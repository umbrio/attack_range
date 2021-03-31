

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "splunk-server" {
  ami                    = data.aws_ami.latest-ubuntu.id
  instance_type          = var.config.instance_type_ec2
  key_name               = var.config.key_name
  subnet_id              = var.ec2_subnet_id
  vpc_security_group_ids = [var.vpc_security_group_ids]
  private_ip             = var.config.splunk_server_private_ip
  depends_on             = [var.phantom_server_instance]
  root_block_device {
    volume_type = "gp2"
    volume_size = "60"
    delete_on_termination = "true"
  }
  tags = {
    Name = "ar-splunk-${var.config.range_name}-${var.config.key_name}"
  }

  provisioner "remote-exec" {
    inline = ["echo booted"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.splunk-server.public_ip
      private_key = file(var.config.private_key_path)
    }
  }

  provisioner "local-exec" {
    working_dir = "../../ansible"
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ${var.config.private_key_path} -i '${aws_instance.splunk-server.public_ip},' playbooks/splunk_server.yml -e 'ansible_python_interpreter=/usr/bin/python3 splunk_admin_password=${var.config.attack_range_password} splunk_url=${var.config.splunk_url} splunk_binary=${var.config.splunk_binary} umbrio_s3_bucket_url=${var.config.umbrio_s3_bucket_url} s3_bucket_url=${var.config.s3_bucket_url} cim_vladiator=${var.config.cim_vladiator} amazon_guardduty_ta =${var.config.amazon_guardduty_ta} cisco_anyconnect_ta =${var.config.cisco_anyconnect_ta} code24_ta =${var.config.code24_ta} decrypy_ta =${var.config.decrypy_ta} ms_azure_ta =${var.config.ms_azure_ta} osquery_ta =${var.config.osquery_ta} splunk_cisco_ta =${var.config.splunk_cisco_ta} splunk_ms_cloud_ta =${var.config.splunk_ms_cloud_ta} splunk_symantec_ep_ta =${var.config.splunk_symantec_ep_ta} splunk_tenable_ta =${var.config.splunk_tenable_ta} url_toolbox =${var.config.url_toolbox} virustotal_workflow_ta =${var.config.virustotal_workflow_ta} splunk_escu_app=${var.config.splunk_escu_app} splunk_asx_app=${var.config.splunk_asx_app} splunk_windows_ta=${var.config.splunk_windows_ta} splunk_aws_ta=${var.config.splunk_aws_ta} splunk_cim_app=${var.config.splunk_cim_app} splunk_sysmon_ta=${var.config.splunk_sysmon_ta} splunk_python_app=${var.config.splunk_python_app} splunk_mltk_app=${var.config.splunk_mltk_app} caldera_password=${var.config.attack_range_password} install_es=${var.config.install_es} splunk_es_app=${var.config.splunk_es_app} phantom_app=${var.config.phantom_app} phantom_server=${var.config.phantom_server} phantom_server_private_ip=${var.config.phantom_server_private_ip} phantom_admin_password=${var.config.attack_range_password} splunk_security_essentials_app=${var.config.splunk_security_essentials_app} splunk_bots_dataset=${var.config.splunk_bots_dataset} punchard_custom_visualization=${var.config.punchard_custom_visualization} status_indicator_custom_visualization=${var.config.status_indicator_custom_visualization} splunk_attack_range_dashboard=${var.config.splunk_attack_range_dashboard} timeline_custom_visualization=${var.config.timeline_custom_visualization} splunk_stream_app=${var.config.splunk_stream_app} splunk_ta_wire_data=${var.config.splunk_ta_wire_data} splunk_ta_stream=${var.config.splunk_ta_stream} splunk_zeek_ta=${var.config.splunk_zeek_ta} splunk_server_private_ip=${var.config.splunk_server_private_ip} splunk_office_365_ta=${var.config.splunk_office_365_ta} splunk_kinesis_ta=${var.config.splunk_kinesis_ta} splunk_linux_ta=${var.config.splunk_linux_ta} splunk_es_app_version=${var.config.splunk_es_app_version}'"

  }
}

resource "aws_eip" "splunk_ip" {
  instance = aws_instance.splunk-server.id
}

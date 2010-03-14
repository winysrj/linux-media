Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-vancouver.gigahost.dk ([209.17.186.58]:46571 "EHLO
	mailout-vancouver.gigahost.dk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab0CNPKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 11:10:18 -0400
Received: from mailout.gigahost.dk (mailout.gigahost.dk [217.116.232.226])
	by mailout-vancouver.gigahost.dk (Postfix) with ESMTP id 49FBB14A88FB
	for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 14:59:59 +0000 (UTC)
Received: from mail.gigahost.dk (mail.gigahost.dk [217.116.232.246])
	by mailout.gigahost.dk (Postfix) with ESMTPS id 888081D70434
	for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 15:59:58 +0100 (CET)
Received: from nigiri.tullinup.dk (0x55517827.adsl.cybercity.dk [85.81.120.39])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.gigahost.dk (Postfix) with ESMTPSA id 706E0A107A9
	for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 15:59:58 +0100 (CET)
Received: from [IPv6:::1] (unknown [IPv6:::1])
	by nigiri.tullinup.dk (Postfix) with ESMTP id 1818DD70
	for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 15:59:58 +0100 (CET)
Subject: Hauppauge MiniStick (Siano 1150-PC) - How to get the IR receiver
 working?
From: Jacob Nielsen <snobel@tullinup.dk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 15:59:57 +0100
Message-ID: <1268578797.2929.37.camel@wasabi>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Hauppauge WinTV MiniStick ("55009 LF Rev A1F7 4609") that I
would like to use with MythTV. I wonder if it is possible to get the IR
receiver working?

Apparently the driver looks for IR functionality but does not find it,
judging from the syslog message "IR port has not been detected". (Syslog
and other info below.)

A newer kernel (2.6.33) did not help. Also tried in vain all the
firmware versions I could find:

- sms1xxx-hcw-55xxx-dvbt-0{1,2,3}.fw from
http://steventoth.net/linux/sms1xxx/
- dvb_nova_12mhz_b0.inp from Siano's FTP site
- hcw17dvb.1b0 from Hauppauge's Windows driver archive

Any ideas would be appreciated.

Regards,
Jacob Nielsen
________________________________


$ uname -r
2.6.33-020633-generic

$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 9.10
Release:	9.10
Codename:	karmic

$ cat /etc/modprobe.d/siano.conf 
options smsmdtv debug=3 cards_dbg=3
options smsdvb debug=3
options smsusb debug=3

$ tail -f /var/log/syslog
[insert]
Mar 13 13:17:30 wasabi kernel: [ 1061.936039] usb 1-4: new high speed
USB device using ehci_hcd and address 7
Mar 13 13:17:30 wasabi kernel: [ 1062.070720] smsusb_probe: smsusb_probe
0
Mar 13 13:17:30 wasabi kernel: [ 1062.070728] smsusb_probe: endpoint 0
81 02 512
Mar 13 13:17:30 wasabi kernel: [ 1062.070733] smsusb_probe: endpoint 1
02 02 512
Mar 13 13:17:30 wasabi kernel: [ 1062.072075] smscore_register_device:
allocated 50 buffers
Mar 13 13:17:30 wasabi kernel: [ 1062.072083] smscore_register_device:
device f39b9800 created
Mar 13 13:17:30 wasabi kernel: [ 1062.072091] smsusb_init_device:
smsusb_start_streaming(...).
Mar 13 13:17:30 wasabi kernel: [ 1062.072127] smscore_set_device_mode:
set device mode to 4
Mar 13 13:17:30 wasabi kernel: [ 1062.072673] smscore_onresponse: 
Mar 13 13:17:30 wasabi kernel: [ 1062.072675] data rate 10 bytes/secs
Mar 13 13:17:30 wasabi kernel: [ 1062.072681] smscore_onresponse:
MSG_SMS_GET_VERSION_EX_RES id 255 prots 0x0 ver 2.1
Mar 13 13:17:30 wasabi kernel: [ 1062.072951] usb 1-4: firmware:
requesting sms1xxx-hcw-55xxx-dvbt-02.fw
Mar 13 13:17:30 wasabi kernel: [ 1062.084073]
smscore_load_firmware_from_file: read FW sms1xxx-hcw-55xxx-dvbt-02.fw,
size=93292
Mar 13 13:17:30 wasabi kernel: [ 1062.084209]
smscore_load_firmware_family2: loading FW to addr 0x40260 size 93280
Mar 13 13:17:30 wasabi kernel: [ 1062.151531] smscore_onresponse:
MSG_SMS_SWDOWNLOAD_TRIGGER_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.652040]
smscore_load_firmware_family2: rc=0, postload=(null) 
Mar 13 13:17:31 wasabi kernel: [ 1062.652070] smscore_set_device_mode:
firmware download success: sms1xxx-hcw-55xxx-dvbt-02.fw
Mar 13 13:17:31 wasabi kernel: [ 1062.652481] smscore_onresponse:
MSG_SMS_INIT_DEVICE_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.652507] DVB: registering new
adapter (Hauppauge WinTV MiniStick)
Mar 13 13:17:31 wasabi kernel: [ 1062.652758] DVB: registering adapter 0
frontend 0 (Siano Mobile Digital MDTV Receiver)...
Mar 13 13:17:31 wasabi kernel: [ 1062.652811] smscore_register_client:
f59fe000 693 1
Mar 13 13:17:31 wasabi kernel: [ 1062.652817] sms_board_dvb3_event:
DVB3_EVENT_HOTPLUG
Mar 13 13:17:31 wasabi kernel: [ 1062.652821] smsdvb_hotplug: success
Mar 13 13:17:31 wasabi kernel: [ 1062.652986] smscore_onresponse:
MSG_SMS_GPIO_CONFIG_EX_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.653107] smscore_onresponse:
MSG_SMS_GPIO_SET_LEVEL_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.653232] smscore_onresponse:
MSG_SMS_GPIO_CONFIG_EX_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.653356] smscore_onresponse:
MSG_SMS_GPIO_SET_LEVEL_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.653481] smscore_onresponse:
MSG_SMS_GPIO_CONFIG_EX_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.653606] smscore_onresponse:
MSG_SMS_GPIO_SET_LEVEL_RES
Mar 13 13:17:31 wasabi kernel: [ 1062.653613] smscore_init_ir: IR port
has not been detected
Mar 13 13:17:31 wasabi kernel: [ 1062.653619] smscore_start_device:
device f39b9800 started, rc 0
Mar 13 13:17:31 wasabi kernel: [ 1062.653624] smsusb_init_device: device
f5a4a000 created
Mar 13 13:17:31 wasabi kernel: [ 1062.653628] smsusb_probe: rc 0
[remove]
Mar 13 13:18:01 wasabi kernel: [ 1092.266210] usb 1-4: USB disconnect,
address 7
Mar 13 13:18:01 wasabi kernel: [ 1092.266286] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266298] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266306] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266313] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266320] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266326] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266333] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266340] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266346] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266353] smsusb_onresponse: line:
70: error, urb status -108 (-ESHUTDOWN), 0 bytes
Mar 13 13:18:01 wasabi kernel: [ 1092.266447] sms_ir_exit: 
Mar 13 13:18:01 wasabi kernel: [ 1092.266454] smscore_unregister_client:
f59fe000
Mar 13 13:18:01 wasabi kernel: [ 1092.266667] smscore_unregister_device:
freed 50 buffers
Mar 13 13:18:01 wasabi kernel: [ 1092.266683] smscore_unregister_device:
device f39b9800 destroyed
Mar 13 13:18:01 wasabi kernel: [ 1092.266688] smsusb_term_device: device
f5a4a000 destroyed

$ lsmod | grep sms
smsdvb                  7427  0 
dvb_core               86411  1 smsdvb
smsusb                  7748  0 
smsmdtv                28192  2 smsdvb,smsusb

$ ls -l /lib/firmware/sms1xxx-hcw-55xxx-dvbt-02.fw 
lrwxrwxrwx 1 root root 48 2010-03-13
13:14 /lib/firmware/sms1xxx-hcw-55xxx-dvbt-02.fw
-> /lib/firmware/siano/sms1xxx-hcw-55xxx-dvbt-03.fw

$ lsusb | grep -i hauppauge
Bus 001 Device 005: ID 2040:5500 Hauppauge 



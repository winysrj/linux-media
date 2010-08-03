Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.pcl-ipout02.plus.net ([212.159.7.100]:32270 "EHLO
	relay.pcl-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755893Ab0HCLVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Aug 2010 07:21:09 -0400
Received: from 196.251.adsl.brightview.com ([80.189.251.196] helo=[192.168.1.32])
	by pih-smtp-proxy02.plus.net with esmtp (Exim 4.63)
	(envelope-from <zpqz79@tesco.net>)
	id 1OgFYR-00073E-FW
	for linux-media@vger.kernel.org; Tue, 03 Aug 2010 12:21:07 +0100
Subject: kernel NULL pointer reference problem when running scandvb, device
 Leadtek WinFast DTV Dongle (0x0413:0x6f00), kernel 2.6.33.6-147.fc13.x86_64
From: Graham C <zpqz79@tesco.net>
To: 'Linux Media Mailing List' <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 12:21:07 +0100
Message-ID: <1280834467.2928.8.camel@Am2>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am getting a kernel NULL pointer reference in a dvb_core module.

I am using v4l-dbv code cloned from http://linuxtv.org/hg/v4l-dvb using
mercurial today.

/sys/module/dvb_usb/srcversion contains 09654C413A19358611A87AD

The v4l-dvb code compiled without any errors.

My setup is:
Architecture: x86_64 (running on an AMD 64 X2 5200+ with 5GB ram)
Kernel:       2.6.33.6-147.fc13.x86_64
Release:      Fedora release 13 (Goddard)

My device is:
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6f00 WinFast DTV Dongle (STK7700P based)

The firmware file is that supplied with the Fedora distribution
	dvb-usb-dib0700-1.20.fw
This matches the version on:
http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw

The output from scandvb when this happens is:

scanning /usr/share/dvb-apps/dvb-t/uk-xxx
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 650200000 0 2 9 3 1 0 0
initial transponder 674200000 0 2 9 3 1 0 0
initial transponder 641800000 0 2 9 3 1 0 0
initial transponder 665800000 0 2 9 3 1 0 0
initial transponder 697800000 0 2 9 3 1 0 0
>>> tune to:
650200000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

Message from syslogd@Am2 at Aug  3 01:01:10 ...
 kernel:Oops: 0000 [#1] SMP 

Message from syslogd@Am2 at Aug  3 01:01:10 ...
 kernel:last sysfs file: /sys/module/dvb_usb/initstate

Message from syslogd@Am2 at Aug  3 01:01:10 ...
 kernel:Stack:

Message from syslogd@Am2 at Aug  3 01:01:10 ...
 kernel:Call Trace:

Message from syslogd@Am2 at Aug  3 01:01:10 ...
 kernel:Code: 89 55 f8 48 c7 c2 4b 01 00 a0 e8 af 9b 2a e1 c9 c3 55 48
89 e5 41 57 41 89 d7 41 56 49 89 f6 41 55 41 54 53 48 89 fb 48 83 ec 18
<48> 8b 47 10 48 83 38 00 0f 84 8f 00 00 00 65 48 8b 04 25 08 cc 

Message from syslogd@Am2 at Aug  3 01:01:10 ...
 kernel:CR2: 0000000000000012


Here is the back trace:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000012
IP: [<ffffffffa00004fd>] i2c_transfer+0x1a/0x109 [i2c_core]
PGD 1486e2067 PUD 148714067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/module/dvb_usb/initstate
CPU 1 
Pid: 2559, comm: scandvb Not tainted 2.6.33.6-147.fc13.x86_64 #1
PE-AM2RS690MH/Unknow
RIP: 0010:[<ffffffffa00004fd>]  [<ffffffffa00004fd>] i2c_transfer
+0x1a/0x109 [i2c_core]
RSP: 0018:ffff880148763b48  EFLAGS: 00010296
RAX: ffff880148763bb8 RBX: 0000000000000002 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffff880148763b98 RDI: 0000000000000002
RBP: ffff880148763b88 R08: ffff88002b881d60 R09: 0000000050000d80
R10: 0000000000000005 R11: 0000000000004a38 R12: 0000000000000000
R13: 0000000000000001 R14: ffff880148763b98 R15: 0000000000000002
FS:  00007f6a4e2e5700(0000) GS:ffff880006900000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000012 CR3: 0000000148614000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scandvb (pid: 2559, threadinfo ffff880148762000, task
ffff88014dc40000)
Stack:
ffff88014ecd1100 ffffc90000003000 ffff880148763b78 00000000000000eb
 0000000000000000 0000000000000001 0000000000000001 0000000000000000
 ffff880148763be8 ffffffffa023110d 0000000200000010 ffff880148763bc8
Call Trace:
[<ffffffffa023110d>] dib7000p_read_word+0x68/0xb7 [dib7000p]
[<ffffffff81305f99>] ? usb_submit_urb+0x26a/0x2e7
[<ffffffffa0231d7c>] dib7000p_pid_filter_ctrl+0x28/0x8a [dib7000p]
[<ffffffffa02867c9>] stk70x0p_pid_filter_ctrl+0x14/0x17
[dvb_usb_dib0700]
[<ffffffffa019e447>] dvb_usb_ctrl_feed+0x172/0x1d2 [dvb_usb]
[<ffffffffa019e522>] dvb_usb_start_feed+0x3d/0x43 [dvb_usb]
[<ffffffffa01461cd>] dmx_section_feed_start_filtering+0xfc/0x150
[dvb_core]
[<ffffffffa0144b11>] dvb_dmxdev_filter_start+0x236/0x310 [dvb_core]
[<ffffffffa01452bf>] dvb_demux_do_ioctl+0x1bf/0x48c [dvb_core]
[<ffffffffa0145100>] ? dvb_demux_do_ioctl+0x0/0x48c [dvb_core]
[<ffffffffa0143425>] dvb_usercopy+0xd2/0x160 [dvb_core]
[<ffffffffa0144049>] dvb_demux_ioctl+0x10/0x12 [dvb_core]
[<ffffffff8110d917>] vfs_ioctl+0x75/0xa1
[<ffffffff8110de38>] do_vfs_ioctl+0x47e/0x4c4
[<ffffffff810f3328>] ? virt_to_head_page+0x9/0x2a
[<ffffffff8110decf>] sys_ioctl+0x51/0x74
[<ffffffff81009b02>] system_call_fastpath+0x16/0x1b
Code: 89 55 f8 48 c7 c2 4b 01 00 a0 e8 af 9b 2a e1 c9 c3 55 48 89 e5 41
57 41 89 d7 41 56 49 89 f6 41 55 41 54 53 48 89 fb 48 83 ec 18 <48> 8b
47 10 48 83 38 00 0f 84 8f 00 00 00 65 48 8b 04 25 08 cc 
RIP  [<ffffffffa00004fd>] i2c_transfer+0x1a/0x109 [i2c_core]
RSP <ffff880148763b48>
CR2: 0000000000000012


This is the output from lsusb -v -s 1:2:

Bus 001 Device 002: ID 0413:6f00 Leadtek Research, Inc. WinFast DTV
Dongle (STK7700P based)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0413 Leadtek Research, Inc.
  idProduct          0x6f00 WinFast DTV Dongle (STK7700P based)
  bcdDevice            1.00
  iManufacturer           1 DIBCOM
  iProduct                2 STK7700
  iSerial                 3 0000000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

These are the relevant lines from dmesg:

dvb-usb: Leadtek Winfast DTV Dongle (STK7700P based) successfully
initialized and connected.
dib0700: rc submit urb failed

I am not a kernel module programmer. If there are other logs or traces I
should submit please advise.

Graham C



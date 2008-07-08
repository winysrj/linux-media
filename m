Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.ispdone.com ([69.39.47.46] helo=smtp-auth0.ispdone.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <purevw@wtxs.net>) id 1KGHzg-00052f-Gj
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 20:32:55 +0200
Received: from [192.168.123.110] (net-69-39-58-36.texascom.net [69.39.58.36]
	(may be forged)) (authenticated bits=0)
	by smtp-auth0.ispdone.com (8.13.1/8.13.1) with ESMTP id m68NWboK023015
	for <linux-dvb@linuxtv.org>; Tue, 8 Jul 2008 18:32:44 -0500
From: Ronnie Bailey <purevw@wtxs.net>
To: linux-dvb@linuxtv.org
Date: Tue, 08 Jul 2008 13:32:37 -0500
Message-Id: <1215541957.4797.21.camel@Opto.Bailey>
Mime-Version: 1.0
Subject: [linux-dvb] Problems with ATI USB Hybrid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1764379794=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1764379794==
Content-Type: multipart/alternative; boundary="=-uSSfUC9nm54Onf5w2XQF"


--=-uSSfUC9nm54Onf5w2XQF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi All,
    I am trying to install an ATI TV Wonder HD 600 USB card and not
having any luck. No matter what I try, there is no /dev/video  and also
no /dev/dvb.  The module seems to load OK, but the card is not found.
Yast sees the card, but only identifies it as a USB device and not a TV
card. I'll include what info I have. I would appreciate any help
offered. I am trying my best to eliminate Microsoft from my systems.
This driver problem is one of the last major headaches. I'm not sure if
this matters, but I need to set it up as NTSC-M with us cable. Channel 3
will be the only channel used.

Yast Hardware information states:

  102: udi =
'/org/freedesktop/Hal/devices/usb_device_438_b002_660729005035'
  info.subsystem = 'usb_device'
  usb_device.vendor = 'Advanced Micro Devices, Inc.'
  usb_device.bus_number = 2 (0x2)
  linux.subsystem = 'usb'
  info.linux.driver = 'usb'
  usb_device.product = 'ATI TV Wonder 600 USB 2.0'
  info.product = 'ATI TV Wonder 600 USB 2.0'
  linux.device_file = '/dev/bus/usb/002/008'
  usb_device.linux.sysfs_path =
'/sys/devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1.7'
  usb_device.device_revision_bcd = 272 (0x110)
  info.udi =
'/org/freedesktop/Hal/devices/usb_device_438_b002_660729005035'
  usb_device.configuration_value = 1 (0x1)
  usb_device.max_power = 500 (0x1f4)
  usb_device.num_configurations = 1 (0x1)
  usb_device.num_ports = 0 (0x0)
  usb_device.num_interfaces = 1 (0x1)
  usb_device.linux.device_number = 8 (0x8)
  usb_device.device_class = 0 (0x0)
  usb_device.serial = '660729005035'
  linux.sysfs_path =
'/sys/devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1.7'
  usb_device.device_subclass = 0 (0x0)
  info.vendor = 'Advanced Micro Devices, Inc.'
  usb_device.speed = 480.000
  info.parent =
'/org/freedesktop/Hal/devices/usb_device_50d_237_noserial'
  usb_device.device_protocol = 0 (0x0)
  usb_device.version = 2.00000
  usb_device.vendor_id = 1080 (0x438)
  usb_device.is_self_powered = false
  usb_device.product_id = 45058 (0xb002)
  usb_device.can_wake_up = false
  linux.hotplug_type = 2 (0x2)

Pertinent lsmod info:

Module                Size            Used By
em28xx_dvb           26884          0
dvb_core              109348          1 em28xx_dvb
em28xx                   81836          1 em28xx_dvb
compat_ioctl32        25856          1 em28xx
videodev                  55040          2 em28xx,compat_ioctl32
v4l1_compat            31620          1 videodev
videobuf_vmalloc       25476          1 em28xx
videobuf_core          38788          2 em28xx,videobuf_vmalloc
ir_common              60932          2 ir_kbd_i2c,em28xx
v4l2_common            29824          1 em28xx
tveeprom               30724              1 em28xx

lsusb gives me this:

Bus 002 Device 008: ID 0438:b002 Advanced Micro Devices, Inc.

dmesg shows:

fuse init (API version 7.9)
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
usbcore: registered new interface driver em28xx
Em28xx: Initialized (Em28xx dvb Extension) extension

Xine posted a couple of warning messages:

Jul 8 12:26:44 Opto xinetd[3495]: No such internal service: chargen/raw
- DISABLING

Jul 8 12:26:45 Opto xinetd[3495]: Port not specified and can't find
service: netstat with getservbyname

Jul 8 12:26:45 Opto xinetd[3495]: No such internal service:
servers/stream - DISABLING

Jul 8 12:26:45 Opto xinetd[3495]: No such internal service:
services/stream - DISABLING

When I open Xine and try to connect to DVB. it simply states:

Input plugin failed to open mrl 'Sorry, No DVB input device found

Thanks in advance,
Ronnie Bailey

--=-uSSfUC9nm54Onf5w2XQF
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.18.1">
</HEAD>
<BODY>
Hi All,<BR>
&nbsp;&nbsp;&nbsp; I am trying to install an ATI TV Wonder HD 600 USB card and not having any luck. No matter what I try, there is no /dev/video&nbsp; and also no /dev/dvb.&nbsp; The module seems to load OK, but the card is not found. Yast sees the card, but only identifies it as a USB device and not a TV card. I'll include what info I have. I would appreciate any help offered. I am trying my best to eliminate Microsoft from my systems. This driver problem is one of the last major headaches. I'm not sure if this matters, but I need to set it up as NTSC-M with us cable. Channel 3 will be the only channel used.<BR>
<BR>
<B>Yast Hardware information states:</B><BR>
<BR>
&nbsp; 102: udi = '/org/freedesktop/Hal/devices/usb_device_438_b002_660729005035'<BR>
&nbsp; info.subsystem = 'usb_device'<BR>
&nbsp; usb_device.vendor = 'Advanced Micro Devices, Inc.'<BR>
&nbsp; usb_device.bus_number = 2 (0x2)<BR>
&nbsp; linux.subsystem = 'usb'<BR>
&nbsp; info.linux.driver = 'usb'<BR>
&nbsp; usb_device.product = 'ATI TV Wonder 600 USB 2.0'<BR>
&nbsp; info.product = 'ATI TV Wonder 600 USB 2.0'<BR>
&nbsp; linux.device_file = '/dev/bus/usb/002/008'<BR>
&nbsp; usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1.7'<BR>
&nbsp; usb_device.device_revision_bcd = 272 (0x110)<BR>
&nbsp; info.udi = '/org/freedesktop/Hal/devices/usb_device_438_b002_660729005035'<BR>
&nbsp; usb_device.configuration_value = 1 (0x1)<BR>
&nbsp; usb_device.max_power = 500 (0x1f4)<BR>
&nbsp; usb_device.num_configurations = 1 (0x1)<BR>
&nbsp; usb_device.num_ports = 0 (0x0)<BR>
&nbsp; usb_device.num_interfaces = 1 (0x1)<BR>
&nbsp; usb_device.linux.device_number = 8 (0x8)<BR>
&nbsp; usb_device.device_class = 0 (0x0)<BR>
&nbsp; usb_device.serial = '660729005035'<BR>
&nbsp; linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1.7'<BR>
&nbsp; usb_device.device_subclass = 0 (0x0)<BR>
&nbsp; info.vendor = 'Advanced Micro Devices, Inc.'<BR>
&nbsp; usb_device.speed = 480.000<BR>
&nbsp; info.parent = '/org/freedesktop/Hal/devices/usb_device_50d_237_noserial'<BR>
&nbsp; usb_device.device_protocol = 0 (0x0)<BR>
&nbsp; usb_device.version = 2.00000<BR>
&nbsp; usb_device.vendor_id = 1080 (0x438)<BR>
&nbsp; usb_device.is_self_powered = false<BR>
&nbsp; usb_device.product_id = 45058 (0xb002)<BR>
&nbsp; usb_device.can_wake_up = false<BR>
&nbsp; linux.hotplug_type = 2 (0x2)<BR>
<BR>
<B>Pertinent lsmod info:</B><BR>
<BR>
<B>Module&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Used By</B><BR>
em28xx_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 26884&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<BR>
dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 109348&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 em28xx_dvb<BR>
em28xx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 81836&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 em28xx_dvb<BR>
compat_ioctl32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25856&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 em28xx<BR>
videodev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 55040&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 em28xx,compat_ioctl32<BR>
v4l1_compat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31620&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 videodev<BR>
videobuf_vmalloc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25476&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 em28xx<BR>
videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 38788&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 em28xx,videobuf_vmalloc<BR>
ir_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60932&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 ir_kbd_i2c,em28xx<BR>
v4l2_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29824&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 em28xx<BR>
tveeprom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30724&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 em28xx<BR>
<BR>
<B>lsusb gives me this:</B><BR>
<BR>
Bus 002 Device 008: ID 0438:b002 Advanced Micro Devices, Inc.<BR>
<BR>
<B>dmesg shows:</B><BR>
<BR>
fuse init (API version 7.9)<BR>
Linux video capture interface: v2.00<BR>
em28xx v4l2 driver version 0.1.0 loaded<BR>
usbcore: registered new interface driver em28xx<BR>
Em28xx: Initialized (Em28xx dvb Extension) extension<BR>
<BR>
<B>Xine posted a couple of warning messages:</B><BR>
<BR>
Jul 8 12:26:44 Opto xinetd[3495]: No such internal service: chargen/raw - DISABLING<BR>
<BR>
Jul 8 12:26:45 Opto xinetd[3495]: Port not specified and can't find service: netstat with getservbyname<BR>
<BR>
Jul 8 12:26:45 Opto xinetd[3495]: No such internal service: servers/stream - DISABLING<BR>
<BR>
Jul 8 12:26:45 Opto xinetd[3495]: No such internal service: services/stream - DISABLING<BR>
<BR>
<B>When I open Xine and try to connect to DVB. it simply states:</B><BR>
<BR>
Input plugin failed to open mrl 'Sorry, No DVB input device found<BR>
<BR>
Thanks in advance,<BR>
Ronnie Bailey
</BODY>
</HTML>

--=-uSSfUC9nm54Onf5w2XQF--



--===============1764379794==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1764379794==--

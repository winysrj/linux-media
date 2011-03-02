Return-path: <mchehab@pedra>
Received: from mx4.wp.pl ([212.77.101.8]:39113 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1CBP5K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 10:57:10 -0500
Received: from dnx210.neoplus.adsl.tpnet.pl (HELO [192.168.2.5]) (laurentp@[83.24.105.210])
          (envelope-sender <laurentp@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 2 Mar 2011 16:57:07 +0100
Message-ID: <4D6E68D1.6050209@wp.pl>
Date: Wed, 02 Mar 2011 16:57:05 +0100
From: "W.P." <laurentp@wp.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Big ptoblem with small webcam
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi there,
I just got an Creative VGA (640x480) USB Live Webcam, VF0520.

lsusb (partial):

Bus 003 Device 007: ID 041e:406c Creative Technology, Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x041e Creative Technology, Ltd
  idProduct          0x406c
  bcdDevice           10.19
  iManufacturer           1 Creative Labs
  iProduct                3 VF0520 Live! Cam Sync
  iSerial                 0
  bNumConfigurations      1

lsmod | grep vid:
uvcvideo               50184  0
compat_ioctl32          5120  1 uvcvideo
videodev               32000  1 uvcvideo
v4l1_compat            15876  2 uvcvideo,videodev

uname -a (kernel from Fedora 10):
[root@laurent-home ~]# uname -a
Linux laurent-home 2.6.27.5-117.fc10.i686 #1 SMP Tue Nov 18 12:19:59 EST
2008 i686 athlon i386 GNU/Linux

Problem: device nodes are created, but NO video in gmplayer, tvtime
complains: can't open /dev/video0.

Only trace in syslog is:

Mar  2 16:26:56 laurent-home kernel: uvcvideo: Failed to submit URB 0 (-28).

Webcam is connected to VIA USB 2.0 controller through a USB 2.0 hub.

What is strange, two days ago I tried apparently the same (model VFxxxx)
with SUCCESS.
Device seems working in Windoze (Ekiga).

What should I check/ do?

W.P.


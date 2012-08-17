Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:36933 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753157Ab2HQTek (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 15:34:40 -0400
Received: from [176.74.212.201] (account mc467741@c2i.net HELO laptop015.hselasky.homeunix.org)
  by mailfe05.swip.net (CommuniGate Pro SMTP 5.4.4)
  with ESMTPA id 305466997 for linux-media@vger.kernel.org; Fri, 17 Aug 2012 21:34:36 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Strong pairing cam doesn't work with CT-3650 driver (ttusb2)
Date: Fri, 17 Aug 2012 21:35:17 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208172135.17623.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Have anyone out there tested the CT-3650 USB driver in the Linux kernel with a 
"strong pairing cam".

According to some web-forums, the hardware should support that given using the 
vendor provided DVB WinXXX software.

drivers/media/dvb/dvb-usb/ttusb2.c

Any clues how to debug or what can be wrong?

When inserting the CAM, VDR says that a CAM is present, but then after a while 
no CAM is present.

Log:

ttusb2: tt3650_ci_slot_reset 0
ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x00
ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x00
TUPLE type:0x0 length:0
dvb_ca adapter 0: Invalid PC card inserted :(
dvb_ca_en50221_io_open
dvb_ca_en50221_thread_wakeup
dvb_ca_en50221_io_do_ioctl
dvb_ca_en50221_io_do_ioctl
dvb_ca_en50221_slot_shutdown
ttusb2: tt3650_ci_set_video_port 0 0
Slot 0 shutdown
dvb_ca_en50221_thread_wakeup
dvb_ca_en50221_io_poll
ttusb2: tt3650_ci_slot_reset 0
dvb_ca_en50221_io_do_ioctl
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
dvb_ca_en50221_io_poll
ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x1d
ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x04
TUPLE type:0x1d length:4
ttusb2: tt3650_ci_read_attribute_mem 0004 -> 0 0x00
  0x00: 0x00 .
ttusb2: tt3650_ci_read_attribute_mem 0006 -> 0 0xdb
  0x01: 0xdb .
ttusb2: tt3650_ci_read_attribute_mem 0008 -> 0 0x08
  0x02: 0x08 .
ttusb2: tt3650_ci_read_attribute_mem 000a -> 0 0xff
  0x03: 0xff .
dvb_ca adapter 0: Invalid PC card inserted :(
dvb_ca_en50221_io_do_ioctl

--HPS

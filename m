Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I2ZtjR030597
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 22:35:55 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6I2Ziqt031433
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 22:35:44 -0400
From: Andy Walls <awalls@radix.net>
To: ivtv-devel@ivtvdriver.org, video4linux-list@redhat.com
Content-Type: text/plain
Date: Thu, 17 Jul 2008 22:30:30 -0400
Message-Id: <1216348230.2942.31.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: videodev related (?) modprobe hang with latest v4l-dvb
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

With a repo I have that I just merged from v4l-dvb, I get a modprobe
ivtv to hang on my 64 bit machine.

$ uname -a
Linux morgan.walls.org 2.6.25-14.fc9.x86_64 #1 SMP Thu May 1 06:06:21
EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

Here's the dmesg.  The last few lines show videodev errors:

-Andy

ivtv:  Start initialization, version 1.3.0
ivtv0: Initializing card #0
ivtv0: Autodetected Hauppauge card (cx23416 based)
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 20 (level, low) -> IRQ 20
tveeprom 0-0050: Hauppauge model 26552, rev B268, serial# 8768144
tveeprom 0-0050: tuner model is LG TAPE H001F MK3 (idx 68, type 47)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is CX25843 (idx 37)
tveeprom 0-0050: decoder processor is CX25843 (idx 30)
tveeprom 0-0050: has radio, has no IR receiver, has no IR transmitter
ivtv0: Autodetected Hauppauge WinTV PVR-150
cx25840 0-0044: cx25843-23 found @ 0x88 (ivtv i2c driver #0)
tuner 0-0043: chip found @ 0x86 (ivtv i2c driver #0)
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
wm8775 0-001b: chip found @ 0x36 (ivtv i2c driver #0)
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 47 (LG NTSC (TAPE series))
cx25840 0-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
videodev: get_index num is too large
video_register_device_index: get_index failed



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

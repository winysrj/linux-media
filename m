Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9P1jWDE012002
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 21:45:32 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9P1jIdj005682
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 21:45:18 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1165846fga.7
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 18:45:18 -0700 (PDT)
Message-ID: <7ea0a1e10810241845m7db56151vbf3f42f16c2385f3@mail.gmail.com>
Date: Fri, 24 Oct 2008 19:45:18 -0600
From: "Corey Klaasmeyer" <corey.klaasmeyer@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Hauppauge 1800 HVR Problem
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

I have a Hauppauge 1800 HVR installed on a Gentoo 2.6.25 r8 kernel and
analog cable. After installed ivtv, the drivers and v4l pulled from
the head on the card is recognized, all drivers seem to be properly
loaded, and all devices are available. However when I try to generate
MPG from /dev/video0, the MPG files is not playable. How can I
troubleshoot this problem?

dmesg:

Linux video capture interface: v2.00
cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800
[card=2,autodetected]
tveeprom 0-0050: Hauppauge model 78521, rev C1E9, serial# 2968591
tveeprom 0-0050: MAC address is 00-0D-FE-2D-4C-0F
tveeprom 0-0050: tuner model is Philips 18271_8295 (idx 149, type 54)
tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 0-0050: audio processor is CX23887 (idx 42)
tveeprom 0-0050: decoder processor is CX23887 (idx 37)
tveeprom 0-0050: has radio
cx23885[0]: hauppauge eeprom: model=78521
cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx23885[0]/0: registered device video0 [v4l2]
cx25840' 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885[0]: registered device video1 [mpeg]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xb1
cx23885[0]/0: found at 0000:03:00.0, rev: 15, irq: 16, latency: 0,
mmio: 0xfc000000
PCI: Setting latency timer of device 0000:03:00.0 to 64

.config (cat /usr/src/linux/.config | egrep VIDEO.*=[ym])
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_TUNER_CUSTOMIZE=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_SELECT=y

ivtv packages
*  media-tv/ivtv
      Latest version available: 1.2.0-r1
      Latest version installed: 1.2.0-r1
      Size of files: 470 kB
      Homepage:      http://www.ivtvdriver.org
      Description:   ivtv driver for Hauppauge PVR PCI cards
      License:       GPL-2

*  media-tv/ivtv-firmware
      Latest version available: 20070217
      Latest version installed: 20070217
      Size of files: 121 kB
      Homepage:      http://www.ivtvdriver.org/index.php/Firmware
      Description:   firmware for Hauppauge PVR-x50 and Conexant 2341x
based cards
      License:       Hauppauge-Firmware

v4l-dvb tip:9349:931fa560184d

Corey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

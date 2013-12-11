Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52879 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab3LKXyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 18:54:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 0/4] SDR API set ADC and RF frequency
Date: Thu, 12 Dec 2013 01:53:59 +0200
Message-Id: <1386806043-5331-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is small example what it looks like when v4l2-ctl is used.

[crope@localhost v4l2-ctl]$ 
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --all
Driver Info (not using libv4l2):
	Driver name   : rtl2832_sdr
	Card type     : Realtek RTL2832U SDR
	Bus info      : usb-0000:00:13.2-2
	Driver version: 3.13.0
	Capabilities  : 0x85010001
		Video Capture
		Tuner
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05010001
		Video Capture
		Tuner
		Read/Write
		Streaming
Priority: 2
Frequency for tuner 0: 0 (0.000000 MHz)
Tuner 0:
	Name                 : ADC
	Capabilities         : 1 Hz freq-bands 
	Frequency range      : 0.300000 MHz - 3.200000 MHz
Video input : 0 (SDR data: ok)

User Controls
                     tuner_gain (int)    : min=0 max=102 step=1 default=0 value=0
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=1 --all
Driver Info (not using libv4l2):
	Driver name   : rtl2832_sdr
	Card type     : Realtek RTL2832U SDR
	Bus info      : usb-0000:00:13.2-2
	Driver version: 3.13.0
	Capabilities  : 0x85010001
		Video Capture
		Tuner
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05010001
		Video Capture
		Tuner
		Read/Write
		Streaming
Priority: 2
Frequency for tuner 1: 0 (0.000000 MHz)
Tuner 1:
	Name                 : RF
	Capabilities         : 62.5 Hz freq-bands 
	Frequency range      : 50.000 MHz - 1500.000 MHz
Video input : 0 (SDR data: ok)

User Controls
                     tuner_gain (int)    : min=0 max=102 step=1 default=0 value=0
(reverse-i-search)`en': gedit drivers/media/radio/radio-ke^Ce.c
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=0 --list-freq-bands
ioctl: VIDIOC_ENUM_FREQ_BANDS
	Index          : 0
	Modulation     : Unknown
	Capability     : 1 Hz freq-bands 
	Frequency Range: 0.300000 MHz - 0.300000 MHz

	Index          : 1
	Modulation     : Unknown
	Capability     : 1 Hz freq-bands 
	Frequency Range: 0.900001 MHz - 2.800000 MHz

	Index          : 2
	Modulation     : Unknown
	Capability     : 1 Hz freq-bands 
	Frequency Range: 3.200000 MHz - 3.200000 MHz
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=1 --list-freq-bands
ioctl: VIDIOC_ENUM_FREQ_BANDS
	Index          : 0
	Modulation     : Unknown
	Capability     : 62.5 Hz freq-bands 
	Frequency Range: 50.000 MHz - 1500.000 MHz
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=0 --set-freq=0.300000
Frequency for tuner 0 set to 300000 (0.300000 MHz)
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=0 --get-freq
Frequency for tuner 0: 300000 (0.300000 MHz)
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=1 --set-freq=100
Frequency for tuner 1 set to 1600000 (100.000000 MHz)
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=1 --get-freq
Frequency for tuner 1: 1600000 (100.000000 MHz)
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=1 --all
Driver Info (not using libv4l2):
	Driver name   : rtl2832_sdr
	Card type     : Realtek RTL2832U SDR
	Bus info      : usb-0000:00:13.2-2
	Driver version: 3.13.0
	Capabilities  : 0x85010001
		Video Capture
		Tuner
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05010001
		Video Capture
		Tuner
		Read/Write
		Streaming
Priority: 2
Frequency for tuner 1: 1600000 (100.000000 MHz)
Tuner 1:
	Name                 : RF
	Capabilities         : 62.5 Hz freq-bands 
	Frequency range      : 50.000 MHz - 1500.000 MHz
Video input : 0 (SDR data: ok)

User Controls
                     tuner_gain (int)    : min=0 max=102 step=1 default=0 value=0
[crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/sdr0 --tuner-index=0 --all
Driver Info (not using libv4l2):
	Driver name   : rtl2832_sdr
	Card type     : Realtek RTL2832U SDR
	Bus info      : usb-0000:00:13.2-2
	Driver version: 3.13.0
	Capabilities  : 0x85010001
		Video Capture
		Tuner
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05010001
		Video Capture
		Tuner
		Read/Write
		Streaming
Priority: 2
Frequency for tuner 0: 300000 (0.300000 MHz)
Tuner 0:
	Name                 : ADC
	Capabilities         : 1 Hz freq-bands 
	Frequency range      : 0.300000 MHz - 3.200000 MHz
Video input : 0 (SDR data: ok)

User Controls
                     tuner_gain (int)    : min=0 max=102 step=1 default=0 value=0
[crope@localhost v4l2-ctl]$ 



Antti Palosaari (4):
  v4l2-core: don't clear VIDIOC_G_FREQUENCY tuner type
  v4l2: add new device type for Software Defined Radio
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners

 drivers/media/v4l2-core/v4l2-dev.c   |  5 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c | 40 +++++++++++++++++++++++++-----------
 include/media/v4l2-dev.h             |  3 ++-
 include/uapi/linux/videodev2.h       |  3 +++
 4 files changed, 38 insertions(+), 13 deletions(-)

-- 
1.8.4.2


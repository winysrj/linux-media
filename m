Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62319 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab0D3RPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:15:31 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH 0/3] TI WL1273 FM Radio Driver v2.
Date: Fri, 30 Apr 2010 15:59:45 +0300
Message-Id: <1272632388-16048-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I've implemented most of the changes proposed on the previous review round. 
There are some things to be done in the RDS handling...

I've left the region handling as it was because neither of the chip's
regions cover the complete range. Japan is from 76 - 90MHz and
Europe/US is 87.5 to 108 MHz.

Some of the private IOCTL were not necessary because corresponding standardized
controls already exist. And for setting the audio mode to digital or analog
I created an ALSA control because that's an audio thing anyway. 

A couple of private IOCTLs are still there: 

1. WL1273_CID_FM_REGION for setting the region. This may not be a good
candidate for standardization as the region control shouldn't exist 
in the kernel in general...

2. WL1273_CID_FM_SEEK_SPACING: defines what resolution is used when scanning 
automatically for stations (50KHz, 100KHz or 200KHz). This could be
useful in genaral. Could this be a field in the v4l2_hw_freq_seek struct?

3. WL1273_CID_FM_RDS_CTRL for turning on and off the RDS reception / 
transmission. To me this seems like a useful standard control...

4. WL1273_CID_SEARCH_LVL for setting the threshold level when detecting radio
channels when doing automatic scan. This could be useful for fine tuning
because automatic  scanning seems to be kind of problematic... This could also
be a field in the v4l2_hw_freq_seek struct?

5. WL1273_CID_FM_RADIO_MODE: Now the radio has the following modes: off, 
suspend, rx and tx. It probably would be better to separate the powering 
state (off, on, suspend) from the FM radio state (rx, tx)... 

Could the VIDIOC_S_MODULATOR and VIDIOC_S_TUNER IOCTLs be used for setting the
TX/RX mode?

Now there already exits a class for fm transmitters: V4L2_CTRL_CLASS_FM_TX.
Should a corresponding class be created for FM tuners?

B.R.
Matti A.

Matti J. Aaltonen (3):
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  WL1273 FM Radio: Digital audio codec.
  V4L2: WL1273 FM Radio: Controls for the FM radio.

 drivers/media/radio/Kconfig        |   15 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c | 1849 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    6 +
 drivers/mfd/Makefile               |    2 +
 drivers/mfd/wl1273-core.c          |  609 ++++++++++++
 include/linux/mfd/wl1273-core.h    |  323 +++++++
 sound/soc/codecs/Kconfig           |    6 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/wl1273.c          |  587 ++++++++++++
 sound/soc/codecs/wl1273.h          |   40 +
 11 files changed, 3440 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h


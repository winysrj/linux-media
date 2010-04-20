Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59534 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0DTPUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 11:20:37 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3KFKR6w031040
	for <linux-media@vger.kernel.org>; Tue, 20 Apr 2010 18:20:34 +0300
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH 0/3] Driver for TI WL1273 FM radio.
Date: Tue, 20 Apr 2010 18:20:04 +0300
Message-Id: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

This is the initial version of my driver for Texas Instruments
WL1273 FM receiver transmitter. The driver is divided into three parts:
the MFD core which handles the communication with the chip and also
keeps the chip state, ASoC codec takes care of the digital audio part and
the V4L2 control part with some private IOCTLs.

This is my first up-streaming effort so all comments are welcome.

Cheers,
Matti

Matti J. Aaltonen (3):
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  ASoC: WL1273 FM Radio: Digital audio codec.
  V4L2: WL1273 FM Radio: Controls for the FM radio.

 drivers/media/radio/Kconfig        |   15 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c |  805 ++++++++++++++++
 drivers/mfd/Kconfig                |    6 +
 drivers/mfd/Makefile               |    2 +
 drivers/mfd/wl1273-core.c          | 1825 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wl1273-core.h    |  265 ++++++
 sound/soc/codecs/Kconfig           |    6 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/wl1273.c          |  708 ++++++++++++++
 sound/soc/codecs/wl1273.h          |   49 +
 11 files changed, 3684 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h


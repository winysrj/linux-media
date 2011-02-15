Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:52549 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1BOIPq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 03:15:46 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v19 0/3] TI Wl1273 FM radio driver.
Date: Tue, 15 Feb 2011 10:13:43 +0200
Message-Id: <1297757626-3281-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Now I've refactored the code so that the I2C I/O functions are in the 
MFD core. Also now the codec can be compiled without compiling the V4L2
driver.

I haven't implemented the audio routing (yet), but I've added a TODO
comment about it in the codec file.

Cheers,
Matti

Matti J. Aaltonen (3):
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  V4L2: WL1273 FM Radio: TI WL1273 FM radio driver
  ASoC: WL1273 FM radio: Access I2C IO functions through pointers.

 drivers/media/radio/Kconfig        |   16 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c | 2183 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |   10 +
 drivers/mfd/Makefile               |    1 +
 drivers/mfd/wl1273-core.c          |  295 +++++
 include/linux/mfd/wl1273-core.h    |  291 +++++
 sound/soc/codecs/Kconfig           |    2 +-
 sound/soc/codecs/wl1273.c          |   38 +-
 sound/soc/codecs/wl1273.h          |   71 --
 10 files changed, 2817 insertions(+), 91 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h


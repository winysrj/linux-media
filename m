Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:36875 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab0I2MlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 08:41:22 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v11 0/4] WL1273 FM Radio driver.
Date: Wed, 29 Sep 2010 15:40:35 +0300
Message-Id: <1285764039-5767-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello again!

I've only received one comment from Hans (thank you) and I'm still
expecting to get comments also from Mauro. But I'm sending 
the eleventh version anyway to keep the wheels rolling so to speak...

Hans wrote:
>> +             V4L2_CAP_RDS_OUTPUT | V4L2_TUNER_CAP_RDS_BLOCK_IO;
>> +
>> +     return 0;
>> +}
>
> V4L2_TUNER_CAP_RDS_BLOCK_IO is a tuner/modulator capability! Not a
> querycap capability! It's added at the wrong place.

Moved the BLOCK_IO flag to g_tuner and g_modulator.

I also made a small fix to driver/media/radio/Kconfig so that the driver
can actually be built without the digital audio codec.

And in addition removed a reference to FM radio bands from the mfd file.

B.R.
Matti

Matti J. Aaltonen (4):
  V4L2: Add seek spacing and RDS CAP bits.
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  V4L2: WL1273 FM Radio: Controls for the FM radio.
  Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.

 Documentation/DocBook/v4l/dev-rds.xml              |   10 +-
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   16 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1859 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |    5 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  583 ++++++
 include/linux/mfd/wl1273-core.h                    |  320 ++++
 include/linux/videodev2.h                          |    5 +-
 10 files changed, 2807 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h


Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:49264 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1CAIBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 03:01:30 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v21 0/3] ASoC/MFD/V4L2: WL1273 FM Radio Driver
Date: Tue,  1 Mar 2011 10:00:47 +0200
Message-Id: <1298966450-31814-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi.

And thanks for the comment.

Samuel wrote:
>> Remove two unnecessary calls to i2c_set_clientdata.
>Provided that you add a changelog relevant to the patch itself, and not to the
>v1->v2 diff:

Replaced the incremental changelog stuff with the original descriptions.

>Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Matti

Matti J. Aaltonen (3):
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  V4L2: WL1273 FM Radio: TI WL1273 FM radio driver
  ASoC: WL1273 FM radio: Access I2C IO functions through pointers.

 drivers/media/radio/radio-wl1273.c |  360 +++++++++++-------------------------
 drivers/mfd/Kconfig                |    2 +-
 drivers/mfd/wl1273-core.c          |  149 +++++++++++++++-
 include/linux/mfd/wl1273-core.h    |    2 +
 sound/soc/codecs/Kconfig           |    2 +-
 sound/soc/codecs/wl1273.c          |   11 +-
 6 files changed, 264 insertions(+), 262 deletions(-)


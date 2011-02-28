Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:51713 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1B1LDR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:03:17 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v20 0/3] ASoC/MFD/V4L2: WL1273 FM Radio driver
Date: Mon, 28 Feb 2011 13:02:28 +0200
Message-Id: <1298890951-23339-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

And thanks for the comments. If we now move quickly enough we can
get this thing in before it becomes deprecated...

Samuel wrote:
> for Mauro to take this one you'd have to provide a
> diff against the already existing wl1273-core.

I've made these patches against the existing stuff.

>> + * Copyright (C) 2010 Nokia Corporation
>2011.

Changed.

>> +}
> I'm confused with this one: Isn't WL1273_VOLUME_SET a command ? Also,
> how can reading from it set the volume ?

It cannot... so I've changed it (back) to write.

>> +     i2c_set_clientdata(client, NULL)
>Not needed.

Removed.

>> +err:
>> +     i2c_set_clientdata(client, NULL);
>Ditto.

Ditto.

Cheers,
Matti

Matti J. Aaltonen (3):
  MFD: Wl1273 FM radio core: Add I2C IO functions.
  V4L2: Wl1273 FM Radio: Remove I2C IO functions.
  ASoC: WL1273 FM radio: Access I2C IO functions through pointers.

 drivers/media/radio/radio-wl1273.c |  360 +++++++++++-------------------------
 drivers/mfd/Kconfig                |    2 +-
 drivers/mfd/wl1273-core.c          |  149 +++++++++++++++-
 include/linux/mfd/wl1273-core.h    |    2 +
 sound/soc/codecs/Kconfig           |    2 +-
 sound/soc/codecs/wl1273.c          |   11 +-
 6 files changed, 264 insertions(+), 262 deletions(-)


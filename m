Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:47111 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1CANL1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:11:27 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v22 0/3] ASoC/MFD/V4L2: WL1273 FM Radio Driver
Date: Tue,  1 Mar 2011 15:10:34 +0200
Message-Id: <1298985037-2714-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Thanks for the comment Mark.

On Tue, 2011-03-01 at 11:54 +0000, ext Mark Brown wrote:
On Tue, Mar 01, 2011 at 10:00:50AM +0200, Matti J. Aaltonen wrote:
> > These changes are needed to keep up with the changes in the
> > MFD core and V4L2 parts of the wl1273 FM radio driver.
> > 
> > Use function pointers instead of exported functions for I2C IO.
> > Also move all preprocessor constants from the wl1273.h to
> > include/linux/mfd/wl1273-core.h.
> > 
> > Also update the year in the copyright statement.
> 
> It's not actually doing that:
> 
> > - * Copyright:   (C) 2010 Nokia Corporation
> > + * Copyright:   (C) 2011 Nokia Corporation
> 
> It's replacing it - portions are still 2010.

Kept also the year 2010 on the copyright line.
 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
 

On Tue, 2011-03-01 at 12:43 +0100, ext Samuel Ortiz wrote:
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

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


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2881 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab0DWJRA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 05:17:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH 0/3] Driver for TI WL1273 FM radio.
Date: Fri, 23 Apr 2010 11:16:55 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004231116.55983.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 20 April 2010 17:20:04 Matti J. Aaltonen wrote:
> Hi.
> 
> This is the initial version of my driver for Texas Instruments
> WL1273 FM receiver transmitter. The driver is divided into three parts:
> the MFD core which handles the communication with the chip and also
> keeps the chip state, ASoC codec takes care of the digital audio part and
> the V4L2 control part with some private IOCTLs.
> 
> This is my first up-streaming effort so all comments are welcome.

OK, I did a quick review and the main things that you need to look at are
the RDS receiver API as defined in the spec
(http://www.linuxtv.org/downloads/v4l-dvb-apis/ch04s11.html) and the FM and
RDS transmitter controls:
http://www.linuxtv.org/downloads/v4l-dvb-apis/ch01s09.html#fm-tx-controls.

Any private controls that you think you need should be discussed first. We
may need to standardize them.

The other thing you have to do in the V4L2 driver is to use struct v4l2_device.
See also Documentation/video4linux/v4l2-framework.txt.

I also noticed some FM and RDS things in the alsa driver. It is not clear to
me why these are there since this is pretty much V4L2 specific.

Regarding hardcoding regions: isn't this more for the application? Are there
any legal requirements for region handling?

Most radio tuners just accept the whole frequency range that they support and
leave it to the application to restrict it if needed depending on the region.

Those disabled controls like bass, treble etc. should be removed. Workarounds
for plainly broken applications is not something we want in our drivers.
Instead make a patch for that app and send it to the maintainer. If it is
unmaintained, then let us know: we can move unmaintained but frequently used
apps to our own repository.

Regards,

	Hans

> 
> Cheers,
> Matti
> 
> Matti J. Aaltonen (3):
>   MFD: WL1273 FM Radio: MFD driver for the FM radio.
>   ASoC: WL1273 FM Radio: Digital audio codec.
>   V4L2: WL1273 FM Radio: Controls for the FM radio.
> 
>  drivers/media/radio/Kconfig        |   15 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c |  805 ++++++++++++++++
>  drivers/mfd/Kconfig                |    6 +
>  drivers/mfd/Makefile               |    2 +
>  drivers/mfd/wl1273-core.c          | 1825 ++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/wl1273-core.h    |  265 ++++++
>  sound/soc/codecs/Kconfig           |    6 +
>  sound/soc/codecs/Makefile          |    2 +
>  sound/soc/codecs/wl1273.c          |  708 ++++++++++++++
>  sound/soc/codecs/wl1273.h          |   49 +
>  11 files changed, 3684 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
>  create mode 100644 drivers/mfd/wl1273-core.c
>  create mode 100644 include/linux/mfd/wl1273-core.h
>  create mode 100644 sound/soc/codecs/wl1273.c
>  create mode 100644 sound/soc/codecs/wl1273.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

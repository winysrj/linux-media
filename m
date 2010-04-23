Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:47101 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab0DWLgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 07:36:10 -0400
Subject: Re: [PATCH 0/3] Driver for TI WL1273 FM radio.
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <201004231116.55983.hverkuil@xs4all.nl>
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <201004231116.55983.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 14:35:46 +0300
Message-ID: <1272022546.5883.65.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

thank you for the comments.

On Fri, 2010-04-23 at 11:16 +0200, ext Hans Verkuil wrote:
> On Tuesday 20 April 2010 17:20:04 Matti J. Aaltonen wrote:
> > Hi.
> > 
> > This is the initial version of my driver for Texas Instruments
> > WL1273 FM receiver transmitter. The driver is divided into three parts:
> > the MFD core which handles the communication with the chip and also
> > keeps the chip state, ASoC codec takes care of the digital audio part and
> > the V4L2 control part with some private IOCTLs.
> > 
> > This is my first up-streaming effort so all comments are welcome.
> 
> OK, I did a quick review and the main things that you need to look at are
> the RDS receiver API as defined in the spec
> (http://www.linuxtv.org/downloads/v4l-dvb-apis/ch04s11.html) and the FM and
> RDS transmitter controls:
> http://www.linuxtv.org/downloads/v4l-dvb-apis/ch01s09.html#fm-tx-controls.

OK, I'll do that.

> 
> Any private controls that you think you need should be discussed first. We
> may need to standardize them.

OK, I didn't realize that. But it makes sense, so let's discuss...

> The other thing you have to do in the V4L2 driver is to use struct v4l2_device.
> See also Documentation/video4linux/v4l2-framework.txt.

OK.

> I also noticed some FM and RDS things in the alsa driver. It is not clear to
> me why these are there since this is pretty much V4L2 specific.

Yes, I kind of new that those controls weren't a good idea. But I
implemented those when I didn't know better. Ande I left them there to
see if they would get accepted. But I'll remove them as the
functionality is duplicated in the V4L2 module.

> Regarding hardcoding regions: isn't this more for the application? Are there
> any legal requirements for region handling?

I thought about that a lot. And I know that the regions are a policy
thing that doesn't belong into the driver/kernel. But those two regions
are directly supported by the hardware so I thought that it would be OK
make them available.

> Most radio tuners just accept the whole frequency range that they support and
> leave it to the application to restrict it if needed depending on the region.

I understand... see above...

> Those disabled controls like bass, treble etc. should be removed. Workarounds
> for plainly broken applications is not something we want in our drivers.
> Instead make a patch for that app and send it to the maintainer. If it is
> unmaintained, then let us know: we can move unmaintained but frequently used
> apps to our own repository.

Fine... I did that just to copy the functionality of some existing
driver when I started.

B.R.

Matti

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Cheers,
> > Matti
> > 
> > Matti J. Aaltonen (3):
> >   MFD: WL1273 FM Radio: MFD driver for the FM radio.
> >   ASoC: WL1273 FM Radio: Digital audio codec.
> >   V4L2: WL1273 FM Radio: Controls for the FM radio.
> > 
> >  drivers/media/radio/Kconfig        |   15 +
> >  drivers/media/radio/Makefile       |    1 +
> >  drivers/media/radio/radio-wl1273.c |  805 ++++++++++++++++
> >  drivers/mfd/Kconfig                |    6 +
> >  drivers/mfd/Makefile               |    2 +
> >  drivers/mfd/wl1273-core.c          | 1825 ++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/wl1273-core.h    |  265 ++++++
> >  sound/soc/codecs/Kconfig           |    6 +
> >  sound/soc/codecs/Makefile          |    2 +
> >  sound/soc/codecs/wl1273.c          |  708 ++++++++++++++
> >  sound/soc/codecs/wl1273.h          |   49 +
> >  11 files changed, 3684 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/radio/radio-wl1273.c
> >  create mode 100644 drivers/mfd/wl1273-core.c
> >  create mode 100644 include/linux/mfd/wl1273-core.h
> >  create mode 100644 sound/soc/codecs/wl1273.c
> >  create mode 100644 sound/soc/codecs/wl1273.h
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 



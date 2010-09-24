Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.230]:53843 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0IXN1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 09:27:43 -0400
Subject: Re: [PATCH v10 3/4] V4L2: WL1273 FM Radio: Controls for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	mchehab@redhat.com
In-Reply-To: <dcd47b0797041a1560a9bd6ddf36cc27.squirrel@webmail.xs4all.nl>
References: <1285329332-4380-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1285329332-4380-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1285329332-4380-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <1285329332-4380-4-git-send-email-matti.j.aaltonen@nokia.com>
	 <dcd47b0797041a1560a9bd6ddf36cc27.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 16:26:56 +0300
Message-ID: <1285334816.8182.165.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2010-09-24 at 15:09 +0200, ext Hans Verkuil wrote:
> > This driver implements V4L2 controls for the Texas Instruments
> > WL1273 FM Radio.
> >
> > Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> > ---
> >  drivers/media/radio/Kconfig        |   15 +
> >  drivers/media/radio/Makefile       |    1 +
> >  drivers/media/radio/radio-wl1273.c | 1859
> > ++++++++++++++++++++++++++++++++++++
> >  drivers/mfd/Kconfig                |    5 +
> >  drivers/mfd/Makefile               |    2 +
> >  5 files changed, 1882 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/radio/radio-wl1273.c
> >
> > +static int wl1273_fm_vidioc_querycap(struct file *file, void *priv,
> > +				     struct v4l2_capability *capability)
> > +{
> > +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> > +
> > +	dev_dbg(radio->dev, "%s\n", __func__);
> > +
> > +	strlcpy(capability->driver, WL1273_FM_DRIVER_NAME,
> > +		sizeof(capability->driver));
> > +	strlcpy(capability->card, "Texas Instruments Wl1273 FM Radio",
> > +		sizeof(capability->card));
> > +	strlcpy(capability->bus_info, "I2C", sizeof(capability->bus_info));
> > +
> > +	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
> > +		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_AUDIO |
> > +		V4L2_CAP_RDS_CAPTURE | V4L2_CAP_MODULATOR |
> > +		V4L2_CAP_RDS_OUTPUT | V4L2_TUNER_CAP_RDS_BLOCK_IO;
> > +
> > +	return 0;
> > +}
> 
> V4L2_TUNER_CAP_RDS_BLOCK_IO is a tuner/modulator capability! Not a
> querycap capability! It's added at the wrong place.

Alright... I'll fix that in v11...

Thanks,
Matti

> 
> Regards,
> 
>          Hans
> 



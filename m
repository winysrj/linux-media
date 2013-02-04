Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2382 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3BDIi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 03:38:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [RFC PATCH 08/18] tlg2300: fix radio querycap
Date: Mon, 4 Feb 2013 09:38:17 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <e745ec830817f4eab48445b0e205a7b568a0e2b0.1359627298.git.hans.verkuil@cisco.com> <510F3AE8.3080205@gmail.com>
In-Reply-To: <510F3AE8.3080205@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302040938.17407.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 4 2013 05:36:56 Huang Shijie wrote:
> 于 2013年01月31日 05:25, Hans Verkuil 写道:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/usb/tlg2300/pd-radio.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> > index 854ffa0..80307d3 100644
> > --- a/drivers/media/usb/tlg2300/pd-radio.c
> > +++ b/drivers/media/usb/tlg2300/pd-radio.c
> > @@ -147,7 +147,12 @@ static int vidioc_querycap(struct file *file, void *priv,
> >  	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
> >  	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
> >  	usb_make_path(p->udev, v->bus_info, sizeof(v->bus_info));
> > -	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> > +	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> > +	/* Report all capabilities of the USB device */
> > +	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS |
> > +			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VBI_CAPTURE |
> why add these video/vbi capabilities?

The capabilities field contains the V4L2 capabilities of the whole device
(i.e. radio+video+vbi), the device_caps field contains the capabilities of
just that node.

In the past different drivers interpreted the capabilities field differently:
either with the capabilities of the whole device or the capabilities of just
that device node. This situation was clarified recently and the device_caps
field was added instead so both the caps for the full device and the current
device node are now available.

This wasn't there when the tlg2300 driver was developed, and the spec was
never clear enough regarding the meaning of the capabilities field.

So this is a later improvement to the V4L2 API.

Regards,

	Hans

> 
> > +			V4L2_CAP_AUDIO | V4L2_CAP_STREAMING 
> > +			V4L2_CAP_READWRITE;
> >  	return 0;
> >  }
> >  
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55281 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbeKGAJl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 19:09:41 -0500
Message-ID: <1541515447.5822.20.camel@pengutronix.de>
Subject: Re: [PATCH 1/3] media: imx: add capture compose rectangle
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Date: Tue, 06 Nov 2018 15:44:07 +0100
In-Reply-To: <20181106140133.n2s2y4uhallf2xke@valkosipuli.retiisi.org.uk>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
         <20181106140133.n2s2y4uhallf2xke@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, 2018-11-06 at 16:01 +0200, Sakari Ailus wrote:
[...]
> @@ -290,6 +294,35 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
> >  	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
> >  }
> >  
> > +static int capture_g_selection(struct file *file, void *fh,
> > +			       struct v4l2_selection *s)
> > +{
> > +	struct capture_priv *priv = video_drvdata(file);
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_NATIVE_SIZE:
> 
> The NATIVE_SIZE is for devices such as sensors. It doesn't make sense here.

Should this be documented in Documentation/media/uapi/v4l/v4l2-
selection-targets.rst ? There it only mentions when to make it
writeable.

> With that removed,
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thank you, I'll remove that line.

regards
Philipp

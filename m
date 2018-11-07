Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35516 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726370AbeKGVP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 16:15:57 -0500
Date: Wed, 7 Nov 2018 13:45:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] media: imx: add capture compose rectangle
Message-ID: <20181107114555.jtw5bzzesbwxgdrx@valkosipuli.retiisi.org.uk>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
 <20181106140133.n2s2y4uhallf2xke@valkosipuli.retiisi.org.uk>
 <1541515447.5822.20.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541515447.5822.20.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Nov 06, 2018 at 03:44:07PM +0100, Philipp Zabel wrote:
> Hi Sakari,
> 
> On Tue, 2018-11-06 at 16:01 +0200, Sakari Ailus wrote:
> [...]
> > @@ -290,6 +294,35 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
> > >  	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
> > >  }
> > >  
> > > +static int capture_g_selection(struct file *file, void *fh,
> > > +			       struct v4l2_selection *s)
> > > +{
> > > +	struct capture_priv *priv = video_drvdata(file);
> > > +
> > > +	switch (s->target) {
> > > +	case V4L2_SEL_TGT_CROP:
> > > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > > +	case V4L2_SEL_TGT_NATIVE_SIZE:
> > 
> > The NATIVE_SIZE is for devices such as sensors. It doesn't make sense here.
> 
> Should this be documented in Documentation/media/uapi/v4l/v4l2-
> selection-targets.rst ? There it only mentions when to make it
> writeable.

This seems to have originated from the documentation before the ReST
conversion and I had hard time to figure out where the current text (apart
from sensor pixel array) came from. There is also no driver using it in
that meaning, and I doubt if the use is not already been covered by the
compose rectangle.

This indeed requires some follow-up, but that's out of scope of your set.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

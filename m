Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58287 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728084AbeKIWlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 17:41:09 -0500
Message-ID: <1541768436.4112.35.camel@pengutronix.de>
Subject: Re: [PATCH 1/3] media: imx: add capture compose rectangle
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Fri, 09 Nov 2018 14:00:36 +0100
In-Reply-To: <67e65cb6-d963-f53d-88e6-a28349477183@gmail.com>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
         <67e65cb6-d963-f53d-88e6-a28349477183@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

thank you for the review.

On Thu, 2018-11-08 at 21:33 -0800, Steve Longerbeam wrote:
[...]
> > --- a/drivers/staging/media/imx/imx-media-capture.c
> > +++ b/drivers/staging/media/imx/imx-media-capture.c
> > @@ -262,6 +262,10 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
> >   	priv->vdev.fmt.fmt.pix = f->fmt.pix;
> >   	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
> >   					      CS_SEL_ANY, true);
> > +	priv->vdev.compose.left = 0;
> > +	priv->vdev.compose.top = 0;
> > +	priv->vdev.compose.width = f->fmt.fmt.pix.width;
> > +	priv->vdev.compose.height = f->fmt.fmt.pix.height;
> 
> this should be:
> 
> priv->vdev.compose.width = fmt_src.format.width;
> priv->vdev.compose.height = fmt_src.format.height;
> 
> (corrected in the next patches but needs to be corrected here).

Thanks for catching this, it should be

+	priv->vdev.compose.width = f->fmt.pix.width;
+	priv->vdev.compose.height = f->fmt.pix.height;

though, fmt_src is only introduced in patch 2.

regards
Philipp

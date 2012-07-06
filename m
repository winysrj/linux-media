Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2GFPL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 11:11:58 -0400
Date: Fri, 6 Jul 2012 17:11:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	fabio.estevam@freescale.com, mchehab@infradead.org,
	kernel@pengutronix.de
Subject: Re: [PATCH v3][for_v3.5] media: mx2_camera: Fix mbus format handling
In-Reply-To: <Pine.LNX.4.64.1207061439090.29809@axis700.grange>
Message-ID: <Pine.LNX.4.64.1207061639210.29809@axis700.grange>
References: <1338543105-20322-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1207061439090.29809@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hmm... sorry again. It is my fault, that I left this patch without 
attention for full 5 weeks, but I still don't have a sufficiently good 
feeling about it. Look here:

On Fri, 6 Jul 2012, Guennadi Liakhovetski wrote:

> Hi Javier
> 
> Thanks for the patch, and sorry for delay. I was away first 10 days of 
> June and still haven't come round to cleaning up my todo list since 
> then...
> 
> On Fri, 1 Jun 2012, Javier Martin wrote:

[snip]

> > @@ -1024,14 +1039,28 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
> >  		return ret;
> >  	}
> >  
> > +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> > +	if (!xlate) {
> > +		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (xlate->code == V4L2_MBUS_FMT_YUYV8_2X8) {
> > +		csicr1 |= CSICR1_PACK_DIR;
> > +		csicr1 &= ~CSICR1_SWAP16_EN;
> > +		dev_dbg(icd->parent, "already yuyv format, don't convert\n");
> > +	} else if (xlate->code == V4L2_MBUS_FMT_UYVY8_2X8) {
> > +		csicr1 &= ~CSICR1_PACK_DIR;
> > +		csicr1 |= CSICR1_SWAP16_EN;
> > +		dev_dbg(icd->parent, "convert uyvy mbus format into yuyv\n");
> > +	}

This doesn't look right. From V4L2_MBUS_FMT_YUYV8_2X8 you can produce two 
output formats:

V4L2_PIX_FMT_YUV420 and
V4L2_PIX_FMT_YUYV

For both of them you set CSICR1_PACK_DIR, which wasn't the default before? 
Next for V4L2_MBUS_FMT_UYVY8_2X8. From this one you can produce 3 formats:

V4L2_PIX_FMT_YUV420,
V4L2_PIX_FMT_YUYV and
V4L2_PIX_FMT_UYVY

For all 3 of them you now set CSICR1_SWAP16_EN. Are you sure all the above 
is correct?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

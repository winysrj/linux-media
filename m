Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36579 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753410AbdLHOO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 09:14:26 -0500
Received: by mail-lf0-f68.google.com with SMTP id f20so12047628lfe.3
        for <linux-media@vger.kernel.org>; Fri, 08 Dec 2017 06:14:25 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 8 Dec 2017 15:14:23 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 11/28] rcar-vin: do not allow changing scaling and
 composing while streaming
Message-ID: <20171208141423.GQ31989@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-12-niklas.soderlund+renesas@ragnatech.se>
 <14690079.PLADEzS7Fe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14690079.PLADEzS7Fe@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2017-12-08 11:04:26 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:25 EET Niklas Söderlund wrote:
> > It is possible on Gen2 to change the registers controlling composing and
> > scaling while the stream is running. It is however not a good idea to do
> > so and could result in trouble. There are also no good reasons to allow
> > this, remove immediate reflection in hardware registers from
> > vidioc_s_selection and only configure scaling and composing when the
> > stream starts.
> 
> There is a good reason: digital zoom.

OK, so you would recommend me to drop this patch to keep the current 
behavior?

> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
> >  drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
> >  3 files changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> > b/drivers/media/platform/rcar-vin/rcar-dma.c index
> > fd14be20a6604d7a..7be5080f742825fb 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -514,7 +514,7 @@ static void rvin_set_coeff(struct rvin_dev *vin,
> > unsigned short xs) rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
> >  }
> > 
> > -void rvin_crop_scale_comp(struct rvin_dev *vin)
> > +static void rvin_crop_scale_comp(struct rvin_dev *vin)
> >  {
> >  	u32 xs, ys;
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 254fa1c8770275a5..d6298c684ab2d731 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -436,9 +436,6 @@ static int rvin_s_selection(struct file *file, void *fh,
> > return -EINVAL;
> >  	}
> > 
> > -	/* HW supports modifying configuration while running */
> > -	rvin_crop_scale_comp(vin);
> > -
> >  	return 0;
> >  }
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> > b/drivers/media/platform/rcar-vin/rcar-vin.h index
> > 36d0f0cc4ce01a6e..67541b483ee43c52 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > @@ -175,7 +175,4 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
> > 
> >  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
> > 
> > -/* Cropping, composing and scaling */
> > -void rvin_crop_scale_comp(struct rvin_dev *vin);
> > -
> >  #endif
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund

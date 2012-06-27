Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33493 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2F0Ly2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 07:54:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 1/6] omap3isp: video: Split format info bpp field into width and bpp
Date: Wed, 27 Jun 2012 13:54:30 +0200
Message-ID: <3151444.lq5j8qGhle@avalon>
In-Reply-To: <4FEAE987.6060104@iki.fi>
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com> <1340718339-29915-2-git-send-email-laurent.pinchart@ideasonboard.com> <4FEAE987.6060104@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Wednesday 27 June 2012 14:07:51 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > The bpp field currently stores the sample width and is aligned to the
> > next multiple of 8 bits when computing data size in memory. This won't
> > work anymore for YUYV8_2X8 formats. Split the bpp field into a sample
> > width and a bits per pixel value.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> ...
> 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.h
> > b/drivers/media/video/omap3isp/ispvideo.h index 5acc909..f8092cc 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.h
> > +++ b/drivers/media/video/omap3isp/ispvideo.h
> > @@ -51,7 +51,8 @@ struct v4l2_pix_format;
> > 
> >   * @flavor: V4L2 media bus format code for the same pixel layout but
> >   *	shifted to be 8 bits per pixel. =0 if format is not shiftable.
> >   * @pixelformat: V4L2 pixel format FCC identifier
> > 
> > - * @bpp: Bits per pixel
> > + * @width: Data bus width
> > + * @bpp: Bits per pixel (when stored in memory)
> 
> Would it make sense to use bytes rather than bits?

I'll change that.

> Also width isn't really the width of the data bus on serial busses, is it?
> How about busses that transfer pixels 8 bits at the time?

I could change the comment to "bits per pixel (when transferred on a bus)", 
would that be better ?

> You can also stop using ALIGN() in isp_video_mbus_to_pix() (in ispvideo.c)
> as the ISP will always write complete bytes.

Indeed.

> I might even switch the meaning between width and bpp but this is up to you.

I got used to width/bpp as defined by this patch, so that would be confusing 
:-)

> >   */
> >  
> >  struct isp_format_info {
> >  
> >  	enum v4l2_mbus_pixelcode code;
> > 
> > @@ -59,6 +60,7 @@ struct isp_format_info {
> > 
> >  	enum v4l2_mbus_pixelcode uncompressed;
> >  	enum v4l2_mbus_pixelcode flavor;
> >  	u32 pixelformat;
> > 
> > +	unsigned int width;
> > 
> >  	unsigned int bpp;
> >  
> >  };
> > 
> > @@ -106,7 +108,7 @@ struct isp_pipeline {
> > 
> >  	struct v4l2_fract max_timeperframe;
> >  	struct v4l2_subdev *external;
> >  	unsigned int external_rate;
> > 
> > -	unsigned int external_bpp;
> > +	unsigned int external_width;
> > 
> >  };
> >  
> >  #define to_isp_pipeline(__e) \

-- 
Regards,

Laurent Pinchart


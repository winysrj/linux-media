Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34548 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbeINQBR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 12:01:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] media: vsp1: Remove artificial pixel limitation
Date: Fri, 14 Sep 2018 13:47:33 +0300
Message-ID: <30741876.5p2uMOrImx@avalon>
In-Reply-To: <3874771.GdJIGdZf8f@avalon>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com> <20180831144044.31713-2-kieran.bingham+renesas@ideasonboard.com> <3874771.GdJIGdZf8f@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Would you mind changing the patch subject to "Remove artificial minimum width/
height limitation" ?

On Friday, 14 September 2018 13:23:04 EEST Laurent Pinchart wrote:
> On Friday, 31 August 2018 17:40:39 EEST Kieran Bingham wrote:
> > The VSP1 has a minimum width and height of a single pixel, with the
> > exception of pixel formats with sub-sampling.
> > 
> > Remove the artificial minimum width and minimum height limitation, and
> > instead clamp the minimum dimensions based upon the sub-sampling
> > parameter of that dimension.
> > 
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> and applied to my tree.
> 
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_video.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > b/drivers/media/platform/vsp1/vsp1_video.c index
> > 81d47a09d7bc..e78eadd0295b
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_video.c
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > @@ -38,9 +38,7 @@
> > 
> >  #define VSP1_VIDEO_DEF_WIDTH		1024
> >  #define VSP1_VIDEO_DEF_HEIGHT		768
> > 
> > -#define VSP1_VIDEO_MIN_WIDTH		2U
> > 
> >  #define VSP1_VIDEO_MAX_WIDTH		8190U
> > 
> > -#define VSP1_VIDEO_MIN_HEIGHT		2U
> > 
> >  #define VSP1_VIDEO_MAX_HEIGHT		8190U
> >  
> >  /*
> > 
> > --------------------------------------------------------------------------
> > -
> > -- @@ -136,9 +134,8 @@ static int __vsp1_video_try_format(struct
> > vsp1_video
> > *video, height = round_down(height, info->vsub);
> > 
> >  	/* Clamp the width and height. */
> > 
> > -	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, VSP1_VIDEO_MAX_WIDTH);
> > -	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
> > -			    VSP1_VIDEO_MAX_HEIGHT);
> > +	pix->width = clamp(width, info->hsub, VSP1_VIDEO_MAX_WIDTH);
> > +	pix->height = clamp(height, info->vsub, VSP1_VIDEO_MAX_HEIGHT);
> > 
> >  	/*
> >  	
> >  	 * Compute and clamp the stride and image size. While not documented in


-- 
Regards,

Laurent Pinchart

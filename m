Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53949 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2F0V5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 17:57:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] ov2640: Don't access the device in the g_mbus_fmt operation
Date: Wed, 27 Jun 2012 23:57:11 +0200
Message-ID: <3085103.ExjgalM03D@avalon>
In-Reply-To: <Pine.LNX.4.64.1206211426520.3513@axis700.grange>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com> <1337786855-28759-4-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1206211426520.3513@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review.

On Thursday 21 June 2012 14:28:04 Guennadi Liakhovetski wrote:
> On Wed, 23 May 2012, Laurent Pinchart wrote:
> > The g_mbus_fmt operation only needs to return the current mbus frame
> > format and doesn't need to configure the hardware to do so. Fix it to
> > avoid requiring the chip to be powered on when calling the operation.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/ov2640.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
> > index 3c2c5d3..d9a427c 100644
> > --- a/drivers/media/video/ov2640.c
> > +++ b/drivers/media/video/ov2640.c
> > @@ -837,10 +837,7 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
> > 
> >  	if (!priv->win) {
> >  	
> >  		u32 width = W_SVGA, height = H_SVGA;
> > 
> > -		int ret = ov2640_set_params(client, &width, &height,
> > -					    V4L2_MBUS_FMT_UYVY8_2X8);
> > -		if (ret < 0)
> > -			return ret;
> > +		priv->win = ov2640_select_win(&width, &height);
> 
> I think you also have to set
> 
> 		priv->cfmt_code = V4L2_MBUS_FMT_UYVY8_2X8;

You're right. I'll fix that.

-- 
Regards,

Laurent Pinchart


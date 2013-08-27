Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H0Mcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 08:32:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Fix typo in v4l2_subdev_get_try_crop()
Date: Tue, 27 Aug 2013 14:34:05 +0200
Message-ID: <6073088.jjl5NmzUoe@avalon>
In-Reply-To: <20130826095346.GB2835@valkosipuli.retiisi.org.uk>
References: <1377508671-13188-1-git-send-email-laurent.pinchart@ideasonboard.com> <20130826095346.GB2835@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 26 August 2013 12:53:46 Sakari Ailus wrote:
> On Mon, Aug 26, 2013 at 11:17:51AM +0200, Laurent Pinchart wrote:
> > The helper function is defined by a macro that is erroneously called
> > with the compose rectangle instead of the crop rectangle. Fix it.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  include/media/v4l2-subdev.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index bfda0fe..34d9219 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -628,7 +628,7 @@ struct v4l2_subdev_fh {
> > 
> >  	}
> >  
> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> > -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_compose)
> > +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
> >  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> >  #endif
> 
> Oops. My bad I guess... it's a surprise to me this one slipped through.
> Excellent find!
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Thank you.

Mauro, could you please pick this patch up, for v3.12 if still possible ?

-- 
Regards,

Laurent Pinchart


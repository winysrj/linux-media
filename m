Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56821 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdERQHu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 12:07:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Kieran Bingham <kbingham@kernel.org>,
        niklas.soderlund@ragnatech.se, geert@glider.be,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3.1 1/2] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
Date: Thu, 18 May 2017 19:08 +0300
Message-ID: <3270185.UdjK4gGCsr@avalon>
In-Reply-To: <20170517192057.GT3227@valkosipuli.retiisi.org.uk>
References: <cover.ed561929790222fc2c4467d4e57072a8e4ba69f3.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com> <38adea84b864609515b2db580a76954b1a114e3f.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com> <20170517192057.GT3227@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 17 May 2017 22:20:57 Sakari Ailus wrote:
> On Wed, May 17, 2017 at 04:38:14PM +0100, Kieran Bingham wrote:
> > From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> > Return NULL, if a null entity is parsed for it's v4l2_subdev
> > 
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > ---
> > 
> >  include/media/v4l2-subdev.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 5f1669c45642..72d7f28f38dc 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -829,7 +829,7 @@ struct v4l2_subdev {
> > 
> >  };
> >  
> >  #define media_entity_to_v4l2_subdev(ent) \
> > -	container_of(ent, struct v4l2_subdev, entity)
> > +	(ent ? container_of(ent, struct v4l2_subdev, entity) : NULL)
> > 
> >  #define vdev_to_v4l2_subdev(vdev) \
> >  	((struct v4l2_subdev *)video_get_drvdata(vdev))
> 
> The problem with this is that ent is now referenced twice. If the ent macro
> argument has side effect, this would introduce bugs. It's unlikely, but
> worth avoiding. Either use a macro or a function.
> 
> I think I'd use function for there's little use for supporting for const and
> non-const arguments presumably. A simple static inline function should do.

Note that, if we want to keep using a macro, this could be written as

#define media_entity_to_v4l2_subdev(ent) ({ \
	typeof(ent) __ent = ent; \
	__ent ? container_of(__ent, struct v4l2_subdev, entity) : NULL; \
})

Bonus point if you can come up with a way to return a const struct v4l2_subdev 
pointer when then ent argument is const.

-- 
Regards,

Laurent Pinchart

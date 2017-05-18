Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44424 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751398AbdERUum (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 16:50:42 -0400
Date: Thu, 18 May 2017 23:50:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        niklas.soderlund@ragnatech.se, geert@glider.be,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3.1 1/2] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
Message-ID: <20170518205033.GW3227@valkosipuli.retiisi.org.uk>
References: <cover.ed561929790222fc2c4467d4e57072a8e4ba69f3.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
 <38adea84b864609515b2db580a76954b1a114e3f.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170517192057.GT3227@valkosipuli.retiisi.org.uk>
 <3270185.UdjK4gGCsr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3270185.UdjK4gGCsr@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, May 18, 2017 at 07:08:00PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wednesday 17 May 2017 22:20:57 Sakari Ailus wrote:
> > On Wed, May 17, 2017 at 04:38:14PM +0100, Kieran Bingham wrote:
> > > From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > 
> > > Return NULL, if a null entity is parsed for it's v4l2_subdev
> > > 
> > > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > ---
> > > 
> > >  include/media/v4l2-subdev.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > > index 5f1669c45642..72d7f28f38dc 100644
> > > --- a/include/media/v4l2-subdev.h
> > > +++ b/include/media/v4l2-subdev.h
> > > @@ -829,7 +829,7 @@ struct v4l2_subdev {
> > > 
> > >  };
> > >  
> > >  #define media_entity_to_v4l2_subdev(ent) \
> > > -	container_of(ent, struct v4l2_subdev, entity)
> > > +	(ent ? container_of(ent, struct v4l2_subdev, entity) : NULL)
> > > 
> > >  #define vdev_to_v4l2_subdev(vdev) \
> > >  	((struct v4l2_subdev *)video_get_drvdata(vdev))
> > 
> > The problem with this is that ent is now referenced twice. If the ent macro
> > argument has side effect, this would introduce bugs. It's unlikely, but
> > worth avoiding. Either use a macro or a function.
> > 
> > I think I'd use function for there's little use for supporting for const and
> > non-const arguments presumably. A simple static inline function should do.
> 
> Note that, if we want to keep using a macro, this could be written as
> 
> #define media_entity_to_v4l2_subdev(ent) ({ \
> 	typeof(ent) __ent = ent; \
> 	__ent ? container_of(__ent, struct v4l2_subdev, entity) : NULL; \
> })
> 
> Bonus point if you can come up with a way to return a const struct v4l2_subdev 
> pointer when then ent argument is const.

I can't think of a use case for that. I've never seen a const struct
v4l2_subdev anywhere. I could be just oblivious though. :-)

Better give a __ent a name that someone will not accidentally come up with.
That can lead to problems that are difficult to debug --- for the code
compiles, it just doesn't do what's expected.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

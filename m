Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:40781 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935534AbdLRXI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 18:08:59 -0500
Received: by mail-lf0-f68.google.com with SMTP id g74so9653362lfk.7
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 15:08:58 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 19 Dec 2017 00:08:56 +0100
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 02/15] rcar-vin: use pad as the starting point for
 a pipeline
Message-ID: <20171218230856.GF32148@bigcity.dyn.berto.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-3-niklas.soderlund+renesas@ragnatech.se>
 <20171215115402.uvvjkn3ltnxweqy6@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171215115402.uvvjkn3ltnxweqy6@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Tack för dina kommentarer.

On 2017-12-15 13:54:02 +0200, Sakari Ailus wrote:
> On Thu, Dec 14, 2017 at 08:08:22PM +0100, Niklas Söderlund wrote:
> > The pipeline will be moved from the entity to the pads; reflect this in
> > the media pipeline function API.
> 
> I'll merge this to "media: entity: Use pad as the starting point for a
> pipeline" if you're fine with that.

I'm fine with that, the issue is that the rcar-vin Gen3 driver is not 
yet upstream :-( If it makes it upstream before the work in your vc 
branch feel free to squash this in. Until then I fear I need to keep 
carry this in this series.

> 
> I haven't compiled everything for some time, and newly added drivers may be
> lacking these changes. I'll re-check that soonish.
> 
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> > index 03a914361a33125c..cf30e5fceb1d493a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -1179,7 +1179,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
> >  		return -EPIPE;
> >  
> >  	if (!on) {
> > -		media_pipeline_stop(&vin->vdev.entity);
> > +		media_pipeline_stop(vin->vdev.entity.pads);
> >  		return v4l2_subdev_call(sd, video, s_stream, 0);
> >  	}
> >  
> > @@ -1235,15 +1235,15 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
> >  	    fmt.format.height != vin->format.height)
> >  		return -EPIPE;
> >  
> > -	pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
> > -	if (media_pipeline_start(&vin->vdev.entity, pipe))
> > +	pipe = sd->entity.pads->pipe ? sd->entity.pads->pipe : &vin->vdev.pipe;
> > +	if (media_pipeline_start(vin->vdev.entity.pads, pipe))
> >  		return -EPIPE;
> >  
> >  	ret = v4l2_subdev_call(sd, video, s_stream, 1);
> >  	if (ret == -ENOIOCTLCMD)
> >  		ret = 0;
> >  	if (ret)
> > -		media_pipeline_stop(&vin->vdev.entity);
> > +		media_pipeline_stop(vin->vdev.entity.pads);
> >  
> >  	return ret;
> >  }
> > -- 
> > 2.15.1
> > 
> 
> -- 
> Sakari Ailus
> sakari.ailus@linux.intel.com

-- 
Regards,
Niklas Söderlund

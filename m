Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:42817 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935893AbdLRXYI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 18:24:08 -0500
Received: by mail-lf0-f65.google.com with SMTP id e30so2735053lfb.9
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 15:24:07 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 19 Dec 2017 00:24:05 +0100
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 03/15] rcar-vin: use the pad and stream aware
 s_stream
Message-ID: <20171218232405.GG32148@bigcity.dyn.berto.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-4-niklas.soderlund+renesas@ragnatech.se>
 <20171215120739.si2b27npc25zxelv@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171215120739.si2b27npc25zxelv@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej Sakari,

Tack för dina kommentarer.

On 2017-12-15 14:07:39 +0200, Sakari Ailus wrote:
> Hej,
> 
> On Thu, Dec 14, 2017 at 08:08:23PM +0100, Niklas Söderlund wrote:
> > To work with multiplexed streams the pad and stream aware s_stream
> > operation needs to be used.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-dma.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> > index cf30e5fceb1d493a..8435491535060eae 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -1180,7 +1180,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
> >  
> >  	if (!on) {
> >  		media_pipeline_stop(vin->vdev.entity.pads);
> > -		return v4l2_subdev_call(sd, video, s_stream, 0);
> > +		return v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 0);
> 
> Have you thought of adding a wrapper for the s_stream callback?

I toyed with the idea, then I reached the same conclusion you do bellow.

> 
> I think you should either change all s_stream callbacks from video to pad,
> or add a wrapper which then calls the video op instead of the pad op if the
> pad op does not exist. Otherwise we again have two non-interoperable
> classes of drivers for no good reason.

Agreed.

> 
> Thinking about it, I'm not all that certain changing all instances would be
> that much work in the end; it should be done anyway. Devices that have a
> single stream (i.e. everything right now) just don't care about the pad
> number.

I tried to cover this in the cover-letter, I believe the correct 
approach is probably to move s_stream() from video ops to pad ops in the 
long run. I did post a similar patch for this a while ago [1] but I fear 
it's outdated by now. Before I refreshed that particular patch I was 
interested on the feedback on this from this series as I don't want to 
send out a patch touching so many drivers without at least some 
discussion :-)

I would be find with both the helper and a full conversion approach. Or 
to do it in stages, add a helper now and slowly convert all drivers and 
then removing the helper. What would be your preferred way of dealing 
with this?

1.  http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2016-June/091250.html

> 
> >  	}
> >  
> >  	fmt.pad = pad->index;
> > @@ -1239,12 +1239,14 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
> >  	if (media_pipeline_start(vin->vdev.entity.pads, pipe))
> >  		return -EPIPE;
> >  
> > -	ret = v4l2_subdev_call(sd, video, s_stream, 1);
> > +	ret = v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 1);
> >  	if (ret == -ENOIOCTLCMD)
> >  		ret = 0;
> >  	if (ret)
> >  		media_pipeline_stop(vin->vdev.entity.pads);
> >  
> > +	vin_dbg(vin, "pad: %u stream: 0 enable: %d\n", pad->index, on);
> > +
> >  	return ret;
> >  }
> >  
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

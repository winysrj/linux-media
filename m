Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:45394 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbeDOSsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 14:48:17 -0400
Received: by mail-lf0-f66.google.com with SMTP id q5-v6so18937333lff.12
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 11:48:16 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sun, 15 Apr 2018 20:48:13 +0200
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180415184813.GB20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <eb0b92de-cb09-9d72-8d46-80a0359184f2@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb0b92de-cb09-9d72-8d46-80a0359184f2@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your feedback.

On 2018-03-13 23:23:49 +0100, Kieran Bingham wrote:
> Hi Niklas
> 
> Thank you for this patch ...
> I know it has been a lot of work getting this and the VIN together!
> 
> On 13/02/18 00:01, Niklas Söderlund wrote:
> > A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> > supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> > connected between the video sources and the video grabbers (VIN).
> > 
> > Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I don't think there's actually anything major in the below - so with any
> comments addressed, or specifically ignored you can add my:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks, see bellow for answers to your questions. I have removed the 
questions Laurent already have provided a reply for, thanks for doing 
that!

> 
> tag if you like.
> 
> 
> > ---
> >  drivers/media/platform/rcar-vin/Kconfig     |  12 +
> >  drivers/media/platform/rcar-vin/Makefile    |   1 +
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 884 ++++++++++++++++++++++++++++
> >  3 files changed, 897 insertions(+)
> >  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
> > 
> > diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> > index af4c98b44d2e22cb..6875f30c1ae42631 100644
> > --- a/drivers/media/platform/rcar-vin/Kconfig
> > +++ b/drivers/media/platform/rcar-vin/Kconfig
> > @@ -1,3 +1,15 @@
> > +config VIDEO_RCAR_CSI2
> > +	tristate "R-Car MIPI CSI-2 Receiver"
> > +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> 
> I think I recall recently seeing that depending upon OF is redundant and not
> necessary (though I think that's minor in this instance)

I can't seem to find anything to indicate this, but as you state if 
there is such a transition ongoing we can delete this later IMHO.

$ find . -name Kconfig -exec grep OF {} \; | grep "depends on" | wc -l
622

But I'm happy to be proven wrong and remove it now as well.

[snip]

> > +static const struct rcar_csi2_format 
> > *rcar_csi2_code_to_fmt(unsigned int code)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> > +		if (rcar_csi2_formats[i].code == code)
> > +			return rcar_csi2_formats + i;
> 
> I would have written this as:
> 	return &rcar_csi2_formats[i];  but I think your way is valid too :)

This seems to be the popular opinion among reviewers so I will adopt 
this style for the next version :-)


> 
> I have a nice 'for_each_entity_in_array' macro I keep meaning to post which
> would be nice here too - but hey - for another day.

Looking forward to it.

[snip]

> > +static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> > +{
> > +	int timeout;
> > +
> > +	/* Wait for the clock and data lanes to enter LP-11 state. */
> > +	for (timeout = 100; timeout > 0; timeout--) {
> > +		const u32 lane_mask = (1 << priv->lanes) - 1;
> > +
> > +		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) == 1 &&
> 
> The '1' is not very clear here.. Could this be:
> 
> 		if ((rcar_csi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATE) &&

Great catch I have clearly missed this define. I will call it 
PHCLM_STOPSTATECLK since that it's what the latest datasheet I have 
calls it. Thanks for pointing this out.

[snip]

> > +static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > +	struct v4l2_subdev *nextsd;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&priv->lock);
> > +
> > +	if (!priv->remote) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	nextsd = priv->remote;
> > +
> > +	if (enable && priv->stream_count == 0) {
> > +		pm_runtime_get_sync(priv->dev);
> > +
> > +		ret = rcar_csi2_start(priv);
> > +		if (ret) {
> > +			pm_runtime_put(priv->dev);
> > +			goto out;
> > +		}
> > +
> > +		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
> 
> Would it be nicer to pass 'enable' through instead of the '1'? (of course
> enable==1 here)
> 
> > +		if (ret) {
> > +			rcar_csi2_stop(priv);
> > +			pm_runtime_put(priv->dev);
> > +			goto out;
> > +		}
> > +	} else if (!enable && priv->stream_count == 1) {
> > +		rcar_csi2_stop(priv);
> > +		v4l2_subdev_call(nextsd, video, s_stream, 0);
> 
> likewise here...
> 

I agree with Laurent's comment here that it's much clearer to use 1/0 
instead of 'enable' when it comes to read the code and will keep it as 
such :-)

> > +		pm_runtime_put(priv->dev);
> > +	}
> 
> What's the 'nextsd' in this instance? We only call the s_stream on nextsd if it
> is the first one to be started, or the last one to be stopped...

The 'nextsd' here is the next subdevice towards the video source, and 
it's a CSI-2 transmitter.

> 
> I can understand this logic for calling rcar_csi2_stop/rcar_csi2_start ... but
> shouldn't we always call :
> 	v4l2_subdev_call(nextsd, video, s_stream, enable); ?

It might seem logical to do so yes, in my first try to add multiplexed 
stream support to v4l2 I even attempted to move s_stream to pad ops 
structure and extend it with a stream number argument :-) But after 
discussing it and toying with different solution this turned out to be a 
bad idea.

The CSI-2 transmitter and CSI-2 receiver needs to know about all links 
when they are started for the first time. So the first on in turns on 
everything and the last one out turns off the lights make sens here. The 
user shall only enable the links it wish to use and they shall all be 
started at the same time. Then we need this logic since we still need to 
start streaming from the different VIN instances individually and the 
CSI-2 receiver is the logical sync point to handle this as it has all 
the knowledge of the links it is involved in.

> 
> in GMSL context, I guess 'nextsd' is the MAX9286?

Yes.

> At which point - it would be called for start/stop, priv->stream_count times,
> and would also have to provide it's own call balancing...

Yes and what could it do different for each call even if it implemented 
call balancing? It have no information about which of the enabled 
multiplexed streams are started. The logic here is a s_stream() shall 
start all enabled streams, if a user don't want a stream he shall not 
enabled it in the first place. As all enabled links will be subject to 
format validation in the media pipeline I think this will sort it self 
out ;-P

> 
> Call me crazy and ignore me here if you like :-)

I will not call you crazy, but I will ignore this comment :-)

[snip]

> > +
> > +/* -----------------------------------------------------------------------------
> > + * Async and registered of subdevices and links
> 
> "Async handling and registration of subdevices and links" ?
> 
> or does of mean OF here ?

No of means of, your English is much better then mine and I will update 
it for next version, thanks.

[snip]

> > +
> > +	/* r8a7795 ES1.x behaves different then ES2.0+ but no own compat */
> 
> /*
>  * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't have it's own
>  * compatible string
>  */
> 

Ditto.

[snip]

-- 
Regards,
Niklas Söderlund

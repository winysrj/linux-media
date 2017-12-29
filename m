Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21717 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754417AbdL2LXQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 06:23:16 -0500
Date: Fri, 29 Dec 2017 13:23:10 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 05/15] rcar-csi2: count usage for each source pad
Message-ID: <20171229112309.fxgmp2kildhdojhp@kekkonen.localdomain>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-6-niklas.soderlund+renesas@ragnatech.se>
 <20171215122527.e73gr43223bvclod@paasikivi.fi.intel.com>
 <20171218233851.GH32148@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171218233851.GH32148@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan,

On Tue, Dec 19, 2017 at 12:38:51AM +0100, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Tack för dina kommentarer.
> 
> On 2017-12-15 14:25:27 +0200, Sakari Ailus wrote:
> > On Thu, Dec 14, 2017 at 08:08:25PM +0100, Niklas Söderlund wrote:
> > > The R-Car CSI-2 hardware can output the same virtual channel
> > > simultaneously to more then one R-Car VIN. For this reason we need to
> > > move the usage counting from the global device to each source pad.
> > > 
> > > If a source pads usage count go from 0 to 1 we need to signal that a new
> > > stream should start, likewise if it go from 1 to 0 we need to stop a
> > > stream. At the same time we only want to start or stop the R-Car
> > > CSI-2 device only on the first or last stream.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  drivers/media/platform/rcar-vin/rcar-csi2.c | 38 +++++++++++++++++++++++------
> > >  1 file changed, 30 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > index 8ce0bfeef1113f9c..e0f56cc3d25179a9 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > @@ -328,6 +328,14 @@ enum rcar_csi2_pads {
> > >  	NR_OF_RCAR_CSI2_PAD,
> > >  };
> > >  
> > > +static int rcar_csi2_pad_to_vc(unsigned int pad)
> > > +{
> > > +	if (pad < RCAR_CSI2_SOURCE_VC0 || pad > RCAR_CSI2_SOURCE_VC3)
> > > +		return -EINVAL;
> > > +
> > > +	return pad - RCAR_CSI2_SOURCE_VC0;
> > > +}
> > > +
> > >  struct rcar_csi2_info {
> > >  	const struct phypll_hsfreqrange *hsfreqrange;
> > >  	const struct phtw_testdin_data *testdin_data;
> > > @@ -350,7 +358,7 @@ struct rcar_csi2 {
> > >  	struct v4l2_mbus_framefmt mf;
> > >  
> > >  	struct mutex lock;
> > > -	int stream_count;
> > > +	int stream_count[4];
> > 
> > Why 4?
> 
> There are 4 source pads connected to up to 8 different remote sink pads.

Could you use a #define (macro) for these numbers?

> 
> > 
> > >  
> > >  	unsigned short lanes;
> > >  	unsigned char lane_swap[4];
> > > @@ -630,7 +638,13 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
> > >  {
> > >  	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > >  	struct v4l2_subdev *nextsd;
> > > -	int ret;
> > > +	unsigned int i, count = 0;
> > > +	int ret, vc;
> > > +
> > > +	/* Only allow stream control on source pads and valid vc */
> > > +	vc = rcar_csi2_pad_to_vc(pad);
> > > +	if (vc < 0)
> > > +		return vc;
> > >  
> > >  	/* Only one stream on each source pad */
> > >  	if (stream != 0)
> > > @@ -642,7 +656,10 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
> > >  	if (ret)
> > >  		goto out;
> > >  
> > > -	if (enable && priv->stream_count == 0) {
> > > +	for (i = 0; i < 4; i++)
> > > +		count += priv->stream_count[i];
> > > +
> > > +	if (enable && count == 0) {
> > >  		pm_runtime_get_sync(priv->dev);
> > >  
> > >  		ret = rcar_csi2_start(priv);
> > > @@ -650,20 +667,23 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
> > >  			pm_runtime_put(priv->dev);
> > >  			goto out;
> > >  		}
> > > +	} else if (!enable && count == 1) {
> > > +		rcar_csi2_stop(priv);
> > > +		pm_runtime_put(priv->dev);
> > > +	}
> > >  
> > > +	if (enable && priv->stream_count[vc] == 0) {
> > >  		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
> > >  		if (ret) {
> > >  			rcar_csi2_stop(priv);
> > >  			pm_runtime_put(priv->dev);
> > >  			goto out;
> > >  		}
> > > -	} else if (!enable && priv->stream_count == 1) {
> > > -		rcar_csi2_stop(priv);
> > > +	} else if (!enable && priv->stream_count[vc] == 1) {
> > 
> > Do I understand correctly that you can start and streams here one by one,
> > independently of each other?
> 
> That is still an area we are figuring out. At this time I don't know if 
> the hardware is capable of starting and stopping individual streams. We 
> are working with our setup to try and get stuff up and running but we 
> are having issues at our sensor side. For our experiments I wished to 
> prepare to test this as I know I can route a single CSI-2 VC to more 
> then one video device consumer and start and stop them independently.
> 
> Maybe it will be different once we manage to get more simultaneously VCs 
> running.

I guess most hardware needs to be fully configured with all streams and
what not until it can be started. Could you figure this out from the
configured routes?

> 
> > 
> > Sometimes this might not be the case. I wonder if we should have a way to
> > tell that to the caller.
> 
> You make a good point. How should this really be handeld? Maybe I'm to 
> focused on my test setup which might not work as I think it dose. Would 
> you say a better approach would be to drop the stream parameter to pad 
> ops s_stream() and just start all streams of routes who are enabled? 

Good questions. V4L2 streams start one by one, but if this functionality is
moved to Media controller (with request API, as discussed in Prague
(meeting notes still pending)), there should be a way to tell to start
multiple streams at once.

V4L2 doesn't really have a concept of a stream and starting and stopping a
stream is dependent on streaming start and stop on the video node. That
works as long as there is a video node related to the stream. It'd be nice
to address that at the same time. In any case, that won't happen in the
near future.

For now, I guess we can just proceed with the current implementation
(s_stream pad op, with integer argument specifying the stream). Drivers
that need to start streaming until everything is configured, wait until
this is the case and then continue propagating the streaming state.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com

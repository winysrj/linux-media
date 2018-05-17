Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37355 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbeEQLF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:05:29 -0400
Received: by mail-lf0-f66.google.com with SMTP id r2-v6so8132582lff.4
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 04:05:28 -0700 (PDT)
Date: Thu, 17 May 2018 13:05:25 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/4] media: rcar-vin: Parse digital input in mc-path
Message-ID: <20180517110524.GB2082@bigcity.dyn.berto.se>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526473016-30559-2-git-send-email-jacopo+renesas@jmondi.org>
 <20180516203249.GB17838@bigcity.dyn.berto.se>
 <20180517101306.GX5956@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180517101306.GX5956@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-05-17 12:13:06 +0200, Jacopo Mondi wrote:
> Hi Niklas,
>    thanks for review.
> 
> On Wed, May 16, 2018 at 10:32:49PM +0200, Niklas S�derlund wrote:
> > Hi Jacopo,
> >
> > Thanks for your work!
> >
> > First let me apologies for the use of the keyword 'digital' in the
> > driver it should have been parallel... Someday we should remedy this.
> >
> > If you touch any parts of the code where such a transition make sens I
> > would not complain about the intermixed use of digital/parallel. Once
> > your work is done we could follow up with a cleanup patch to complete
> > the transition. Or if you rather stick with digital here I'm fine with
> > that too.
> 
> I would go with a major s/digital/parallel/ after this has been
> merged, if that' fine with you.

I'm totally fine whit that.

> >
> > On 2018-05-16 14:16:53 +0200, Jacopo Mondi wrote:
> > > Add support for digital input subdevices to Gen-3 rcar-vin.
> > > The Gen-3, media-controller compliant, version has so far only accepted
> > > CSI-2 input subdevices. Remove assumptions on the supported bus_type and
> > > accepted number of subdevices, and allow digital input connections on port@0.
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  drivers/media/platform/rcar-vin/rcar-core.c | 99 +++++++++++++++++++++++------
> > >  drivers/media/platform/rcar-vin/rcar-vin.h  | 15 +++++
> > >  2 files changed, 93 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > > index d3072e1..0ea21ab 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > > @@ -562,7 +562,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
> > >  		return ret;
> > >
> > >  	if (!vin->digital)
> > > -		return -ENODEV;
> > > +		return -ENOTCONN;
> > >
> > >  	vin_dbg(vin, "Found digital subdevice %pOF\n",
> > >  		to_of_node(vin->digital->asd.match.fwnode));
> > > @@ -703,15 +703,13 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
> > >  {
> > >  	struct rvin_dev *vin = dev_get_drvdata(dev);
> > >
> > > -	if (vep->base.port != 1 || vep->base.id >= RVIN_CSI_MAX)
> > > +	if (vep->base.port != RVIN_PORT_CSI2 || vep->base.id >= RVIN_CSI_MAX)
> >
> > I don't like this RVIN_PORT_CSI2. It makes the code harder to read as I
> > have have to go and lookup which port RVIN_PORT_CSI2 represents. I would
> 
> Why do you have to go and look? It's an enum, it abstracts away the numerical
> value it represents with a human readable string. If you want to check
> which number it represent you can got and look at the enum definition,
> once. While reading the code, the most important part is "this is the CSI-2
> port" or "this is port 1"? You wrote the driver and for you there is
> no ambiguity there, I understand.
> 
> > rater just keep vep->base.port != 1 as I think it's much clearer whats
> > going on. And it's not as we will move the CSI-2 input to a different
> > port as it's described in the bindings.
> 
> That's one more reason to have an enum for that.
> 
> Anyway, that's pure bikeshedding, I like discussing these things
> too but I'm surely not making an argument for this. If you don't like
> the enum I'll remove that.

I'm sorry, I don't like the enum :-(

> 
> >
> > >  		return -EINVAL;
> > >
> > >  	if (!of_device_is_available(to_of_node(asd->match.fwnode))) {
> > > -
> > >  		vin_dbg(vin, "OF device %pOF disabled, ignoring\n",
> > >  			to_of_node(asd->match.fwnode));
> > >  		return -ENOTCONN;
> > > -
> > >  	}
> > >
> > >  	if (vin->group->csi[vep->base.id].fwnode) {
> > > @@ -720,6 +718,8 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
> > >  		return -ENOTCONN;
> > >  	}
> > >
> > > +	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> > > +	vin->mbus_cfg.flags = 0;
> >
> > I like this move of mbus_cfg handling! Makes the two cases more aligned
> > which are good. Unfortunately I fear it needs more work :-(
> >
> > With this series addition of parallel input support. There are now two
> > input types CSI-2 and parallel which can be changed at runtime for the
> > same VIN. The mbus connected to the VIN will therefor be different
> 
> Wait, are you suggesting the parallel input connection can be switched
> with CSI-2 ones at runtime? I undestand the CSI-2 - VIN routing as the
> physical connections are already in place in the SoC, but if we're
> connecting a parallel input to a VIN instance that accepts an input
> connection then that hardly can be switched to another port with a
> software configuration.

Sure it can. Check 'Figure 26.2.1 Functional Block Diagram of Video 
Input Modules 4 to 7 (VIN4 to VIN7) (R-Car H3, M3-W)'. Here VIN4 and 
VIN5 can have both a parallel input and a CSI-2 input.

In the block diagram the "CSI or Digial Pin" is the VNMC_DPINE register 
and the "CSI select" is the VNCSI_IFMD_CSI_CHSEL register. So the media 
graph will should just have one more entity for the parallel input 
device and add the appropriate route. Then the link notifier needs to 
handle the logic so that when s_stream() is called the driver knows how 
to set these registers*.

* VNCSI_IFMD_CSI_CHSEL is not handled at s_stream() time as it's shared 
  between VIN's and is the reason we need this awesome (tm) group 
  concept..

> 
> My understanding was even different: when a port has a digital video
> input connected, a CSI-2 input cannot be routed there, because, well,
> there is already a non modifiable connection, possibly part of the PCB
> design.
> 
> > depending on which media graph link is connected to a particular VIN and
> > this effects hardware configuration, see 'vin->mbus_cfg.type ==
> > V4L2_MBUS_CSI2' in rvin_setup().
> >
> > Maybe the best solution is to move mbus_cfg into struct
> > rvin_graph_entity, rename that struct rvin_parallel_input and cache the
> > parallel input settings in there, much like we do today for the pads.
> > Remove mbus_cfg from struct rvin_dev and replace it with a bool flag
> > (input_csi or similar)?
> 
> I'm sorry I'm not following here. The mbus config is not a 'group'
> property, but it may differ for each VIN with a parallel input
> connected.

Yes. The struct rvin_graph_entity is only used to deal with the parallel 
input in the code path and is only ever associated with a struct 
rvin_dev and not with a struct rvin_group so this should be fine :-)

> 
> >
> > In rvin_setup() use this flag to check which input type is in use and if
> > it's needed fetch mbus_cfg from this cache. Then in
> > rvin_group_link_notify() you could handle this input_csi flag depending
> > on which link is activated. But I'm open to other solutions.
> >
> 
> I think we have to clarify first a fundamental issue here: can a CSI-2
> connection be routed to a VIN with a digital input connected? I think
> no, there are wirings that have to be set in place, and they are
> described by DT with the connection to port@0. Each VIN with a
> connection on port@0 does not even parse port@1, as the two are
> mutually exclusive. It seems to me you think instead they can co-exist
> and software can chose between which one of the two to enable (I
> assume through the DPINE bit setting).

Exactly DPINE is the control for if parallel or CSI-2 is 'routed' to the 
VIN.

> 
> > >  	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
> > >
> > >  	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
> > > @@ -742,7 +742,14 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
> > >  		return -EINVAL;
> > >  	}
> > >
> > > -	/* If not all VIN's are registered don't register the notifier. */
> > > +	/* Collect digital subdevices in this VIN device node. */
> > > +	ret = rvin_digital_graph_init(vin);
> > > +	if (ret < 0 && ret != -ENOTCONN) {
> > > +		mutex_unlock(&vin->group->lock);
> > > +		return ret;
> > > +	}
> >
> > Why do you need to add this here? Is it not better to in
> > rcar_vin_probe() do something like:
> >
> >     ret = rvin_digital_graph_init(vin);
> >     if (ret < 0)
> >         goto error;
> >
> >     if (vin->info->use_mc) {
> >         ret = rvin_mc_init(vin);
> >         if (ret < 0)
> >             goto error;
> >     }
> >
> > That way we can try and keep to two code paths separated and at lest for
> > me that increases readability a lot.
> 
> That was your first suggestion, I moved it there because I assumed I
> need the 'group' to be initialized for each VIN we're about to parse
> digital connections from, but as we defer notifiers registration until
> all VINs have probed, that's actually not an issue afaict.

Then I'm sorry I must have expressed myself in a inadequate way or I'm 
misunderstanding you now. Let's have a chat about this to clear it up 
:-) Maybe future changes this change is sound, but for this patch-set I 
think doing it in probe would be nicer.

> 
> >
> > > +
> > > +	/* Only the last registered VIN instance collects CSI-2 subdevices. */
> > >  	for (i = 0; i < RCAR_VIN_NUM; i++)
> > >  		if (vin->group->vin[i])
> > >  			count++;
> > > @@ -752,22 +759,33 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
> > >  		return 0;
> > >  	}
> > >
> > > -	/*
> > > -	 * Have all VIN's look for subdevices. Some subdevices will overlap
> > > -	 * but the parser function can handle it, so each subdevice will
> > > -	 * only be registered once with the notifier.
> > > -	 */
> > > -
> > > -	vin->group->notifier = &vin->notifier;
> > > -
> > > +	vin->group->notifier = NULL;
> > >  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> > > +		struct v4l2_async_notifier *notifier;
> > > +
> > >  		if (!vin->group->vin[i])
> > >  			continue;
> > >
> > > +		/* This VIN alread has digitial subdevices registered, skip. */
> > > +		notifier = &vin->group->vin[i]->notifier;
> > > +		if (notifier->num_subdevs)
> > > +			continue;
> >
> > I'm afraid this won't work :-(
> >
> > v4l2_async_notifier_parse_fwnode_endpoints_by_port() must be called on
> > all VINs in the group using the same notifier else there is a potential
> > subdevices can be missed.
> 
> Again, I'm assuming digital and CSI-2 subdevices cannot live together.
> 
> >
> > > +
> > > +		/* This VIN instance notifier will collect all CSI-2 subdevs. */
> > > +		if (!vin->group->notifier) {
> > > +			vin->group->v4l2_dev = &vin->group->vin[i]->v4l2_dev;
> >
> > The vin->group structure should only hold data which is as much as
> > possible only associate with the group. This feels like a step backwards
> > :-(
> 
> Why? the v4l2_dev is global to the group as the notifier is. I don't
> see any difference between the notifier and the v4l2_dev.
> 
> >
> > It's a real shame that v4l2_async_notifier_register() needs a video
> > device at all else we could make the notifier part of the struct
> > rvin_group and then have a specific VIN local notifier for the parallel
> > inputs.
> 
> I would rather create a group notifier for CSI-2 subdevices instead of
> reusing the one from the last probed VIN. We would need a v4l2_dev
> though, and that may only come from some VIN instance if I'm not
> wrong.

I think that is an idea worth exploring. Making the notifier in struct 
rvin_group not a pointer but a new separate notifier for the group I 
think is a great idea. And sometime in the future we should strive to 
remove the vdev argument and need for in the notifier registration 
process :-)

> 
> >
> > > +			vin->group->notifier = &vin->group->vin[i]->notifier;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Some CSI-2 subdevices will overlap but the parser function
> > > +		 * can handle it, so each subdevice will only be registered
> > > +		 * once with the group notifier.
> > > +		 */
> > >  		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> > >  				vin->group->vin[i]->dev, vin->group->notifier,
> > > -				sizeof(struct v4l2_async_subdev), 1,
> > > -				rvin_mc_parse_of_endpoint);
> > > +				sizeof(struct v4l2_async_subdev),
> > > +				RVIN_PORT_CSI2, rvin_mc_parse_of_endpoint);
> > >  		if (ret) {
> > >  			mutex_unlock(&vin->group->lock);
> > >  			return ret;
> > > @@ -776,25 +794,64 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
> > >
> > >  	mutex_unlock(&vin->group->lock);
> > >
> > > -	vin->group->notifier->ops = &rvin_group_notify_ops;
> > > +	/*
> > > +	 * Go and register all notifiers for digital subdevs, and
> > > +	 * the group notifier for CSI-2 subdevs, if any.
> > > +	 */
> > > +	for (i = 0; i < RCAR_VIN_NUM; i++) {
> > > +		struct rvin_dev *ivin = vin->group->vin[i];
> > > +		struct v4l2_async_notifier *notifier;
> > >
> > > -	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> > > +		if (!ivin)
> > > +			continue;
> > > +
> > > +		notifier = &ivin->notifier;
> > > +		if (notifier == vin->group->notifier ||
> > > +		    !notifier->num_subdevs)
> > > +			continue;
> > > +
> > > +		notifier->ops = &rvin_digital_notify_ops;
> > > +		ret = v4l2_async_notifier_register(&ivin->v4l2_dev, notifier);
> > > +		if (ret < 0) {
> > > +			vin_err(ivin, "Notifier registration failed\n");
> > > +			goto error_unregister_notifiers;
> > > +		}
> > > +	}
> > > +
> > > +	if (!vin->group->notifier || !vin->group->notifier->num_subdevs)
> > > +		return 0;
> > > +
> > > +	vin->group->notifier->ops = &rvin_group_notify_ops;
> > > +	ret = v4l2_async_notifier_register(vin->group->v4l2_dev,
> > > +					   vin->group->notifier);
> > >  	if (ret < 0) {
> > >  		vin_err(vin, "Notifier registration failed\n");
> > >  		return ret;
> > >  	}
> > >
> > >  	return 0;
> > > +
> > > +error_unregister_notifiers:
> > > +	for (; i > 0; i--) {
> >
> > As this is an error path it feels a bit to optimised.
> >
> >     for (i = 0; i < RCAR_VIN_NUM; i++)
> >
> 
> Looping for more iterations than necessary is not exactly an
> optimization imho. By the way, we're talking about 8 iteration more
> top and only during an error path, so I assume this is just more
> readable in your opinion and it justifies this very few extra
> loops.

Yes and seeing "for (; i > 0; i--)" scares me as I don't know what i is 
before the jump. Sometimes such things are needed, but for this case I 
think readability is a better option :-)

> 
> > With the same checks as bellow would work just as good with the checks
> > you have bellow. v4l2_async_notifier_unregister() checks if it's called
> > with a notifier that have not been registered and does the right thing.
> 
> I assume you meant I can call v4l2_async_notifier_unregister()
> unconditionally, right?

Yes.

> 
> >
> > > +		struct v4l2_async_notifier *notifier;
> > > +
> > > +		if (!vin->group->vin[i - 1])
> > > +			continue;
> > > +
> > > +		notifier = &vin->group->vin[i - 1]->notifier;
> > > +		if (!notifier->num_subdevs)
> > > +			continue;
> > > +
> > > +		v4l2_async_notifier_unregister(notifier);
> > > +	}
> > > +
> > > +	return ret;
> > >  }
> > >
> > >  static int rvin_mc_init(struct rvin_dev *vin)
> > >  {
> > >  	int ret;
> > >
> > > -	/* All our sources are CSI-2 */
> > > -	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> > > -	vin->mbus_cfg.flags = 0;
> > > -
> > >  	vin->pad.flags = MEDIA_PAD_FL_SINK;
> > >  	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > >  	if (ret)
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> > > index c2aef78..836751e 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > > @@ -52,6 +52,19 @@ enum rvin_csi_id {
> > >  };
> > >
> > >  /**
> > > + * enum rvin_port_id
> > > + *
> > > + * List the available VIN port functions.
> > > + *
> > > + * RVIN_PORT_DIGITAL	- Input port for digital video connection
> > > + * RVIN_PORT_CSI2	- Input port for CSI-2 video connection
> > > + */
> > > +enum rvin_port_id {
> > > +	RVIN_PORT_DIGITAL,
> > > +	RVIN_PORT_CSI2
> > > +};
> > > +
> > > +/**
> > >   * STOPPED  - No operation in progress
> > >   * RUNNING  - Operation in progress have buffers
> > >   * STOPPING - Stopping operation
> > > @@ -225,6 +238,7 @@ struct rvin_dev {
> > >   *
> > >   * @lock:		protects the count, notifier, vin and csi members
> > >   * @count:		number of enabled VIN instances found in DT
> > > + * @v4l2_dev:		pointer to the group v4l2 device
> >
> > I pray there is a away to avoid adding this here, it feels awkward :-(
> 
> I still don't see why its more awkward that re-using a notifier from a
> VIN instance.
> 
> Thanks
>    j
> >
> > >   * @notifier:		pointer to the notifier of a VIN which handles the
> > >   *			groups async sub-devices.
> > >   * @vin:		VIN instances which are part of the group
> > > @@ -238,6 +252,7 @@ struct rvin_group {
> > >
> > >  	struct mutex lock;
> > >  	unsigned int count;
> > > +	struct v4l2_device *v4l2_dev;
> > >  	struct v4l2_async_notifier *notifier;
> > >  	struct rvin_dev *vin[RCAR_VIN_NUM];
> > >
> > > --
> > > 2.7.4
> > >
> >
> > --
> > Regards,
> > Niklas S�derlund



-- 
Regards,
Niklas S�derlund

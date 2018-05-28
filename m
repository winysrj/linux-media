Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:56200 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754537AbeE1Nuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 09:50:39 -0400
Received: by mail-wm0-f66.google.com with SMTP id a8-v6so32324352wmg.5
        for <linux-media@vger.kernel.org>; Mon, 28 May 2018 06:50:38 -0700 (PDT)
Date: Mon, 28 May 2018 15:50:36 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 5/9] media: rcar-vin: Parse parallel input on Gen3
Message-ID: <20180528135036.GB27709@bigcity.dyn.berto.se>
References: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527199339-7724-6-git-send-email-jacopo+renesas@jmondi.org>
 <20180524222944.GI31036@bigcity.dyn.berto.se>
 <20180525115008.GL18369@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180525115008.GL18369@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-05-25 13:50:08 +0200, Jacopo Mondi wrote:
> Hi Niklas,
>    I might have another question before sending v5.
> 
> On Fri, May 25, 2018 at 12:29:44AM +0200, Niklas Söderlund wrote:
> > Hi Jacopo,
> >
> > Thanks for your work.
> >
> > I really like what you did with this patch in v4.
> >
> > On 2018-05-25 00:02:15 +0200, Jacopo Mondi wrote:
> > > The rcar-vin driver so far had a mutually exclusive code path for
> > > handling parallel and CSI-2 video input subdevices, with only the CSI-2
> > > use case supporting media-controller. As we add support for parallel
> > > inputs to Gen3 media-controller compliant code path now parse both port@0
> > > and port@1, handling the media-controller use case in the parallel
> > > bound/unbind notifier operations.
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > >
> > > ---
> > > v3 -> v4:
> > > - Change the mc/parallel initialization order. Initialize mc first, then
> > >   parallel
> > > - As a consequence no need to delay parallel notifiers registration, the
> > >   media controller is set up already when parallel input got parsed,
> > >   this greatly simplify the group notifier complete callback.
> > > ---
> > >  drivers/media/platform/rcar-vin/rcar-core.c | 56 ++++++++++++++++++-----------
> > >  1 file changed, 35 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > > index a799684..29619c2 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > > @@ -399,6 +399,11 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
> > >  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> > >  	vin->parallel->sink_pad = ret < 0 ? 0 : ret;
> > >
> > > +	if (vin->info->use_mc) {
> > > +		vin->parallel->subdev = subdev;
> > > +		return 0;
> > > +	}
> > > +
> > >  	/* Find compatible subdevices mbus format */
> > >  	vin->mbus_code = 0;
> > >  	code.index = 0;
> > > @@ -460,10 +465,12 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
> > >  static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
> > >  {
> > >  	rvin_v4l2_unregister(vin);
> > > -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > > -
> > > -	vin->vdev.ctrl_handler = NULL;
> > >  	vin->parallel->subdev = NULL;
> > > +
> > > +	if (!vin->info->use_mc) {
> > > +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > > +		vin->vdev.ctrl_handler = NULL;
> > > +	}
> > >  }
> > >
> > >  static int rvin_parallel_notify_complete(struct v4l2_async_notifier *notifier)
> > > @@ -552,18 +559,18 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
> > >  	return 0;
> > >  }
> > >
> > > -static int rvin_parallel_graph_init(struct rvin_dev *vin)
> > > +static int rvin_parallel_init(struct rvin_dev *vin)
> > >  {
> > >  	int ret;
> > >
> > > -	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > > -		vin->dev, &vin->notifier,
> > > -		sizeof(struct rvin_parallel_entity), rvin_parallel_parse_v4l2);
> > > +	ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> > > +		vin->dev, &vin->notifier, sizeof(struct rvin_parallel_entity),
> > > +		0, rvin_parallel_parse_v4l2);
> > >  	if (ret)
> > >  		return ret;
> > >
> > >  	if (!vin->parallel)
> > > -		return -ENODEV;
> > > +		return -ENOTCONN;
> >
> > I think you still should return -ENODEV here if !vin->info->use_mc to
> > preserve Gen2 which runs without media controller behavior. How about:
> >
> >     return vin->info->use_mc ? -ENOTCONN : -ENODEV;
> >
> > >
> > >  	vin_dbg(vin, "Found parallel subdevice %pOF\n",
> > >  		to_of_node(vin->parallel->asd.match.fwnode));
> > > @@ -784,14 +791,8 @@ static int rvin_mc_init(struct rvin_dev *vin)
> > >  {
> > >  	int ret;
> > >
> > > -	vin->pad.flags = MEDIA_PAD_FL_SINK;
> > > -	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > > -	if (ret)
> > > -		return ret;
> > > -
> > > -	ret = rvin_group_get(vin);
> > > -	if (ret)
> > > -		return ret;
> > > +	if (!vin->info->use_mc)
> > > +		return 0;
> > >
> > >  	ret = rvin_mc_parse_of_graph(vin);
> > >  	if (ret)
> > > @@ -1074,11 +1075,24 @@ static int rcar_vin_probe(struct platform_device *pdev)
> > >  		return ret;
> > >
> > >  	platform_set_drvdata(pdev, vin);
> > > -	if (vin->info->use_mc)
> > > -		ret = rvin_mc_init(vin);
> > > -	else
> > > -		ret = rvin_parallel_graph_init(vin);
> > > -	if (ret < 0)
> > > +
> > > +	if (vin->info->use_mc) {
> > > +		vin->pad.flags = MEDIA_PAD_FL_SINK;
> > > +		ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		ret = rvin_group_get(vin);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> >
> > I don't see why you need to move the media pad creation out of
> > rvin_mc_init(). With the reorder of the rvin_mc_init()
> > rvin_parallel_init() I would keep this in rvin_mc_init().
> >
> > > +
> > > +	ret = rvin_mc_init(vin);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = rvin_parallel_init(vin);
> > > +	if (ret < 0 && ret != -ENOTCONN)
> > >  		goto error;
> > >
> > >  	pm_suspend_ignore_children(&pdev->dev, true);
> 
> I've been looking at the error path handling now that the code looks
> like this in the forthcoming v5:
> 
> 	if (vin->info->use_mc) {
> 		ret = rvin_mc_init(vin);
> 		if (ret)
> 			goto error_dma_unregister;
> 	}
> 
> 	ret = rvin_parallel_init(vin);
> 	if (ret)
> 		goto error_group_unregister;
> 
> 
>         ...
> 
> 
> error_group_unreg:
> 	if (vin->info->use_mc) {
> 		mutex_lock(&vin->group->lock);
> 		if (&vin->v4l2_dev == vin->group->notifier.v4l2_dev) {
> 			v4l2_async_notifier_unregister(&vin->group->notifier);
> 			v4l2_async_notifier_cleanup(&vin->group->notifier);
> 		}
> 		mutex_unlock(&vin->group->lock);
> 		rvin_group_put(vin);
> 	}
> 
> error_dma_unreg:
> 	rvin_dma_unregister(vin);
> 
> 	return ret;
> 
> Question is, do you think the group notifier should be unregistered
> and cleaned up if the parallel input initialization of the VIN
> instance whose v4l2_dev is used to register the group notifier fails?
> 
> I feel like it should, as the VIN instance whose v4l2_dev is used is
> always the last probing one, so there should be no issues with other
> VINs registering after it and finding themselves without a valid
> notifier.

I agree with you. If the parallel initialization fails everything done 
by that particular VIN probe should be undone. So if it have registered 
the group notifier it should unregister it.

> 
> I felt like it was better anticipating this to you instead of adding
> this part out of the blue in v5.
> 
> Also, I think in both parallel input and mc notifier registration, the
> notifier should be cleaned up to release the parsed async subdevices
> memory allocated by
> v4l2_async_notifier_parse_fwnode_endpoints_by_port() if the
> sub-sequent v4l2_async_notifier_register() fails.

I agree with you here as well. That this memory should be cleaned up, 
nice catch.

> 
> That would be:
> 
> @@ -781,18 +782,29 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>                                            &vin->group->notifier);
>         if (ret < 0) {
>                 vin_err(vin, "Notifier registration failed\n");
> -               return ret;
> +               goto error_clean_up_notifier;
>         }
> 
>         return 0;
> +
> +error_clean_up_notifier:
> +       v4l2_async_notifier_cleanup(&vin->group->notifier);
> +
> +       return ret;
>  }
> 
> in both mc and parallel initialization functions.
> 
> With your ack I can send two patches on top of the currently merged VIN
> version, and rebase my series on top eventually.
> 
> Sorry for the long email.
> 
> Thanks
>    j
> 
> 
> > > --
> > > 2.7.4
> > >
> >
> > --
> > Regards,
> > Niklas Söderlund



-- 
Regards,
Niklas Söderlund

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35632 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752748AbdF2MP7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 08:15:59 -0400
Received: by mail-lf0-f49.google.com with SMTP id b207so51584324lfg.2
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 05:15:58 -0700 (PDT)
Date: Thu, 29 Jun 2017 14:15:51 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
Message-ID: <20170629121550.GR30481@bigcity.dyn.berto.se>
References: <20170524001353.13482-1-niklas.soderlund@ragnatech.se>
 <20170524001353.13482-3-niklas.soderlund@ragnatech.se>
 <c81499b3-b875-af4a-6e0a-8e66412d3cf4@xs4all.nl>
 <20170612144850.GK17461@bigcity.dyn.berto.se>
 <22bf8ad0-c93c-e858-bf95-75338940997f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22bf8ad0-c93c-e858-bf95-75338940997f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

On 2017-06-19 13:44:22 +0200, Hans Verkuil wrote:
> On 06/12/2017 04:48 PM, Niklas Söderlund wrote:
> > Hi Hans,
> > 
> > Thanks for your comments.
> > 
> > On 2017-05-29 13:16:23 +0200, Hans Verkuil wrote:
> > > On 05/24/2017 02:13 AM, Niklas Söderlund wrote:
> > > > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > > 
> > > > A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> > > > supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2
> > > > hardware blocks are connected between the video sources and the video
> > > > grabbers (VIN).
> > > > 
> > > > Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> > > > 
> > > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > > ---
> > > >    drivers/media/platform/rcar-vin/Kconfig     |  12 +
> > > >    drivers/media/platform/rcar-vin/Makefile    |   1 +
> > > >    drivers/media/platform/rcar-vin/rcar-csi2.c | 867 ++++++++++++++++++++++++++++
> > > >    3 files changed, 880 insertions(+)
> > > >    create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
> > > > 
> 
> > > > +static int rcar_csi2_registered(struct v4l2_subdev *sd)
> > > > +{
> > > > +	struct rcar_csi2 *priv = container_of(sd, struct rcar_csi2, subdev);
> > > > +	struct v4l2_async_subdev **subdevs = NULL;
> > > > +	int ret;
> > > > +
> > > > +	subdevs = devm_kzalloc(priv->dev, sizeof(*subdevs), GFP_KERNEL);
> > > > +	if (subdevs == NULL)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	subdevs[0] = &priv->remote.asd;
> > > > +
> > > > +	priv->notifier.num_subdevs = 1;
> > > > +	priv->notifier.subdevs = subdevs;
> > > > +	priv->notifier.bound = rcar_csi2_notify_bound;
> > > > +	priv->notifier.unbind = rcar_csi2_notify_unbind;
> > > > +	priv->notifier.complete = rcar_csi2_notify_complete;
> > > > +
> > > > +	ret = v4l2_async_subnotifier_register(&priv->subdev, &priv->notifier);
> > > > +	if (ret < 0) {
> > > > +		dev_err(priv->dev, "Notifier registration failed\n");
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > Hmm, I'm trying to understand this, and I got one question. There are at least
> > > two complete callbacks: rcar_csi2_notify_complete and the bridge driver's
> > > complete callback. Am I right that the bridge driver's complete callback is
> > > called as soon as this function exists (assuming this is the only subdev)?
> > 
> > Yes (at least for the async case).
> > 
> > In v4l2_async_test_notify() calls v4l2_device_register_subdev() which in
> > turns calls this registered callback. v4l2_async_test_notify() then go
> > on and calls the notifiers complete callback.
> > 
> > In my case I have (in the simplified case) AD7482 -> CSI-2 -> VIN. Where
> > VIN is the video device and CSI-2 is the subdevice of VIN while the
> > ADV7482 is a subdevice to the CSI-2. In that case the call graph would
> > be:
> > 
> > v4l2_async_test_notify()                (From VIN on the CSI-2 subdev)
> >    v4l2_device_register_subdev()
> >      sd->internal_ops->registered(sd);   (sd == CSI-2 subdev)
> >        v4l2_async_subnotifier_register() (CSI-2 notifier for the ADV7482 subdev)
> >          v4l2_async_test_notify()        (From CSI-2 on the ADV7482) [1]
> >    notifier->complete(notifier);         (on the notifier from VIN)
> > 
> > > 
> > > So the bridge driver thinks it is complete when in reality this subdev may
> > > be waiting on newly registered subdevs?
> > 
> > Yes if the ADV7482 subdevice are not already registered in [1] above the
> > VIN complete callback would be called before the complete callback have
> > been called on the notifier register from the CSI-2 registered callback.
> > Instead that would be called once the ADV7482 calls
> > v4l2_async_register_subdev().
> > 
> > > 
> > > If I am right, then my question is if that is what we want. If I am wrong,
> > > then what did I miss?
> > 
> > I think that is what we want?
> > 
> >  From the VIN point of view all the subdevices it registered in it's
> > notifier have been found and bound right so I think it's correct to call
> > the complete callback for that notifier at this point?  If it really
> > cared about that all devices be present before it calls it complete
> > callback should it not also add all devices to its own notifier list?
> > 
> > But I do see your point that the VIN really have no way of telling if
> > all devices are present and we are ready to start to stream. This
> > however will be found out with a -EPIPE error if a stream is tried to be
> > started since the CSI-2 driver will fail to verify the pipeline since it
> > have no subdevice attached to its source pad. What do you think?
> 
> I think this is a bad idea. From the point of view of the application you
> expect that once the device nodes appear they will also *work*. In this
> case it might not work because one piece is still missing. So applications
> would have to know that if they get -EPIPE, then if they wait for a few
> seconds it might suddenly work because the last component was finally
> loaded. That's IMHO not acceptable and will drive application developers
> crazy.
> 
> In the example above the CSI-2 subdev can't tell VIN that it is complete
> when it is still waiting for the ADV7482. Because it *isn't* complete.
> 
> It is also unexpected: if A depends on B and B depends on C and D, then
> you expect that B won't tell A that is it ready unless C and D are both
> loaded.

You are not alone, I have received additional feedback which also did 
not like this idea. So I be happy to try and find a way to sort this 
out.

> 
> I was planning to merge this patch today: https://patchwork.linuxtv.org/patch/41834/
> 
> But I've decided to hold off on it for a bit in case changes are needed
> to solve this particular issue. I think it is better to add that patch
> as part of this driver's patch series.

I think it was a good call to hold of this patch. I have been presented 
with an alternative idea from Laurent on how one could get incremental 
async feature using a single notifier hence solving the dependency 
problem. I will try to implement this idea and include it as a patch in 
the next version of this series.

> 
> Regards,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund

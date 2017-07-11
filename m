Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755800AbdGKOsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 10:48:21 -0400
Date: Tue, 11 Jul 2017 17:48:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
Message-ID: <20170711144816.xesxewero6gspft7@valkosipuli.retiisi.org.uk>
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

Hi Hans and Niklas,

On Mon, Jun 19, 2017 at 01:44:22PM +0200, Hans Verkuil wrote:
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

Typically modules are loaded at system bootup, so there's not much chance
of this happening. The user can also detect this from the fact that there
are sub-devices that have pads without links. The MUST_CONNECT pad flag
should be set on such pads in any case: this is actually how the user could
detect the situation.

But then to why I replied to your e-mail, which is that there are other
problems as well. Such as the complete callback itself.

Imagine a system with a single ISP and multiple cameras. Or don't even
imagine one, just take an example from what we'll already have: even
omap3isp supports multiple cameras. The Intel CIO2 device will support
multiple cameras, too.

Each of the cameras can be used independently, but right now a fault in
probing any of the sensors (or other components in the system for that
matter, such as soon supposedly lens, flash or EEPROM devices) will render
all the cameras unusable. It'd be still quite importtant to be able to use
cameras that actually work, even if one of them does not. This is simply a
question of reliability.

The current implementation is that the initialisation of all the related
devices is required to be completed until any device nodes are registered.
This as itself is a part of the problem problem.

How that can be solved is by registering the device nodes of sub-devices
when the sub-devices are registered rather than at the time when all of
them are registered. This will have the effect of making partial device
states visible to the user space during driver probing.

I'd like to claim that it is not knowable whether a device the probing of
which has failed is going to come up in a fraction of a second or is not
going to come up during system uptime. -EPROBE_DEFER probably means that
the device will be around but there's no guarantee about it either, whereas
another error could be possibly fixed e.g. by the user.

Besides, the device nodes are even currently not created at the same
moment; they are rather created within a small window of time during which
the user will have access to the device nodes already created --- which do
not (yet) represent the complete device.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

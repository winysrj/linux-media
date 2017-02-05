Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51832 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751956AbdBEWpb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Feb 2017 17:45:31 -0500
Date: Mon, 6 Feb 2017 00:44:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: Add video bus switch
Message-ID: <20170205224450.GA13854@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170112111731.GA27541@amd>
 <20170203222520.GE12291@valkosipuli.retiisi.org.uk>
 <20170205221622.GA16107@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170205221622.GA16107@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Pavel!

On Sun, Feb 05, 2017 at 11:16:22PM +0100, Pavel Machek wrote:
> Hi!
> 
> I lost my original reply... so this will be slightly brief.

:-o

> 
> > > > + * This program is distributed in the hope that it will be useful, but
> > > > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > > > + * General Public License for more details.
> > > > + */
> > > > +
> > > > +#define DEBUG
> > 
> > Please remove.
> 
> Ok.
> 
> > > > +#include <linux/of_graph.h>
> > > > +#include <linux/gpio/consumer.h>
> > 
> > Alphabetical order, please.
> 
> Ok. (But let me make unhappy noise, because these rules are
> inconsistent across kernel.)
> 
> > > > + * TODO:
> > > > + * isp_subdev_notifier_complete() calls v4l2_device_register_subdev_nodes()
> > > > + */
> > > > +
> > > > +#define CSI_SWITCH_SUBDEVS 2
> > > > +#define CSI_SWITCH_PORTS 3
> > 
> > This could go to the enum below.
> > 
> > I guess the CSI_SWITCH_SUBDEVS could be (CSI_SWITCH_PORTS - 1).
> > 
> > I'd just replace CSI_SWITCH by VBS. The bus could be called
> > differently.
> 
> Ok.
> 
> > > > +static int vbs_registered(struct v4l2_subdev *sd)
> > > > +{
> > > > +	struct v4l2_device *v4l2_dev = sd->v4l2_dev;
> > > > +	struct vbs_data *pdata;
> > > > +	int err;
> > > > +
> > > > +	dev_dbg(sd->dev, "registered, init notifier...\n");
> > 
> > Looks like a development time debug message. :-)
> 
> ex-development message ;-).
> 
> > > > +	gpiod_set_value(pdata->swgpio, local->index == CSI_SWITCH_PORT_2);
> > > > +	pdata->state = local->index;
> > > > +
> > > > +	sd = vbs_get_remote_subdev(sd);
> > > > +	if (IS_ERR(sd))
> > > > +		return PTR_ERR(sd);
> > > > +
> > > > +	pdata->subdev.ctrl_handler = sd->ctrl_handler;
> > 
> > This is ugly. You're exposing all the controls through another sub-device.
> > 
> > How does link validation work now?
> > 
> > I wonder if it'd be less so if you just pass through the LINK_FREQ and
> > PIXEL_RATE controls. It'll certainly be more code though.
> > 
> > I think the link frequency could be something that goes to the frame
> > descriptor as well. Then we wouldn't need to worry about the controls
> > separately, just passing the frame descriptor would be enough.
> > 
> > I apologise that I don't have patches quite ready for posting to the
> > list.
> 
> (Plus of course question is "what is link validation".)

The links along the pipeline are validated for matching width, height, media
bus code and possibly other matters. The aim is to make sure that the
hardware configuration is a valid one before streaming starts.

> 
> Ok, let me play with this one. Solution you are suggesting is to make
> a custom harndler that only passes certain data through, right?

That's an option. But supposing we'll add that to the frame desciptors [1],
there won't be need for a custom handler either.

> 
> > > > +		dev_dbg(pdata->subdev.dev, "create link: %s[%d] -> %s[%d])\n",
> > > > +			src->name, src_pad, sink->name, sink_pad);
> > > > +	}
> > > > +
> > > > +	return v4l2_device_register_subdev_nodes(pdata->subdev.v4l2_dev);
> > 
> > The ISP driver's complete() callback calls
> > v4l2_device_register_subdev_nodes() already. Currently it cannot handle
> > being called more than once --- that needs to be fixed.
> 
> I may have patches for that. Let me check.
> 
> > > > +}
> > > > +
> > > > +
> > 
> > I'd say that's an extra newline.
> 
> Not any more.
> 
> > > > +	v4l2_subdev_init(&pdata->subdev, &vbs_ops);
> > > > +	pdata->subdev.dev = &pdev->dev;
> > > > +	pdata->subdev.owner = pdev->dev.driver->owner;
> > > > +	strncpy(pdata->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
> > 
> > How about sizeof(pdata->subdev.name) ?
> 
> Ok.
> 
> > I'm not sure I like V4L2_SUBDEV_NAME_SIZE in general. It could be even
> > removed. But not by this patch. :-)
> > 
> > > > +	v4l2_set_subdevdata(&pdata->subdev, pdata);
> > > > +	pdata->subdev.entity.function = MEDIA_ENT_F_SWITCH;
> > > > +	pdata->subdev.entity.flags |= MEDIA_ENT_F_SWITCH;
> > 
> > MEDIA_ENT_FL_*
> 
> Do we actually have a flag here? We already have .function, so this
> looks like a duplicate.

You can skip setting this. We only have flags for DEFAULT and CONNECTOR and
neither is relevant here.

> 
> 
> > > > +	if (err < 0) {
> > > > +		dev_err(&pdev->dev, "Failed to register v4l2 subdev: %d\n", err);
> > > > +		media_entity_cleanup(&pdata->subdev.entity);
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +	dev_info(&pdev->dev, "video-bus-switch registered\n");
> > 
> > How about dev_dbg()?
> 
> Ok.
> 
> > > > +static int video_bus_switch_remove(struct platform_device *pdev)
> > > > +{
> > > > +	struct vbs_data *pdata = platform_get_drvdata(pdev);
> > > > +
> > > > +	v4l2_async_notifier_unregister(&pdata->notifier);
> > 
> > Shouldn't you unregister the notifier in the .unregister() callback?
> 
> Ok, I guess we can do that for symetry.

The sub-device may be bound and unbound without the driver being probed or
removed. That's why the notifier unregistration should take place in the
.unregister callback.

> 
> > > >  /* generic v4l2_device notify callback notification values */
> > > >  #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
> > > > @@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
> > > >  			     const struct v4l2_mbus_config *cfg);
> > > >  	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> > > >  			   unsigned int *size);
> > > > +	int (*g_endpoint_config)(struct v4l2_subdev *sd,
> > > > +			    struct v4l2_of_endpoint *cfg);
> > 
> > This should be in a separate patch --- assuming we'll add this one.
> 
> Hmm. I believe the rest of the driver is quite useful in understanding
> this. Ok, lets get the discussion started.

Please add field documentation as well in the comment above.

> 
> > > > --- a/include/uapi/linux/media.h
> > > > +++ b/include/uapi/linux/media.h
> > > > @@ -147,6 +147,7 @@ struct media_device_info {
> > > >   * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
> > > >   */
> > > >  #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
> > > > +#define MEDIA_ENT_F_SWITCH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 6)
> > 
> > I wonder if MEDIA_ENT_F_PROC_ would be a better prefix.
> > We shouldn't have new entries in MEDIA_ENT_F_OLD_SUBDEV_BASE anymore.
> 
> Ok.
> 									Pavel
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

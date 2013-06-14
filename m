Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56564 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3FNNC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 09:02:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v10 16/21] V4L2: support asynchronous subdevice registration
Date: Fri, 14 Jun 2013 15:03:10 +0200
Message-ID: <1686962.DYieKKCbIi@avalon>
In-Reply-To: <Pine.LNX.4.64.1306140902170.6920@axis700.grange>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de> <51BA3B9A.5090206@gmail.com> <Pine.LNX.4.64.1306140902170.6920@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 14 June 2013 09:14:48 Guennadi Liakhovetski wrote:
> On Thu, 13 Jun 2013, Sylwester Nawrocki wrote:
> > Hi Guennadi,
> > 
> > Overall it looks quite neat at this v10. :)
> 
> Thanks :)
> 
> > On 06/11/2013 10:23 AM, Guennadi Liakhovetski wrote:
> > > Currently bridge device drivers register devices for all subdevices
> > > synchronously, tupically, during their probing. E.g. if an I2C CMOS
> > > sensor
> > 
> > s/tupically/typically
> > 
> > > is attached to a video bridge device, the bridge driver will create an
> > > I2C
> > > 
> > > +/**
> > > + * v4l2_async_subdev_list - provided by subdevices
> > > + * @list:	links struct v4l2_async_subdev_list objects to a global list
> > > + *		before probing, and onto notifier->done after probing
> > > + * @asd:	pointer to respective struct v4l2_async_subdev
> > > + * @notifier:	pointer to managing notifier
> > > + */
> > > +struct v4l2_async_subdev_list {
> > > +	struct list_head list;
> > > +	struct v4l2_async_subdev *asd;
> > > +	struct v4l2_async_notifier *notifier;
> > > +};
> > 
> > I have a patch for this patch, which embeds members of this struct
> > directly into struct v4l2_subdev. My felling is that the code is simpler
> > and easier to follow this way, I might be missing some important details
> > though.
> 
> Thanks, saw it. In principle I have nothing against it. I think, it's just
> principle approach to this work, which seems to differ slightly from how
> others see it. I tried to as little intrusive as possible, touching
> current APIs only if absolutely necessary, keeping the async stuff largely
> separated from the rest. If however the common feeling is, that we should
> inject it directly in V4L2 core, I have nothing against it either. Still,
> I would prefer to keep the .c and .h files separate for now at least to
> reduce merge conflicts etc.
> 
> > > +/**
> > > + * v4l2_async_notifier - v4l2_device notifier data
> > > + * @subdev_num:	number of subdevices
> > > + * @subdev:	array of pointers to subdevices
> > 
> > How about changing this to:
> >       @subdevs: array of pointers to the subdevice descriptors
> 
> I'm sure every single line of comments and code in these (and all other)
> patches can be improved :)
> 
> > I think it would be more immediately clear this is the actual subdevs
> > array pointer, and perhaps we could have subdev_num renamed to num_subdevs
> > ?
> 
> Sure, why not :)
> 
> > > + * @v4l2_dev:	pointer to struct v4l2_device
> > > + * @waiting:	list of struct v4l2_async_subdev, waiting for their
> > > drivers
> > > + * @done:	list of struct v4l2_async_subdev_list, already probed
> > > + * @list:	member in a global list of notifiers
> > > + * @bound:	a subdevice driver has successfully probed one of subdevices
> > > + * @complete:	all subdevices have been probed successfully
> > > + * @unbind:	a subdevice is leaving
> > > + */
> > > +struct v4l2_async_notifier {
> > > +	unsigned int subdev_num;
> > > +	struct v4l2_async_subdev **subdev;
> > > +	struct v4l2_device *v4l2_dev;
> > > +	struct list_head waiting;
> > > +	struct list_head done;
> > > +	struct list_head list;
> > > +	int (*bound)(struct v4l2_async_notifier *notifier,
> > > +		     struct v4l2_subdev *subdev,
> > > +		     struct v4l2_async_subdev *asd);
> > > +	int (*complete)(struct v4l2_async_notifier *notifier);
> > > +	void (*unbind)(struct v4l2_async_notifier *notifier,
> > > +		       struct v4l2_subdev *subdev,
> > > +		       struct v4l2_async_subdev *asd);
> > > +};
> > > +
> > > +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> > > +				 struct v4l2_async_notifier *notifier);
> > > +void v4l2_async_notifier_unregister(struct v4l2_async_notifier
> > > *notifier);
> > > +int v4l2_async_register_subdev(struct v4l2_subdev *sd);
> > > +void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
> > 
> > I still think "async_" in this public API is unnecessary, since we
> > register/ unregister a subdev with the core and notifiers are
> > intrinsically asynchronous.
> > But your preference seems be otherwise, what could I do... :) At most it
> > just means one less happy user of this interface.
> 
> See above :) And another point - this is your opinion, which I certainly
> respect and take into account. I think, Laurent somehow softly inclined in
> the same direction. But I didn't hear any other opinions, so, in the end I
> have to make a decision - is everyone more likely to like what has been
> proposed by this specific reviewer, or would everyone object :) There are
> obvious things - fixes etc., and there are less obvious ones - naming,
> formulating and such. So, here again - I just would prefer all methods,
> comprising this API to share the same namespace. To make it clearer, that
> if you register subdevices asynchronously, you also need notifiers on the
> host and the other way round. To make it easier to authors to match these
> methods. Just my 2p :)
> 
> > So except this bikeshedding I don't really have other comments, I'm going
> > to test this series with the s3c-camif/ov9650 drivers and will report
> > back soon.
> > 
> > It would have been a shame to not have this series in 3.11. I guess three
> > kernel cycles, since the initial implementation, time frame is sufficient
> > for having finally working camera devices on a device tree enabled system
> > in mainline.
> 
> Great! So, let's get 1 or 2 opinions more, then I can make a v11 with just
> a couple of cosmetic changes and kindly ask Mauro to pull this in :)

I have no further comment than those already posted by Hans and Sylwester on 
v10. I'll ack v11 (possibly with comments on the documentation though ;-)).

-- 
Regards,

Laurent Pinchart


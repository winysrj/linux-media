Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49515 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab3FMVhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 17:37:35 -0400
Message-ID: <51BA3B9A.5090206@gmail.com>
Date: Thu, 13 Jun 2013 23:37:30 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v10 16/21] V4L2: support asynchronous subdevice registration
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de> <1370939028-8352-17-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1370939028-8352-17-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Overall it looks quite neat at this v10. :)

On 06/11/2013 10:23 AM, Guennadi Liakhovetski wrote:
> Currently bridge device drivers register devices for all subdevices
> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor

s/tupically/typically

> is attached to a video bridge device, the bridge driver will create an I2C

> +/**
> + * v4l2_async_subdev_list - provided by subdevices
> + * @list:	links struct v4l2_async_subdev_list objects to a global list
> + *		before probing, and onto notifier->done after probing
> + * @asd:	pointer to respective struct v4l2_async_subdev
> + * @notifier:	pointer to managing notifier
> + */
> +struct v4l2_async_subdev_list {
> +	struct list_head list;
> +	struct v4l2_async_subdev *asd;
> +	struct v4l2_async_notifier *notifier;
> +};

I have a patch for this patch, which embeds members of this struct directly
into struct v4l2_subdev. My felling is that the code is simpler and easier
to follow this way, I might be missing some important details though.

> +/**
> + * v4l2_async_notifier - v4l2_device notifier data
> + * @subdev_num:	number of subdevices
> + * @subdev:	array of pointers to subdevices

How about changing this to:

       @subdevs: array of pointers to the subdevice descriptors

I think it would be more immediately clear this is the actual subdevs array
pointer, and perhaps we could have subdev_num renamed to num_subdevs ?

> + * @v4l2_dev:	pointer to struct v4l2_device
> + * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
> + * @done:	list of struct v4l2_async_subdev_list, already probed
> + * @list:	member in a global list of notifiers
> + * @bound:	a subdevice driver has successfully probed one of subdevices
> + * @complete:	all subdevices have been probed successfully
> + * @unbind:	a subdevice is leaving
> + */
> +struct v4l2_async_notifier {
> +	unsigned int subdev_num;
> +	struct v4l2_async_subdev **subdev;
> +	struct v4l2_device *v4l2_dev;
> +	struct list_head waiting;
> +	struct list_head done;
> +	struct list_head list;
> +	int (*bound)(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_subdev *subdev,
> +		     struct v4l2_async_subdev *asd);
> +	int (*complete)(struct v4l2_async_notifier *notifier);
> +	void (*unbind)(struct v4l2_async_notifier *notifier,
> +		       struct v4l2_subdev *subdev,
> +		       struct v4l2_async_subdev *asd);
> +};
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier);
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
> +int v4l2_async_register_subdev(struct v4l2_subdev *sd);
> +void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);

I still think "async_" in this public API is unnecessary, since we register/
unregister a subdev with the core and notifiers are intrinsically 
asynchronous.
But your preference seems be otherwise, what could I do... :) At most it 
just
means one less happy user of this interface.

So except this bikeshedding I don't really have other comments, I'm 
going to
test this series with the s3c-camif/ov9650 drivers and will report back 
soon.

It would have been a shame to not have this series in 3.11. I guess three
kernel cycles, since the initial implementation, time frame is sufficient
for having finally working camera devices on a device tree enabled system
in mainline.

Thanks for the idea and patience during reviews! :)


Regards,
Sylwester

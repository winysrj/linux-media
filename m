Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56535 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3FNM6h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 08:58:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v10 16/21] V4L2: support asynchronous subdevice registration
Date: Fri, 14 Jun 2013 14:58:48 +0200
Message-ID: <1401621.8faXML07Vy@avalon>
In-Reply-To: <51BAE4FC.4080400@samsung.com>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1306141113050.6920@axis700.grange> <51BAE4FC.4080400@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 14 June 2013 11:40:12 Sylwester Nawrocki wrote:
> On 06/14/2013 11:14 AM, Guennadi Liakhovetski wrote:
> > On Fri, 14 Jun 2013, Hans Verkuil wrote:
> >> On Fri 14 June 2013 09:14:48 Guennadi Liakhovetski wrote:
> >>> On Thu, 13 Jun 2013, Sylwester Nawrocki wrote:
> >>>> On 06/11/2013 10:23 AM, Guennadi Liakhovetski wrote:
> [...]
> 
> >>>>> + * @v4l2_dev:	pointer to struct v4l2_device
> >>>>> + * @waiting:	list of struct v4l2_async_subdev, waiting for their
> >>>>> drivers
> >>>>> + * @done:	list of struct v4l2_async_subdev_list, already probed
> >>>>> + * @list:	member in a global list of notifiers
> >>>>> + * @bound:	a subdevice driver has successfully probed one of
> >>>>> subdevices
> >>>>> + * @complete:	all subdevices have been probed successfully
> >>>>> + * @unbind:	a subdevice is leaving
> >>>>> + */
> >>>>> +struct v4l2_async_notifier {
> >>>>> +	unsigned int subdev_num;
> >>>>> +	struct v4l2_async_subdev **subdev;
> >>>>> +	struct v4l2_device *v4l2_dev;
> >>>>> +	struct list_head waiting;
> >>>>> +	struct list_head done;
> >>>>> +	struct list_head list;
> >>>>> +	int (*bound)(struct v4l2_async_notifier *notifier,
> >>>>> +		     struct v4l2_subdev *subdev,
> >>>>> +		     struct v4l2_async_subdev *asd);
> >>>>> +	int (*complete)(struct v4l2_async_notifier *notifier);
> >>>>> +	void (*unbind)(struct v4l2_async_notifier *notifier,
> >>>>> +		       struct v4l2_subdev *subdev,
> >>>>> +		       struct v4l2_async_subdev *asd);
> >>>>> +};
> >>>>> +
> >>>>> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> >>>>> +				 struct v4l2_async_notifier *notifier);
> >>>>> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier
> >>>>> *notifier);
> >>>>> +int v4l2_async_register_subdev(struct v4l2_subdev *sd);
> >>>>> +void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
> >>>> 
> >>>> I still think "async_" in this public API is unnecessary, since we
> >>>> register/ unregister a subdev with the core and notifiers are
> >>>> intrinsically
> >>>> asynchronous.
> >>>> But your preference seems be otherwise, what could I do... :) At most
> >>>> it just means one less happy user of this interface.
> >> 
> >> I think v4l2_register_subdev looks awfully similar to
> >> v4l2_device_register_subdev. It becomes very confusing naming it like
> >> that. I prefer v4l2_async where 'async' refers to the v4l2-async module.
> 
> Ok, let's leave v4l2_async then.
> 
> > And v4l2(_async)_notifier_(un)register()?
> 
> I guess it would be better to have all or none of the functions
> with that prefix. So either:
> 
> v4l2_async_notifier_register
> v4l2_async_notifier_unregister
> v4l2_async_register_subdev
> v4l2_async_unregister_subdev
> 
> or
> 
> v4l2_subdev_notifier_register
> v4l2_subdev_notifier_unregister
> v4l2_subdev_register
> v4l2_subdev_unregister

I prefer the section option, but I'm fine with the first one for now. As Hans 
pointed out, it would be pretty easy to confuse v4l2_subdev_register with 
v4l2_device_register_subdev. In the long term we want to move all drivers to 
asynchronous registration. When that happens it won't be difficult to revisit 
the API to remove unused functions and rename v4l2_aysnc_* to just v4l2_*.

-- 
Regards,

Laurent Pinchart


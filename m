Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:25594 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3EOLup (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 07:50:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH RFC v2 3/3] media: added managed v4l2 subdevice initialization
Date: Wed, 15 May 2013 13:50:40 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
References: <1368434086-9027-1-git-send-email-a.hajda@samsung.com> <201305131124.23598.hverkuil@xs4all.nl> <5193475C.5040908@samsung.com>
In-Reply-To: <5193475C.5040908@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151350.40979.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 15 May 2013 10:29:16 Andrzej Hajda wrote:
> On 13.05.2013 11:24, Hans Verkuil wrote:
> > Hi Andrzej,
> >
> > On Mon May 13 2013 10:34:46 Andrzej Hajda wrote:
> >> This patch adds managed versions of initialization
> >> functions for v4l2 subdevices.
> > I figured out what is bothering me about this patch: the fact that it is
> > tied to the v4l2_i2c_subdev_init/v4l2_subdev_init functions. Normally devm
> > functions are wrappers around functions that actually allocate some resource.
> > That's not the case with these subdev_init functions, they just initialize
> > fields in a struct.
> clk_get do not perform any allocation for now, there is only requirement(?)
> that it should be paired with clk_put, and that is what devm_clk_get
> actually does.
> 
> >
> > Why not drop those wrappers and just provide the devm_v4l2_subdev_bind
> > function? That's actually the one that is doing the binding, and is a function
> > drivers can call explicitly.
> 
> struct v4l2_subdev does not need allocation on initialization,
> but an 'allocation' (subdev registration) usually happens during its
> lifetime and is performed from outside (from v4l2 device), in fact it can
> happen multiple times.
> On v4l2_subdev de-initialization/cleanup/destruction we should ensure
> it is not registered and eventually unregister it and all this is performed
> by v4l2_device_unregister_subdev. So v4l2_device_unregister_subdev function
> seems to be natural cleanup routine for v4l2_subdev and it is used this
> way in most of the drivers.
> 
> All this lengthly explanation is to show that devm_v4l2*subdev_init just
> initializes v4l2_subdev in a managed way - besides fields initialization
> it adds automatic cleanup routine.
> >
> > The only thing you need to add to devm_v4l2_subdev_bind is a WARN_ON check that
> > sd->ops != NULL, verifying that v4l2_subdev_init was called before the
> > bind().
> OK.
> >
> > I would be much happier with that solution.
> I hope my reasoning above will convince you, if not I will adjust the
> patch accordingly.

You have convinced me only partially. v4l2_subdev_init should *not* be managed:
it really is just an initialization function and for non-i2c and non-spi subdevs
there is generally no cleanup needed (or it is done automatically when the
v4l2_device is unregistered).

For v4l2_i2c/spi_subdev_init it makes sense to manage that since there cleanup
is needed. Actually, to be precise: cleanup is only needed if the i2c adapter
is released before the v4l2_device is unregistered. In general the order is
unknown, so cleanup is needed.

Regards,

	Hans

> 
> Regards
> Andrzej
> >
> > Regards,
> >
> > 	Hans
> >
> >> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> v2:
> >> 	- changes of v4l2-ctrls.h moved to proper patch
> >> ---
> >>  drivers/media/v4l2-core/v4l2-common.c |   10 +++++++
> >>  drivers/media/v4l2-core/v4l2-subdev.c |   52 +++++++++++++++++++++++++++++++++
> >>  include/media/v4l2-common.h           |    2 ++
> >>  include/media/v4l2-subdev.h           |    5 ++++
> >>  4 files changed, 69 insertions(+)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> >> index 3fed63f..96aac931 100644
> >> --- a/drivers/media/v4l2-core/v4l2-common.c
> >> +++ b/drivers/media/v4l2-core/v4l2-common.c
> >> @@ -301,7 +301,17 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> >>  }
> >>  EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
> >>  
> >> +int devm_v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> >> +			      const struct v4l2_subdev_ops *ops)
> >> +{
> >> +	int ret;
> >>  
> >> +	ret = devm_v4l2_subdev_bind(&client->dev, sd);
> >> +	if (!ret)
> >> +		v4l2_i2c_subdev_init(sd, client, ops);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(devm_v4l2_i2c_subdev_init);
> >>  
> >>  /* Load an i2c sub-device. */
> >>  struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
> >> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> >> index 996c248..87ce2f6 100644
> >> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> >> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> >> @@ -474,3 +474,55 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
> >>  #endif
> >>  }
> >>  EXPORT_SYMBOL(v4l2_subdev_init);
> >> +
> >> +static void devm_v4l2_subdev_release(struct device *dev, void *res)
> >> +{
> >> +	struct v4l2_subdev **sd = res;
> >> +
> >> +	v4l2_device_unregister_subdev(*sd);
> >> +#if defined(CONFIG_MEDIA_CONTROLLER)
> >> +	media_entity_cleanup(&(*sd)->entity);
> >> +#endif
> >> +}
> >> +
> >> +int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd)
> >> +{
> >> +	struct v4l2_subdev **dr;
> >> +
> >> +	dr = devres_alloc(devm_v4l2_subdev_release, sizeof(*dr), GFP_KERNEL);
> >> +	if (!dr)
> >> +		return -ENOMEM;
> >> +
> >> +	*dr = sd;
> >> +	devres_add(dev, dr);
> >> +
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL(devm_v4l2_subdev_bind);
> >> +
> >> +int devm_v4l2_subdev_init(struct device *dev, struct v4l2_subdev *sd,
> >> +			  const struct v4l2_subdev_ops *ops)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = devm_v4l2_subdev_bind(dev, sd);
> >> +	if (!ret)
> >> +		v4l2_subdev_init(sd, ops);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL(devm_v4l2_subdev_init);
> >> +
> >> +static int devm_v4l2_subdev_match(struct device *dev, void *res,
> >> +					void *data)
> >> +{
> >> +	struct v4l2_subdev **this = res, **sd = data;
> >> +
> >> +	return *this == *sd;
> >> +}
> >> +
> >> +void devm_v4l2_subdev_free(struct device *dev, struct v4l2_subdev *sd)
> >> +{
> >> +	WARN_ON(devres_release(dev, devm_v4l2_subdev_release,
> >> +			       devm_v4l2_subdev_match, &sd));
> >> +}
> >> +EXPORT_SYMBOL_GPL(devm_v4l2_subdev_free);
> >> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> >> index 1d93c48..da62e2b 100644
> >> --- a/include/media/v4l2-common.h
> >> +++ b/include/media/v4l2-common.h
> >> @@ -136,6 +136,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
> >>  /* Initialize a v4l2_subdev with data from an i2c_client struct */
> >>  void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> >>  		const struct v4l2_subdev_ops *ops);
> >> +int devm_v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> >> +		const struct v4l2_subdev_ops *ops);
> >>  /* Return i2c client address of v4l2_subdev. */
> >>  unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd);
> >>  
> >> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >> index 5298d67..881abdd 100644
> >> --- a/include/media/v4l2-subdev.h
> >> +++ b/include/media/v4l2-subdev.h
> >> @@ -657,6 +657,11 @@ int v4l2_subdev_link_validate(struct media_link *link);
> >>  void v4l2_subdev_init(struct v4l2_subdev *sd,
> >>  		      const struct v4l2_subdev_ops *ops);
> >>  
> >> +int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd);
> >> +int devm_v4l2_subdev_init(struct device *dev, struct v4l2_subdev *sd,
> >> +			  const struct v4l2_subdev_ops *ops);
> >> +void devm_v4l2_subdev_free(struct device *dev, struct v4l2_subdev *sd);
> >> +
> >>  /* Call an ops of a v4l2_subdev, doing the right checks against
> >>     NULL pointers.
> >>  
> >>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

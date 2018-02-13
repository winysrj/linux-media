Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50634 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965574AbeBMUJ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 15:09:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 22/30] rcar-vin: add group allocator functions
Date: Tue, 13 Feb 2018 22:09:56 +0200
Message-ID: <1907646.jK4vy9bKSB@avalon>
In-Reply-To: <20180129163435.24936-23-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-23-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:27 EET Niklas S=F6derlund wrote:
> In media controller mode all VIN instances needs to be part of the same
> media graph. There is also a need for each VIN instance to know about
> and in some cases be able to communicate with other VIN instances.
>=20
> Add an allocator framework where the first VIN instance to be probed
> creates a shared data structure and registers a media device.
> Consecutive VINs insert themself into the global group.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 177 ++++++++++++++++++++++=
++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  31 +++++
>  2 files changed, 206 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 0c6960756c33f86c..4a64df5019ce45f7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -20,12 +20,177 @@
>  #include <linux/of_graph.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/slab.h>
>=20
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
>=20
>  #include "rcar-vin.h"
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Gen3 CSI2 Group Allocator
> + */
> +
> +/* FIXME:  This should if we find a system that supports more
> + * then one group for the whole system be replaced with a linked

s/then/than/

> + * list of groups. And eventually all of this should be replaced
> + * with a global device allocator API.
> + *
> + * But for now this works as on all supported systems there will
> + * be only one group for all instances.
> + */
> +
> +static DEFINE_MUTEX(rvin_group_lock);
> +static struct rvin_group *rvin_group_data;
> +
> +static void rvin_group_cleanup(struct rvin_group *group)
> +{
> +	media_device_unregister(&group->mdev);
> +	media_device_cleanup(&group->mdev);
> +	mutex_destroy(&group->lock);
> +}
> +
> +static int rvin_group_init(struct rvin_group *group, struct rvin_dev *vi=
n)
> +{
> +	struct media_device *mdev =3D &group->mdev;
> +	const struct of_device_id *match;
> +	struct device_node *np;
> +	int ret;
> +
> +	mutex_init(&group->lock);
> +
> +	/* Count number of VINs in the system */
> +	group->count =3D 0;
> +	for_each_matching_node(np, vin->dev->driver->of_match_table)
> +		if (of_device_is_available(np))
> +			group->count++;
> +
> +	vin_dbg(vin, "found %u enabled VIN's in DT", group->count);
> +
> +	mdev->dev =3D vin->dev;
> +
> +	match =3D of_match_node(vin->dev->driver->of_match_table,
> +			      vin->dev->of_node);
> +
> +	strlcpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
> +	strlcpy(mdev->model, match->compatible, sizeof(mdev->model));
> +	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
> +		 dev_name(mdev->dev));
> +
> +	media_device_init(mdev);
> +
> +	ret =3D media_device_register(&group->mdev);
> +	if (ret)
> +		rvin_group_cleanup(group);
> +
> +	return ret;
> +}
> +
> +static void rvin_group_release(struct kref *kref)
> +{
> +	struct rvin_group *group =3D
> +		container_of(kref, struct rvin_group, refcount);
> +
> +	mutex_lock(&rvin_group_lock);
> +
> +	rvin_group_data =3D NULL;
> +
> +	rvin_group_cleanup(group);
> +
> +	kfree(group);
> +
> +	mutex_unlock(&rvin_group_lock);
> +}
> +
> +static int rvin_group_get(struct rvin_dev *vin)
> +{
> +	struct rvin_group *group;
> +	u32 id;
> +	int ret;
> +
> +	/* Make sure VIN id is present and sane */
> +	ret =3D of_property_read_u32(vin->dev->of_node, "renesas,id", &id);
> +	if (ret) {
> +		vin_err(vin, "%pOF: No renesas,id property found\n",
> +			vin->dev->of_node);
> +		return -EINVAL;
> +	}
> +
> +	if (id >=3D RCAR_VIN_NUM) {
> +		vin_err(vin, "%pOF: Invalid renesas,id '%u'\n",
> +			vin->dev->of_node, id);
> +		return -EINVAL;
> +	}

I'd move this out of this function to an OF parsing function, but we don't=
=20
have one yet. Something to keep in mind for later.

> +	/* Join or create a VIN group */
> +	mutex_lock(&rvin_group_lock);
> +	if (rvin_group_data) {
> +		group =3D rvin_group_data;
> +		kref_get(&group->refcount);
> +	} else {
> +		group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> +		if (!group) {
> +			ret =3D -ENOMEM;
> +			goto err_group;
> +		}
> +
> +		ret =3D rvin_group_init(group, vin);
> +		if (ret) {
> +			kfree(group);
> +			vin_err(vin, "Failed to initialize group\n");
> +			goto err_group;
> +		}
> +
> +		kref_init(&group->refcount);
> +
> +		rvin_group_data =3D group;
> +	}
> +	mutex_unlock(&rvin_group_lock);
> +
> +	/* Add VIN to group */
> +	mutex_lock(&group->lock);
> +
> +	if (group->vin[id]) {
> +		vin_err(vin, "Duplicate renesas,id property value %u\n", id);
> +		ret =3D -EINVAL;
> +		goto err_vin;
> +	}
> +
> +	group->vin[id] =3D vin;
> +
> +	vin->id =3D id;
> +	vin->group =3D group;
> +	vin->v4l2_dev.mdev =3D &group->mdev;
> +
> +	mutex_unlock(&group->lock);
> +
> +	return 0;
> +err_group:
> +	mutex_unlock(&rvin_group_lock);
> +	return ret;
> +err_vin:
> +	mutex_unlock(&group->lock);
> +	kref_put(&group->refcount, rvin_group_release);
> +	return ret;

This error handling path is used from a single location, you can inline it.

> +}
> +
> +static void rvin_group_put(struct rvin_dev *vin)
> +{
> +	mutex_lock(&vin->group->lock);
> +
> +	vin->group =3D NULL;
> +	vin->v4l2_dev.mdev =3D NULL;
> +
> +	if (WARN_ON(vin->group->vin[vin->id] !=3D vin))
> +		goto out;
> +
> +	vin->group->vin[vin->id] =3D NULL;
> +out:
> +	mutex_unlock(&vin->group->lock);
> +
> +	kref_put(&vin->group->refcount, rvin_group_release);
> +}
> +
>  /* ---------------------------------------------------------------------=
=2D--
>   * Async notifier
>   */
> @@ -243,12 +408,18 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin)
>=20
>  static int rvin_mc_init(struct rvin_dev *vin)
>  {
> +	int ret;
> +
>  	/* All our sources are CSI-2 */
>  	vin->mbus_cfg.type =3D V4L2_MBUS_CSI2;
>  	vin->mbus_cfg.flags =3D 0;
>=20
>  	vin->pad.flags =3D MEDIA_PAD_FL_SINK;
> -	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> +	ret =3D media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> +	if (ret)
> +		return ret;
> +
> +	return rvin_group_get(vin);
>  }
>=20
>  /* ---------------------------------------------------------------------=
=2D--
> @@ -368,7 +539,9 @@ static int rcar_vin_remove(struct platform_device
> *pdev) v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
> -	if (!vin->info->use_mc)
> +	if (vin->info->use_mc)
> +		rvin_group_put(vin);
> +	else
>  		v4l2_ctrl_handler_free(&vin->ctrl_handler);
>=20
>  	rvin_dma_unregister(vin);
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 4caef7193db09c5b..903d8fb8426a7860 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -17,6 +17,8 @@
>  #ifndef __RCAR_VIN__
>  #define __RCAR_VIN__
>=20
> +#include <linux/kref.h>
> +
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-dev.h>
> @@ -29,6 +31,11 @@
>  /* Address alignment mask for HW buffers */
>  #define HW_BUFFER_MASK 0x7f
>=20
> +/* Max number on VIN instances that can be in a system */
> +#define RCAR_VIN_NUM 8
> +
> +struct rvin_group;
> +
>  enum model_id {
>  	RCAR_H1,
>  	RCAR_M1,
> @@ -101,6 +108,8 @@ struct rvin_info {
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @digital:		entity in the DT for local digital subdevice
>   *
> + * @group:		Gen3 CSI group
> + * @id:			Gen3 group id for this VIN
>   * @pad:		media pad for the video device entity
>   *
>   * @lock:		protects @queue
> @@ -132,6 +141,8 @@ struct rvin_dev {
>  	struct v4l2_async_notifier notifier;
>  	struct rvin_graph_entity *digital;
>=20
> +	struct rvin_group *group;
> +	unsigned char id;

You can use an unsigned int, the compiler would pad the field anyway.

>  	struct media_pad pad;
>=20
>  	struct mutex lock;
> @@ -160,6 +171,26 @@ struct rvin_dev {
>  #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
>  #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
>=20
> +/**
> + * struct rvin_group - VIN CSI2 group information
> + * @refcount:		number of VIN instances using the group
> + *
> + * @mdev:		media device which represents the group
> + *
> + * @lock:		protects the count and vin members
> + * @count:		number of enabled VIN instances found in DT
> + * @vin:		VIN instances which are part of the group
> + */
> +struct rvin_group {
> +	struct kref refcount;
> +
> +	struct media_device mdev;
> +
> +	struct mutex lock;
> +	unsigned int count;
> +	struct rvin_dev *vin[RCAR_VIN_NUM];
> +};
> +
>  int rvin_dma_register(struct rvin_dev *vin, int irq);
>  void rvin_dma_unregister(struct rvin_dev *vin);

With these small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

=2D-=20
Regards,

Laurent Pinchart

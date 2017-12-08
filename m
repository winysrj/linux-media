Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52189 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbdLHUM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 15:12:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 21/28] rcar-vin: add group allocator functions
Date: Fri, 08 Dec 2017 22:12:56 +0200
Message-ID: <2338267.IAVXeh1rRr@avalon>
In-Reply-To: <20171208010842.20047-22-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-22-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:35 EET Niklas S=F6derlund wrote:
> In media controller mode all VIN instances needs to be part of the same
> media graph. There is also a need to each VIN instance to know and in
> some cases be able to communicate with other VIN instances.
>=20
> Add an allocator framework where the first VIN instance to be probed
> creates a shared data structure and creates a media device.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 179 ++++++++++++++++++++++=
++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  38 ++++++
>  2 files changed, 215 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 45de4079fd835759..a6713fd61dd87a88 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -20,12 +20,170 @@
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
>  + * Gen3 CSI2 Group Allocator
> + */
> +
> +static int rvin_group_read_id(struct rvin_dev *vin, struct device_node *=
np)
> +{
> +	u32 val;
> +	int ret;
> +
> +	ret =3D of_property_read_u32(np, "renesas,id", &val);
> +	if (ret) {
> +		vin_err(vin, "%pOF: No renesas,id property found\n", np);
> +		return -EINVAL;
> +	}
> +
> +	if (val >=3D RCAR_VIN_NUM) {
> +		vin_err(vin, "%pOF: Invalid renesas,id '%u'\n", np, val);
> +		return -EINVAL;
> +	}

I'd move all this to the main DT parsing function.

> +	return val;
> +}
> +
> +static DEFINE_MUTEX(rvin_group_lock);
> +static struct rvin_group *rvin_group_data;

Nitpicking, static variables are often defined at the beginning of the C fi=
le,=20
before any function. I'll let you decide whether you want to move them.

> +static void rvin_group_release(struct kref *kref)
> +{
> +	struct rvin_group *group =3D
> +		container_of(kref, struct rvin_group, refcount);
> +
> +	mutex_lock(&rvin_group_lock);
> +
> +	media_device_unregister(&group->mdev);
> +	media_device_cleanup(&group->mdev);
> +
> +	rvin_group_data =3D NULL;
> +
> +	mutex_unlock(&rvin_group_lock);
> +
> +	kfree(group);
> +}
> +
> +static struct rvin_group *__rvin_group_allocate(struct rvin_dev *vin)
> +{
> +	struct rvin_group *group;
> +
> +	if (rvin_group_data) {
> +		group =3D rvin_group_data;
> +		kref_get(&group->refcount);
> +		vin_dbg(vin, "%s: get group=3D%p\n", __func__, group);
> +		return group;
> +	}
> +
> +	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> +	if (!group)
> +		return NULL;
> +
> +	kref_init(&group->refcount);
> +	rvin_group_data =3D group;

Ouch. While I agree with the global mutex, a single global group variable=20
reminds me of the days when per-device data was happily stored in global=20
variables because, you know, we will never have more than one instance of t=
hat=20
device, right ? (Or, sometimes, because the driver author didn't know what =
an=20
instance was.)

Ideally we'd want a linked list of groups, and this function would either=20
retrieve the group that the VIN instance is part of, or allocate a new one.

> +	vin_dbg(vin, "%s: alloc group=3D%p\n", __func__, group);

Do you still need those two debug statements (and all of the other ones bel=
ow)=20
?

> +	return group;
> +}
> +
> +static int rvin_group_add_vin(struct rvin_dev *vin)
> +{
> +	int ret;
> +
> +	ret =3D rvin_group_read_id(vin, vin->dev->of_node);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&vin->group->lock);
> +
> +	if (vin->group->vin[ret]) {
> +		mutex_unlock(&vin->group->lock);
> +		vin_err(vin, "VIN number %d already occupied\n", ret);
> +		return -EINVAL;

Can this happen ?

> +	}
> +
> +	vin->group->vin[ret] =3D vin;
> +
> +	mutex_unlock(&vin->group->lock);
> +
> +	vin_dbg(vin, "I'm VIN number %d", ret);
> +
> +	return 0;
> +}
> +
> +static int rvin_group_allocate(struct rvin_dev *vin)
> +{
> +	struct rvin_group *group;
> +	struct media_device *mdev;
> +	int ret;
> +
> +	mutex_lock(&rvin_group_lock);
> +
> +	group =3D __rvin_group_allocate(vin);
> +	if (!group) {
> +		mutex_unlock(&rvin_group_lock);

I'd use a goto unlock instead of spreading mutex_unlock() calls through the=
=20
function. It's easier to locate a misplaced return in a function that shoul=
d=20
only use gotos than a missing mutex_unlock().

> +		return -ENOMEM;
> +	}
> +
> +	/* Init group data if it is not already initialized */
> +	mdev =3D &group->mdev;
> +	if (!mdev->dev) {
> +		mutex_init(&group->lock);
> +		mdev->dev =3D vin->dev;
> +
> +		strlcpy(mdev->driver_name, "Renesas VIN",
> +			sizeof(mdev->driver_name));

How about using the module name ?

> +		strlcpy(mdev->model, vin->dev->of_node->name,
> +			sizeof(mdev->model));

I wonder whether you shouldn't somehow use the compatible string to create =
the=20
model name, in order to accurately report the device model.

> +		snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
> +			 dev_name(mdev->dev));
> +		media_device_init(mdev);
> +
> +		ret =3D media_device_register(mdev);
> +		if (ret) {
> +			vin_err(vin, "Failed to register media device\n");
> +			kref_put(&group->refcount, rvin_group_release);

This will deadlock if you're releasing the last reference. There's an=20
identical issue below.

> +			mutex_unlock(&rvin_group_lock);
> +			return ret;
> +		}
> +	}
> +
> +	vin->group =3D group;
> +	vin->v4l2_dev.mdev =3D mdev;
> +
> +	ret =3D rvin_group_add_vin(vin);

I'd inline the function here.

> +	if (ret) {
> +		kref_put(&group->refcount, rvin_group_release);
> +		mutex_unlock(&rvin_group_lock);
> +		return ret;
> +	}
> +
> +	mutex_unlock(&rvin_group_lock);
> +
> +	return 0;
> +}
> +
> +static void rvin_group_delete(struct rvin_dev *vin)

This function doesn't completely delete the group, it only drops one=20
reference. How about rvin_group_put() ? rvin_group_allocate() could then be=
=20
called rvin_group_get().

> +{
> +	unsigned int i;
> +
> +	mutex_lock(&vin->group->lock);
> +	for (i =3D 0; i < RCAR_VIN_NUM; i++)
> +		if (vin->group->vin[i] =3D=3D vin)
> +			vin->group->vin[i] =3D NULL;
> +	mutex_unlock(&vin->group->lock);
> +
> +	vin_dbg(vin, "%s: group=3D%p\n", __func__, &vin->group);
> +	kref_put(&vin->group->refcount, rvin_group_release);
> +}
> +
>  /* ---------------------------------------------------------------------=
=2D--
>   * Async notifier
>   */
> @@ -236,12 +394,27 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin)
>=20
>  static int rvin_group_init(struct rvin_dev *vin)
>  {
> +	int ret;
> +
> +	ret =3D rvin_group_allocate(vin);
> +	if (ret)
> +		return ret;
> +
>  	/* All our sources are CSI-2 */
>  	vin->mbus_cfg.type =3D V4L2_MBUS_CSI2;
>  	vin->mbus_cfg.flags =3D 0;
>=20
>  	vin->pad.flags =3D MEDIA_PAD_FL_SINK;
> -	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> +	ret =3D media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
> +	if (ret)
> +		goto error_group;
> +
> +	return 0;
> +
> +error_group:
> +	rvin_group_delete(vin);
> +
> +	return ret;
>  }
>=20
>  /* ---------------------------------------------------------------------=
=2D--
> @@ -361,7 +534,9 @@ static int rcar_vin_remove(struct platform_device
> *pdev) v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
> -	if (!vin->info->use_mc)
> +	if (vin->info->use_mc)
> +		rvin_group_delete(vin);
> +	else
>  		v4l2_ctrl_handler_free(&vin->ctrl_handler);
>=20
>  	rvin_dma_unregister(vin);
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 07d270a976893cdb..5f736a3500b6e10f 100644
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
> @@ -30,6 +32,9 @@
>  /* Address alignment mask for HW buffers */
>  #define HW_BUFFER_MASK 0x7f
>=20
> +/* Max number on VIN instances that can be in a system */
> +#define RCAR_VIN_NUM 8
> +
>  enum chip_id {
>  	RCAR_H1,
>  	RCAR_M1,
> @@ -37,6 +42,15 @@ enum chip_id {
>  	RCAR_GEN3,
>  };
>=20
> +enum rvin_csi_id {
> +	RVIN_CSI20,
> +	RVIN_CSI21,
> +	RVIN_CSI40,
> +	RVIN_CSI41,
> +	RVIN_CSI_MAX,
> +	RVIN_NC, /* Not Connected */
> +};
> +
>  /**
>   * STOPPED  - No operation in progress
>   * RUNNING  - Operation in progress have buffers
> @@ -75,6 +89,8 @@ struct rvin_graph_entity {
>  	unsigned int sink_pad;
>  };
>=20
> +struct rvin_group;

=46orward declarations are usually grouped at the beginning of the header.

>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @chip:		type of VIN chip
> @@ -103,6 +119,7 @@ struct rvin_info {
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @digital:		entity in the DT for local digital subdevice
>   *
> + * @group:		Gen3 CSI group
>   * @pad:		pad for media controller
>   *
>   * @lock:		protects @queue
> @@ -134,6 +151,7 @@ struct rvin_dev {
>  	struct v4l2_async_notifier notifier;
>  	struct rvin_graph_entity *digital;
>=20
> +	struct rvin_group *group;
>  	struct media_pad pad;
>=20
>  	struct mutex lock;
> @@ -162,6 +180,26 @@ struct rvin_dev {
>  #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
>  #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
>=20
> +/**
> + * struct rvin_group - VIN CSI2 group information
> + * @refcount:		number of VIN instances using the group
> + *
> + * @mdev:		media device which represents the group
> + *
> + * @lock:		protects the vin and csi members
> + * @vin:		VIN instances which are part of the group
> + * @csi:		CSI-2 entities that are part of the group
> + */
> +struct rvin_group {
> +	struct kref refcount;
> +
> +	struct media_device mdev;
> +
> +	struct mutex lock;
> +	struct rvin_dev *vin[RCAR_VIN_NUM];
> +	struct rvin_graph_entity csi[RVIN_CSI_MAX];

Given that the number and types of CSI receivers varies quite a bit between=
=20
SoCs I wonder whether this couldn't be a linked list. If csi was an array o=
f=20
pointers it would be less of an issue, but an array of rvin_graph_entity ca=
n=20
grow large.

> +};
> +
>  int rvin_dma_register(struct rvin_dev *vin, int irq);
>  void rvin_dma_unregister(struct rvin_dev *vin);

=2D-=20
Regards,

Laurent Pinchart

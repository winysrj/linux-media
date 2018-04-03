Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42634 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752813AbeDCVgg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:36:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 29/33] rcar-vin: add link notify for Gen3
Date: Wed, 04 Apr 2018 00:36:45 +0300
Message-ID: <3043167.HnJ2ITFFYu@avalon>
In-Reply-To: <20180326214456.6655-30-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se> <20180326214456.6655-30-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 27 March 2018 00:44:52 EEST Niklas S=F6derlund wrote:
> Add the ability to process media device link change requests. Link
> enabling is a bit complicated on Gen3, whether or not it's possible to
> enable a link depends on what other links already are enabled. On Gen3
> the 8 VINs are split into two subgroup's (VIN0-3 and VIN4-7) and from a
> routing perspective these two groups are independent of each other.
> Each subgroup's routing is controlled by the subgroup VIN master
> instance (VIN0 and VIN4).
>=20
> There are a limited number of possible route setups available for each
> subgroup and the configuration of each setup is dictated by the
> hardware. On H3 for example there are 6 possible route setups for each
> subgroup to choose from.
>=20
> This leads to the media device link notification code being rather large
> since it will find the best routing configuration to try and accommodate
> as many links as possible. When it's not possible to enable a new link
> due to hardware constrains the link_notifier callback will return
> -EMLINK.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>=20
> ---
>=20
> * Changes since v11
> - Fixed spelling
> - Updated comment to clarify the intent that no link can be enabled if
> any video node is open.
> - Use container_of() instead of a loop to find struct vin_dev from the
> video device.
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 147
> ++++++++++++++++++++++++++++ 1 file changed, 147 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 99f6301a778046df..0cc76d73115e9277 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -24,6 +24,7 @@
>=20
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
> +#include <media/v4l2-mc.h>
>=20
>  #include "rcar-vin.h"
>=20
> @@ -44,6 +45,151 @@
>   */
>  #define rvin_group_id_to_master(vin) ((vin) < 4 ? 0 : 4)
>=20
> +/*
> -------------------------------------------------------------------------=
=2D-
> -- + * Media Controller link notification
> + */
> +
> +/* group lock should be held when calling this function. */
> +static int rvin_group_entity_to_csi_id(struct rvin_group *group,
> +				       struct media_entity *entity)
> +{
> +	struct v4l2_subdev *sd;
> +	unsigned int i;
> +
> +	sd =3D media_entity_to_v4l2_subdev(entity);
> +
> +	for (i =3D 0; i < RVIN_CSI_MAX; i++)
> +		if (group->csi[i].subdev =3D=3D sd)
> +			return i;
> +
> +	return -ENODEV;
> +}
> +
> +static unsigned int rvin_group_get_mask(struct rvin_dev *vin,
> +					enum rvin_csi_id csi_id,
> +					unsigned char channel)
> +{
> +	const struct rvin_group_route *route;
> +	unsigned int mask =3D 0;
> +
> +	for (route =3D vin->info->routes; route->mask; route++) {
> +		if (route->vin =3D=3D vin->id &&
> +		    route->csi =3D=3D csi_id &&
> +		    route->channel =3D=3D channel) {
> +			vin_dbg(vin,
> +				"Adding route: vin: %d csi: %d channel: %d\n",
> +				route->vin, route->csi, route->channel);
> +			mask |=3D route->mask;
> +		}
> +	}
> +
> +	return mask;
> +}
> +
> +/*
> + * Link setup for the links between a VIN and a CSI-2 receiver is a bit
> + * complex. The reason for this is that the register controlling routing
> + * is not present in each VIN instance. There are special VINs which
> + * control routing for themselves and other VINs. There are not many
> + * different possible links combinations that can be enabled at the same
> + * time, therefor all already enabled links which are controlled by a
> + * master VIN need to be taken into account when making the decision
> + * if a new link can be enabled or not.
> + *
> + * 1. Find out which VIN the link the user tries to enable is connected =
to.
> + * 2. Lookup which master VIN controls the links for this VIN.
> + * 3. Start with a bitmask with all bits set.
> + * 4. For each previously enabled link from the master VIN bitwise AND i=
ts
> + *    route mask (see documentation for mask in struct rvin_group_route)
> + *    with the bitmask.
> + * 5. Bitwise AND the mask for the link the user tries to enable to the
> bitmask. + * 6. If the bitmask is not empty at this point the new link can
> be enabled + *    while keeping all previous links enabled. Update the
> CHSEL value of the + *    master VIN and inform the user that the link
> could be enabled. + *
> + * Please note that no link can be enabled if any VIN in the group is
> + * currently open.
> + */
> +static int rvin_group_link_notify(struct media_link *link, u32 flags,
> +				  unsigned int notification)
> +{
> +	struct rvin_group *group =3D container_of(link->graph_obj.mdev,
> +						struct rvin_group, mdev);
> +	unsigned int master_id, channel, mask_new, i;
> +	unsigned int mask =3D ~0;
> +	struct media_entity *entity;
> +	struct video_device *vdev;
> +	struct media_pad *csi_pad;
> +	struct rvin_dev *vin =3D NULL;
> +	int csi_id, ret;
> +
> +	ret =3D v4l2_pipeline_link_notify(link, flags, notification);
> +	if (ret)
> +		return ret;
> +
> +	/* Only care about link enablement for VIN nodes. */
> +	if (!(flags & MEDIA_LNK_FL_ENABLED) ||
> +	    !is_media_entity_v4l2_video_device(link->sink->entity))
> +		return 0;
> +
> +	/* If any entity is in use don't allow link changes. */
> +	media_device_for_each_entity(entity, &group->mdev)
> +		if (entity->use_count)
> +			return -EBUSY;
> +
> +	mutex_lock(&group->lock);
> +
> +	/* Find the master VIN that controls the routes. */
> +	vdev =3D media_entity_to_video_device(link->sink->entity);
> +	vin =3D container_of(vdev, struct rvin_dev, vdev);
> +	master_id =3D rvin_group_id_to_master(vin->id);
> +
> +	if (WARN_ON(!group->vin[master_id])) {
> +		ret =3D -ENODEV;
> +		goto out;
> +	}
> +
> +	/* Build a mask for already enabled links. */
> +	for (i =3D master_id; i < master_id + 4; i++) {
> +		if (!group->vin[i])
> +			continue;
> +
> +		/* Get remote CSI-2, if any. */
> +		csi_pad =3D media_entity_remote_pad(
> +				&group->vin[i]->vdev.entity.pads[0]);
> +		if (!csi_pad)
> +			continue;
> +
> +		csi_id =3D rvin_group_entity_to_csi_id(group, csi_pad->entity);
> +		channel =3D rvin_group_csi_pad_to_channel(csi_pad->index);
> +
> +		mask &=3D rvin_group_get_mask(group->vin[i], csi_id, channel);
> +	}
> +
> +	/* Add the new link to the existing mask and check if it works. */
> +	csi_id =3D rvin_group_entity_to_csi_id(group, link->source->entity);
> +	channel =3D rvin_group_csi_pad_to_channel(link->source->index);
> +	mask_new =3D mask & rvin_group_get_mask(vin, csi_id, channel);
> +
> +	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
> +
> +	if (!mask_new) {
> +		ret =3D -EMLINK;
> +		goto out;
> +	}
> +
> +	/* New valid CHSEL found, set the new value. */
> +	ret =3D rvin_set_channel_routing(group->vin[master_id], __ffs(mask_new)=
);
> +out:
> +	mutex_unlock(&group->lock);
> +
> +	return ret;
> +}
> +
> +static const struct media_device_ops rvin_media_ops =3D {
> +	.link_notify =3D rvin_group_link_notify,
> +};
> +
>  /*
> -------------------------------------------------------------------------=
=2D-
> -- * Gen3 CSI2 Group Allocator
>   */
> @@ -85,6 +231,7 @@ static int rvin_group_init(struct rvin_group *group,
> struct rvin_dev *vin) vin_dbg(vin, "found %u enabled VIN's in DT",
> group->count);
>=20
>  	mdev->dev =3D vin->dev;
> +	mdev->ops =3D &rvin_media_ops;
>=20
>  	match =3D of_match_node(vin->dev->driver->of_match_table,
>  			      vin->dev->of_node);


=2D-=20
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52500 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965801AbeBMVQn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 16:16:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 26/30] rcar-vin: add link notify for Gen3
Date: Tue, 13 Feb 2018 23:17:14 +0200
Message-ID: <2799740.yfQ1Qb9HQN@avalon>
In-Reply-To: <20180129163435.24936-27-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-27-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:31 EET Niklas S=F6derlund wrote:
> Add the ability to process media device link change request. Link
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
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 129 ++++++++++++++++++++++=
+++
>  1 file changed, 129 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> f08277a0dc11f477..7ceff0de40078580 100644
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
> @@ -44,6 +45,133 @@
>   */
>  #define rvin_group_id_to_master(vin) ((vin) < 4 ? 0 : 4)
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Media Controller link notification
> + */
> +
> +/* group lock should be held when calling this function */
> +static int rvin_group_entity_to_csi_id(struct rvin_group *group,
> +					struct media_entity *entity)
> +{
> +	struct v4l2_subdev *sd;
> +	int i;

unsigned int.

> +
> +	if (!is_media_entity_v4l2_subdev(entity))
> +		return -ENODEV;

Can this happen ?

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
> +					unsigned char chan)
> +{
> +	const struct rvin_group_route *route;
> +	unsigned int mask =3D 0;
> +
> +	for (route =3D vin->info->routes; route->mask; route++) {

Please document the fact that the array needs to be terminated by an empty=
=20
element in the kerneldoc for vin->info->routes.

> +		if (route->vin =3D=3D vin->id &&
> +		    route->csi =3D=3D csi_id &&
> +		    route->chan =3D=3D chan) {
> +			vin_dbg(vin, "Adding route: vin: %d csi: %d chan: %d\n",
> +				route->vin, route->csi, route->chan);
> +			mask |=3D route->mask;
> +		}
> +	}
> +
> +	return mask;
> +}
> +
> +static int rvin_group_link_notify(struct media_link *link, u32 flags,
> +				  unsigned int notification)
> +{
> +	struct rvin_group *group =3D container_of(link->graph_obj.mdev,
> +						struct rvin_group, mdev);
> +	unsigned int i, master_id, chan, mask_new, mask =3D ~0;

I'm sure you could spare a few more lines :-)

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
> +	/* Only care about link enablement for VIN nodes */
> +	if (!(flags & MEDIA_LNK_FL_ENABLED) ||
> +	    !is_media_entity_v4l2_video_device(link->sink->entity))
> +		return 0;
> +
> +	/* If any entity are in use don't allow link changes */

s/are/is/

> +	media_device_for_each_entity(entity, &group->mdev)
> +		if (entity->use_count)
> +			return -EBUSY;
> +
> +	mutex_lock(&group->lock);
> +
> +	/* Find VIN and its master for which the link */

The words make sense individually. Maybe you could try a different order ? =
:-)

> +	entity =3D link->sink->entity;
> +	vdev =3D media_entity_to_video_device(entity);

You can combine those two lines and remove the entity variable.

> +	for (i =3D 0; i < RCAR_VIN_NUM; i++) {
> +		if (group->vin[i] && &group->vin[i]->vdev =3D=3D vdev) {
> +			vin =3D group->vin[i];
> +			master_id =3D rvin_group_id_to_master(vin->id);
> +			break;
> +		}
> +	}
> +	if (WARN_ON(!vin || !group->vin[master_id])) {
> +		ret =3D -ENODEV;
> +		goto out;
> +	}
> +
> +	/* Build a mask for already enabled links */
> +	for (i =3D master_id; i < master_id + 4; i++) {
> +		if (!group->vin[i])
> +			continue;
> +
> +		/* Get remote CSI-2, if any */
> +		csi_pad =3D media_entity_remote_pad(
> +				&group->vin[i]->vdev.entity.pads[0]);
> +		if (!csi_pad)
> +			continue;
> +
> +		csi_id =3D rvin_group_entity_to_csi_id(group, csi_pad->entity);
> +		chan =3D rvin_group_csi_pad_to_chan(csi_pad->index);
> +
> +		mask &=3D rvin_group_get_mask(group->vin[i], csi_id, chan);
> +	}
> +
> +	/* Add the new link to the existing mask and check if it works */
> +	csi_id =3D rvin_group_entity_to_csi_id(group, link->source->entity);
> +	chan =3D rvin_group_csi_pad_to_chan(link->source->index);
> +	mask_new =3D mask & rvin_group_get_mask(vin, csi_id, chan);
> +
> +	vin_dbg(vin, "Try link change mask: 0x%x new: 0x%x\n", mask, mask_new);
> +
> +	if (!mask_new) {
> +		ret =3D -EMLINK;
> +		goto out;
> +	}
> +
> +	/* New valid CHSEL found, set the new value */
> +	rvin_set_channel_routing(group->vin[master_id], __ffs(mask_new));
> +out:
> +	mutex_unlock(&group->lock);
> +
> +	return ret;

I assume this work, but without knowing what the mask field is, it's hard t=
o=20
comment. As stated in the review of a previous patch please document the ma=
sk=20
field correctly, and please explain the algorithm at the beginning of this=
=20
function.

> +}
> +
> +static const struct media_device_ops rvin_media_ops =3D {
> +	.link_notify =3D rvin_group_link_notify,
> +};
> +
>  /* ---------------------------------------------------------------------=
=2D--
>   * Gen3 CSI2 Group Allocator
>   */
> @@ -85,6 +213,7 @@ static int rvin_group_init(struct rvin_group *group,
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

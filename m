Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51706 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965676AbeBMVAc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 16:00:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 25/30] rcar-vin: parse Gen3 OF and setup media graph
Date: Tue, 13 Feb 2018 23:01:03 +0200
Message-ID: <10215234.Ncu5prJo3h@avalon>
In-Reply-To: <20180129163435.24936-26-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se> <20180129163435.24936-26-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday, 29 January 2018 18:34:30 EET Niklas S=F6derlund wrote:
> The parsing and registering CSI-2 subdevices with the v4l2 async
> framework is a collaborative effort shared between the VIN instances
> which are part of the group. When the last VIN in the group is probed it
> asks all other VINs to parse its share of OF and record the async
> subdevices it finds in the notifier belonging to the last probed VIN.
>=20
> Once all CSI-2 subdevices in this notifier are bound proceed to register
> all VIN video devices of the group and crate media device links between
> all CSI-2 and VIN entities according to the SoC specific routing
> configuration.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 250 ++++++++++++++++++++++=
++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  12 +-
>  2 files changed, 258 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 4a64df5019ce45f7..f08277a0dc11f477 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -27,6 +27,23 @@
>=20
>  #include "rcar-vin.h"
>=20
> +/*
> + * The companion CSI-2 receiver driver (rcar-csi2) is known
> + * and we know it have one source pad (pad 0) and four sink

s/have/has/

> + * pads (pad 1-4). So to translate a pad on the remote
> + * CSI-2 receiver to/from the VIN internal channel number simply
> + * subtract/add or one from the pad/chan number.

s/or one/one/

and maybe s/chan/channel/ ?

> + */
> +#define rvin_group_csi_pad_to_chan(pad) ((pad) - 1)
> +#define rvin_group_csi_chan_to_pad(chan) ((chan) + 1)
> +
> +/*
> + * Not all VINs are created equal, master VINs control the
> + * routing for other VIN's. We can figure out which VIN is
> + * master by looking at a VINs id
> + */
> +#define rvin_group_id_to_master(vin) ((vin) < 4 ? 0 : 4)
> +
>  /* ---------------------------------------------------------------------=
=2D--
>   * Gen3 CSI2 Group Allocator
>   */
> @@ -77,6 +94,8 @@ static int rvin_group_init(struct rvin_group *group,
> struct rvin_dev *vin) snprintf(mdev->bus_info, sizeof(mdev->bus_info),
> "platform:%s",
>  		 dev_name(mdev->dev));
>=20
> +	group->notifier =3D NULL;
> +

The group has been allocated with kzalloc() so this isn't necessary.

>  	media_device_init(mdev);
>=20
>  	ret =3D media_device_register(&group->mdev);
> @@ -406,6 +425,218 @@ static int rvin_digital_graph_init(struct rvin_dev
> *vin) return 0;
>  }
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Group async notifier
> + */
> +
> +static int rvin_group_notify_complete(struct v4l2_async_notifier *notifi=
er)
> +{
> +	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> +	const struct rvin_group_route *route;
> +	unsigned int i;
> +	int ret;
> +
> +	ret =3D v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
> +	if (ret) {
> +		vin_err(vin, "Failed to register subdev nodes\n");
> +		return ret;
> +	}
> +
> +	/* Register all video nodes for the group */
> +	for (i =3D 0; i < RCAR_VIN_NUM; i++) {
> +		if (vin->group->vin[i]) {
> +			ret =3D rvin_v4l2_register(vin->group->vin[i]);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	/* Create all media device links between VINs and CSI-2's */
> +	mutex_lock(&vin->group->lock);
> +	for (route =3D vin->info->routes; route->mask; route++) {
> +		struct media_pad *source_pad, *sink_pad;
> +		struct media_entity *source, *sink;
> +		unsigned int source_idx;
> +
> +		/* Check that VIN is part of the group */
> +		if (!vin->group->vin[route->vin])
> +			continue;
> +
> +		/* Check that VIN' master is part of the group */
> +		if (!vin->group->vin[rvin_group_id_to_master(route->vin)])
> +			continue;
> +
> +		/* Check that CSI-2 is part of the group */
> +		if (!vin->group->csi[route->csi].subdev)
> +			continue;
> +
> +		source =3D &vin->group->csi[route->csi].subdev->entity;
> +		source_idx =3D rvin_group_csi_chan_to_pad(route->chan);
> +		source_pad =3D &source->pads[source_idx];
> +
> +		sink =3D &vin->group->vin[route->vin]->vdev.entity;
> +		sink_pad =3D &sink->pads[0];
> +
> +		/* Skip if link already exists */
> +		if (media_entity_find_link(source_pad, sink_pad))
> +			continue;
> +
> +		ret =3D media_create_pad_link(source, source_idx, sink, 0, 0);
> +		if (ret) {
> +			vin_err(vin, "Error adding link from %s to %s\n",
> +				source->name, sink->name);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&vin->group->lock);
> +
> +	return ret;
> +}
> +
> +static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifie=
r,
> +				     struct v4l2_subdev *subdev,
> +				     struct v4l2_async_subdev *asd)
> +{
> +	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> +	unsigned int i;
> +
> +	for (i =3D 0; i < RCAR_VIN_NUM; i++)
> +		if (vin->group->vin[i])
> +			rvin_v4l2_unregister(vin->group->vin[i]);
> +
> +	mutex_lock(&vin->group->lock);
> +
> +	for (i =3D 0; i < RVIN_CSI_MAX; i++) {
> +		if (vin->group->csi[i].fwnode !=3D asd->match.fwnode)
> +			continue;
> +		vin->group->csi[i].subdev =3D NULL;
> +		vin_dbg(vin, "Unbind CSI-2 %s from slot %u\n", subdev->name, i);
> +		break;
> +	}
> +
> +	mutex_unlock(&vin->group->lock);
> +}
> +
> +static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> +	unsigned int i;
> +
> +	mutex_lock(&vin->group->lock);
> +
> +	for (i =3D 0; i < RVIN_CSI_MAX; i++) {
> +		if (vin->group->csi[i].fwnode !=3D asd->match.fwnode)
> +			continue;
> +		vin->group->csi[i].subdev =3D subdev;
> +		vin_dbg(vin, "Bound CSI-2 %s to slot %u\n", subdev->name, i);
> +		break;
> +	}
> +
> +	mutex_unlock(&vin->group->lock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_async_notifier_operations rvin_group_notify_ops=
 =3D
> {
> +	.bound =3D rvin_group_notify_bound,
> +	.unbind =3D rvin_group_notify_unbind,
> +	.complete =3D rvin_group_notify_complete,
> +};
> +
> +static int rvin_mc_parse_v4l2(struct device *dev,
> +				   struct v4l2_fwnode_endpoint *vep,
> +				   struct v4l2_async_subdev *asd)

As this parses one endpoint, maybe rvin_mc_parse_of_endpoint() ?

> +{
> +	struct rvin_dev *vin =3D dev_get_drvdata(dev);
> +	struct v4l2_async_notifier *notifier =3D vin->group->notifier;
> +	unsigned int i;
> +
> +	if (vep->base.port !=3D 1 || vep->base.id >=3D RVIN_CSI_MAX)
> +		return -EINVAL;
> +
> +	if (!of_device_is_available(to_of_node(asd->match.fwnode))) {
> +		vin_dbg(vin, "Subdevice %pOF disabled, ignoring\n",
> +			to_of_node(asd->match.fwnode));

It's not the subdevice that is disabled, it's the OF node, so I'd write thi=
s=20
"OF device %pOF disabled, ignoring".

> +		return -ENOTCONN;
> +
> +	}
> +
> +	for (i =3D 0; i < notifier->num_subdevs; i++) {
> +		if (notifier->subdevs[i]->match.fwnode =3D=3D asd->match.fwnode) {
> +			vin_dbg(vin, "Subdevice %pOF already handled\n",
> +				to_of_node(asd->match.fwnode));

Ditto.

> +			return -ENOTCONN;
> +		}
> +	}

Do you need a loop, or could you just test if vin->group->csi[vep-
>base.id].fwnode is non-NULL ?

> +	vin->group->csi[vep->base.id].fwnode =3D asd->match.fwnode;
> +
> +	vin_dbg(vin, "Add group subdevice %pOF to slot %u\n",
> +		to_of_node(asd->match.fwnode), vep->base.id);

And here too.

> +	return 0;
> +}
> +
> +static int rvin_mc_try_parse(struct rvin_dev *vin)

"try" parse ? Do you really expect this to be so difficult that we'll likel=
y=20
fail ? :-) How about rvin_mc_parse_of_graph() ?

> +{
> +	unsigned int i, count =3D 0;

I'd split that on two lines.

> +	int ret;
> +
> +	mutex_lock(&vin->group->lock);
> +
> +	/* If there already is a notifier something have gone wrong, bail */

s/have/has/

and I assume you mean "bail out", not "bail".

> +	if (WARN_ON(vin->group->notifier)) {
> +		mutex_unlock(&vin->group->lock);
> +		return -EINVAL;
> +	}
> +
> +	/* If not all VIN's are registered don't register the notifier */
> +	for (i =3D 0; i < RCAR_VIN_NUM; i++)
> +		if (vin->group->vin[i])
> +			count++;
> +
> +	if (vin->group->count !=3D count) {
> +		mutex_unlock(&vin->group->lock);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Have all VIN's look for subdevices. Some subdevices will overlap
> +	 * but the parser function can handle it, so each subdevice will
> +	 * only be registered once with the notifier

Do you have anything particular against periods at end of sentences (and th=
is=20
also applies to single-sentence comments) ? If not, this comment applies to=
=20
the whole series.

> +	 */
> +
> +	vin->group->notifier =3D &vin->notifier;
> +
> +	for (i =3D 0; i < RCAR_VIN_NUM; i++) {
> +		if (!vin->group->vin[i])
> +			continue;
> +
> +		ret =3D v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> +				vin->group->vin[i]->dev, vin->group->notifier,
> +				sizeof(struct v4l2_async_subdev), 1,
> +				rvin_mc_parse_v4l2);
> +		if (ret) {
> +			mutex_unlock(&vin->group->lock);
> +			return ret;
> +		}
> +	}

I'll refrain from telling how much this makes me want to cry. I know we hav=
e=20
no other choice for now, but still :(

> +	mutex_unlock(&vin->group->lock);
> +
> +	vin->group->notifier->ops =3D &rvin_group_notify_ops;
> +
> +	ret =3D v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> +	if (ret < 0) {
> +		vin_err(vin, "Notifier registration failed\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int rvin_mc_init(struct rvin_dev *vin)
>  {
>  	int ret;
> @@ -419,7 +650,15 @@ static int rvin_mc_init(struct rvin_dev *vin)
>  	if (ret)
>  		return ret;
>=20
> -	return rvin_group_get(vin);
> +	ret =3D rvin_group_get(vin);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D rvin_mc_try_parse(vin);
> +	if (ret)
> +		rvin_group_put(vin);
> +
> +	return ret;
>  }
>=20
>  /* ---------------------------------------------------------------------=
=2D--
> @@ -539,10 +778,15 @@ static int rcar_vin_remove(struct platform_device
> *pdev) v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>=20
> -	if (vin->info->use_mc)
> +	if (vin->info->use_mc) {
> +		mutex_lock(&vin->group->lock);
> +		if (vin->group->notifier =3D=3D &vin->notifier)
> +			vin->group->notifier =3D NULL;
> +		mutex_unlock(&vin->group->lock);
>  		rvin_group_put(vin);
> -	else
> +	} else {
>  		v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +	}
>=20
>  	rvin_dma_unregister(vin);
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> ca2c2a23cef8506c..6cef78df42047c8c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -207,9 +207,13 @@ struct rvin_dev {
>   *
>   * @mdev:		media device which represents the group
>   *
> - * @lock:		protects the count and vin members
> + * @lock:		protects the count, notifier, vin and csi members
>   * @count:		number of enabled VIN instances found in DT
> + * @notifier:		pointer to the notifier of a VIN which handles the
> + *			groups async sub-devices.
>   * @vin:		VIN instances which are part of the group
> + * @csi:		array of pairs of fwnode and subdev pointers
> + *			to all CSI-2 subdevices.
>   */
>  struct rvin_group {
>  	struct kref refcount;
> @@ -218,7 +222,13 @@ struct rvin_group {
>=20
>  	struct mutex lock;
>  	unsigned int count;
> +	struct v4l2_async_notifier *notifier;
>  	struct rvin_dev *vin[RCAR_VIN_NUM];
> +
> +	struct {
> +		struct fwnode_handle *fwnode;
> +		struct v4l2_subdev *subdev;
> +	} csi[RVIN_CSI_MAX];
>  };
>=20
>  int rvin_dma_register(struct rvin_dev *vin, int irq);

With these small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

We clearly need a new review tag to tell "this is horrible but I agree to l=
et=20
it in" :-/

=2D-=20
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:40325 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967452AbeEXUUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:20:02 -0400
Date: Thu, 24 May 2018 22:19:57 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 1/9] media: rcar-vin: Rename 'digital' to 'parallel'
Message-ID: <20180524201957.GF18369@w540>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-2-git-send-email-jacopo+renesas@jmondi.org>
 <20180523224225.GF5115@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
Content-Disposition: inline
In-Reply-To: <20180523224225.GF5115@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Thu, May 24, 2018 at 12:42:25AM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your patch.
>
> On 2018-05-18 16:40:37 +0200, Jacopo Mondi wrote:
> > As the term 'digital' is used all over the rcar-vin code in place of
> > 'parallel', rename all the occurrencies.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 72 ++++++++++++++-------=
--------
> >  drivers/media/platform/rcar-vin/rcar-dma.c  |  4 +-
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 12 ++---
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  6 +--
> >  4 files changed, 47 insertions(+), 47 deletions(-)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/medi=
a/platform/rcar-vin/rcar-core.c
> > index d3072e1..6b80f98 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -376,12 +376,12 @@ static int rvin_find_pad(struct v4l2_subdev *sd, =
int direction)
> >  }
> >
> >  /* -------------------------------------------------------------------=
----------
> > - * Digital async notifier
> > + * Parallel async notifier
> >   */
> >
> >  /* The vin lock should be held when calling the subdevice attach and d=
etach */
> > -static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
> > -					 struct v4l2_subdev *subdev)
> > +static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
> > +					  struct v4l2_subdev *subdev)
> >  {
> >  	struct v4l2_subdev_mbus_code_enum code =3D {
> >  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> > @@ -392,15 +392,15 @@ static int rvin_digital_subdevice_attach(struct r=
vin_dev *vin,
> >  	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> >  	if (ret < 0)
> >  		return ret;
> > -	vin->digital->source_pad =3D ret;
> > +	vin->parallel->source_pad =3D ret;
> >
> >  	ret =3D rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
> > -	vin->digital->sink_pad =3D ret < 0 ? 0 : ret;
> > +	vin->parallel->sink_pad =3D ret < 0 ? 0 : ret;
> >
> >  	/* Find compatible subdevices mbus format */
> >  	vin->mbus_code =3D 0;
> >  	code.index =3D 0;
> > -	code.pad =3D vin->digital->source_pad;
> > +	code.pad =3D vin->parallel->source_pad;
> >  	while (!vin->mbus_code &&
> >  	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
> >  		code.index++;
> > @@ -450,21 +450,21 @@ static int rvin_digital_subdevice_attach(struct r=
vin_dev *vin,
> >
> >  	vin->vdev.ctrl_handler =3D &vin->ctrl_handler;
> >
> > -	vin->digital->subdev =3D subdev;
> > +	vin->parallel->subdev =3D subdev;
> >
> >  	return 0;
> >  }
> >
> > -static void rvin_digital_subdevice_detach(struct rvin_dev *vin)
> > +static void rvin_parallel_subdevice_detach(struct rvin_dev *vin)
> >  {
> >  	rvin_v4l2_unregister(vin);
> >  	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> >
> >  	vin->vdev.ctrl_handler =3D NULL;
> > -	vin->digital->subdev =3D NULL;
> > +	vin->parallel->subdev =3D NULL;
> >  }
> >
> > -static int rvin_digital_notify_complete(struct v4l2_async_notifier *no=
tifier)
> > +static int rvin_parallel_notify_complete(struct v4l2_async_notifier *n=
otifier)
> >  {
> >  	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> >  	int ret;
> > @@ -478,28 +478,28 @@ static int rvin_digital_notify_complete(struct v4=
l2_async_notifier *notifier)
> >  	return rvin_v4l2_register(vin);
> >  }
> >
> > -static void rvin_digital_notify_unbind(struct v4l2_async_notifier *not=
ifier,
> > -				       struct v4l2_subdev *subdev,
> > -				       struct v4l2_async_subdev *asd)
> > +static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *no=
tifier,
> > +				        struct v4l2_subdev *subdev,
> > +				        struct v4l2_async_subdev *asd)
>
> When I run my indentation script this indentation changes from spaces to
> all tabs. If possible I would like to keep that as I usually run it on
> these files before submitting any patches, but it's not a big deal.

Oh I didn't notice that we now have exactly 8 spaces there.
I'll change this for sure!

Thanks
   j

>
> Whit this fixed, thanks for clearing this up!
>
> Acked-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
>
> >  {
> >  	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> >
> > -	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> > +	vin_dbg(vin, "unbind parallel subdev %s\n", subdev->name);
> >
> >  	mutex_lock(&vin->lock);
> > -	rvin_digital_subdevice_detach(vin);
> > +	rvin_parallel_subdevice_detach(vin);
> >  	mutex_unlock(&vin->lock);
> >  }
> >
> > -static int rvin_digital_notify_bound(struct v4l2_async_notifier *notif=
ier,
> > -				     struct v4l2_subdev *subdev,
> > -				     struct v4l2_async_subdev *asd)
> > +static int rvin_parallel_notify_bound(struct v4l2_async_notifier *noti=
fier,
> > +				      struct v4l2_subdev *subdev,
> > +				      struct v4l2_async_subdev *asd)
> >  {
> >  	struct rvin_dev *vin =3D notifier_to_vin(notifier);
> >  	int ret;
> >
> >  	mutex_lock(&vin->lock);
> > -	ret =3D rvin_digital_subdevice_attach(vin, subdev);
> > +	ret =3D rvin_parallel_subdevice_attach(vin, subdev);
> >  	mutex_unlock(&vin->lock);
> >  	if (ret)
> >  		return ret;
> > @@ -507,21 +507,21 @@ static int rvin_digital_notify_bound(struct v4l2_=
async_notifier *notifier,
> >  	v4l2_set_subdev_hostdata(subdev, vin);
> >
> >  	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
> > -		subdev->name, vin->digital->source_pad,
> > -		vin->digital->sink_pad);
> > +		subdev->name, vin->parallel->source_pad,
> > +		vin->parallel->sink_pad);
> >
> >  	return 0;
> >  }
> >
> > -static const struct v4l2_async_notifier_operations rvin_digital_notify=
_ops =3D {
> > -	.bound =3D rvin_digital_notify_bound,
> > -	.unbind =3D rvin_digital_notify_unbind,
> > -	.complete =3D rvin_digital_notify_complete,
> > +static const struct v4l2_async_notifier_operations rvin_parallel_notif=
y_ops =3D {
> > +	.bound =3D rvin_parallel_notify_bound,
> > +	.unbind =3D rvin_parallel_notify_unbind,
> > +	.complete =3D rvin_parallel_notify_complete,
> >  };
> >
> > -static int rvin_digital_parse_v4l2(struct device *dev,
> > -				   struct v4l2_fwnode_endpoint *vep,
> > -				   struct v4l2_async_subdev *asd)
> > +static int rvin_parallel_parse_v4l2(struct device *dev,
> > +				    struct v4l2_fwnode_endpoint *vep,
> > +				    struct v4l2_async_subdev *asd)
> >  {
> >  	struct rvin_dev *vin =3D dev_get_drvdata(dev);
> >  	struct rvin_graph_entity *rvge =3D
> > @@ -546,28 +546,28 @@ static int rvin_digital_parse_v4l2(struct device =
*dev,
> >  		return -EINVAL;
> >  	}
> >
> > -	vin->digital =3D rvge;
> > +	vin->parallel =3D rvge;
> >
> >  	return 0;
> >  }
> >
> > -static int rvin_digital_graph_init(struct rvin_dev *vin)
> > +static int rvin_parallel_graph_init(struct rvin_dev *vin)
> >  {
> >  	int ret;
> >
> >  	ret =3D v4l2_async_notifier_parse_fwnode_endpoints(
> >  		vin->dev, &vin->notifier,
> > -		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
> > +		sizeof(struct rvin_graph_entity), rvin_parallel_parse_v4l2);
> >  	if (ret)
> >  		return ret;
> >
> > -	if (!vin->digital)
> > +	if (!vin->parallel)
> >  		return -ENODEV;
> >
> > -	vin_dbg(vin, "Found digital subdevice %pOF\n",
> > -		to_of_node(vin->digital->asd.match.fwnode));
> > +	vin_dbg(vin, "Found parallel subdevice %pOF\n",
> > +		to_of_node(vin->parallel->asd.match.fwnode));
> >
> > -	vin->notifier.ops =3D &rvin_digital_notify_ops;
> > +	vin->notifier.ops =3D &rvin_parallel_notify_ops;
> >  	ret =3D v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> >  	if (ret < 0) {
> >  		vin_err(vin, "Notifier registration failed\n");
> > @@ -1088,7 +1088,7 @@ static int rcar_vin_probe(struct platform_device =
*pdev)
> >  	if (vin->info->use_mc)
> >  		ret =3D rvin_mc_init(vin);
> >  	else
> > -		ret =3D rvin_digital_graph_init(vin);
> > +		ret =3D rvin_parallel_graph_init(vin);
> >  	if (ret < 0)
> >  		goto error;
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media=
/platform/rcar-vin/rcar-dma.c
> > index ac07f99..f1c3585 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -733,7 +733,7 @@ static int rvin_setup(struct rvin_dev *vin)
> >  		vnmc |=3D VNMC_BPS;
> >
> >  	if (vin->info->model =3D=3D RCAR_GEN3) {
> > -		/* Select between CSI-2 and Digital input */
> > +		/* Select between CSI-2 and parallel input */
> >  		if (vin->mbus_cfg.type =3D=3D V4L2_MBUS_CSI2)
> >  			vnmc &=3D ~VNMC_DPINE;
> >  		else
> > @@ -1074,7 +1074,7 @@ static int rvin_set_stream(struct rvin_dev *vin, =
int on)
> >
> >  	/* No media controller used, simply pass operation to subdevice. */
> >  	if (!vin->info->use_mc) {
> > -		ret =3D v4l2_subdev_call(vin->digital->subdev, video, s_stream,
> > +		ret =3D v4l2_subdev_call(vin->parallel->subdev, video, s_stream,
> >  				       on);
> >
> >  		return ret =3D=3D -ENOIOCTLCMD ? 0 : ret;
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/medi=
a/platform/rcar-vin/rcar-v4l2.c
> > index e78fba8..87a718b 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -144,7 +144,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
> >  {
> >  	struct v4l2_subdev_format fmt =3D {
> >  		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> > -		.pad =3D vin->digital->source_pad,
> > +		.pad =3D vin->parallel->source_pad,
> >  	};
> >  	int ret;
> >
> > @@ -175,7 +175,7 @@ static int rvin_try_format(struct rvin_dev *vin, u3=
2 which,
> >  	struct v4l2_subdev_pad_config *pad_cfg;
> >  	struct v4l2_subdev_format format =3D {
> >  		.which =3D which,
> > -		.pad =3D vin->digital->source_pad,
> > +		.pad =3D vin->parallel->source_pad,
> >  	};
> >  	enum v4l2_field field;
> >  	u32 width, height;
> > @@ -517,7 +517,7 @@ static int rvin_enum_dv_timings(struct file *file, =
void *priv_fh,
> >  	if (timings->pad)
> >  		return -EINVAL;
> >
> > -	timings->pad =3D vin->digital->sink_pad;
> > +	timings->pad =3D vin->parallel->sink_pad;
> >
> >  	ret =3D v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
> >
> > @@ -569,7 +569,7 @@ static int rvin_dv_timings_cap(struct file *file, v=
oid *priv_fh,
> >  	if (cap->pad)
> >  		return -EINVAL;
> >
> > -	cap->pad =3D vin->digital->sink_pad;
> > +	cap->pad =3D vin->parallel->sink_pad;
> >
> >  	ret =3D v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
> >
> > @@ -587,7 +587,7 @@ static int rvin_g_edid(struct file *file, void *fh,=
 struct v4l2_edid *edid)
> >  	if (edid->pad)
> >  		return -EINVAL;
> >
> > -	edid->pad =3D vin->digital->sink_pad;
> > +	edid->pad =3D vin->parallel->sink_pad;
> >
> >  	ret =3D v4l2_subdev_call(sd, pad, get_edid, edid);
> >
> > @@ -605,7 +605,7 @@ static int rvin_s_edid(struct file *file, void *fh,=
 struct v4l2_edid *edid)
> >  	if (edid->pad)
> >  		return -EINVAL;
> >
> > -	edid->pad =3D vin->digital->sink_pad;
> > +	edid->pad =3D vin->parallel->sink_pad;
> >
> >  	ret =3D v4l2_subdev_call(sd, pad, set_edid, edid);
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media=
/platform/rcar-vin/rcar-vin.h
> > index c2aef78..755ac3c 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > @@ -146,7 +146,7 @@ struct rvin_info {
> >   * @v4l2_dev:		V4L2 device
> >   * @ctrl_handler:	V4L2 control handler
> >   * @notifier:		V4L2 asynchronous subdevs notifier
> > - * @digital:		entity in the DT for local digital subdevice
> > + * @parallel:		entity in the DT for local parallel subdevice
> >   *
> >   * @group:		Gen3 CSI group
> >   * @id:			Gen3 group id for this VIN
> > @@ -182,7 +182,7 @@ struct rvin_dev {
> >  	struct v4l2_device v4l2_dev;
> >  	struct v4l2_ctrl_handler ctrl_handler;
> >  	struct v4l2_async_notifier notifier;
> > -	struct rvin_graph_entity *digital;
> > +	struct rvin_graph_entity *parallel;
> >
> >  	struct rvin_group *group;
> >  	unsigned int id;
> > @@ -209,7 +209,7 @@ struct rvin_dev {
> >  	v4l2_std_id std;
> >  };
> >
> > -#define vin_to_source(vin)		((vin)->digital->subdev)
> > +#define vin_to_source(vin)		((vin)->parallel->subdev)
> >
> >  /* Debug */
> >  #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbBx5tAAoJEHI0Bo8WoVY8Xg8P/3bPBXxGGSDRBT0oy0wdk+Ly
CSUEJ2iry/L1ipVdhGHO5D7IbUPNysi2fnPFd8zV8ptMUdSkywA6irEtJqmdKeZh
genCYfsXcukCWIPV289Iwl0nTzoK6NmlZDuhPvxAOAHF/Hz23EzMfaYZfVxIlgXE
Y7Dc2mA03aLsqp6yMk5gHRt7fdVSBoUsYdhpjQT8RPIBun8Ctjpf6j3iBHC1ZT71
9plRqllWMsAOu7XyZrmcWH4U5IJ3gGle4d1ne/gS2rUZsRrxOKHsJyuYtCdjw/ch
m26ET+66hAB8n22KvQO9eiUbx/TInv0De2T7kZgj3BXmmNB56BM+VaP3XygUBkyw
ydQQAEI4QJas2X1ZIpbupb/OwlGUMVY6zyixhOgvj7pwZSQ/ZcnA3jxAl1nWjve1
vleK5OaeiA8BzaQVdTEZrVgDYyITgC2dt+9PtHZU7MHm3KnefQhtuAH000NEuv6Q
5bsgUWul6oqZOk/KBQKtoCzvU10uNEn45pW1vpFJ9W7FwlHy2ELnz4fhipyVxnKb
S0DHTiCRlJ+HaB8cmzvHqwkmqYCkY3klKu2jFBmusz0HYrNdh5og68j34kwyrCCd
llqoMoYZI4kI88+v6HBfYBb8o1a+JSxdto/lmiwHiXVcj5kf4wWX+RURGl2M3yPQ
GrgdoX7ZHpECVE9v0raG
=sv6I
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--

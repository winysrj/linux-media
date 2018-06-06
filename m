Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43812 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbeFFNv4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 09:51:56 -0400
Subject: Re: [RFC] media: renesas-ceu: Add media-controller support
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1528291333-20562-1-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e90d1516-88f0-8f7f-3c57-535aaf6491f2@ideasonboard.com>
Date: Wed, 6 Jun 2018 14:51:49 +0100
MIME-Version: 1.0
In-Reply-To: <1528291333-20562-1-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="gFsFfI6OfJojyvw5OZmo2RRWeekfvYd1w"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gFsFfI6OfJojyvw5OZmo2RRWeekfvYd1w
Content-Type: multipart/mixed; boundary="UtMrcBuyu1rmRotu2n7nN7AlAKUrlsgdm";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>, niklas.soderlund@ragnatech.se,
 laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Message-ID: <e90d1516-88f0-8f7f-3c57-535aaf6491f2@ideasonboard.com>
Subject: Re: [RFC] media: renesas-ceu: Add media-controller support
References: <1528291333-20562-1-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528291333-20562-1-git-send-email-jacopo+renesas@jmondi.org>

--UtMrcBuyu1rmRotu2n7nN7AlAKUrlsgdm
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Jacopo,

On 06/06/18 14:22, Jacopo Mondi wrote:
> Add initial support for media controller framework to the renesas-ceu d=
river.
>=20
> Adding media-controller support allows to operate sensors that expose a=
dvanced
> functionalities through the v4l2-subdev APIs.
>=20
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> Hello,
>    I'm in the process of adding support to a sensor driver that exposes=
 advanced
> functionalities through the v4l2-subdev APIs.
>=20
> In order to operate on it, I had to add initial media-controller suppor=
t to the
> host driver (renesas-ceu) to have the subdevice video nodes properly cr=
eated.
>=20
> The current implementation allows to create and operate on the media gr=
aph, but
> the result is a lot of #ifdef in the driver code I don't see in any oth=
er
> mainline platform driver.

I thought I saw a patch fly by which removed the need for #ifdef
MEDIA_CONTROLLER by allowing the mdev to exist and be NULL.

However I can't find that now, so maybe I was confused by something else =
- and I
see that in the latest RequestAPI series, [0], [1], non-mc drivers are ge=
tting
MC support out of necessity and this is wrapped in #ifdefs.

So I think for the moment, it's fine.

[0] https://www.mail-archive.com/linux-media@vger.kernel.org/msg132623.ht=
ml
[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg132634.ht=
ml

--
Kieran


> As there are more media-controller specificities to be supported (eg. s=
et_fmt
> that should not call into the subdev operations etc) before going too f=
ar I
> decided to send this out to collect suggestions.
>=20
> What is the best way to add media-controller support to a non-mc driver=
?
>=20
> Ideally I would like this to continue working with all sensor drivers, =
and thus
> I see a few ways of doing this:
>=20
> - Keep using #ifdef CONFIG_MEDIA_CONTROLLER, but I don't see it in any =
other
>   driver in mainline
> - Add a media-controller compatible string, and decide at runtime if we=
 should
>   use media-controller or not (similar to what VIN driver does)
> - Make the driver media controller only, but I fear 'old-style' sensor =
driver
>   won't be usable anymore with this new version.
>=20
> Any pointer/opinion is welcome.
>=20
> Thanks
>   j
> ---
>  drivers/media/platform/renesas-ceu.c | 111 +++++++++++++++++++++++++++=
++++++++
>  1 file changed, 111 insertions(+)
>=20
> diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platf=
orm/renesas-ceu.c
> index 46b0639..5911f097 100644
> --- a/drivers/media/platform/renesas-ceu.c
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -39,6 +39,7 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mc.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/videobuf2-dma-contig.h>
>=20
> @@ -158,6 +159,9 @@ struct ceu_subdev {
>  	/* per-subdevice mbus configuration options */
>  	unsigned int mbus_flags;
>  	struct ceu_mbus_fmt mbus_fmt;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	int source_pad;
> +#endif
>  };
>=20
>  static struct ceu_subdev *to_ceu_subdev(struct v4l2_async_subdev *asd)=

> @@ -173,6 +177,11 @@ struct ceu_device {
>  	struct video_device	vdev;
>  	struct v4l2_device	v4l2_dev;
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_device	mdev;
> +	struct media_pad	pad;
> +#endif
> +
>  	/* subdevices descriptors */
>  	struct ceu_subdev	*subdevs;
>  	/* the subdevice currently in use */
> @@ -1381,6 +1390,60 @@ static void ceu_vdev_release(struct video_device=
 *vdev)
>  	kfree(ceudev);
>  }
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static int ceu_find_pad(struct v4l2_subdev *sd, int direction)
> +{
> +	unsigned int pad;
> +
> +	if (sd->entity.num_pads <=3D 1)
> +		return 0;
> +
> +	for (pad =3D 0; pad < sd->entity.num_pads; pad++)
> +		if (sd->entity.pads[pad].flags & direction)
> +			return pad;
> +
> +	return -EINVAL;
> +}
> +
> +static int ceu_notify_complete_mc(struct ceu_device *ceudev)
> +{
> +	struct video_device *vdev =3D &ceudev->vdev;
> +	struct media_entity *source;
> +	struct media_entity *sink;
> +
> +	unsigned int i;
> +	int ret;
> +
> +	ret =3D media_device_register(&ceudev->mdev);
> +	if (ret) {
> +		v4l2_err(vdev->v4l2_dev,
> +			 "media_device_register failed : %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret =3D v4l2_device_register_subdev_nodes(&ceudev->v4l2_dev);
> +	if (ret)
> +		return ret;
> +
> +	/* Link subdev's first available source pad to CEU sink one. */
> +	for (i =3D 0; i < ceudev->num_sd; i++) {
> +		int source_pad =3D ceudev->subdevs[i].source_pad;
> +
> +		if (source_pad < 0)
> +			continue;
> +
> +		source =3D &ceudev->subdevs[i].v4l2_sd->entity;
> +		sink =3D &vdev->entity;
> +
> +		ret =3D media_create_pad_link(source, source_pad, sink, 0, 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
>  static int ceu_notify_bound(struct v4l2_async_notifier *notifier,
>  			    struct v4l2_subdev *v4l2_sd,
>  			    struct v4l2_async_subdev *asd)
> @@ -1392,6 +1455,11 @@ static int ceu_notify_bound(struct v4l2_async_no=
tifier *notifier,
>  	ceu_sd->v4l2_sd =3D v4l2_sd;
>  	ceudev->num_sd++;
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	/* Cache the entity source pad for later link creation. */
> +	ceu_sd->source_pad =3D ceu_find_pad(v4l2_sd, MEDIA_PAD_FL_SOURCE);
> +#endif
> +
>  	return 0;
>  }
>=20
> @@ -1459,6 +1527,14 @@ static int ceu_notify_complete(struct v4l2_async=
_notifier *notifier)
>  		return ret;
>  	}
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	ret =3D ceu_notify_complete_mc(ceudev);
> +	if (ret) {
> +		video_unregister_device(&ceudev->vdev);
> +		return ret;
> +	}
> +#endif
> +
>  	return 0;
>  }
>=20
> @@ -1467,6 +1543,12 @@ static const struct v4l2_async_notifier_operatio=
ns ceu_notify_ops =3D {
>  	.complete	=3D ceu_notify_complete,
>  };
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static const struct media_device_ops ceu_media_ops =3D {
> +	.link_notify =3D v4l2_pipeline_link_notify,
> +};
> +#endif
> +
>  /*
>   * ceu_init_async_subdevs() - Initialize CEU subdevices and async_subd=
evs in
>   *			      ceu device. Both DT and platform data parsing use
> @@ -1631,6 +1713,9 @@ static int ceu_probe(struct platform_device *pdev=
)
>  	struct device *dev =3D &pdev->dev;
>  	const struct ceu_data *ceu_data;
>  	struct ceu_device *ceudev;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_device *mdev;
> +#endif
>  	struct resource *res;
>  	unsigned int irq;
>  	int num_subdevs;
> @@ -1670,6 +1755,24 @@ static int ceu_probe(struct platform_device *pde=
v)
>=20
>  	pm_runtime_enable(dev);
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	mdev =3D &ceudev->mdev;
> +	mdev->dev =3D dev;
> +	mdev->ops =3D &ceu_media_ops;
> +	strlcpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name))=
;
> +	strlcpy(mdev->model, KBUILD_MODNAME, sizeof(mdev->model));
> +	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
> +		 dev_name(mdev->dev));
> +
> +	media_device_init(mdev);
> +	ceudev->v4l2_dev.mdev =3D mdev;
> +
> +	ceudev->pad.flags =3D MEDIA_PAD_FL_SINK;
> +	ret =3D media_entity_pads_init(&ceudev->vdev.entity, 1, &ceudev->pad)=
;
> +	if (ret)
> +		goto error_pm_disable;
> +#endif
> +
>  	ret =3D v4l2_device_register(dev, &ceudev->v4l2_dev);
>  	if (ret)
>  		goto error_pm_disable;
> @@ -1709,6 +1812,9 @@ static int ceu_probe(struct platform_device *pdev=
)
>  	v4l2_device_unregister(&ceudev->v4l2_dev);
>  error_pm_disable:
>  	pm_runtime_disable(dev);
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	media_device_cleanup(&ceudev->mdev);
> +#endif
>  error_free_ceudev:
>  	kfree(ceudev);
>=20
> @@ -1723,6 +1829,11 @@ static int ceu_remove(struct platform_device *pd=
ev)
>=20
>  	v4l2_async_notifier_unregister(&ceudev->notifier);
>=20
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	media_device_cleanup(&ceudev->mdev);
> +	media_device_unregister(&ceudev->mdev);
> +#endif
> +
>  	v4l2_device_unregister(&ceudev->v4l2_dev);
>=20
>  	video_unregister_device(&ceudev->vdev);
> --
> 2.7.4
>=20


--UtMrcBuyu1rmRotu2n7nN7AlAKUrlsgdm--

--gFsFfI6OfJojyvw5OZmo2RRWeekfvYd1w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlsX5vYACgkQoR5GchCk
Yf1iWxAAlX7nkLLlf1LZRwUiD7zpB6ysNLDT6R2fDtjsWXc2kDpZiaOQccTd8uDK
8frcTy7JZVGYgf+imBXDoCu1iFcvMPJrQBf7pztlrabbL2Zm2ab0WNxULS4zg4zl
t8iAAHu5OqfKGUaUGBU5TPMYuI35qpEbTKT8lHSXGoEFlnR019c8jj+I6VV7j71r
4HPynkyxdHe8ytA1T2jCOheQw/9DNH29VSDhOIqJHu8nc/UkcPFRt3QKHlAfZDfu
0KhpxY9JMawXHDu1g2ksQJdKJN0LeGyNWKqnlGNemMmqmpOEufhabk7R+D58svE7
R/Oo1dSJrxGQy56ayJT3tBLwmXs5++9RhgAikY718t37jAts1PERz5E0M+jzuMEn
ORN8K3YndiW+TfuUiovGSIEf1o8ZD+h6m1X9aft3nsI2vmXQGU/De5TEWlIpvE3o
gwLhoOh0dnZYscfj41zpEhyiSNHICVODiW7Ep5Qx1Ne151vCl28j9X1U8uDJuxyk
NMXYQvyRSg6pfQOvzlFD9ZAVyaahDczrKYsG3okh+97Vn0FuwRo7EP2qF4kqzJ3O
ZEnLh2e7Go7f1KIRKdB3Fu8rk+Wn4Gj7wNY1uY5A/a06+w073ebL6rtKKYXQ3cm8
5MbgAMXPRy2dwyMegH5kO89OdwPhNL3nUu44Gc7uFknJh+52ioo=
=i8Z/
-----END PGP SIGNATURE-----

--gFsFfI6OfJojyvw5OZmo2RRWeekfvYd1w--

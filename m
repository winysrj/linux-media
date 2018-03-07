Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43676 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933386AbeCGQig (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 11:38:36 -0500
Message-ID: <1520440654.1092.15.camel@bootlin.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date: Wed, 07 Mar 2018 17:37:34 +0100
In-Reply-To: <20180220044425.169493-20-acourbot@chromium.org>
References: <20180220044425.169493-20-acourbot@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-hHNWd2u71U+t6RHgvHqQ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-hHNWd2u71U+t6RHgvHqQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

First off, I'd like to take the occasion to say thank-you for your work.
This is a major piece of plumbing that is required for me to add support
for the Allwinner CedarX VPU hardware in upstream Linux. Other drivers,
such as tegra-vde (that was recently merged in staging) are also badly
in need of this API.

I have a few comments based on my experience integrating this request
API with the Cedrus VPU driver (and the associated libva backend), that
also concern the vim2m driver.

On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
> Set the necessary ops for supporting requests in vim2m.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/platform/Kconfig |  1 +
>  drivers/media/platform/vim2m.c | 75
> ++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
>=20
> diff --git a/drivers/media/platform/Kconfig
> b/drivers/media/platform/Kconfig
> index 614fbef08ddc..09be0b5f9afe 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig

[...]

> +static int vim2m_request_submit(struct media_request *req,
> +				struct media_request_entity_data
> *_data)
> +{
> +	struct v4l2_request_entity_data *data;
> +
> +	data =3D to_v4l2_entity_data(_data);

We need to call v4l2_m2m_try_schedule here so that m2m scheduling can
happen when only 2 buffers were queued and no other action was taken
from usespace. In that scenario, m2m scheduling currently doesn't
happen.

However, this requires access to the m2m context, which is not easy to
get from req or _data. I'm not sure that some container_of magic would
even do the trick here.

> +	return vb2_request_submit(data);

vb2_request_submit does not lock the associated request mutex although
it accesses the associated queued buffers list, which I believe this
mutex is supposed to protect.

We could either wrap this call with media_request_lock(req) and
media_request_unlock(req) or have the lock in the function itself, which
would require passing it the req pointer.

The latter would probably be safer for future use of the function.

> +}
> +
> +static const struct media_request_entity_ops vim2m_request_entity_ops
> =3D {
> +	.data_alloc	=3D vim2m_entity_data_alloc,
> +	.data_free	=3D v4l2_request_entity_data_free,
> +	.submit		=3D vim2m_request_submit,
> +};
> +
>  /*
>   * File operations
>   */
> @@ -900,6 +967,9 @@ static int vim2m_open(struct file *file)
>  	ctx->dev =3D dev;
>  	hdl =3D &ctx->hdl;
>  	v4l2_ctrl_handler_init(hdl, 4);
> +	v4l2_request_entity_init(&ctx->req_entity,
> &vim2m_request_entity_ops,
> +				 &ctx->dev->vfd);
> +	ctx->fh.entity =3D &ctx->req_entity.base;
>  	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0, 1,
> 1, 0);
>  	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0, 1,
> 1, 0);
>  	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec, NULL);
> @@ -999,6 +1069,9 @@ static int vim2m_probe(struct platform_device
> *pdev)
>  	if (!dev)
>  		return -ENOMEM;
> =20
> +	v4l2_request_mgr_init(&dev->req_mgr, &dev->vfd,
> +			      &v4l2_request_ops);
> +
>  	spin_lock_init(&dev->irqlock);
> =20
>  	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> @@ -1012,6 +1085,7 @@ static int vim2m_probe(struct platform_device
> *pdev)
>  	vfd =3D &dev->vfd;
>  	vfd->lock =3D &dev->dev_mutex;
>  	vfd->v4l2_dev =3D &dev->v4l2_dev;
> +	vfd->req_mgr =3D &dev->req_mgr.base;
> =20
>  	ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {
> @@ -1054,6 +1128,7 @@ static int vim2m_remove(struct platform_device
> *pdev)
>  	del_timer_sync(&dev->timer);
>  	video_unregister_device(&dev->vfd);
>  	v4l2_device_unregister(&dev->v4l2_dev);
> +	v4l2_request_mgr_free(&dev->req_mgr);
> =20
>  	return 0;
>  }

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-hHNWd2u71U+t6RHgvHqQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqgFU4ACgkQ3cLmz3+f
v9FUQwf/S4dKb/GrPnFohSVyWLIgt0BO+v5Ksf0XTY3rFUZsLfSkwz/uSvJSxNOD
1gJ9tj/hm4KfYeqnhKbrOWFuEfqhv92px8ft6p8iFgmkhrFoe5UtMI3/k1IakV2f
daV5wFxUSu2d3qIHcdlIAm27oQGxriGD42yJ6Aqtqs3Rcaxl2wwmoxdW+3aHMLG2
AJQavhbUg0irwEwW71Pq9L3sNB9U8FQKgZSXljujdRlYg6G1cQzkEdnWOwvBK23B
cikR6rB+RbuKeFDKWzoj2XCvZJpBDRMxGLTVxgtXPZWxDbq5mGa4Lptp/RUTpkbE
HnQfv0WEDw3isrE9QH5g/CmtcuRBzQ==
=kMeS
-----END PGP SIGNATURE-----

--=-hHNWd2u71U+t6RHgvHqQ--

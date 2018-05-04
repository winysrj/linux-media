Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50556 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbeEDIFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:05:38 -0400
Message-ID: <dd921da015112f2300a784caf2c21a88f63f1919.camel@bootlin.com>
Subject: Re: [PATCH v2 03/10] videobuf2-core: Add helper to get buffer
 private data from media request
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 04 May 2018 10:03:29 +0200
In-Reply-To: <20180419154124.17512-4-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154124.17512-4-paul.kocialkowski@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OkMVK6E3uX4i+oLxbLBv"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-OkMVK6E3uX4i+oLxbLBv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-04-19 at 17:41 +0200, Paul Kocialkowski wrote:
> When calling media operation driver callbacks related to media
> requests,
> only a pointer to the request itself is provided, which is
> insufficient
> to retrieve the driver's context. Since the driver context is usually
> set as vb2 queue private data and given that the core can determine
> which objects attached to the request are buffers, it is possible to
> extract the associated private data for the first buffer found.
>=20
> This is required in order to access the current m2m context from m2m
> drivers' private data in the context of media request operation
> callbacks. More specifically, this allows scheduling m2m device runs
> from the newly-introduced request complete operation.

This patch too will be dropped since it's no longer useful with the
latest version of the request API.

> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 15 +++++++++++++++
>  include/media/videobuf2-core.h                  |  1 +
>  2 files changed, 16 insertions(+)
>=20
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> b/drivers/media/common/videobuf2/videobuf2-core.c
> index 13c9d9e243dd..6fa46bfc620f 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1351,6 +1351,21 @@ bool vb2_core_request_has_buffers(struct
> media_request *req)
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_request_has_buffers);
> =20
> +void *vb2_core_request_find_buffer_priv(struct media_request *req)
> +{
> +	struct media_request_object *obj;
> +	struct vb2_buffer *vb;
> +
> +	obj =3D media_request_object_find(req, &vb2_core_req_ops,
> NULL);
> +	if (!obj)
> +		return NULL;
> +
> +	vb =3D container_of(obj, struct vb2_buffer, req_obj);
> +
> +	return vb2_get_drv_priv(vb->vb2_queue);
> +}
> +EXPORT_SYMBOL_GPL(vb2_core_request_find_buffer_priv);
> +
>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index,
> void *pb,
>  			 struct media_request *req)
>  {
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-
> core.h
> index 032bd1bec555..65c0cf6afb55 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -1153,4 +1153,5 @@ int vb2_verify_memory_type(struct vb2_queue *q,
>  		enum vb2_memory memory, unsigned int type);
> =20
>  bool vb2_core_request_has_buffers(struct media_request *req);
> +void *vb2_core_request_find_buffer_priv(struct media_request *req);
>  #endif /* _MEDIA_VIDEOBUF2_CORE_H */
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-OkMVK6E3uX4i+oLxbLBv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsE9EACgkQ3cLmz3+f
v9HYxwf9GfHkwCzO+xymDzRl8+yiO7l0OJn+I66l64ESLA+4bTLsrXnox8NkNFAX
y2bZ0hxgk8ZDQ2Utu/T3RjoSdxtmKEchgKcwSti0Ljx//N6fdXZR6Pw2+/JMEX0N
hpUGhFFkF4gSkjV6TD+PggXZWSnxzKTUkyTrCvw/AdzKdBy5nYjYTI6sdL9b6cod
eqUUxREXsGHjvKBxZu74sA3LH6TQ5fa7yaLcZqfLLy3ARrzuzhQ1yLlyAOjp0xQ+
PZMNLuU8vrJ2aZ7Sqn5njhDsXdRBkSAdxrHQXU5tMN82tMG45CJPJnnJXVHWCA81
Fnyo4av3S7P6vODY0RqgwODQ3soPdA==
=zhfg
-----END PGP SIGNATURE-----

--=-OkMVK6E3uX4i+oLxbLBv--

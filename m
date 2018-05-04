Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50488 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbeEDIEg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:04:36 -0400
Message-ID: <ddab13eb3dbc179d4a366248b5f510f147b02556.camel@bootlin.com>
Subject: Re: [PATCH v2 02/10] media-request: Add a request complete
 operation to allow m2m scheduling
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
Date: Fri, 04 May 2018 10:03:05 +0200
In-Reply-To: <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7ElAg6Ux7kGsIjD5tVrd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-7ElAg6Ux7kGsIjD5tVrd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-04-19 at 17:41 +0200, Paul Kocialkowski wrote:
> When using the request API in the context of a m2m driver, the
> operations that come with a m2m run scheduling call in their
> (m2m-specific) ioctl handler are delayed until the request is queued
> (for instance, this includes queuing buffers and streamon).
>=20
> Thus, the m2m run scheduling calls are not called in due time since
> the
> request AP's internal plumbing will (rightfully) use the relevant core
> functions directly instead of the ioctl handler.
>=20
> This ends up in a situation where nothing happens if there is no
> run-scheduling ioctl called after queuing the request.
>=20
> In order to circumvent the issue, a new media operation is introduced,
> called at the time of handling the media request queue ioctl. It gives
> m2m drivers a chance to schedule a m2m device run at that time.
>=20
> The existing req_queue operation cannot be used for this purpose,
> since
> it is called with the request queue mutex held, that is eventually
> needed
> in the device_run call to apply relevant controls.

This patch will be dropped since it's no longer useful with the latest
version of the request API.

> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/media-request.c | 3 +++
>  include/media/media-device.h  | 2 ++
>  2 files changed, 5 insertions(+)
>=20
> diff --git a/drivers/media/media-request.c b/drivers/media/media-
> request.c
> index 415f7e31019d..28ac5ccfe6a2 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -157,6 +157,9 @@ static long media_request_ioctl_queue(struct
> media_request *req)
>  		media_request_get(req);
>  	}
> =20
> +	if (mdev->ops->req_complete)
> +		mdev->ops->req_complete(req);
> +
>  	return ret;
>  }
> =20
> diff --git a/include/media/media-device.h b/include/media/media-
> device.h
> index 07e323c57202..c7dcf2079cc9 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -55,6 +55,7 @@ struct media_entity_notify {
>   * @req_alloc: Allocate a request
>   * @req_free: Free a request
>   * @req_queue: Queue a request
> + * @req_complete: Complete a request
>   */
>  struct media_device_ops {
>  	int (*link_notify)(struct media_link *link, u32 flags,
> @@ -62,6 +63,7 @@ struct media_device_ops {
>  	struct media_request *(*req_alloc)(struct media_device
> *mdev);
>  	void (*req_free)(struct media_request *req);
>  	int (*req_queue)(struct media_request *req);
> +	void (*req_complete)(struct media_request *req);
>  };
> =20
>  /**
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-7ElAg6Ux7kGsIjD5tVrd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsE7kACgkQ3cLmz3+f
v9HomAf/U5gnx6ZprY8K3VbK3hDNSCzIPHXorx02poTTlLsTDO/H5j+5Woi/y9BF
kV/Y6TdvZVyoR6mkXUrqxA+zAjr68cMsvtNwcoWODVtVGzmmgtqfQmlhvzzs8sIv
RdTIxHaWDbHTMn39MS40xQjGrFkEZ5haPLjnDh9ziVisr7gftvWmwawhB0JkRsqm
/XKucxJVj5UPucPGfAVBBLJmnOxOsXNjOWq7IEPnaUWIJktKzSuYHWLiRikXsoPF
W8tJLWQNRt8xJFHaJHEZeKz/9Hao1jm0+x1x/zL7DViUje2KUaw4mrY2n2RHLq5P
NTxR6xAHKKJTzFzl1ZkAA53Ab+OZbg==
=3zgR
-----END PGP SIGNATURE-----

--=-7ElAg6Ux7kGsIjD5tVrd--

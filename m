Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45862 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdJHVy0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 17:54:26 -0400
Date: Sun, 8 Oct 2017 23:54:23 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v15 07/32] v4l: async: Add V4L2 async documentation to
 the documentation build
Message-ID: <20171008215423.qjevsmge7xfvvlzq@earth>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-8-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tyjfgzvcko235whv"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-8-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tyjfgzvcko235whv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 05, 2017 at 12:50:26AM +0300, Sakari Ailus wrote:
> The V4L2 async wasn't part of the documentation build. Fix this.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  Documentation/media/kapi/v4l2-async.rst | 3 +++
>  Documentation/media/kapi/v4l2-core.rst  | 1 +
>  2 files changed, 4 insertions(+)
>  create mode 100644 Documentation/media/kapi/v4l2-async.rst
>=20
> diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/medi=
a/kapi/v4l2-async.rst
> new file mode 100644
> index 000000000000..523ff9eb09a0
> --- /dev/null
> +++ b/Documentation/media/kapi/v4l2-async.rst
> @@ -0,0 +1,3 @@
> +V4L2 async kAPI
> +^^^^^^^^^^^^^^^
> +.. kernel-doc:: include/media/v4l2-async.h
> diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media=
/kapi/v4l2-core.rst
> index c7434f38fd9c..5cf292037a48 100644
> --- a/Documentation/media/kapi/v4l2-core.rst
> +++ b/Documentation/media/kapi/v4l2-core.rst
> @@ -19,6 +19,7 @@ Video4Linux devices
>      v4l2-mc
>      v4l2-mediabus
>      v4l2-mem2mem
> +    v4l2-async
>      v4l2-fwnode
>      v4l2-rect
>      v4l2-tuner
> --=20
> 2.11.0
>=20

--tyjfgzvcko235whv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnano4ACgkQ2O7X88g7
+pqBIRAAnm5oB4v6CELQiHqzyO2DT4akmJCjW9McWi0Glx+SbmQO5IgcJgfe7Uk3
j6EF4k2myCaGK7JxVpgqFEEPGyRgK0NCaQKE5zcuBrXhYRLdxDRegoTrHB9Ves97
Gwk/TDwmWj2PalDWSjOT0beWRmTfmm359YeL3FwE/6AgKv0SpX47eqU0bOc2dNY1
c2K+dylpcn3q+kC6n0AcbufDoG8xiHZfq9cdnO7rU+VEtmHaGnjw+xEZ735nhYKt
v9ixlZxeYynpNcTKSuHJEl3Qxdvonf5K1AuaIuDjCWzoXjj830LbQGen2oYypwEF
PqsSD1vE+r1MI+EflJxSXu4o2bE6+Y8TWNOG/k9UGSlM6+qTzXrpapFaeT5fFNFk
uU6R/reeBvWfIIWZxIkOiYGe4SCUCL17G0R4orxErqvHYEpEJhrqMIq6KSX2b7hs
dxoOuNNMNCXc1XLAjT8OvEYsbAsR2l0LMtJwJLE9pfxU/Eqk6iClusQfkHMh3VN1
ucWw69uUSlYKJ2kT0qnUBBXsmDKct26i5kRk1up5s1QcLV/YT92BCe1vSGqI2EUA
tMMa4F2JNqrYV7gXXcbkK+nEcqAHH684yBA1RsKQ8Tj3GC4Pbu+CNaE7+/IH3dbr
KZm0CnqPlsUapp4bVGtBMJnCUt3dpz1s3ozTLEm5THrwjkE1W6Q=
=D700
-----END PGP SIGNATURE-----

--tyjfgzvcko235whv--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37059 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754194AbdEDOdW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 10:33:22 -0400
Date: Thu, 4 May 2017 16:33:17 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC 2/3] dt: bindings: Add lens-focus binding for image sensors
Message-ID: <20170504143317.obpt2nmsjiypn4d2@earth>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493720749-31509-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q3657so5543stwzk"
Content-Disposition: inline
In-Reply-To: <1493720749-31509-3-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--q3657so5543stwzk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 02, 2017 at 01:25:48PM +0300, Sakari Ailus wrote:
> The lens-focus property contains a phandle to the lens voice coil driver
> that is associated to the sensor; typically both are contained in the same
> camera module.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index d6c62bc..e52aefc 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -77,6 +77,9 @@ Optional properties
>    the child nodes of the LED driver describing individual LEDs. Only
>    valid for device nodes that are related to an image sensor.
> =20
> +- lens-focus: A phandle to the node of the lens. Only valid for device
> +  nodes that are related to an image sensor.

s/of the lens/of the focus lens controller/

Also I wonder about the second sentence. That sentence could
basically be added to every property, so can't we just drop it?

-- Sebastian

--q3657so5543stwzk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkLO60ACgkQ2O7X88g7
+pqUHQ//Ub6M1lCSrRZPdLVTF4YfTgI7g5555+cqyfOZAB5lfNtQTxZNR0/rlLNo
mkF2QRjjiUaxObZ+MAyZkZ89S4hpMTvpUxj3tQytMna+630VV6IgOqMAp5rjGLwd
siQqEnxKqRq949Ct/AzqL88XF6xKcogu7Qs5t5SJXm7N317LxbG+qM+bhjG7PbBu
o/QOU8wXVr6VWL8f5jZqYe8Z5t5KVj0gu0liwravVtj5Ce4bsjfzo4dDtQFtAD6k
0ESIiMoytpKfXQGK17xtOo4AhHDfOTrOHFkClf/ECsh4zq7FxOoeKM5UdPV4tQDc
ZR0cMIOnTeJ3d+y3LFUwGO2kjlYhQqReetFeFGmPYRTfO+dWxeigNHA7wVl7t+DO
ElDjDE2JecZ14KQfxia9D5S7pbfRkpp01SCIYZc4zbwBkwpiI5cSxTEV7eqPdU0x
zfGfKsLPPkL0ZNuR36Qa/K4BrWFS7K8SW7fl81ucTJZT0rZeTYt5s3wabMBzhYSK
wH3ccXyRipZU1zLuZXBaToLXBalaam4ofP+rhZQq83gCcuJNxfA5TFsZ1d934Mgz
9Mykb2N3LRE3t11VadlEUMrcqkZuWmnxifVL24bcGXtad7XEXYHAtoC9+eE/Z1da
wJ9ziNp+ufGdoksBIAW30NpigzYMKVgdk0dnMjRDyLJAy+fWF6A=
=6iSX
-----END PGP SIGNATURE-----

--q3657so5543stwzk--

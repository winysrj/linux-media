Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:32671 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdBOLXS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 06:23:18 -0500
Subject: Re: [Patch 2/2] media: ti-vpe: vpe: allow use of user specified
 stride
To: Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-media@vger.kernel.org>
References: <20170213130658.31907-1-bparrot@ti.com>
 <20170213130658.31907-3-bparrot@ti.com>
CC: <linux-kernel@vger.kernel.org>, Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <4f5aa907-59fe-0230-7108-ef292978fcde@ti.com>
Date: Wed, 15 Feb 2017 13:22:42 +0200
MIME-Version: 1.0
In-Reply-To: <20170213130658.31907-3-bparrot@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="Q1aoBOOVBLgwlXoEx3TA4eRfvR7uDm8lM"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Q1aoBOOVBLgwlXoEx3TA4eRfvR7uDm8lM
Content-Type: multipart/mixed; boundary="JqVIUgjbmNxHeIc1L4Vrs4TnJ3QIi7CLi";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>,
 Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <4f5aa907-59fe-0230-7108-ef292978fcde@ti.com>
Subject: Re: [Patch 2/2] media: ti-vpe: vpe: allow use of user specified
 stride
References: <20170213130658.31907-1-bparrot@ti.com>
 <20170213130658.31907-3-bparrot@ti.com>
In-Reply-To: <20170213130658.31907-3-bparrot@ti.com>

--JqVIUgjbmNxHeIc1L4Vrs4TnJ3QIi7CLi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 13/02/17 15:06, Benoit Parrot wrote:
> Bytesperline/stride was always overwritten by VPE to the most
> adequate value based on needed alignment.
>=20
> However in order to make use of arbitrary size DMA buffer it
> is better to use the user space provide stride instead.
>=20
> The driver will still calculate an appropriate stride but will
> use the provided one when it is larger than the calculated one.
>=20
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platfo=
rm/ti-vpe/vpe.c
> index 2dd67232b3bc..c47151495b6f 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1597,6 +1597,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, str=
uct v4l2_format *f,
>  	struct v4l2_plane_pix_format *plane_fmt;
>  	unsigned int w_align;
>  	int i, depth, depth_bytes, height;
> +	unsigned int stride =3D 0;
> =20
>  	if (!fmt || !(fmt->types & type)) {
>  		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
> @@ -1683,16 +1684,27 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, s=
truct v4l2_format *f,
>  		plane_fmt =3D &pix->plane_fmt[i];
>  		depth =3D fmt->vpdma_fmt[i]->depth;
> =20
> -		if (i =3D=3D VPE_LUMA)
> -			plane_fmt->bytesperline =3D (pix->width * depth) >> 3;
> -		else
> -			plane_fmt->bytesperline =3D pix->width;
> +		stride =3D (pix->width * fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
> +		if (stride > plane_fmt->bytesperline)
> +			plane_fmt->bytesperline =3D stride;

The old code calculates different bytes per line for luma and chroma,
but the new one calculates only for luma. Is that correct?

 Tomi


--JqVIUgjbmNxHeIc1L4Vrs4TnJ3QIi7CLi--

--Q1aoBOOVBLgwlXoEx3TA4eRfvR7uDm8lM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYpDoCAAoJEPo9qoy8lh71VUsP/RC3taM5rehV1TXchBaloOC5
yaTqLjSu4W1z0N/wDaLsjAThX73CgcXr4cZlztVaBkE63QbYbZ0Q55YsXmxT7B5X
CoMgf3xe0IEYok6QgvC4utXydNmuiNwuV3bPYtJm6E0aYUPgPB2pgHRafi9nQ0T7
U0Hw7oXFAq3UdWJk0gFnlO7IjPEp/I+mvfaA/sn7h+fmoTKB2pNPc3MXhMf3ZhNe
8fINp6k29i8hTy6a9CjeSR5Wzm2HEjd1A21uGJlJexlX/nMAH8iptN3gthEoQ2pi
sTAQTioY4xdNg4DHwY0A/+da1ns9ExApqryE9xQJCGGNir2RLnjsReP531tcQk/+
//nHISm2ibGGp/3+VpAYmYoU+44y9YITwQ649n7m4CURJFfaX6R/dm0k35MUzABk
8crBWlIEKZ/jmv2RCghOMFreMTajZ1K171Yh3eVa0LCewbF2bF5C0J0CXRzeGOLL
1pbFJwePkqxxdeLQZTpM5oSO5g1HOEue+4ZLUDqDGg4Wqh1OtkhtPdfgFdu/E3Ed
0z2P76h3xjXC8U5kER91Wq2c0XBZCCA+SH/j1MbniujmBCyRfpoA6jMA/wxkW0gj
NKoSIMD3+EvUriMRV6zHmhKUXcALPBcOakNRMOxysqr6N01P13GCE1LPcwbD7hhB
9mT8gq+y1I1v6/mrPnCd
=L3P5
-----END PGP SIGNATURE-----

--Q1aoBOOVBLgwlXoEx3TA4eRfvR7uDm8lM--

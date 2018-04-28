Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53166 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757745AbeD1R3I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 13:29:08 -0400
Subject: Re: [PATCH v2 4/8] v4l: vsp1: Document the vsp1_du_atomic_config
 structure
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-5-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <0dee02dd-67f5-511e-84fb-a75ee086db10@ideasonboard.com>
Date: Sat, 28 Apr 2018 18:29:03 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-5-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="67T80XvAp0McWRoWgZicjDsJ29duMnib8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--67T80XvAp0McWRoWgZicjDsJ29duMnib8
Content-Type: multipart/mixed; boundary="ucPTudhEREhtN0lzwa3GTHEAl7f66vMXA";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Message-ID: <0dee02dd-67f5-511e-84fb-a75ee086db10@ideasonboard.com>
Subject: Re: [PATCH v2 4/8] v4l: vsp1: Document the vsp1_du_atomic_config
 structure
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-5-laurent.pinchart+renesas@ideasonboard.com>

--ucPTudhEREhtN0lzwa3GTHEAl7f66vMXA
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 22/04/18 23:34, Laurent Pinchart wrote:
> The structure is used in the API that the VSP1 driver exposes to the DU=

> driver. Documenting it is thus important.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

I look forward to being reminded to add a doc-line to this structure for =
my
interlaced support branch which added 'bool interlaced' to this structure=
 before
it was documented, (thus doesn't add a doc string). Maybe me writing this=

comment will remind me in the future when I rebase the interlaced patches=
 ;-)


Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
> Changes since v1:
>=20
> - Fixed typo
> ---
>  include/media/vsp1.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 68a8abe4fac5..ff7ef894465d 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -41,6 +41,16 @@ struct vsp1_du_lif_config {
>  int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		      const struct vsp1_du_lif_config *cfg);
> =20
> +/**
> + * struct vsp1_du_atomic_config - VSP atomic configuration parameters
> + * @pixelformat: plane pixel format (V4L2 4CC)
> + * @pitch: line pitch in bytes, for all planes
> + * @mem: DMA memory address for each plane of the frame buffer
> + * @src: source rectangle in the frame buffer (integer coordinates)
> + * @dst: destination rectangle on the display (integer coordinates)
> + * @alpha: alpha value (0: fully transparent, 255: fully opaque)
> + * @zpos: Z position of the plane (from 0 to number of planes minus 1)=

> + */
>  struct vsp1_du_atomic_config {
>  	u32 pixelformat;
>  	unsigned int pitch;
>=20


--ucPTudhEREhtN0lzwa3GTHEAl7f66vMXA--

--67T80XvAp0McWRoWgZicjDsJ29duMnib8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrkr2AACgkQoR5GchCk
Yf2Pqw//RE8JnGvftCpI4hyyCfRU8lO8O8aDySQQGVMvLTB1nNIopHOpTjC564Ti
w2nCjAHckTiU5YD2V7U/AnkY9o2If7C+MPVjV43qYCmbLoGy+WwNfv/kKUXH3YAC
jngvPqURTsHnzHhAZUDBNO1eHmZIFdbY2jc+CBOhydbMvESBbD+9sMaKOlvIKhUS
EsLVgZKf9hWHke9SfD429AVirp3NdwhiwxOEt44QLG5vkCFr39DhQYzjmftmloe1
AUfLoureESJjypwMewHFbcus6ClkirbUVUZhfOnyw+Kyx85aSGOPyCzKVvbI3NN4
xu8fuFU2b9urjTD6dewCpQAIltW9s1sZkFIVa/DEx1KQw15DVfqRir2VsdtcHZJk
ZubBXC9DU2Jys/UbHoHCTjJk2TCzQ35u8eumMuVM8KUfMnpFlxBcYwV5OLGyv8hC
lW+D6wUZvWyIcOVn3Rm2G0VIhNM59zsb2WxRN9Wjs/GWGgGwcugXs17nlyy5LtA8
5KIn3ATUdy+xrNnKWGOZQ7M3sFQTAeJ+lES4S7ZWgBK61jJGoqfZFRG6bfXuYFnT
hh/CJfNe5GSF88yu6fcVedDUCTol1sEsNWiF/MoyiK9M2FjUMEOWBSxpuMwwWXV7
UC7gdDU9gAmsjD5m6vWIzFO/QjLPKX5mti5wRvRO9qqikZec7pY=
=uGx8
-----END PGP SIGNATURE-----

--67T80XvAp0McWRoWgZicjDsJ29duMnib8--

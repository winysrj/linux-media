Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41708 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754894AbeDTOPk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 10:15:40 -0400
Date: Fri, 20 Apr 2018 16:15:28 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
Subject: Re: [PATCH 2/3] media: ov5640: add PIXEL_RATE and LINK_FREQ controls
Message-ID: <20180420141528.ethp34p6czomokpi@flea>
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-2-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v5kz7xrear4zf7bm"
Content-Disposition: inline
In-Reply-To: <20180420094419.11267-2-daniel@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v5kz7xrear4zf7bm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 20, 2018 at 11:44:18AM +0200, Daniel Mack wrote:
> Add v4l2 controls to report the pixel and MIPI link rates of each mode.
> The camss camera subsystem needs them to set up the correct hardware
> clocks.
>=20
> Tested on msm8016 based hardware.
>=20
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/media/i2c/ov5640.c | 77 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 77 insertions(+)
>=20
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 96f1564abdf5..78669ed386cd 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -91,6 +91,20 @@
>  #define OV5640_REG_SDE_CTRL5		0x5585
>  #define OV5640_REG_AVG_READOUT		0x56a1
> =20
> +#define OV5640_LINK_FREQ_111	0
> +#define OV5640_LINK_FREQ_166	1
> +#define OV5640_LINK_FREQ_222	2
> +#define OV5640_LINK_FREQ_333	3
> +#define OV5640_LINK_FREQ_666	4
> +
> +static const s64 link_freq_menu_items[] =3D {
> +	111066666,
> +	166600000,
> +	222133333,
> +	332200000,
> +	666400000,
> +};
> +
>  enum ov5640_mode_id {
>  	OV5640_MODE_QCIF_176_144 =3D 0,
>  	OV5640_MODE_QVGA_320_240,
> @@ -167,12 +181,18 @@ struct ov5640_mode_info {
>  	enum ov5640_downsize_mode dn_mode;
>  	u32 width;
>  	u32 height;
> +	u32 pixel_rate;
> +	u32 link_freq_idx;
>  	const struct reg_value *reg_data;
>  	u32 reg_data_size;
>  };
> =20
>  struct ov5640_ctrls {
>  	struct v4l2_ctrl_handler handler;
> +	struct {
> +		struct v4l2_ctrl *link_freq;
> +		struct v4l2_ctrl *pixel_rate;
> +	};
>  	struct {
>  		struct v4l2_ctrl *auto_exp;
>  		struct v4l2_ctrl *exposure;
> @@ -732,6 +752,8 @@ static const struct ov5640_mode_info ov5640_mode_init=
_data =3D {
>  	.dn_mode	=3D SUBSAMPLING,
>  	.width		=3D 640,
>  	.height		=3D 480,
> +	.pixel_rate	=3D 27766666,
> +	.link_freq_idx	=3D OV5640_LINK_FREQ_111,

I'm not sure where this is coming from, but on a parallel sensor I
have a quite different pixel rate.

I have a serie ongoing that tries to deal with this, hopefully in
order to get rid of all the clock setup done in the initialiasation
array.

See https://patchwork.linuxtv.org/patch/48710/ for the patch and
https://www.spinics.net/lists/linux-media/msg132201.html for a
discussion on what the clock tree might look like on a MIPI-CSI bus.

Feel free to step in the discussion.
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--v5kz7xrear4zf7bm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrZ9f8ACgkQ0rTAlCFN
r3SYJxAAkrszD0xxrMcUwcjPT5OfSl+2Y0yxjXMdQgciLKILaBjLHTwujteVMgi/
5qg0/ZESxnHTF/ffDCQ9/YvYiffK4x6sah4HUAHNaraByar7wOgQhn/AwZmKRZ7e
1DgajYGwnoeqPvWGf9TNiP0+r12sNL0RUWLQ84qnNV6W1rJeJ10pN87qEZRaKuS5
q+LvP4GvfnqvyBQFuwT9L0N2jqIkmrf/FGrhxnsi9YxaGGu1E9mehu+wyT9XDvK/
tdM6Plf7u/2K3Pz54ibzwQkHQZKAx4FcWRw5I+S0k37qDJpV7JwCR/YXCfyiCFKl
buZAMuKoCcDutKWLTfDKVa+V0K639v23hm16B5mpSe5ByqHKgZljjq3xFHSsdVzw
OSOtdaTp7TOADAtH9P1GrdQxoA3YdPyK8XLV4P/M8jGDEWKhJQLUgwATz17sjT68
RflG9wmBu0JJ5Llx6fZUAw7IppvkNAM029UCaom/MF3qcJHXkWzsxfDPNppBXt/3
CAVQ1jcWyExMp4kDBaMJhM3XJoCTQRC0GxdavmQNozeRuJEaHUNdMi90n51LYy3Q
qJfygUgg52ImIlUNRK1tfmontg7XCNahkayQSbScyJc6L0eiOgirgOi1Z/Y8Xe6h
5mgWhp+IOQwmkv4WL+X/JR1wuno56Dzr/04Fsxrl2FTr/+Mlsxg=
=Keaz
-----END PGP SIGNATURE-----

--v5kz7xrear4zf7bm--

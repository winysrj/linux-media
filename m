Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42130 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934918AbeBMMSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 07:18:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v3 4/5] media: adv7604: Add support for i2c_new_secondary_device
Date: Tue, 13 Feb 2018 14:19:06 +0200
Message-ID: <12162268.j7DyVD3ArW@avalon>
In-Reply-To: <1518473273-6333-5-git-send-email-kbingham@kernel.org>
References: <1518473273-6333-1-git-send-email-kbingham@kernel.org> <1518473273-6333-5-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 13 February 2018 00:07:52 EET Kieran Bingham wrote:
> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>=20
> The ADV7604 has thirteen 256-byte maps that can be accessed via the main
> I=B2C ports. Each map has it own I=B2C address and acts as a standard sla=
ve
> device on the I=B2C bus.
>=20
> Allow a device tree node to override the default addresses so that
> address conflicts with other devices on the same bus may be resolved at
> the board description level.
>=20
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> [Kieran: Re-adapted for mainline]
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>=20
> ---
> Based upon the original posting :
>   https://lkml.org/lkml/2014/10/22/469
>=20
> v2:
>  - Split out DT bindings from driver updates
>  - Return -EINVAL on error paths from adv76xx_dummy_client()
>=20
>  drivers/media/i2c/adv7604.c | 62 ++++++++++++++++++++++++++-------------=
=2D--
>  1 file changed, 40 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 1544920ec52d..872e124793f8 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2734,6 +2734,27 @@ static const struct v4l2_ctrl_config
> adv76xx_ctrl_free_run_color =3D {
>=20
>  /* ---------------------------------------------------------------------=
 */
>=20
> +struct adv76xx_register {

adv76xx_register seems to imply that this describes a particular register,=
=20
while the structure describes a registers map. How about adv76xx_register_m=
ap,=20
adv76xx_register_bank or adv76xx_register_page ?

> +	const char *name;
> +	u8 default_addr;
> +};
> +
> +static const struct adv76xx_register adv76xx_secondary_names[] =3D {

The table doesn't contain secondary names only as there's an entry for the=
=20
main map. How about calling it adv76xx_default_addresses or something along=
=20
the same line ?

> +	[ADV76XX_PAGE_IO] =3D { "main", 0x4c },
> +	[ADV7604_PAGE_AVLINK] =3D { "avlink", 0x42 },
> +	[ADV76XX_PAGE_CEC] =3D { "cec", 0x40 },
> +	[ADV76XX_PAGE_INFOFRAME] =3D { "infoframe", 0x3e },
> +	[ADV7604_PAGE_ESDP] =3D { "esdp", 0x38 },
> +	[ADV7604_PAGE_DPP] =3D { "dpp", 0x3c },
> +	[ADV76XX_PAGE_AFE] =3D { "afe", 0x26 },
> +	[ADV76XX_PAGE_REP] =3D { "rep", 0x32 },
> +	[ADV76XX_PAGE_EDID] =3D { "edid", 0x36 },
> +	[ADV76XX_PAGE_HDMI] =3D { "hdmi", 0x34 },
> +	[ADV76XX_PAGE_TEST] =3D { "test", 0x30 },
> +	[ADV76XX_PAGE_CP] =3D { "cp", 0x22 },
> +	[ADV7604_PAGE_VDP] =3D { "vdp", 0x24 },
> +};
> +
>  static int adv76xx_core_init(struct v4l2_subdev *sd)
>  {
>  	struct adv76xx_state *state =3D to_state(sd);
> @@ -2834,13 +2855,26 @@ static void adv76xx_unregister_clients(struct
> adv76xx_state *state) }
>=20
>  static struct i2c_client *adv76xx_dummy_client(struct v4l2_subdev *sd,
> -							u8 addr, u8 io_reg)
> +					       unsigned int i)

Maybe unsigned int page ?

With these fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  {
>  	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> +	struct adv76xx_state *state =3D to_state(sd);
> +	struct adv76xx_platform_data *pdata =3D &state->pdata;
> +	unsigned int io_reg =3D 0xf2 + i;
> +	struct i2c_client *new_client;
> +
> +	if (pdata && pdata->i2c_addresses[i])
> +		new_client =3D i2c_new_dummy(client->adapter,
> +					   pdata->i2c_addresses[i]);
> +	else
> +		new_client =3D i2c_new_secondary_device(client,
> +				adv76xx_secondary_names[i].name,
> +				adv76xx_secondary_names[i].default_addr);
>=20
> -	if (addr)
> -		io_write(sd, io_reg, addr << 1);
> -	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
> +	if (new_client)
> +		io_write(sd, io_reg, new_client->addr << 1);
> +
> +	return new_client;
>  }
>=20
>  static const struct adv76xx_reg_seq adv7604_recommended_settings_afe[] =
=3D {
> @@ -3115,20 +3149,6 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state) /* Disable the interrupt for now as no DT-based board uses it. */
> state->pdata.int1_config =3D ADV76XX_INT1_CONFIG_DISABLED;
>=20
> -	/* Use the default I2C addresses. */
> -	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] =3D 0x42;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_CEC] =3D 0x40;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_INFOFRAME] =3D 0x3e;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] =3D 0x38;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] =3D 0x3c;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_AFE] =3D 0x26;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_REP] =3D 0x32;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_EDID] =3D 0x36;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_HDMI] =3D 0x34;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_TEST] =3D 0x30;
> -	state->pdata.i2c_addresses[ADV76XX_PAGE_CP] =3D 0x22;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] =3D 0x24;
> -
>  	/* Hardcode the remaining platform data fields. */
>  	state->pdata.disable_pwrdnb =3D 0;
>  	state->pdata.disable_cable_det_rst =3D 0;
> @@ -3478,11 +3498,9 @@ static int adv76xx_probe(struct i2c_client *client,
>  		if (!(BIT(i) & state->info->page_mask))
>  			continue;
>=20
> -		state->i2c_clients[i] =3D
> -			adv76xx_dummy_client(sd, state->pdata.i2c_addresses[i],
> -					     0xf2 + i);
> +		state->i2c_clients[i] =3D adv76xx_dummy_client(sd, i);
>  		if (!state->i2c_clients[i]) {
> -			err =3D -ENOMEM;
> +			err =3D -EINVAL;
>  			v4l2_err(sd, "failed to create i2c client %u\n", i);
>  			goto err_i2c;
>  		}

=2D-=20
Regards,

Laurent Pinchart

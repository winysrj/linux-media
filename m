Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58090 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeKEULF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 15:11:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/4] i2c: adv748x: reuse power up sequence when initializing CSI-2
Date: Mon, 05 Nov 2018 12:52:07 +0200
Message-ID: <3507408.Ue7CVe2Eut@avalon>
In-Reply-To: <20181102160009.17267-3-niklas.soderlund+renesas@ragnatech.se>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se> <20181102160009.17267-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 November 2018 18:00:07 EET Niklas S=F6derlund wrote:
> Extend the MIPI CSI-2 power up sequence to match the power up sequence
> in the hardware manual chapter "9.5.1 Power Up Sequence". This change
> allows the power up functions to be reused when initializing the
> hardware reducing code duplicating as well aligning with the
> documentation.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>=20
> ---
> * Changes since v2
> - Bring in the undocumented registers in the power on sequence from the
>   initialization sequence after confirming in the hardware manual that
>   this is the correct behavior.
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 50 ++++++------------------
>  1 file changed, 13 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index
> 6854d898fdd1f192..2384f50dacb0ccff 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -234,6 +234,12 @@ static const struct adv748x_reg_value
> adv748x_power_up_txa_4lane[] =3D {
>=20
>  	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
>  	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> +	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
>=20
>  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> @@ -263,6 +269,11 @@ static const struct adv748x_reg_value
> adv748x_power_up_txb_1lane[] =3D {
>=20
>  	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
>  	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> +	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
>=20
>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> @@ -383,25 +394,6 @@ static const struct adv748x_reg_value
> adv748x_init_txa_4lane[] =3D { {ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enable
> LLC_DLL & Double LLC Timing */ {ADV748X_PAGE_IO, 0x0e, 0xdd},	/*
> LLC/PIX/SPI PINS TRISTATED AUD */
>=20
> -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> -	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> -
> -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> -
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>=20
> @@ -435,24 +427,6 @@ static const struct adv748x_reg_value
> adv748x_init_txb_1lane[] =3D { {ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI
> Required Write */
>  	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC */
>=20
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> -	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -
> -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> -	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> -
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>=20
> @@ -474,6 +448,7 @@ static int adv748x_reset(struct adv748x_state *state)
>  	if (ret)
>  		return ret;
>=20
> +	adv748x_tx_power(&state->txa, 1);
>  	adv748x_tx_power(&state->txa, 0);
>=20
>  	/* Init and power down TXB */
> @@ -481,6 +456,7 @@ static int adv748x_reset(struct adv748x_state *state)
>  	if (ret)
>  		return ret;
>=20
> +	adv748x_tx_power(&state->txb, 1);
>  	adv748x_tx_power(&state->txb, 0);
>=20
>  	/* Disable chip powerdown & Enable HDMI Rx block */


=2D-=20
Regards,

Laurent Pinchart

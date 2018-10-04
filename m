Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52900 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725758AbeJEFDw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 01:03:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v2 5/5] i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter
Date: Fri, 05 Oct 2018 01:08:42 +0300
Message-ID: <2119221.Db59uWWuRb@avalon>
In-Reply-To: <20181004204138.2784-6-niklas.soderlund@ragnatech.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <20181004204138.2784-6-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:41:38 EEST Niklas S=F6derlund wrote:
> From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it could
> operate using 1-, 2- and 4-lanes. Update the driver to support all modes
> the hardware does.
>=20
> The driver make use of large tables of static register/value writes when
> powering up/down the TXA and TXB transmitters which include the write to
> the NUM_LANES register. By converting the tables into functions and
> using parameters the power up/down functions for TXA and TXB power
> up/down can be merged and used for both transmitters.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> ---
> * Changes since v1
> - Convert tables of register/value writes into functions instead of
>   intercepting and modifying the writes to the NUM_LANES register.
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 132 ++++++++++++-----------
>  1 file changed, 67 insertions(+), 65 deletions(-)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index
> 3836dd3025d6ffb7..fe29781368a3a6b6 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -125,6 +125,16 @@ int adv748x_write(struct adv748x_state *state, u8 pa=
ge,
> u8 reg, u8 value) return regmap_write(state->regmap[page], reg, value);
>  }
>=20
> +static int adv748x_write_check(struct adv748x_state *state, u8 page, u8
> reg,
> +			       u8 value, int *error)
> +{
> +	if (*error)
> +		return *error;

We could also store the error as a write_error field in the state structure=
 to=20
avoid passing it around as a parameter all the time. I'll let you and Kiera=
n=20
decide.

> +
> +	*error =3D adv748x_write(state, page, reg, value);
> +	return *error;
> +}
> +
>  /* adv748x_write_block(): Write raw data with a maximum of
> I2C_SMBUS_BLOCK_MAX * size to one or more registers.
>   *
> @@ -231,69 +241,63 @@ static int adv748x_write_regs(struct adv748x_state
> *state, * TXA and TXB
>   */
>=20
> -static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] =3D {
> -
> -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
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
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
> -static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] =3D=
 {
> -
> -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
> -static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] =3D {
> -
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> -
> -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> -	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
> -static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] =3D=
 {
> -
> -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> +static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
> +{
> +	struct adv748x_state *state =3D tx->state;
> +	u8 page =3D is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> +	int ret =3D 0;
> +
> +	/* Enable 4-lane MIPI */

Not necessarily 4 lanes anymore.

> +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> +
> +	/* Set Auto DPHY Timing */
> +	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> +
> +	/* ADI Required Writes*/

s/\*\// *\//

> +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> +	adv748x_write_check(state, page, 0x1e, 0x40, &ret);
> +
> +	/* i2c_mipi_pll_en - 1'b1 */
> +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> +	usleep_range(2000, 2500);
> +
> +	/* Power-up CSI-TX */
> +	adv748x_write_check(state, page, 0x00, 0x20 | tx->num_lanes, &ret);
> +	usleep_range(1000, 1500);
> +
> +	/* ADI Required Writes*/
> +	adv748x_write_check(state, page, 0xc1, 0x2b, &ret);
> +	usleep_range(1000, 1500);
> +	adv748x_write_check(state, page, 0x31, 0x80, &ret);
> +
> +	return ret;
> +}
> +
> +static int adv748x_power_down_tx(struct adv748x_csi2 *tx)
> +{
> +	struct adv748x_state *state =3D tx->state;
> +	u8 page =3D is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> +	int ret =3D 0;
> +
> +	/* ADI Required Writes */
> +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> +	adv748x_write_check(state, page, 0x1e, 0x00, &ret);
> +
> +	/* Enable 4-lane MIPI */

Same here.

> +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> +
> +	/* i2c_mipi_pll_en - 1'b1 */
> +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> +
> +	/* ADI Required Write */
> +	adv748x_write_check(state, page, 0xc1, 0x3b, &ret);
> +
> +	return ret;
> +}
>=20
>  int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
>  {
> -	struct adv748x_state *state =3D tx->state;
> -	const struct adv748x_reg_value *reglist;
> -	int val;
> +	int val, ret;
>=20
>  	if (!is_tx_enabled(tx))
>  		return 0;
> @@ -311,13 +315,11 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool =
on)
> "Enabling with unknown bit set");
>=20
>  	if (on)
> -		reglist =3D is_txa(tx) ? adv748x_power_up_txa_4lane :
> -				       adv748x_power_up_txb_1lane;
> +		ret =3D adv748x_power_up_tx(tx);
>  	else
> -		reglist =3D is_txa(tx) ? adv748x_power_down_txa_4lane :
> -				       adv748x_power_down_txb_1lane;
> +		ret =3D adv748x_power_down_tx(tx);

You could also return directly here and avoid adding a ret variable.

>=20
> -	return adv748x_write_regs(state, reglist);
> +	return ret;
>  }
>=20
>  /* ---------------------------------------------------------------------=
=2D--

Very nice change overall. With the above small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

=2D-=20
Regards,

Laurent Pinchart

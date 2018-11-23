Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43168 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731421AbeKXB1c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 20:27:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 4/4] i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter
Date: Fri, 23 Nov 2018 16:43:18 +0200
Message-ID: <2306235.pDioDJoL9o@avalon>
In-Reply-To: <20181123140154.GF8279@w540>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se> <20181102160009.17267-5-niklas.soderlund+renesas@ragnatech.se> <20181123140154.GF8279@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Friday, 23 November 2018 16:01:54 EET jacopo mondi wrote:
> On Fri, Nov 02, 2018 at 05:00:09PM +0100, Niklas S=F6derlund wrote:
> > The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it could
> > operate using 1-, 2- and 4-lanes. Update the driver to support all modes
> > the hardware does.
> >=20
> > The driver make use of large tables of static register/value writes when
> > powering up/down the TXA and TXB transmitters which include the write to
> > the NUM_LANES register. By converting the tables into functions and
> > using parameters the power up/down functions for TXA and TXB power
> > up/down can be merged and used for both transmitters.
> >=20
> > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.s=
e>
> >=20
> > ---
> > * Changes since v2
> > - Fix typos in comments.
> > - Remove unneeded boiler plait code in adv748x_tx_power() as suggested
> >=20
> >   by Jacopo and Laurent.
> >=20
> > - Take into account the two different register used when powering up TXA
> >=20
> >   and TXB due to an earlier patch in this series aligns the power
> >   sequence with the manual.
> >=20
> > * Changes since v1
> > - Convert tables of register/value writes into functions instead of
> >=20
> >   intercepting and modifying the writes to the NUM_LANES register.
> >=20
> > ---
> >=20
> >  drivers/media/i2c/adv748x/adv748x-core.c | 157 ++++++++++++-----------
> >  1 file changed, 79 insertions(+), 78 deletions(-)
> >=20
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > b/drivers/media/i2c/adv748x/adv748x-core.c index
> > 9d80d7f3062b16bc..d94c63cb6a2efdba 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -125,6 +125,16 @@ int adv748x_write(struct adv748x_state *state, u8
> > page, u8 reg, u8 value)
> >  	return regmap_write(state->regmap[page], reg, value);
> >  }
> >=20
> > +static int adv748x_write_check(struct adv748x_state *state, u8 page, u8
> > reg,
> > +			       u8 value, int *error)
> > +{
> > +	if (*error)
> > +		return *error;
> > +
> > +	*error =3D adv748x_write(state, page, reg, value);
> > +	return *error;
> > +}
> > +
> >  /* adv748x_write_block(): Write raw data with a maximum of
> >  I2C_SMBUS_BLOCK_MAX> =20
> >   * size to one or more registers.
> >   *
> > @@ -231,79 +241,77 @@ static int adv748x_write_regs(struct adv748x_state
> > *state,
> >   * TXA and TXB
> >   */
> >=20
> > -static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] =3D=
 {
> > -
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > -	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> > -
> > -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > -
> > -static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] =
=3D {
> > -
> > -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > -
> > -static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] =3D=
 {
> > -
> > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> > -	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> > -
> > -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > -	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > -	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > -
> > -static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] =
=3D {
> > -
> > -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > -	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> > -
> > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > -};
> > +static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
> > +{
> > +	struct adv748x_state *state =3D tx->state;
> > +	u8 page =3D is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > +	int ret =3D 0;
> > +
> > +	/* Enable n-lane MIPI */
> > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > +
> > +	/* Set Auto DPHY Timing */
> > +	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> > +
> > +	/* ADI Required Write */
> > +	if (is_txa(tx)) {
> > +		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
> > +		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
> > +	} else {
> > +		adv748x_write_check(state, page, 0xd2, 0x40, &ret);
> > +	}
> > +
> > +	adv748x_write_check(state, page, 0xc4, 0x0a, &ret);
> > +	adv748x_write_check(state, page, 0x71, 0x33, &ret);
> > +	adv748x_write_check(state, page, 0x72, 0x11, &ret);
> > +
> > +	/* i2c_dphy_pwdn - 1'b0 */
> > +	adv748x_write_check(state, page, 0xf0, 0x00, &ret);
> > +
> > +	/* ADI Required Writes*/
> > +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> > +	adv748x_write_check(state, page, 0x1e, 0x40, &ret);
> > +
> > +	/* i2c_mipi_pll_en - 1'b1 */
> > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> > +	usleep_range(2000, 2500);
> > +
> > +	/* Power-up CSI-TX */
> > +	adv748x_write_check(state, page, 0x00, 0x20 | tx->num_lanes, &ret);
>=20
> Where does the 0x20 come from? I don't see it in the register
> description in the HW manual..

Isn't it the EN_AUTOCALC_DPHY_PARAMS bit ?

> > +	usleep_range(1000, 1500);
> > +
> > +	/* ADI Required Writes */
> > +	adv748x_write_check(state, page, 0xc1, 0x2b, &ret);
> > +	usleep_range(1000, 1500);
> > +	adv748x_write_check(state, page, 0x31, 0x80, &ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int adv748x_power_down_tx(struct adv748x_csi2 *tx)
> > +{
> > +	struct adv748x_state *state =3D tx->state;
> > +	u8 page =3D is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > +	int ret =3D 0;
> > +
> > +	/* ADI Required Writes */
> > +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> > +	adv748x_write_check(state, page, 0x1e, 0x00, &ret);
> > +
> > +	/* Enable n-lane MIPI */
>=20
> The comment is wrong here: this write disables the CSI TX interface.
>=20
> > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > +
> > +	/* i2c_mipi_pll_en - 1'b1 */
> > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
>=20
> Re-looking at power up/down sequences, this should actually be 0xda =3D 0=
x00,
> as specified in seciont 9.5.2 of the HW manual.
>=20
> I know all of these come from tables in the previous version and has not
> been introduced by this patch, but while at there it might be worth
> fixing them.
>=20
> And actually, I don't like much the comments for registers pll_en and
> dphy_pdn registers, and they might be improved, since you're rewriting
> this sequence anyhow.
>=20
> I had a patch pending, before I realized you could change this in your
> next v4. In case you want to have a look:
> https://paste.debian.net/1052965/

I would prefer fixes to be made on top of this patch, to separate the=20
refactoring from the functional changes as much as possible.

> > +
> > +	/* ADI Required Write */
> > +	adv748x_write_check(state, page, 0xc1, 0x3b, &ret);
> > +
> > +	return ret;
> > +}
> >=20
> >  int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> >  {
> > -	struct adv748x_state *state =3D tx->state;
> > -	const struct adv748x_reg_value *reglist;
> >  	int val;
> >  =09
> >  	if (!is_tx_enabled(tx))
> > @@ -321,14 +329,7 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool
> > on)
> >  	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
> >  			"Enabling with unknown bit set");
> >=20
> > -	if (on)
> > -		reglist =3D is_txa(tx) ? adv748x_power_up_txa_4lane :
> > -				       adv748x_power_up_txb_1lane;
> > -	else
> > -		reglist =3D is_txa(tx) ? adv748x_power_down_txa_4lane :
> > -				       adv748x_power_down_txb_1lane;
> > -
> > -	return adv748x_write_regs(state, reglist);
> > +	return on ? adv748x_power_up_tx(tx) : adv748x_power_down_tx(tx);
> >  }
> > =20
> >  /* -------------------------------------------------------------------=
=2D--

=2D-=20
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59089 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbeKBULY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 16:11:24 -0400
Date: Fri, 2 Nov 2018 12:04:33 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 5/5] i2c: adv748x: configure number of lanes used for
 TXA CSI-2 transmitter
Message-ID: <20181102110433.GT15991@w540>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
 <20181004204138.2784-6-niklas.soderlund@ragnatech.se>
 <20181005104615.GP31281@w540>
 <20181102104425.GI22306@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lKbk9CFItQTD29wm"
Content-Disposition: inline
In-Reply-To: <20181102104425.GI22306@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, Nov 02, 2018 at 11:44:25AM +0100, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your feedback.
>
> On 2018-10-05 12:46:15 +0200, Jacopo Mondi wrote:
> > Hi Niklas,
> >
> > On Thu, Oct 04, 2018 at 10:41:38PM +0200, Niklas S=C3=B6derlund wrote:
> > > From: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> > >
> > > The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it co=
uld
> > > operate using 1-, 2- and 4-lanes. Update the driver to support all mo=
des
> > > the hardware does.
> > >
> > > The driver make use of large tables of static register/value writes w=
hen
> > > powering up/down the TXA and TXB transmitters which include the write=
 to
> > > the NUM_LANES register. By converting the tables into functions and
> > > using parameters the power up/down functions for TXA and TXB power
> > > up/down can be merged and used for both transmitters.
> > >
> > > Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> > >
> > > ---
> > > * Changes since v1
> > > - Convert tables of register/value writes into functions instead of
> > >   intercepting and modifying the writes to the NUM_LANES register.
> > > ---
> > >  drivers/media/i2c/adv748x/adv748x-core.c | 132 ++++++++++++---------=
--
> > >  1 file changed, 67 insertions(+), 65 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media=
/i2c/adv748x/adv748x-core.c
> > > index 3836dd3025d6ffb7..fe29781368a3a6b6 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > > @@ -125,6 +125,16 @@ int adv748x_write(struct adv748x_state *state, u=
8 page, u8 reg, u8 value)
> > >  	return regmap_write(state->regmap[page], reg, value);
> > >  }
> > >
> > > +static int adv748x_write_check(struct adv748x_state *state, u8 page,=
 u8 reg,
> > > +			       u8 value, int *error)
> >
> > Am I wrong or the return error is ignored and could be dropped?
>
> No it's used to reduce boiler plate code, see adv748x_power_up_tx()
> bellow for one example.

I meant the function return value. It is never checked:

        adv748x_write_check(state, page, 0x31, 0x82, &ret);

>
>     int ret =3D 0;
>     ...
>     adv748x_write_check(state, page, 0x31, 0x82, &ret);
>     adv748x_write_check(state, page, 0x1e, 0x40, &ret);
>     ...
>     return ret;
>
> If the first adv748x_write_check() fails all later calls to
> adv748x_write_check() will do nothing. This is do avoid the rather hard
> to read:
>
>     ret =3D adv748x_write(state, page, 0x31, 0x82);
>     if (ret)
>         return ret;
>
>     ret =3D adv748x_write(state, page, 0x1e, 0x40);
>     if (ret)
>         return ret;
>
> >
> > > +{
> > > +	if (*error)
> > > +		return *error;
> > > +
> > > +	*error =3D adv748x_write(state, page, reg, value);
> > > +	return *error;
> > > +}
> > > +
> > >  /* adv748x_write_block(): Write raw data with a maximum of I2C_SMBUS=
_BLOCK_MAX
> > >   * size to one or more registers.
> > >   *
> > > @@ -231,69 +241,63 @@ static int adv748x_write_regs(struct adv748x_st=
ate *state,
> > >   * TXA and TXB
> > >   */
> > >
> > > -static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] =
=3D {
> > > -
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > > -
> > > -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > > -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > > -	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > > -	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> > > -
> > > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > > -};
> > > -
> > > -static const struct adv748x_reg_value adv748x_power_down_txa_4lane[]=
 =3D {
> > > -
> > > -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > > -	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> > > -
> > > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > > -};
> > > -
> > > -static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] =
=3D {
> > > -
> > > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > > -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> > > -
> > > -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > > -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > > -	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> > > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > > -	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > > -	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> > > -
> > > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > > -};
> > > -
> > > -static const struct adv748x_reg_value adv748x_power_down_txb_1lane[]=
 =3D {
> > > -
> > > -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > > -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > > -	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> > > -
> > > -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> > > -};
> > > +static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
> > > +{
> > > +	struct adv748x_state *state =3D tx->state;
> > > +	u8 page =3D is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > > +	int ret =3D 0;
> > > +
> > > +	/* Enable 4-lane MIPI */
> > > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > > +
> > > +	/* Set Auto DPHY Timing */
> > > +	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> > > +
> > > +	/* ADI Required Writes*/
> > > +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> > > +	adv748x_write_check(state, page, 0x1e, 0x40, &ret);
> > > +
> > > +	/* i2c_mipi_pll_en - 1'b1 */
> > > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> > > +	usleep_range(2000, 2500);
> > > +
> > > +	/* Power-up CSI-TX */
> > > +	adv748x_write_check(state, page, 0x00, 0x20 | tx->num_lanes, &ret);
> > > +	usleep_range(1000, 1500);
> > > +
> > > +	/* ADI Required Writes*/
> > > +	adv748x_write_check(state, page, 0xc1, 0x2b, &ret);
> > > +	usleep_range(1000, 1500);
> > > +	adv748x_write_check(state, page, 0x31, 0x80, &ret);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int adv748x_power_down_tx(struct adv748x_csi2 *tx)
> > > +{
> > > +	struct adv748x_state *state =3D tx->state;
> > > +	u8 page =3D is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> > > +	int ret =3D 0;
> > > +
> > > +	/* ADI Required Writes */
> > > +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> > > +	adv748x_write_check(state, page, 0x1e, 0x00, &ret);
> > > +
> > > +	/* Enable 4-lane MIPI */
> > > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > > +
> > > +	/* i2c_mipi_pll_en - 1'b1 */
> > > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> > > +
> > > +	/* ADI Required Write */
> > > +	adv748x_write_check(state, page, 0xc1, 0x3b, &ret);
> > > +
> > > +	return ret;
> > > +}
> >
> > This one looks good to me
> >
> > >
> > >  int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> > >  {
> > > -	struct adv748x_state *state =3D tx->state;
> > > -	const struct adv748x_reg_value *reglist;
> > > -	int val;
> > > +	int val, ret;
> > >
> > >  	if (!is_tx_enabled(tx))
> > >  		return 0;
> > > @@ -311,13 +315,11 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, b=
ool on)
> > >  			"Enabling with unknown bit set");
> > >
> > >  	if (on)
> > > -		reglist =3D is_txa(tx) ? adv748x_power_up_txa_4lane :
> > > -				       adv748x_power_up_txb_1lane;
> > > +		ret =3D adv748x_power_up_tx(tx);
> > >  	else
> > > -		reglist =3D is_txa(tx) ? adv748x_power_down_txa_4lane :
> > > -				       adv748x_power_down_txb_1lane;
> > > +		ret =3D adv748x_power_down_tx(tx);
> > >
> > > -	return adv748x_write_regs(state, reglist);
> > > +	return ret;
> >
> > As Laurent suggested, or even
> >         return on ? adv748x_power_up_tx(tx) : adv748x_power_down_tx(tx);
>
> Good idea!
>
> >
> > Thanks
> >    j
> >
> > >  }
> > >
> > >  /* -----------------------------------------------------------------=
------------
> > > --
> > > 2.19.0
> > >
>
>
>
> --
> Regards,
> Niklas S=C3=B6derlund

--lKbk9CFItQTD29wm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb3C9BAAoJEHI0Bo8WoVY8qBIQAJPV8cQPD0zcooWnzDW2CfOG
06rpViRIcyNXG1Y+Rm2N53VZQwdl4WTccgvhSD5XyTCXwVp8cZDJa59cIllW0HZx
/IZ4AbhNFfoxIJkfw2fFxRu1qWlpS63XdHiNpsxp3PACnXUjxvfVym4rWpCIpmWS
tNFnCiPdGWv7K+LcPlRlSkJrYELvy/SsabO7nQBIHOFb1b4FMCq1CMpixwMRdCtl
bYuN/1RaCjILl2HfB+uLIF2UvYXTSUl8lxtk+CjNzfHIWtW9WJgNUv4EV13er3HK
z39Fyu3zK6Fiqhs7/WK54gO+ms7aF80j7F07TQxKtgHdO/l2FhgsDlZAGcosBpj2
hR2FHI/2Pv/Q0W09hYouHFiLaMeyDOXncFWQ51p9dgYb7uQZz4qsBC4u+G5N2NNN
OxlyHHNZ+1Z0RTYg8g5TUINTVGf3J6XJIcewTaXzreFG5Fi2zwh5DXYaGyE0F1wp
+yBp8HoF61URfGAE4duazpazWPvQMclrYEzGIrylnFbarShNryt0VJoefTku4pcB
mgBcgOJMRAH1NwSi88MRtalEFO8qC1EGahLzk7eDoUvr104Lp4heWKYwkV0ZZcJZ
3JImIXSs0cUSAzldXdGn5M+KiuW0wjMnR0Um2Nee3sgp8ncSgpPkuiwUqvqBUuoO
d8uqa4uM0/ehTFVt3ccL
=jrQW
-----END PGP SIGNATURE-----

--lKbk9CFItQTD29wm--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34285 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbeKYU74 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 15:59:56 -0500
Date: Sun, 25 Nov 2018 11:09:04 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 4/4] i2c: adv748x: configure number of lanes used for
 TXA CSI-2 transmitter
Message-ID: <20181125100904.GE6788@w540>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
 <20181102160009.17267-5-niklas.soderlund+renesas@ragnatech.se>
 <20181123140154.GF8279@w540>
 <2306235.pDioDJoL9o@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1XWsVB21DFCvn2e8"
Content-Disposition: inline
In-Reply-To: <2306235.pDioDJoL9o@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1XWsVB21DFCvn2e8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Fri, Nov 23, 2018 at 04:43:18PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> On Friday, 23 November 2018 16:01:54 EET jacopo mondi wrote:
> > On Fri, Nov 02, 2018 at 05:00:09PM +0100, Niklas S=C3=B6derlund wrote:
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
> > > * Changes since v2
> > > - Fix typos in comments.
> > > - Remove unneeded boiler plait code in adv748x_tx_power() as suggested
> > >
> > >   by Jacopo and Laurent.
> > >
> > > - Take into account the two different register used when powering up =
TXA
> > >
> > >   and TXB due to an earlier patch in this series aligns the power
> > >   sequence with the manual.
> > >
> > > * Changes since v1
> > > - Convert tables of register/value writes into functions instead of
> > >
> > >   intercepting and modifying the writes to the NUM_LANES register.
> > >
> > > ---
> > >
> > >  drivers/media/i2c/adv748x/adv748x-core.c | 157 ++++++++++++---------=
--
> > >  1 file changed, 79 insertions(+), 78 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > > b/drivers/media/i2c/adv748x/adv748x-core.c index
> > > 9d80d7f3062b16bc..d94c63cb6a2efdba 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > > @@ -125,6 +125,16 @@ int adv748x_write(struct adv748x_state *state, u8
> > > page, u8 reg, u8 value)
> > >  	return regmap_write(state->regmap[page], reg, value);
> > >  }
> > >
> > > +static int adv748x_write_check(struct adv748x_state *state, u8 page,=
 u8
> > > reg,
> > > +			       u8 value, int *error)
> > > +{
> > > +	if (*error)
> > > +		return *error;
> > > +
> > > +	*error =3D adv748x_write(state, page, reg, value);
> > > +	return *error;
> > > +}
> > > +
> > >  /* adv748x_write_block(): Write raw data with a maximum of
> > >  I2C_SMBUS_BLOCK_MAX>
> > >   * size to one or more registers.
> > >   *
> > > @@ -231,79 +241,77 @@ static int adv748x_write_regs(struct adv748x_st=
ate
> > > *state,
> > >   * TXA and TXB
> > >   */
> > >
> > > -static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] =
=3D {
> > > -
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > > -	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
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
> > > -	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> > > -	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
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
> > > +	/* Enable n-lane MIPI */
> > > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > > +
> > > +	/* Set Auto DPHY Timing */
> > > +	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> > > +
> > > +	/* ADI Required Write */
> > > +	if (is_txa(tx)) {
> > > +		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
> > > +		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
> > > +	} else {
> > > +		adv748x_write_check(state, page, 0xd2, 0x40, &ret);
> > > +	}
> > > +
> > > +	adv748x_write_check(state, page, 0xc4, 0x0a, &ret);
> > > +	adv748x_write_check(state, page, 0x71, 0x33, &ret);
> > > +	adv748x_write_check(state, page, 0x72, 0x11, &ret);
> > > +
> > > +	/* i2c_dphy_pwdn - 1'b0 */
> > > +	adv748x_write_check(state, page, 0xf0, 0x00, &ret);
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
> >
> > Where does the 0x20 come from? I don't see it in the register
> > description in the HW manual..
>
> Isn't it the EN_AUTOCALC_DPHY_PARAMS bit ?
>

Right, I missed that :)

> > > +	usleep_range(1000, 1500);
> > > +
> > > +	/* ADI Required Writes */
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
> > > +	/* Enable n-lane MIPI */
> >
> > The comment is wrong here: this write disables the CSI TX interface.
> >
> > > +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> > > +
> > > +	/* i2c_mipi_pll_en - 1'b1 */
> > > +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> >
> > Re-looking at power up/down sequences, this should actually be 0xda =3D=
 0x00,
> > as specified in seciont 9.5.2 of the HW manual.
> >
> > I know all of these come from tables in the previous version and has not
> > been introduced by this patch, but while at there it might be worth
> > fixing them.
> >
> > And actually, I don't like much the comments for registers pll_en and
> > dphy_pdn registers, and they might be improved, since you're rewriting
> > this sequence anyhow.
> >
> > I had a patch pending, before I realized you could change this in your
> > next v4. In case you want to have a look:
> > https://paste.debian.net/1052965/
>
> I would prefer fixes to be made on top of this patch, to separate the
> refactoring from the functional changes as much as possible.
>

Fine. I will send them based on next iteration of this series from
Niklas.

Thanks
   j

> > > +
> > > +	/* ADI Required Write */
> > > +	adv748x_write_check(state, page, 0xc1, 0x3b, &ret);
> > > +
> > > +	return ret;
> > > +}
> > >
> > >  int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
> > >  {
> > > -	struct adv748x_state *state =3D tx->state;
> > > -	const struct adv748x_reg_value *reglist;
> > >  	int val;
> > >
> > >  	if (!is_tx_enabled(tx))
> > > @@ -321,14 +329,7 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bo=
ol
> > > on)
> > >  	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
> > >  			"Enabling with unknown bit set");
> > >
> > > -	if (on)
> > > -		reglist =3D is_txa(tx) ? adv748x_power_up_txa_4lane :
> > > -				       adv748x_power_up_txb_1lane;
> > > -	else
> > > -		reglist =3D is_txa(tx) ? adv748x_power_down_txa_4lane :
> > > -				       adv748x_power_down_txb_1lane;
> > > -
> > > -	return adv748x_write_regs(state, reglist);
> > > +	return on ? adv748x_power_up_tx(tx) : adv748x_power_down_tx(tx);
> > >  }
> > >
> > >  /* -----------------------------------------------------------------=
-----
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--1XWsVB21DFCvn2e8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb+nTAAAoJEHI0Bo8WoVY8wxkP/jF3jtGKWDe55pMgA3fwVIea
vJwicoaZSwOblEYJkpabxs3xhp3kFdwbOdPTud+rl/4EP6PWQ3AnLLZbPELW5xvm
KmviOEdkqvwMLiAYD+pgN9j8pCNGPGSZnFoyMsb3KPiPzHe0XqaYDW145KxsaRvM
WfF+/XKZy5TpVHT9kraHACj53/k8pYJ+Pgn1Q/qk6DCrEMp3370OlMFYZUJHMIOQ
+RyjFn59yXMcq2nhAZjGO3OhuXZl87EpDqwnTzwXnjdPtu2O/u2w7PR3326y0zWu
x3N52hgvChSV/V5S55OTmB3/WsiQ20ctgV2Vbf6d+KKt2rIURBzD5ngICUEZ9pI/
mBnzVea1TEQod6sy/XGXks58nHoWE54VLTnjv95MSEn1cBRS6j+vRJRjEM1Q8jsZ
o5bmJQPLQeTNPhqO3qAeEojwZeqzK2xCISpX2W+pKyqJbXft8gKJlgy+zuzmbyPP
5m49U2zG87RKkgchIPLYO2uBDbGHGvKgTV4cKr3+ygGUtdmW1zug3UrsOWSCpA4t
+eQDLOPwWS4qHqhHptDKqsUUYK+u5jc2DdzHky7L5kSsShTdFw6Bl/WmeQSUc31L
jb1tQ+Q3p4v/Tu6e2a9EcRtfohSXsHtHVpC0DaMl62XBN9YbHCK2wPl7TgJ/jIMY
H+1+0JmPqmUWg88Napd9
=eXb8
-----END PGP SIGNATURE-----

--1XWsVB21DFCvn2e8--

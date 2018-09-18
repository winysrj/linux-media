Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39504 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbeISEUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 00:20:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter
Date: Wed, 19 Sep 2018 01:46:14 +0300
Message-ID: <2188241.SgTP4FcS7O@avalon>
In-Reply-To: <20180918192932.GW18450@bigcity.dyn.berto.se>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se> <cfcaa7a5-d642-e5cc-485b-267c7e5846a1@ideasonboard.com> <20180918192932.GW18450@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Tuesday, 18 September 2018 22:29:32 EEST Niklas S=F6derlund wrote:
> On 2018-09-18 11:13:45 +0100, Kieran Bingham wrote:
> > On 18/09/18 02:45, Niklas S=F6derlund wrote:
> >> The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it cou=
ld
> >> operate using 1-, 2- and 4-lanes. Update the driver to support all mod=
es
> >> the hardware does.
> >>=20
> >> The driver make use of large tables of static register/value writes wh=
en
> >> configuring the hardware, some writing to undocumented registers.
> >> Instead of creating 3 sets of the register tables for the different
> >> modes catch when the register containing NUM_LANES[2:0] is written to
> >> and inject the correct number of lanes.
> >=20
> > Aye aye aye.
> >=20
> > Neat solution to avoid adding more tables - but is it necessary? And I
> > can't find it easy to overlook the hack value in checking every register
> > write against a specific value :-(
>=20
> I agree it's not the most obvious nice solution.
>=20
> > Couldn't we create a function called "adv748x_configure_tx_lanes(...)"
> > or such and just write this value as appropriate after the tables are
> > written?
> >=20
> > That will then hopefully take us a step towards not needing (as much of)
> > these tables.
>=20
> This was my starting point :-) But the register is referenced multiple
> times in the tables and converting the tables to individual register
> writes turned out such a mess I judged this solution to be less of a
> maintenance burden. I'm however open to your views on how you would
> prefer this to be handled. Keep in mind that each row in the register
> tables needs to be turned into a:
>=20
>     /* Write registerx */
>     ret =3D adv748x_write(...)
>     if (ret)
>         return ret;
>=20
> So the overview of what happens become much harder to read.

Error checking may indeed make the code more difficult to read. One option=
=20
would be, in pseudo-code, something like the following.


struct adv748x_state {
	int write_error;
};

static int adv748x_error_check(struct adv748x_state *state)
{
	int error =3D state->write_error;

	state->write_error =3D 0;
	return error;
}

static int adv748x_write(struct adv748x_state *state, ...)
{
	int ret;

	if (state->write_error)
		return write_error;

	ret =3D write(...);
	state->write_error =3D ret;
	return ret;
}

=2E..
	adv748x_write(state, ...);
	adv748x_write(state, ...);
	adv748x_write(state, ...);
	adv748x_write(state, ...);

	ret =3D adv748x_error_check(state);
	if (ret)
		return ret;
=2E..

> Other options such as creating copies of the tables and injecting the
> NUM_LANE value at probe time I feel just hides the behavior even more.
>=20
> Another option I tried was to splice the tables whenever the register in
> question was referenced. This became hard to read but less lines of
> code.
>=20
> > However - *I fully understand ordering may be important here* so
> > actually it looks like we can't write this after writing the table.
> >=20
> > But it does look conveniently early in the tables, so we could split the
> > tables out and start functionalising them with the information we do kn=
ow.
>=20
> I have not tested if ordering is important or not, the documentation we
> have is just a sequential list of register writes, The register is used
> in multiple places in the tables making things even more ugly.

I would at least try reordering writes where we think it would make sense.

> adv748x_power_up_txa_4lane: 3 times, beginning and middle
> adv748x_power_down_txa_4lane: 1 time, middle
> adv748x_init_txa_4lane: 3 times, middle and end
>=20
> > I.e. We could have our init function enable the lanes, and handle the
> > auto DPHY, then write the rest through the tables.
>=20
> If only that where possible :-)
>=20
> I hold off posting v2 until I know how you wish to handle this. To help
> you make a decision the number of register writes in the tables involved
>=20
> :-)
>=20
> adv748x_power_up_txa_4lane: 11
> adv748x_power_down_txa_4lane: 5
> adv748x_init_txa_4lane: ~50
>=20
> > > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
=2Ese>
> > > ---
> > >=20
> > >  drivers/media/i2c/adv748x/adv748x-core.c | 38 +++++++++++++++++++---=
=2D-
> > >  1 file changed, 30 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > > b/drivers/media/i2c/adv748x/adv748x-core.c index
> > > a93f8ea89a228474..9a82cdf301bccb41 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > > @@ -207,13 +207,23 @@ static int adv748x_write_regs(struct adv748x_st=
ate
> > > *state,> >=20
> > >  			      const struct adv748x_reg_value *regs)
> > > =20
> > >  {
> > > =20
> > >  	int ret;
> > >=20
> > > +	u8 value;
> > >=20
> > >  	while (regs->page !=3D ADV748X_PAGE_EOR) {
> > >  =09
> > >  		if (regs->page =3D=3D ADV748X_PAGE_WAIT) {
> > >  	=09
> > >  			msleep(regs->value);
> > >  	=09
> > >  		} else {
> > >=20
> > > +			value =3D regs->value;
> > > +
> > > +			/*
> > > +			 * Register 0x00 in TXA needs to bei injected with
> >=20
> > s/bei/be/
> >=20
> > > +			 * the number of CSI-2 lanes used to transmitt.
> >=20
> > s/transmitt/transmit/
> >=20
> > > +			 */
> > > +			if (regs->page =3D=3D ADV748X_PAGE_TXA && regs->reg =3D=3D 0x00)
> > > +				value =3D (value & ~7) | state->txa.num_lanes;
> > > +
> > >=20
> > >  			ret =3D adv748x_write(state, regs->page, regs->reg,
> > >=20
> > > -				      regs->value);
> > > +					    value);
> > >=20
> > >  			if (ret < 0) {
> > >  		=09
> > >  				adv_err(state,
> > >  			=09
> > >  					"Error regs page: 0x%02x reg: 0x%02x\n",
> > >=20
> > > @@ -233,14 +243,18 @@ static int adv748x_write_regs(struct adv748x_st=
ate
> > > *state,> >=20
> > >  static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] =
=3D {
> > >=20
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write.=
=20
*/
> > > +	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
> > > +	{ADV748X_PAGE_TXA, 0x00, 0xa0},	/* Set Auto DPHY Timing */
> > >=20
> > >  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > >  	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > >=20
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > > +
> > > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write.=
=20
*/
> > > +	{ADV748X_PAGE_TXA, 0x00, 0x20 },/* Power-up CSI-TX */
> > > +
> > >=20
> > >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > >  	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > >=20
> > > @@ -253,7 +267,10 @@ static const struct adv748x_reg_value
> > > adv748x_power_down_txa_4lane[] =3D {> >=20
> > >  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> > >=20
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > +
> > > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write.=
=20
*/
> > > +	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
> >=20
> > If we're in power down - shouldn't this be "Disable n-lane MIPI */ ??
>=20
> Well the register write enables the lanes. IIRC the comments here come
> from the register tables text files found in the "documentation".
>=20
> > > +
> > >=20
> > >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > >  	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> > >=20
> > > @@ -399,8 +416,10 @@ static const struct adv748x_reg_value
> > > adv748x_init_txa_4lane[] =3D {> >=20
> > >  	/* Outputs Enabled */
> > >  	{ADV748X_PAGE_IO, 0x10, 0xa0},	/* Enable 4-lane CSI Tx & Pixel Port=
=20
*/
> > >=20
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write.=
=20
*/
> > > +	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
> > > +	{ADV748X_PAGE_TXA, 0x00, 0xa0},	/* Set Auto DPHY Timing */
> > > +
> > >=20
> > >  	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> > >=20
> > > @@ -412,7 +431,10 @@ static const struct adv748x_reg_value
> > > adv748x_init_txa_4lane[] =3D {> >=20
> > >  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > >  	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> > >=20
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> > > +
> > > +	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write.=
=20
*/
> > > +	{ADV748X_PAGE_TXA, 0x00, 0x20 },/* Power-up CSI-TX */
> > > +
> > >=20
> > >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> > >  	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */

=2D-=20
Regards,

Laurent Pinchart

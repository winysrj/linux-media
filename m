Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40034 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeKBUuK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 16:50:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/5] i2c: adv748x: reorder register writes for CSI-2 transmitters initialization
Date: Fri, 02 Nov 2018 13:43:21 +0200
Message-ID: <13521791.45T9WbT6im@avalon>
In-Reply-To: <20181102103834.GH22306@bigcity.dyn.berto.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <4501829.jIgCaKJ1df@avalon> <20181102103834.GH22306@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 2 November 2018 12:38:34 EET Niklas S=F6derlund wrote:
> On 2018-10-05 01:36:11 +0300, Laurent Pinchart wrote:
> > On Thursday, 4 October 2018 23:41:35 EEST Niklas S=F6derlund wrote:
> > > From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> > >=20
> > > Reorder the initialization order of registers to allow for refactorin=
g.
> > > The move could have been done at the same time as the refactoring but
> > > since the documentation about some registers involved are missing do =
it
> > > separately.
> > >=20
> > > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
=2Ese>
> > > ---
> > >=20
> > >  drivers/media/i2c/adv748x/adv748x-core.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > > b/drivers/media/i2c/adv748x/adv748x-core.c index
> > > 6854d898fdd1f192..721ed6552bc1cde6 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > > @@ -383,8 +383,6 @@ static const struct adv748x_reg_value
> > > adv748x_init_txa_4lane[] =3D { {ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enab=
le
> > > LLC_DLL & Double LLC Timing */ {ADV748X_PAGE_IO, 0x0e, 0xdd},	/*
> > > LLC/PIX/SPI PINS TRISTATED AUD */
> > >=20
> > > -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > >=20
> > >  	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> > >=20
> > > @@ -392,6 +390,9 @@ static const struct adv748x_reg_value
> > > adv748x_init_txa_4lane[] =3D { {ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI
> > > Required Write */
> > >=20
> > >  	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> > >=20
> > > +	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> > > +	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> > > +
> > >=20
> > >  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> > >=20
> > > @@ -435,17 +436,18 @@ static const struct adv748x_reg_value
> > > adv748x_init_txb_1lane[] =3D { {ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI
> > > Required Write */
> > >=20
> > >  	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC=
=20
*/
> > >=20
> > > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > > -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> > >=20
> > >  	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> > >  	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> > >=20
> > > +
> > > +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> > > +	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> > > +
> >=20
> > This is pretty hard to review, as there's a bunch of undocumented regis=
ter
> > writes. I think the first write is safe, as the tables are written
> > immediately following a software reset, and the default value of the
> > register is 0x81 (CSI-TX disabled, 1 lane). The second write, however,
> > enables usage of the computed DPHY parameters, and I don't know whether
> > the undocumented register writes in-between may interact with that.
>=20
> I agree it's hard to grasp all implications with undocumented registers
> involved. That is why I choose to do it in a separate commit so if
> regressions are found it could be bisectable to this change.
>=20
> > That being said, this change enables further important refactoring, so =
I'm
> > tempted to accept it. I assume you've tested it and haven't noticed a
> > regression. The part that still bothers me in particular is that the wr=
ite
> > to register 0xf0 just above this takes the DPHY out of power down
> > according to the datasheet, and I wonder whether at that point the DPHY
> > might not react to that information. Have you analyzed the power-up
> > sequence in section 9.5.1 of the hardware manual ? I wonder whether the
> > dphy_pwdn shouldn't be handled in the power up and power down sequences,
> > which might involve also moving the above four (and five for TXA)
> > undocumented writes to the power up sequence as well.
>=20
> I looked at the documentation and ran lots of tests based on this change
> and noticed no change in behavior.

As a last test, could you try programming completely invalid values to the=
=20
undocumented registers before taking the DPHY out of power down ? I'm worri=
ed=20
that things might work just because the registers happen to contain accepta=
ble=20
values when the DPHY is powered up, and that it might break later because t=
he=20
sequence of operations resulting from starting and stopping the video strea=
ms=20
in different configurations would end up taking the DPHY out of power down=
=20
with invalid values in those registers.

> >>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> >>  	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> >>  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> >> -
> >>  	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> >>  	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> >>  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */

=2D-=20
Regards,

Laurent Pinchart

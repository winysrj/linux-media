Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54482 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbeJEFb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 01:31:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v2 2/5] i2c: adv748x: reorder register writes for CSI-2 transmitters initialization
Date: Fri, 05 Oct 2018 01:36:11 +0300
Message-ID: <4501829.jIgCaKJ1df@avalon>
In-Reply-To: <20181004204138.2784-3-niklas.soderlund@ragnatech.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <20181004204138.2784-3-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:41:35 EEST Niklas S=F6derlund wrote:
> From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> Reorder the initialization order of registers to allow for refactoring.
> The move could have been done at the same time as the refactoring but
> since the documentation about some registers involved are missing do it
> separately.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index
> 6854d898fdd1f192..721ed6552bc1cde6 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -383,8 +383,6 @@ static const struct adv748x_reg_value
> adv748x_init_txa_4lane[] =3D { {ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enable
> LLC_DLL & Double LLC Timing */ {ADV748X_PAGE_IO, 0x0e, 0xdd},	/*
> LLC/PIX/SPI PINS TRISTATED AUD */
>=20
> -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
>  	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> @@ -392,6 +390,9 @@ static const struct adv748x_reg_value
> adv748x_init_txa_4lane[] =3D { {ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI
> Required Write */
>  	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
>=20
> +	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> +
>  	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> @@ -435,17 +436,18 @@ static const struct adv748x_reg_value
> adv748x_init_txb_1lane[] =3D { {ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI
> Required Write */
>  	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC */
>=20
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
>  	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> +
> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> +	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> +

This is pretty hard to review, as there's a bunch of undocumented register=
=20
writes. I think the first write is safe, as the tables are written immediat=
ely=20
following a software reset, and the default value of the register is 0x81=20
(CSI-TX disabled, 1 lane). The second write, however, enables usage of the=
=20
computed DPHY parameters, and I don't know whether the undocumented registe=
r=20
writes in-between may interact with that.

That being said, this change enables further important refactoring, so I'm=
=20
tempted to accept it. I assume you've tested it and haven't noticed a=20
regression. The part that still bothers me in particular is that the write =
to=20
register 0xf0 just above this takes the DPHY out of power down according to=
=20
the datasheet, and I wonder whether at that point the DPHY might not react =
to=20
that information. Have you analyzed the power-up sequence in section 9.5.1 =
of=20
the hardware manual ? I wonder whether the dphy_pwdn shouldn't be handled i=
n=20
the power up and power down sequences, which might involve also moving the=
=20
above four (and five for TXA) undocumented writes to the power up sequence =
as=20
well.

>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -
>  	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
>  	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
>  	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */

=2D-=20
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52754 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbeJEEx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 00:53:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v2 3/5] i2c: adv748x: reuse power up sequence when initializing CSI-2
Date: Fri, 05 Oct 2018 00:58:48 +0300
Message-ID: <1636157.lAsdG5Pq9I@avalon>
In-Reply-To: <20181004204138.2784-4-niklas.soderlund@ragnatech.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se> <20181004204138.2784-4-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 4 October 2018 23:41:36 EEST Niklas S=F6derlund wrote:
> From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> Instead of duplicate the register writes to power on the CSI-2
> transmitter when initialization the hardware reuse the dedicated power
> control functions.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 28 ++----------------------
>  1 file changed, 2 insertions(+), 26 deletions(-)

Nice diffstat.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Please see below for an additional comment.

> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index
> 721ed6552bc1cde6..41cc0cdd6a5fcef5 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -390,19 +390,6 @@ static const struct adv748x_reg_value
> adv748x_init_txa_4lane[] =3D { {ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI
> Required Write */
>  	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
>=20
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
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>=20
> @@ -442,19 +429,6 @@ static const struct adv748x_reg_value
> adv748x_init_txb_1lane[] =3D { {ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI
> Required Write */
>  	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
>=20
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
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>=20
> @@ -476,6 +450,7 @@ static int adv748x_reset(struct adv748x_state *state)
>  	if (ret)
>  		return ret;
>=20
> +	adv748x_tx_power(&state->txa, 1);
>  	adv748x_tx_power(&state->txa, 0);

This makes me think there's room for further improvement :-)

>  	/* Init and power down TXB */
> @@ -483,6 +458,7 @@ static int adv748x_reset(struct adv748x_state *state)
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

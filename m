Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54424 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeIRPtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:49:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down
Date: Tue, 18 Sep 2018 13:17:33 +0300
Message-ID: <1979276.imk8I1T1qk@avalon>
In-Reply-To: <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se> <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 18 September 2018 04:45:09 EEST Niklas S=F6derlund wrote:
> Fix copy-and-past error in comment for TXB CSI-2 transmitter power down
> sequence.

Apart from the s/past/paste/ typo that Sergei pointed out, I see no other=20
issue.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> b/drivers/media/i2c/adv748x/adv748x-core.c index
> 9a82cdf301bccb41..86cb38f4d7cc11c6 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -299,7 +299,7 @@ static const struct adv748x_reg_value
> adv748x_power_down_txb_1lane[] =3D {
>=20
>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
>  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
>  	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */


=2D-=20
Regards,

Laurent Pinchart

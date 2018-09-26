Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50990 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbeIZUCa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 16:02:30 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 3/3] i2c: adv748x: fix typo in comment for TXB CSI-2
 transmitter power down
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <0a4bb79e-2f5d-f4ee-1c5a-3d9a28d75596@ideasonboard.com>
Date: Wed, 26 Sep 2018 14:49:22 +0100
MIME-Version: 1.0
In-Reply-To: <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 18/09/18 02:45, Niklas Söderlund wrote:
> Fix copy-and-past error in comment for TXB CSI-2 transmitter power down
> sequence.
> 

I have collected this patch into my adv748x/for-next branch (and fixed
the typo in "copy-and-past" and submitted as a pull request for Hans and
Mauro.

--
Regards

Kieran


> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 9a82cdf301bccb41..86cb38f4d7cc11c6 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -299,7 +299,7 @@ static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
>  
>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
>  	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
>  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
>  	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
>  
> 

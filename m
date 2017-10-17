Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42139 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936340AbdJQPZI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 11:25:08 -0400
Message-ID: <1508253905.6854.15.camel@pengutronix.de>
Subject: Re: [PATCH][MEDIA] i.MX6: Fix MIPI CSI-2 LP-11 check
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 17 Oct 2017 17:25:05 +0200
In-Reply-To: <m3k1zul2uu.fsf@t19.piap.pl>
References: <m3k1zul2uu.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-10-17 at 08:12 +0200, Krzysztof Hałasa wrote:
> Bitmask for the MIPI CSI-2 data PHY status doesn't seem to be correct.
> Fix it.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> --- a/drivers/staging/media/imx/imx6-mipi-csi2.c
> +++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
> @@ -252,8 +252,8 @@ static int csi2_dphy_wait_stopstate(struct csi2_dev *csi2)
>  	u32 mask, reg;
>  	int ret;
>  
> -	mask = PHY_STOPSTATECLK |
> -		((csi2->bus.num_data_lanes - 1) << PHY_STOPSTATEDATA_BIT);
> +	mask = PHY_STOPSTATECLK | (((1 << csi2->bus.num_data_lanes) - 1) <<
> +				   PHY_STOPSTATEDATA_BIT);
>  
>  	ret = readl_poll_timeout(csi2->base + CSI2_PHY_STATE, reg,
>  				 (reg & mask) == mask, 0, 500000);

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

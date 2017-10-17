Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43413 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934082AbdJQQy3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 12:54:29 -0400
Received: by mail-pg0-f65.google.com with SMTP id s75so1887861pgs.0
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 09:54:28 -0700 (PDT)
Subject: Re: [PATCH][MEDIA] i.MX6: Fix MIPI CSI-2 LP-11 check
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <m3k1zul2uu.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <eaf6c4e4-3e20-e359-c5f0-5cc0db8427c8@gmail.com>
Date: Tue, 17 Oct 2017 09:54:24 -0700
MIME-Version: 1.0
In-Reply-To: <m3k1zul2uu.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/16/2017 11:12 PM, Krzysztof Hałasa wrote:
> Bitmask for the MIPI CSI-2 data PHY status doesn't seem to be correct.
> Fix it.
>
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
>
> --- a/drivers/staging/media/imx/imx6-mipi-csi2.c
> +++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
> @@ -252,8 +252,8 @@ static int csi2_dphy_wait_stopstate(struct csi2_dev *csi2)
>   	u32 mask, reg;
>   	int ret;
>   
> -	mask = PHY_STOPSTATECLK |
> -		((csi2->bus.num_data_lanes - 1) << PHY_STOPSTATEDATA_BIT);
> +	mask = PHY_STOPSTATECLK | (((1 << csi2->bus.num_data_lanes) - 1) <<
> +				   PHY_STOPSTATEDATA_BIT);
>   
>   	ret = readl_poll_timeout(csi2->base + CSI2_PHY_STATE, reg,
>   				 (reg & mask) == mask, 0, 500000);
>

Thanks for catching.

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>

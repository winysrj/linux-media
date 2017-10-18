Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57007 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750954AbdJRQAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 12:00:01 -0400
Message-ID: <1508342385.9874.12.camel@pengutronix.de>
Subject: Re: [PATCH] imx-csi: fix burst size
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Wed, 18 Oct 2017 17:59:45 +0200
In-Reply-To: <E1dy32l-0003Pb-Lv@rmk-PC.armlinux.org.uk>
References: <E1dy32l-0003Pb-Lv@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-09-29 at 22:41 +0100, Russell King wrote:
> Setting a burst size of "8" doesn't work for IMX219 with 8-bit bayer,
> but a burst size of "16" does.  Fix this.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Oh, well, this isn't for me to apply after all.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 6d856118c223..e27bcdb63973 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -341,7 +341,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	case V4L2_PIX_FMT_SGBRG8:
>  	case V4L2_PIX_FMT_SGRBG8:
>  	case V4L2_PIX_FMT_SRGGB8:
> -		burst_size = 8;
> +		burst_size = 16;
>  		passthrough = true;
>  		passthrough_bits = 8;
>  		break;

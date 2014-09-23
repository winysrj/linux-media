Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46924 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaIWUZG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 16:25:06 -0400
Message-ID: <5421D71F.9010605@iki.fi>
Date: Tue, 23 Sep 2014 23:25:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] si2168: add FE_CAN_MULTISTREAM into caps
References: <1411491189-5554-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411491189-5554-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

On 09/23/2014 07:53 PM, Olli Salonen wrote:
> PLP selection was implemented for Si2168 last month (patchwork 25387). However, FE_CAN_MULTISTREAM was not added to dvb_frontend_ops of si2168. This patch adds FE_CAN_MULTISTREAM, which indicates that multiple PLP are supported.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/si2168.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 55a4212..c7e7446 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -598,7 +598,8 @@ static const struct dvb_frontend_ops si2168_ops = {
>   			FE_CAN_GUARD_INTERVAL_AUTO |
>   			FE_CAN_HIERARCHY_AUTO |
>   			FE_CAN_MUTE_TS |
> -			FE_CAN_2G_MODULATION
> +			FE_CAN_2G_MODULATION |
> +			FE_CAN_MULTISTREAM
>   	},
>
>   	.get_tune_settings = si2168_get_tune_settings,
>

-- 
http://palosaari.fi/

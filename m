Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48684 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbKKXKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 18:10:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] media: adv7180: increase delay after reset to 5ms
Date: Thu, 12 Nov 2015 01:10:47 +0200
Message-ID: <1743324.8Mae4aQqGO@avalon>
In-Reply-To: <1447162740-28096-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1447162740-28096-1-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

(CC'ing Lars-Peter Clausen)

Thank you for the patch.

On Tuesday 10 November 2015 14:39:00 Ulrich Hecht wrote:
> Initialization of the ADV7180 chip fails on the Renesas R8A7790-based
> Lager board about 50% of the time.  This patch resolves the issue by
> increasing the minimum delay after reset from 2 ms to 5 ms, following the
> recommendation in the ADV7180 datasheet:
> 
> "Executing a software reset takes approximately 2 ms. However, it is
> recommended to wait 5 ms before any further I2C writes are performed."
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Lars, would you like to take this in your tree with other Analog Devices 
patches, or should I take it ?

> ---
>  drivers/media/i2c/adv7180.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index f82c8aa..3c3c4bf 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -1112,7 +1112,7 @@ static int init_device(struct adv7180_state *state)
>  	mutex_lock(&state->mutex);
> 
>  	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
> -	usleep_range(2000, 10000);
> +	usleep_range(5000, 10000);
> 
>  	ret = state->chip_info->init(state);
>  	if (ret)

-- 
Regards,

Laurent Pinchart


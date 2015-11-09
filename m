Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44527 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbKIMqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 07:46:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] mt9v032: Do not unset master_mode
Date: Mon, 09 Nov 2015 14:46:42 +0200
Message-ID: <1542250.4NFmqc20qx@avalon>
In-Reply-To: <1446815625-18413-2-git-send-email-mpa@pengutronix.de>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <1446815625-18413-2-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Thank you for the patch.

On Friday 06 November 2015 14:13:44 Markus Pargmann wrote:
> The power_on function of the driver resets the chip and sets the
> CHIP_CONTROL register to 0. This switches the operating mode to slave.
> The s_stream function sets the correct mode. But this caused problems on
> a board where the camera chip is operated as master. The camera started
> after a random amount of time streaming an image, I observed between 10
> and 300 seconds.
> 
> The STRFM_OUT and STLN_OUT pins are not connected on this board which
> may cause some issues in slave mode. I could not find any documentation
> about this.
> 
> Keeping the chip in master mode after the reset helped to fix this
> issue for me.
> 
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>  drivers/media/i2c/mt9v032.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 4aefde9634f5..943c3f39ea73 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -344,7 +344,8 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	if (ret < 0)
>  		return ret;
> 
> -	return regmap_write(map, MT9V032_CHIP_CONTROL, 0);
> +	return regmap_write(map, MT9V032_CHIP_CONTROL,
> +			    MT9V032_CHIP_CONTROL_MASTER_MODE);

This makes sense, but shouldn't you also fix the mt9v032_s_stream() function 
then ? It clears the MT9V032_CHIP_CONTROL_MASTER_MODE bit when turning the 
stream off.

>  }
> 
>  static void mt9v032_power_off(struct mt9v032 *mt9v032)

-- 
Regards,

Laurent Pinchart


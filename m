Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36792 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaGLUTR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jul 2014 16:19:17 -0400
Message-ID: <53C19842.8090308@iki.fi>
Date: Sat, 12 Jul 2014 23:19:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: em28xx - add error handling for KWORLD dvb_attach
 failures
References: <1404938183-29535-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1404938183-29535-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks correct!
All the other devices, excluding those few PCTV ones I have added, has 
that same bug... Deadlocks if tuner attach fails.

Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti


On 07/09/2014 11:36 PM, Shuah Khan wrote:
> Add error hanlding when EM2870_BOARD_KWORLD_A340 dvb_attach()
> for fe and tuner fail in em28xx_dvb_init().
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-dvb.c |   14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index d381861..8314f51 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1213,9 +1213,17 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   		dvb->fe[0] = dvb_attach(lgdt3305_attach,
>   					   &em2870_lgdt3304_dev,
>   					   &dev->i2c_adap[dev->def_i2c_bus]);
> -		if (dvb->fe[0] != NULL)
> -			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
> -				   &dev->i2c_adap[dev->def_i2c_bus], &kworld_a340_config);
> +		if (!dvb->fe[0]) {
> +			result = -EINVAL;
> +			goto out_free;
> +		}
> +		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
> +			&dev->i2c_adap[dev->def_i2c_bus],
> +			&kworld_a340_config)) {
> +				dvb_frontend_detach(dvb->fe[0]);
> +				result = -EINVAL;
> +				goto out_free;
> +		}
>   		break;
>   	case EM28174_BOARD_PCTV_290E:
>   		/* set default GPIO0 for LNA, used if GPIOLIB is undefined */
>

-- 
http://palosaari.fi/

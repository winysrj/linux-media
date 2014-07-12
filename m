Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43253 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbaGLUU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jul 2014 16:20:29 -0400
Message-ID: <53C19889.1000800@iki.fi>
Date: Sat, 12 Jul 2014 23:20:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: em28xx-dvb - fix em28xx_dvb_resume() to not unregister
 i2c and dvb
References: <1404912087-22028-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1404912087-22028-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 07/09/2014 04:21 PM, Shuah Khan wrote:
> em28xx_dvb_resume() unregisters i2c tuner, i2c demod, and dvb.
> This erroneous cleanup results in i2c tuner, i2c demod, and dvb
> devices unregistered and removed during resume. This error is a
> result of merge conflict between two patches that went into 3.15.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-dvb.c |   17 -----------------
>   1 file changed, 17 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index a121ed9..d381861 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1712,7 +1712,6 @@ static int em28xx_dvb_resume(struct em28xx *dev)
>   	em28xx_info("Resuming DVB extension");
>   	if (dev->dvb) {
>   		struct em28xx_dvb *dvb = dev->dvb;
> -		struct i2c_client *client = dvb->i2c_client_tuner;
>
>   		if (dvb->fe[0]) {
>   			ret = dvb_frontend_resume(dvb->fe[0]);
> @@ -1723,22 +1722,6 @@ static int em28xx_dvb_resume(struct em28xx *dev)
>   			ret = dvb_frontend_resume(dvb->fe[1]);
>   			em28xx_info("fe1 resume %d", ret);
>   		}
> -		/* remove I2C tuner */
> -		if (client) {
> -			module_put(client->dev.driver->owner);
> -			i2c_unregister_device(client);
> -		}
> -
> -		/* remove I2C demod */
> -		client = dvb->i2c_client_demod;
> -		if (client) {
> -			module_put(client->dev.driver->owner);
> -			i2c_unregister_device(client);
> -		}
> -
> -		em28xx_unregister_dvb(dvb);
> -		kfree(dvb);
> -		dev->dvb = NULL;
>   	}
>
>   	return 0;
>

-- 
http://palosaari.fi/

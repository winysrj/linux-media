Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35372 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbeHKIn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Aug 2018 04:43:28 -0400
Subject: Re: [PATCH v2] media: i2c: lm3560: use conservative defaults
To: Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
        nekit1000@gmail.com, mpartap@gmx.net, merlijn@wizzup.org,
        m.chehab@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
References: <20180506080250.GA24114@amd> <20180716090814.GA4505@amd>
From: Daniel Jeong <gshark.jeong@gmail.com>
Message-ID: <3a9ece34-baad-a19d-c3bd-96aa458ea70b@gmail.com>
Date: Sat, 11 Aug 2018 15:10:14 +0900
MIME-Version: 1.0
In-Reply-To: <20180716090814.GA4505@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

I think if there is not exist pdata, it should be set to the value of power on reset (POR) to sync with the chip.

According to the LM3560 datasheet, Flash Timeout is 512ms, Flash current is 875mA and Torch Current is 93.75mA.

Daniel Jeong.

On 07/016/2018 18:08 PM, Pavel Machek wrote:

> If no pdata is found, we should use lowest current settings, not highest.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> ---
>
> v2: I got notification from patchwork that patch no longer applies, so
> I'm rediffing the patch.
>
> diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
> index b600e03a..c4e5ed5 100644
> --- a/drivers/media/i2c/lm3560.c
> +++ b/drivers/media/i2c/lm3560.c
> @@ -420,14 +434,14 @@ static int lm3560_probe(struct i2c_client *client,
>   		pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>   		if (pdata == NULL)
>   			return -ENODEV;
> -		pdata->peak = LM3560_PEAK_3600mA;
> -		pdata->max_flash_timeout = LM3560_FLASH_TOUT_MAX;
> +		pdata->peak = LM3560_PEAK_1600mA;
> +		pdata->max_flash_timeout = LM3560_FLASH_TOUT_MIN;
>   		/* led 1 */
> -		pdata->max_flash_brt[LM3560_LED0] = LM3560_FLASH_BRT_MAX;
> -		pdata->max_torch_brt[LM3560_LED0] = LM3560_TORCH_BRT_MAX;
> +		pdata->max_flash_brt[LM3560_LED0] = LM3560_FLASH_BRT_MIN;
> +		pdata->max_torch_brt[LM3560_LED0] = LM3560_TORCH_BRT_MIN;
>   		/* led 2 */
> -		pdata->max_flash_brt[LM3560_LED1] = LM3560_FLASH_BRT_MAX;
> -		pdata->max_torch_brt[LM3560_LED1] = LM3560_TORCH_BRT_MAX;
> +		pdata->max_flash_brt[LM3560_LED1] = LM3560_FLASH_BRT_MIN;
> +		pdata->max_torch_brt[LM3560_LED1] = LM3560_TORCH_BRT_MIN;
>   	}
>   	flash->pdata = pdata;
>   	flash->dev = &client->dev;
>
>
>

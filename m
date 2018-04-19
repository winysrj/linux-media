Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34390 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbeDSSKD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 14:10:03 -0400
Subject: Re: [PATCH 2/9] cx231xx: Use board profile values for addresses
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@s-opensource.com
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
 <1523983195-28691-3-git-send-email-brad@nextdimension.cc>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <00cb50ca-b467-2f0f-fbdc-92b8b9faad3b@gentoo.org>
Date: Thu, 19 Apr 2018 20:10:02 +0200
MIME-Version: 1.0
In-Reply-To: <1523983195-28691-3-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.04.2018 um 18:39 schrieb Brad Love:
> Replace all usage of hard coded values with
> the proper field from the board profile.
> 

Hi Brad,

will there be any interference with the usage to configure the analog
tuner via the fields tuner_addr and tuner_type?

Regards
Matthias

> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>  drivers/media/usb/cx231xx/cx231xx-dvb.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> index 67ed667..99f1a77 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
> @@ -728,7 +728,7 @@ static int dvb_init(struct cx231xx *dev)
>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>  
>  		if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
> -			       0x60, tuner_i2c,
> +			       dev->board.tuner_addr, tuner_i2c,
>  			       &cnxt_rde253s_tunerconfig)) {
>  			result = -EINVAL;
>  			goto out_free;
> @@ -752,7 +752,7 @@ static int dvb_init(struct cx231xx *dev)
>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>  
>  		if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
> -			       0x60, tuner_i2c,
> +			       dev->board.tuner_addr, tuner_i2c,
>  			       &cnxt_rde253s_tunerconfig)) {
>  			result = -EINVAL;
>  			goto out_free;
> @@ -779,7 +779,7 @@ static int dvb_init(struct cx231xx *dev)
>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>  
>  		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
> -			   0x60, tuner_i2c,
> +			   dev->board.tuner_addr, tuner_i2c,
>  			   &hcw_tda18271_config);
>  		break;
>  
> @@ -797,7 +797,7 @@ static int dvb_init(struct cx231xx *dev)
>  
>  		memset(&info, 0, sizeof(struct i2c_board_info));
>  		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
> -		info.addr = 0x64;
> +		info.addr = dev->board.demod_addr;
>  		info.platform_data = &si2165_pdata;
>  		request_module(info.type);
>  		client = i2c_new_device(demod_i2c, &info);
> @@ -822,8 +822,7 @@ static int dvb_init(struct cx231xx *dev)
>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>  
>  		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
> -			0x60,
> -			tuner_i2c,
> +			dev->board.tuner_addr, tuner_i2c,
>  			&hcw_tda18271_config);
>  
>  		dev->cx231xx_reset_analog_tuner = NULL;
> @@ -844,7 +843,7 @@ static int dvb_init(struct cx231xx *dev)
>  
>  		memset(&info, 0, sizeof(struct i2c_board_info));
>  		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
> -		info.addr = 0x64;
> +		info.addr = dev->board.demod_addr;
>  		info.platform_data = &si2165_pdata;
>  		request_module(info.type);
>  		client = i2c_new_device(demod_i2c, &info);
> @@ -879,7 +878,7 @@ static int dvb_init(struct cx231xx *dev)
>  		si2157_config.if_port = 1;
>  		si2157_config.inversion = true;
>  		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
> -		info.addr = 0x60;
> +		info.addr = dev->board.tuner_addr;
>  		info.platform_data = &si2157_config;
>  		request_module("si2157");
>  
> @@ -938,7 +937,7 @@ static int dvb_init(struct cx231xx *dev)
>  		si2157_config.if_port = 1;
>  		si2157_config.inversion = true;
>  		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
> -		info.addr = 0x60;
> +		info.addr = dev->board.tuner_addr;
>  		info.platform_data = &si2157_config;
>  		request_module("si2157");
>  
> @@ -985,7 +984,7 @@ static int dvb_init(struct cx231xx *dev)
>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>  
>  		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
> -			   0x60, tuner_i2c,
> +			   dev->board.tuner_addr, tuner_i2c,
>  			   &pv_tda18271_config);
>  		break;
>  
> 

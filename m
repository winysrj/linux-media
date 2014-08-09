Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37417 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaHIWWn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 18:22:43 -0400
Message-ID: <53E69F30.1020603@iki.fi>
Date: Sun, 10 Aug 2014 01:22:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] support for DVBSky dvb-s2 usb: change em28xx-dvb.c
 following the m88ds3103 config change
References: <201408061234417811441@gmail.com>
In-Reply-To: <201408061234417811441@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks fine
Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


On 08/06/2014 07:34 AM, nibble.max wrote:
> change em28xx-dvb.c following the m88ds3103 config change
> 
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
>   drivers/media/usb/em28xx/em28xx-dvb.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 3a3e243..d8e9760 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -856,7 +856,9 @@ static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
>   	.clock = 27000000,
>   	.i2c_wr_max = 33,
>   	.clock_out = 0,
> -	.ts_mode = M88DS3103_TS_PARALLEL_16,
> +	.ts_mode = M88DS3103_TS_PARALLEL,
> +	.ts_clk = 16000,
> +	.ts_clk_pol = 1,
>   	.agc = 0x99,
>   };
>    
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
http://palosaari.fi/

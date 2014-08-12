Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56848 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaHLXXm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 19:23:42 -0400
Message-ID: <53EAA1FA.4020806@iki.fi>
Date: Wed, 13 Aug 2014 02:23:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, olli@cabbala.net
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/6] em28xx: add ts mode setting for PCTV 461e
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi> <1407787095-2167-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

PCTV 461e is satellite receiver whilst that one should be PCTV 292e. I 
will fix the type, no new patch needed.

Antti


On 08/11/2014 10:58 PM, Olli Salonen wrote:
> TS mode must be set in the existing PCTV 461e driver.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index d8e9760..0645793 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1535,6 +1535,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   			/* attach demod */
>   			si2168_config.i2c_adapter = &adapter;
>   			si2168_config.fe = &dvb->fe[0];
> +			si2168_config.ts_mode = SI2168_TS_PARALLEL;
>   			memset(&info, 0, sizeof(struct i2c_board_info));
>   			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
>   			info.addr = 0x64;
>

-- 
http://palosaari.fi/

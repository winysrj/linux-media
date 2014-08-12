Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44790 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaHLXZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 19:25:23 -0400
Message-ID: <53EAA25F.7030007@iki.fi>
Date: Wed, 13 Aug 2014 02:25:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, olli@cabbala.net
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] cxusb: add ts mode setting for TechnoTrend CT2-4400
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi> <1407787095-2167-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-3-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 08/11/2014 10:58 PM, Olli Salonen wrote:
> TS mode must be set in the existing TechnoTrend CT2-4400 driver.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/usb/dvb-usb/cxusb.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 16bc579..87842e9 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1369,6 +1369,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
>   	/* attach frontend */
>   	si2168_config.i2c_adapter = &adapter;
>   	si2168_config.fe = &adap->fe_adap[0].fe;
> +	si2168_config.ts_mode = SI2168_TS_PARALLEL;
>   	memset(&info, 0, sizeof(struct i2c_board_info));
>   	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
>   	info.addr = 0x64;
>

-- 
http://palosaari.fi/

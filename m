Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44312 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951AbaLMECL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 23:02:11 -0500
Message-ID: <548BBA41.7000109@iki.fi>
Date: Sat, 13 Dec 2014 06:02:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave
 demodulators
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418429925-16342-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am not sure even idea of that. You didn't add even commit description, 
like all the other patches too :( You should really start adding commit 
messages explaining why and how commit is.

So the question is why that patch should be applied?

On the other-hand, how there is
if (fe->id == 1 && onoff) {
... as I don't remember any patch changing it to 0. I look my tree FE ID 
is 0. Do you have some unpublished hacks?

Antti


On 12/13/2014 02:18 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index ab48b5f..cdc342a 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -863,6 +863,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
>
>   		/* attach slave demodulator */
>   		if (priv->slave_demod == SLAVE_DEMOD_MN88472) {
> +			struct dvb_frontend *tmp_fe;
>   			struct mn88472_config mn88472_config = {};
>
>   			mn88472_config.fe = &adap->fe[1];
> @@ -887,6 +888,12 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
>   			}
>
>   			priv->i2c_client_slave_demod = client;
> +
> +			/* Swap frontend order */
> +			tmp_fe = adap->fe[0];
> +			adap->fe[0] = adap->fe[1];
> +			adap->fe[1] = tmp_fe;
> +
>   		} else {
>   			struct mn88473_config mn88473_config = {};
>
> @@ -1373,7 +1380,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
>
>   	/* bypass slave demod TS through master demod */
>   	if (fe->id == 1 && onoff) {
> -		ret = rtl2832_enable_external_ts_if(adap->fe[0]);
> +		ret = rtl2832_enable_external_ts_if(adap->fe[1]);
>   		if (ret)
>   			goto err;
>   	}
>

-- 
http://palosaari.fi/

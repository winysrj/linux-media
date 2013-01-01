Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60137 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3AAVQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 16:16:39 -0500
Message-ID: <50E35213.1030404@iki.fi>
Date: Tue, 01 Jan 2013 23:16:03 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 07/11] it913x: make remote controller optional
References: <1355100335-2123-1-git-send-email-crope@iki.fi> <1355100335-2123-7-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-7-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Care to Ack that one too?

regards
Antti

On 12/10/2012 02:45 AM, Antti Palosaari wrote:
> Do not compile remote controller when RC-core is disabled by Kconfig.
>
> Cc: Malcolm Priestley <tvboxspy@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/usb/dvb-usb-v2/it913x.c | 36 +++++++++++++++++++----------------
>   1 file changed, 20 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
> index 4720428..5dc352b 100644
> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
> @@ -308,6 +308,7 @@ static struct i2c_algorithm it913x_i2c_algo = {
>   };
>
>   /* Callbacks for DVB USB */
> +#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
>   #define IT913X_POLL 250
>   static int it913x_rc_query(struct dvb_usb_device *d)
>   {
> @@ -334,6 +335,25 @@ static int it913x_rc_query(struct dvb_usb_device *d)
>   	return ret;
>   }
>
> +static int it913x_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
> +{
> +	struct it913x_state *st = d->priv;
> +
> +	if (st->proprietary_ir == false) {
> +		rc->map_name = NULL;
> +		return 0;
> +	}
> +
> +	rc->allowed_protos = RC_BIT_NEC;
> +	rc->query = it913x_rc_query;
> +	rc->interval = 250;
> +
> +	return 0;
> +}
> +#else
> +	#define it913x_get_rc_config NULL
> +#endif
> +
>   /* Firmware sets raw */
>   static const char fw_it9135_v1[] = FW_IT9135_V1;
>   static const char fw_it9135_v2[] = FW_IT9135_V2;
> @@ -695,22 +715,6 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
>   }
>
>   /* DVB USB Driver */
> -static int it913x_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
> -{
> -	struct it913x_state *st = d->priv;
> -
> -	if (st->proprietary_ir == false) {
> -		rc->map_name = NULL;
> -		return 0;
> -	}
> -
> -	rc->allowed_protos = RC_BIT_NEC;
> -	rc->query = it913x_rc_query;
> -	rc->interval = 250;
> -
> -	return 0;
> -}
> -
>   static int it913x_get_adapter_count(struct dvb_usb_device *d)
>   {
>   	struct it913x_state *st = d->priv;
>


-- 
http://palosaari.fi/

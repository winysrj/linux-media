Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60624 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaJLKM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 06:12:29 -0400
Message-ID: <543A540A.2010507@iki.fi>
Date: Sun, 12 Oct 2014 13:12:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
CC: nibble.max@gmail.com
Subject: Re: [PATCH 4/4] dvbsky: add option to disable IR receiver
References: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi> <1413108191-32510-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1413108191-32510-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/12/2014 01:03 PM, Olli Salonen wrote:
> Added an option disable_rc that can be used to disable the IR receiver polling for this module.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/usb/dvb-usb-v2/dvbsky.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> index 5c7387a..71a3324 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> @@ -25,6 +25,10 @@
>   #define DVBSKY_MSG_DELAY	0/*2000*/
>   #define DVBSKY_BUF_LEN	64
>
> +static int dvb_usb_dvbsky_disable_rc;
> +module_param_named(disable_rc, dvb_usb_dvbsky_disable_rc, int, 0644);
> +MODULE_PARM_DESC(disable_rc, "Disable inbuilt IR receiver.");
> +
>   DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>
>   struct dvbsky_state {
> @@ -218,6 +222,10 @@ static int dvbsky_rc_query(struct dvb_usb_device *d)
>
>   static int dvbsky_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
>   {
> +	if (dvb_usb_dvbsky_disable_rc)
> +		return 0;
> +
> +	rc->map_name       = RC_MAP_DVBSKY;
>   	rc->allowed_protos = RC_BIT_RC5;
>   	rc->query          = dvbsky_rc_query;
>   	rc->interval       = 300;
> @@ -450,7 +458,7 @@ static struct dvb_usb_device_properties dvbsky_s960_props = {
>
>   static const struct usb_device_id dvbsky_id_table[] = {
>   	{ DVB_USB_DEVICE(0x0572, 0x6831,
> -		&dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
> +		&dvbsky_s960_props, "DVBSky S960/S860", NULL) },

Why you removed default keytable too?

>   	{ }
>   };
>   MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
>

-- 
http://palosaari.fi/

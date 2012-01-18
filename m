Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3814 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2ARNeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 08:34:18 -0500
Message-ID: <4F16C6B8.8000402@linuxtv.org>
Date: Wed, 18 Jan 2012 08:18:48 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.3] [media] DVB: dib0700, add support for
 Nova-TD LEDs
References: <E1RnU5E-0000Vf-T9@www.linuxtv.org>
In-Reply-To: <E1RnU5E-0000Vf-T9@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Why was my sign-off changed to an Ack?

As you can see, I worked *with* Jiri to help him create this patchset.

During review, I noticed a poorly named function, which I renamed before 
pusging it into my own tree.  Patrick saw this, and merged my changes 
into into his tree.

Why did I go through this effort to help another developer add value to 
one of our drivers, and additional effort to make a small cleanup, push 
the changes into my own tree and issue a pull request?  I was thanked by 
Patrick.  Everybody's signature is on the patch, but you then go and 
remove my signature, and add a forged "ack"?  I don't understand this, 
Mauro.

Why didn't you just take my pull request?  Instead, you have changed my 
signature?  What is the point of a signature if it will become mangled?

Please don't do this.  Or, if you have *some* legitimate reason to 
change my signature, you should at LEAST check with me before committing 
it into kernel history.

-Mike

On 01/17/2012 08:02 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] DVB: dib0700, add support for Nova-TD LEDs
> Author:  Jiri Slaby<jslaby@suse.cz>
> Date:    Tue Jan 10 14:11:25 2012 -0300
>
> Add an override of read_status to intercept lock status. This allows
> us to switch LEDs appropriately on and off with signal un/locked.
>
> The second phase is to override sleep to properly turn off both.
>
> This is a hackish way to achieve that.
>
> Thanks to Mike Krufky for his help.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Acked-by: Michael Krufky<mkrufky@linuxtv.org>
> Signed-off-by: Patrick Boettcher<pboettcher@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>   drivers/media/dvb/dvb-usb/dib0700.h         |    2 +
>   drivers/media/dvb/dvb-usb/dib0700_devices.c |   41 ++++++++++++++++++++++++++-
>   2 files changed, 42 insertions(+), 1 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=d43272a4e898a1e43e5ac351ab625b7a40b39e88
>
> diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
> index 9bd6d51..7de125c 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700.h
> +++ b/drivers/media/dvb/dvb-usb/dib0700.h
> @@ -48,6 +48,8 @@ struct dib0700_state {
>   	u8 disable_streaming_master_mode;
>   	u32 fw_version;
>   	u32 nb_packet_buffer_size;
> +	int (*read_status)(struct dvb_frontend *, fe_status_t *);
> +	int (*sleep)(struct dvb_frontend* fe);
>   	u8 buf[255];
>   };
>
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
> index 3ab45ae..f9e966a 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
> @@ -3105,6 +3105,35 @@ static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
>   	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
>   }
>
> +static int novatd_read_status_override(struct dvb_frontend *fe,
> +		fe_status_t *stat)
> +{
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct dvb_usb_device *dev = adap->dev;
> +	struct dib0700_state *state = dev->priv;
> +	int ret;
> +
> +	ret = state->read_status(fe, stat);
> +
> +	if (!ret)
> +		dib0700_set_gpio(dev, adap->id == 0 ? GPIO1 : GPIO0, GPIO_OUT,
> +				!!(*stat&  FE_HAS_LOCK));
> +
> +	return ret;
> +}
> +
> +static int novatd_sleep_override(struct dvb_frontend* fe)
> +{
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct dvb_usb_device *dev = adap->dev;
> +	struct dib0700_state *state = dev->priv;
> +
> +	/* turn off LED */
> +	dib0700_set_gpio(dev, adap->id == 0 ? GPIO1 : GPIO0, GPIO_OUT, 0);
> +
> +	return state->sleep(fe);
> +}
> +
>   /**
>    * novatd_frontend_attach - Nova-TD specific attach
>    *
> @@ -3114,6 +3143,7 @@ static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
>   static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
>   {
>   	struct dvb_usb_device *dev = adap->dev;
> +	struct dib0700_state *st = dev->priv;
>
>   	if (adap->id == 0) {
>   		stk7070pd_init(dev);
> @@ -3134,7 +3164,16 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
>   	adap->fe_adap[0].fe = dvb_attach(dib7000p_attach,&dev->i2c_adap,
>   			adap->id == 0 ? 0x80 : 0x82,
>   			&stk7070pd_dib7000p_config[adap->id]);
> -	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
> +
> +	if (adap->fe_adap[0].fe == NULL)
> +		return -ENODEV;
> +
> +	st->read_status = adap->fe_adap[0].fe->ops.read_status;
> +	adap->fe_adap[0].fe->ops.read_status = novatd_read_status_override;
> +	st->sleep = adap->fe_adap[0].fe->ops.sleep;
> +	adap->fe_adap[0].fe->ops.sleep = novatd_sleep_override;
> +
> +	return 0;
>   }
>
>   /* S5H1411 */


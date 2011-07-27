Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1G0THG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 15:07:06 -0400
Message-ID: <4E3061CF.2080009@redhat.com>
Date: Wed, 27 Jul 2011 16:06:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi>
In-Reply-To: <4E2E0788.3010507@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-07-2011 21:17, Antti Palosaari escreveu:
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-usb/dvb-usb-dvb.c  |   85 +++++++++++++++++++++++-------
>  drivers/media/dvb/dvb-usb/dvb-usb-init.c |    4 ++
>  drivers/media/dvb/dvb-usb/dvb-usb.h      |   11 +++-
>  3 files changed, 78 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> index d8c0bd9..5e34df7 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> @@ -162,8 +162,11 @@ static int dvb_usb_fe_wakeup(struct dvb_frontend *fe)
> 
>      dvb_usb_device_power_ctrl(adap->dev, 1);
> 
> -    if (adap->fe_init)
> -        adap->fe_init(fe);
> +    if (adap->props.frontend_ctrl)
> +        adap->props.frontend_ctrl(fe, 1);
> +
> +    if (adap->fe_init[fe->id])
> +        adap->fe_init[fe->id](fe);
> 
>      return 0;
>  }
> @@ -172,45 +175,89 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
>  {
>      struct dvb_usb_adapter *adap = fe->dvb->priv;
> 
> -    if (adap->fe_sleep)
> -        adap->fe_sleep(fe);
> +    if (adap->fe_sleep[fe->id])
> +        adap->fe_sleep[fe->id](fe);
> +
> +    if (adap->props.frontend_ctrl)
> +        adap->props.frontend_ctrl(fe, 0);
> 
>      return dvb_usb_device_power_ctrl(adap->dev, 0);
>  }
> 
>  int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
>  {
> +    int ret, i, x;
> +
> +    memset(adap->fe, 0, sizeof(adap->fe));
> +
>      if (adap->props.frontend_attach == NULL) {
> -        err("strange: '%s' #%d doesn't want to attach a frontend.",adap->dev->desc->name, adap->id);
> +        err("strange: '%s' #%d doesn't want to attach a frontend.",
> +            adap->dev->desc->name, adap->id);
> +
>          return 0;
>      }
> 
> -    /* re-assign sleep and wakeup functions */
> -    if (adap->props.frontend_attach(adap) == 0 && adap->fe[0] != NULL) {
> -        adap->fe_init  = adap->fe[0]->ops.init;  adap->fe[0]->ops.init  = dvb_usb_fe_wakeup;
> -        adap->fe_sleep = adap->fe[0]->ops.sleep; adap->fe[0]->ops.sleep = dvb_usb_fe_sleep;
> +    /* register all given adapter frontends */
> +    if (adap->props.num_frontends)
> +        x = adap->props.num_frontends - 1;
> +    else
> +        x = 0;
> +
> +    for (i = 0; i <= x; i++) {
> +        ret = adap->props.frontend_attach(adap);
> +        if (ret || adap->fe[i] == NULL) {
> +            /* only print error when there is no FE at all */
> +            if (i == 0)
> +                err("no frontend was attached by '%s'",
> +                    adap->dev->desc->name);

This doesn't seem right. One thing is to accept adap->fe[1] to be
NULL. Another thing is to accept an error at the attach. IMO, the
logic should be something like:

	if (ret < 0)
		return ret;

	if (!i && !adap->fe[0]) {
		err("no adapter!");
		return -ENODEV;
	}

> +
> +            return 0;
> +        }
> 
> -        if (dvb_register_frontend(&adap->dvb_adap, adap->fe[0])) {
> -            err("Frontend registration failed.");
> -            dvb_frontend_detach(adap->fe[0]);
> -            adap->fe[0] = NULL;
> -            return -ENODEV;
> +        adap->fe[i]->id = i;
> +
> +        /* re-assign sleep and wakeup functions */
> +        adap->fe_init[i] = adap->fe[i]->ops.init;
> +        adap->fe[i]->ops.init  = dvb_usb_fe_wakeup;
> +        adap->fe_sleep[i] = adap->fe[i]->ops.sleep;
> +        adap->fe[i]->ops.sleep = dvb_usb_fe_sleep;
> +
> +        if (dvb_register_frontend(&adap->dvb_adap, adap->fe[i])) {
> +            err("Frontend %d registration failed.", i);
> +            dvb_frontend_detach(adap->fe[i]);

There is a special case here: for DRX-K, we can't call dvb_frontend_detach().
as just one drxk_attach() returns the two pointers. While this is not fixed,
we need to add some logic here to check if the adapter were attached.

> +            adap->fe[i] = NULL;
> +            /* In error case, do not try register more FEs,
> +             * still leaving already registered FEs alive. */

I think that the proper thing to do is to detach everything, if one of
the attach fails. There isn't much sense on keeping the device partially
initialized.

> +            if (i == 0)
> +                return -ENODEV;
> +            else
> +                return 0;
>          }
> 
>          /* only attach the tuner if the demod is there */
>          if (adap->props.tuner_attach != NULL)
>              adap->props.tuner_attach(adap);
> -    } else
> -        err("no frontend was attached by '%s'",adap->dev->desc->name);
> +    }
> 
>      return 0;
>  }
> 
>  int dvb_usb_adapter_frontend_exit(struct dvb_usb_adapter *adap)
>  {
> -    if (adap->fe[0] != NULL) {
> -        dvb_unregister_frontend(adap->fe[0]);
> -        dvb_frontend_detach(adap->fe[0]);
> +    int i;
> +
> +    /* unregister all given adapter frontends */
> +    if (adap->props.num_frontends)
> +        i = adap->props.num_frontends - 1;
> +    else
> +        i = 0;
> +
> +    for (; i >= 0; i--) {
> +        if (adap->fe[i] != NULL) {
> +            dvb_unregister_frontend(adap->fe[i]);
> +            dvb_frontend_detach(adap->fe[i]);
> +        }
>      }
> +
>      return 0;
>  }
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
> index 2e3ea0f..f9af348 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
> @@ -77,6 +77,10 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
>              return ret;
>          }
> 
> +        /* use exclusive FE lock if there is multiple shared FEs */
> +        if (adap->fe[1])
> +            adap->dvb_adap.mfe_shared = 1;

Why? multiple FE doesn't mean that they're mutually exclusive.

> +
>          d->num_adapters_initialized++;
>          d->state |= DVB_USB_STATE_DVB;
>      }
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
> index 2e57bff..a3e77b2 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
> @@ -124,6 +124,8 @@ struct usb_data_stream_properties {
>   * @caps: capabilities of the DVB USB device.
>   * @pid_filter_count: number of PID filter position in the optional hardware
>   *  PID-filter.
> + * @num_frontends: number of frontends of the DVB USB adapter.
> + * @frontend_ctrl: called to power on/off active frontend.
>   * @streaming_ctrl: called to start and stop the MPEG2-TS streaming of the
>   *  device (not URB submitting/killing).
>   * @pid_filter_ctrl: called to en/disable the PID filter, if any.
> @@ -141,7 +143,9 @@ struct dvb_usb_adapter_properties {
>  #define DVB_USB_ADAP_RECEIVES_204_BYTE_TS         0x08
>      int caps;
>      int pid_filter_count;
> +    int num_frontends;
> 
> +    int (*frontend_ctrl)   (struct dvb_frontend *, int);
>      int (*streaming_ctrl)  (struct dvb_usb_adapter *, int);
>      int (*pid_filter_ctrl) (struct dvb_usb_adapter *, int);
>      int (*pid_filter)      (struct dvb_usb_adapter *, int, u16, int);
> @@ -345,6 +349,7 @@ struct usb_data_stream {
>   *
>   * @stream: the usb data stream.
>   */
> +#define MAX_NO_OF_FE_PER_ADAP 2
>  struct dvb_usb_adapter {
>      struct dvb_usb_device *dev;
>      struct dvb_usb_adapter_properties props;
> @@ -363,11 +368,11 @@ struct dvb_usb_adapter {
>      struct dmxdev        dmxdev;
>      struct dvb_demux     demux;
>      struct dvb_net       dvb_net;
> -    struct dvb_frontend *fe[1];
> +    struct dvb_frontend *fe[MAX_NO_OF_FE_PER_ADAP];
>      int                  max_feed_count;
> 
> -    int (*fe_init)  (struct dvb_frontend *);
> -    int (*fe_sleep) (struct dvb_frontend *);
> +    int (*fe_init[MAX_NO_OF_FE_PER_ADAP])  (struct dvb_frontend *);
> +    int (*fe_sleep[MAX_NO_OF_FE_PER_ADAP]) (struct dvb_frontend *);
> 
>      struct usb_data_stream stream;
> 


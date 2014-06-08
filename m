Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:34075 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaFHPUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 11:20:32 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6U009YTVY6NU30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 08 Jun 2014 11:20:30 -0400 (EDT)
Date: Sun, 08 Jun 2014 12:20:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Harper <james@ejbdigital.com.au>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: regression in dib0700
Message-id: <20140608122026.18a144db.m.chehab@samsung.com>
In-reply-to: <05b085d5192b4c92a9d474f49b60535c@SIXPR04MB304.apcprd04.prod.outlook.com>
References: <05b085d5192b4c92a9d474f49b60535c@SIXPR04MB304.apcprd04.prod.outlook.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 08 Jun 2014 13:20:45 +0000
James Harper <james@ejbdigital.com.au> escreveu:

> Somewhere along the way there's been a regression in dib0700 for my "Leadtek Winfast DTV Dongle (STK7700P based)"
> 
> One is the addition of dvb_detach(&state->dib7000p_ops);
> 
> The other is a missing .size_of_priv
> 
> The following is required to get it working again, although obviously commenting out dvb_detach isn't really correct. dvb_detach looks like it is supposed to take a function as an argument...

Actually, removing dvb_detach() there is the right thing to do. This 
should be called only at the error handling logic, on devices with
two frontends, with is not this case. 

Perhaps this came from some bad merge conflict solving.

I'll double check if dvb_detach() is called on needed error conditions,
and if it is not called elsewhere.

Thanks for reporting it!

Please re-span this patch removing the dvb_detach() and send it with
your Signed-off-by for me to apply the new version.

Regards,
Mauro

> 
> James
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index d067bb7..4c80151 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -721,7 +721,7 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
>                 adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
>                 st->is_dib7000pc = 1;
>         } else {
> -               dvb_detach(&state->dib7000p_ops);
> +               //dvb_detach(&state->dib7000p_ops);
>                 memset(&state->dib7000p_ops, 0, sizeof(state->dib7000p_ops));
>                 adap->fe_adap[0].fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
>         }
> @@ -3788,6 +3788,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
> 
>                                 DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
>                         }},
> +                               .size_of_priv     = sizeof(struct dib0700_adapter_state),
>                         },
>                 },

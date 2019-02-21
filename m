Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A0FC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 09:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3322320880
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 09:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfBUJft (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:35:49 -0500
Received: from gofer.mess.org ([88.97.38.141]:45457 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfBUJft (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 04:35:49 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 0E072602BB; Thu, 21 Feb 2019 09:35:46 +0000 (GMT)
Date:   Thu, 21 Feb 2019 09:35:46 +0000
From:   Sean Young <sean@mess.org>
To:     Jose Alberto Reguero <jareguero@telefonica.net>
Cc:     Linux media <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>, jose.alberto.reguero@gmail.com
Subject: Re: [PATCH V2 2/2] Add suport for Avermedia TD310
Message-ID: <20190221093546.7yjvnrvp64pmsmin@gofer.mess.org>
References: <97905686-6FE3-4EFE-9B1B-B137631FBAD3@telefonica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97905686-6FE3-4EFE-9B1B-B137631FBAD3@telefonica.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

s/suport/support in title.

On Wed, Feb 20, 2019 at 10:36:16PM +0100, Jose Alberto Reguero wrote:
> This patch add support for Avermedia TD310 usb stik. 

stick

> 
> Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com> 
> 
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-20 16:54:24.121847069 +0100
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-20 16:53:50.148848459 +0100
> @@ -1215,6 +1215,7 @@ static int it930x_frontend_attach(struct
>  	int ret;
>  	struct si2168_config si2168_config;
>  	struct i2c_adapter *adapter;
> +	u8 i2c_addr;
>  
>  	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
>  
> @@ -1267,7 +1268,11 @@ static int it930x_frontend_attach(struct
>  
>  	state->af9033_config[adap->id].fe = &adap->fe[0];
>  	state->af9033_config[adap->id].ops = &state->ops;
> -	ret = af9035_add_i2c_dev(d, "si2168", 0x67, &si2168_config,
> +	i2c_addr = 0x67;
> +	if ((le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) &&
> +			(le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_TD310))

Bad alignment. Please check with checkpatch.pl --strict

Also I'm not a fan of the comparing usb ids in the frontend attach. It would
be nicer to have this in some constant struct which stores per-device i2c
addresses (and other bits which vary per-device). 


Sean

> +		i2c_addr = 0x64;
> +	ret = af9035_add_i2c_dev(d, "si2168", i2c_addr, &si2168_config,
>  				&d->i2c_adap);
>  	if (ret)
>  		goto err;
> @@ -1614,13 +1619,20 @@ static int it930x_tuner_attach(struct dv
>  	struct usb_interface *intf = d->intf;
>  	int ret;
>  	struct si2157_config si2157_config;
> +	u8 i2c_addr;
>  
>  	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
>  
>  	memset(&si2157_config, 0, sizeof(si2157_config));
>  	si2157_config.fe = adap->fe[0];
>  	si2157_config.if_port = 1;
> -	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
> +	i2c_addr = 0x63;
> +	if ((le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA) &&
> +			(le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_TD310)) {
> +		i2c_addr = 0x60;
> +		si2157_config.if_port = 0;
> +	}
> +	ret = af9035_add_i2c_dev(d, "si2157", i2c_addr,
>  			&si2157_config, state->i2c_adapter_demod);
>  
>  	if (ret)
> @@ -2128,6 +2140,8 @@ static const struct usb_device_id af9035
>  	/* IT930x devices */
>  	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
>  		&it930x_props, "ITE 9303 Generic", NULL) },
> +	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD310,
> +		&it930x_props, "AVerMedia TD310 DVB-T2", NULL) },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(usb, af9035_id_table);
> diff -upr linux/include/media/dvb-usb-ids.h linux.new/include/media/dvb-usb-ids.h
> --- linux/include/media/dvb-usb-ids.h	2018-05-05 07:40:18.000000000 +0200
> +++ linux.new/include/media/dvb-usb-ids.h	2019-02-20 16:53:50.149848459 +0100
> @@ -258,6 +258,7 @@
>  #define USB_PID_AVERMEDIA_A867				0xa867
>  #define USB_PID_AVERMEDIA_H335				0x0335
>  #define USB_PID_AVERMEDIA_TD110				0xa110
> +#define USB_PID_AVERMEDIA_TD310				0x1871
>  #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
>  #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
>  #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
> 
> -- 
> Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.

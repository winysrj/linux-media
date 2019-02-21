Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F71C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 09:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E41B20880
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 09:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfBUJcb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:32:31 -0500
Received: from gofer.mess.org ([88.97.38.141]:39157 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfBUJcb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 04:32:31 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 4EF82602BB; Thu, 21 Feb 2019 09:32:29 +0000 (GMT)
Date:   Thu, 21 Feb 2019 09:32:29 +0000
From:   Sean Young <sean@mess.org>
To:     Jose Alberto Reguero <jareguero@telefonica.net>
Cc:     Linux media <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>, jose.alberto.reguero@gmail.com
Subject: Re: [PATCH V2 1/2] af9035: init i2c already in it930x_frontend_attach
Message-ID: <20190221093228.bjcdf34vi6q7nx2t@gofer.mess.org>
References: <77409C7A-37D1-45F1-A188-97FF92C79699@telefonica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77409C7A-37D1-45F1-A188-97FF92C79699@telefonica.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 20, 2019 at 10:36:04PM +0100, Jose Alberto Reguero wrote:
> This patch init i2c in it930x_frontend_attach instead of it930x_tuner_attach.

This needs to describe why you are moving it. We can see in the patch
that you've moved it.

Something like "we need i2c to be available in it930x_frontend_attach() so
that .. in a later commit".

> 
> From: Andreas Kemnade <andreas@kemnade.info>

We need the original Signed-off-by from Andreas Kemnade here.

> Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com> 
> 
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2018-09-12 07:40:12.000000000 +0200
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-20 16:45:17.467869437 +0100
> @@ -1218,6 +1218,48 @@ static int it930x_frontend_attach(struct
>  
>  	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
>  
> +	/* I2C master bus 2 clock speed 300k */
> +	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* I2C master bus 1,3 clock speed 300k */
> +	ret = af9035_wr_reg(d, 0x00f103, 0x07);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* set gpio11 low */
> +	ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
> +	ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
> +	msleep(200);
> +
> +	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
> +	if (ret < 0)
> +		goto err;
> +
>  	memset(&si2168_config, 0, sizeof(si2168_config));
>  	si2168_config.i2c_adapter = &adapter;
>  	si2168_config.fe = &adap->fe[0];
> @@ -1575,48 +1617,6 @@ static int it930x_tuner_attach(struct dv
>  
>  	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
>  
> -	/* I2C master bus 2 clock speed 300k */
> -	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* I2C master bus 1,3 clock speed 300k */
> -	ret = af9035_wr_reg(d, 0x00f103, 0x07);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* set gpio11 low */
> -	ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
> -	ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
> -	msleep(200);
> -
> -	ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
> -	if (ret < 0)
> -		goto err;
> -
>  	memset(&si2157_config, 0, sizeof(si2157_config));
>  	si2157_config.fe = adap->fe[0];
>  	si2157_config.if_port = 1;
> 
> -- 
> Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.

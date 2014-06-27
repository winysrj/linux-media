Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:60255 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaF0Vny (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 17:43:54 -0400
Received: by mail-qg0-f50.google.com with SMTP id j5so34997qga.9
        for <linux-media@vger.kernel.org>; Fri, 27 Jun 2014 14:43:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403870714.2767.5.camel@madomr-fc.comexp.ru>
References: <1403870714.2767.5.camel@madomr-fc.comexp.ru>
Date: Fri, 27 Jun 2014 17:43:53 -0400
Message-ID: <CAGoCfixLOwkrrU2CuQ7n-0Fy41Mkxc026OV1Ut94WmseG7wr4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] xc5000: add product id of xc5000C
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mikhail Domrachev <mihail.domrychev@comexp.ru>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index 2b3d514..d1f539c 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -85,6 +85,7 @@ struct xc5000_priv {
>  /* Product id */
>  #define XC_PRODUCT_ID_FW_NOT_LOADED    0x2000
>  #define XC_PRODUCT_ID_FW_LOADED        0x1388
> +#define XC_PRODUCT_ID_FW_LOADED_5000C  0x14b4
>
>  /* Registers */
>  #define XREG_INIT         0x00
> @@ -1344,6 +1345,7 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
>
>         switch (id) {
>         case XC_PRODUCT_ID_FW_LOADED:
> +       case XC_PRODUCT_ID_FW_LOADED_5000C:
>                 printk(KERN_INFO
>                         "xc5000: Successfully identified at address 0x%02x\n",
>                         cfg->i2c_address);

What is the bridge which interfaces the xc5000?  The XC5000C typically
returns 0x1388 just like the xc5000.  It's much more likely that the
I2C bus is broken on the bridge driver (or the chip is in reset at
this stage), the I2C request is silently failing and you're getting
whatever happens to have been in the buffer.

NACK unless you can produce an I2C bus trace showing those bytes
coming back over the wire.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

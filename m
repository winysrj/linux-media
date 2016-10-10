Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:57220 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbcJJGeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:34:21 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 6D16220A28
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:34:19 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:34:14 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 22/26] technisat-usb2: use DMA buffers for I2C transfers
Message-ID: <20161010083414.1e191762@posteo.de>
In-Reply-To: <2792fc0fbd2bb0366c6967c60184c93fecc828c3.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <2792fc0fbd2bb0366c6967c60184c93fecc828c3.1475860773.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  7 Oct 2016 14:24:32 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
> 
> On this driver, most of the transfers are OK, but the I2C
> one was using stack.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/technisat-usb2.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c
> b/drivers/media/usb/dvb-usb/technisat-usb2.c index
> d9f3262bf071..4706628a3ed5 100644 ---
> a/drivers/media/usb/dvb-usb/technisat-usb2.c +++
> b/drivers/media/usb/dvb-usb/technisat-usb2.c @@ -89,9 +89,13 @@
> struct technisat_usb2_state { static int
> technisat_usb2_i2c_access(struct usb_device *udev, u8 device_addr, u8
> *tx, u8 txlen, u8 *rx, u8 rxlen) {
> -	u8 b[64];
> +	u8 *b;
>  	int ret, actual_length;
>  
> +	b = kmalloc(64, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> +
>  	deb_i2c("i2c-access: %02x, tx: ", device_addr);
>  	debug_dump(tx, txlen, deb_i2c);
>  	deb_i2c(" ");
> @@ -123,7 +127,7 @@ static int technisat_usb2_i2c_access(struct
> usb_device *udev, 
>  	if (ret < 0) {
>  		err("i2c-error: out failed %02x = %d", device_addr,
> ret);
> -		return -ENODEV;
> +		goto err;
>  	}
>  
>  	ret = usb_bulk_msg(udev,
> @@ -131,7 +135,7 @@ static int technisat_usb2_i2c_access(struct
> usb_device *udev, b, 64, &actual_length, 1000);
>  	if (ret < 0) {
>  		err("i2c-error: in failed %02x = %d", device_addr,
> ret);
> -		return -ENODEV;
> +		goto err;
>  	}
>  
>  	if (b[0] != I2C_STATUS_OK) {
> @@ -140,7 +144,7 @@ static int technisat_usb2_i2c_access(struct
> usb_device *udev, if (!(b[0] == I2C_STATUS_NAK &&
>  				device_addr == 0x60
>  				/* && device_is_technisat_usb2 */))
> -			return -ENODEV;
> +			goto err;
>  	}
>  
>  	deb_i2c("status: %d, ", b[0]);
> @@ -154,7 +158,9 @@ static int technisat_usb2_i2c_access(struct
> usb_device *udev, 
>  	deb_i2c("\n");
>  
> -	return 0;
> +err:
> +	kfree(b);
> +	return ret;
>  }
>  
>  static int technisat_usb2_i2c_xfer(struct i2c_adapter *adap, struct
> i2c_msg *msg,

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:35018 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932570AbeFTU2J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 16:28:09 -0400
Date: Wed, 20 Jun 2018 13:28:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Guenter Roeck <linux@roeck-us.net>, Crt Mori <cmo@melexis.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Lee Jones <lee.jones@linaro.org>,
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 03/10] input: rohm_bu21023: switch to
 i2c_lock_bus(..., I2C_LOCK_SEGMENT)
Message-ID: <20180620202805.GB75925@dtor-ws>
References: <20180620051803.12206-1-peda@axentia.se>
 <20180620051803.12206-4-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620051803.12206-4-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2018 at 07:17:56AM +0200, Peter Rosin wrote:
> Locking the root adapter for __i2c_transfer will deadlock if the
> device sits behind a mux-locked I2C mux. Switch to the finer-grained
> i2c_lock_bus with the I2C_LOCK_SEGMENT flag. If the device does not
> sit behind a mux-locked mux, the two locking variants are equivalent.
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>

Still

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Feel free to merge through I2C tree.

> ---
>  drivers/input/touchscreen/rohm_bu21023.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/rohm_bu21023.c b/drivers/input/touchscreen/rohm_bu21023.c
> index bda0500c9b57..714affdd742f 100644
> --- a/drivers/input/touchscreen/rohm_bu21023.c
> +++ b/drivers/input/touchscreen/rohm_bu21023.c
> @@ -304,7 +304,7 @@ static int rohm_i2c_burst_read(struct i2c_client *client, u8 start, void *buf,
>  	msg[1].len = len;
>  	msg[1].buf = buf;
>  
> -	i2c_lock_adapter(adap);
> +	i2c_lock_bus(adap, I2C_LOCK_SEGMENT);
>  
>  	for (i = 0; i < 2; i++) {
>  		if (__i2c_transfer(adap, &msg[i], 1) < 0) {
> @@ -313,7 +313,7 @@ static int rohm_i2c_burst_read(struct i2c_client *client, u8 start, void *buf,
>  		}
>  	}
>  
> -	i2c_unlock_adapter(adap);
> +	i2c_unlock_bus(adap, I2C_LOCK_SEGMENT);
>  
>  	return ret;
>  }
> -- 
> 2.11.0
> 

Thanks.

-- 
Dmitry

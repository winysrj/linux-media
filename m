Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33452 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbeGDHEg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 03:04:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id z6-v6so12239500wma.0
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 00:04:36 -0700 (PDT)
Date: Wed, 4 Jul 2018 08:04:32 +0100
From: Lee Jones <lee.jones@linaro.org>
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
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 09/10] mfd: 88pm860x-i2c: switch to i2c_lock_bus(...,
 I2C_LOCK_SEGMENT)
Message-ID: <20180704070432.GF20176@dell>
References: <20180620051803.12206-1-peda@axentia.se>
 <20180620051803.12206-10-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180620051803.12206-10-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jun 2018, Peter Rosin wrote:

> Locking the root adapter for __i2c_transfer will deadlock if the
> device sits behind a mux-locked I2C mux. Switch to the finer-grained
> i2c_lock_bus with the I2C_LOCK_SEGMENT flag. If the device does not
> sit behind a mux-locked mux, the two locking variants are equivalent.
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>  drivers/mfd/88pm860x-i2c.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

If Wolfram is happy with this, then I am.

Since this file sees few changes - please merge through the I2C tree.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

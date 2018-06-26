Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:9181 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965824AbeFZOL2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 10:11:28 -0400
Subject: Re: [PATCH v2 10/10] i2c: remove i2c_lock_adapter and use
 i2c_lock_bus directly
To: Peter Rosin <peda@axentia.se>, <linux-kernel@vger.kernel.org>
CC: Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
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
        Lee Jones <lee.jones@linaro.org>,
        <linux-integrity@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>
References: <20180620051803.12206-1-peda@axentia.se>
 <20180620051803.12206-11-peda@axentia.se>
From: Sekhar Nori <nsekhar@ti.com>
Message-ID: <4e0545e3-fee9-cf29-bae1-e442347e3cb8@ti.com>
Date: Tue, 26 Jun 2018 19:39:43 +0530
MIME-Version: 1.0
In-Reply-To: <20180620051803.12206-11-peda@axentia.se>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 20 June 2018 10:48 AM, Peter Rosin wrote:
> The i2c_lock_adapter name is ambiguous since it is unclear if it
> refers to the root adapter or the adapter you name in the argument.
> The natural interpretation is the adapter you name in the argument,
> but there are historical reasons for that not being the case; it
> in fact locks the root adapter. Just remove the function and force
> users to spell out the I2C_LOCK_ROOT_ADAPTER name to indicate what
> is really going on. Also remove i2c_unlock_adapter, of course.
> 
> This patch was generated with
> 
> git grep -l 'i2c_\(un\)\?lock_adapter' \
> | xargs sed -i 's/i2c_\(un\)\?lock_adapter(\([^)]*\))/'\
> 'i2c_\1lock_bus(\2, I2C_LOCK_ROOT_ADAPTER)/g'
> 
> followed by white-space touch-up.
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>  drivers/i2c/busses/i2c-brcmstb.c   |  8 ++++----
>  drivers/i2c/busses/i2c-davinci.c   |  4 ++--

On DM644x and DA850 EVMs applying this series does not seem to break I2C
functionality. So:

Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

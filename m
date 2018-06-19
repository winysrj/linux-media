Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr50127.outbound.protection.outlook.com ([40.107.5.127]:55107
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756803AbeFSVaE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 17:30:04 -0400
Subject: Re: [PATCH 01/11] i2c: add helpers for locking the I2C segment
To: Wolfram Sang <wsa@the-dreams.de>
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
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
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
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20180615101506.8012-1-peda@axentia.se>
 <20180615101506.8012-2-peda@axentia.se>
 <20180618110502.cb5s24srp4frahm6@ninjato>
 <b860025e-3d4b-f333-80b4-3831dd969757@axentia.se>
 <20180618115444.pgjmfntp767zuvmw@ninjato>
From: Peter Rosin <peda@axentia.se>
Message-ID: <4a721b58-d718-68c0-cca5-23b5b21ef100@axentia.se>
Date: Tue, 19 Jun 2018 23:29:51 +0200
MIME-Version: 1.0
In-Reply-To: <20180618115444.pgjmfntp767zuvmw@ninjato>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-18 13:54, Wolfram Sang wrote:
> 
>>> I wonder if i2c_lock_segment() and i2c_lock_root_adapter() are really
>>> more readable and convenient than i2c_lock_bus() with the flag. I think
>>> the flags have speaking names, too.
>>>
>>> Is that an idea to remove these functions altogether and start using
>>> i2c_lock_bus()?
>>
>> That would be fine with me. I don't have a strong opinion and agree that
>> both are readable enough...
>>
>> It would make for a reduction of the number of lines so that's nice, but
>> the macro in drivers/i2c/busses/i2c-gpio.c (patch 11) would not fit in
>> the current \-width (or whatever you'd call that line of backslashes to
>> the right in a multi-line macro).
>>
>> Does anyone have a strong opinion?
> 
> I have a strong opinion on making i2c.h less bloated. And yes, less
> number of lines is nice, too. I think that surely pays off the
> whitespace exception.

Ok, I have rebased onto v4.18-rc1, killed the i2c-tegra hunk and converted
i2c_lock_root(foo) over to i2c_lock_bus(foo, I2C_LOCK_ROOT_ADAPTER) and
i2c_lock_segment(foo) over to i2c_lock_bus(foo, I2C_LOCK_SEGMENT). And I
of course killed a bunch of locking helpers in i2c.h.

I doing build tests now, will post a v2 in the morning.

Cheers,
Peter

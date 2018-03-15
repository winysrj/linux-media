Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44166 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbeCOFc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 01:32:57 -0400
Date: Thu, 15 Mar 2018 06:32:38 +0100
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux@roeck-us.net, corbet@lwn.net,
        tj@kernel.org, gregkh@linuxfoundation.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, bp@alien8.de, mchehab@kernel.org,
        linus.walleij@linaro.org, wsa@the-dreams.de,
        dmitry.torokhov@gmail.com, ulf.hansson@linaro.org,
        cyrille.pitchen@wedev4u.fr, wg@grandegger.com, mkl@pengutronix.de,
        alexandre.belloni@bootlin.com, broonie@kernel.org,
        jic23@kernel.org, lars@metafoo.de, jslaby@suse.com,
        stern@rowland.harvard.edu, b.zolnierkie@samsung.com,
        shli@kernel.org, linux-watchdog@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-raid@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/47] arch-removal: device drivers
Message-ID: <20180315063238.3303b8d1@bbrezillon>
In-Reply-To: <20180314153603.3127932-1-arnd@arndb.de>
References: <20180314153603.3127932-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, 14 Mar 2018 16:35:13 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> Hi driver maintainers,
> 
> I just posted one series with the removal of eight architectures,
> see https://lkml.org/lkml/2018/3/14/505 for details, or
> https://lwn.net/Articles/748074/ for more background.
> 
> These are the device drivers that go along with them. I have already
> picked up the drivers for arch/metag/ into my tree, they were reviewed
> earlier.
> 
> Please let me know if you have any concerns with the patch, or if you
> prefer to pick up the patches in your respective trees.  I created
> the patches with 'git format-patch -D', so they will not apply without
> manually removing those files.
> 
> For anything else, I'd keep the removal patches in my asm-generic tree
> and will send a pull request for 4.17 along with the actual arch removal.
> 
>        Arnd
> 
> Arnd Bergmann
>   edac: remove tile driver
>   net: tile: remove ethernet drivers
>   net: adi: remove blackfin ethernet drivers
>   net: 8390: remove m32r specific bits
>   net: remove cris etrax ethernet driver
>   net: smsc: remove m32r specific smc91x configuration
>   raid: remove tile specific raid6 implementation
>   rtc: remove tile driver
>   rtc: remove bfin driver
>   char: remove obsolete ds1302 rtc driver
>   char: remove tile-srom.c
>   char: remove blackfin OTP driver
>   pcmcia: remove m32r drivers
>   pcmcia: remove blackfin driver
>   ASoC: remove blackfin drivers
>   video/logo: remove obsolete logo files
>   fbdev: remove blackfin drivers
>   fbdev: s1d13xxxfb: remove m32r specific hacks
>   crypto: remove blackfin CRC driver
>   media: platform: remove blackfin capture driver
>   media: platform: remove m32r specific arv driver
>   cpufreq: remove blackfin driver
>   cpufreq: remove cris specific drivers
>   gpio: remove etraxfs driver
>   pinctrl: remove adi2/blackfin drivers
>   ata: remove bf54x driver
>   input: keyboard: remove bf54x driver
>   input: misc: remove blackfin rotary driver
>   mmc: remove bfin_sdh driver
>   can: remove bfin_can driver
>   watchdog: remove bfin_wdt driver
>   mtd: maps: remove bfin-async-flash driver
>   mtd: nand: remove bf5xx_nand driver

If you don't mind, I'd like to take the mtd patches through the MTD
tree. As you've probably noticed, nand code has been moved around and
it's easier for me to carry those 2 simple changes in my tree than
creating an immutable branch.

Let me know if this is a problem.

Regards,

Boris

-- 
Boris Brezillon, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

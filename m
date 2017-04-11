Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr30090.outbound.protection.outlook.com ([40.107.3.90]:26592
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752010AbdDKII2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 04:08:28 -0400
Subject: Re: [PATCH 0/9] Unify i2c_mux_add_adapter error reporting
To: <linux-kernel@vger.kernel.org>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-media@vger.kernel.org>
From: Peter Rosin <peda@axentia.se>
Message-ID: <5f70e59b-f832-f123-6901-ab89b45e7d70@axentia.se>
Date: Tue, 11 Apr 2017 10:08:21 +0200
MIME-Version: 1.0
In-Reply-To: <1491208718-32068-1-git-send-email-peda@axentia.se>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-04-03 10:38, Peter Rosin wrote:
> Hi!
> 
> Many users of the i2c_mux_add_adapter interface log a message
> on failure, but the function already logs such a message. One
> or two of those users actually add more information than already
> provided by the central failure message.
> 
> So, first fix the central error reporting to provide as much
> information as any current user, and then remove the surplus
> error reporting at the call sites.

I have now pushed patches 1-7 to i2c-mux/for-next.
Jonathan grabbed patch 8 and it's going through the iio tree.
Still waiting on patch 9 and the media maintainers.

Cheers,
Peter

> 
> Cheers,
> peda
> 
> Peter Rosin (9):
>   i2c: mux: provide more info on failure in i2c_mux_add_adapter
>   i2c: arb: gpio-challenge: stop double error reporting
>   i2c: mux: gpio: stop double error reporting
>   i2c: mux: pca9541: stop double error reporting
>   i2c: mux: pca954x: stop double error reporting
>   i2c: mux: pinctrl: stop double error reporting
>   i2c: mux: reg: stop double error reporting
>   iio: gyro: mpu3050: stop double error reporting
>   [media] cx231xx: stop double error reporting
> 
>  drivers/i2c/i2c-mux.c                      |  9 ++++++---
>  drivers/i2c/muxes/i2c-arb-gpio-challenge.c |  4 +---
>  drivers/i2c/muxes/i2c-mux-gpio.c           |  4 +---
>  drivers/i2c/muxes/i2c-mux-pca9541.c        |  4 +---
>  drivers/i2c/muxes/i2c-mux-pca954x.c        |  7 +------
>  drivers/i2c/muxes/i2c-mux-pinctrl.c        |  4 +---
>  drivers/i2c/muxes/i2c-mux-reg.c            |  4 +---
>  drivers/iio/gyro/mpu3050-i2c.c             |  5 ++---
>  drivers/media/usb/cx231xx/cx231xx-i2c.c    | 15 ++++-----------
>  9 files changed, 18 insertions(+), 38 deletions(-)
> 

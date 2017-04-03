Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0096.outbound.protection.outlook.com ([104.47.0.96]:31631
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751993AbdDCIhD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:37:03 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
Subject: [PATCH 0/9] Unify i2c_mux_add_adapter error reporting
Date: Mon, 3 Apr 2017 10:38:29 +0200
Message-ID: <1491208718-32068-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Many users of the i2c_mux_add_adapter interface log a message
on failure, but the function already logs such a message. One
or two of those users actually add more information than already
provided by the central failure message.

So, first fix the central error reporting to provide as much
information as any current user, and then remove the surplus
error reporting at the call sites.

Cheers,
peda

Peter Rosin (9):
  i2c: mux: provide more info on failure in i2c_mux_add_adapter
  i2c: arb: gpio-challenge: stop double error reporting
  i2c: mux: gpio: stop double error reporting
  i2c: mux: pca9541: stop double error reporting
  i2c: mux: pca954x: stop double error reporting
  i2c: mux: pinctrl: stop double error reporting
  i2c: mux: reg: stop double error reporting
  iio: gyro: mpu3050: stop double error reporting
  [media] cx231xx: stop double error reporting

 drivers/i2c/i2c-mux.c                      |  9 ++++++---
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c |  4 +---
 drivers/i2c/muxes/i2c-mux-gpio.c           |  4 +---
 drivers/i2c/muxes/i2c-mux-pca9541.c        |  4 +---
 drivers/i2c/muxes/i2c-mux-pca954x.c        |  7 +------
 drivers/i2c/muxes/i2c-mux-pinctrl.c        |  4 +---
 drivers/i2c/muxes/i2c-mux-reg.c            |  4 +---
 drivers/iio/gyro/mpu3050-i2c.c             |  5 ++---
 drivers/media/usb/cx231xx/cx231xx-i2c.c    | 15 ++++-----------
 9 files changed, 18 insertions(+), 38 deletions(-)

-- 
2.1.4

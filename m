Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve1eur01on0112.outbound.protection.outlook.com ([104.47.1.112]:15593
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753879AbeFTFSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 01:18:20 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Peter Huewe <peterhuewe@gmx.de>,
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
        Lee Jones <lee.jones@linaro.org>,
        linux-integrity@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 00/10] Split i2c_lock_adapter into i2c_lock_root and i2c_lock_segment
Date: Wed, 20 Jun 2018 07:17:53 +0200
Message-Id: <20180620051803.12206-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

With the introduction of mux-locked I2C muxes, the concept of
locking only a segment of the I2C adapter tree was added. At the
time, I did not want to cause a lot of extra churn, so left most
users of i2c_lock_adapter alone and apparently didn't think enough
about it; they simply continued to lock the whole adapter tree.
However, i2c_lock_adapter is in fact wrong for almost every caller
(there is naturally an exception) that is itself not a driver for
a root adapter. What normal drivers generally want is to only
lock the segment of the adapter tree that their device sits on.

In fact, if a device sits behind a mux-locked I2C mux, and its
driver calls i2c_lock_adapter followed by an unlocked I2C transfer,
things will deadlock (since even a mux-locked I2C adapter will lock
its parent at some point). If the device is not sitting behind a
mux-locked I2C mux (i.e. either directly on the root adapter or
behind a (chain of) parent-locked I2C muxes) the root/segment
distinction is of no consequence; the root adapter is locked either
way.

Mux-locked I2C muxes are probably not that common, and putting any
of the affected devices behind one is probably even rarer, which
is why we have not seen any deadlocks. At least not that I know
of...

Since silently changing the semantics of i2c_lock_adapter might
be quite a surprise, especially for out-of-tree users, this series
instead removes the function and forces all users to explicitly
name I2C_LOCK_SEGMENT or I2C_LOCK_ROOT_ADAPTER in a call to
i2c_lock_bus, as suggested by Wolfram. Yes, users will be a teensy
bit more wordy, but open-coding I2C locking from random drivers
should be avoided, so it's perhaps a good thing if it doesn't look
too neat?

I suggest that Wolfram takes this series through the I2C tree and
creates an immutable branch for the other subsystems. The series
is based on v4.18-r1.

I do not have *any* of the affected devices, and have thus only
done build tests.

Cheers,
Peter

PS. for more background on mux-locked vs. parent-locked etc, see
Documentation/i2c/i2c-topology

Changes since v1:
- rebased to v4.18-rc1, thus removing the i2c-tegra hunk from
  the last patch
- Not adding i2c_lock_segment (et al) and remove i2c_lock_adapter
  instead of renaming it to i2c_lock_root, since having 8 closely
  related inline locking functions in include/linux/i2c.h was
  a few too many. I.e., instead going from 5 to 8, we are now
  going from 5 to 3.

Peter Rosin (10):
  tpm/tpm_i2c_infineon: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  i2c: mux: pca9541: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  input: rohm_bu21023: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  media: af9013: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  media: drxk_hard: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  media: rtl2830: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  media: tda1004x: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  media: tda18271: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  mfd: 88pm860x-i2c: switch to i2c_lock_bus(..., I2C_LOCK_SEGMENT)
  i2c: remove i2c_lock_adapter and use i2c_lock_bus directly

 drivers/char/tpm/tpm_i2c_infineon.c      |  8 +++----
 drivers/i2c/busses/i2c-brcmstb.c         |  8 +++----
 drivers/i2c/busses/i2c-davinci.c         |  4 ++--
 drivers/i2c/busses/i2c-gpio.c            | 40 ++++++++++++++++----------------
 drivers/i2c/busses/i2c-s3c2410.c         |  4 ++--
 drivers/i2c/busses/i2c-sprd.c            |  8 +++----
 drivers/i2c/i2c-core-slave.c             |  8 +++----
 drivers/i2c/muxes/i2c-mux-pca9541.c      |  6 ++---
 drivers/iio/temperature/mlx90614.c       |  4 ++--
 drivers/input/touchscreen/rohm_bu21023.c |  4 ++--
 drivers/media/dvb-frontends/af9013.c     |  8 +++----
 drivers/media/dvb-frontends/drxk_hard.c  |  4 ++--
 drivers/media/dvb-frontends/rtl2830.c    | 12 +++++-----
 drivers/media/dvb-frontends/tda1004x.c   |  6 ++---
 drivers/media/tuners/tda18271-common.c   |  8 +++----
 drivers/mfd/88pm860x-i2c.c               |  8 +++----
 include/linux/i2c.h                      | 12 ----------
 17 files changed, 70 insertions(+), 82 deletions(-)

-- 
2.11.0

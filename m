Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0122.outbound.protection.outlook.com ([104.47.2.122]:4422
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934900AbeFOKPh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 06:15:37 -0400
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
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
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
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 00/11] Split i2c_lock_adapter into i2c_lock_root and i2c_lock_segment
Date: Fri, 15 Jun 2018 12:14:55 +0200
Message-Id: <20180615101506.8012-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

With the introduction of mux-locked I2C muxes, the concept of
locking only a segment of the I2C adapter tree was added. At the
time, I did not want to cause a lot of extra churn, so left most
users of i2c_lock_adapter alone and aparently didn't think enough
about it; they simply continued to lock the whole adapter tree.
However, i2c_lock_adapter is in fact wrong for almost every caller
(there are naturally exceptions) that is itself not a driver for
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
be quite a surprise, especially for out-of-tree users, this
series instead introduces new helpers to make it easier to only
lock the I2C segment, then converts drivers over and finally
renames the remaining i2c_lock_adapter instances to i2c_lock_root.

I suggest that Wolfram takes this series through the I2C tree
and creates an immutable branch for the other subsystems. The
series is based on v4.17, but I did not find any new instances in
neither linus-master nor linux-next and the series still applies
cleanly to linus-master for me. linux-next has removed suspend
support from the i2c-tegra driver. A bit strange, I thought the
I2C changes was merged for this window? Anyway, the resolution
for that conflict is trivial, just remove the i2c-tegra hunk from
patch 11.

I do not have *any* of the affected devices, and have thus only
done build tests.

Cheers,
Peter

Peter Rosin (11):
  i2c: add helpers for locking the I2C segment
  tpm/tpm_i2c_infineon: switch to i2c_lock_segment
  i2c: mux: pca9541: switch to i2c_lock_segment
  input: rohm_bu21023: switch to i2c_lock_segment
  media: af9013: switch to i2c_lock_segment
  media: drxk_hard: switch to i2c_lock_segment
  media: rtl2830: switch to i2c_lock_segment
  media: tda1004x: switch to i2c_lock_segment
  media: tda18271: switch to i2c_lock_segment
  mfd: 88pm860x-i2c: switch to i2c_lock_segment
  i2c: rename i2c_lock_adapter to i2c_lock_root

 drivers/char/tpm/tpm_i2c_infineon.c      |  8 ++++----
 drivers/i2c/busses/i2c-brcmstb.c         |  8 ++++----
 drivers/i2c/busses/i2c-davinci.c         |  4 ++--
 drivers/i2c/busses/i2c-gpio.c            | 12 ++++++------
 drivers/i2c/busses/i2c-s3c2410.c         |  4 ++--
 drivers/i2c/busses/i2c-sprd.c            |  8 ++++----
 drivers/i2c/busses/i2c-tegra.c           |  8 ++++----
 drivers/i2c/i2c-core-base.c              |  6 +++---
 drivers/i2c/i2c-core-slave.c             |  8 ++++----
 drivers/i2c/i2c-core-smbus.c             |  4 ++--
 drivers/i2c/muxes/i2c-mux-pca9541.c      |  6 +++---
 drivers/iio/temperature/mlx90614.c       |  4 ++--
 drivers/input/touchscreen/rohm_bu21023.c |  4 ++--
 drivers/media/dvb-frontends/af9013.c     |  8 ++++----
 drivers/media/dvb-frontends/drxk_hard.c  |  4 ++--
 drivers/media/dvb-frontends/rtl2830.c    | 12 ++++++------
 drivers/media/dvb-frontends/tda1004x.c   |  6 +++---
 drivers/media/tuners/tda18271-common.c   |  8 ++++----
 drivers/mfd/88pm860x-i2c.c               |  8 ++++----
 include/linux/i2c.h                      | 22 ++++++++++++++++++++--
 20 files changed, 85 insertions(+), 67 deletions(-)

-- 
2.11.0

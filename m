Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:45067 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbcCCW1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:27:50 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v4 00/18] i2c mux cleanup and locking update
Date: Thu,  3 Mar 2016 23:27:12 +0100
Message-Id: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Hi!

I have a pair of boards with this i2c topology:

                       GPIO ---|  ------ BAT1
                        |      v /
   I2C  -----+------B---+---- MUX
             |                   \
           EEPROM                 ------ BAT2

	(B denotes the boundary between the boards)

The problem with this is that the GPIO controller sits on the same i2c bus
that it MUXes. For pca954x devices this is worked around by using unlocked
transfers when updating the MUX. I have no such luck as the GPIO is a general
purpose IO expander and the MUX is just a random bidirectional MUX, unaware
of the fact that it is muxing an i2c bus. Extending unlocked transfers
into the GPIO subsystem is too ugly to even think about. But the general hw
approach is sane in my opinion, with the number of connections between the
two boards minimized. To put is plainly, I need support for it.

So, I observe that while it is needed to have the i2c bus locked during the
actual MUX update in order to avoid random garbage on the slave side, it
is not strictly a must to have it locked over the whole sequence of a full
select-transfer-deselect operation. The MUX itself needs to be locked, so
transfers to clients behind the mux are serialized, and the MUX needs to be
stable during all i2c traffic (otherwise individual mux slave segments
might see garbage).

This series accomplishes this by adding code to i2c-mux-gpio and
i2c-mux-pinctrl that determines if all involved devices used to update the
mux are controlled by the same root i2c adapter that is muxed. When this
is the case, the select-transfer-deselect operations should be locked
individually to avoid the deadlock. The i2c bus *is* still locked
during muxing, since the muxing happens as part of i2c transfers. This
is true even if the MUX is updated with several transfers to the GPIO (at
least as long as *all* MUX changes are using the i2c master bus). A lock
is added to the mux so that transfers through the mux are serialized.

Concerns:
- The locking is perhaps too complex?
- I worry about the priority inheritance aspect of the adapter lock. When
  the transfers behind the mux are divided into select-transfer-deselect all
  locked individually, low priority transfers get more chances to interfere
  with high priority transfers. But there is no risk for regressions, since
  it did not work at all previously.
- When doing an i2c_transfer() in_atomic() context or with irqs_disabled(),
  there is a higher possibility that the mux is not returned to its idle
  state after a failed (-EAGAIN) transfer due to trylock. Again, no risk
  for regressions.
- Is the detection of i2c-controlled gpios and pinctrls sane (i.e. the
  usage of the new i2c_root_adapter() function in 18/18)?

To summarize the series, there's some i2c-mux infrastructure cleanup work
first (I think that part stands by itself as desireable regardless), the
locking changes are in the last three patches of the series, with the real
meat in 18/18.

PS. needs a bunch of testing, I do not have access to all the involved hw

v4 compared to v3:
- Rebase on top of v4.5-rc6.
- Update to add new i2c-mux interfaces in 01/18 including glue to implement
  the old interfaces in terms of the new interfaces, then change the
  mux users over to the new interfaces one by one (in 02/18 through 14/18),
  and finally removing the old interfaces in 15/18. I.e. the first 15
  patches of v4 replaces the first 5 patches of v3, with the following
  points describing changes in the end result. Each patch is now touching
  only one subsystem.
- Rename i2c_add_mux_adapter and i2c_del_mux_adapters to i2c_mux_add_adapter
  and i2c_mux_del_adapters (so that the old functions can live on during the
  transition).
- Make i2c_mux_alloc take a parent and the select/deselect ops as
  arguments. Also add a flags argument to prevent churn later on.
- Add a new interface i2c_mux_one_adapter(). Make use of it in suitable
  mux users with a single child adapter.
- Adjust to a rename in struct gpio_chip.
- Update a couple of comments to match the new code.

v3 compared to v2:
- Fix devm_kfree of a NULL pointer in i2c_mux_reserve_adapters().
- Remove device tree "i2c-controlled" property and determine this by walking
  the dev tree instead.
- Fix compile problems with inv_mpu_acpi.c
- Wait with adding the client pointer to patch 2/8 for pca9541 and pca954x.

v2 compared to v1:
- Allocate mux core and (optional) priv in a combined allocation.
- Kill dev_err messages triggered by memory allocation failure.
- Fix the device specific i2c muxes that I had overlooked.
- Rebase on top of v4.4-rc8 (was based on v4.4-rc6 previously).
- Drop the last two patches in the series.

Cheers,
Peter

Peter Rosin (18):
  i2c-mux: add common data for every i2c-mux instance
  i2c: i2c-mux-gpio: convert to use an explicit i2c mux core
  i2c: i2c-mux-pinctrl: convert to use an explicit i2c mux core
  i2c: i2c-arb-gpio-challenge: convert to use an explicit i2c mux core
  i2c: i2c-mux-pca9541: convert to use an explicit i2c mux core
  i2c: i2c-mux-pca954x: convert to use an explicit i2c mux core
  i2c: i2c-mux-reg: convert to use an explicit i2c mux core
  iio: imu: inv_mpu6050: convert to use an explicit i2c mux core
  [media] m88ds3103: convert to use an explicit i2c mux core
  [media] rtl2830: convert to use an explicit i2c mux core
  [media] rtl2832: convert to use an explicit i2c mux core
  [media] si2168: convert to use an explicit i2c mux core
  [media] cx231xx: convert to use an explicit i2c mux core
  of/unittest: convert to use an explicit i2c mux core
  i2c-mux: drop old unused i2c-mux api
  i2c: allow adapter drivers to override the adapter locking
  i2c: muxes always lock the parent adapter
  i2c-mux: relax locking of the top i2c adapter during i2c controlled
    muxing

 drivers/i2c/i2c-core.c                       |  59 ++---
 drivers/i2c/i2c-mux.c                        | 338 ++++++++++++++++++++++-----
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c   |  47 ++--
 drivers/i2c/muxes/i2c-mux-gpio.c             |  73 +++---
 drivers/i2c/muxes/i2c-mux-pca9541.c          |  55 ++---
 drivers/i2c/muxes/i2c-mux-pca954x.c          |  64 ++---
 drivers/i2c/muxes/i2c-mux-pinctrl.c          | 125 +++++-----
 drivers/i2c/muxes/i2c-mux-reg.c              |  63 ++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c   |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   |  30 ++-
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |   3 +-
 drivers/media/dvb-frontends/m88ds3103.c      |  18 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   2 +-
 drivers/media/dvb-frontends/rtl2830.c        |  17 +-
 drivers/media/dvb-frontends/rtl2830_priv.h   |   2 +-
 drivers/media/dvb-frontends/rtl2832.c        |  22 +-
 drivers/media/dvb-frontends/rtl2832_priv.h   |   2 +-
 drivers/media/dvb-frontends/si2168.c         |  22 +-
 drivers/media/dvb-frontends/si2168_priv.h    |   2 +-
 drivers/media/usb/cx231xx/cx231xx-core.c     |   6 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c      |  47 ++--
 drivers/media/usb/cx231xx/cx231xx.h          |   4 +-
 drivers/of/unittest.c                        |  40 ++--
 include/linux/i2c-mux.h                      |  65 ++++--
 include/linux/i2c.h                          |  28 ++-
 25 files changed, 703 insertions(+), 433 deletions(-)

-- 
2.1.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:46760 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbcDCIxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:53:19 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v6 00/24] i2c mux cleanup and locking update
Date: Sun,  3 Apr 2016 10:52:30 +0200
Message-Id: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
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
two boards minimized. To put it plainly, I need support for it.

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
is added to i2c adapters that muxes on that adapter grab, so that transfers
through the muxes are serialized.

Concerns:
- The locking is perhaps too complex?
- I worry about the priority inheritance aspect of the adapter lock. When
  the transfers behind the mux are divided into select-transfer-deselect all
  locked individually, low priority transfers get more chances to interfere
  with high priority transfers.
- When doing an i2c_transfer() in_atomic() context or with irqs_disabled(),
  there is a higher possibility that the mux is not returned to its idle
  state after a failed (-EAGAIN) transfer due to trylock.
- Is the detection of i2c-controlled gpios and pinctrls sane (i.e. the
  usage of the new i2c_root_adapter() function in 18/24)?

To summarize the series, there's some i2c-mux infrastructure cleanup work
first (I think that part stands by itself as desireable regardless), the
locking changes are in 16/24 and after with the real meat in 18/24. There
is some documentation added in 19/24 while 20/24 and after are cleanups to
existing drivers utilizing the new stuff.

PS. needs a bunch of testing, I do not have access to all the involved hw.

Specifically, thank you Antti for testing v5, but I did not add any
Tested-by for v6 since I moved the lock from the mux itself to the mux
parent adapter. I did this to cope with the situation I described in
    http://marc.info/?l=linux-i2c&m=145875234525803&w=2
thus making it possible to get rid of the unlocked accesses in the
si2168 driver (patch 21/24). I also didn't add any Reviewed-by for
the parts of the rtl2832 driver changes that suffered the most from
driver updates since v4.5-rc7, so please review that again as well.

This series can also be pulled from github, if that is preferred:

---------------------
The following changes since commit f55532a0c0b8bb6148f4e07853b876ef73bc69ca:

  Linux 4.6-rc1 (2016-03-26 16:03:24 -0700)

are available in the git repository at:

  https://github.com/peda-r/i2c-mux.git mux-core-and-locking-6

for you to fetch changes up to 81830e43de2bc849848b939166103217ac444df5:

  [media] rtl2832: regmap is aware of lockdep, drop local locking hack (2016-04-03 09:35:52 +0200)
---------------------

v6 compared to v5:
- Rebase on top of v4.6-rc1
- Adjust to gpio subsystem overhaul.
- Adjust to changes in the inv_mpu6050 driver.
- Adjust to changes in the rtl2832 driver.
- Fix some new trivial checkpatch issues.
- Rename "self-locked" muxes "mux-locked" instead, since the lock has
  been moved to the parent adapter and is common for all muxes with
  the same parent adapter. The advantage is that address collisions
  behind sibling muxes are handled. Parent-locked muxes also grab this
  new mux-lock so that parent-locked and mux-locked siblings interact
  better.
- Firmware mutex added to the si2168 driver.

v5 compared to v4 (only published as a git branch):
- Rebase on top of v4.5-rc7.
- A new patch making me maintainer of i2c muxes (also sent separately).
- A new file Documentation/i2c/i2c-topology that describes various muxing
  issues.
- Rename "i2c-controlled" muxes "self-locked" instead, as it is perfectly
  reasonable to have i2c-controlled muxes that use the pre-existing locking
  scheme. The pre-existing locking scheme for i2c muxes is from here on
  called "parent-locked".
- Rename i2c-mux.c:i2c_mux_master_xfer to __i2c_mux_master_xfer since it
  calls __i2c_transfer, which leaves room for a new i2c_mux_master_xfer
  that calls i2c_transfer. Similar rename shuffle for i2c_mux_smbus_xfer.
- Use sizeof(*priv) instead of sizeof(struct i2c_mux_priv). One instance.
- Some follow-up patches that were posted in response to v2-v4 cleaning up
  and simplifying various i2c muxes outside drivers/i2c/, among those is
  an unrelated cleanup patch to drivers/media/dvb-frontends/rtl2832.c that
  I carry here since it conflicts (trivially) with this series. That
  unrelated patch is (currently) the last patch in the series.

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

Antti Palosaari (1):
  [media] si2168: change the i2c gate to be mux-locked

Peter Rosin (23):
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
  i2c-mux: relax locking of the top i2c adapter during mux-locked muxing
  i2c-mux: document i2c muxes and elaborate on parent-/mux-locked muxes
  iio: imu: inv_mpu6050: change the i2c gate to be mux-locked
  [media] rtl2832: change the i2c gate to be mux-locked
  [media] rtl2832_sdr: get rid of empty regmap wrappers
  [media] rtl2832: regmap is aware of lockdep, drop local locking hack

 Documentation/i2c/i2c-topology               | 370 +++++++++++++++++++++++++++
 MAINTAINERS                                  |   1 +
 drivers/i2c/i2c-core.c                       |  66 +++--
 drivers/i2c/i2c-mux.c                        | 350 ++++++++++++++++++++-----
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c   |  47 ++--
 drivers/i2c/muxes/i2c-mux-gpio.c             |  72 +++---
 drivers/i2c/muxes/i2c-mux-pca9541.c          |  55 ++--
 drivers/i2c/muxes/i2c-mux-pca954x.c          |  64 ++---
 drivers/i2c/muxes/i2c-mux-pinctrl.c          | 124 +++++----
 drivers/i2c/muxes/i2c-mux-reg.c              |  63 ++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c   |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   |   1 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c    |  78 ++----
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |   3 +-
 drivers/media/dvb-frontends/m88ds3103.c      |  18 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   2 +-
 drivers/media/dvb-frontends/rtl2830.c        |  17 +-
 drivers/media/dvb-frontends/rtl2830_priv.h   |   2 +-
 drivers/media/dvb-frontends/rtl2832.c        | 241 +++--------------
 drivers/media/dvb-frontends/rtl2832.h        |   4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h   |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c    | 303 ++++++++++------------
 drivers/media/dvb-frontends/rtl2832_sdr.h    |   5 +-
 drivers/media/dvb-frontends/si2168.c         | 103 +++-----
 drivers/media/dvb-frontends/si2168_priv.h    |   3 +-
 drivers/media/usb/cx231xx/cx231xx-core.c     |   6 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c      |  47 ++--
 drivers/media/usb/cx231xx/cx231xx.h          |   4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |   5 +-
 drivers/of/unittest.c                        |  40 ++-
 include/linux/i2c-mux.h                      |  64 ++++-
 include/linux/i2c.h                          |  29 ++-
 32 files changed, 1277 insertions(+), 915 deletions(-)
 create mode 100644 Documentation/i2c/i2c-topology

-- 
2.1.4


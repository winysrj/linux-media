Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0097.outbound.protection.outlook.com ([104.47.2.97]:51128
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545AbcEDUQG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 16:16:06 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH v9 0/9] i2c mux cleanup and locking update
Date: Wed, 4 May 2016 22:15:26 +0200
Message-ID: <1462392935-28011-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

The first half (patches 01-15 in v7) of what was originally part of this
series have already been scheduled for 4.6. So, this is the second half
(patches 16-24 in v7, patches 1-9 in v9).

To summarize the series, there is some preparatory locking changes in
in 1/9 and the real meat is in 3/9. There is some documentation added in
4/9 while 5/9 and after are cleanups to existing drivers utilizing
the new stuff.

PS. needs a bunch of testing, I do not have access to all the involved hw.

This second half of the series is planned to be merged with 4.7 and can
also be pulled from github, if that is preferred:

---------------------
The following changes since commit b3b85922534861445a24f48f1d6125a99c6f3aa2:

  Merge branch 'i2c/for-4.7' into i2c/for-next (2016-04-27 19:11:32 +0200)

are available in the git repository at:

  https://github.com/peda-r/i2c-mux.git mux-core-and-locking-9

for you to fetch changes up to ce3cf4098f0bb41fa9fc9a87bb5d4d64ec90074f:

  [media] rtl2832: regmap is aware of lockdep, drop local locking hack (2016-05-04 21:05:53 +0200)
---------------------

v9 compared to v8:
- Drop patches 01-15, since they are in the pipe anyway.
- Change the name of the I2C_LOCK_ADAPTER flag to I2C_LOCK_ROOT_ADAPTER.
- Do not change the locking in i2c_slave_register and i2c_slave_unregister.
  That cannot possibly work for muxes anyway, so the changes were somewhere
  between pointless and silly.
- The the BIT macro to specify bits for flags.
- Add kerneldoc for i2c_lock_bus and i2c_unlock_bus.
- Add some comments in i2c_mux_trylock_bus and i2c_parent_trylock_bus.
- Use true instead of 1 for a bool variable.
- Whitespace issues fixed as indicated by --strict checkpatching.
- Updated commit message for the first patch.

v8 compared to v7:
- Do not change i2c_get_clientdata() into dev_get_drvdata() in the mpu6050
  driver.

v7 compared to v6:
- Removed i2c_mux_reserve_adapters, and all realloc attempts in
  i2c_mux_add_adapter. Supply a maximum number of adapters in i2c_mux_alloc
  instead.
- Removed i2c_mux_one_adapter since it is was hard to use correctly, which
  was evident from the crash in the mpu6050 driver (on a mpu9150 chip) reported
  by Crestez Dan Leonard. Also, it didn't make things all that much simpler
  anyway (even if used correctly).
- Rename i2c_mux_core:adapters into i2c_mux_core:num_adapters.
- Some grammar and spelling fixes.

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

Peter Rosin (8):
  i2c: allow adapter drivers to override the adapter locking
  i2c: muxes always lock the parent adapter
  i2c-mux: relax locking of the top i2c adapter during mux-locked muxing
  i2c-mux: document i2c muxes and elaborate on parent-/mux-locked muxes
  iio: imu: inv_mpu6050: change the i2c gate to be mux-locked
  [media] rtl2832: change the i2c gate to be mux-locked
  [media] rtl2832_sdr: get rid of empty regmap wrappers
  [media] rtl2832: regmap is aware of lockdep, drop local locking hack

 Documentation/i2c/i2c-topology             | 370 +++++++++++++++++++++++++++++
 MAINTAINERS                                |   1 +
 drivers/i2c/i2c-core.c                     |  61 +++--
 drivers/i2c/i2c-mux.c                      | 170 ++++++++++++-
 drivers/i2c/muxes/i2c-mux-gpio.c           |  18 ++
 drivers/i2c/muxes/i2c-mux-pinctrl.c        |  38 +++
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c  |  52 +---
 drivers/media/dvb-frontends/rtl2832.c      | 220 ++---------------
 drivers/media/dvb-frontends/rtl2832.h      |   4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h |   1 -
 drivers/media/dvb-frontends/rtl2832_sdr.c  | 303 +++++++++++------------
 drivers/media/dvb-frontends/rtl2832_sdr.h  |   5 +-
 drivers/media/dvb-frontends/si2168.c       |  83 ++-----
 drivers/media/dvb-frontends/si2168_priv.h  |   1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |   5 +-
 include/linux/i2c-mux.h                    |   8 +
 include/linux/i2c.h                        |  45 +++-
 17 files changed, 864 insertions(+), 521 deletions(-)
 create mode 100644 Documentation/i2c/i2c-topology

-- 
2.1.4


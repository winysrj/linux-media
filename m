Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:59589 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbcCOOJ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 10:09:59 -0400
Message-ID: <56E817AE.2090005@lysator.liu.se>
Date: Tue, 15 Mar 2016 15:09:50 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 00/18] i2c mux cleanup and locking update
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 2016-03-03 23:27, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
> 
> Hi!
> 
> I have a pair of boards with this i2c topology:
> 
>                        GPIO ---|  ------ BAT1
>                         |      v /
>    I2C  -----+------B---+---- MUX
>              |                   \
>            EEPROM                 ------ BAT2
> 
> 	(B denotes the boundary between the boards)
> 
> The problem with this is that the GPIO controller sits on the same i2c bus
> that it MUXes. For pca954x devices this is worked around by using unlocked
> transfers when updating the MUX. I have no such luck as the GPIO is a general
> purpose IO expander and the MUX is just a random bidirectional MUX, unaware
> of the fact that it is muxing an i2c bus. Extending unlocked transfers
> into the GPIO subsystem is too ugly to even think about. But the general hw
> approach is sane in my opinion, with the number of connections between the
> two boards minimized. To put is plainly, I need support for it.

etc etc

I've made a few changes, but instead of posting another copy of a rather long
series, I decided to push it to github and only post a note about it here. The
plan is to then rebase (if needed) on top of v4.6-rc1 and at that point post
all the patches (this is, after all, at least 4.7 material). At the same time
I do not want to hide the latest version from anyone wanting to have a look or
test.

The series will be posted again for review. This is just a heads up.

v5 compared to v4:
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


The series looks like this now:

The following changes since commit f6cede5b49e822ebc41a099fe41ab4989f64e2cb:

  Linux 4.5-rc7 (2016-03-06 14:48:03 -0800)

are available in the git repository at:

  https://github.com/peda-r/i2c-mux.git mux-core-and-locking-5

for you to fetch changes up to c1ef4a249b0bd45ba97e14f15f6ee89e7fbc0222:

  [media] rtl2832: regmap is aware of lockdep, drop local locking hack (2016-03-15 10:02:15 +0100)

----------------------------------------------------------------
Antti Palosaari (1):
      [media] si2168: declare that the i2c gate is self-locked

Peter Rosin (24):
      MAINTAINERS: add myself as i2c mux maintainer
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
      i2c-mux: relax locking of the top i2c adapter during self-locked muxing
      i2c-mux: document i2c muxes and elaborate on parent-/self-locked muxes
      iio: imu: inv_mpu6050: declare that the i2c gate is self-locked
      [media] rtl2832: declare that the i2c gate is self-locked
      [media] rtl2832_sdr: get rid of empty regmap wrappers
      [media] rtl2832: regmap is aware of lockdep, drop local locking hack

 Documentation/i2c/i2c-topology               | 312 ++++++++++++++++++++++++
 MAINTAINERS                                  |  11 +
 drivers/i2c/i2c-core.c                       |  65 +++--
 drivers/i2c/i2c-mux.c                        | 347 ++++++++++++++++++++++-----
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c   |  47 ++--
 drivers/i2c/muxes/i2c-mux-gpio.c             |  72 +++---
 drivers/i2c/muxes/i2c-mux-pca9541.c          |  55 ++---
 drivers/i2c/muxes/i2c-mux-pca954x.c          |  64 ++---
 drivers/i2c/muxes/i2c-mux-pinctrl.c          | 124 +++++-----
 drivers/i2c/muxes/i2c-mux-reg.c              |  63 ++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c   |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   |  75 ++----
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |   3 +-
 drivers/media/dvb-frontends/m88ds3103.c      |  18 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   2 +-
 drivers/media/dvb-frontends/rtl2830.c        |  17 +-
 drivers/media/dvb-frontends/rtl2830_priv.h   |   2 +-
 drivers/media/dvb-frontends/rtl2832.c        | 236 +++---------------
 drivers/media/dvb-frontends/rtl2832.h        |   4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h   |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c    | 303 ++++++++++-------------
 drivers/media/dvb-frontends/rtl2832_sdr.h    |   5 +-
 drivers/media/dvb-frontends/si2168.c         |  82 ++-----
 drivers/media/dvb-frontends/si2168_priv.h    |   2 +-
 drivers/media/usb/cx231xx/cx231xx-core.c     |   6 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c      |  47 ++--
 drivers/media/usb/cx231xx/cx231xx.h          |   4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |   5 +-
 drivers/of/unittest.c                        |  40 ++-
 include/linux/i2c-mux.h                      |  65 ++++-
 include/linux/i2c.h                          |  28 ++-
 31 files changed, 1206 insertions(+), 903 deletions(-)
 create mode 100644 Documentation/i2c/i2c-topology

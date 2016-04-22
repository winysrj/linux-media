Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0130.outbound.protection.outlook.com ([157.55.234.130]:28817
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751971AbcDVLwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 07:52:47 -0400
From: Peter Rosin <peda@axentia.se>
To: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@axentia.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	"Guenter Roeck" <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	"Hartmut Knaack" <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	"Peter Meerwald" <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	"Frank Rowand" <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Kalle Valo" <kvalo@codeaurora.org>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	"Crestez Dan Leonard" <leonard.crestez@intel.com>,
	"linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 00/24] i2c mux cleanup and locking update
Date: Fri, 22 Apr 2016 11:52:41 +0000
Message-ID: <AM4PR02MB129919DA6CE8A98793D10C43BC6F0@AM4PR02MB1299.eurprd02.prod.outlook.com>
Content-Language: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wolfram Sang wrote:
> > The problem with waiting until 4.8 with the rest of the series is that it
> > will likely go stale, e.g. patch 22 ([media] rtl2832: change the i2c gate
> > to be mux-locked) touches a ton of register accesses in that driver since
> > it removes a regmap wrapper that is rendered obsolete. Expecting that
> > patch to work for 4.8 is overly optimistic, and while patching things up
> 
> Okay, that can be argued, I understand that. So, what about this
> suggestion: I pull in patches 1-15 today, and we schedule the rest of
> the patches for like next week or so. That still gives the first set of
> patches some time in linux-next for further exposure and testing whilst
> the whole series should arrive in 4.7.

That sounds really good, thanks!

> However, I need help with that. There are serious locking changes
> involved and ideally these patches are reviewed by multiple people,
> especially patches 16-19. I first want to say that the collaboration
> experience with this series was great so far, lots of testing and
> reporting back. Thanks for that already. Yet, if we want to have this in
> 4.7, this needs to be a group effort. So, if people interested could
> review even a little and report back this would be extremly helpful.

Yes please!

> > Third, should we deprecate the old i2c_add_mux_adapter, so that new
> > users do not crop up behind our backs in the transition? Or not bother?
> 
> Usually it is fine to change in-kernel-APIs when you take care that all
> current users are converted. But I am also fine with being nice and
> keeping the old call around for a few cycles. It is your call.

Ok, I'm a bit fed up with this series and will ignore it then.

> > Fourth, I forgot to change patch 8 (iio: imu: inv_mpu6050: convert to
> > use an explicit i2c mux core) to not change i2c_get_clientdata() ->
> > dev_get_drvdata() as requested by Jonathan Cameron. How should I handle
> > that?
> 
> I'll pull in the first patches this eveneing. You can choose to send me
> an incremental patch or resend patch 8. I am fine with both, but it
> should appear on the mailing list somehow.

I just sent a v8 of 08/24 (not sending a whole v8 for that though)

> > There are also some new Tested-by tags that I have added to my
> > local branch but have not pushed anywhere. I'm ready to push all that
> > to a new branch once you are ready to take it.
> 
> For the patches 1-15, I am ready when you are :)

Ok, I pushed out v8, see below. Pick what you want :-)

Cheers,
Peter

The following changes since commit f55532a0c0b8bb6148f4e07853b876ef73bc69ca:

  Linux 4.6-rc1 (2016-03-26 16:03:24 -0700)

are available in the git repository at:

  https://github.com/peda-r/i2c-mux.git mux-core-and-locking-8

for you to fetch changes up to b9a0ea3a309a3a4051c7c0cc54ade0eb5a877896:

  [media] rtl2832: regmap is aware of lockdep, drop local locking hack (2016-04-22 12:18:45 +0200)

----------------------------------------------------------------
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
 drivers/i2c/i2c-mux.c                        | 297 ++++++++++++++++-----
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c   |  47 ++--
 drivers/i2c/muxes/i2c-mux-gpio.c             |  73 +++---
 drivers/i2c/muxes/i2c-mux-pca9541.c          |  58 ++---
 drivers/i2c/muxes/i2c-mux-pca954x.c          |  61 +++--
 drivers/i2c/muxes/i2c-mux-pinctrl.c          | 121 +++++----
 drivers/i2c/muxes/i2c-mux-reg.c              |  69 ++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c   |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   |   1 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c    |  79 ++----
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |   3 +-
 drivers/media/dvb-frontends/m88ds3103.c      |  19 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h |   2 +-
 drivers/media/dvb-frontends/rtl2830.c        |  20 +-
 drivers/media/dvb-frontends/rtl2830_priv.h   |   2 +-
 drivers/media/dvb-frontends/rtl2832.c        | 243 +++---------------
 drivers/media/dvb-frontends/rtl2832.h        |   4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h   |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c    | 303 ++++++++++------------
 drivers/media/dvb-frontends/rtl2832_sdr.h    |   5 +-
 drivers/media/dvb-frontends/si2168.c         | 106 +++-----
 drivers/media/dvb-frontends/si2168_priv.h    |   3 +-
 drivers/media/usb/cx231xx/cx231xx-core.c     |   6 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c      |  47 ++--
 drivers/media/usb/cx231xx/cx231xx.h          |   4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |   5 +-
 drivers/of/unittest.c                        |  37 +--
 include/linux/i2c-mux.h                      |  53 +++-
 include/linux/i2c.h                          |  29 ++-
 32 files changed, 1224 insertions(+), 915 deletions(-)
 create mode 100644 Documentation/i2c/i2c-topology

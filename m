Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3LULK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 06:10:26 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] subdev autoselect only works if I2C and I2C_MUX is selected
Date: Sat, 21 Dec 2013 06:07:15 -0200
Message-Id: <1387613235-25483-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by the kbuild test robot <fengguang.wu@intel.com>:

> warning: (VIDEO_EM28XX_DVB) selects DVB_M88DS3103 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CORE && I2C && I2C_MUX)
>    drivers/built-in.o: In function `m88ds3103_release':
> >> m88ds3103.c:(.text+0x1ab1af): undefined reference to `i2c_del_mux_adapter'
>    drivers/built-in.o: In function `m88ds3103_attach':
> >> (.text+0x1ab342): undefined reference to `i2c_add_mux_adapter'

There are 3 possible ways to fix it:

1) make em28xx dependent on I2C_MUX.

That sounds wrong, as the em28xx bridge doesn't have i2c muxes on it,
and just one frontend has.

Well, subdevs could eventually be converted to, instead of using dvb
i2c gate control, to use i2c mux support.

That makes sense, but it takes time and lots of effort. Not sure if
this will happen anytime soon.

2) MEDIA_SUBDRV_AUTOSELECT can be dependent of I2C and I2C_MUX.

That means that users will need to manually enable I2C_MUX on some
distributions. Not sure about others, but, on Fedora, this option is
disabled.

So, it can end by generating a number of complains from users
that their devices suddenly stopped working after a Kernel upgrade,
at least until all distros that ship Kernels with I2C_MUX enabled.

3) if MEDIA_SUBDRV_AUTOSELECT is selected, it will select I2C and I2C_MUX.

Of course, MEDIA_SUBDRV_AUTOSELECT will need to inherit all dependencies
that I2C and I2C_MUX have (only HAS_IOMEM).

The disadvantage is that, if new dependencies are added on I2C, they'll
also need to be added here.

As the hole idea of autoselect is to let the user not bother about whatever
frontend/tuner is used by a driver, IMHO, (3) is the better solution.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8270388e2a0d..1d0758aeb8e4 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -172,6 +172,9 @@ comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
 config MEDIA_SUBDRV_AUTOSELECT
 	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT
+	depends on HAS_IOMEM
+	select I2C
+	select I2C_MUX
 	default y
 	help
 	  By default, a media driver auto-selects all possible ancillary
-- 
1.8.3.1


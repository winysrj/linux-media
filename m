Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:40823 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3LUKuy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 05:50:54 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY500361KST4X30@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 21 Dec 2013 05:50:53 -0500 (EST)
Date: Sat, 21 Dec 2013 08:50:48 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 483/499] m88ds3103.c:undefined reference to
 `i2c_del_mux_adapter'
Message-id: <20131221085048.40a00d81@samsung.com>
In-reply-to: <52b4fca0.ygAJPoOJD83r3RML%fengguang.wu@intel.com>
References: <52b4fca0.ygAJPoOJD83r3RML%fengguang.wu@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 21 Dec 2013 10:27:44 +0800
kbuild test robot <fengguang.wu@intel.com> escreveu:

> tree:   git://linuxtv.org/media_tree.git master
> head:   c57f87e62368c33ebda11a4993380c8e5a19a5c5
> commit: 44b9055b4b058d7b02bf0380158627f9be79b9e5 [483/499] [media] m88ds3103: use I2C mux for tuner I2C adapter
> config: i386-randconfig-x0-12210941 (attached as .config)
> 
> All error/warnings:
> 
> warning: (VIDEO_EM28XX_DVB) selects DVB_M88DS3103 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CORE && I2C && I2C_MUX)
>    drivers/built-in.o: In function `m88ds3103_release':
> >> m88ds3103.c:(.text+0x1ab1af): undefined reference to `i2c_del_mux_adapter'
>    drivers/built-in.o: In function `m88ds3103_attach':
> >> (.text+0x1ab342): undefined reference to `i2c_add_mux_adapter'
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

Not sure what's the best fix for this. I can see 3 alternatives:

1) make em28xx dependent on I2C_MUX.

That sounds wrong, as the em28xx bridge doesn't have i2c muxes on it,
and just one frontend has.

Well, we may eventually convert all i2c gate stuff into i2c mux support,
with makes sense, but it takes time and lots of effort.

2) we may make MEDIA_SUBDRV_AUTOSELECT dependent of I2C and I2C_MUX.

That means that users will need to manually enable I2C_MUX on some
distributions. Not sure about others, but, on Fedora, this option is
disabled.

So, we'll end by receiving a number of complains from users, until all
distros that ship media start adding I2C_MUX.

3) if MEDIA_SUBDRV_AUTOSELECT is selected, it will select I2C and I2C_MUX.

Of course, MEDIA_SUBDRV_AUTOSELECT will need to inherit all dependencies
that I2C and I2C_MUX have (only HAS_IOMEM).

The disadvantage is that, if new dependencies are added on I2C, they'll
also need to be added here.

As the hole idea of autoselect is to let the user not bother about whatever
frontend/tuner is used by a driver, IMHO, (3) is the better solution.

Patch for (3) is enclosed.

-- 

Cheers,
Mauro

From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Sat, 21 Dec 2013 05:42:11 -0200
Subject: [PATCH] [media] subdev autoselect only works if I2C and I2C_MUX is selected

As reported by the kbuild test robot <fengguang.wu@intel.com>:

> warning: (VIDEO_EM28XX_DVB) selects DVB_M88DS3103 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CORE && I2C && I2C_MUX)
>    drivers/built-in.o: In function `m88ds3103_release':
> >> m88ds3103.c:(.text+0x1ab1af): undefined reference to `i2c_del_mux_adapter'
>    drivers/built-in.o: In function `m88ds3103_attach':
> >> (.text+0x1ab342): undefined reference to `i2c_add_mux_adapter'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

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

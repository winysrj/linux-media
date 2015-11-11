Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbKKRPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 12:15:38 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Daniel Ribeiro <drwyrm@gmail.com>,
	Stefan Schmidt <stefan@openezx.org>,
	Harald Welte <laforge@openezx.org>,
	Sergey Lapin <slapin@ossfans.org>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Josh Wu <josh.wu@atmel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Inki Dae <inki.dae@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	openezx-devel@lists.openezx.org, linux-sh@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] [media] include/media: move platform driver headers to a separate dir
Date: Wed, 11 Nov 2015 15:14:48 -0200
Message-Id: <09e182fa61a7122356b790cd2a4a7f622dabb4ce.1447261977.git.mchehab@osg.samsung.com>
In-Reply-To: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
References: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
In-Reply-To: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
References: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's not mix headers used by the core with those headers that
are needed by some specific platform drivers.

This patch was made via this script:

	mkdir include/media/platform
	for i in include/media/*.h; do n=`basename $i`;  (for j in $(git grep -l $n); do dirname $j; done)|sort|uniq|grep -ve '^.$' > list; num=$(wc -l list|cut -d' ' -f1); if [ $num == 1 ]; then if [ "`grep platform list`" != "" ]; then git mv $i include/media/platform; fi; fi; done
	git mv include/media/exynos* include/media/s5p* include/media/omap* include/media/soc_* include/media/sh_include/media/platform/
	for i in $(find include/media/ -type f); do n=`basename $i`; git grep -l $n; done|sort|uniq >files && (echo "for i in \$(cat files); do cat \$i | \\"; cd include/media; for j in rc/ i2c/ platform/ common_drv/; do for i in $(ls $j); do echo "perl -ne 's,(include [\\\"\\<]media/)($i)([\\\"\\>]),\1$j\2\3,; print \$_' |\\"; done; done; echo "cat > a && mv a \$i; done") >script && . ./script

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 rename include/media/{ => platform}/exynos-fimc.h (100%)
 rename include/media/{ => platform}/mmp-camera.h (100%)
 rename include/media/{ => platform}/omap1_camera.h (100%)
 rename include/media/{ => platform}/omap4iss.h (100%)
 rename include/media/{ => platform}/s3c_camif.h (100%)
 rename include/media/{ => platform}/s5p_hdmi.h (100%)
 rename include/media/{ => platform}/sh_mobile_ceu.h (100%)
 rename include/media/{ => platform}/sh_mobile_csi2.h (100%)
 rename include/media/{ => platform}/sh_vou.h (100%)
 rename include/media/{ => platform}/sii9234.h (100%)
 rename include/media/{ => platform}/soc_camera.h (100%)
 rename include/media/{ => platform}/soc_camera_platform.h (98%)
 rename include/media/{ => platform}/soc_mediabus.h (100%)

diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index ede2bdbb5dd5..99bd64c69a4f 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -33,7 +33,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/leds.h>
 #include <linux/platform_data/asoc-mx27vis.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <sound/tlv320aic32x4.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 9ef4640f3660..74d073fd4fa6 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -31,7 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/spi/l4f00242t03.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 65a0dc06a97c..5e1b9c335103 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -28,7 +28,7 @@
 #include <linux/usb/ulpi.h>
 #include <linux/memblock.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 7e315f00648d..355b9521f7f0 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -45,7 +45,7 @@
 
 #include <video/platform_lcd.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include "3ds_debugboard.h"
 #include "common.h"
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 6d879417db49..02cc07b0a687 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -35,7 +35,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index 2e895a82a6eb..79ae360a9c8f 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -24,7 +24,7 @@
 
 #include <linux/usb/otg.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include "common.h"
 #include "devices-imx31.h"
diff --git a/arch/arm/mach-imx/mx31moboard-smartbot.c b/arch/arm/mach-imx/mx31moboard-smartbot.c
index 89fc35a64448..00bd100df69a 100644
--- a/arch/arm/mach-imx/mx31moboard-smartbot.c
+++ b/arch/arm/mach-imx/mx31moboard-smartbot.c
@@ -23,7 +23,7 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include "board-mx31moboard.h"
 #include "common.h"
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index a95499ea8706..7adef38f27c2 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -28,7 +28,7 @@
 #include <linux/io.h>
 #include <linux/platform_data/gpio-omap.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <asm/serial.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap1/include/mach/camera.h b/arch/arm/mach-omap1/include/mach/camera.h
index 847d00f0bb0a..0df5ebf85de6 100644
--- a/arch/arm/mach-omap1/include/mach/camera.h
+++ b/arch/arm/mach-omap1/include/mach/camera.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_ARCH_CAMERA_H_
 #define __ASM_ARCH_CAMERA_H_
 
-#include <media/omap1_camera.h>
+#include <media/platform/omap1_camera.h>
 
 void omap1_camera_init(void *);
 
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 9d7072b04045..ae645794ffd0 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -34,7 +34,7 @@
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/regulator/userspace-consumer.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index ab93441e596e..22125d6e6f1d 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -22,7 +22,7 @@
 #include <linux/leds-lp3944.h>
 #include <linux/i2c/pxa-i2c.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 29997bde277d..6d6531738c60 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -56,7 +56,7 @@
 #include <linux/platform_data/camera-pxa.h>
 #include <mach/audio.h>
 #include <mach/smemc.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <mach/mioa701.h>
 
diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 1a35ddf218da..54ce20931774 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -51,7 +51,7 @@
 #include <mach/pm.h>
 #include <linux/platform_data/camera-pxa.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include "generic.h"
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 68736ae71507..aecb05bb3d1c 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -27,7 +27,7 @@
 #include <linux/pwm_backlight.h>
 
 #include <media/i2c/mt9v022.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 #include <linux/platform_data/camera-pxa.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-shmobile/board-bockw.c b/arch/arm/mach-shmobile/board-bockw.c
index 25a0e7233fe4..1b64ccab36ae 100644
--- a/arch/arm/mach-shmobile/board-bockw.c
+++ b/arch/arm/mach-shmobile/board-bockw.c
@@ -31,7 +31,7 @@
 #include <linux/spi/flash.h>
 #include <linux/usb/renesas_usbhs.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <asm/mach/arch.h>
 #include <sound/rcar_snd.h>
 #include <sound/simple_card.h>
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 83c7d154bde0..02acada61c82 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -36,7 +36,7 @@
 #include <linux/platform_data/s3c-hsotg.h>
 #include <linux/platform_data/dma-s3c24xx.h>
 
-#include <media/s5p_hdmi.h>
+#include <media/platform/s5p_hdmi.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 62b045c6d289..3c097616e7ae 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -28,9 +28,9 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
-#include <media/soc_camera_platform.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_camera_platform.h>
+#include <media/platform/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/io.h>
 #include <asm/clock.h>
diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 5fcec7648d52..8341af21d28e 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -38,8 +38,8 @@
 #include <video/sh_mobile_lcdc.h>
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
-#include <media/sh_mobile_ceu.h>
-#include <media/soc_camera.h>
+#include <media/platform/sh_mobile_ceu.h>
+#include <media/platform/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <media/i2c/mt9t112.h>
 #include <asm/heartbeat.h>
@@ -901,7 +901,7 @@ static struct platform_device irda_device = {
 };
 
 #include <media/i2c/ak881x.h>
-#include <media/sh_vou.h>
+#include <media/platform/sh_vou.h>
 
 static struct ak881x_pdata ak881x_pdata = {
 	.flags = AK881X_IF_MODE_SLAVE,
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index ec9357333878..478e3f894112 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -28,8 +28,8 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <media/i2c/rj54n1cb0c.h>
-#include <media/soc_camera.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/suspend.h>
 #include <asm/clock.h>
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 7f91854dea15..8fabc7c09363 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -27,9 +27,9 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/platform/sh_mobile_ceu.h>
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <asm/clock.h>
 #include <asm/machvec.h>
diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index 4ecedcc2473c..e1cddc6bf816 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -30,7 +30,7 @@
 #include <linux/sh_intc.h>
 #include <linux/videodev2.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/platform/sh_mobile_ceu.h>
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
 #include <asm/io.h>
@@ -535,7 +535,7 @@ static struct platform_device irda_device = {
 };
 
 #include <media/i2c/ak881x.h>
-#include <media/sh_vou.h>
+#include <media/platform/sh_vou.h>
 
 static struct ak881x_pdata ak881x_pdata = {
 	.flags = AK881X_IF_MODE_SLAVE,
diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
index 95d9274a872c..ebd92d4a4c44 100644
--- a/drivers/media/i2c/m5mols/m5mols_capture.c
+++ b/drivers/media/i2c/m5mols/m5mols_capture.c
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/i2c/m5mols.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #include "m5mols.h"
 #include "m5mols_reg.h"
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f68c2352c63c..8490febb3af5 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -17,7 +17,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 4fbdd1e9f7ee..fa45d5bdf2f0 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -14,8 +14,8 @@
 #include <linux/log2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 6dfaead6aaa8..40a88d98d534 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -16,7 +16,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 3b6eeed2e2b9..509842c5dd28 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -17,7 +17,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 6a1b2a9f9a09..bf2fb19d3357 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -26,7 +26,7 @@
 #include <linux/videodev2.h>
 
 #include <media/i2c/mt9t112.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-image-sizes.h>
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 48362e0be8b8..652f7a650c54 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -16,8 +16,8 @@
 #include <linux/module.h>
 
 #include <media/i2c/mt9v022.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 9b4f5deec748..31b5f683bc06 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -24,7 +24,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index bab9ac0c1764..93af96568892 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -23,7 +23,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-mediabus.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 1f8af1ee8352..3b4aa54e5493 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -31,7 +31,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index a43410c1e254..b111ed3b3f3d 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -25,7 +25,7 @@
 #include <linux/videodev2.h>
 
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 8caae1c07541..a02bb6020554 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -27,7 +27,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 03a7fc7316ae..7dfb61eee612 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/v4l2-mediabus.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index aa7bfbb4ad71..46308f05c197 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 
 #include <media/i2c/rj54n1cb0c.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 06aff81787a7..c946e9317c6a 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -25,7 +25,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index 0eb34ecb8ee4..0cd08313276b 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/module.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 #include "common.h"
 
 /* Called with the media graph mutex held or entity->stream_count > 0. */
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index d336fa2916df..b286a865f9b8 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #define dbg(fmt, args...) \
 	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 6e6648446f00..8e66796d2218 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #include "common.h"
 #include "media-dev.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index c2d25df85db9..c73e7ee3980d 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -24,7 +24,7 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 extern int fimc_isp_debug;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index 0477716a20db..66dedaeb73cd 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -12,7 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #include "fimc-lite-reg.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 60660c3a5de0..3d356289c17e 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #include "common.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index b302305dedbe..af2b56e759e6 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -23,7 +23,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index df0cbcb69b6b..0e8702e14887 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -13,7 +13,7 @@
 #include <linux/io.h>
 #include <linux/regmap.h>
 
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 #include "media-dev.h"
 
 #include "fimc-reg.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a4cbff..000650f6adf8 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #include "media-dev.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 03214541f149..f3fc24a0c007 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -19,7 +19,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 
 #include "fimc-core.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 4b85105dc159..0b3646921eda 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
-#include <media/exynos-fimc.h>
+#include <media/platform/exynos-fimc.h>
 #include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index b5f165a68566..2058a0e94e03 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/mmp-camera.h>
+#include <media/platform/mmp-camera.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index adaf1969ef63..cae6b12e212c 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
 #include <media/videobuf2-v4l2.h>
-#include <media/s3c_camif.h>
+#include <media/platform/s3c_camif.h>
 
 #define S3C_CAMIF_DRIVER_NAME	"s3c-camif"
 #define CAMIF_REQ_BUFS_MIN	3
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
index af2d472ea1dd..0c0088f5954c 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.h
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -13,7 +13,7 @@
 #define CAMIF_REGS_H_
 
 #include "camif-core.h"
-#include <media/s3c_camif.h>
+#include <media/platform/s3c_camif.h>
 
 /*
  * The id argument indicates the processing path:
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 79940757b34f..bd6841180bef 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -33,7 +33,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-dv-timings.h>
 
-#include <media/s5p_hdmi.h>
+#include <media/platform/s5p_hdmi.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 8d171310af8f..a8eac8ae4226 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -23,7 +23,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/slab.h>
 
-#include <media/sii9234.h>
+#include <media/platform/sii9234.h>
 #include <media/v4l2-subdev.h>
 
 MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 2231f8922df3..399eb40df812 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -22,7 +22,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/sh_vou.h>
+#include <media/platform/sh_vou.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 454f68f0cdad..1c72392d2264 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -23,8 +23,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 1f28d21a3c9a..1a2a540d5e1d 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -34,8 +34,8 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 
 #include <linux/videodev2.h>
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 49c3a257a916..438769dbd443 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -22,8 +22,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 
 #include <linux/platform_data/camera-mx3.h>
 #include <linux/platform_data/dma-imx.h>
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index ba8dcd11ae0e..b766ac825038 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -28,9 +28,9 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <media/omap1_camera.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/omap1_camera.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/videobuf-dma-contig.h>
 #include <media/videobuf-dma-sg.h>
 
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index fcb942de0c7f..d674cf71acc1 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -32,8 +32,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-dma-sg.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-of.h>
 
 #include <linux/videodev2.h>
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index efe57b23fac1..2c02bd9ff8d3 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -27,8 +27,8 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 67a669d826b8..0be02d4b75f7 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -39,12 +39,12 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-#include <media/soc_camera.h>
-#include <media/sh_mobile_ceu.h>
-#include <media/sh_mobile_csi2.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/sh_mobile_ceu.h>
+#include <media/platform/sh_mobile_csi2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-mediabus.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_mediabus.h>
 
 #include "soc_scale_crop.h"
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 12d3626ecf22..b11356a179f1 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -18,10 +18,10 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/sh_mobile_ceu.h>
-#include <media/sh_mobile_csi2.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/sh_mobile_ceu.h>
+#include <media/platform/sh_mobile_csi2.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index dc98122e78dc..f08e78f149a4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -29,8 +29,8 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_mediabus.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index cc8eb0758219..082f93e5c722 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -17,8 +17,8 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-subdev.h>
-#include <media/soc_camera.h>
-#include <media/soc_camera_platform.h>
+#include <media/platform/soc_camera.h>
+#include <media/platform/soc_camera_platform.h>
 
 struct soc_camera_platform_priv {
 	struct v4l2_subdev subdev;
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 1dbcd426683c..8624c9d29069 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -13,7 +13,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/soc_mediabus.h>
+#include <media/platform/soc_mediabus.h>
 
 static const struct soc_mbus_lookup mbus_fmt[] = {
 {
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index bda29bc1b933..b7bf2f05d38e 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -12,7 +12,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-common.h>
 
 #include "soc_scale_crop.h"
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 104d4a5a0649..58bc77fb26bd 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -20,7 +20,7 @@
 */
 
 #include <linux/i2c.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/i2c/mt9v011.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 35df8b4709e6..6fd951bd6096 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
-#include <media/omap4iss.h>
+#include <media/platform/omap4iss.h>
 
 #include "iss_regs.h"
 #include "iss_csiphy.h"
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.h b/drivers/staging/media/omap4iss/iss_csiphy.h
index e9ca43955654..5e6a9ec4e6ec 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.h
+++ b/drivers/staging/media/omap4iss/iss_csiphy.h
@@ -14,7 +14,7 @@
 #ifndef OMAP4_ISS_CSI_PHY_H
 #define OMAP4_ISS_CSI_PHY_H
 
-#include <media/omap4iss.h>
+#include <media/platform/omap4iss.h>
 
 struct iss_csi2_device;
 
diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
index 90bcf1fa5421..d76fd9c43dc3 100644
--- a/include/media/i2c/tw9910.h
+++ b/include/media/i2c/tw9910.h
@@ -16,7 +16,7 @@
 #ifndef __TW9910_H__
 #define __TW9910_H__
 
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 
 enum tw9910_mpout_pin {
 	TW9910_MPO_VLOSS,
diff --git a/include/media/exynos-fimc.h b/include/media/platform/exynos-fimc.h
similarity index 100%
rename from include/media/exynos-fimc.h
rename to include/media/platform/exynos-fimc.h
diff --git a/include/media/mmp-camera.h b/include/media/platform/mmp-camera.h
similarity index 100%
rename from include/media/mmp-camera.h
rename to include/media/platform/mmp-camera.h
diff --git a/include/media/omap1_camera.h b/include/media/platform/omap1_camera.h
similarity index 100%
rename from include/media/omap1_camera.h
rename to include/media/platform/omap1_camera.h
diff --git a/include/media/omap4iss.h b/include/media/platform/omap4iss.h
similarity index 100%
rename from include/media/omap4iss.h
rename to include/media/platform/omap4iss.h
diff --git a/include/media/s3c_camif.h b/include/media/platform/s3c_camif.h
similarity index 100%
rename from include/media/s3c_camif.h
rename to include/media/platform/s3c_camif.h
diff --git a/include/media/s5p_hdmi.h b/include/media/platform/s5p_hdmi.h
similarity index 100%
rename from include/media/s5p_hdmi.h
rename to include/media/platform/s5p_hdmi.h
diff --git a/include/media/sh_mobile_ceu.h b/include/media/platform/sh_mobile_ceu.h
similarity index 100%
rename from include/media/sh_mobile_ceu.h
rename to include/media/platform/sh_mobile_ceu.h
diff --git a/include/media/sh_mobile_csi2.h b/include/media/platform/sh_mobile_csi2.h
similarity index 100%
rename from include/media/sh_mobile_csi2.h
rename to include/media/platform/sh_mobile_csi2.h
diff --git a/include/media/sh_vou.h b/include/media/platform/sh_vou.h
similarity index 100%
rename from include/media/sh_vou.h
rename to include/media/platform/sh_vou.h
diff --git a/include/media/sii9234.h b/include/media/platform/sii9234.h
similarity index 100%
rename from include/media/sii9234.h
rename to include/media/platform/sii9234.h
diff --git a/include/media/soc_camera.h b/include/media/platform/soc_camera.h
similarity index 100%
rename from include/media/soc_camera.h
rename to include/media/platform/soc_camera.h
diff --git a/include/media/soc_camera_platform.h b/include/media/platform/soc_camera_platform.h
similarity index 98%
rename from include/media/soc_camera_platform.h
rename to include/media/platform/soc_camera_platform.h
index 1e5065dab430..cd21a2b00b30 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/platform/soc_camera_platform.h
@@ -12,7 +12,7 @@
 #define __SOC_CAMERA_H__
 
 #include <linux/videodev2.h>
-#include <media/soc_camera.h>
+#include <media/platform/soc_camera.h>
 #include <media/v4l2-mediabus.h>
 
 struct device;
diff --git a/include/media/soc_mediabus.h b/include/media/platform/soc_mediabus.h
similarity index 100%
rename from include/media/soc_mediabus.h
rename to include/media/platform/soc_mediabus.h
-- 
2.4.3


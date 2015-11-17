Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbbKQJQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 04:16:20 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Acked-by: Arnd Bergmann" <arnd@arndb.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Daniel Ribeiro <drwyrm@gmail.com>,
	Stefan Schmidt <stefan@openezx.org>,
	Harald Welte <laforge@openezx.org>,
	Tomas Cech <sleep_walker@suse.com>,
	Sergey Lapin <slapin@ossfans.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Timur Tabi <timur@tabi.org>,
	Nicolin Chen <nicoleotsuka@gmail.com>,
	Xiubo Li <Xiubo.Lee@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, dmaengine@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] [media] move media platform data to linux/platform_data/media
Date: Tue, 17 Nov 2015 07:15:59 -0200
Message-Id: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that media has its own subdirectory inside platform_data,
let's move the headers that are already there to such subdir.

After moving those files, the references were adjusted using this
script:

    MAIN_DIR="linux/platform_data/"
    PREV_DIR="linux/platform_data/"
    DIRS="media/"

    echo "Checking affected files" >&2
    for i in $DIRS; do
	for j in $(find include/$MAIN_DIR/$i -type f -name '*.h'); do
		 n=`basename $j`
		git grep -l $n
	done
    done|sort|uniq >files && (
	echo "Handling files..." >&2;
	echo "for i in \$(cat files|grep -v Documentation); do cat \$i | \\";
	(
		cd include/$MAIN_DIR;
		for j in $DIRS; do
			for i in $(ls $j); do
				echo "perl -ne 's,(include [\\\"\\<])$PREV_DIR($i)([\\\"\\>]),\1$MAIN_DIR$j\2\3,; print \$_' |\\";
			done;
		done;
		echo "cat > a && mv a \$i; done";
	);
	echo "Handling documentation..." >&2;
	echo "for i in MAINTAINERS \$(cat files); do cat \$i | \\";
	(
		cd include/$MAIN_DIR;
		for j in $DIRS; do
			for i in $(ls $j); do
				echo "  perl -ne 's,include/$PREV_DIR($i)\b,include/$MAIN_DIR$j\1,; print \$_' |\\";
			done;
		done;
		echo "cat > a && mv a \$i; done"
	);
    ) >script && . ./script

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 arch/arm/mach-imx/devices/devices-common.h            | 4 ++--
 arch/arm/mach-pxa/devices.c                           | 2 +-
 arch/arm/mach-pxa/em-x270.c                           | 2 +-
 arch/arm/mach-pxa/ezx.c                               | 2 +-
 arch/arm/mach-pxa/mioa701.c                           | 2 +-
 arch/arm/mach-pxa/palmtreo.c                          | 2 +-
 arch/arm/mach-pxa/palmz72.c                           | 2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c                  | 2 +-
 drivers/dma/imx-dma.c                                 | 2 +-
 drivers/dma/imx-sdma.c                                | 2 +-
 drivers/media/platform/coda/coda-common.c             | 2 +-
 drivers/media/platform/soc_camera/mx2_camera.c        | 2 +-
 drivers/media/platform/soc_camera/mx3_camera.c        | 4 ++--
 drivers/media/platform/soc_camera/pxa_camera.c        | 2 +-
 drivers/media/platform/soc_camera/rcar_vin.c          | 2 +-
 drivers/mmc/host/mxcmmc.c                             | 2 +-
 drivers/spi/spi-imx.c                                 | 2 +-
 drivers/tty/serial/imx.c                              | 2 +-
 drivers/video/fbdev/mx3fb.c                           | 2 +-
 include/linux/platform_data/{ => media}/camera-mx2.h  | 0
 include/linux/platform_data/{ => media}/camera-mx3.h  | 0
 include/linux/platform_data/{ => media}/camera-pxa.h  | 0
 include/linux/platform_data/{ => media}/camera-rcar.h | 0
 include/linux/platform_data/{ => media}/coda.h        | 0
 include/linux/platform_data/{ => media}/dma-imx.h     | 0
 sound/soc/fsl/fsl_asrc.c                              | 2 +-
 sound/soc/fsl/fsl_asrc_dma.c                          | 2 +-
 sound/soc/fsl/imx-pcm.h                               | 2 +-
 sound/soc/fsl/imx-ssi.h                               | 2 +-
 29 files changed, 25 insertions(+), 25 deletions(-)
 rename include/linux/platform_data/{ => media}/camera-mx2.h (100%)
 rename include/linux/platform_data/{ => media}/camera-mx3.h (100%)
 rename include/linux/platform_data/{ => media}/camera-pxa.h (100%)
 rename include/linux/platform_data/{ => media}/camera-rcar.h (100%)
 rename include/linux/platform_data/{ => media}/coda.h (100%)
 rename include/linux/platform_data/{ => media}/dma-imx.h (100%)

diff --git a/arch/arm/mach-imx/devices/devices-common.h b/arch/arm/mach-imx/devices/devices-common.h
index 67f7fb13050d..09cebd8cef2b 100644
--- a/arch/arm/mach-imx/devices/devices-common.h
+++ b/arch/arm/mach-imx/devices/devices-common.h
@@ -177,7 +177,7 @@ struct platform_device *__init imx_add_imx_uart_1irq(
 		const struct imxuart_platform_data *pdata);
 
 #include <linux/platform_data/video-mx3fb.h>
-#include <linux/platform_data/camera-mx3.h>
+#include <linux/platform_data/media/camera-mx3.h>
 struct imx_ipu_core_data {
 	resource_size_t iobase;
 	resource_size_t synirq;
@@ -192,7 +192,7 @@ struct platform_device *__init imx_add_mx3_sdc_fb(
 		const struct imx_ipu_core_data *data,
 		struct mx3fb_platform_data *pdata);
 
-#include <linux/platform_data/camera-mx2.h>
+#include <linux/platform_data/media/camera-mx2.h>
 struct imx_mx2_camera_data {
 	const char *devid;
 	resource_size_t iobasecsi;
diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
index 2a6e0ae2b920..d1211a40f400 100644
--- a/arch/arm/mach-pxa/devices.c
+++ b/arch/arm/mach-pxa/devices.c
@@ -14,7 +14,7 @@
 #include <mach/irqs.h>
 #include <linux/platform_data/usb-ohci-pxa27x.h>
 #include <linux/platform_data/keypad-pxa27x.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 #include <mach/audio.h>
 #include <mach/hardware.h>
 #include <linux/platform_data/mmp_dma.h>
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 9d7072b04045..8b1f89e096c6 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -46,7 +46,7 @@
 #include <linux/platform_data/usb-ohci-pxa27x.h>
 #include <linux/platform_data/mmc-pxamci.h>
 #include <linux/platform_data/keypad-pxa27x.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 
 #include "generic.h"
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index 9a9c15bfcd34..12af6e2d597c 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -34,7 +34,7 @@
 #include <linux/platform_data/usb-ohci-pxa27x.h>
 #include <mach/hardware.h>
 #include <linux/platform_data/keypad-pxa27x.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 
 #include "devices.h"
 #include "generic.h"
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 3b52b1aa0659..ccfd2b63c6a4 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -54,7 +54,7 @@
 #include <linux/platform_data/mmc-pxamci.h>
 #include <mach/udc.h>
 #include <mach/pxa27x-udc.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 #include <mach/audio.h>
 #include <mach/smemc.h>
 #include <media/soc_camera.h>
diff --git a/arch/arm/mach-pxa/palmtreo.c b/arch/arm/mach-pxa/palmtreo.c
index d8b937c870de..2dc56062fb7e 100644
--- a/arch/arm/mach-pxa/palmtreo.c
+++ b/arch/arm/mach-pxa/palmtreo.c
@@ -43,7 +43,7 @@
 #include <linux/platform_data/usb-ohci-pxa27x.h>
 #include <mach/pxa2xx-regs.h>
 #include <linux/platform_data/asoc-palm27x.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 #include <mach/palm27x.h>
 
 #include <sound/pxa2xx-lib.h>
diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 1a35ddf218da..e3df17a7e8d4 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -49,7 +49,7 @@
 #include <mach/palm27x.h>
 
 #include <mach/pm.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 
 #include <media/soc_camera.h>
 
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index e3b58cb84c06..8459239a093c 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -30,7 +30,7 @@
 #include <media/i2c/mt9v022.h>
 #include <media/soc_camera.h>
 
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 #include <asm/mach/map.h>
 #include <mach/pxa27x.h>
 #include <mach/audio.h>
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 48d85f8b95fe..8d1856369af4 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -31,7 +31,7 @@
 #include <linux/of_dma.h>
 
 #include <asm/irq.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 
 #include "dmaengine.h"
 #define IMXDMA_MAX_CHAN_DESCRIPTORS	16
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 7058d58ba588..fde0537b55ed 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -41,7 +41,7 @@
 
 #include <asm/irq.h>
 #include <linux/platform_data/dma-imx-sdma.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 15516a6e3a39..f821627d015b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -28,7 +28,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
-#include <linux/platform_data/coda.h>
+#include <linux/platform_data/media/coda.h>
 #include <linux/reset.h>
 
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 55437ec3a3e2..276beaefca7c 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -39,7 +39,7 @@
 
 #include <linux/videodev2.h>
 
-#include <linux/platform_data/camera-mx2.h>
+#include <linux/platform_data/media/camera-mx2.h>
 
 #include <asm/dma.h>
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 3e67b9517a5a..a7d449dd84f9 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -25,8 +25,8 @@
 #include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
 
-#include <linux/platform_data/camera-mx3.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/camera-mx3.h>
+#include <linux/platform_data/media/dma-imx.h>
 
 #define MX3_CAM_DRV_NAME "mx3-camera"
 
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 34762a82ebd2..415f3bda60bf 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -39,7 +39,7 @@
 #include <linux/videodev2.h>
 
 #include <mach/dma.h>
-#include <linux/platform_data/camera-pxa.h>
+#include <linux/platform_data/media/camera-pxa.h>
 
 #define PXA_CAM_VERSION "0.0.6"
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 32aa64c3fc7e..defee08f073c 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/platform_data/camera-rcar.h>
+#include <linux/platform_data/media/camera-rcar.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index d110f9e98c4b..9b8aba09a56d 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -44,7 +44,7 @@
 #include <asm/irq.h>
 #include <linux/platform_data/mmc-mxcmmc.h>
 
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 
 #define DRIVER_NAME "mxc-mmc"
 #define MXCMCI_TIMEOUT_MS 10000
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 0e5723ab47f0..0a84ab47c8c9 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -39,7 +39,7 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 #include <linux/platform_data/spi-imx.h>
 
 #define DRIVER_NAME "spi_imx"
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 016e4be05cec..cfc622fd02ab 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -42,7 +42,7 @@
 
 #include <asm/irq.h>
 #include <linux/platform_data/serial-imx.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 
 /* Register definitions */
 #define URXD0 0x0  /* Receiver Register */
diff --git a/drivers/video/fbdev/mx3fb.c b/drivers/video/fbdev/mx3fb.c
index 7947634ee6b0..702b6ff23370 100644
--- a/drivers/video/fbdev/mx3fb.c
+++ b/drivers/video/fbdev/mx3fb.c
@@ -29,7 +29,7 @@
 #include <linux/dma/ipu-dma.h>
 #include <linux/backlight.h>
 
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 #include <linux/platform_data/video-mx3fb.h>
 
 #include <asm/io.h>
diff --git a/include/linux/platform_data/camera-mx2.h b/include/linux/platform_data/media/camera-mx2.h
similarity index 100%
rename from include/linux/platform_data/camera-mx2.h
rename to include/linux/platform_data/media/camera-mx2.h
diff --git a/include/linux/platform_data/camera-mx3.h b/include/linux/platform_data/media/camera-mx3.h
similarity index 100%
rename from include/linux/platform_data/camera-mx3.h
rename to include/linux/platform_data/media/camera-mx3.h
diff --git a/include/linux/platform_data/camera-pxa.h b/include/linux/platform_data/media/camera-pxa.h
similarity index 100%
rename from include/linux/platform_data/camera-pxa.h
rename to include/linux/platform_data/media/camera-pxa.h
diff --git a/include/linux/platform_data/camera-rcar.h b/include/linux/platform_data/media/camera-rcar.h
similarity index 100%
rename from include/linux/platform_data/camera-rcar.h
rename to include/linux/platform_data/media/camera-rcar.h
diff --git a/include/linux/platform_data/coda.h b/include/linux/platform_data/media/coda.h
similarity index 100%
rename from include/linux/platform_data/coda.h
rename to include/linux/platform_data/media/coda.h
diff --git a/include/linux/platform_data/dma-imx.h b/include/linux/platform_data/media/dma-imx.h
similarity index 100%
rename from include/linux/platform_data/dma-imx.h
rename to include/linux/platform_data/media/dma-imx.h
diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 9f087d4f73ed..0ca75915ff12 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -15,7 +15,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 #include <linux/pm_runtime.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index ffc000bc1f15..96e3fb0db535 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -12,7 +12,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 #include <sound/dmaengine_pcm.h>
 #include <sound/pcm_params.h>
 
diff --git a/sound/soc/fsl/imx-pcm.h b/sound/soc/fsl/imx-pcm.h
index 133c4470acad..367e1a768d42 100644
--- a/sound/soc/fsl/imx-pcm.h
+++ b/sound/soc/fsl/imx-pcm.h
@@ -13,7 +13,7 @@
 #ifndef _IMX_PCM_H
 #define _IMX_PCM_H
 
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 
 /*
  * Do not change this as the FIQ handler depends on this size
diff --git a/sound/soc/fsl/imx-ssi.h b/sound/soc/fsl/imx-ssi.h
index be6562365b6a..7a7d55b54cf5 100644
--- a/sound/soc/fsl/imx-ssi.h
+++ b/sound/soc/fsl/imx-ssi.h
@@ -186,7 +186,7 @@
 #define DRV_NAME "imx-ssi"
 
 #include <linux/dmaengine.h>
-#include <linux/platform_data/dma-imx.h>
+#include <linux/platform_data/media/dma-imx.h>
 #include <sound/dmaengine_pcm.h>
 #include "imx-pcm.h"
 
-- 
2.5.0


Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbKPLA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 06:00:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-sh@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 3/3] [media] include/media: move platform_data to linux/platform_data/media
Date: Mon, 16 Nov 2015 09:00:45 -0200
Message-Id: <b8bd73bedde742571b1ab8a7c0917a732dbf2ca1.1447671420.git.mchehab@osg.samsung.com>
In-Reply-To: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
In-Reply-To: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's not mix platform_data headers with the core headers. Instead, let's
create a subdir at linux/platform_data and move the headers to that
common place, adding it to MAINTAINERS.

The headers were moved with:
	mkdir include/linux/platform_data/media/; git mv include/media/gpio-ir-recv.h include/media/ir-rx51.h include/media/mmp-camera.h include/media/omap1_camera.h include/media/omap4iss.h include/media/s5p_hdmi.h include/media/si4713.h include/media/sii9234.h include/media/smiapp.h include/media/soc_camera.h include/media/soc_camera_platform.h include/media/timb_radio.h include/media/timb_video.h include/linux/platform_data/media/

And the references fixed with this script:
    MAIN_DIR="linux/platform_data/"
    PREV_DIR="media/"
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

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/video4linux/omap4_camera.txt                    | 2 +-
 Documentation/video4linux/si4713.txt                          | 2 +-
 MAINTAINERS                                                   | 1 +
 arch/arm/mach-omap1/include/mach/camera.h                     | 2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c                  | 4 ++--
 arch/arm/plat-samsung/devs.c                                  | 2 +-
 arch/sh/boards/mach-ap325rxa/setup.c                          | 2 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c              | 2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                      | 2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c                   | 2 +-
 drivers/media/platform/soc_camera/omap1_camera.c              | 2 +-
 drivers/media/platform/soc_camera/soc_camera_platform.c       | 2 +-
 drivers/media/platform/timblogiw.c                            | 2 +-
 drivers/media/radio/radio-timb.c                              | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c                 | 2 +-
 drivers/media/radio/si4713/si4713.h                           | 2 +-
 drivers/media/rc/gpio-ir-recv.c                               | 2 +-
 drivers/media/rc/ir-rx51.c                                    | 2 +-
 drivers/mfd/timberdale.c                                      | 4 ++--
 drivers/staging/media/omap4iss/iss.h                          | 2 +-
 drivers/staging/media/omap4iss/iss_csiphy.h                   | 2 +-
 include/{ => linux/platform_data}/media/gpio-ir-recv.h        | 1 -
 include/{ => linux/platform_data}/media/ir-rx51.h             | 0
 include/{ => linux/platform_data}/media/mmp-camera.h          | 0
 include/{ => linux/platform_data}/media/omap1_camera.h        | 0
 include/{ => linux/platform_data}/media/omap4iss.h            | 0
 include/{ => linux/platform_data}/media/s5p_hdmi.h            | 1 -
 include/{ => linux/platform_data}/media/si4713.h              | 2 +-
 include/{ => linux/platform_data}/media/sii9234.h             | 0
 include/{ => linux/platform_data}/media/soc_camera_platform.h | 0
 include/{ => linux/platform_data}/media/timb_radio.h          | 0
 include/{ => linux/platform_data}/media/timb_video.h          | 0
 32 files changed, 24 insertions(+), 25 deletions(-)
 rename include/{ => linux/platform_data}/media/gpio-ir-recv.h (99%)
 rename include/{ => linux/platform_data}/media/ir-rx51.h (100%)
 rename include/{ => linux/platform_data}/media/mmp-camera.h (100%)
 rename include/{ => linux/platform_data}/media/omap1_camera.h (100%)
 rename include/{ => linux/platform_data}/media/omap4iss.h (100%)
 rename include/{ => linux/platform_data}/media/s5p_hdmi.h (99%)
 rename include/{ => linux/platform_data}/media/si4713.h (96%)
 rename include/{ => linux/platform_data}/media/sii9234.h (100%)
 rename include/{ => linux/platform_data}/media/soc_camera_platform.h (100%)
 rename include/{ => linux/platform_data}/media/timb_radio.h (100%)
 rename include/{ => linux/platform_data}/media/timb_video.h (100%)

diff --git a/Documentation/video4linux/omap4_camera.txt b/Documentation/video4linux/omap4_camera.txt
index 25d9b40a4651..a6734aa77242 100644
--- a/Documentation/video4linux/omap4_camera.txt
+++ b/Documentation/video4linux/omap4_camera.txt
@@ -47,7 +47,7 @@ Tested platforms
 File list
 ---------
 drivers/staging/media/omap4iss/
-include/media/omap4iss.h
+include/linux/platform_data/media/omap4iss.h
 
 References
 ----------
diff --git a/Documentation/video4linux/si4713.txt b/Documentation/video4linux/si4713.txt
index 2e7392a4fee1..2ddc6b095a76 100644
--- a/Documentation/video4linux/si4713.txt
+++ b/Documentation/video4linux/si4713.txt
@@ -157,7 +157,7 @@ int main (int argc, char *argv[])
 }
 
 The struct si4713_rnl and SI4713_IOC_MEASURE_RNL are defined under
-include/media/si4713.h.
+include/linux/platform_data/media/si4713.h.
 
 Stereo/Mono and RDS subchannels
 ===============================
diff --git a/MAINTAINERS b/MAINTAINERS
index dc1787719c2a..96521eb39270 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6895,6 +6895,7 @@ F:	Documentation/video4linux/
 F:	Documentation/DocBook/media/
 F:	drivers/media/
 F:	drivers/staging/media/
+F:	include/linux/platform_data/media/
 F:	include/media/
 F:	include/uapi/linux/dvb/
 F:	include/uapi/linux/videodev2.h
diff --git a/arch/arm/mach-omap1/include/mach/camera.h b/arch/arm/mach-omap1/include/mach/camera.h
index 847d00f0bb0a..caa6c0d6f0ac 100644
--- a/arch/arm/mach-omap1/include/mach/camera.h
+++ b/arch/arm/mach-omap1/include/mach/camera.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_ARCH_CAMERA_H_
 #define __ASM_ARCH_CAMERA_H_
 
-#include <media/omap1_camera.h>
+#include <linux/platform_data/media/omap1_camera.h>
 
 void omap1_camera_init(void *);
 
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 14edcd7a2a1d..0a0567f8e8a0 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -39,7 +39,7 @@
 
 #include <sound/tlv320aic3x.h>
 #include <sound/tpa6130a2-plat.h>
-#include <media/si4713.h>
+#include <linux/platform_data/media/si4713.h>
 #include <linux/platform_data/leds-lp55xx.h>
 
 #include <linux/platform_data/tsl2563.h>
@@ -48,7 +48,7 @@
 #include <video/omap-panel-data.h>
 
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
-#include <media/ir-rx51.h>
+#include <linux/platform_data/media/ir-rx51.h>
 #endif
 
 #include "mux.h"
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 82074625de5c..74ef8891254e 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -36,7 +36,7 @@
 #include <linux/platform_data/s3c-hsotg.h>
 #include <linux/platform_data/dma-s3c24xx.h>
 
-#include <media/s5p_hdmi.h>
+#include <linux/platform_data/media/s5p_hdmi.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index d642a77d1913..62c3b81300ed 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -29,7 +29,7 @@
 #include <linux/sh_intc.h>
 #include <media/i2c/ov772x.h>
 #include <media/soc_camera.h>
-#include <media/soc_camera_platform.h>
+#include <linux/platform_data/media/soc_camera_platform.h>
 #include <media/drv-intf/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/io.h>
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index b5f165a68566..816f4b6a7b8e 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/mmp-camera.h>
+#include <linux/platform_data/media/mmp-camera.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 79940757b34f..a03ea98c4a2e 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -33,7 +33,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-dv-timings.h>
 
-#include <media/s5p_hdmi.h>
+#include <linux/platform_data/media/s5p_hdmi.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 8d171310af8f..0a97f9ab4f76 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -23,7 +23,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/slab.h>
 
-#include <media/sii9234.h>
+#include <linux/platform_data/media/sii9234.h>
 #include <media/v4l2-subdev.h>
 
 MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index faebcab728fc..bd721e35474a 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -28,7 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <media/omap1_camera.h>
+#include <linux/platform_data/media/omap1_camera.h>
 #include <media/soc_camera.h>
 #include <media/drv-intf/soc_mediabus.h>
 #include <media/videobuf-dma-contig.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index cc8eb0758219..a51d2a42998c 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -18,7 +18,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-subdev.h>
 #include <media/soc_camera.h>
-#include <media/soc_camera_platform.h>
+#include <linux/platform_data/media/soc_camera_platform.h>
 
 struct soc_camera_platform_priv {
 	struct v4l2_subdev subdev;
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 5820e45b3a9f..113c9f3c0b3e 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-dma-contig.h>
-#include <media/timb_video.h>
+#include <linux/platform_data/media/timb_video.h>
 
 #define DRIVER_NAME			"timb-video"
 
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 04baafe5e901..a82eb9678d6c 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
-#include <media/timb_radio.h>
+#include <linux/platform_data/media/timb_radio.h>
 
 #define DRIVER_NAME "timb-radio"
 
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index a77319dcba05..5146be2a1a50 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/si4713.h>
+#include <linux/platform_data/media/si4713.h>
 
 #include "si4713.h"
 
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 8a376e142188..29d0e1f104d2 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -20,7 +20,7 @@
 #include <linux/gpio/consumer.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
-#include <media/si4713.h>
+#include <linux/platform_data/media/si4713.h>
 
 #define SI4713_PRODUCT_NUMBER		0x0D
 
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 7dbc9ca6d885..6050de1142a6 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <media/rc-core.h>
-#include <media/gpio-ir-recv.h>
+#include <linux/platform_data/media/gpio-ir-recv.h>
 
 #define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
 #define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index b1e19a26208d..4e1711a40466 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -31,7 +31,7 @@
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
-#include <media/ir-rx51.h>
+#include <linux/platform_data/media/ir-rx51.h>
 
 #define LIRC_RX51_DRIVER_FEATURES (LIRC_CAN_SET_SEND_DUTY_CYCLE |	\
 				   LIRC_CAN_SET_SEND_CARRIER |		\
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 6ce36d6970a4..c9339f85359b 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -39,8 +39,8 @@
 #include <linux/spi/max7301.h>
 #include <linux/spi/mc33880.h>
 
-#include <media/timb_radio.h>
-#include <media/timb_video.h>
+#include <linux/platform_data/media/timb_radio.h>
+#include <linux/platform_data/media/timb_video.h>
 
 #include <linux/timb_dma.h>
 
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 35df8b4709e6..5929357fe687 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
-#include <media/omap4iss.h>
+#include <linux/platform_data/media/omap4iss.h>
 
 #include "iss_regs.h"
 #include "iss_csiphy.h"
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.h b/drivers/staging/media/omap4iss/iss_csiphy.h
index e9ca43955654..a0f2d974daeb 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.h
+++ b/drivers/staging/media/omap4iss/iss_csiphy.h
@@ -14,7 +14,7 @@
 #ifndef OMAP4_ISS_CSI_PHY_H
 #define OMAP4_ISS_CSI_PHY_H
 
-#include <media/omap4iss.h>
+#include <linux/platform_data/media/omap4iss.h>
 
 struct iss_csi2_device;
 
diff --git a/include/media/gpio-ir-recv.h b/include/linux/platform_data/media/gpio-ir-recv.h
similarity index 99%
rename from include/media/gpio-ir-recv.h
rename to include/linux/platform_data/media/gpio-ir-recv.h
index 0142736a59db..0c298f569d5a 100644
--- a/include/media/gpio-ir-recv.h
+++ b/include/linux/platform_data/media/gpio-ir-recv.h
@@ -21,4 +21,3 @@ struct gpio_ir_recv_platform_data {
 };
 
 #endif /* __GPIO_IR_RECV_H__ */
-
diff --git a/include/media/ir-rx51.h b/include/linux/platform_data/media/ir-rx51.h
similarity index 100%
rename from include/media/ir-rx51.h
rename to include/linux/platform_data/media/ir-rx51.h
diff --git a/include/media/mmp-camera.h b/include/linux/platform_data/media/mmp-camera.h
similarity index 100%
rename from include/media/mmp-camera.h
rename to include/linux/platform_data/media/mmp-camera.h
diff --git a/include/media/omap1_camera.h b/include/linux/platform_data/media/omap1_camera.h
similarity index 100%
rename from include/media/omap1_camera.h
rename to include/linux/platform_data/media/omap1_camera.h
diff --git a/include/media/omap4iss.h b/include/linux/platform_data/media/omap4iss.h
similarity index 100%
rename from include/media/omap4iss.h
rename to include/linux/platform_data/media/omap4iss.h
diff --git a/include/media/s5p_hdmi.h b/include/linux/platform_data/media/s5p_hdmi.h
similarity index 99%
rename from include/media/s5p_hdmi.h
rename to include/linux/platform_data/media/s5p_hdmi.h
index 181642b8d0a5..bb9cacb0cbb0 100644
--- a/include/media/s5p_hdmi.h
+++ b/include/linux/platform_data/media/s5p_hdmi.h
@@ -34,4 +34,3 @@ struct s5p_hdmi_platform_data {
 };
 
 #endif /* S5P_HDMI_H */
-
diff --git a/include/media/si4713.h b/include/linux/platform_data/media/si4713.h
similarity index 96%
rename from include/media/si4713.h
rename to include/linux/platform_data/media/si4713.h
index be4f58e2440b..932668ad54f7 100644
--- a/include/media/si4713.h
+++ b/include/linux/platform_data/media/si4713.h
@@ -1,5 +1,5 @@
 /*
- * include/media/si4713.h
+ * include/linux/platform_data/media/si4713.h
  *
  * Board related data definitions for Si4713 i2c device driver.
  *
diff --git a/include/media/sii9234.h b/include/linux/platform_data/media/sii9234.h
similarity index 100%
rename from include/media/sii9234.h
rename to include/linux/platform_data/media/sii9234.h
diff --git a/include/media/soc_camera_platform.h b/include/linux/platform_data/media/soc_camera_platform.h
similarity index 100%
rename from include/media/soc_camera_platform.h
rename to include/linux/platform_data/media/soc_camera_platform.h
diff --git a/include/media/timb_radio.h b/include/linux/platform_data/media/timb_radio.h
similarity index 100%
rename from include/media/timb_radio.h
rename to include/linux/platform_data/media/timb_radio.h
diff --git a/include/media/timb_video.h b/include/linux/platform_data/media/timb_video.h
similarity index 100%
rename from include/media/timb_video.h
rename to include/linux/platform_data/media/timb_video.h
-- 
2.5.0


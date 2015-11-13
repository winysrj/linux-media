Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54591 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbbKMTN4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 14:13:56 -0500
Date: Fri, 13 Nov 2015 17:13:41 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	linux-sh@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
	Sergey Lapin <slapin@ossfans.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Harald Welte <laforge@openezx.org>, devel@driverdev.osuosl.org,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	openezx-devel@lists.openezx.org,
	Russell King <linux@arm.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Vinod Koul <vinod.koul@intel.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Junghak Sung <jh1009.sung@samsung.com>,
	D aniel Ribeiro <drwyrm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Inki Dae <inki.dae@samsung.com>,
	Simon Horman <horms@verge.net.au>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	linux-omap@vger.kernel.org, Stefan Schmidt <stefan@openezx.org>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Josh Wu <josh.wu@atmel.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 2/2] [media] include/media: move platform driver headers
 to a separate dir
Message-ID: <20151113171341.0972ef7a@recife.lan>
In-Reply-To: <4220808.QEkJDXYE1T@wuerfel>
References: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
	<09e182fa61a7122356b790cd2a4a7f622dabb4ce.1447261977.git.mchehab@osg.samsung.com>
	<4220808.QEkJDXYE1T@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Nov 2015 21:26:31 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Wednesday 11 November 2015 15:14:48 Mauro Carvalho Chehab wrote:
> >  rename include/media/{ => platform}/exynos-fimc.h (100%)
> >  rename include/media/{ => platform}/mmp-camera.h (100%)
> >  rename include/media/{ => platform}/omap1_camera.h (100%)
> >  rename include/media/{ => platform}/omap4iss.h (100%)
> >  rename include/media/{ => platform}/s3c_camif.h (100%)
> >  rename include/media/{ => platform}/s5p_hdmi.h (100%)
> >  rename include/media/{ => platform}/sh_mobile_ceu.h (100%)
> >  rename include/media/{ => platform}/sh_mobile_csi2.h (100%)
> >  rename include/media/{ => platform}/sh_vou.h (100%)
> >  rename include/media/{ => platform}/sii9234.h (100%)
> >  rename include/media/{ => platform}/soc_camera.h (100%)
> >  rename include/media/{ => platform}/soc_camera_platform.h (98%)
> >  rename include/media/{ => platform}/soc_mediabus.h (100%)
> 
> This still seems to be a mix of various things. Some of these are interfaces
> between drivers, while others declare a foo_platform_data structure that
> is used to interface between platform code and the driver.

True. What about calling putting those driver interfaces under
include/media/drv-intf? That also helps moving the headers for other
non-platform drivers too.

> 
> I think the latter should go into include/linux/platform_data/media/*.h instead.

Agreed.

Please see the enclosed patch:


Subject: [PATCH] [media] include/media: move platform driver headers to a
 separate dirs

Let's not mix headers used by the core with those headers that
are needed by some specific platform drivers or by platform data.

This patch was made via this script:
	mkdir include/media/platform mkdir include/media/platform_data
	(cd include/media/; git mv $(grep -l platform_data *.h|grep -v v4l2) platform_data/)
	for i in include/media/*.h; do n=`basename $i`;  (for j in $(git grep -l $n); do dirname $j; done)|sort|uniq|grep -ve '^.$' > list; num=$(wc -l list|cut -d' ' -f1); if [ $num == 1 ]; then if [ "`grep platform list`" != "" ]; then git mv $i include/media/drv-intf; fi; fi; done
	git mv include/media/exynos* include/media/soc_* include/media/sh_* include/media/drv-intf/

And some headers were manually adjusted. Then, this script fixed the
address for those new headers:

	for i in $(find include/media/ -type f); do n=`basename $i`; git grep -l $n; done|sort|uniq >files && (echo "for i in \$(cat files); do cat \$i | \\"; cd include/media; for j in platform/ platform_data/; do for i in $(ls $j); do echo "perl -ne 's,(include [\\\"\\<]media/)($i)([\\\"\\>]),\1$j\2\3,; print \$_' |\\"; done; done; echo "cat > a && mv a \$i; done") >script&& . ./script

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---

 arch/arm/mach-imx/mach-imx27_visstrim_m10.c              | 2 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                        | 2 +-
 arch/arm/mach-imx/mach-mx31_3ds.c                        | 2 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                        | 2 +-
 arch/arm/mach-imx/mach-pcm037.c                          | 2 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c                  | 2 +-
 arch/arm/mach-imx/mx31moboard-smartbot.c                 | 2 +-
 arch/arm/mach-omap1/board-ams-delta.c                    | 2 +-
 arch/arm/mach-omap1/include/mach/camera.h                | 2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c             | 4 ++--
 arch/arm/mach-pxa/em-x270.c                              | 2 +-
 arch/arm/mach-pxa/ezx.c                                  | 2 +-
 arch/arm/mach-pxa/mioa701.c                              | 2 +-
 arch/arm/mach-pxa/palmz72.c                              | 2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c                     | 2 +-
 arch/arm/mach-shmobile/board-bockw.c                     | 2 +-
 arch/arm/plat-samsung/devs.c                             | 2 +-
 arch/sh/boards/mach-ap325rxa/setup.c                     | 6 +++---
 arch/sh/boards/mach-ecovec24/setup.c                     | 6 +++---
 arch/sh/boards/mach-kfr2r09/setup.c                      | 4 ++--
 arch/sh/boards/mach-migor/setup.c                        | 4 ++--
 arch/sh/boards/mach-se/7724/setup.c                      | 4 ++--
 drivers/media/common/cx2341x.c                           | 2 +-
 drivers/media/common/saa7146/saa7146_core.c              | 2 +-
 drivers/media/common/saa7146/saa7146_fops.c              | 2 +-
 drivers/media/common/saa7146/saa7146_hlp.c               | 2 +-
 drivers/media/common/saa7146/saa7146_i2c.c               | 2 +-
 drivers/media/common/saa7146/saa7146_vbi.c               | 2 +-
 drivers/media/common/saa7146/saa7146_video.c             | 2 +-
 drivers/media/i2c/cx25840/cx25840-audio.c                | 2 +-
 drivers/media/i2c/cx25840/cx25840-core.c                 | 2 +-
 drivers/media/i2c/cx25840/cx25840-firmware.c             | 2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c                   | 2 +-
 drivers/media/i2c/cx25840/cx25840-vbi.c                  | 2 +-
 drivers/media/i2c/m5mols/m5mols_capture.c                | 2 +-
 drivers/media/i2c/msp3400-driver.c                       | 2 +-
 drivers/media/i2c/msp3400-driver.h                       | 2 +-
 drivers/media/i2c/msp3400-kthreads.c                     | 2 +-
 drivers/media/i2c/smiapp/smiapp.h                        | 2 +-
 drivers/media/i2c/soc_camera/imx074.c                    | 2 +-
 drivers/media/i2c/soc_camera/mt9m001.c                   | 4 ++--
 drivers/media/i2c/soc_camera/mt9m111.c                   | 2 +-
 drivers/media/i2c/soc_camera/mt9t031.c                   | 2 +-
 drivers/media/i2c/soc_camera/mt9t112.c                   | 2 +-
 drivers/media/i2c/soc_camera/mt9v022.c                   | 4 ++--
 drivers/media/i2c/soc_camera/ov2640.c                    | 2 +-
 drivers/media/i2c/soc_camera/ov5642.c                    | 2 +-
 drivers/media/i2c/soc_camera/ov6650.c                    | 2 +-
 drivers/media/i2c/soc_camera/ov772x.c                    | 2 +-
 drivers/media/i2c/soc_camera/ov9640.c                    | 2 +-
 drivers/media/i2c/soc_camera/ov9740.c                    | 2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                | 2 +-
 drivers/media/i2c/soc_camera/tw9910.c                    | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                    | 2 +-
 drivers/media/pci/bt8xx/bttvp.h                          | 2 +-
 drivers/media/pci/cx18/cx23418.h                         | 2 +-
 drivers/media/pci/cx23885/cx23885-417.c                  | 2 +-
 drivers/media/pci/cx23885/cx23885-cards.c                | 2 +-
 drivers/media/pci/cx23885/cx23885-video.c                | 2 +-
 drivers/media/pci/cx23885/cx23885.h                      | 2 +-
 drivers/media/pci/cx88/cx88-blackbird.c                  | 2 +-
 drivers/media/pci/cx88/cx88.h                            | 2 +-
 drivers/media/pci/ivtv/ivtv-cards.c                      | 4 ++--
 drivers/media/pci/ivtv/ivtv-driver.h                     | 2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                        | 2 +-
 drivers/media/pci/ivtv/ivtv-routing.c                    | 2 +-
 drivers/media/pci/saa7146/hexium_gemini.c                | 2 +-
 drivers/media/pci/saa7146/hexium_orion.c                 | 2 +-
 drivers/media/pci/saa7146/mxb.c                          | 2 +-
 drivers/media/pci/ttpci/av7110.h                         | 2 +-
 drivers/media/pci/ttpci/budget-av.c                      | 2 +-
 drivers/media/pci/ttpci/budget.h                         | 2 +-
 drivers/media/platform/exynos4-is/common.c               | 2 +-
 drivers/media/platform/exynos4-is/fimc-core.h            | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c       | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h             | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c        | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c            | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h            | 2 +-
 drivers/media/platform/exynos4-is/fimc-reg.c             | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c            | 2 +-
 drivers/media/platform/exynos4-is/media-dev.h            | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c            | 2 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c         | 2 +-
 drivers/media/platform/s3c-camif/camif-core.h            | 2 +-
 drivers/media/platform/s3c-camif/camif-regs.h            | 2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                 | 2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c              | 2 +-
 drivers/media/platform/sh_vou.c                          | 2 +-
 drivers/media/platform/soc_camera/atmel-isi.c            | 4 ++--
 drivers/media/platform/soc_camera/mx2_camera.c           | 4 ++--
 drivers/media/platform/soc_camera/mx3_camera.c           | 4 ++--
 drivers/media/platform/soc_camera/omap1_camera.c         | 6 +++---
 drivers/media/platform/soc_camera/pxa_camera.c           | 4 ++--
 drivers/media/platform/soc_camera/rcar_vin.c             | 4 ++--
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 8 ++++----
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       | 8 ++++----
 drivers/media/platform/soc_camera/soc_camera.c           | 4 ++--
 drivers/media/platform/soc_camera/soc_camera_platform.c  | 4 ++--
 drivers/media/platform/soc_camera/soc_mediabus.c         | 2 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c       | 2 +-
 drivers/media/platform/timblogiw.c                       | 2 +-
 drivers/media/radio/radio-maxiradio.c                    | 2 +-
 drivers/media/radio/radio-sf16fmr2.c                     | 2 +-
 drivers/media/radio/radio-shark.c                        | 2 +-
 drivers/media/radio/radio-si476x.c                       | 2 +-
 drivers/media/radio/radio-timb.c                         | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c            | 2 +-
 drivers/media/radio/si4713/si4713.h                      | 2 +-
 drivers/media/radio/tea575x.c                            | 2 +-
 drivers/media/rc/gpio-ir-recv.c                          | 2 +-
 drivers/media/rc/ir-rx51.c                               | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c                  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c                | 2 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c                  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                | 2 +-
 drivers/media/usb/cx231xx/cx231xx.h                      | 2 +-
 drivers/media/usb/em28xx/em28xx-camera.c                 | 2 +-
 drivers/media/usb/em28xx/em28xx-cards.c                  | 2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c                | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c          | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h         | 2 +-
 drivers/mfd/timberdale.c                                 | 4 ++--
 drivers/staging/media/omap4iss/iss.h                     | 2 +-
 drivers/staging/media/omap4iss/iss_csiphy.h              | 2 +-
 include/media/{ => drv-intf}/cx2341x.h                   | 0
 include/media/{ => drv-intf}/cx25840.h                   | 0
 include/media/{ => drv-intf}/exynos-fimc.h               | 0
 include/media/{ => drv-intf}/msp3400.h                   | 0
 include/media/{ => drv-intf}/s3c_camif.h                 | 0
 include/media/{ => drv-intf}/saa7146.h                   | 0
 include/media/{ => drv-intf}/saa7146_vv.h                | 2 +-
 include/media/{ => drv-intf}/sh_mobile_ceu.h             | 0
 include/media/{ => drv-intf}/sh_mobile_csi2.h            | 0
 include/media/{ => drv-intf}/sh_vou.h                    | 0
 include/media/{ => drv-intf}/si476x.h                    | 0
 include/media/{ => drv-intf}/soc_mediabus.h              | 0
 include/media/{ => drv-intf}/tea575x.h                   | 0
 include/media/i2c/tw9910.h                               | 2 +-
 include/media/{ => platform_data}/gpio-ir-recv.h         | 0
 include/media/{ => platform_data}/ir-rx51.h              | 0
 include/media/{ => platform_data}/mmp-camera.h           | 0
 include/media/{ => platform_data}/omap1_camera.h         | 0
 include/media/{ => platform_data}/omap4iss.h             | 0
 include/media/{ => platform_data}/s5p_hdmi.h             | 0
 include/media/{ => platform_data}/si4713.h               | 0
 include/media/{ => platform_data}/sii9234.h              | 0
 include/media/{ => platform_data}/smiapp.h               | 0
 include/media/{ => platform_data}/soc_camera.h           | 0
 include/media/{ => platform_data}/soc_camera_platform.h  | 2 +-
 include/media/{ => platform_data}/timb_radio.h           | 0
 include/media/{ => platform_data}/timb_video.h           | 0
 sound/pci/es1968.c                                       | 2 +-
 sound/pci/fm801.c                                        | 2 +-
 155 files changed, 158 insertions(+), 158 deletions(-)


diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index ede2bdbb5dd5..44ba1f28bb34 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -33,7 +33,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/leds.h>
 #include <linux/platform_data/asoc-mx27vis.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <sound/tlv320aic32x4.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 9ef4640f3660..0acacada1243 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -31,7 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/spi/l4f00242t03.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 65a0dc06a97c..f22907fad8a3 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -28,7 +28,7 @@
 #include <linux/usb/ulpi.h>
 #include <linux/memblock.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 7e315f00648d..751bbb0d662a 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -45,7 +45,7 @@
 
 #include <video/platform_lcd.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include "3ds_debugboard.h"
 #include "common.h"
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 6d879417db49..5621a177fc9a 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -35,7 +35,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index 2e895a82a6eb..192a3b4d22c8 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -24,7 +24,7 @@
 
 #include <linux/usb/otg.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include "common.h"
 #include "devices-imx31.h"
diff --git a/arch/arm/mach-imx/mx31moboard-smartbot.c b/arch/arm/mach-imx/mx31moboard-smartbot.c
index 89fc35a64448..774dad973d48 100644
--- a/arch/arm/mach-imx/mx31moboard-smartbot.c
+++ b/arch/arm/mach-imx/mx31moboard-smartbot.c
@@ -23,7 +23,7 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include "board-mx31moboard.h"
 #include "common.h"
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index a95499ea8706..65ab23e4238b 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -28,7 +28,7 @@
 #include <linux/io.h>
 #include <linux/platform_data/gpio-omap.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <asm/serial.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap1/include/mach/camera.h b/arch/arm/mach-omap1/include/mach/camera.h
index 847d00f0bb0a..d3c6e9120cf9 100644
--- a/arch/arm/mach-omap1/include/mach/camera.h
+++ b/arch/arm/mach-omap1/include/mach/camera.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_ARCH_CAMERA_H_
 #define __ASM_ARCH_CAMERA_H_
 
-#include <media/omap1_camera.h>
+#include <media/platform_data/omap1_camera.h>
 
 void omap1_camera_init(void *);
 
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 14edcd7a2a1d..d41a65ed9b2e 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -39,7 +39,7 @@
 
 #include <sound/tlv320aic3x.h>
 #include <sound/tpa6130a2-plat.h>
-#include <media/si4713.h>
+#include <media/platform_data/si4713.h>
 #include <linux/platform_data/leds-lp55xx.h>
 
 #include <linux/platform_data/tsl2563.h>
@@ -48,7 +48,7 @@
 #include <video/omap-panel-data.h>
 
 #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
-#include <media/ir-rx51.h>
+#include <media/platform_data/ir-rx51.h>
 #endif
 
 #include "mux.h"
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 9d7072b04045..01c733c61464 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -34,7 +34,7 @@
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/regulator/userspace-consumer.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index ab93441e596e..c6efb3a6860e 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -22,7 +22,7 @@
 #include <linux/leds-lp3944.h>
 #include <linux/i2c/pxa-i2c.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 29997bde277d..78729413f509 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -56,7 +56,7 @@
 #include <linux/platform_data/camera-pxa.h>
 #include <mach/audio.h>
 #include <mach/smemc.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <mach/mioa701.h>
 
diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 1a35ddf218da..f1e83358d6fb 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -51,7 +51,7 @@
 #include <mach/pm.h>
 #include <linux/platform_data/camera-pxa.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include "generic.h"
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 68736ae71507..ea7e7ed656b3 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -27,7 +27,7 @@
 #include <linux/pwm_backlight.h>
 
 #include <media/i2c/mt9v022.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 #include <linux/platform_data/camera-pxa.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-shmobile/board-bockw.c b/arch/arm/mach-shmobile/board-bockw.c
index 25a0e7233fe4..225565570ec2 100644
--- a/arch/arm/mach-shmobile/board-bockw.c
+++ b/arch/arm/mach-shmobile/board-bockw.c
@@ -31,7 +31,7 @@
 #include <linux/spi/flash.h>
 #include <linux/usb/renesas_usbhs.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <asm/mach/arch.h>
 #include <sound/rcar_snd.h>
 #include <sound/simple_card.h>
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 83c7d154bde0..993520a366df 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -36,7 +36,7 @@
 #include <linux/platform_data/s3c-hsotg.h>
 #include <linux/platform_data/dma-s3c24xx.h>
 
-#include <media/s5p_hdmi.h>
+#include <media/platform_data/s5p_hdmi.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 62b045c6d289..c174dcb1b16f 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -28,9 +28,9 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
-#include <media/soc_camera_platform.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/platform_data/soc_camera_platform.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/io.h>
 #include <asm/clock.h>
diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 5fcec7648d52..27a62b5ac370 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -38,8 +38,8 @@
 #include <video/sh_mobile_lcdc.h>
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
-#include <media/sh_mobile_ceu.h>
-#include <media/soc_camera.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <media/i2c/mt9t112.h>
 #include <asm/heartbeat.h>
@@ -901,7 +901,7 @@ static struct platform_device irda_device = {
 };
 
 #include <media/i2c/ak881x.h>
-#include <media/sh_vou.h>
+#include <media/drv-intf/sh_vou.h>
 
 static struct ak881x_pdata ak881x_pdata = {
 	.flags = AK881X_IF_MODE_SLAVE,
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index ec9357333878..e8dc7c1b5775 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -28,8 +28,8 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <media/i2c/rj54n1cb0c.h>
-#include <media/soc_camera.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
 #include <asm/suspend.h>
 #include <asm/clock.h>
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 7f91854dea15..6dba9ac766a9 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -27,9 +27,9 @@
 #include <linux/videodev2.h>
 #include <linux/sh_intc.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <asm/clock.h>
 #include <asm/machvec.h>
diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index 4ecedcc2473c..e0e1df136642 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -30,7 +30,7 @@
 #include <linux/sh_intc.h>
 #include <linux/videodev2.h>
 #include <video/sh_mobile_lcdc.h>
-#include <media/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
 #include <sound/sh_fsi.h>
 #include <sound/simple_card.h>
 #include <asm/io.h>
@@ -535,7 +535,7 @@ static struct platform_device irda_device = {
 };
 
 #include <media/i2c/ak881x.h>
-#include <media/sh_vou.h>
+#include <media/drv-intf/sh_vou.h>
 
 static struct ak881x_pdata ak881x_pdata = {
 	.flags = AK881X_IF_MODE_SLAVE,
diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index c07b9db51b05..5e4afa0131e6 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -27,7 +27,7 @@
 #include <linux/videodev2.h>
 
 #include <media/tuner.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/v4l2-common.h>
 
 MODULE_DESCRIPTION("cx23415/6/8 driver");
diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index 1ff9f5323bc3..9f7c5b0a6b45 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -20,7 +20,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146.h>
+#include <media/drv-intf/saa7146.h>
 #include <linux/module.h>
 
 static int saa7146_num;
diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index df1e8c975cd8..930d2c94d5d3 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -1,6 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 
 /****************************************************************************/
diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
index 3dc6a838ca6f..6ebcbc6450f5 100644
--- a/drivers/media/common/saa7146/saa7146_hlp.c
+++ b/drivers/media/common/saa7146/saa7146_hlp.c
@@ -2,7 +2,7 @@
 
 #include <linux/kernel.h>
 #include <linux/export.h>
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 static void calculate_output_format_register(struct saa7146_dev* saa, u32 palette, u32* clip_format)
 {
diff --git a/drivers/media/common/saa7146/saa7146_i2c.c b/drivers/media/common/saa7146/saa7146_i2c.c
index 22027198129d..239a2db35068 100644
--- a/drivers/media/common/saa7146/saa7146_i2c.c
+++ b/drivers/media/common/saa7146/saa7146_i2c.c
@@ -1,6 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 static u32 saa7146_i2c_func(struct i2c_adapter *adapter)
 {
diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index 2da995758778..49237518d65f 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -1,4 +1,4 @@
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 static int vbi_pixel_to_capture = 720 * 2;
 
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 30779498c173..d5837be3e8cf 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1,6 +1,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/module.h>
diff --git a/drivers/media/i2c/cx25840/cx25840-audio.c b/drivers/media/i2c/cx25840/cx25840-audio.c
index 34b96c7cfd62..baf3d9c8710e 100644
--- a/drivers/media/i2c/cx25840/cx25840-audio.c
+++ b/drivers/media/i2c/cx25840/cx25840-audio.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index fe6eb78b6914..181fdc14c6c6 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -45,7 +45,7 @@
 #include <linux/delay.h>
 #include <linux/math64.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/cx25840/cx25840-firmware.c b/drivers/media/i2c/cx25840/cx25840-firmware.c
index 9bbb31adc29d..37e052923a87 100644
--- a/drivers/media/i2c/cx25840/cx25840-firmware.c
+++ b/drivers/media/i2c/cx25840/cx25840-firmware.c
@@ -19,7 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/firmware.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 4cf8f18bf097..4b782012cadc 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/kfifo.h>
 #include <linux/module.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <media/rc-core.h>
 
 #include "cx25840-core.h"
diff --git a/drivers/media/i2c/cx25840/cx25840-vbi.c b/drivers/media/i2c/cx25840/cx25840-vbi.c
index c39e91dc1137..04034c592603 100644
--- a/drivers/media/i2c/cx25840/cx25840-vbi.c
+++ b/drivers/media/i2c/cx25840/cx25840-vbi.c
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-common.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
index 95d9274a872c..a0cd6dc32eb0 100644
--- a/drivers/media/i2c/m5mols/m5mols_capture.c
+++ b/drivers/media/i2c/m5mols/m5mols_capture.c
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/i2c/m5mols.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "m5mols.h"
 #include "m5mols_reg.h"
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index e48230bd514f..a84561d0d4a8 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -56,7 +56,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/tvaudio.h>
 #include "msp3400-driver.h"
 
diff --git a/drivers/media/i2c/msp3400-driver.h b/drivers/media/i2c/msp3400-driver.h
index fbe5e0715f93..6cae21366ed5 100644
--- a/drivers/media/i2c/msp3400-driver.h
+++ b/drivers/media/i2c/msp3400-driver.h
@@ -4,7 +4,7 @@
 #ifndef MSP3400_DRIVER_H
 #define MSP3400_DRIVER_H
 
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/i2c/msp3400-kthreads.c b/drivers/media/i2c/msp3400-kthreads.c
index f8b51714f2f9..17120804fab7 100644
--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -26,7 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
 #include "msp3400-driver.h"
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index ed010a8a49d7..d23fa7bfe5a1 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -22,7 +22,7 @@
 #include <linux/mutex.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
-#include <media/smiapp.h>
+#include <media/platform_data/smiapp.h>
 
 #include "smiapp-pll.h"
 #include "smiapp-reg.h"
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f68c2352c63c..53ca49b0f541 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -17,7 +17,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 4fbdd1e9f7ee..2e5f6c28069b 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -14,8 +14,8 @@
 #include <linux/log2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 6dfaead6aaa8..99a89eae7505 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -16,7 +16,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 3b6eeed2e2b9..ae20a3304da8 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -17,7 +17,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 6a1b2a9f9a09..3f91426cf478 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -26,7 +26,7 @@
 #include <linux/videodev2.h>
 
 #include <media/i2c/mt9t112.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-image-sizes.h>
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 48362e0be8b8..2d695e45859c 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -16,8 +16,8 @@
 #include <linux/module.h>
 
 #include <media/i2c/mt9v022.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 9b4f5deec748..97ff65c5cd02 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -24,7 +24,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index bab9ac0c1764..192ac06d038b 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -23,7 +23,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-mediabus.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 1f8af1ee8352..f7d2d0c794ea 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -31,7 +31,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index a43410c1e254..e9480ad04778 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -25,7 +25,7 @@
 #include <linux/videodev2.h>
 
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 8caae1c07541..12e81af5cf14 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -27,7 +27,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 03a7fc7316ae..5667b9328462 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/v4l2-mediabus.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index aa7bfbb4ad71..476fc239a568 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 
 #include <media/i2c/rj54n1cb0c.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 06aff81787a7..99e7ef4b5785 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -25,7 +25,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/i2c/tw9910.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 3f40606a60a7..9400e996087b 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -51,7 +51,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include <media/i2c/tvaudio.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 
 #include <linux/dma-mapping.h>
 
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 28a02cd0fccd..b1e0023f923c 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -42,7 +42,7 @@
 #include <media/tveeprom.h>
 #include <media/rc-core.h>
 #include <media/i2c/ir-kbd-i2c.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 #include "bt848.h"
 #include "bttv.h"
diff --git a/drivers/media/pci/cx18/cx23418.h b/drivers/media/pci/cx18/cx23418.h
index 767a8d23e3f2..67ffe65b56a3 100644
--- a/drivers/media/pci/cx18/cx23418.h
+++ b/drivers/media/pci/cx18/cx23418.h
@@ -22,7 +22,7 @@
 #ifndef CX23418_H
 #define CX23418_H
 
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #define MGR_CMD_MASK            		0x40000000
 /* The MSB of the command code indicates that this is the completion of a
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 88a3afb66d10..2fe3708d8654 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #include "cx23885.h"
 #include "cx23885-ioctl.h"
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index f384f295676e..99ac2019e728 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <linux/firmware.h>
 #include <misc/altera.h>
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 71a80e2b842c..63f302e06379 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -35,7 +35,7 @@
 #include "cx23885-ioctl.h"
 #include "tuner-xc2028.h"
 
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index c5ba0833f47a..f9eb57b186fa 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -30,7 +30,7 @@
 #include <media/rc-core.h>
 
 #include "cx23885-reg.h"
-#include "media/cx2341x.h"
+#include "media/drv-intf/cx2341x.h"
 
 #include <linux/mutex.h>
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 8b889135be8a..27ffb24d73bb 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -36,7 +36,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #include "cx88.h"
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index d81b26ee89df..78f817ee7e41 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -30,7 +30,7 @@
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf2-dma-sg.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/videobuf2-dvb.h>
 #include <media/i2c/ir-kbd-i2c.h>
 #include <media/i2c/wm8775.h>
diff --git a/drivers/media/pci/ivtv/ivtv-cards.c b/drivers/media/pci/ivtv/ivtv-cards.c
index 9eb964c9f593..410d97bdf541 100644
--- a/drivers/media/pci/ivtv/ivtv-cards.c
+++ b/drivers/media/pci/ivtv/ivtv-cards.c
@@ -22,11 +22,11 @@
 #include "ivtv-cards.h"
 #include "ivtv-i2c.h"
 
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/m52790.h>
 #include <media/i2c/wm8775.h>
 #include <media/i2c/cs53l32a.h>
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <media/i2c/upd64031a.h>
 
 #define MSP_TUNER  MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER1, \
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index e004f56267a6..6c08dae67a73 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -64,7 +64,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
 #include <media/tuner.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/i2c/ir-kbd-i2c.h>
 
 #include <linux/ivtv.h>
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 1a41ba5c7d30..bccbf2d18e30 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -63,7 +63,7 @@
 #include "ivtv-cards.h"
 #include "ivtv-gpio.h"
 #include "ivtv-i2c.h"
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 
 /* i2c implementation for cx23415/6 chip, ivtv project.
  * Author: Kevin Thayer (nufan_wfk at yahoo.com)
diff --git a/drivers/media/pci/ivtv/ivtv-routing.c b/drivers/media/pci/ivtv/ivtv-routing.c
index 9a07808b61f0..0c168f238904 100644
--- a/drivers/media/pci/ivtv/ivtv-routing.c
+++ b/drivers/media/pci/ivtv/ivtv-routing.c
@@ -24,7 +24,7 @@
 #include "ivtv-gpio.h"
 #include "ivtv-routing.h"
 
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/m52790.h>
 #include <media/i2c/upd64031a.h>
 #include <media/i2c/upd64083.h>
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 03cbcd2095c6..c889ec9f8a5a 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -25,7 +25,7 @@
 
 #define DEBUG_VARIABLE debug
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 
 static int debug;
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index 15f0d66ff78a..c306a92e8909 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -25,7 +25,7 @@
 
 #define DEBUG_VARIABLE debug
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 
 static int debug;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 04b66327e329..504d78807639 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -25,7 +25,7 @@
 
 #define DEBUG_VARIABLE debug
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
 #include <media/i2c/saa7115.h>
diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 3a55927edb95..3707ccd02732 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -32,7 +32,7 @@
 #include "stv0297.h"
 #include "l64781.h"
 
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 
 
 #define ANALOG_TUNER_VES1820 1
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 3e469d4e0c87..f1f7360c01ba 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -46,7 +46,7 @@
 #include "tda1004x.h"
 #include "tua6100.h"
 #include "dvb-pll.h"
-#include <media/saa7146_vv.h>
+#include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/media/pci/ttpci/budget.h b/drivers/media/pci/ttpci/budget.h
index 1ccbe1a49a4b..655eef5236ca 100644
--- a/drivers/media/pci/ttpci/budget.h
+++ b/drivers/media/pci/ttpci/budget.h
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 
-#include <media/saa7146.h>
+#include <media/drv-intf/saa7146.h>
 
 extern int budget_debug;
 
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index 0eb34ecb8ee4..b6716c57b5db 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/module.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 #include "common.h"
 
 /* Called with the media graph mutex held or entity->stream_count > 0. */
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index d336fa2916df..6b7435453d2a 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #define dbg(fmt, args...) \
 	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 6e6648446f00..f88a36908489 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "common.h"
 #include "media-dev.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index c2d25df85db9..e0686b5f1bf8 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -24,7 +24,7 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 extern int fimc_isp_debug;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index 0477716a20db..f0acc550d065 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -12,7 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "fimc-lite-reg.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 60660c3a5de0..6f76afd909c4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "common.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index b302305dedbe..11690d563e06 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -23,7 +23,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index df0cbcb69b6b..0806724553a2 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -13,7 +13,7 @@
 #include <linux/io.h>
 #include <linux/regmap.h>
 
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 #include "media-dev.h"
 
 #include "fimc-reg.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a4cbff..9481ce3201a2 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "media-dev.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 03214541f149..93a96126929b 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -19,7 +19,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 
 #include "fimc-core.h"
 #include "fimc-lite.h"
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 4b85105dc159..ff5dabf24694 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
-#include <media/exynos-fimc.h>
+#include <media/drv-intf/exynos-fimc.h>
 #include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index b5f165a68566..9acb4278649a 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/mmp-camera.h>
+#include <media/platform_data/mmp-camera.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index adaf1969ef63..57cbc3d9725d 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
 #include <media/videobuf2-v4l2.h>
-#include <media/s3c_camif.h>
+#include <media/drv-intf/s3c_camif.h>
 
 #define S3C_CAMIF_DRIVER_NAME	"s3c-camif"
 #define CAMIF_REQ_BUFS_MIN	3
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
index af2d472ea1dd..5ad36c1c2a5d 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.h
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -13,7 +13,7 @@
 #define CAMIF_REGS_H_
 
 #include "camif-core.h"
-#include <media/s3c_camif.h>
+#include <media/drv-intf/s3c_camif.h>
 
 /*
  * The id argument indicates the processing path:
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 79940757b34f..d89d2b541c36 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -33,7 +33,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-dv-timings.h>
 
-#include <media/s5p_hdmi.h>
+#include <media/platform_data/s5p_hdmi.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 8d171310af8f..e8daf694e265 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -23,7 +23,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/slab.h>
 
-#include <media/sii9234.h>
+#include <media/platform_data/sii9234.h>
 #include <media/v4l2-subdev.h>
 
 MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 2231f8922df3..544e2b5a2ec3 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -22,7 +22,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/sh_vou.h>
+#include <media/drv-intf/sh_vou.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 454f68f0cdad..8ec2a11e0415 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -23,8 +23,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 1f28d21a3c9a..e4973bd422d7 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -34,8 +34,8 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 #include <linux/videodev2.h>
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 49c3a257a916..84989851573c 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -22,8 +22,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 #include <linux/platform_data/camera-mx3.h>
 #include <linux/platform_data/dma-imx.h>
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index ba8dcd11ae0e..1834e815fe56 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -28,9 +28,9 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <media/omap1_camera.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/omap1_camera.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/videobuf-dma-contig.h>
 #include <media/videobuf-dma-sg.h>
 
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index fcb942de0c7f..49c4c148ec60 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -32,8 +32,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-dma-sg.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-of.h>
 
 #include <linux/videodev2.h>
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index efe57b23fac1..ed804cbf47a2 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -27,8 +27,8 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 67a669d826b8..40aba9fd2950 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -39,12 +39,12 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-#include <media/soc_camera.h>
-#include <media/sh_mobile_ceu.h>
-#include <media/sh_mobile_csi2.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_csi2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-mediabus.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 #include "soc_scale_crop.h"
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 12d3626ecf22..dabc617d366e 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -18,10 +18,10 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
-#include <media/sh_mobile_ceu.h>
-#include <media/sh_mobile_csi2.h>
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/sh_mobile_ceu.h>
+#include <media/drv-intf/sh_mobile_csi2.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index dc98122e78dc..e7505258d8c5 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -29,8 +29,8 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/soc_camera.h>
-#include <media/soc_mediabus.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index cc8eb0758219..be1f87422257 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -17,8 +17,8 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-subdev.h>
-#include <media/soc_camera.h>
-#include <media/soc_camera_platform.h>
+#include <media/platform_data/soc_camera.h>
+#include <media/platform_data/soc_camera_platform.h>
 
 struct soc_camera_platform_priv {
 	struct v4l2_subdev subdev;
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 1dbcd426683c..e3e665e1c503 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -13,7 +13,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/soc_mediabus.h>
+#include <media/drv-intf/soc_mediabus.h>
 
 static const struct soc_mbus_lookup mbus_fmt[] = {
 {
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index bda29bc1b933..b7e9b5e8a18f 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -12,7 +12,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-common.h>
 
 #include "soc_scale_crop.h"
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 5820e45b3a9f..a144b198175e 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-dma-contig.h>
-#include <media/timb_video.h>
+#include <media/platform_data/timb_video.h>
 
 #define DRIVER_NAME			"timb-video"
 
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 5236035f0f2a..41c16520a367 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -42,7 +42,7 @@
 #include <linux/videodev2.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index b8d61cbc18cb..8e4f1d18c9b2 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <linux/isa.h>
 #include <linux/pnp.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 MODULE_AUTHOR("Ondrej Zary");
 MODULE_DESCRIPTION("MediaForte SF16-FMR2 and SF16-FMD2 FM radio card driver");
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 050b3bb96fec..409fac188d40 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -33,7 +33,7 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-device.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 #if defined(CONFIG_LEDS_CLASS) || \
     (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9cbb8cdf0ac0..859f0c08ee05 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
 
-#include <media/si476x.h>
+#include <media/drv-intf/si476x.h>
 #include <linux/mfd/si476x-core.h>
 
 #define FM_FREQ_RANGE_LOW   64000000
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 04baafe5e901..017a00be9819 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
-#include <media/timb_radio.h>
+#include <media/platform_data/timb_radio.h>
 
 #define DRIVER_NAME "timb-radio"
 
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index a77319dcba05..7db93c8e6ed6 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/si4713.h>
+#include <media/platform_data/si4713.h>
 
 #include "si4713.h"
 
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 8a376e142188..d1fb47dd1148 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -20,7 +20,7 @@
 #include <linux/gpio/consumer.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
-#include <media/si4713.h>
+#include <media/platform_data/si4713.h>
 
 #define SI4713_PRODUCT_NUMBER		0x0D
 
diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index 43d1ea53cb66..3e08475af579 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -31,7 +31,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 7dbc9ca6d885..e73600830d8b 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <media/rc-core.h>
-#include <media/gpio-ir-recv.h>
+#include <media/platform_data/gpio-ir-recv.h>
 
 #define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
 #define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index b1e19a26208d..5ca37afdd9b7 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -31,7 +31,7 @@
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
-#include <media/ir-rx51.h>
+#include <media/platform_data/ir-rx51.h>
 
 #define LIRC_RX51_DRIVER_FEATURES (LIRC_CAN_SET_SEND_DUTY_CYCLE |	\
 				   LIRC_CAN_SET_SEND_CARRIER |		\
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 47a98a2014a5..f59a6f18f458 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -37,7 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/tuner.h>
 
 #define CX231xx_FIRM_IMAGE_SIZE 376836
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 4a117a58c39a..be018fc089de 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -30,7 +30,7 @@
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
 
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include "dvb-usb-ids.h"
 #include "xc5000.h"
 #include "tda18271.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index a08014d20a5c..15bb573b78ac 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -32,7 +32,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
 #include "cx231xx-vbi.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index d0d8f08e37c8..246fb2bff114 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -36,7 +36,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index e34eb1bfb567..ec6d3f5bc36d 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -30,7 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/usb.h>
 
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 104d4a5a0649..b49f7de79092 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -20,7 +20,7 @@
 */
 
 #include <linux/i2c.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/i2c/mt9v011.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index f9c1c8f31e24..5718c4f7517a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -30,7 +30,7 @@
 #include <linux/i2c.h>
 #include <linux/usb.h>
 #include <media/tuner.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/i2c/saa7115.h>
 #include <media/i2c/tvp5150.h>
 #include <media/i2c/tvaudio.h>
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6a3cf342e087..bba205246b22 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -43,7 +43,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-clk.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
 #define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-audio.c b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
index 45276c628482..5f953d837bf1 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-audio.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
@@ -23,7 +23,7 @@
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
 #include <linux/videodev2.h>
-#include <media/msp3400.h>
+#include <media/drv-intf/msp3400.h>
 #include <media/v4l2-common.h>
 
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
index 1a81aa70509b..7d675fae1846 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
@@ -32,7 +32,7 @@
 
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
-#include <media/cx25840.h>
+#include <media/drv-intf/cx25840.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/errno.h>
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
index c940a12bb0ed..60141b16d731 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
@@ -39,7 +39,7 @@
 #include "pvrusb2-hdw.h"
 #include "pvrusb2-io.h"
 #include <media/v4l2-device.h>
-#include <media/cx2341x.h>
+#include <media/drv-intf/cx2341x.h>
 #include <media/i2c/ir-kbd-i2c.h>
 #include "pvrusb2-devattr.h"
 
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 6ce36d6970a4..fba30b17517a 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -39,8 +39,8 @@
 #include <linux/spi/max7301.h>
 #include <linux/spi/mc33880.h>
 
-#include <media/timb_radio.h>
-#include <media/timb_video.h>
+#include <media/platform_data/timb_radio.h>
+#include <media/platform_data/timb_video.h>
 
 #include <linux/timb_dma.h>
 
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 35df8b4709e6..8d8b0bdc4ec4 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
-#include <media/omap4iss.h>
+#include <media/platform_data/omap4iss.h>
 
 #include "iss_regs.h"
 #include "iss_csiphy.h"
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.h b/drivers/staging/media/omap4iss/iss_csiphy.h
index e9ca43955654..d00f7016c557 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.h
+++ b/drivers/staging/media/omap4iss/iss_csiphy.h
@@ -14,7 +14,7 @@
 #ifndef OMAP4_ISS_CSI_PHY_H
 #define OMAP4_ISS_CSI_PHY_H
 
-#include <media/omap4iss.h>
+#include <media/platform_data/omap4iss.h>
 
 struct iss_csi2_device;
 
diff --git a/include/media/cx2341x.h b/include/media/drv-intf/cx2341x.h
similarity index 100%
rename from include/media/cx2341x.h
rename to include/media/drv-intf/cx2341x.h
diff --git a/include/media/cx25840.h b/include/media/drv-intf/cx25840.h
similarity index 100%
rename from include/media/cx25840.h
rename to include/media/drv-intf/cx25840.h
diff --git a/include/media/exynos-fimc.h b/include/media/drv-intf/exynos-fimc.h
similarity index 100%
rename from include/media/exynos-fimc.h
rename to include/media/drv-intf/exynos-fimc.h
diff --git a/include/media/msp3400.h b/include/media/drv-intf/msp3400.h
similarity index 100%
rename from include/media/msp3400.h
rename to include/media/drv-intf/msp3400.h
diff --git a/include/media/s3c_camif.h b/include/media/drv-intf/s3c_camif.h
similarity index 100%
rename from include/media/s3c_camif.h
rename to include/media/drv-intf/s3c_camif.h
diff --git a/include/media/saa7146.h b/include/media/drv-intf/saa7146.h
similarity index 100%
rename from include/media/saa7146.h
rename to include/media/drv-intf/saa7146.h
diff --git a/include/media/saa7146_vv.h b/include/media/drv-intf/saa7146_vv.h
similarity index 99%
rename from include/media/saa7146_vv.h
rename to include/media/drv-intf/saa7146_vv.h
index 92766f77a5de..0da6ccc0615b 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/drv-intf/saa7146_vv.h
@@ -4,7 +4,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
-#include <media/saa7146.h>
+#include <media/drv-intf/saa7146.h>
 #include <media/videobuf-dma-sg.h>
 
 #define MAX_SAA7146_CAPTURE_BUFFERS	32	/* arbitrary */
diff --git a/include/media/sh_mobile_ceu.h b/include/media/drv-intf/sh_mobile_ceu.h
similarity index 100%
rename from include/media/sh_mobile_ceu.h
rename to include/media/drv-intf/sh_mobile_ceu.h
diff --git a/include/media/sh_mobile_csi2.h b/include/media/drv-intf/sh_mobile_csi2.h
similarity index 100%
rename from include/media/sh_mobile_csi2.h
rename to include/media/drv-intf/sh_mobile_csi2.h
diff --git a/include/media/sh_vou.h b/include/media/drv-intf/sh_vou.h
similarity index 100%
rename from include/media/sh_vou.h
rename to include/media/drv-intf/sh_vou.h
diff --git a/include/media/si476x.h b/include/media/drv-intf/si476x.h
similarity index 100%
rename from include/media/si476x.h
rename to include/media/drv-intf/si476x.h
diff --git a/include/media/soc_mediabus.h b/include/media/drv-intf/soc_mediabus.h
similarity index 100%
rename from include/media/soc_mediabus.h
rename to include/media/drv-intf/soc_mediabus.h
diff --git a/include/media/tea575x.h b/include/media/drv-intf/tea575x.h
similarity index 100%
rename from include/media/tea575x.h
rename to include/media/drv-intf/tea575x.h
diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
index 90bcf1fa5421..7b0a65e966fc 100644
--- a/include/media/i2c/tw9910.h
+++ b/include/media/i2c/tw9910.h
@@ -16,7 +16,7 @@
 #ifndef __TW9910_H__
 #define __TW9910_H__
 
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 
 enum tw9910_mpout_pin {
 	TW9910_MPO_VLOSS,
diff --git a/include/media/gpio-ir-recv.h b/include/media/platform_data/gpio-ir-recv.h
similarity index 100%
rename from include/media/gpio-ir-recv.h
rename to include/media/platform_data/gpio-ir-recv.h
diff --git a/include/media/ir-rx51.h b/include/media/platform_data/ir-rx51.h
similarity index 100%
rename from include/media/ir-rx51.h
rename to include/media/platform_data/ir-rx51.h
diff --git a/include/media/mmp-camera.h b/include/media/platform_data/mmp-camera.h
similarity index 100%
rename from include/media/mmp-camera.h
rename to include/media/platform_data/mmp-camera.h
diff --git a/include/media/omap1_camera.h b/include/media/platform_data/omap1_camera.h
similarity index 100%
rename from include/media/omap1_camera.h
rename to include/media/platform_data/omap1_camera.h
diff --git a/include/media/omap4iss.h b/include/media/platform_data/omap4iss.h
similarity index 100%
rename from include/media/omap4iss.h
rename to include/media/platform_data/omap4iss.h
diff --git a/include/media/s5p_hdmi.h b/include/media/platform_data/s5p_hdmi.h
similarity index 100%
rename from include/media/s5p_hdmi.h
rename to include/media/platform_data/s5p_hdmi.h
diff --git a/include/media/si4713.h b/include/media/platform_data/si4713.h
similarity index 100%
rename from include/media/si4713.h
rename to include/media/platform_data/si4713.h
diff --git a/include/media/sii9234.h b/include/media/platform_data/sii9234.h
similarity index 100%
rename from include/media/sii9234.h
rename to include/media/platform_data/sii9234.h
diff --git a/include/media/smiapp.h b/include/media/platform_data/smiapp.h
similarity index 100%
rename from include/media/smiapp.h
rename to include/media/platform_data/smiapp.h
diff --git a/include/media/soc_camera.h b/include/media/platform_data/soc_camera.h
similarity index 100%
rename from include/media/soc_camera.h
rename to include/media/platform_data/soc_camera.h
diff --git a/include/media/soc_camera_platform.h b/include/media/platform_data/soc_camera_platform.h
similarity index 97%
rename from include/media/soc_camera_platform.h
rename to include/media/platform_data/soc_camera_platform.h
index 1e5065dab430..787f6ba0f7ab 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/platform_data/soc_camera_platform.h
@@ -12,7 +12,7 @@
 #define __SOC_CAMERA_H__
 
 #include <linux/videodev2.h>
-#include <media/soc_camera.h>
+#include <media/platform_data/soc_camera.h>
 #include <media/v4l2-mediabus.h>
 
 struct device;
diff --git a/include/media/timb_radio.h b/include/media/platform_data/timb_radio.h
similarity index 100%
rename from include/media/timb_radio.h
rename to include/media/platform_data/timb_radio.h
diff --git a/include/media/timb_video.h b/include/media/platform_data/timb_video.h
similarity index 100%
rename from include/media/timb_video.h
rename to include/media/platform_data/timb_video.h
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index e0d9363dc7fd..cb38cd1c5fc4 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -113,7 +113,7 @@
 #include <sound/initval.h>
 
 #ifdef CONFIG_SND_ES1968_RADIO
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 #endif
 
 #define CARD_NAME "ESS Maestro1/2"
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 1fdd92b6f18f..5144a7fcb5aa 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -30,7 +30,7 @@
 #include <sound/initval.h>
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
-#include <media/tea575x.h>
+#include <media/drv-intf/tea575x.h>
 #endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");



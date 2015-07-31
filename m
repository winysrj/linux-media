Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57313 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbbGaIoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 04:44:44 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSC030JAGAF58E0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Jul 2015 17:44:39 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH v2 1/5] media: videobuf2: Rename videobuf2-core to
 videobuf2-v4l2
Date: Fri, 31 Jul 2015 17:44:33 +0900
Message-id: <1438332277-6542-2-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename file name - from videobuf2-core.[ch] to videobuf2-v4l2.[ch]
This renaming patch should be accompanied by the modifications for all device
drivers that include this header file. It can be done with just running this
shell script.

replace()
{
str1=$1
str2=$2
dir=$3
for file in $(find $dir -name *.h -o -name *.c -o -name Makefile)
do
    echo $file
    sed "s/$str1/$str2/g" $file > $file.out
    mv $file.out $file
done
}
replace "videobuf2-core" "videobuf2-v4l2" "include/media/"
replace "videobuf2-core" "videobuf2-v4l2" "drivers/media/"

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/pci/solo6x10/solo6x10.h              |    2 +-
 drivers/media/platform/coda/coda-bit.c             |    2 +-
 drivers/media/platform/coda/coda-common.c          |    2 +-
 drivers/media/platform/coda/coda.h                 |    2 +-
 drivers/media/platform/coda/trace.h                |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    2 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/s5p-tv/mixer.h              |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
 drivers/media/platform/ti-vpe/vpe.c                |    2 +-
 drivers/media/platform/vivid/vivid-core.h          |    2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |    2 +-
 drivers/media/platform/vsp1/vsp1_video.h           |    2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |    2 +-
 drivers/media/platform/xilinx/xilinx-dma.h         |    2 +-
 drivers/media/usb/go7007/go7007-priv.h             |    2 +-
 drivers/media/usb/stk1160/stk1160.h                |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    2 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    2 +-
 drivers/media/v4l2-core/Makefile                   |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
 drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
 .../{videobuf2-core.c => videobuf2-v4l2.c}         |   10 +++++-----
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    2 +-
 drivers/usb/gadget/function/uvc_queue.h            |    2 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/v4l2-mem2mem.h                       |    2 +-
 include/media/videobuf2-dma-contig.h               |    2 +-
 include/media/videobuf2-dma-sg.h                   |    2 +-
 include/media/videobuf2-dvb.h                      |    2 +-
 include/media/videobuf2-memops.h                   |    2 +-
 .../media/{videobuf2-core.h => videobuf2-v4l2.h}   |    2 +-
 include/media/videobuf2-vmalloc.h                  |    2 +-
 57 files changed, 61 insertions(+), 61 deletions(-)
 rename drivers/media/v4l2-core/{videobuf2-core.c => videobuf2-v4l2.c} (99%)
 rename include/media/{videobuf2-core.h => videobuf2-v4l2.h} (99%)

diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 27423d7..5cc9e9d 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -35,7 +35,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "solo6x10-regs.h"
 
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 3d434a4..d058447 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -25,7 +25,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04310cd..6e0c9be 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -36,7 +36,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 59b2af9..feb9671 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -24,7 +24,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "coda_regs.h"
 
diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
index d9099a0..9db6a66 100644
--- a/drivers/media/platform/coda/trace.h
+++ b/drivers/media/platform/coda/trace.h
@@ -5,7 +5,7 @@
 #define __CODA_TRACE_H__
 
 #include <linux/tracepoint.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "coda.h"
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index fa572aa..769ff50 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index cfebf29..d0ceae3 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -24,7 +24,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "common.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 1101c41..cef2a7f 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -27,7 +27,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "fimc-core.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 7328f08..ccb5d91 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -22,7 +22,7 @@
 #include <linux/sizes.h>
 
 #include <media/media-entity.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index e0be691..386eb49 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -22,7 +22,7 @@
 #include <linux/sizes.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-ctrls.h>
 
 #include "fimc-isp.h"
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 76b6b4d..195f9b5 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -28,7 +28,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/exynos-fimc.h>
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.h b/drivers/media/platform/exynos4-is/fimc-isp-video.h
index 98c6626..f79a1b3 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
@@ -11,7 +11,7 @@
 #ifndef FIMC_ISP_VIDEO__
 #define FIMC_ISP_VIDEO__
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include "fimc-isp.h"
 
 #ifdef CONFIG_VIDEO_EXYNOS4_ISP_DMA_CAPTURE
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index b99be09..ad9908b 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -21,7 +21,7 @@
 #include <linux/videodev2.h>
 
 #include <media/media-entity.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
 #include <media/exynos-fimc.h>
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index ca6261a..7e37c9a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -28,7 +28,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/exynos-fimc.h>
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index ea19dc7..7e4c708 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -19,7 +19,7 @@
 #include <linux/videodev2.h>
 
 #include <media/media-entity.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 0ad1b6f..9c27335 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "common.h"
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 97167f6..35cd9e5 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -10,7 +10,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /*
  * Create our own symbols for the supported buffer modes, but, for now,
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4071dd7..31c2445 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -20,7 +20,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #define ISP_VIDEO_DRIVER_NAME		"ispvideo"
 #define ISP_VIDEO_DRIVER_VERSION	"0.0.2"
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 76e6289..bb01eaa 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -34,7 +34,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "camif-core.h"
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index f47b332..1ba9bb0 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -32,7 +32,7 @@
 #include <media/media-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "camif-core.h"
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index 35d2fcd..8ef6f26 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -25,7 +25,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/s3c_camif.h>
 
 #define S3C_CAMIF_DRIVER_NAME	"s3c-camif"
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 421a7c3..81483da 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -23,7 +23,7 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "g2d.h"
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index bfbf157..712d8c3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -26,7 +26,7 @@
 #include <linux/string.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "jpeg-core.h"
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8de61dc..b3758b8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -22,7 +22,7 @@
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 24262bb..10884a7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -21,7 +21,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include "regs-mfc.h"
 #include "regs-mfc-v8.h"
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index aebe4fd..2fd59e7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -22,7 +22,7 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e65993f..3fb87ed 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -23,7 +23,7 @@
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index fb2acc5..855b723 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -24,7 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <media/v4l2-device.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "regs-mixer.h"
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index ea4c423..6e41335 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -32,7 +32,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d708df4..4595590 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -38,7 +38,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-of.h>
 #include <media/videobuf-core.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /* Default to VGA resolution */
 #define DEFAULT_WIDTH	640
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index c44760b..d82c2f2 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -40,7 +40,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "vpdma.h"
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index c72349c..5f1b1da 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -21,7 +21,7 @@
 #define _VIVID_CORE_H_
 
 #include <linux/fb.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 3c124c1..dfd45c7 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -24,7 +24,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-subdev.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "vsp1.h"
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 0887a4d..d808301 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -18,7 +18,7 @@
 #include <linux/wait.h>
 
 #include <media/media-entity.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 struct vsp1_video;
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index e779c93..d9dcd4b 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -22,7 +22,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "xilinx-dma.h"
diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
index a540111..7a1621a 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.h
+++ b/drivers/media/platform/xilinx/xilinx-dma.h
@@ -22,7 +22,7 @@
 
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 struct dma_chan;
 struct xvip_composite_device;
diff --git a/drivers/media/usb/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
index 2251c3f..9e83bbf 100644
--- a/drivers/media/usb/go7007/go7007-priv.h
+++ b/drivers/media/usb/go7007/go7007-priv.h
@@ -20,7 +20,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 struct go7007;
 
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 72cc8e8..047131b 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -23,7 +23,7 @@
 #include <linux/i2c.h>
 #include <sound/core.h>
 #include <sound/ac97_codec.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 08fb0f2..a46766c 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -29,7 +29,7 @@
  */
 
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "usbtv.h"
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 816dd1a..53e6484 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -15,7 +15,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /* --------------------------------------------------------------------------
  * UVC constants
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index dc3de00..16865b8 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-v4l2.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 85de455..e0bb729 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -26,7 +26,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/v4l2.h>
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index af8d6b4..95100e3 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -17,7 +17,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 94c1e64..437b769 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-memops.h>
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 7289b81..eb90188 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-memops.h>
 #include <media/videobuf2-dma-sg.h>
 
diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 81c1ad8..e5da47a 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -19,7 +19,7 @@
 #include <linux/sched.h>
 #include <linux/file.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-memops.h>
 
 /**
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
similarity index 99%
rename from drivers/media/v4l2-core/videobuf2-core.c
rename to drivers/media/v4l2-core/videobuf2-v4l2.c
index b866a6b..ca15186 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -1,5 +1,5 @@
 /*
- * videobuf2-core.c - V4L2 driver helper framework
+ * videobuf2-v4l2.c - V4L2 driver helper framework
  *
  * Copyright (C) 2010 Samsung Electronics
  *
@@ -28,7 +28,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include <trace/events/v4l2.h>
 
@@ -1810,7 +1810,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
 	 * after a failed start_streaming(). See the start_streaming()
-	 * documentation in videobuf2-core.h for more information how buffers
+	 * documentation in videobuf2-v4l2.h for more information how buffers
 	 * should be returned to vb2 in start_streaming().
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
@@ -2197,7 +2197,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
 	 * in stop_streaming(). See the stop_streaming() documentation in
-	 * videobuf2-core.h for more information how buffers should be returned
+	 * videobuf2-v4l2.h for more information how buffers should be returned
 	 * to vb2 in stop_streaming().
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
@@ -2731,7 +2731,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
  * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
  * for more information.
  */
 int vb2_queue_init(struct vb2_queue *q)
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 2fe4c27..45da6cd 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-memops.h>
 
diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
index 01ca9ea..0ffe498 100644
--- a/drivers/usb/gadget/function/uvc_queue.h
+++ b/drivers/usb/gadget/function/uvc_queue.h
@@ -6,7 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/poll.h>
 #include <linux/videodev2.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /* Maximum frame size in bytes, for sanity checking. */
 #define UVC_MAX_FRAME_SIZE	(16*1024*1024)
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2f6261f..97aa133 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -18,7 +18,7 @@
 #include <linux/pm.h>
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3bbd96d..22f88c7 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -17,7 +17,7 @@
 #ifndef _MEDIA_V4L2_MEM2MEM_H
 #define _MEDIA_V4L2_MEM2MEM_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /**
  * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 8197f87..c33dfa6 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -13,7 +13,7 @@
 #ifndef _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 #define _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <linux/dma-mapping.h>
 
 static inline dma_addr_t
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 14ce306..8d1083f 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -13,7 +13,7 @@
 #ifndef _MEDIA_VIDEOBUF2_DMA_SG_H
 #define _MEDIA_VIDEOBUF2_DMA_SG_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 static inline struct sg_table *vb2_dma_sg_plane_desc(
 		struct vb2_buffer *vb, unsigned int plane_no)
diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
index 8f61456..bef9127 100644
--- a/include/media/videobuf2-dvb.h
+++ b/include/media/videobuf2-dvb.h
@@ -6,7 +6,7 @@
 #include <dvb_demux.h>
 #include <dvb_net.h>
 #include <dvb_frontend.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 struct vb2_dvb {
 	/* filling that the job of the driver */
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index f05444c..7b6d475 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -14,7 +14,7 @@
 #ifndef _MEDIA_VIDEOBUF2_MEMOPS_H
 #define _MEDIA_VIDEOBUF2_MEMOPS_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /**
  * vb2_vmarea_handler - common vma refcount tracking handler
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-v4l2.h
similarity index 99%
rename from include/media/videobuf2-core.h
rename to include/media/videobuf2-v4l2.h
index 22a44c2..021a69c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-v4l2.h
@@ -1,5 +1,5 @@
 /*
- * videobuf2-core.h - V4L2 driver helper framework
+ * videobuf2-v4l2.h - V4L2 driver helper framework
  *
  * Copyright (C) 2010 Samsung Electronics
  *
diff --git a/include/media/videobuf2-vmalloc.h b/include/media/videobuf2-vmalloc.h
index 93a76b4..a63fe66 100644
--- a/include/media/videobuf2-vmalloc.h
+++ b/include/media/videobuf2-vmalloc.h
@@ -13,7 +13,7 @@
 #ifndef _MEDIA_VIDEOBUF2_VMALLOC_H
 #define _MEDIA_VIDEOBUF2_VMALLOC_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 extern const struct vb2_mem_ops vb2_vmalloc_memops;
 
-- 
1.7.9.5


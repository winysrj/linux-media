Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54192 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbFHNfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 09:35:51 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NPM01MJCOFEHU10@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Jun 2015 22:35:38 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH 1/3] modify the vb2_buffer structure for common video
 buffer and make struct vb2_v4l2_buffer
Date: Mon, 08 Jun 2015 22:35:33 +0900
Message-id: <1433770535-21143-2-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the struct vb2_buffer to common buffer by removing v4l2-specific members.
And common video buffer is embedded into v4l2-specific video buffer like:
struct vb2_v4l2_buffer {
    struct vb2_buffer    vb2;
    struct v4l2_buffer    v4l2_buf;
    struct v4l2_plane    v4l2_planes[VIDEO_MAX_PLANES];
};
This changes require the modifications of all device drivers that use this structure.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c      |   12 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   10 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   12 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   12 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |   12 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   12 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   12 +-
 drivers/media/pci/cx25821/cx25821.h                |    2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   14 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   14 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   12 +-
 drivers/media/pci/cx88/cx88-video.c                |   12 +-
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |   10 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |   12 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   18 +-
 drivers/media/pci/saa7134/saa7134.h                |    8 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   14 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    6 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   20 +-
 drivers/media/pci/tw68/tw68-video.c                |   12 +-
 drivers/media/pci/tw68/tw68.h                      |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   16 +-
 drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   20 +-
 drivers/media/platform/coda/coda-bit.c             |   20 +-
 drivers/media/platform/coda/coda-common.c          |   24 +-
 drivers/media/platform/coda/coda-jpeg.c            |    2 +-
 drivers/media/platform/coda/coda.h                 |    6 +-
 drivers/media/platform/davinci/vpbe_display.c      |    8 +-
 drivers/media/platform/davinci/vpif_capture.c      |   16 +-
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   18 +-
 drivers/media/platform/davinci/vpif_display.h      |    6 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    6 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   16 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   12 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |    4 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    6 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   14 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   10 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   16 +-
 drivers/media/platform/m2m-deinterlace.c           |   16 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   24 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |   16 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    8 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   12 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   16 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   30 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   18 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer.h              |    4 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    4 +-
 drivers/media/platform/sh_veu.c                    |   20 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   20 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   14 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   18 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   14 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   22 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
 drivers/media/platform/ti-vpe/vpe.c                |   26 +-
 drivers/media/platform/vim2m.c                     |   24 +-
 drivers/media/platform/vivid/vivid-core.h          |    4 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    8 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   10 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |   10 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   12 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    8 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   16 +-
 drivers/media/platform/vsp1/vsp1_video.h           |    6 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |    4 +-
 drivers/media/usb/airspy/airspy.c                  |    6 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    8 +-
 drivers/media/usb/au0828/au0828-video.c            |    8 +-
 drivers/media/usb/au0828/au0828.h                  |    2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    8 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    8 +-
 drivers/media/usb/em28xx/em28xx.h                  |    2 +-
 drivers/media/usb/go7007/go7007-priv.h             |    4 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   10 +-
 drivers/media/usb/hackrf/hackrf.c                  |    6 +-
 drivers/media/usb/msi2500/msi2500.c                |    6 +-
 drivers/media/usb/pwc/pwc-if.c                     |   18 +-
 drivers/media/usb/pwc/pwc.h                        |    2 +-
 drivers/media/usb/s2255/s2255drv.c                 |   10 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    4 +-
 drivers/media/usb/stk1160/stk1160.h                |    4 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    6 +-
 drivers/media/usb/usbtv/usbtv.h                    |    2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   14 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
 drivers/media/v4l2-core/Makefile                   |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  398 +++++++++----------
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
 drivers/media/v4l2-core/videobuf2-dvb.c            |    2 +-
 drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
 .../{videobuf2-core.c => videobuf2-v4l2.c}         |  400 ++++++++++----------
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   30 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |   14 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.h        |    2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   16 +-
 drivers/staging/media/omap4iss/iss_video.h         |    4 +-
 drivers/usb/gadget/function/uvc_queue.c            |   14 +-
 drivers/usb/gadget/function/uvc_queue.h            |    4 +-
 include/media/davinci/vpbe_display.h               |    2 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/v4l2-mem2mem.h                       |    8 +-
 include/media/videobuf2-core.h                     |   76 ++--
 include/media/videobuf2-dma-contig.h               |    4 +-
 include/media/videobuf2-dma-sg.h                   |    4 +-
 include/media/videobuf2-dvb.h                      |    2 +-
 include/media/videobuf2-memops.h                   |    2 +-
 .../media/{videobuf2-core.h => videobuf2-v4l2.h}   |   80 ++--
 include/media/videobuf2-vmalloc.h                  |    2 +-
 136 files changed, 1081 insertions(+), 1045 deletions(-)
 copy drivers/media/v4l2-core/{videobuf2-core.c => videobuf2-v4l2.c} (89%)
 copy include/media/{videobuf2-core.h => videobuf2-v4l2.h} (94%)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 7bd1b97..b1142c2 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -81,11 +81,11 @@ struct skeleton {
 };
 
 struct skel_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
-static inline struct skel_buffer *to_skel_buffer(struct vb2_buffer *vb2)
+static inline struct skel_buffer *to_skel_buffer(struct vb2_v4l2_buffer *vb2)
 {
 	return container_of(vb2, struct skel_buffer, vb);
 }
@@ -194,9 +194,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
  * Prepare the buffer for queueing to the DMA engine: check and set the
  * payload size.
  */
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct skeleton *skel = vb2_get_drv_priv(vb->vb2_queue);
+	struct skeleton *skel = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned long size = skel->format.sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
@@ -212,9 +212,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 /*
  * Queue this buffer to the DMA engine.
  */
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct skeleton *skel = vb2_get_drv_priv(vb->vb2_queue);
+	struct skeleton *skel = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct skel_buffer *buf = to_skel_buffer(vb);
 	unsigned long flags;
 
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 3ff8806..3ef60ba 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -103,7 +103,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct rtl2832_sdr_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -500,9 +500,9 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
+static int rtl2832_sdr_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	/* Don't allow queing new buffers after device disconnection */
 	if (!dev->udev)
@@ -511,9 +511,9 @@ static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
+static void rtl2832_sdr_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct rtl2832_sdr_frame_buf *buf =
 			container_of(vb, struct rtl2832_sdr_frame_buf, vb);
 	unsigned long flags;
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 63c0ee5..89d5009 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1153,27 +1153,27 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer *buf =
 		container_of(vb, struct cx23885_buffer, vb);
 
 	return cx23885_buf_prepare(buf, &dev->ts1);
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 
 	cx23885_free_buffer(dev, buf);
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer   *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 45fbe1e..a4af6c8 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -109,18 +109,18 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 }
 
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
+	struct cx23885_tsport *port = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer *buf =
 		container_of(vb, struct cx23885_buffer, vb);
 
 	return cx23885_buf_prepare(buf, port);
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
+	struct cx23885_tsport *port = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
@@ -128,9 +128,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 	cx23885_free_buffer(dev, buf);
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
+	struct cx23885_tsport *port = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer   *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index d362d38..4c6b19e 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -136,9 +136,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
@@ -159,12 +159,12 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 
-	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
+	cx23885_free_buffer(vb->vb2.vb2_queue->drv_priv, buf);
 }
 
 /*
@@ -188,9 +188,9 @@ static void buffer_finish(struct vb2_buffer *vb)
  * The end-result of all this that you only get an interrupt when a buffer
  * is ready, so the control flow is very easy.
  */
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb, struct cx23885_buffer, vb);
 	struct cx23885_buffer *prev;
 	struct cx23885_dmaqueue *q = &dev->vbiq;
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 5e93c68..ebec673 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -327,9 +327,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer *buf =
 		container_of(vb, struct cx23885_buffer, vb);
 	u32 line0_offset, line1_offset;
@@ -407,12 +407,12 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 
-	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
+	cx23885_free_buffer(vb->vb2.vb2_queue->drv_priv, buf);
 }
 
 /*
@@ -436,9 +436,9 @@ static void buffer_finish(struct vb2_buffer *vb)
  * The end-result of all this that you only get an interrupt when a buffer
  * is ready, so the control flow is very easy.
  */
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx23885_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx23885_buffer   *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 	struct cx23885_buffer   *prev;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index aeda8d3..bfd24f0 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -170,7 +170,7 @@ struct cx23885_riscmem {
 /* buffer for one video frame */
 struct cx23885_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head queue;
 
 	/* cx23885 specific */
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 7bc495e..bb0c663 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -157,9 +157,9 @@ static int cx25821_queue_setup(struct vb2_queue *q, const struct v4l2_format *fm
 	return 0;
 }
 
-static int cx25821_buffer_prepare(struct vb2_buffer *vb)
+static int cx25821_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
+	struct cx25821_channel *chan = vb->vb2.vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
@@ -238,21 +238,21 @@ static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 	return ret;
 }
 
-static void cx25821_buffer_finish(struct vb2_buffer *vb)
+static void cx25821_buffer_finish(struct vb2_v4l2_buffer *vb)
 {
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
-	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
+	struct cx25821_channel *chan = vb->vb2.vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 
 	cx25821_free_buffer(dev, buf);
 }
 
-static void cx25821_buffer_queue(struct vb2_buffer *vb)
+static void cx25821_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct cx25821_buffer *buf =
 		container_of(vb, struct cx25821_buffer, vb);
-	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
+	struct cx25821_channel *chan = vb->vb2.vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_buffer *prev;
 	struct cx25821_dmaqueue *q = &dev->channels[chan->id].dma_vidq;
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index d81a08a..fb2920c 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -127,7 +127,7 @@ struct cx25821_riscmem {
 /* buffer for one video frame */
 struct cx25821_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head queue;
 
 	/* cx25821 specific */
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index b6be46e..87cef1a 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -651,17 +651,17 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8802_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 
-	return cx8802_buf_prepare(vb->vb2_queue, dev, buf);
+	return cx8802_buf_prepare(vb->vb2.vb2_queue, dev, buf);
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8802_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
@@ -670,9 +670,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 	memset(risc, 0, sizeof(*risc));
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8802_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
 
 	cx8802_buf_queue(dev, buf);
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 1b2ed23..f9959a4 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -97,17 +97,17 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8802_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 
-	return cx8802_buf_prepare(vb->vb2_queue, dev, buf);
+	return cx8802_buf_prepare(vb->vb2.vb2_queue, dev, buf);
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8802_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
@@ -116,9 +116,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 	memset(risc, 0, sizeof(*risc));
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8802_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
 
 	cx8802_buf_queue(dev, buf);
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 32eb7fd..b40c2a0 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -125,9 +125,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 }
 
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8800_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int lines;
@@ -149,9 +149,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8800_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
@@ -160,9 +160,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 	memset(risc, 0, sizeof(*risc));
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8800_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
 	struct cx88_dmaqueue  *q    = &dev->vbiq;
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 860c98fc..5090346 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -444,9 +444,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8800_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
@@ -497,9 +497,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8800_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
@@ -508,9 +508,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 	memset(risc, 0, sizeof(*risc));
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
+	struct cx8800_dev *dev = vb->vb2.vb2_queue->drv_priv;
 	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
 	struct cx88_core      *core = dev->core;
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 7748ca9..9a351fd 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -321,7 +321,7 @@ struct cx88_riscmem {
 /* buffer for one video frame */
 struct cx88_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head       list;
 
 	/* cx88 specific */
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 594dc3a..618f8412 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -96,7 +96,7 @@ static struct vb2_ops saa7134_empress_qops = {
 	.queue_setup	= saa7134_ts_queue_setup,
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
-	.buf_queue	= saa7134_vb2_buffer_queue,
+	.buf_queue	= saa7134_vb2_v4l2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2709b83..e197a67 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -75,9 +75,9 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-int saa7134_ts_buffer_init(struct vb2_buffer *vb2)
+int saa7134_ts_buffer_init(struct vb2_v4l2_buffer *vb2)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2.vb2_queue->drv_priv;
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
@@ -87,9 +87,9 @@ int saa7134_ts_buffer_init(struct vb2_buffer *vb2)
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_init);
 
-int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
+int saa7134_ts_buffer_prepare(struct vb2_v4l2_buffer *vb2)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2.vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
@@ -173,7 +173,7 @@ struct vb2_ops saa7134_ts_qops = {
 	.queue_setup	= saa7134_ts_queue_setup,
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
-	.buf_queue	= saa7134_vb2_buffer_queue,
+	.buf_queue	= saa7134_vb2_v4l2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
 	.stop_streaming = saa7134_ts_stop_streaming,
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 5306e54..b26a6c3 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -81,7 +81,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
-	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2.vb2_queue->drv_priv;
 	unsigned long control, base;
 
 	dprintk("buffer_activate [%p]\n", buf);
@@ -113,9 +113,9 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb2)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb2)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2.vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
@@ -156,9 +156,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb2)
+static int buffer_init(struct vb2_v4l2_buffer *vb2)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2.vb2_queue->drv_priv;
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
@@ -170,7 +170,7 @@ struct vb2_ops saa7134_vbi_qops = {
 	.queue_setup	= queue_setup,
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
-	.buf_queue	= saa7134_vb2_buffer_queue,
+	.buf_queue	= saa7134_vb2_v4l2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
 	.start_streaming = saa7134_vb2_start_streaming,
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 99d09a7..2545418 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -788,7 +788,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
-	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2.vb2_queue->drv_priv;
 	unsigned long base,control,bpl;
 	unsigned long bpl_uv,lines_uv,base2,base3,tmp; /* planar */
 
@@ -866,9 +866,9 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb2)
+static int buffer_init(struct vb2_v4l2_buffer *vb2)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2.vb2_queue->drv_priv;
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
@@ -876,9 +876,9 @@ static int buffer_init(struct vb2_buffer *vb2)
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb2)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb2)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb2->vb2.vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
@@ -925,15 +925,15 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 /*
  * move buffer to hardware queue
  */
-void saa7134_vb2_buffer_queue(struct vb2_buffer *vb)
+void saa7134_vb2_v4l2_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = vb->vb2.vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
 	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb2);
 
 	saa7134_buffer_queue(dev, dmaq, buf);
 }
-EXPORT_SYMBOL_GPL(saa7134_vb2_buffer_queue);
+EXPORT_SYMBOL_GPL(saa7134_vb2_v4l2_buffer_queue);
 
 int saa7134_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
@@ -991,7 +991,7 @@ static struct vb2_ops vb2_qops = {
 	.queue_setup	= queue_setup,
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
-	.buf_queue	= saa7134_vb2_buffer_queue,
+	.buf_queue	= saa7134_vb2_v4l2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
 	.start_streaming = saa7134_vb2_start_streaming,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 8bf0553..00f5e8f 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -456,7 +456,7 @@ struct saa7134_thread {
 /* buffer for one video/vbi/ts frame */
 struct saa7134_buf {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb2;
+	struct vb2_v4l2_buffer vb2;
 
 	/* saa7134 specific */
 	unsigned int            top_seen;
@@ -777,7 +777,7 @@ extern unsigned int video_debug;
 extern struct video_device saa7134_video_template;
 extern struct video_device saa7134_radio_template;
 
-void saa7134_vb2_buffer_queue(struct vb2_buffer *vb);
+void saa7134_vb2_v4l2_buffer_queue(struct vb2_v4l2_buffer *vb);
 int saa7134_vb2_start_streaming(struct vb2_queue *vq, unsigned int count);
 void saa7134_vb2_stop_streaming(struct vb2_queue *vq);
 
@@ -813,8 +813,8 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 #define TS_PACKET_SIZE 188 /* TS packets 188 bytes */
 
-int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
-int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
+int saa7134_ts_buffer_init(struct vb2_v4l2_buffer *vb2);
+int saa7134_ts_buffer_prepare(struct vb2_v4l2_buffer *vb2);
 int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 53fff54..e4bd59f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -456,7 +456,7 @@ static inline u32 vop_usec(const vop_header *vh)
 }
 
 static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
-			  struct vb2_buffer *vb, const vop_header *vh)
+			  struct vb2_v4l2_buffer *vb, const vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
@@ -477,7 +477,7 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 }
 
 static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
-		struct vb2_buffer *vb, const vop_header *vh)
+		struct vb2_v4l2_buffer *vb, const vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
@@ -511,7 +511,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 }
 
 static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
-			    struct vb2_buffer *vb, struct solo_enc_buf *enc_buf)
+			    struct vb2_v4l2_buffer *vb, struct solo_enc_buf *enc_buf)
 {
 	const vop_header *vh = enc_buf->vh;
 	int ret;
@@ -676,9 +676,9 @@ static int solo_enc_queue_setup(struct vb2_queue *q,
 	return 0;
 }
 
-static void solo_enc_buf_queue(struct vb2_buffer *vb)
+static void solo_enc_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vq);
 	struct solo_vb2_buf *solo_vb =
 		container_of(vb, struct solo_vb2_buf, vb);
@@ -739,9 +739,9 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 }
 
-static void solo_enc_buf_finish(struct vb2_buffer *vb)
+static void solo_enc_buf_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vb->vb2_queue);
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 
 	switch (solo_enc->fmt) {
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 63ae8a6..fbf5468 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -189,7 +189,7 @@ static int solo_v4l2_set_ch(struct solo_dev *solo_dev, u8 ch)
 }
 
 static void solo_fillbuf(struct solo_dev *solo_dev,
-			 struct vb2_buffer *vb)
+			 struct vb2_v4l2_buffer *vb)
 {
 	dma_addr_t vbuf;
 	unsigned int fdma_addr;
@@ -343,9 +343,9 @@ static void solo_stop_streaming(struct vb2_queue *q)
 	INIT_LIST_HEAD(&solo_dev->vidq_active);
 }
 
-static void solo_buf_queue(struct vb2_buffer *vb)
+static void solo_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct solo_dev *solo_dev = vb2_get_drv_priv(vq);
 	struct solo_vb2_buf *solo_vb =
 		container_of(vb, struct solo_vb2_buf, vb);
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 1ca54b0..516d723 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -35,7 +35,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "solo6x10-regs.h"
 
@@ -135,7 +135,7 @@ struct solo_p2m_dev {
 #define OSD_TEXT_MAX		44
 
 struct solo_vb2_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 22450f5..bd1aaab 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -88,11 +88,11 @@
 
 
 struct vip_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	dma_addr_t		dma;
 };
-static inline struct vip_buffer *to_vip_buffer(struct vb2_buffer *vb2)
+static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
 {
 	return container_of(vb2, struct vip_buffer, vb);
 }
@@ -285,7 +285,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 	return 0;
 };
-static int buffer_init(struct vb2_buffer *vb)
+static int buffer_init(struct vb2_v4l2_buffer *vb)
 {
 	struct vip_buffer *vip_buf = to_vip_buffer(vb);
 
@@ -294,9 +294,9 @@ static int buffer_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vip_buffer *vip_buf = to_vip_buffer(vb);
 	unsigned long size;
 
@@ -311,9 +311,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	return 0;
 }
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vip_buffer *vip_buf = to_vip_buffer(vb);
 
 	spin_lock(&vip->lock);
@@ -327,9 +327,9 @@ static void buffer_queue(struct vb2_buffer *vb)
 	}
 	spin_unlock(&vip->lock);
 }
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
+	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vip_buffer *vip_buf = to_vip_buffer(vb);
 
 	/* Buffer handled, remove it from the list */
@@ -337,7 +337,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 	list_del_init(&vip_buf->list);
 	spin_unlock(&vip->lock);
 
-	if (vb2_is_streaming(vb->vb2_queue))
+	if (vb2_is_streaming(vb->vb2.vb2_queue))
 		vip_active_buf_next(vip);
 }
 
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8355e55..887bbdf 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -421,9 +421,9 @@ static int tw68_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
  * The end-result of all this that you only get an interrupt when a buffer
  * is ready, so the control flow is very easy.
  */
-static void tw68_buf_queue(struct vb2_buffer *vb)
+static void tw68_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
 	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
 	struct tw68_buf *prev;
@@ -455,9 +455,9 @@ static void tw68_buf_queue(struct vb2_buffer *vb)
  * last format set for the current buffer.  If they differ, the risc
  * code (which controls the filling of the buffer) is (re-)generated.
  */
-static int tw68_buf_prepare(struct vb2_buffer *vb)
+static int tw68_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
 	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
@@ -497,9 +497,9 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void tw68_buf_finish(struct vb2_buffer *vb)
+static void tw68_buf_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
 	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
 
diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
index 93f2335..e23c77c 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -134,7 +134,7 @@ struct tw68_dev;	/* forward delclaration */
 
 /* buffer for one video/vbi/ts frame */
 struct tw68_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	unsigned int   size;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 56a5cb0..7bdb1a4 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -306,7 +306,7 @@ static inline struct vpfe_device *to_vpfe(struct vpfe_ccdc *ccdc)
 	return container_of(ccdc, struct vpfe_device, ccdc);
 }
 
-static inline struct vpfe_cap_buffer *to_vpfe_buffer(struct vb2_buffer *vb)
+static inline struct vpfe_cap_buffer *to_vpfe_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpfe_cap_buffer, vb);
 }
@@ -1933,15 +1933,15 @@ static int vpfe_queue_setup(struct vb2_queue *vq,
 
 /*
  * vpfe_buffer_prepare :  callback function for buffer prepare
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  *
  * This is the callback function for buffer prepare when vb2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
-static int vpfe_buffer_prepare(struct vb2_buffer *vb)
+static int vpfe_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	vb2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
 
@@ -1955,11 +1955,11 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 
 /*
  * vpfe_buffer_queue : Callback function to add buffer to DMA queue
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  */
-static void vpfe_buffer_queue(struct vb2_buffer *vb)
+static void vpfe_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vpfe_cap_buffer *buf = to_vpfe_buffer(vb);
 	unsigned long flags = 0;
 
@@ -1971,7 +1971,7 @@ static void vpfe_buffer_queue(struct vb2_buffer *vb)
 
 /*
  * vpfe_start_streaming : Starts the DMA engine for streaming
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  * @count: number of buffers
  */
 static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
index 0f55735..a2cd259 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.h
+++ b/drivers/media/platform/am437x/am437x-vpfe.h
@@ -105,7 +105,7 @@ struct vpfe_config {
 };
 
 struct vpfe_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8f66986..db9f6bb 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -55,7 +55,7 @@ struct bcap_format {
 };
 
 struct bcap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -154,7 +154,7 @@ static const struct bcap_format bcap_formats[] = {
 
 static irqreturn_t bcap_isr(int irq, void *dev_id);
 
-static struct bcap_buffer *to_bcap_vb(struct vb2_buffer *vb)
+static struct bcap_buffer *to_bcap_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct bcap_buffer, vb);
 }
@@ -302,7 +302,7 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int bcap_buffer_init(struct vb2_buffer *vb)
+static int bcap_buffer_init(struct vb2_v4l2_buffer *vb)
 {
 	struct bcap_buffer *buf = to_bcap_vb(vb);
 
@@ -310,9 +310,9 @@ static int bcap_buffer_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int bcap_buffer_prepare(struct vb2_buffer *vb)
+static int bcap_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct bcap_buffer *buf = to_bcap_vb(vb);
 	unsigned long size;
 
@@ -327,9 +327,9 @@ static int bcap_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void bcap_buffer_queue(struct vb2_buffer *vb)
+static void bcap_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct bcap_buffer *buf = to_bcap_vb(vb);
 	unsigned long flags;
 
@@ -338,9 +338,9 @@ static void bcap_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&bcap_dev->lock, flags);
 }
 
-static void bcap_buffer_cleanup(struct vb2_buffer *vb)
+static void bcap_buffer_cleanup(struct vb2_v4l2_buffer *vb)
 {
-	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct bcap_buffer *buf = to_bcap_vb(vb);
 	unsigned long flags;
 
@@ -506,7 +506,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 {
 	struct ppi_if *ppi = dev_id;
 	struct bcap_device *bcap_dev = ppi->priv;
-	struct vb2_buffer *vb = &bcap_dev->cur_frm->vb;
+	struct vb2_v4l2_buffer *vb = &bcap_dev->cur_frm->vb;
 	dma_addr_t addr;
 
 	spin_lock(&bcap_dev->lock);
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 856b542..31d5286 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -24,7 +24,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 
@@ -167,7 +167,7 @@ static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
 }
 
 static int coda_bitstream_queue(struct coda_ctx *ctx,
-				struct vb2_buffer *src_buf)
+				struct vb2_v4l2_buffer *src_buf)
 {
 	u32 src_size = vb2_get_plane_payload(src_buf, 0);
 	u32 n;
@@ -187,7 +187,7 @@ static int coda_bitstream_queue(struct coda_ctx *ctx,
 }
 
 static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
-				     struct vb2_buffer *src_buf)
+				     struct vb2_v4l2_buffer *src_buf)
 {
 	int ret;
 
@@ -216,7 +216,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 
 void coda_fill_bitstream(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *src_buf;
+	struct vb2_v4l2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
 	u32 start;
 
@@ -446,7 +446,7 @@ err:
 	return ret;
 }
 
-static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
+static int coda_encode_header(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
 	struct coda_dev *dev = ctx->dev;
@@ -715,7 +715,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
 	u32 bitstream_buf, bitstream_size;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int gamma, ret, value;
 	u32 dst_fourcc;
 	int num_fb;
@@ -1097,7 +1097,7 @@ out:
 static int coda_prepare_encode(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	int force_ipicture;
 	int quant_param = 0;
@@ -1234,7 +1234,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 
 static void coda_finish_encode(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	u32 wr_ptr, start_ptr;
 
@@ -1568,7 +1568,7 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 
 static int coda_prepare_decode(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *dst_buf;
+	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
@@ -1685,7 +1685,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_src;
 	struct coda_q_data *q_data_dst;
-	struct vb2_buffer *dst_buf;
+	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long payload;
 	int width, height;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6f32e6d..8983c32 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -35,7 +35,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 
@@ -85,7 +85,7 @@ unsigned int coda_read(struct coda_dev *dev, u32 reg)
 }
 
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-		     struct vb2_buffer *buf, unsigned int reg_y)
+		     struct vb2_v4l2_buffer *buf, unsigned int reg_y)
 {
 	u32 base_y = vb2_dma_contig_plane_dma_addr(buf, 0);
 	u32 base_cb, base_cr;
@@ -1133,12 +1133,12 @@ static int coda_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int coda_buf_prepare(struct vb2_buffer *vb)
+static int coda_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct coda_q_data *q_data;
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	q_data = get_q_data(ctx, vb->vb2.vb2_queue->type);
 
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		v4l2_warn(&ctx->dev->v4l2_dev,
@@ -1151,13 +1151,13 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void coda_buf_queue(struct vb2_buffer *vb)
+static void coda_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct coda_q_data *q_data;
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	q_data = get_q_data(ctx, vb->vb2.vb2_queue->type);
 
 	/*
 	 * In the decoder case, immediately try to copy the buffer into the
@@ -1172,7 +1172,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 			coda_bit_stream_end_flag(ctx);
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
-		if (vb2_is_streaming(vb->vb2_queue))
+		if (vb2_is_streaming(vb->vb2.vb2_queue))
 			coda_fill_bitstream(ctx);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
@@ -1224,7 +1224,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int ret = 0;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1307,7 +1307,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 8fa3e35..a065b80 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -177,7 +177,7 @@ int coda_jpeg_write_tables(struct coda_ctx *ctx)
 	return 0;
 }
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb)
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb)
 {
 	void *vaddr = vb2_plane_vaddr(vb, 0);
 	u16 soi = be16_to_cpup((__be16 *)vaddr);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 0c35cd5..872d3ac 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -21,7 +21,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "coda_regs.h"
 
@@ -243,7 +243,7 @@ extern int coda_debug;
 void coda_write(struct coda_dev *dev, u32 data, u32 reg);
 unsigned int coda_read(struct coda_dev *dev, u32 reg);
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-		     struct vb2_buffer *buf, unsigned int reg_y);
+		     struct vb2_v4l2_buffer *buf, unsigned int reg_y);
 
 int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 		       size_t size, const char *name, struct dentry *parent);
@@ -293,7 +293,7 @@ void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 
 int coda_h264_padding(int size, char *p);
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
 void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality);
 
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index c4ab46f..b4f2782 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -205,9 +205,9 @@ static irqreturn_t venc_isr(int irq, void *arg)
  * the buffer is prepared and user space virtual address is converted into
  * physical address
  */
-static int vpbe_buffer_prepare(struct vb2_buffer *vb)
+static int vpbe_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	struct vpbe_layer *layer = vb2_get_drv_priv(q);
 	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	unsigned long addr;
@@ -262,12 +262,12 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
  * vpbe_buffer_queue()
  * This function adds the buffer to DMA queue
  */
-static void vpbe_buffer_queue(struct vb2_buffer *vb)
+static void vpbe_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	/* Get the file handle object and layer object */
 	struct vpbe_disp_buffer *buf = container_of(vb,
 				struct vpbe_disp_buffer, vb);
-	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vpbe_display *disp = layer->disp_dev;
 	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	unsigned long flags;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fa0a515..1936c76 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -57,22 +57,22 @@ static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
 /* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
 static int ycmux_mode;
 
-static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpif_cap_buffer, vb);
 }
 
 /**
  * vpif_buffer_prepare :  callback function for buffer prepare
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  *
  * This is the callback function for buffer prepare when vb2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
-static int vpif_buffer_prepare(struct vb2_buffer *vb)
+static int vpif_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
 	unsigned long addr;
@@ -141,11 +141,11 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 
 /**
  * vpif_buffer_queue : Callback function to add buffer to DMA queue
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  */
-static void vpif_buffer_queue(struct vb2_buffer *vb)
+static void vpif_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
 	struct common_obj *common;
 	unsigned long flags;
@@ -162,7 +162,7 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 
 /**
  * vpif_start_streaming : Starts the DMA engine for streaming
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  * @count: number of buffers
  */
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index f65d28d..6e6a659 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -52,7 +52,7 @@ struct video_obj {
 };
 
 struct vpif_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 839c24d..830d36f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -53,22 +53,22 @@ static struct device *vpif_dev;
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
-static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpif_disp_buffer, vb);
 }
 
 /**
  * vpif_buffer_prepare :  callback function for buffer prepare
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  *
  * This is the callback function for buffer prepare when vb2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
-static int vpif_buffer_prepare(struct vb2_buffer *vb)
+static int vpif_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct common_obj *common;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
@@ -79,7 +79,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 
 	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
 
-	if (vb->vb2_queue->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
+	if (vb->vb2.vb2_queue->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
 		unsigned long addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 
 		if (!ISALIGNED(addr + common->ytop_off) ||
@@ -132,14 +132,14 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 
 /**
  * vpif_buffer_queue : Callback function to add buffer to DMA queue
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  *
  * This callback fucntion queues the buffer to DMA engine
  */
-static void vpif_buffer_queue(struct vb2_buffer *vb)
+static void vpif_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
-	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -153,7 +153,7 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 
 /**
  * vpif_start_streaming : Starts the DMA engine for streaming
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  * @count: number of buffers
  */
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 7b21a76..fd1df8f 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -62,15 +62,15 @@ struct video_obj {
 };
 
 struct vpif_disp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
 struct common_obj {
 	struct vpif_disp_buffer *cur_frm;	/* Pointer pointing to current
-						 * vb2_buffer */
+						 * vb2_v4l2_buffer */
 	struct vpif_disp_buffer *next_frm;	/* Pointer pointing to next
-						 * vb2_buffer */
+						 * vb2_v4l2_buffer */
 	struct v4l2_format fmt;			/* Used to store the format */
 	struct vb2_queue buffer_queue;		/* Buffer queue used in
 						 * video-buf */
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 2edc40b..63279a3 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -798,7 +798,7 @@ void gsc_ctrls_delete(struct gsc_ctx *ctx)
 }
 
 /* The color format (num_comp, num_planes) must be already configured. */
-int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 			struct gsc_frame *frame, struct gsc_addr *addr)
 {
 	int ret = 0;
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index fa572aa..7dd6aef 100644
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
@@ -136,7 +136,7 @@ struct gsc_fmt {
  * @idx : index of G-Scaler input buffer
  */
 struct gsc_input_buf {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	int			idx;
 };
@@ -408,7 +408,7 @@ int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
 int gsc_set_scaler_info(struct gsc_ctx *ctx);
 int gsc_ctrls_create(struct gsc_ctx *ctx);
 void gsc_ctrls_delete(struct gsc_ctx *ctx);
-int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 		     struct gsc_frame *frame, struct gsc_addr *addr);
 
 static inline void gsc_ctx_state_lock_set(u32 state, struct gsc_ctx *ctx)
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d5cffef..7f13def 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -77,7 +77,7 @@ static void gsc_m2m_stop_streaming(struct vb2_queue *q)
 
 void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (!ctx || !ctx->m2m_ctx)
 		return;
@@ -109,7 +109,7 @@ static void gsc_m2m_job_abort(void *priv)
 static int gsc_get_bufs(struct gsc_ctx *ctx)
 {
 	struct gsc_frame *s_frame, *d_frame;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	int ret;
 
 	s_frame = &ctx->s_frame;
@@ -235,17 +235,17 @@ static int gsc_m2m_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
+static int gsc_m2m_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct gsc_frame *frame;
 	int i;
 
-	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	frame = ctx_get_frame(ctx, vb->vb2.vb2_queue->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2.vb2_queue->type)) {
 		for (i = 0; i < frame->fmt->num_planes; i++)
 			vb2_set_plane_payload(vb, i, frame->payload[i]);
 	}
@@ -253,9 +253,9 @@ static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
+static void gsc_m2m_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	pr_debug("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 8a2fd8c..24a24c5 100644
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
@@ -315,7 +315,7 @@ int fimc_capture_suspend(struct fimc_dev *fimc)
 	return fimc_pipeline_call(&fimc->vid_cap.ve, close);
 }
 
-static void buffer_queue(struct vb2_buffer *vb);
+static void buffer_queue(struct vb2_v4l2_buffer *vb);
 
 int fimc_capture_resume(struct fimc_dev *fimc)
 {
@@ -384,9 +384,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct fimc_ctx *ctx = vq->drv_priv;
 	int i;
 
@@ -408,11 +408,11 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct fimc_vid_buffer *buf
 		= container_of(vb, struct fimc_vid_buffer, vb);
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	struct exynos_video_entity *ve = &vid_cap->ve;
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 1101c41..4dfd3ac 100644
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
@@ -348,7 +348,7 @@ out:
 }
 
 /* The color format (colplanes, memplanes) must be already configured. */
-int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr)
 {
 	int ret = 0;
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 7328f08..042276c 100644
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
@@ -224,7 +224,7 @@ struct fimc_addr {
  * @index: buffer index for the output DMA engine
  */
 struct fimc_vid_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	struct fimc_addr	paddr;
 	int			index;
@@ -634,7 +634,7 @@ int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation);
 int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
-int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
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
index 76b6b4d..3964e27 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -28,7 +28,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/exynos-fimc.h>
 
@@ -157,9 +157,9 @@ static void isp_video_capture_stop_streaming(struct vb2_queue *q)
 	isp->video_capture.buf_count = 0;
 }
 
-static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
+static int isp_video_capture_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct fimc_is_video *video = &isp->video_capture;
 	int i;
 
@@ -192,9 +192,9 @@ static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
+static void isp_video_capture_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct fimc_is_video *video = &isp->video_capture;
 	struct fimc_is *is = fimc_isp_to_is(isp);
 	struct isp_video_buf *ivb = to_isp_video_buf(vb);
@@ -232,7 +232,7 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 	}
 
 	if (!test_bit(ST_ISP_VID_CAP_STREAMING, &isp->state))
-		isp_video_capture_start_streaming(vb->vb2_queue, 0);
+		isp_video_capture_start_streaming(vb->vb2.vb2_queue, 0);
 }
 
 /*
@@ -242,7 +242,7 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 void fimc_isp_video_irq_handler(struct fimc_is *is)
 {
 	struct fimc_is_video *video = &is->isp.video_capture;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int buf_index;
 
 	/* TODO: Ensure the DMA is really stopped in stop_streaming callback */
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
index b99be09..c2d25df 100644
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
@@ -102,7 +102,7 @@ struct fimc_isp_ctrls {
 };
 
 struct isp_video_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	dma_addr_t dma_addr[FIMC_ISP_MAX_PLANES];
 	unsigned int index;
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 2510f18..32e400e 100644
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
 
@@ -396,9 +396,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct fimc_lite *fimc = vq->drv_priv;
 	int i;
 
@@ -420,11 +420,11 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct flite_buffer *buf
 		= container_of(vb, struct flite_buffer, vb);
-	struct fimc_lite *fimc = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_lite *fimc = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned long flags;
 
 	spin_lock_irqsave(&fimc->slock, flags);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index ea19dc7..b302305 100644
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
@@ -100,7 +100,7 @@ struct flite_frame {
  * @index: DMA start address register's index
  */
 struct flite_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	dma_addr_t paddr;
 	unsigned short index;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 0ad1b6f..b876d25 100644
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
@@ -42,7 +42,7 @@ static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
 
 void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (!ctx || !ctx->fh.m2m_ctx)
 		return;
@@ -99,7 +99,7 @@ static void stop_streaming(struct vb2_queue *q)
 
 static void fimc_device_run(void *priv)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *sf, *df;
 	struct fimc_dev *fimc;
@@ -202,13 +202,13 @@ static int fimc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int fimc_buf_prepare(struct vb2_buffer *vb)
+static int fimc_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct fimc_frame *frame;
 	int i;
 
-	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	frame = ctx_get_frame(ctx, vb->vb2.vb2_queue->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
@@ -218,9 +218,9 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void fimc_buf_queue(struct vb2_buffer *vb)
+static void fimc_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index b70c1ae..5ebcf56 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -200,7 +200,7 @@ static void dma_callback(void *data)
 {
 	struct deinterlace_ctx *curr_ctx = data;
 	struct deinterlace_dev *pcdev = curr_ctx->dev;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	atomic_set(&pcdev->busy, 0);
 
@@ -225,7 +225,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 				  int do_callback)
 {
 	struct deinterlace_q_data *s_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct deinterlace_dev *pcdev = ctx->dev;
 	struct dma_chan *chan = pcdev->dma_chan;
 	struct dma_device *dmadev = chan->device;
@@ -827,14 +827,14 @@ static int deinterlace_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int deinterlace_buf_prepare(struct vb2_buffer *vb)
+static int deinterlace_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct deinterlace_q_data *q_data;
 
-	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+	dprintk(ctx->dev, "type: %d\n", vb->vb2.vb2_queue->type);
 
-	q_data = get_q_data(vb->vb2_queue->type);
+	q_data = get_q_data(vb->vb2.vb2_queue->type);
 
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
@@ -847,9 +847,9 @@ static int deinterlace_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void deinterlace_buf_queue(struct vb2_buffer *vb)
+static void deinterlace_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index dd5b141..7ca83ba 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -212,11 +212,11 @@ struct yuv_pointer_t {
 
 /*
  * Our buffer type for working with videobuf2.  Note that the vb2
- * developers have decreed that struct vb2_buffer must be at the
+ * developers have decreed that struct vb2_v4l2_buffer must be at the
  * beginning of this structure.
  */
 struct mcam_vb_buffer {
-	struct vb2_buffer vb_buf;
+	struct vb2_v4l2_buffer vb_buf;
 	struct list_head queue;
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
@@ -224,7 +224,7 @@ struct mcam_vb_buffer {
 	struct yuv_pointer_t yuv_p;
 };
 
-static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
+static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct mcam_vb_buffer, vb_buf);
 }
@@ -233,7 +233,7 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
  * Hand a completed buffer back to user space.
  */
 static void mcam_buffer_done(struct mcam_camera *cam, int frame,
-		struct vb2_buffer *vbuf)
+		struct vb2_v4l2_buffer *vbuf)
 {
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
 	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
@@ -532,7 +532,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 	dma_addr_t dma_handle;
 	u32 pixel_count = fmt->width * fmt->height;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * If there are no available buffers, go into single mode
@@ -1085,10 +1085,10 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 }
 
 
-static void mcam_vb_buf_queue(struct vb2_buffer *vb)
+static void mcam_vb_buf_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned long flags;
 	int start;
 
@@ -1181,10 +1181,10 @@ static const struct vb2_ops mcam_vb2_ops = {
  * Scatter/gather mode uses all of the above functions plus a
  * few extras to deal with DMA mapping.
  */
-static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
+static int mcam_vb_sg_buf_init(struct vb2_v4l2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
 	mvb->dma_desc = dma_alloc_coherent(cam->dev,
@@ -1197,7 +1197,7 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
+static int mcam_vb_sg_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
@@ -1213,9 +1213,9 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
+static void mcam_vb_sg_buf_cleanup(struct vb2_v4l2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index aa0c6ea..81e0b5f 100644
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
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 87314b7..8e52a0d 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -289,7 +289,7 @@ static void emmaprp_device_run(void *priv)
 {
 	struct emmaprp_ctx *ctx = priv;
 	struct emmaprp_q_data *s_q_data, *d_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct emmaprp_dev *pcdev = ctx->dev;
 	unsigned int s_width, s_height;
 	unsigned int d_width, d_height;
@@ -351,7 +351,7 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 {
 	struct emmaprp_dev *pcdev = data;
 	struct emmaprp_ctx *curr_ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 	u32 irqst;
 
@@ -718,14 +718,14 @@ static int emmaprp_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int emmaprp_buf_prepare(struct vb2_buffer *vb)
+static int emmaprp_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct emmaprp_q_data *q_data;
 
-	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+	dprintk(ctx->dev, "type: %d\n", vb->vb2.vb2_queue->type);
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	q_data = get_q_data(ctx, vb->vb2.vb2_queue->type);
 
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane"
@@ -740,9 +740,9 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void emmaprp_buf_queue(struct vb2_buffer *vb)
+static void emmaprp_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3fe9047..31fc539 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -340,9 +340,9 @@ static int isp_video_queue_setup(struct vb2_queue *queue,
 	return 0;
 }
 
-static int isp_video_buffer_prepare(struct vb2_buffer *buf)
+static int isp_video_buffer_prepare(struct vb2_v4l2_buffer *buf)
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2.vb2_queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
 	struct isp_video *video = vfh->video;
 	dma_addr_t addr;
@@ -378,9 +378,9 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
  * If the pipeline is busy, it will be restarted in the output module interrupt
  * handler.
  */
-static void isp_video_buffer_queue(struct vb2_buffer *buf)
+static void isp_video_buffer_queue(struct vb2_v4l2_buffer *buf)
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2.vb2_queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
 	struct isp_video *video = vfh->video;
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4071dd7..bcf0e0a 100644
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
@@ -122,7 +122,7 @@ static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
  * @dma: DMA address
  */
 struct isp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head irqlist;
 	dma_addr_t dma;
 };
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 54479d6..defbd8d 100644
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
@@ -239,7 +239,7 @@ static int camif_stop_capture(struct camif_vp *vp)
 	return camif_reinitialize(vp);
 }
 
-static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer *vb,
+static int camif_prepare_addr(struct camif_vp *vp, struct vb2_v4l2_buffer *vb,
 			      struct camif_addr *paddr)
 {
 	struct camif_frame *frame = &vp->out_frame;
@@ -474,9 +474,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
+	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	if (vp->out_fmt == NULL)
 		return -EINVAL;
@@ -491,10 +491,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct camif_buffer *buf = container_of(vb, struct camif_buffer, vb);
-	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
+	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct camif_dev *camif = vp->camif;
 	unsigned long flags;
 
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 2d5bd3a..47f6653 100644
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
index 35d2fcd..adaf196 100644
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
@@ -322,7 +322,7 @@ struct camif_addr {
  * @index: an identifier of this buffer at the DMA engine
  */
 struct camif_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	struct camif_addr paddr;
 	unsigned int index;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index ec3e124..d9f2351 100644
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
@@ -121,10 +121,10 @@ static int g2d_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int g2d_buf_prepare(struct vb2_buffer *vb)
+static int g2d_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct g2d_frame *f = get_frame(ctx, vb->vb2_queue->type);
+	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
+	struct g2d_frame *f = get_frame(ctx, vb->vb2.vb2_queue->type);
 
 	if (IS_ERR(f))
 		return PTR_ERR(f);
@@ -132,9 +132,9 @@ static int g2d_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void g2d_buf_queue(struct vb2_buffer *vb)
+static void g2d_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
@@ -496,7 +496,7 @@ static void device_run(void *prv)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 	unsigned long flags;
 	u32 cmd = 0;
 
@@ -537,7 +537,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 {
 	struct g2d_dev *dev = prv;
 	struct g2d_ctx *ctx = dev->curr;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 
 	g2d_clear_int(dev);
 	clk_disable(dev->gate);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a1fb7e6..d8cb918 100644
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
@@ -1763,7 +1763,7 @@ static void s5p_jpeg_device_run(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long src_addr, dst_addr, flags;
 
 	spin_lock_irqsave(&ctx->jpeg->slock, flags);
@@ -1844,7 +1844,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr;
 	u32 pix_size, padding_bytes = 0;
 
@@ -1881,7 +1881,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -1948,7 +1948,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr;
 	u32 pix_size;
 
@@ -1980,7 +1980,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -2149,12 +2149,12 @@ static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
+static int s5p_jpeg_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct s5p_jpeg_q_data *q_data = NULL;
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	q_data = get_q_data(ctx, vb->vb2.vb2_queue->type);
 	BUG_ON(q_data == NULL);
 
 	if (vb2_plane_size(vb, 0) < q_data->size) {
@@ -2169,12 +2169,12 @@ static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
+static void s5p_jpeg_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	if (ctx->mode == S5P_JPEG_DECODE &&
-	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+	    vb->vb2.vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		struct s5p_jpeg_q_data tmp, *q_data;
 		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
 		     (unsigned long)vb2_plane_vaddr(vb, 0),
@@ -2265,7 +2265,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 {
 	struct s5p_jpeg *jpeg = dev_id;
 	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool enc_jpeg_too_large = false;
@@ -2322,7 +2322,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 {
 	unsigned int int_status;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	struct s5p_jpeg *jpeg = priv;
 	struct s5p_jpeg_ctx *curr_ctx;
 	unsigned long payload_size = 0;
@@ -2384,7 +2384,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 {
 	struct s5p_jpeg *jpeg = dev_id;
 	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool interrupt_timeout = false;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 61e4540..5600dcd 100644
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
index 24262bb..e8740fa 100644
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
 
@@ -180,7 +180,7 @@ struct s5p_mfc_ctx;
  */
 struct s5p_mfc_buf {
 	struct list_head list;
-	struct vb2_buffer *b;
+	struct vb2_v4l2_buffer *b;
 	union {
 		struct {
 			size_t luma;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index aebe4fd..ff8567f 100644
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
@@ -943,9 +943,9 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+static int s5p_mfc_buf_init(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	unsigned int i;
 
@@ -1056,9 +1056,9 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 }
 
 
-static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+static void s5p_mfc_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long flags;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e65993f..c2aab57 100644
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
@@ -1789,13 +1789,13 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
+static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_v4l2_buffer *vb)
 {
 	int i;
 
 	if (!fmt)
 		return -EINVAL;
-	if (fmt->num_planes != vb->num_planes) {
+	if (fmt->num_planes != vb->vb2.num_planes) {
 		mfc_err("invalid plane number for the format\n");
 		return -EINVAL;
 	}
@@ -1866,9 +1866,9 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+static int s5p_mfc_buf_init(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	unsigned int i;
 	int ret;
@@ -1900,9 +1900,9 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
+static int s5p_mfc_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	int ret;
 
@@ -1997,9 +1997,9 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 }
 
-static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+static void s5p_mfc_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long flags;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index b09bcd1..c64ff34 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1476,7 +1476,7 @@ static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
+		for (i = 0; i < b->b->vb2.num_planes; i++)
 			vb2_set_plane_payload(b->b, i, 0);
 		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index cefad18..75e875f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1834,7 +1834,7 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
+		for (i = 0; i < b->b->vb2.num_planes; i++)
 			vb2_set_plane_payload(b->b, i, 0);
 		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index fb2acc5..be7ed5f 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -24,7 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <media/v4l2-device.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "regs-mixer.h"
 
@@ -113,7 +113,7 @@ struct mxr_geometry {
 /** instance of a buffer */
 struct mxr_buffer {
 	/** common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	/** node for layer's lists */
 	struct list_head	list;
 };
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 72d4f2e..e7ca9cd 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -912,10 +912,10 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	return 0;
 }
 
-static void buf_queue(struct vb2_buffer *vb)
+static void buf_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
-	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
+	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
 
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 2554f37..1c9028c 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -243,8 +243,8 @@ static void sh_veu_job_abort(void *priv)
 }
 
 static void sh_veu_process(struct sh_veu_dev *veu,
-			   struct vb2_buffer *src_buf,
-			   struct vb2_buffer *dst_buf)
+			   struct vb2_v4l2_buffer *src_buf,
+			   struct vb2_v4l2_buffer *dst_buf)
 {
 	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 
@@ -277,7 +277,7 @@ static void sh_veu_process(struct sh_veu_dev *veu,
 static void sh_veu_device_run(void *priv)
 {
 	struct sh_veu_dev *veu = priv;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(veu->m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(veu->m2m_ctx);
@@ -908,13 +908,13 @@ static int sh_veu_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int sh_veu_buf_prepare(struct vb2_buffer *vb)
+static int sh_veu_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2_queue);
+	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct sh_veu_vfmt *vfmt;
 	unsigned int sizeimage;
 
-	vfmt = sh_veu_get_vfmt(veu, vb->vb2_queue->type);
+	vfmt = sh_veu_get_vfmt(veu, vb->vb2.vb2_queue->type);
 	sizeimage = vfmt->bytesperline * vfmt->frame.height *
 		vfmt->fmt->depth / vfmt->fmt->ydepth;
 
@@ -929,9 +929,9 @@ static int sh_veu_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void sh_veu_buf_queue(struct vb2_buffer *vb)
+static void sh_veu_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2_queue);
+	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	dev_dbg(veu->dev, "%s(%d)\n", __func__, vb->v4l2_buf.type);
 	v4l2_m2m_buf_queue(veu->m2m_ctx, vb);
 }
@@ -1082,8 +1082,8 @@ static irqreturn_t sh_veu_bh(int irq, void *dev_id)
 static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 {
 	struct sh_veu_dev *veu = dev_id;
-	struct vb2_buffer *dst;
-	struct vb2_buffer *src;
+	struct vb2_v4l2_buffer *dst;
+	struct vb2_v4l2_buffer *src;
 	u32 status = sh_veu_reg_read(veu, VEU_EVTR);
 
 	/* bundle read mode not used */
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index c835beb..bb66058 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -59,7 +59,7 @@ struct isi_dma_desc {
 
 /* Frame buffer data */
 struct frame_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct isi_dma_desc *p_dma_desc;
 	struct list_head list;
 };
@@ -153,7 +153,7 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 {
 	if (isi->active) {
-		struct vb2_buffer *vb = &isi->active->vb;
+		struct vb2_v4l2_buffer *vb = &isi->active->vb;
 		struct frame_buffer *buf = isi->active;
 
 		list_del_init(&buf->list);
@@ -267,7 +267,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static int buffer_init(struct vb2_v4l2_buffer *vb)
 {
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
 
@@ -277,9 +277,9 @@ static int buffer_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
@@ -319,9 +319,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_cleanup(struct vb2_buffer *vb)
+static void buffer_cleanup(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
@@ -360,9 +360,9 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 	isi_writel(isi, ISI_CFG1, cfg1);
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
@@ -373,7 +373,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	if (isi->active == NULL) {
 		isi->active = buf;
-		if (vb2_is_streaming(vb->vb2_queue))
+		if (vb2_is_streaming(vb->vb2.vb2_queue))
 			start_dma(isi, buf);
 	}
 	spin_unlock_irqrestore(&isi->lock, flags);
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 192377f..4022aeb 100644
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
@@ -225,7 +225,7 @@ struct mx2_buf_internal {
 /* buffer for one video frame */
 struct mx2_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer		vb;
 	struct mx2_buf_internal		internal;
 };
 
@@ -498,9 +498,9 @@ static int mx2_videobuf_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int mx2_videobuf_prepare(struct vb2_buffer *vb)
+static int mx2_videobuf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	int ret = 0;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
@@ -528,7 +528,7 @@ out:
 	return ret;
 }
 
-static void mx2_videobuf_queue(struct vb2_buffer *vb)
+static void mx2_videobuf_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici =
@@ -650,7 +650,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct mx2_buffer *buf;
 	unsigned long phys;
 	int bytesperline;
@@ -1293,7 +1293,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 #endif
 	struct mx2_buf_internal *ibuf;
 	struct mx2_buffer *buf;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long phys;
 
 	ibuf = list_first_entry(&pcdev->active_bufs, struct mx2_buf_internal,
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 3435fd2..e747440 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -63,7 +63,7 @@
 
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer			vb;
+	struct vb2_v4l2_buffer			vb;
 	struct list_head			queue;
 
 	/* One descriptot per scatterlist (per frame) */
@@ -133,7 +133,7 @@ static void csi_reg_write(struct mx3_camera_dev *mx3, u32 value, off_t reg)
 	__raw_writel(value, mx3->base + reg);
 }
 
-static struct mx3_camera_buffer *to_mx3_vb(struct vb2_buffer *vb)
+static struct mx3_camera_buffer *to_mx3_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct mx3_camera_buffer, vb);
 }
@@ -151,7 +151,7 @@ static void mx3_cam_dma_done(void *arg)
 
 	spin_lock(&mx3_cam->lock);
 	if (mx3_cam->active) {
-		struct vb2_buffer *vb = &mx3_cam->active->vb;
+		struct vb2_v4l2_buffer *vb = &mx3_cam->active->vb;
 		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
 		list_del_init(&buf->queue);
@@ -255,9 +255,9 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 	}
 }
 
-static void mx3_videobuf_queue(struct vb2_buffer *vb)
+static void mx3_videobuf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
@@ -355,9 +355,9 @@ error:
 	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 }
 
-static void mx3_videobuf_release(struct vb2_buffer *vb)
+static void mx3_videobuf_release(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
@@ -388,9 +388,9 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 	mx3_cam->buf_total -= vb2_plane_size(vb, 0);
 }
 
-static int mx3_videobuf_init(struct vb2_buffer *vb)
+static int mx3_videobuf_init(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 279ab9f..7a4c3c6 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -475,7 +475,7 @@ struct rcar_vin_priv {
 	struct soc_camera_host		ici;
 	struct list_head		capture;
 #define MAX_BUFFER_NUM			3
-	struct vb2_buffer		*queue_buf[MAX_BUFFER_NUM];
+	struct vb2_v4l2_buffer		*queue_buf[MAX_BUFFER_NUM];
 	struct vb2_alloc_ctx		*alloc_ctx;
 	enum v4l2_field			field;
 	unsigned int			pdata_flags;
@@ -489,11 +489,11 @@ struct rcar_vin_priv {
 #define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)
 
 struct rcar_vin_buffer {
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer		vb;
 	struct list_head		list;
 };
 
-#define to_buf_list(vb2_buffer)	(&container_of(vb2_buffer, \
+#define to_buf_list(vb2_v4l2_buffer)	(&container_of(vb2_v4l2_buffer, \
 						       struct rcar_vin_buffer, \
 						       vb)->list)
 
@@ -736,7 +736,7 @@ static int rcar_vin_hw_ready(struct rcar_vin_priv *priv)
 /* Moves a buffer from the queue to the HW slots */
 static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	dma_addr_t phys_addr_top;
 	int slot;
 
@@ -757,9 +757,9 @@ static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 	return 1;
 }
 
-static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
+static void rcar_vin_videobuf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2.vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
 	unsigned long size;
@@ -949,7 +949,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int i;
 
 	/* disable capture, disable interrupts */
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 9ce202f..7c05ab1 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -93,7 +93,7 @@
 
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
-	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct vb2_v4l2_buffer vb; /* v4l buffer must be first */
 	struct list_head queue;
 };
 
@@ -112,7 +112,7 @@ struct sh_mobile_ceu_dev {
 
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
-	struct vb2_buffer *active;
+	struct vb2_v4l2_buffer *active;
 	struct vb2_alloc_ctx *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
@@ -152,7 +152,7 @@ struct sh_mobile_ceu_cam {
 	u32 code;
 };
 
-static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_buffer *vb)
+static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct sh_mobile_ceu_buffer, vb);
 }
@@ -367,7 +367,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	return ret;
 }
 
-static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
+static int sh_mobile_ceu_videobuf_prepare(struct vb2_v4l2_buffer *vb)
 {
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 
@@ -377,9 +377,9 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
+static void sh_mobile_ceu_videobuf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = container_of(vb->vb2.vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
@@ -427,9 +427,9 @@ error:
 	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 }
 
-static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
+static void sh_mobile_ceu_videobuf_release(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = container_of(vb->vb2.vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
@@ -456,9 +456,9 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	spin_unlock_irq(&pcdev->lock);
 }
 
-static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
+static int sh_mobile_ceu_videobuf_init(struct vb2_v4l2_buffer *vb)
 {
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_device *icd = container_of(vb->vb2.vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
@@ -504,7 +504,7 @@ static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 {
 	struct sh_mobile_ceu_dev *pcdev = data;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	spin_lock(&pcdev->lock);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 66634b4..5f2db3d 100644
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
index c44760b..568c716 100644
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
@@ -384,8 +384,8 @@ struct vpe_ctx {
 	unsigned int		bufs_completed;		/* bufs done in this batch */
 
 	struct vpe_q_data	q_data[2];		/* src & dst queue data */
-	struct vb2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
-	struct vb2_buffer	*dst_vb;
+	struct vb2_v4l2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
+	struct vb2_v4l2_buffer	*dst_vb;
 
 	dma_addr_t		mv_buf_dma[2];		/* dma addrs of motion vector in/out bufs */
 	void			*mv_buf[2];		/* virtual addrs of motion vector bufs */
@@ -988,7 +988,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_DST];
 	const struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->dst_vb;
+	struct vb2_v4l2_buffer *vb = ctx->dst_vb;
 	struct vpe_fmt *fmt = q_data->fmt;
 	const struct vpdma_data_format *vpdma_fmt;
 	int mv_buf_selector = !ctx->src_mv_buf_selector;
@@ -1025,7 +1025,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_SRC];
 	const struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->src_vbs[p_data->vb_index];
+	struct vb2_v4l2_buffer *vb = ctx->src_vbs[p_data->vb_index];
 	struct vpe_fmt *fmt = q_data->fmt;
 	const struct vpdma_data_format *vpdma_fmt;
 	int mv_buf_selector = ctx->src_mv_buf_selector;
@@ -1222,7 +1222,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	struct vpe_dev *dev = (struct vpe_dev *)data;
 	struct vpe_ctx *ctx;
 	struct vpe_q_data *d_q_data;
-	struct vb2_buffer *s_vb, *d_vb;
+	struct vb2_v4l2_buffer *s_vb, *d_vb;
 	struct v4l2_buffer *s_buf, *d_buf;
 	unsigned long flags;
 	u32 irqst0, irqst1;
@@ -1823,18 +1823,18 @@ static int vpe_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int vpe_buf_prepare(struct vb2_buffer *vb)
+static int vpe_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vpe_q_data *q_data;
 	int i, num_planes;
 
-	vpe_dbg(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+	vpe_dbg(ctx->dev, "type: %d\n", vb->vb2.vb2_queue->type);
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	q_data = get_q_data(ctx, vb->vb2.vb2_queue->type);
 	num_planes = q_data->fmt->coplanar ? 2 : 1;
 
-	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+	if (vb->vb2.vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (!(q_data->flags & Q_DATA_INTERLACED)) {
 			vb->v4l2_buf.field = V4L2_FIELD_NONE;
 		} else {
@@ -1860,9 +1860,9 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vpe_buf_queue(struct vb2_buffer *vb)
+static void vpe_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d9d844a..6e0560d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -200,8 +200,8 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 
 
 static int device_process(struct vim2m_ctx *ctx,
-			  struct vb2_buffer *in_vb,
-			  struct vb2_buffer *out_vb)
+			  struct vb2_v4l2_buffer *in_vb,
+			  struct vb2_v4l2_buffer *out_vb)
 {
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data;
@@ -377,7 +377,7 @@ static void device_run(void *priv)
 {
 	struct vim2m_ctx *ctx = priv;
 	struct vim2m_dev *dev = ctx->dev;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -392,7 +392,7 @@ static void device_isr(unsigned long priv)
 {
 	struct vim2m_dev *vim2m_dev = (struct vim2m_dev *)priv;
 	struct vim2m_ctx *curr_ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 
 	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
@@ -741,15 +741,15 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int vim2m_buf_prepare(struct vb2_buffer *vb)
+static int vim2m_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vim2m_q_data *q_data;
 
-	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+	dprintk(ctx->dev, "type: %d\n", vb->vb2.vb2_queue->type);
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
-	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+	q_data = get_q_data(ctx, vb->vb2.vb2_queue->type);
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2.vb2_queue->type)) {
 		if (vb->v4l2_buf.field == V4L2_FIELD_ANY)
 			vb->v4l2_buf.field = V4L2_FIELD_NONE;
 		if (vb->v4l2_buf.field != V4L2_FIELD_NONE) {
@@ -770,9 +770,9 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vim2m_buf_queue(struct vb2_buffer *vb)
+static void vim2m_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
@@ -789,7 +789,7 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long flags;
 
 	for (;;) {
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 4b497df..4c31d84 100644
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
@@ -92,7 +92,7 @@ extern struct vivid_fmt vivid_formats[];
 /* buffer for one video frame */
 struct vivid_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 };
 
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 4af55f1..af9de57 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -200,9 +200,9 @@ static int sdr_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	return 0;
 }
 
-static int sdr_cap_buf_prepare(struct vb2_buffer *vb)
+static int sdr_cap_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned size = SDR_CAP_SAMPLES_PER_BUF * 2;
 
 	dprintk(dev, 1, "%s\n", __func__);
@@ -225,9 +225,9 @@ static int sdr_cap_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void sdr_cap_buf_queue(struct vb2_buffer *vb)
+static void sdr_cap_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index ef81b01..a994484 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -157,11 +157,11 @@ static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	return 0;
 }
 
-static int vbi_cap_buf_prepare(struct vb2_buffer *vb)
+static int vbi_cap_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
-	unsigned size = vb->vb2_queue->type == V4L2_BUF_TYPE_SLICED_VBI_CAPTURE ?
+	unsigned size = vb->vb2.vb2_queue->type == V4L2_BUF_TYPE_SLICED_VBI_CAPTURE ?
 		36 * sizeof(struct v4l2_sliced_vbi_data) :
 		1440 * 2 * (is_60hz ? 12 : 18);
 
@@ -185,9 +185,9 @@ static int vbi_cap_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vbi_cap_buf_queue(struct vb2_buffer *vb)
+static void vbi_cap_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 4e4c70e..6d41855 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -49,11 +49,11 @@ static int vbi_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	return 0;
 }
 
-static int vbi_out_buf_prepare(struct vb2_buffer *vb)
+static int vbi_out_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	bool is_60hz = dev->std_out & V4L2_STD_525_60;
-	unsigned size = vb->vb2_queue->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT ?
+	unsigned size = vb->vb2.vb2_queue->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT ?
 		36 * sizeof(struct v4l2_sliced_vbi_data) :
 		1440 * 2 * (is_60hz ? 12 : 18);
 
@@ -77,9 +77,9 @@ static int vbi_out_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vbi_out_buf_queue(struct vb2_buffer *vb)
+static void vbi_out_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 867a29a..8dba4b5 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -164,9 +164,9 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	return 0;
 }
 
-static int vid_cap_buf_prepare(struct vb2_buffer *vb)
+static int vid_cap_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned long size;
 	unsigned planes = tpg_g_planes(&dev->tpg);
 	unsigned p;
@@ -201,9 +201,9 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vid_cap_buf_finish(struct vb2_buffer *vb)
+static void vid_cap_buf_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct v4l2_timecode *tc = &vb->v4l2_buf.timecode;
 	unsigned fps = 25;
 	unsigned seq = vb->v4l2_buf.sequence;
@@ -226,9 +226,9 @@ static void vid_cap_buf_finish(struct vb2_buffer *vb)
 	tc->hours = (seq / (60 * 60 * fps)) % 24;
 }
 
-static void vid_cap_buf_queue(struct vb2_buffer *vb)
+static void vid_cap_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 39ff79f..251d02b 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -110,9 +110,9 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	return 0;
 }
 
-static int vid_out_buf_prepare(struct vb2_buffer *vb)
+static int vid_out_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned long size;
 	unsigned planes = dev->fmt_out->planes;
 	unsigned p;
@@ -151,9 +151,9 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vid_out_buf_queue(struct vb2_buffer *vb)
+static void vid_out_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 3294529..a6344df 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -200,10 +200,10 @@ static void rpf_vdev_queue(struct vsp1_video *video,
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
 		       buf->addr[0] + rpf->offsets[0]);
-	if (buf->buf.num_planes > 1)
+	if (buf->buf.vb2.num_planes > 1)
 		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
 			       buf->addr[1] + rpf->offsets[1]);
-	if (buf->buf.num_planes > 2)
+	if (buf->buf.vb2.num_planes > 2)
 		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
 			       buf->addr[2] + rpf->offsets[1]);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d91f19a..0983ea6 100644
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
@@ -600,7 +600,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	done->buf.v4l2_buf.sequence = video->sequence++;
 	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
-	for (i = 0; i < done->buf.num_planes; ++i)
+	for (i = 0; i < done->buf.vb2.num_planes; ++i)
 		vb2_set_plane_payload(&done->buf, i, done->length[i]);
 	vb2_buffer_done(&done->buf, VB2_BUF_STATE_DONE);
 
@@ -739,17 +739,17 @@ vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
+static int vsp1_video_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
 	const struct v4l2_pix_format_mplane *format = &video->format;
 	unsigned int i;
 
-	if (vb->num_planes < format->num_planes)
+	if (vb->vb2.num_planes < format->num_planes)
 		return -EINVAL;
 
-	for (i = 0; i < vb->num_planes; ++i) {
+	for (i = 0; i < vb->vb2.num_planes; ++i) {
 		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
 		buf->length[i] = vb2_plane_size(vb, i);
 
@@ -760,9 +760,9 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
+static void vsp1_video_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
 	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
 	unsigned long flags;
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index fd2851a..199c289 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -18,7 +18,7 @@
 #include <linux/wait.h>
 
 #include <media/media-entity.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 struct vsp1_video;
 
@@ -94,7 +94,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	dma_addr_t addr[3];
@@ -102,7 +102,7 @@ struct vsp1_video_buffer {
 };
 
 static inline struct vsp1_video_buffer *
-to_vsp1_video_buffer(struct vb2_buffer *vb)
+to_vsp1_video_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vsp1_video_buffer, buf);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 1d2b3a2..84ddefd 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -201,9 +201,9 @@ static void wpf_vdev_queue(struct vsp1_video *video,
 	struct vsp1_rwpf *wpf = container_of(video, struct vsp1_rwpf, video);
 
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, buf->addr[0]);
-	if (buf->buf.num_planes > 1)
+	if (buf->buf.vb2.num_planes > 1)
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, buf->addr[1]);
-	if (buf->buf.num_planes > 2)
+	if (buf->buf.vb2.num_planes > 2)
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, buf->addr[2]);
 }
 
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 4069234..d5b9f0d 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -97,7 +97,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct airspy_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -503,9 +503,9 @@ static int airspy_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void airspy_buf_queue(struct vb2_buffer *vb)
+static void airspy_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct airspy *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct airspy *s = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct airspy_frame_buf *buf =
 			container_of(vb, struct airspy_frame_buf, vb);
 	unsigned long flags;
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index f67247c..2225e8a 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -49,9 +49,9 @@ static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int vbi_buffer_prepare(struct vb2_buffer *vb)
+static int vbi_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
 	unsigned long size;
 
@@ -68,9 +68,9 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 }
 
 static void
-vbi_buffer_queue(struct vb2_buffer *vb)
+vbi_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
 	struct au0828_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index a27cb5f..c5aea1f 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -664,10 +664,10 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 }
 
 static int
-buffer_prepare(struct vb2_buffer *vb)
+buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
-	struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	buf->length = dev->height * dev->bytesperline;
 
@@ -681,12 +681,12 @@ buffer_prepare(struct vb2_buffer *vb)
 }
 
 static void
-buffer_queue(struct vb2_buffer *vb)
+buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct au0828_buffer    *buf     = container_of(vb,
 							struct au0828_buffer,
 							vb);
-	struct au0828_dev       *dev     = vb2_get_drv_priv(vb->vb2_queue);
+	struct au0828_dev       *dev     = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct au0828_dmaqueue  *vidq    = &dev->vidq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index eb15187..8b9df1c 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -167,7 +167,7 @@ struct au0828_usb_isoc_ctl {
 /* buffer for one video frame */
 struct au0828_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 744e7ed..e73cea8 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -57,9 +57,9 @@ static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int vbi_buffer_prepare(struct vb2_buffer *vb)
+static int vbi_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct em28xx        *dev  = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx        *dev  = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct em28xx_v4l2   *v4l2 = dev->v4l2;
 	struct em28xx_buffer *buf  = container_of(vb, struct em28xx_buffer, vb);
 	unsigned long        size;
@@ -77,9 +77,9 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 }
 
 static void
-vbi_buffer_queue(struct vb2_buffer *vb)
+vbi_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
 	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9ecf656..907272f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -899,9 +899,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 }
 
 static int
-buffer_prepare(struct vb2_buffer *vb)
+buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct em28xx_v4l2   *v4l2 = dev->v4l2;
 	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
 	unsigned long size;
@@ -1041,9 +1041,9 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 }
 
 static void
-buffer_queue(struct vb2_buffer *vb)
+buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct em28xx *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
 	struct em28xx_dmaqueue *vidq = &dev->vidq;
 	unsigned long flags = 0;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 9c70753..251d050 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -263,7 +263,7 @@ struct em28xx_fmt {
 /* buffer for one video frame */
 struct em28xx_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
index 2251c3f..745185e 100644
--- a/drivers/media/usb/go7007/go7007-priv.h
+++ b/drivers/media/usb/go7007/go7007-priv.h
@@ -20,7 +20,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 struct go7007;
 
@@ -136,7 +136,7 @@ struct go7007_hpi_ops {
 #define	GO7007_BUF_SIZE		(GO7007_BUF_PAGES << PAGE_SHIFT)
 
 struct go7007_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	unsigned int frame_offset;
 	u32 modet_active;
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index d6bf982..c16ff31 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -380,9 +380,9 @@ static int go7007_queue_setup(struct vb2_queue *q,
 	return 0;
 }
 
-static void go7007_buf_queue(struct vb2_buffer *vb)
+static void go7007_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
 	struct go7007_buffer *go7007_vb =
 		container_of(vb, struct go7007_buffer, vb);
@@ -393,7 +393,7 @@ static void go7007_buf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&go->spinlock, flags);
 }
 
-static int go7007_buf_prepare(struct vb2_buffer *vb)
+static int go7007_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
 	struct go7007_buffer *go7007_vb =
 		container_of(vb, struct go7007_buffer, vb);
@@ -404,9 +404,9 @@ static int go7007_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void go7007_buf_finish(struct vb2_buffer *vb)
+static void go7007_buf_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *vq = vb->vb2_queue;
+	struct vb2_queue *vq = vb->vb2.vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
 	struct go7007_buffer *go7007_vb =
 		container_of(vb, struct go7007_buffer, vb);
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index fd1fa41..6037040 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -85,7 +85,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct hackrf_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -481,9 +481,9 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void hackrf_buf_queue(struct vb2_buffer *vb)
+static void hackrf_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct hackrf_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct hackrf_dev *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct hackrf_frame_buf *buf =
 			container_of(vb, struct hackrf_frame_buf, vb);
 	unsigned long flags;
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index efc761c..4ed8675 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -115,7 +115,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct msi2500_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -629,9 +629,9 @@ static int msi2500_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void msi2500_buf_queue(struct vb2_buffer *vb)
+static void msi2500_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct msi2500_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi2500_state *s = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct msi2500_frame_buf *buf =
 			container_of(vb, struct msi2500_frame_buf, vb);
 	unsigned long flags;
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 702267e..5ef46a0 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -592,7 +592,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static int buffer_init(struct vb2_v4l2_buffer *vb)
 {
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
@@ -604,9 +604,9 @@ static int buffer_init(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 
 	/* Don't allow queing new buffers after device disconnection */
 	if (!pdev->udev)
@@ -615,9 +615,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
 	if (vb->state == VB2_BUF_STATE_DONE) {
@@ -625,22 +625,22 @@ static void buffer_finish(struct vb2_buffer *vb)
 		 * Application has called dqbuf and is getting back a buffer
 		 * we've filled, take the pwc data we've stored in buf->data
 		 * and decompress it into a usable format, storing the result
-		 * in the vb2_buffer.
+		 * in the vb2_v4l2_buffer.
 		 */
 		pwc_decompress(pdev, buf);
 	}
 }
 
-static void buffer_cleanup(struct vb2_buffer *vb)
+static void buffer_cleanup(struct vb2_v4l2_buffer *vb)
 {
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
 	vfree(buf->data);
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/pwc/pwc.h b/drivers/media/usb/pwc/pwc.h
index 81b017a..e2c12dc 100644
--- a/drivers/media/usb/pwc/pwc.h
+++ b/drivers/media/usb/pwc/pwc.h
@@ -210,7 +210,7 @@ struct pwc_raw_frame {
 /* intermediate buffers with raw data from the USB cam */
 struct pwc_frame_buf
 {
-	struct vb2_buffer vb;	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;	/* common v4l buffer stuff -- must be first */
 	struct list_head list;
 	void *data;
 	int filled;		/* number of bytes filled */
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 0f3c34d..110c932 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -293,7 +293,7 @@ struct s2255_fmt {
 /* buffer for one video frame */
 struct s2255_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -671,9 +671,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb)
+static int buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
+	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	int w = vc->width;
 	int h = vc->height;
@@ -700,10 +700,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
-	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
+	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	unsigned long flags = 0;
 	dprintk(vc->dev, 1, "%s\n", __func__);
 	spin_lock_irqsave(&vc->qlock, flags);
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 65a326c..3ee5cd9 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -538,10 +538,10 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
 	return 0;
 }
 
-static void buffer_queue(struct vb2_buffer *vb)
+static void buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	unsigned long flags;
-	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct stk1160_buffer *buf =
 		container_of(vb, struct stk1160_buffer, vb);
 
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index abdea48..11c8239 100644
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
 
@@ -78,7 +78,7 @@
 /* Buffer for one video frame */
 struct stk1160_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 9d3525f..51d9437 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -29,7 +29,7 @@
  */
 
 #include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 #include "usbtv.h"
 
@@ -612,9 +612,9 @@ static int usbtv_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void usbtv_buf_queue(struct vb2_buffer *vb)
+static void usbtv_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct usbtv *usbtv = vb2_get_drv_priv(vb->vb2_queue);
+	struct usbtv *usbtv = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct usbtv_buf *buf = container_of(vb, struct usbtv_buf, vb);
 	unsigned long flags;
 
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 9681195..a1a4d95 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -61,7 +61,7 @@ struct usbtv_norm_params {
 
 /* A single videobuf2 frame buffer. */
 struct usbtv_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 10c554e..8b52fd2 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -87,9 +87,9 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int uvc_buffer_prepare(struct vb2_buffer *vb)
+static int uvc_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
 	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
@@ -113,9 +113,9 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void uvc_buffer_queue(struct vb2_buffer *vb)
+static void uvc_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 	unsigned long flags;
 
@@ -133,13 +133,13 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
-static void uvc_buffer_finish(struct vb2_buffer *vb)
+static void uvc_buffer_finish(struct vb2_v4l2_buffer *vb)
 {
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2.vb2_queue);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
-	if (vb->state == VB2_BUF_STATE_DONE)
+	if (vb->vb2.state == VB2_BUF_STATE_DONE)
 		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
 }
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c63e5b5..e4525bf 100644
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
@@ -354,7 +354,7 @@ enum uvc_buffer_state {
 };
 
 struct uvc_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	enum uvc_buffer_state state;
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 63d29f2..bd9a6ef 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-v4l2.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b084072..1bab53e 100644
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
index 80c588f..3392a58 100644
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
@@ -739,13 +739,13 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
  *
  * Call from buf_queue(), videobuf_queue_ops callback.
  */
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb)
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_v4l2_buffer *vb)
 {
 	struct v4l2_m2m_buffer *b = container_of(vb, struct v4l2_m2m_buffer, vb);
 	struct v4l2_m2m_queue_ctx *q_ctx;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2_queue->type);
+	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2.vb2_queue->type);
 	if (!q_ctx)
 		return;
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index cc16e76..0d8bd9a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -51,12 +51,12 @@ module_param(debug, int, 0644);
 
 #define log_memop(vb, op)						\
 	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
-		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
+		(vb)->vb2.vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2.vb2_queue->mem_ops->op ? "" : " (nop)")
 
 #define call_memop(vb, op, args...)					\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
 	int err;							\
 									\
 	log_memop(vb, op);						\
@@ -68,7 +68,7 @@ module_param(debug, int, 0644);
 
 #define call_ptr_memop(vb, op, args...)					\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
 	void *ptr;							\
 									\
 	log_memop(vb, op);						\
@@ -80,7 +80,7 @@ module_param(debug, int, 0644);
 
 #define call_void_memop(vb, op, args...)				\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
 									\
 	log_memop(vb, op);						\
 	if (_q->mem_ops->op)						\
@@ -113,16 +113,16 @@ module_param(debug, int, 0644);
 
 #define log_vb_qop(vb, op, args...)					\
 	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
-		(vb)->vb2_queue->ops->op ? "" : " (nop)")
+		(vb)->vb2.vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2.vb2_queue->ops->op ? "" : " (nop)")
 
 #define call_vb_qop(vb, op, args...)					\
 ({									\
 	int err;							\
 									\
 	log_vb_qop(vb, op);						\
-	err = (vb)->vb2_queue->ops->op ?				\
-		(vb)->vb2_queue->ops->op(args) : 0;			\
+	err = (vb)->vb2.vb2_queue->ops->op ?				\
+		(vb)->vb2.vb2_queue->ops->op(args) : 0;			\
 	if (!err)							\
 		(vb)->cnt_ ## op++;					\
 	err;								\
@@ -131,25 +131,25 @@ module_param(debug, int, 0644);
 #define call_void_vb_qop(vb, op, args...)				\
 ({									\
 	log_vb_qop(vb, op);						\
-	if ((vb)->vb2_queue->ops->op)					\
-		(vb)->vb2_queue->ops->op(args);				\
+	if ((vb)->vb2.vb2_queue->ops->op)					\
+		(vb)->vb2.vb2_queue->ops->op(args);				\
 	(vb)->cnt_ ## op++;						\
 })
 
 #else
 
 #define call_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : 0)
+	((vb)->vb2.vb2_queue->mem_ops->op ?					\
+		(vb)->vb2.vb2_queue->mem_ops->op(args) : 0)
 
 #define call_ptr_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : NULL)
+	((vb)->vb2.vb2_queue->mem_ops->op ?					\
+		(vb)->vb2.vb2_queue->mem_ops->op(args) : NULL)
 
 #define call_void_memop(vb, op, args...)				\
 	do {								\
-		if ((vb)->vb2_queue->mem_ops->op)			\
-			(vb)->vb2_queue->mem_ops->op(args);		\
+		if ((vb)->vb2.vb2_queue->mem_ops->op)			\
+			(vb)->vb2.vb2_queue->mem_ops->op(args);		\
 	} while (0)
 
 #define call_qop(q, op, args...)					\
@@ -162,12 +162,12 @@ module_param(debug, int, 0644);
 	} while (0)
 
 #define call_vb_qop(vb, op, args...)					\
-	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
+	((vb)->vb2.vb2_queue->ops->op ? (vb)->vb2.vb2_queue->ops->op(args) : 0)
 
 #define call_void_vb_qop(vb, op, args...)				\
 	do {								\
-		if ((vb)->vb2_queue->ops->op)				\
-			(vb)->vb2_queue->ops->op(args);			\
+		if ((vb)->vb2.vb2_queue->ops->op)				\
+			(vb)->vb2.vb2_queue->ops->op(args);			\
 	} while (0)
 
 #endif
@@ -186,9 +186,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
-static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
+static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
@@ -198,7 +198,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	 * Allocate memory for all planes in this buffer
 	 * NOTE: mmapped areas should be page aligned
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
@@ -207,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 			goto free;
 
 		/* Associate allocator private data with this plane */
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->vb2.planes[plane].mem_priv = mem_priv;
 		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 
@@ -215,8 +215,8 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 free:
 	/* Free already allocated memory if one of the allocations failed */
 	for (; plane > 0; --plane) {
-		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
-		vb->planes[plane - 1].mem_priv = NULL;
+		call_void_memop(vb, put, vb->vb2.planes[plane - 1].mem_priv);
+		vb->vb2.planes[plane - 1].mem_priv = NULL;
 	}
 
 	return -ENOMEM;
@@ -225,13 +225,13 @@ free:
 /**
  * __vb2_buf_mem_free() - free memory of the given buffer
  */
-static void __vb2_buf_mem_free(struct vb2_buffer *vb)
+static void __vb2_buf_mem_free(struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		call_void_memop(vb, put, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		call_void_memop(vb, put, vb->vb2.planes[plane].mem_priv);
+		vb->vb2.planes[plane].mem_priv = NULL;
 		dprintk(3, "freed plane %d of buffer %d\n", plane,
 			vb->v4l2_buf.index);
 	}
@@ -241,14 +241,14 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
  * __vb2_buf_userptr_put() - release userspace memory associated with
  * a USERPTR buffer
  */
-static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
+static void __vb2_buf_userptr_put(struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		if (vb->vb2.planes[plane].mem_priv)
+			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
+		vb->vb2.planes[plane].mem_priv = NULL;
 	}
 }
 
@@ -256,7 +256,7 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
  * __vb2_plane_dmabuf_put() - release memory associated with
  * a DMABUF shared plane
  */
-static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
+static void __vb2_plane_dmabuf_put(struct vb2_v4l2_buffer *vb, struct vb2_plane *p)
 {
 	if (!p->mem_priv)
 		return;
@@ -273,12 +273,12 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
  * __vb2_buf_dmabuf_put() - release memory associated with
  * a DMABUF shared buffer
  */
-static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
+static void __vb2_buf_dmabuf_put(struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
+		__vb2_plane_dmabuf_put(vb, &vb->vb2.planes[plane]);
 }
 
 /**
@@ -288,14 +288,14 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 static void __setup_lengths(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
 
-		for (plane = 0; plane < vb->num_planes; ++plane)
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane)
 			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 }
@@ -307,13 +307,13 @@ static void __setup_lengths(struct vb2_queue *q, unsigned int n)
 static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long off;
 
 	if (q->num_buffers) {
 		struct v4l2_plane *p;
 		vb = q->bufs[q->num_buffers - 1];
-		p = &vb->v4l2_planes[vb->num_planes - 1];
+		p = &vb->v4l2_planes[vb->vb2.num_planes - 1];
 		off = PAGE_ALIGN(p->m.mem_offset + p->length);
 	} else {
 		off = 0;
@@ -324,7 +324,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 		if (!vb)
 			continue;
 
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 			vb->v4l2_planes[plane].m.mem_offset = off;
 
 			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
@@ -347,7 +347,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes)
 {
 	unsigned int buffer;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	for (buffer = 0; buffer < num_buffers; ++buffer) {
@@ -362,9 +362,9 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
 			vb->v4l2_buf.length = num_planes;
 
-		vb->state = VB2_BUF_STATE_DEQUEUED;
-		vb->vb2_queue = q;
-		vb->num_planes = num_planes;
+		vb->vb2.state = VB2_BUF_STATE_DEQUEUED;
+		vb->vb2.vb2_queue = q;
+		vb->vb2.num_planes = num_planes;
 		vb->v4l2_buf.index = q->num_buffers + buffer;
 		vb->v4l2_buf.type = q->type;
 		vb->v4l2_buf.memory = memory;
@@ -412,7 +412,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
@@ -438,6 +438,7 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * Sanity check: when preparing a buffer the queue lock is released for
@@ -449,9 +450,11 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	 */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		if (q->bufs[buffer] == NULL)
+		vb = (struct vb2_v4l2_buffer *)q->bufs[buffer];
+
+		if (vb == NULL)
 			continue;
-		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
+		if (vb->vb2.state == VB2_BUF_STATE_PREPARING) {
 			dprintk(1, "preparing buffers, cannot free\n");
 			return -EAGAIN;
 		}
@@ -460,9 +463,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		struct vb2_buffer *vb = q->bufs[buffer];
+		vb = (struct vb2_v4l2_buffer *)q->bufs[buffer];
 
-		if (vb && vb->planes[0].mem_priv)
+		if (vb && vb->vb2.planes[0].mem_priv)
 			call_void_vb_qop(vb, buf_cleanup, vb);
 	}
 
@@ -495,38 +498,38 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		q->cnt_stop_streaming = 0;
 	}
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		struct vb2_buffer *vb = q->bufs[buffer];
-		bool unbalanced = vb->cnt_mem_alloc != vb->cnt_mem_put ||
-				  vb->cnt_mem_prepare != vb->cnt_mem_finish ||
-				  vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
-				  vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
-				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
-				  vb->cnt_buf_queue != vb->cnt_buf_done ||
-				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
-				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
+		struct vb2_v4l2_buffer *vb = q->bufs[buffer];
+		bool unbalanced = vb->vb2.cnt_mem_alloc != vb->vb2.cnt_mem_put ||
+				  vb->vb2.cnt_mem_prepare != vb->vb2.cnt_mem_finish ||
+				  vb->vb2.cnt_mem_get_userptr != vb->vb2.cnt_mem_put_userptr ||
+				  vb->vb2.cnt_mem_attach_dmabuf != vb->vb2.cnt_mem_detach_dmabuf ||
+				  vb->vb2.cnt_mem_map_dmabuf != vb->vb2.cnt_mem_unmap_dmabuf ||
+				  vb->vb2.cnt_buf_queue != vb->vb2.cnt_buf_done ||
+				  vb->vb2.cnt_buf_prepare != vb->vb2.cnt_buf_finish ||
+				  vb->vb2.cnt_buf_init != vb->vb2.cnt_buf_cleanup;
 
 		if (unbalanced || debug) {
 			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
 				q, buffer, unbalanced ? " UNBALANCED!" : "");
 			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
-				vb->cnt_buf_init, vb->cnt_buf_cleanup,
-				vb->cnt_buf_prepare, vb->cnt_buf_finish);
+				vb->vb2.cnt_buf_init, vb->vb2.cnt_buf_cleanup,
+				vb->vb2.cnt_buf_prepare, vb->vb2.cnt_buf_finish);
 			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
-				vb->cnt_buf_queue, vb->cnt_buf_done);
+				vb->vb2.cnt_buf_queue, vb->vb2.cnt_buf_done);
 			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
-				vb->cnt_mem_alloc, vb->cnt_mem_put,
-				vb->cnt_mem_prepare, vb->cnt_mem_finish,
-				vb->cnt_mem_mmap);
+				vb->vb2.cnt_mem_alloc, vb->vb2.cnt_mem_put,
+				vb->vb2.cnt_mem_prepare, vb->vb2.cnt_mem_finish,
+				vb->vb2.cnt_mem_mmap);
 			pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
-				vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
+				vb->vb2.cnt_mem_get_userptr, vb->vb2.cnt_mem_put_userptr);
 			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
-				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
-				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
+				vb->vb2.cnt_mem_attach_dmabuf, vb->vb2.cnt_mem_detach_dmabuf,
+				vb->vb2.cnt_mem_map_dmabuf, vb->vb2.cnt_mem_unmap_dmabuf);
 			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
-				vb->cnt_mem_get_dmabuf,
-				vb->cnt_mem_num_users,
-				vb->cnt_mem_vaddr,
-				vb->cnt_mem_cookie);
+				vb->vb2.cnt_mem_get_dmabuf,
+				vb->vb2.cnt_mem_num_users,
+				vb->vb2.cnt_mem_vaddr,
+				vb->vb2.cnt_mem_cookie);
 		}
 	}
 #endif
@@ -550,7 +553,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
  * __verify_planes_array() - verify that the planes array passed in struct
  * v4l2_buffer from userspace can be safely used
  */
-static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_planes_array(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
 		return 0;
@@ -562,9 +565,9 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 		return -EINVAL;
 	}
 
-	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
+	if (b->length < vb->vb2.num_planes || b->length > VIDEO_MAX_PLANES) {
 		dprintk(1, "incorrect planes array length, "
-			   "expected %d, got %d\n", vb->num_planes, b->length);
+			   "expected %d, got %d\n", vb->vb2.num_planes, b->length);
 		return -EINVAL;
 	}
 
@@ -575,7 +578,7 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
  * __verify_length() - Verify that the bytesused value for each plane fits in
  * the plane length and that the data offset doesn't exceed the bytesused value.
  */
-static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_length(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	unsigned int length;
 	unsigned int bytesused;
@@ -585,7 +588,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		return 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 			length = (b->memory == V4L2_MEMORY_USERPTR ||
 				  b->memory == V4L2_MEMORY_DMABUF)
 			       ? b->m.planes[plane].length
@@ -616,11 +619,11 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
  * __buffer_in_use() - return true if the buffer is in use and
  * the queue cannot be freed (by the means of REQBUFS(0)) call
  */
-static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
+static bool __buffer_in_use(struct vb2_queue *q, struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		void *mem_priv = vb->planes[plane].mem_priv;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		void *mem_priv = vb->vb2.planes[plane].mem_priv;
 		/*
 		 * If num_users() has not been provided, call_memop
 		 * will return 0, apparently nobody cares about this
@@ -651,9 +654,9 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *vb, struct v4l2_buffer *b)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 
 	/* Copy back data such as timestamp, flags, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
@@ -665,7 +668,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * Fill in plane-related data if userspace provided an array
 		 * for it. The caller has already verified memory and size.
 		 */
-		b->length = vb->num_planes;
+		b->length = vb->vb2.num_planes;
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
@@ -698,7 +701,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
 
-	switch (vb->state) {
+	switch (vb->vb2.state) {
 	case VB2_BUF_STATE_QUEUED:
 	case VB2_BUF_STATE_ACTIVE:
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
@@ -737,7 +740,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
  */
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	if (b->type != q->type) {
@@ -857,7 +860,7 @@ static int __verify_memory_type(struct vb2_queue *q,
  * 2) sets up the queue,
  * 3) negotiates number of buffers and planes per buffer with the driver
  *    to be used during streaming,
- * 4) allocates internal buffer structures (struct vb2_buffer), according to
+ * 4) allocates internal buffer structures (struct vb2_v4l2_buffer), according to
  *    the agreed parameters,
  * 5) for MMAP memory type, allocates actual video memory, using the
  *    memory handling/allocation routines provided during queue initialization
@@ -1114,45 +1117,45 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
+ * @vb:		vb2_v4l2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the address is to be returned
  *
  * This function returns a kernel virtual address of a given plane if
  * such a mapping exist, NULL otherwise.
  */
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
+void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no > vb->vb2.num_planes || !vb->vb2.planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, vaddr, vb->vb2.planes[plane_no].mem_priv);
 
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
 
 /**
  * vb2_plane_cookie() - Return allocator specific cookie for the given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
+ * @vb:		vb2_v4l2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the cookie is to be returned
  *
  * This function returns an allocator specific cookie for a given plane if
  * available, NULL otherwise. The allocator should provide some simple static
- * inline function, which would convert this cookie to the allocator specific
+ * inline funaction, which would convert this cookie to the allocator specific
  * type that can be used directly by the driver to access the buffer. This can
  * be for example physical address, pointer to scatter list or IOMMU mapping.
  */
-void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
+void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no >= vb->vb2.num_planes || !vb->vb2.planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, cookie, vb->vb2.planes[plane_no].mem_priv);
 }
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
 /**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
- * @vb:		vb2_buffer returned from the driver
+ * @vb:		vb2_v4l2_buffer returned from the driver
  * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
  *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
  *		If start_streaming fails then it should return buffers with state
@@ -1169,13 +1172,13 @@ EXPORT_SYMBOL_GPL(vb2_plane_cookie);
  * be started for some reason. In that case the buffers should be returned with
  * state QUEUED.
  */
-void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
+void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	unsigned long flags;
 	unsigned int plane;
 
-	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
+	if (WARN_ON(vb->vb2.state != VB2_BUF_STATE_ACTIVE))
 		return;
 
 	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
@@ -1188,20 +1191,20 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	 * Although this is not a callback, it still does have to balance
 	 * with the buf_queue op. So update this counter manually.
 	 */
-	vb->cnt_buf_done++;
+	vb->vb2.cnt_buf_done++;
 #endif
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, state);
 
 	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
+		call_void_memop(vb, finish, vb->vb2.planes[plane].mem_priv);
 
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
-	vb->state = state;
+	vb->vb2.state = state;
 	if (state != VB2_BUF_STATE_QUEUED)
-		list_add_tail(&vb->done_entry, &q->done_list);
+		list_add_tail(&vb->vb2.done_entry, &q->done_list);
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
@@ -1238,18 +1241,18 @@ void vb2_discard_done(struct vb2_queue *q)
 EXPORT_SYMBOL_GPL(vb2_discard_done);
 
 /**
- * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
+ * __fill_vb2_buffer() - fill a vb2_v4l2_buffer with information provided in a
  * v4l2_buffer by the userspace. The caller has already verified that struct
  * v4l2_buffer has a valid number of planes.
  */
-static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
+static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b,
 				struct v4l2_plane *v4l2_planes)
 {
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == V4L2_MEMORY_USERPTR) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
 				v4l2_planes[plane].length =
@@ -1257,7 +1260,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			}
 		}
 		if (b->memory == V4L2_MEMORY_DMABUF) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 				v4l2_planes[plane].m.fd =
 					b->m.planes[plane].m.fd;
 				v4l2_planes[plane].length =
@@ -1277,7 +1280,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			 * it's a safe assumption that they really meant to
 			 * use the full plane sizes.
 			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 				struct v4l2_plane *pdst = &v4l2_planes[plane];
 				struct v4l2_plane *psrc = &b->m.planes[plane];
 
@@ -1316,7 +1319,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 
 	/* Zero flags that the vb2 core handles */
 	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
-	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	if ((vb->vb2.vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
 	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * Non-COPY timestamps and non-OUTPUT queues will get
@@ -1344,7 +1347,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 /**
  * __qbuf_mmap() - handle qbuf of an MMAP buffer
  */
-static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_mmap(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
 	return call_vb_qop(vb, buf_prepare, vb);
@@ -1353,22 +1356,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 /**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
-static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_userptr(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	bool reacquired = vb->planes[0].mem_priv == NULL;
+	bool reacquired = vb->vb2.planes[0].mem_priv == NULL;
 
-	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
+	memset(planes, 0, sizeof(planes[0]) * vb->vb2.num_planes);
 	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 		/* Skip the plane if already verified */
 		if (vb->v4l2_planes[plane].m.userptr &&
 		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
@@ -1389,15 +1392,15 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Release previously acquired memory if present */
-		if (vb->planes[plane].mem_priv) {
+		if (vb->vb2.planes[plane].mem_priv) {
 			if (!reacquired) {
 				reacquired = true;
 				call_void_vb_qop(vb, buf_cleanup, vb);
 			}
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
 		}
 
-		vb->planes[plane].mem_priv = NULL;
+		vb->vb2.planes[plane].mem_priv = NULL;
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
@@ -1410,14 +1413,14 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
 			goto err;
 		}
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->vb2.planes[plane].mem_priv = mem_priv;
 	}
 
 	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
 	if (reacquired) {
@@ -1443,10 +1446,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	return 0;
 err:
 	/* In case of errors, release planes that were already acquired */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		if (vb->vb2.planes[plane].mem_priv)
+			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
+		vb->vb2.planes[plane].mem_priv = NULL;
 		vb->v4l2_planes[plane].m.userptr = 0;
 		vb->v4l2_planes[plane].length = 0;
 	}
@@ -1457,22 +1460,22 @@ err:
 /**
  * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
  */
-static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	bool reacquired = vb->planes[0].mem_priv == NULL;
+	bool reacquired = vb->vb2.planes[0].mem_priv == NULL;
 
-	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
+	memset(planes, 0, sizeof(planes[0]) * vb->vb2.num_planes);
 	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
 		if (IS_ERR_OR_NULL(dbuf)) {
@@ -1494,7 +1497,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Skip the plane if already verified */
-		if (dbuf == vb->planes[plane].dbuf &&
+		if (dbuf == vb->vb2.planes[plane].dbuf &&
 		    vb->v4l2_planes[plane].length == planes[plane].length) {
 			dma_buf_put(dbuf);
 			continue;
@@ -1508,7 +1511,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Release previously acquired memory if present */
-		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
+		__vb2_plane_dmabuf_put(vb, &vb->vb2.planes[plane]);
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
@@ -1521,29 +1524,29 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			goto err;
 		}
 
-		vb->planes[plane].dbuf = dbuf;
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->vb2.planes[plane].dbuf = dbuf;
+		vb->vb2.planes[plane].mem_priv = mem_priv;
 	}
 
 	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
 	 * really we want to do this just before the DMA, not while queueing
 	 * the buffer(s)..
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		ret = call_memop(vb, map_dmabuf, vb->vb2.planes[plane].mem_priv);
 		if (ret) {
 			dprintk(1, "failed to map dmabuf for plane %d\n",
 				plane);
 			goto err;
 		}
-		vb->planes[plane].dbuf_mapped = 1;
+		vb->vb2.planes[plane].dbuf_mapped = 1;
 	}
 
 	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
 	if (reacquired) {
@@ -1574,10 +1577,11 @@ err:
 }
 
 /**
- * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
+ * __enqueue_in_driver() - enqueue a vb2_v4l2_buffer in driver for processing
  */
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *pb = container_of(vb, struct vb2_v4l2_buffer, vb2);
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
 
@@ -1586,14 +1590,14 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
+		call_void_memop(pb, prepare, vb->planes[plane].mem_priv);
 
-	call_void_vb_qop(vb, buf_queue, vb);
+	call_void_vb_qop(pb, buf_queue, pb);
 }
 
-static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __buf_prepare(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	int ret;
 
 	ret = __verify_length(vb, b);
@@ -1620,7 +1624,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		return -EIO;
 	}
 
-	vb->state = VB2_BUF_STATE_PREPARING;
+	vb->vb2.state = VB2_BUF_STATE_PREPARING;
 	vb->v4l2_buf.timestamp.tv_sec = 0;
 	vb->v4l2_buf.timestamp.tv_usec = 0;
 	vb->v4l2_buf.sequence = 0;
@@ -1644,7 +1648,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	if (ret)
 		dprintk(1, "buffer preparation failed: %d\n", ret);
-	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
+	vb->vb2.state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
 
 	return ret;
 }
@@ -1693,7 +1697,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -1706,9 +1710,9 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return ret;
 
 	vb = q->bufs[b->index];
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+	if (vb->vb2.state != VB2_BUF_STATE_DEQUEUED) {
 		dprintk(1, "invalid buffer state %d\n",
-			vb->state);
+			vb->vb2.state);
 		return -EINVAL;
 	}
 
@@ -1737,6 +1741,7 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 static int vb2_start_streaming(struct vb2_queue *q)
 {
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *pb;
 	int ret;
 
 	/*
@@ -1770,9 +1775,9 @@ static int vb2_start_streaming(struct vb2_queue *q)
 		 * correctly return them to vb2.
 		 */
 		for (i = 0; i < q->num_buffers; ++i) {
-			vb = q->bufs[i];
-			if (vb->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED);
+			pb = q->bufs[i];
+			if (pb->vb2.state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(pb, VB2_BUF_STATE_QUEUED);
 		}
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
@@ -1789,14 +1794,14 @@ static int vb2_start_streaming(struct vb2_queue *q)
 static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	if (ret)
 		return ret;
 
 	vb = q->bufs[b->index];
 
-	switch (vb->state) {
+	switch (vb->vb2.state) {
 	case VB2_BUF_STATE_DEQUEUED:
 		ret = __buf_prepare(vb, b);
 		if (ret)
@@ -1808,7 +1813,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		dprintk(1, "buffer still being prepared\n");
 		return -EINVAL;
 	default:
-		dprintk(1, "invalid buffer state %d\n", vb->state);
+		dprintk(1, "invalid buffer state %d\n", vb->vb2.state);
 		return -EINVAL;
 	}
 
@@ -1816,10 +1821,10 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
 	 */
-	list_add_tail(&vb->queued_entry, &q->queued_list);
+	list_add_tail(&vb->vb2.queued_entry, &q->queued_list);
 	q->queued_count++;
 	q->waiting_for_buffers = false;
-	vb->state = VB2_BUF_STATE_QUEUED;
+	vb->vb2.state = VB2_BUF_STATE_QUEUED;
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		/*
 		 * For output buffers copy the timestamp if needed,
@@ -1838,7 +1843,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
 	if (q->start_streaming_called)
-		__enqueue_in_driver(vb);
+		__enqueue_in_driver(&vb->vb2);
 
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
@@ -1964,11 +1969,12 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
  *
  * Will sleep if required for nonblocking == false.
  */
-static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
+static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_v4l2_buffer **vb,
 				struct v4l2_buffer *b, int nonblocking)
 {
 	unsigned long flags;
 	int ret;
+	struct vb2_buffer *vb2 = NULL;
 
 	/*
 	 * Wait for at least one buffer to become available on the done_list.
@@ -1982,14 +1988,15 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	 * is not empty, so no need for another list_empty(done_list) check.
 	 */
 	spin_lock_irqsave(&q->done_lock, flags);
-	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
+	vb2 = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
+	*vb = container_of(vb2, struct vb2_v4l2_buffer, vb2); 
 	/*
 	 * Only remove the buffer from done_list if v4l2_buffer can handle all
 	 * the planes.
 	 */
 	ret = __verify_planes_array(*vb, b);
 	if (!ret)
-		list_del(&(*vb)->done_entry);
+		list_del(&(*vb)->vb2.done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	return ret;
@@ -2020,30 +2027,30 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 /**
  * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
  */
-static void __vb2_dqbuf(struct vb2_buffer *vb)
+static void __vb2_dqbuf(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	unsigned int i;
 
 	/* nothing to do if the buffer is already dequeued */
-	if (vb->state == VB2_BUF_STATE_DEQUEUED)
+	if (vb->vb2.state == VB2_BUF_STATE_DEQUEUED)
 		return;
 
-	vb->state = VB2_BUF_STATE_DEQUEUED;
+	vb->vb2.state = VB2_BUF_STATE_DEQUEUED;
 
 	/* unmap DMABUF buffer */
 	if (q->memory == V4L2_MEMORY_DMABUF)
-		for (i = 0; i < vb->num_planes; ++i) {
-			if (!vb->planes[i].dbuf_mapped)
+		for (i = 0; i < vb->vb2.num_planes; ++i) {
+			if (!vb->vb2.planes[i].dbuf_mapped)
 				continue;
-			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
-			vb->planes[i].dbuf_mapped = 0;
+			call_void_memop(vb, unmap_dmabuf, vb->vb2.planes[i].mem_priv);
+			vb->vb2.planes[i].dbuf_mapped = 0;
 		}
 }
 
 static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
-	struct vb2_buffer *vb = NULL;
+	struct vb2_v4l2_buffer *vb = NULL;
 	int ret;
 
 	if (b->type != q->type) {
@@ -2054,7 +2061,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	if (ret < 0)
 		return ret;
 
-	switch (vb->state) {
+	switch (vb->vb2.state) {
 	case VB2_BUF_STATE_DONE:
 		dprintk(3, "returning done buffer\n");
 		break;
@@ -2071,13 +2078,13 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
 	/* Remove from videobuf queue */
-	list_del(&vb->queued_entry);
+	list_del(&vb->vb2.queued_entry);
 	q->queued_count--;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
-			vb->v4l2_buf.index, vb->state);
+			vb->v4l2_buf.index, vb->vb2.state);
 
 	return 0;
 }
@@ -2122,6 +2129,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
 static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * Tell driver to stop all transactions and release all queued
@@ -2138,8 +2146,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
-			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+		{
+			vb = (struct vb2_v4l2_buffer *)q->bufs[i];
+			if (vb->vb2.state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		}
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
@@ -2171,10 +2182,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
 	 */
 	for (i = 0; i < q->num_buffers; ++i) {
-		struct vb2_buffer *vb = q->bufs[i];
+		struct vb2_v4l2_buffer *vb = q->bufs[i];
 
-		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-			vb->state = VB2_BUF_STATE_PREPARED;
+		if (vb->vb2.state != VB2_BUF_STATE_DEQUEUED) {
+			vb->vb2.state = VB2_BUF_STATE_PREPARED;
 			call_void_vb_qop(vb, buf_finish, vb);
 		}
 		__vb2_dqbuf(vb);
@@ -2322,7 +2333,7 @@ EXPORT_SYMBOL_GPL(vb2_streamoff);
 static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 			unsigned int *_buffer, unsigned int *_plane)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int buffer, plane;
 
 	/*
@@ -2333,7 +2344,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
 		vb = q->bufs[buffer];
 
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 			if (vb->v4l2_planes[plane].m.mem_offset == off) {
 				*_buffer = buffer;
 				*_plane = plane;
@@ -2356,7 +2367,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
  */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
-	struct vb2_buffer *vb = NULL;
+	struct vb2_v4l2_buffer *vb = NULL;
 	struct vb2_plane *vb_plane;
 	int ret;
 	struct dma_buf *dbuf;
@@ -2388,7 +2399,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 
 	vb = q->bufs[eb->index];
 
-	if (eb->plane >= vb->num_planes) {
+	if (eb->plane >= vb->vb2.num_planes) {
 		dprintk(1, "buffer plane out of range\n");
 		return -EINVAL;
 	}
@@ -2398,7 +2409,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EBUSY;
 	}
 
-	vb_plane = &vb->planes[eb->plane];
+	vb_plane = &vb->vb2.planes[eb->plane];
 
 	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
@@ -2445,7 +2456,7 @@ EXPORT_SYMBOL_GPL(vb2_expbuf);
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int buffer = 0, plane = 0;
 	int ret;
 	unsigned long length;
@@ -2500,7 +2511,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	}
 
 	mutex_lock(&q->mmap_lock);
-	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
+	ret = call_memop(vb, mmap, vb->vb2.planes[plane].mem_priv, vma);
 	mutex_unlock(&q->mmap_lock);
 	if (ret)
 		return ret;
@@ -2518,7 +2529,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long flags)
 {
 	unsigned long off = pgoff << PAGE_SHIFT;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int buffer, plane;
 	void *vaddr;
 	int ret;
@@ -2658,7 +2669,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
  * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
  * for more information.
  */
 int vb2_queue_init(struct vb2_queue *q)
@@ -2689,7 +2700,7 @@ int vb2_queue_init(struct vb2_queue *q)
 	init_waitqueue_head(&q->done_wq);
 
 	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_buffer);
+		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
 	return 0;
 }
@@ -2773,6 +2784,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	struct vb2_fileio_data *fileio;
 	int i, ret;
 	unsigned int count = 0;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * Sanity check
@@ -2823,7 +2835,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Check if plane_count is correct
 	 * (multiplane buffers are not supported).
 	 */
-	if (q->bufs[0]->num_planes != 1) {
+	vb = (struct vb2_v4l2_buffer *)q->bufs[0];
+	if (vb->vb2.num_planes != 1) {
 		ret = -EBUSY;
 		goto err_reqbufs;
 	}
@@ -3133,7 +3146,7 @@ static int vb2_thread(void *data)
 	set_freezable();
 
 	for (;;) {
-		struct vb2_buffer *vb;
+		struct vb2_v4l2_buffer *vb;
 
 		/*
 		 * Call vb2_dqbuf to get buffer back.
@@ -3225,7 +3238,6 @@ EXPORT_SYMBOL_GPL(vb2_thread_start);
 int vb2_thread_stop(struct vb2_queue *q)
 {
 	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
 	int err;
 
 	if (threadio == NULL)
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 852a952..f578775 100644
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
index b1838ab..3e3a3cc 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-memops.h>
 #include <media/videobuf2-dma-sg.h>
 
diff --git a/drivers/media/v4l2-core/videobuf2-dvb.c b/drivers/media/v4l2-core/videobuf2-dvb.c
index d092698..21e6858 100644
--- a/drivers/media/v4l2-core/videobuf2-dvb.c
+++ b/drivers/media/v4l2-core/videobuf2-dvb.c
@@ -27,7 +27,7 @@ MODULE_LICENSE("GPL");
 
 /* ------------------------------------------------------------------ */
 
-static int dvb_fnc(struct vb2_buffer *vb, void *priv)
+static int dvb_fnc(struct vb2_v4l2_buffer *vb, void *priv)
 {
 	struct vb2_dvb *dvb = priv;
 
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
similarity index 89%
copy from drivers/media/v4l2-core/videobuf2-core.c
copy to drivers/media/v4l2-core/videobuf2-v4l2.c
index cc16e76..cd28b4807f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -28,7 +28,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -51,12 +51,12 @@ module_param(debug, int, 0644);
 
 #define log_memop(vb, op)						\
 	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
-		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
+		(vb)->vb2.vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2.vb2_queue->mem_ops->op ? "" : " (nop)")
 
 #define call_memop(vb, op, args...)					\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
 	int err;							\
 									\
 	log_memop(vb, op);						\
@@ -68,7 +68,7 @@ module_param(debug, int, 0644);
 
 #define call_ptr_memop(vb, op, args...)					\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
 	void *ptr;							\
 									\
 	log_memop(vb, op);						\
@@ -80,7 +80,7 @@ module_param(debug, int, 0644);
 
 #define call_void_memop(vb, op, args...)				\
 ({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	struct vb2_queue *_q = (vb)->vb2.vb2_queue;				\
 									\
 	log_memop(vb, op);						\
 	if (_q->mem_ops->op)						\
@@ -113,16 +113,16 @@ module_param(debug, int, 0644);
 
 #define log_vb_qop(vb, op, args...)					\
 	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
-		(vb)->vb2_queue->ops->op ? "" : " (nop)")
+		(vb)->vb2.vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2.vb2_queue->ops->op ? "" : " (nop)")
 
 #define call_vb_qop(vb, op, args...)					\
 ({									\
 	int err;							\
 									\
 	log_vb_qop(vb, op);						\
-	err = (vb)->vb2_queue->ops->op ?				\
-		(vb)->vb2_queue->ops->op(args) : 0;			\
+	err = (vb)->vb2.vb2_queue->ops->op ?				\
+		(vb)->vb2.vb2_queue->ops->op(args) : 0;			\
 	if (!err)							\
 		(vb)->cnt_ ## op++;					\
 	err;								\
@@ -131,25 +131,25 @@ module_param(debug, int, 0644);
 #define call_void_vb_qop(vb, op, args...)				\
 ({									\
 	log_vb_qop(vb, op);						\
-	if ((vb)->vb2_queue->ops->op)					\
-		(vb)->vb2_queue->ops->op(args);				\
+	if ((vb)->vb2.vb2_queue->ops->op)					\
+		(vb)->vb2.vb2_queue->ops->op(args);				\
 	(vb)->cnt_ ## op++;						\
 })
 
 #else
 
 #define call_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : 0)
+	((vb)->vb2.vb2_queue->mem_ops->op ?					\
+		(vb)->vb2.vb2_queue->mem_ops->op(args) : 0)
 
 #define call_ptr_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : NULL)
+	((vb)->vb2.vb2_queue->mem_ops->op ?					\
+		(vb)->vb2.vb2_queue->mem_ops->op(args) : NULL)
 
 #define call_void_memop(vb, op, args...)				\
 	do {								\
-		if ((vb)->vb2_queue->mem_ops->op)			\
-			(vb)->vb2_queue->mem_ops->op(args);		\
+		if ((vb)->vb2.vb2_queue->mem_ops->op)			\
+			(vb)->vb2.vb2_queue->mem_ops->op(args);		\
 	} while (0)
 
 #define call_qop(q, op, args...)					\
@@ -162,12 +162,12 @@ module_param(debug, int, 0644);
 	} while (0)
 
 #define call_vb_qop(vb, op, args...)					\
-	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
+	((vb)->vb2.vb2_queue->ops->op ? (vb)->vb2.vb2_queue->ops->op(args) : 0)
 
 #define call_void_vb_qop(vb, op, args...)				\
 	do {								\
-		if ((vb)->vb2_queue->ops->op)				\
-			(vb)->vb2_queue->ops->op(args);			\
+		if ((vb)->vb2.vb2_queue->ops->op)				\
+			(vb)->vb2.vb2_queue->ops->op(args);			\
 	} while (0)
 
 #endif
@@ -186,9 +186,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
-static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
+static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
@@ -198,7 +198,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	 * Allocate memory for all planes in this buffer
 	 * NOTE: mmapped areas should be page aligned
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
@@ -207,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 			goto free;
 
 		/* Associate allocator private data with this plane */
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->vb2.planes[plane].mem_priv = mem_priv;
 		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 
@@ -215,8 +215,8 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 free:
 	/* Free already allocated memory if one of the allocations failed */
 	for (; plane > 0; --plane) {
-		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
-		vb->planes[plane - 1].mem_priv = NULL;
+		call_void_memop(vb, put, vb->vb2.planes[plane - 1].mem_priv);
+		vb->vb2.planes[plane - 1].mem_priv = NULL;
 	}
 
 	return -ENOMEM;
@@ -225,13 +225,13 @@ free:
 /**
  * __vb2_buf_mem_free() - free memory of the given buffer
  */
-static void __vb2_buf_mem_free(struct vb2_buffer *vb)
+static void __vb2_buf_mem_free(struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		call_void_memop(vb, put, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		call_void_memop(vb, put, vb->vb2.planes[plane].mem_priv);
+		vb->vb2.planes[plane].mem_priv = NULL;
 		dprintk(3, "freed plane %d of buffer %d\n", plane,
 			vb->v4l2_buf.index);
 	}
@@ -241,14 +241,14 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
  * __vb2_buf_userptr_put() - release userspace memory associated with
  * a USERPTR buffer
  */
-static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
+static void __vb2_buf_userptr_put(struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		if (vb->vb2.planes[plane].mem_priv)
+			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
+		vb->vb2.planes[plane].mem_priv = NULL;
 	}
 }
 
@@ -256,7 +256,7 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
  * __vb2_plane_dmabuf_put() - release memory associated with
  * a DMABUF shared plane
  */
-static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
+static void __vb2_plane_dmabuf_put(struct vb2_v4l2_buffer *vb, struct vb2_plane *p)
 {
 	if (!p->mem_priv)
 		return;
@@ -273,12 +273,12 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
  * __vb2_buf_dmabuf_put() - release memory associated with
  * a DMABUF shared buffer
  */
-static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
+static void __vb2_buf_dmabuf_put(struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
 
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
+		__vb2_plane_dmabuf_put(vb, &vb->vb2.planes[plane]);
 }
 
 /**
@@ -288,14 +288,14 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 static void __setup_lengths(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
 
-		for (plane = 0; plane < vb->num_planes; ++plane)
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane)
 			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 }
@@ -307,13 +307,13 @@ static void __setup_lengths(struct vb2_queue *q, unsigned int n)
 static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long off;
 
 	if (q->num_buffers) {
 		struct v4l2_plane *p;
 		vb = q->bufs[q->num_buffers - 1];
-		p = &vb->v4l2_planes[vb->num_planes - 1];
+		p = &vb->v4l2_planes[vb->vb2.num_planes - 1];
 		off = PAGE_ALIGN(p->m.mem_offset + p->length);
 	} else {
 		off = 0;
@@ -324,7 +324,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 		if (!vb)
 			continue;
 
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 			vb->v4l2_planes[plane].m.mem_offset = off;
 
 			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
@@ -347,7 +347,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes)
 {
 	unsigned int buffer;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	for (buffer = 0; buffer < num_buffers; ++buffer) {
@@ -362,9 +362,9 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
 			vb->v4l2_buf.length = num_planes;
 
-		vb->state = VB2_BUF_STATE_DEQUEUED;
-		vb->vb2_queue = q;
-		vb->num_planes = num_planes;
+		vb->vb2.state = VB2_BUF_STATE_DEQUEUED;
+		vb->vb2.vb2_queue = q;
+		vb->vb2.num_planes = num_planes;
 		vb->v4l2_buf.index = q->num_buffers + buffer;
 		vb->v4l2_buf.type = q->type;
 		vb->v4l2_buf.memory = memory;
@@ -412,7 +412,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
@@ -438,6 +438,7 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 {
 	unsigned int buffer;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * Sanity check: when preparing a buffer the queue lock is released for
@@ -449,9 +450,11 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	 */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		if (q->bufs[buffer] == NULL)
+		vb = (struct vb2_v4l2_buffer *)q->bufs[buffer];
+
+		if (vb == NULL)
 			continue;
-		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
+		if (vb->vb2.state == VB2_BUF_STATE_PREPARING) {
 			dprintk(1, "preparing buffers, cannot free\n");
 			return -EAGAIN;
 		}
@@ -460,9 +463,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	/* Call driver-provided cleanup function for each buffer, if provided */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		struct vb2_buffer *vb = q->bufs[buffer];
+		vb = (struct vb2_v4l2_buffer *)q->bufs[buffer];
 
-		if (vb && vb->planes[0].mem_priv)
+		if (vb && vb->vb2.planes[0].mem_priv)
 			call_void_vb_qop(vb, buf_cleanup, vb);
 	}
 
@@ -495,38 +498,38 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 		q->cnt_stop_streaming = 0;
 	}
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		struct vb2_buffer *vb = q->bufs[buffer];
-		bool unbalanced = vb->cnt_mem_alloc != vb->cnt_mem_put ||
-				  vb->cnt_mem_prepare != vb->cnt_mem_finish ||
-				  vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
-				  vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
-				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
-				  vb->cnt_buf_queue != vb->cnt_buf_done ||
-				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
-				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
+		struct vb2_v4l2_buffer *vb = q->bufs[buffer];
+		bool unbalanced = vb->vb2.cnt_mem_alloc != vb->vb2.cnt_mem_put ||
+				  vb->vb2.cnt_mem_prepare != vb->vb2.cnt_mem_finish ||
+				  vb->vb2.cnt_mem_get_userptr != vb->vb2.cnt_mem_put_userptr ||
+				  vb->vb2.cnt_mem_attach_dmabuf != vb->vb2.cnt_mem_detach_dmabuf ||
+				  vb->vb2.cnt_mem_map_dmabuf != vb->vb2.cnt_mem_unmap_dmabuf ||
+				  vb->vb2.cnt_buf_queue != vb->vb2.cnt_buf_done ||
+				  vb->vb2.cnt_buf_prepare != vb->vb2.cnt_buf_finish ||
+				  vb->vb2.cnt_buf_init != vb->vb2.cnt_buf_cleanup;
 
 		if (unbalanced || debug) {
 			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
 				q, buffer, unbalanced ? " UNBALANCED!" : "");
 			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
-				vb->cnt_buf_init, vb->cnt_buf_cleanup,
-				vb->cnt_buf_prepare, vb->cnt_buf_finish);
+				vb->vb2.cnt_buf_init, vb->vb2.cnt_buf_cleanup,
+				vb->vb2.cnt_buf_prepare, vb->vb2.cnt_buf_finish);
 			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
-				vb->cnt_buf_queue, vb->cnt_buf_done);
+				vb->vb2.cnt_buf_queue, vb->vb2.cnt_buf_done);
 			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
-				vb->cnt_mem_alloc, vb->cnt_mem_put,
-				vb->cnt_mem_prepare, vb->cnt_mem_finish,
-				vb->cnt_mem_mmap);
+				vb->vb2.cnt_mem_alloc, vb->vb2.cnt_mem_put,
+				vb->vb2.cnt_mem_prepare, vb->vb2.cnt_mem_finish,
+				vb->vb2.cnt_mem_mmap);
 			pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
-				vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
+				vb->vb2.cnt_mem_get_userptr, vb->vb2.cnt_mem_put_userptr);
 			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
-				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
-				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
+				vb->vb2.cnt_mem_attach_dmabuf, vb->vb2.cnt_mem_detach_dmabuf,
+				vb->vb2.cnt_mem_map_dmabuf, vb->vb2.cnt_mem_unmap_dmabuf);
 			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
-				vb->cnt_mem_get_dmabuf,
-				vb->cnt_mem_num_users,
-				vb->cnt_mem_vaddr,
-				vb->cnt_mem_cookie);
+				vb->vb2.cnt_mem_get_dmabuf,
+				vb->vb2.cnt_mem_num_users,
+				vb->vb2.cnt_mem_vaddr,
+				vb->vb2.cnt_mem_cookie);
 		}
 	}
 #endif
@@ -550,7 +553,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
  * __verify_planes_array() - verify that the planes array passed in struct
  * v4l2_buffer from userspace can be safely used
  */
-static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_planes_array(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
 		return 0;
@@ -562,9 +565,9 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 		return -EINVAL;
 	}
 
-	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
+	if (b->length < vb->vb2.num_planes || b->length > VIDEO_MAX_PLANES) {
 		dprintk(1, "incorrect planes array length, "
-			   "expected %d, got %d\n", vb->num_planes, b->length);
+			   "expected %d, got %d\n", vb->vb2.num_planes, b->length);
 		return -EINVAL;
 	}
 
@@ -575,7 +578,7 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
  * __verify_length() - Verify that the bytesused value for each plane fits in
  * the plane length and that the data offset doesn't exceed the bytesused value.
  */
-static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_length(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	unsigned int length;
 	unsigned int bytesused;
@@ -585,7 +588,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		return 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 			length = (b->memory == V4L2_MEMORY_USERPTR ||
 				  b->memory == V4L2_MEMORY_DMABUF)
 			       ? b->m.planes[plane].length
@@ -616,11 +619,11 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
  * __buffer_in_use() - return true if the buffer is in use and
  * the queue cannot be freed (by the means of REQBUFS(0)) call
  */
-static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
+static bool __buffer_in_use(struct vb2_queue *q, struct vb2_v4l2_buffer *vb)
 {
 	unsigned int plane;
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		void *mem_priv = vb->planes[plane].mem_priv;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		void *mem_priv = vb->vb2.planes[plane].mem_priv;
 		/*
 		 * If num_users() has not been provided, call_memop
 		 * will return 0, apparently nobody cares about this
@@ -651,9 +654,9 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *vb, struct v4l2_buffer *b)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 
 	/* Copy back data such as timestamp, flags, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
@@ -665,7 +668,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * Fill in plane-related data if userspace provided an array
 		 * for it. The caller has already verified memory and size.
 		 */
-		b->length = vb->num_planes;
+		b->length = vb->vb2.num_planes;
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
@@ -698,7 +701,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
 
-	switch (vb->state) {
+	switch (vb->vb2.state) {
 	case VB2_BUF_STATE_QUEUED:
 	case VB2_BUF_STATE_ACTIVE:
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
@@ -737,7 +740,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
  */
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	if (b->type != q->type) {
@@ -857,7 +860,7 @@ static int __verify_memory_type(struct vb2_queue *q,
  * 2) sets up the queue,
  * 3) negotiates number of buffers and planes per buffer with the driver
  *    to be used during streaming,
- * 4) allocates internal buffer structures (struct vb2_buffer), according to
+ * 4) allocates internal buffer structures (struct vb2_v4l2_buffer), according to
  *    the agreed parameters,
  * 5) for MMAP memory type, allocates actual video memory, using the
  *    memory handling/allocation routines provided during queue initialization
@@ -1114,45 +1117,45 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
+ * @vb:		vb2_v4l2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the address is to be returned
  *
  * This function returns a kernel virtual address of a given plane if
  * such a mapping exist, NULL otherwise.
  */
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
+void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no > vb->vb2.num_planes || !vb->vb2.planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, vaddr, vb->vb2.planes[plane_no].mem_priv);
 
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
 
 /**
  * vb2_plane_cookie() - Return allocator specific cookie for the given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
+ * @vb:		vb2_v4l2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the cookie is to be returned
  *
  * This function returns an allocator specific cookie for a given plane if
  * available, NULL otherwise. The allocator should provide some simple static
- * inline function, which would convert this cookie to the allocator specific
+ * inline funaction, which would convert this cookie to the allocator specific
  * type that can be used directly by the driver to access the buffer. This can
  * be for example physical address, pointer to scatter list or IOMMU mapping.
  */
-void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
+void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no >= vb->vb2.num_planes || !vb->vb2.planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, cookie, vb->vb2.planes[plane_no].mem_priv);
 }
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
 /**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
- * @vb:		vb2_buffer returned from the driver
+ * @vb:		vb2_v4l2_buffer returned from the driver
  * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
  *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
  *		If start_streaming fails then it should return buffers with state
@@ -1169,13 +1172,13 @@ EXPORT_SYMBOL_GPL(vb2_plane_cookie);
  * be started for some reason. In that case the buffers should be returned with
  * state QUEUED.
  */
-void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
+void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	unsigned long flags;
 	unsigned int plane;
 
-	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
+	if (WARN_ON(vb->vb2.state != VB2_BUF_STATE_ACTIVE))
 		return;
 
 	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
@@ -1188,20 +1191,20 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	 * Although this is not a callback, it still does have to balance
 	 * with the buf_queue op. So update this counter manually.
 	 */
-	vb->cnt_buf_done++;
+	vb->vb2.cnt_buf_done++;
 #endif
 	dprintk(4, "done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, state);
 
 	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
+		call_void_memop(vb, finish, vb->vb2.planes[plane].mem_priv);
 
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
-	vb->state = state;
+	vb->vb2.state = state;
 	if (state != VB2_BUF_STATE_QUEUED)
-		list_add_tail(&vb->done_entry, &q->done_list);
+		list_add_tail(&vb->vb2.done_entry, &q->done_list);
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
@@ -1238,18 +1241,18 @@ void vb2_discard_done(struct vb2_queue *q)
 EXPORT_SYMBOL_GPL(vb2_discard_done);
 
 /**
- * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
+ * __fill_vb2_buffer() - fill a vb2_v4l2_buffer with information provided in a
  * v4l2_buffer by the userspace. The caller has already verified that struct
  * v4l2_buffer has a valid number of planes.
  */
-static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
+static void __fill_vb2_buffer(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b,
 				struct v4l2_plane *v4l2_planes)
 {
 	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == V4L2_MEMORY_USERPTR) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
 					b->m.planes[plane].m.userptr;
 				v4l2_planes[plane].length =
@@ -1257,7 +1260,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			}
 		}
 		if (b->memory == V4L2_MEMORY_DMABUF) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 				v4l2_planes[plane].m.fd =
 					b->m.planes[plane].m.fd;
 				v4l2_planes[plane].length =
@@ -1277,7 +1280,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			 * it's a safe assumption that they really meant to
 			 * use the full plane sizes.
 			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
+			for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 				struct v4l2_plane *pdst = &v4l2_planes[plane];
 				struct v4l2_plane *psrc = &b->m.planes[plane];
 
@@ -1316,7 +1319,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 
 	/* Zero flags that the vb2 core handles */
 	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
-	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	if ((vb->vb2.vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
 	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * Non-COPY timestamps and non-OUTPUT queues will get
@@ -1344,7 +1347,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 /**
  * __qbuf_mmap() - handle qbuf of an MMAP buffer
  */
-static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_mmap(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
 	return call_vb_qop(vb, buf_prepare, vb);
@@ -1353,22 +1356,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 /**
  * __qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
-static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_userptr(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	bool reacquired = vb->planes[0].mem_priv == NULL;
+	bool reacquired = vb->vb2.planes[0].mem_priv == NULL;
 
-	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
+	memset(planes, 0, sizeof(planes[0]) * vb->vb2.num_planes);
 	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 		/* Skip the plane if already verified */
 		if (vb->v4l2_planes[plane].m.userptr &&
 		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
@@ -1389,15 +1392,15 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Release previously acquired memory if present */
-		if (vb->planes[plane].mem_priv) {
+		if (vb->vb2.planes[plane].mem_priv) {
 			if (!reacquired) {
 				reacquired = true;
 				call_void_vb_qop(vb, buf_cleanup, vb);
 			}
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
 		}
 
-		vb->planes[plane].mem_priv = NULL;
+		vb->vb2.planes[plane].mem_priv = NULL;
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
@@ -1410,14 +1413,14 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
 			goto err;
 		}
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->vb2.planes[plane].mem_priv = mem_priv;
 	}
 
 	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
 	if (reacquired) {
@@ -1443,10 +1446,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	return 0;
 err:
 	/* In case of errors, release planes that were already acquired */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		if (vb->vb2.planes[plane].mem_priv)
+			call_void_memop(vb, put_userptr, vb->vb2.planes[plane].mem_priv);
+		vb->vb2.planes[plane].mem_priv = NULL;
 		vb->v4l2_planes[plane].m.userptr = 0;
 		vb->v4l2_planes[plane].length = 0;
 	}
@@ -1457,22 +1460,22 @@ err:
 /**
  * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
  */
-static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __qbuf_dmabuf(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	bool reacquired = vb->planes[0].mem_priv == NULL;
+	bool reacquired = vb->vb2.planes[0].mem_priv == NULL;
 
-	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
+	memset(planes, 0, sizeof(planes[0]) * vb->vb2.num_planes);
 	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
 		if (IS_ERR_OR_NULL(dbuf)) {
@@ -1494,7 +1497,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Skip the plane if already verified */
-		if (dbuf == vb->planes[plane].dbuf &&
+		if (dbuf == vb->vb2.planes[plane].dbuf &&
 		    vb->v4l2_planes[plane].length == planes[plane].length) {
 			dma_buf_put(dbuf);
 			continue;
@@ -1508,7 +1511,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		/* Release previously acquired memory if present */
-		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
+		__vb2_plane_dmabuf_put(vb, &vb->vb2.planes[plane]);
 		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
@@ -1521,29 +1524,29 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			goto err;
 		}
 
-		vb->planes[plane].dbuf = dbuf;
-		vb->planes[plane].mem_priv = mem_priv;
+		vb->vb2.planes[plane].dbuf = dbuf;
+		vb->vb2.planes[plane].mem_priv = mem_priv;
 	}
 
 	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
 	 * really we want to do this just before the DMA, not while queueing
 	 * the buffer(s)..
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
+		ret = call_memop(vb, map_dmabuf, vb->vb2.planes[plane].mem_priv);
 		if (ret) {
 			dprintk(1, "failed to map dmabuf for plane %d\n",
 				plane);
 			goto err;
 		}
-		vb->planes[plane].dbuf_mapped = 1;
+		vb->vb2.planes[plane].dbuf_mapped = 1;
 	}
 
 	/*
 	 * Now that everything is in order, copy relevant information
 	 * provided by userspace.
 	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
+	for (plane = 0; plane < vb->vb2.num_planes; ++plane)
 		vb->v4l2_planes[plane] = planes[plane];
 
 	if (reacquired) {
@@ -1574,10 +1577,11 @@ err:
 }
 
 /**
- * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
+ * __enqueue_in_driver() - enqueue a vb2_v4l2_buffer in driver for processing
  */
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *pb = container_of(vb, struct vb2_v4l2_buffer, vb2);
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
 
@@ -1586,14 +1590,14 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
+		call_void_memop(pb, prepare, vb->planes[plane].mem_priv);
 
-	call_void_vb_qop(vb, buf_queue, vb);
+	call_void_vb_qop(pb, buf_queue, pb);
 }
 
-static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __buf_prepare(struct vb2_v4l2_buffer *vb, const struct v4l2_buffer *b)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	int ret;
 
 	ret = __verify_length(vb, b);
@@ -1620,7 +1624,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		return -EIO;
 	}
 
-	vb->state = VB2_BUF_STATE_PREPARING;
+	vb->vb2.state = VB2_BUF_STATE_PREPARING;
 	vb->v4l2_buf.timestamp.tv_sec = 0;
 	vb->v4l2_buf.timestamp.tv_usec = 0;
 	vb->v4l2_buf.sequence = 0;
@@ -1644,7 +1648,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	if (ret)
 		dprintk(1, "buffer preparation failed: %d\n", ret);
-	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
+	vb->vb2.state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
 
 	return ret;
 }
@@ -1693,7 +1697,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	if (vb2_fileio_is_active(q)) {
@@ -1706,9 +1710,9 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return ret;
 
 	vb = q->bufs[b->index];
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+	if (vb->vb2.state != VB2_BUF_STATE_DEQUEUED) {
 		dprintk(1, "invalid buffer state %d\n",
-			vb->state);
+			vb->vb2.state);
 		return -EINVAL;
 	}
 
@@ -1737,6 +1741,7 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 static int vb2_start_streaming(struct vb2_queue *q)
 {
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *pb;
 	int ret;
 
 	/*
@@ -1770,9 +1775,9 @@ static int vb2_start_streaming(struct vb2_queue *q)
 		 * correctly return them to vb2.
 		 */
 		for (i = 0; i < q->num_buffers; ++i) {
-			vb = q->bufs[i];
-			if (vb->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED);
+			pb = q->bufs[i];
+			if (pb->vb2.state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(pb, VB2_BUF_STATE_QUEUED);
 		}
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
@@ -1789,14 +1794,14 @@ static int vb2_start_streaming(struct vb2_queue *q)
 static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	if (ret)
 		return ret;
 
 	vb = q->bufs[b->index];
 
-	switch (vb->state) {
+	switch (vb->vb2.state) {
 	case VB2_BUF_STATE_DEQUEUED:
 		ret = __buf_prepare(vb, b);
 		if (ret)
@@ -1808,7 +1813,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		dprintk(1, "buffer still being prepared\n");
 		return -EINVAL;
 	default:
-		dprintk(1, "invalid buffer state %d\n", vb->state);
+		dprintk(1, "invalid buffer state %d\n", vb->vb2.state);
 		return -EINVAL;
 	}
 
@@ -1816,10 +1821,10 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
 	 */
-	list_add_tail(&vb->queued_entry, &q->queued_list);
+	list_add_tail(&vb->vb2.queued_entry, &q->queued_list);
 	q->queued_count++;
 	q->waiting_for_buffers = false;
-	vb->state = VB2_BUF_STATE_QUEUED;
+	vb->vb2.state = VB2_BUF_STATE_QUEUED;
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		/*
 		 * For output buffers copy the timestamp if needed,
@@ -1838,7 +1843,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
 	if (q->start_streaming_called)
-		__enqueue_in_driver(vb);
+		__enqueue_in_driver(&vb->vb2);
 
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
@@ -1964,11 +1969,12 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
  *
  * Will sleep if required for nonblocking == false.
  */
-static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
+static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_v4l2_buffer **vb,
 				struct v4l2_buffer *b, int nonblocking)
 {
 	unsigned long flags;
 	int ret;
+	struct vb2_buffer *vb2 = NULL;
 
 	/*
 	 * Wait for at least one buffer to become available on the done_list.
@@ -1982,14 +1988,15 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	 * is not empty, so no need for another list_empty(done_list) check.
 	 */
 	spin_lock_irqsave(&q->done_lock, flags);
-	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
+	vb2 = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
+	*vb = container_of(vb2, struct vb2_v4l2_buffer, vb2); 
 	/*
 	 * Only remove the buffer from done_list if v4l2_buffer can handle all
 	 * the planes.
 	 */
 	ret = __verify_planes_array(*vb, b);
 	if (!ret)
-		list_del(&(*vb)->done_entry);
+		list_del(&(*vb)->vb2.done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	return ret;
@@ -2020,30 +2027,30 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 /**
  * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
  */
-static void __vb2_dqbuf(struct vb2_buffer *vb)
+static void __vb2_dqbuf(struct vb2_v4l2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_queue *q = vb->vb2.vb2_queue;
 	unsigned int i;
 
 	/* nothing to do if the buffer is already dequeued */
-	if (vb->state == VB2_BUF_STATE_DEQUEUED)
+	if (vb->vb2.state == VB2_BUF_STATE_DEQUEUED)
 		return;
 
-	vb->state = VB2_BUF_STATE_DEQUEUED;
+	vb->vb2.state = VB2_BUF_STATE_DEQUEUED;
 
 	/* unmap DMABUF buffer */
 	if (q->memory == V4L2_MEMORY_DMABUF)
-		for (i = 0; i < vb->num_planes; ++i) {
-			if (!vb->planes[i].dbuf_mapped)
+		for (i = 0; i < vb->vb2.num_planes; ++i) {
+			if (!vb->vb2.planes[i].dbuf_mapped)
 				continue;
-			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
-			vb->planes[i].dbuf_mapped = 0;
+			call_void_memop(vb, unmap_dmabuf, vb->vb2.planes[i].mem_priv);
+			vb->vb2.planes[i].dbuf_mapped = 0;
 		}
 }
 
 static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
-	struct vb2_buffer *vb = NULL;
+	struct vb2_v4l2_buffer *vb = NULL;
 	int ret;
 
 	if (b->type != q->type) {
@@ -2054,7 +2061,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	if (ret < 0)
 		return ret;
 
-	switch (vb->state) {
+	switch (vb->vb2.state) {
 	case VB2_BUF_STATE_DONE:
 		dprintk(3, "returning done buffer\n");
 		break;
@@ -2071,13 +2078,13 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
 	/* Remove from videobuf queue */
-	list_del(&vb->queued_entry);
+	list_del(&vb->vb2.queued_entry);
 	q->queued_count--;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
-			vb->v4l2_buf.index, vb->state);
+			vb->v4l2_buf.index, vb->vb2.state);
 
 	return 0;
 }
@@ -2122,6 +2129,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
 static void __vb2_queue_cancel(struct vb2_queue *q)
 {
 	unsigned int i;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * Tell driver to stop all transactions and release all queued
@@ -2138,8 +2146,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
-			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+		{
+			vb = (struct vb2_v4l2_buffer *)q->bufs[i];
+			if (vb->vb2.state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		}
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
@@ -2171,10 +2182,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
 	 */
 	for (i = 0; i < q->num_buffers; ++i) {
-		struct vb2_buffer *vb = q->bufs[i];
+		struct vb2_v4l2_buffer *vb = q->bufs[i];
 
-		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-			vb->state = VB2_BUF_STATE_PREPARED;
+		if (vb->vb2.state != VB2_BUF_STATE_DEQUEUED) {
+			vb->vb2.state = VB2_BUF_STATE_PREPARED;
 			call_void_vb_qop(vb, buf_finish, vb);
 		}
 		__vb2_dqbuf(vb);
@@ -2322,7 +2333,7 @@ EXPORT_SYMBOL_GPL(vb2_streamoff);
 static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 			unsigned int *_buffer, unsigned int *_plane)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int buffer, plane;
 
 	/*
@@ -2333,7 +2344,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
 		vb = q->bufs[buffer];
 
-		for (plane = 0; plane < vb->num_planes; ++plane) {
+		for (plane = 0; plane < vb->vb2.num_planes; ++plane) {
 			if (vb->v4l2_planes[plane].m.mem_offset == off) {
 				*_buffer = buffer;
 				*_plane = plane;
@@ -2356,7 +2367,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
  */
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
-	struct vb2_buffer *vb = NULL;
+	struct vb2_v4l2_buffer *vb = NULL;
 	struct vb2_plane *vb_plane;
 	int ret;
 	struct dma_buf *dbuf;
@@ -2388,7 +2399,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 
 	vb = q->bufs[eb->index];
 
-	if (eb->plane >= vb->num_planes) {
+	if (eb->plane >= vb->vb2.num_planes) {
 		dprintk(1, "buffer plane out of range\n");
 		return -EINVAL;
 	}
@@ -2398,7 +2409,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 		return -EBUSY;
 	}
 
-	vb_plane = &vb->planes[eb->plane];
+	vb_plane = &vb->vb2.planes[eb->plane];
 
 	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
 	if (IS_ERR_OR_NULL(dbuf)) {
@@ -2445,7 +2456,7 @@ EXPORT_SYMBOL_GPL(vb2_expbuf);
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int buffer = 0, plane = 0;
 	int ret;
 	unsigned long length;
@@ -2500,7 +2511,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	}
 
 	mutex_lock(&q->mmap_lock);
-	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
+	ret = call_memop(vb, mmap, vb->vb2.planes[plane].mem_priv, vma);
 	mutex_unlock(&q->mmap_lock);
 	if (ret)
 		return ret;
@@ -2518,7 +2529,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 				    unsigned long flags)
 {
 	unsigned long off = pgoff << PAGE_SHIFT;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int buffer, plane;
 	void *vaddr;
 	int ret;
@@ -2658,7 +2669,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
  * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
  * for more information.
  */
 int vb2_queue_init(struct vb2_queue *q)
@@ -2689,7 +2700,7 @@ int vb2_queue_init(struct vb2_queue *q)
 	init_waitqueue_head(&q->done_wq);
 
 	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_buffer);
+		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
 	return 0;
 }
@@ -2773,6 +2784,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	struct vb2_fileio_data *fileio;
 	int i, ret;
 	unsigned int count = 0;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * Sanity check
@@ -2823,7 +2835,8 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Check if plane_count is correct
 	 * (multiplane buffers are not supported).
 	 */
-	if (q->bufs[0]->num_planes != 1) {
+	vb = (struct vb2_v4l2_buffer *)q->bufs[0];
+	if (vb->vb2.num_planes != 1) {
 		ret = -EBUSY;
 		goto err_reqbufs;
 	}
@@ -3133,7 +3146,7 @@ static int vb2_thread(void *data)
 	set_freezable();
 
 	for (;;) {
-		struct vb2_buffer *vb;
+		struct vb2_v4l2_buffer *vb;
 
 		/*
 		 * Call vb2_dqbuf to get buffer back.
@@ -3225,7 +3238,6 @@ EXPORT_SYMBOL_GPL(vb2_thread_start);
 int vb2_thread_stop(struct vb2_queue *q)
 {
 	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
 	int err;
 
 	if (threadio == NULL)
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index bcde885..386064c 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-memops.h>
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 06d48d5..3a61e7d 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -474,7 +474,7 @@ void vpfe_video_process_buffer_complete(struct vpfe_video_device *video)
 	struct vpfe_pipeline *pipe = &video->pipe;
 
 	do_gettimeofday(&video->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_DONE);
+	vb2_v4l2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_DONE);
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
 		video->cur_frm = video->next_frm;
 }
@@ -1112,15 +1112,15 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 /*
  * vpfe_buffer_prepare : callback function for buffer prepare
- * @vb: ptr to vb2_buffer
+ * @vb: ptr to vb2_v4l2_buffer
  *
  * This is the callback function for buffer prepare when vb2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
-static int vpfe_buffer_prepare(struct vb2_buffer *vb)
+static int vpfe_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct vpfe_video_device *video = fh->video;
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	unsigned long addr;
@@ -1145,10 +1145,10 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void vpfe_buffer_queue(struct vb2_buffer *vb)
+static void vpfe_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	/* Get the file handle object and device object */
-	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct vpfe_video_device *video = fh->video;
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct vpfe_pipeline *pipe = &video->pipe;
@@ -1223,10 +1223,10 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret) {
 		struct vpfe_cap_buffer *buf, *tmp;
 
-		vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+		vb2_v4l2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_QUEUED);
 		list_for_each_entry_safe(buf, tmp, &video->dma_queue, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_v4l2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
 		}
 		goto unlock_out;
 	}
@@ -1241,7 +1241,7 @@ streamoff:
 	return 0;
 }
 
-static int vpfe_buffer_init(struct vb2_buffer *vb)
+static int vpfe_buffer_init(struct vb2_v4l2_buffer *vb)
 {
 	struct vpfe_cap_buffer *buf = container_of(vb,
 						   struct vpfe_cap_buffer, vb);
@@ -1258,13 +1258,13 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 
 	/* release all active buffers */
 	if (video->cur_frm == video->next_frm) {
-		vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_ERROR);
 	} else {
 		if (video->cur_frm != NULL)
-			vb2_buffer_done(&video->cur_frm->vb,
+			vb2_v4l2_buffer_done(&video->cur_frm->vb,
 					VB2_BUF_STATE_ERROR);
 		if (video->next_frm != NULL)
-			vb2_buffer_done(&video->next_frm->vb,
+			vb2_v4l2_buffer_done(&video->next_frm->vb,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -1272,13 +1272,13 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 		video->next_frm = list_entry(video->dma_queue.next,
 						struct vpfe_cap_buffer, list);
 		list_del(&video->next_frm->list);
-		vb2_buffer_done(&video->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(&video->next_frm->vb, VB2_BUF_STATE_ERROR);
 	}
 }
 
-static void vpfe_buf_cleanup(struct vb2_buffer *vb)
+static void vpfe_buf_cleanup(struct vb2_v4l2_buffer *vb)
 {
-	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct vpfe_video_device *video = fh->video;
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct vpfe_cap_buffer *buf = container_of(vb,
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index 1b1b6c4..6a82257 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -72,7 +72,7 @@ struct vpfe_pipeline {
 	container_of(vdev, struct vpfe_video_device, video_dev)
 
 struct vpfe_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 293ffda..fa995bc 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -190,7 +190,7 @@ static int wait_i2c_reg(void __iomem *addr)
 static int
 dt3155_start_acq(struct dt3155_priv *pd)
 {
-	struct vb2_buffer *vb = pd->curr_buf;
+	struct vb2_v4l2_buffer *vb = pd->curr_buf;
 	dma_addr_t dma_addr;
 
 	dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
@@ -256,7 +256,7 @@ dt3155_wait_finish(struct vb2_queue *q)
 }
 
 static int
-dt3155_buf_prepare(struct vb2_buffer *vb)
+dt3155_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
 	vb2_set_plane_payload(vb, 0, img_width * img_height);
 	return 0;
@@ -272,21 +272,21 @@ dt3155_stop_streaming(struct vb2_queue *q)
 	while (!list_empty(&pd->dmaq)) {
 		vb = list_first_entry(&pd->dmaq, typeof(*vb), done_entry);
 		list_del(&vb->done_entry);
-		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irq(&pd->lock);
 	msleep(45); /* irq hendler will stop the hardware */
 }
 
 static void
-dt3155_buf_queue(struct vb2_buffer *vb)
+dt3155_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
+	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 
 	/*  pd->q->streaming = 1 when dt3155_buf_queue() is invoked  */
 	spin_lock_irq(&pd->lock);
 	if (pd->curr_buf)
-		list_add_tail(&vb->done_entry, &pd->dmaq);
+		list_add_tail(&vb->vb2_buf.done_entry, &pd->dmaq);
 	else {
 		pd->curr_buf = vb;
 		dt3155_start_acq(pd);
@@ -342,7 +342,7 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 	if (ipd->curr_buf) {
 		v4l2_get_timestamp(&ipd->curr_buf->v4l2_buf.timestamp);
 		ipd->curr_buf->v4l2_buf.sequence = (ipd->field_count) >> 1;
-		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
+		vb2_v4l2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (!ipd->q->streaming || list_empty(&ipd->dmaq))
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 2e4f89d..5e4fa61 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -196,7 +196,7 @@ struct dt3155_priv {
 	struct video_device *vdev;
 	struct pci_dev *pdev;
 	struct vb2_queue *q;
-	struct vb2_buffer *curr_buf;
+	struct vb2_v4l2_buffer *curr_buf;
 	struct mutex mux;
 	struct list_head dmaq;
 	spinlock_t lock;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 6955044..8df1b10 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -309,7 +309,7 @@ static int iss_video_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void iss_video_buf_cleanup(struct vb2_buffer *vb)
+static void iss_video_buf_cleanup(struct vb2_v4l2_buffer *vb)
 {
 	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
 
@@ -317,9 +317,9 @@ static void iss_video_buf_cleanup(struct vb2_buffer *vb)
 		buffer->iss_addr = 0;
 }
 
-static int iss_video_buf_prepare(struct vb2_buffer *vb)
+static int iss_video_buf_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
+	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
 	struct iss_video *video = vfh->video;
 	unsigned long size = vfh->format.fmt.pix.sizeimage;
@@ -340,9 +340,9 @@ static int iss_video_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void iss_video_buf_queue(struct vb2_buffer *vb)
+static void iss_video_buf_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
+	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct iss_video *video = vfh->video;
 	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
 	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
@@ -357,7 +357,7 @@ static void iss_video_buf_queue(struct vb2_buffer *vb)
 	 * need to handle the race condition with an authoritative check here.
 	 */
 	if (unlikely(video->error)) {
-		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->qlock, flags);
 		return;
 	}
@@ -449,7 +449,7 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	else
 		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
 
-	vb2_buffer_done(&buf->vb, pipe->error ?
+	vb2_v4l2_buffer_done(&buf->vb, pipe->error ?
 			VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 	pipe->error = false;
 
@@ -503,7 +503,7 @@ void omap4iss_video_cancel_stream(struct iss_video *video)
 		buf = list_first_entry(&video->dmaqueue, struct iss_buffer,
 				       list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 
 	vb2_queue_error(video->queue);
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index f11fce2..cf30642 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -18,7 +18,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #define ISS_VIDEO_DRIVER_NAME		"issvideo"
@@ -117,7 +117,7 @@ static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
  */
 struct iss_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	dma_addr_t iss_addr;
 };
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 8ea8b3b..ccf1be7 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -58,9 +58,9 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int uvc_buffer_prepare(struct vb2_buffer *vb)
+static int uvc_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
 	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
@@ -83,9 +83,9 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void uvc_buffer_queue(struct vb2_buffer *vb)
+static void uvc_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_buf.vb2_queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 	unsigned long flags;
 
@@ -98,7 +98,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&queue->irqlock, flags);
@@ -292,7 +292,7 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 				       queue);
 		list_del(&buf->queue);
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_v4l2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
 	}
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
@@ -383,7 +383,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	vb2_v4l2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
 }
diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
index 03919c7..2f0ef74 100644
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
@@ -26,7 +26,7 @@ enum uvc_buffer_state {
 };
 
 struct uvc_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	enum uvc_buffer_state state;
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index fa0247a..63c16ed 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -64,7 +64,7 @@ struct display_layer_info {
 };
 
 struct vpbe_disp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
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
index c5f3914..225c2a6 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -17,7 +17,7 @@
 #ifndef _MEDIA_V4L2_MEM2MEM_H
 #define _MEDIA_V4L2_MEM2MEM_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 /**
  * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
@@ -86,7 +86,7 @@ struct v4l2_m2m_ctx {
 };
 
 struct v4l2_m2m_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 };
 
@@ -101,7 +101,7 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
 
 static inline void
-v4l2_m2m_buf_done(struct vb2_buffer *buf, enum vb2_buffer_state state)
+v4l2_m2m_buf_done(struct vb2_v4l2_buffer *buf, enum vb2_buffer_state state)
 {
 	vb2_buffer_done(buf, state);
 }
@@ -154,7 +154,7 @@ static inline void v4l2_m2m_set_dst_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_v4l2_buffer *vb);
 
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bd2cec2..3b5df66 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1,5 +1,5 @@
 /*
- * videobuf2-core.h - V4L2 driver helper framework
+ * videobuf2-core.h - Video Buffer 2 framework
  *
  * Copyright (C) 2010 Samsung Electronics
  *
@@ -171,18 +171,7 @@ enum vb2_buffer_state {
 struct vb2_queue;
 
 /**
- * struct vb2_buffer - represents a video buffer
- * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as timestamp)
- * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as bytesused); NOTE that even for single-planar
- *			types, the v4l2_planes[0] struct should be used
- *			instead of v4l2_buf for filling bytesused - drivers
- *			should use the vb2_set_plane_payload() function for that
+ * struct vb2_buffer - represents a common video buffer
  * @vb2_queue:		the queue to which this driver belongs
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
@@ -194,11 +183,7 @@ struct vb2_queue;
  * @planes:		private per-plane information; do not change
  */
 struct vb2_buffer {
-	struct v4l2_buffer	v4l2_buf;
-	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
-
 	struct vb2_queue	*vb2_queue;
-
 	unsigned int		num_planes;
 
 /* Private: internal use only */
@@ -242,6 +227,27 @@ struct vb2_buffer {
 };
 
 /**
+ * struct vb2_v4l2_buffer - represents a video buffer for v4l2
+ * @vb2_buf:		common video buffer
+ * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as timestamp)
+ * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as bytesused); NOTE that even for single-planar
+ *			types, the v4l2_planes[0] struct should be used
+ *			instead of v4l2_buf for filling bytesused - drivers
+ *			should use the vb2_set_plane_payload() function for that
+ */
+struct vb2_v4l2_buffer {
+	struct vb2_buffer	vb2;
+	struct v4l2_buffer	v4l2_buf;
+	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
+};
+
+/**
  * struct vb2_ops - driver-specific callbacks
  *
  * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
@@ -328,15 +334,15 @@ struct vb2_ops {
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
-	int (*buf_init)(struct vb2_buffer *vb);
-	int (*buf_prepare)(struct vb2_buffer *vb);
-	void (*buf_finish)(struct vb2_buffer *vb);
-	void (*buf_cleanup)(struct vb2_buffer *vb);
+	int (*buf_init)(struct vb2_v4l2_buffer *vb);
+	int (*buf_prepare)(struct vb2_v4l2_buffer *vb);
+	void (*buf_finish)(struct vb2_v4l2_buffer *vb);
+	void (*buf_cleanup)(struct vb2_v4l2_buffer *vb);
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	void (*stop_streaming)(struct vb2_queue *q);
 
-	void (*buf_queue)(struct vb2_buffer *vb);
+	void (*buf_queue)(struct vb2_v4l2_buffer *vb);
 };
 
 struct v4l2_fh;
@@ -361,7 +367,7 @@ struct v4l2_fh;
  * @drv_priv:	driver private data
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
- *		structure type, so sizeof(struct vb2_buffer) will is used
+ *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
  * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
  *		V4L2_BUF_FLAG_TSTAMP_SRC_*
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
@@ -398,7 +404,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	unsigned int			io_flags;
 	struct mutex			*lock;
-	struct v4l2_fh			*owner;
+	void					*owner;
 
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
@@ -411,7 +417,7 @@ struct vb2_queue {
 /* private: internal use only */
 	struct mutex			mmap_lock;
 	enum v4l2_memory		memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	void					*bufs[VIDEO_MAX_FRAME];
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
@@ -446,10 +452,10 @@ struct vb2_queue {
 #endif
 };
 
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
-void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
 
-void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
@@ -489,7 +495,7 @@ size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
  *
  * This is called whenever a buffer is dequeued in the thread.
  */
-typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
+typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *vb, void *priv);
 
 /**
  * vb2_thread_start() - start a thread for the given queue.
@@ -566,10 +572,10 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
  */
-static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
+static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2.num_planes)
 		vb->v4l2_planes[plane_no].bytesused = size;
 }
 
@@ -579,10 +585,10 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
  */
-static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
+static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
 				 unsigned int plane_no)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2.num_planes)
 		return vb->v4l2_planes[plane_no].bytesused;
 	return 0;
 }
@@ -593,9 +599,9 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
  * @plane_no:	plane number for which size should be returned
  */
 static inline unsigned long
-vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
+vb2_plane_size(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2.num_planes)
 		return vb->v4l2_planes[plane_no].length;
 	return 0;
 }
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 8197f87..3de9111 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -13,11 +13,11 @@
 #ifndef _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 #define _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <linux/dma-mapping.h>
 
 static inline dma_addr_t
-vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
+vb2_dma_contig_plane_dma_addr(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
 	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
 
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 14ce306..36f7ea3 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -13,10 +13,10 @@
 #ifndef _MEDIA_VIDEOBUF2_DMA_SG_H
 #define _MEDIA_VIDEOBUF2_DMA_SG_H
 
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 
 static inline struct sg_table *vb2_dma_sg_plane_desc(
-		struct vb2_buffer *vb, unsigned int plane_no)
+		struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
 	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
 }
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
similarity index 94%
copy from include/media/videobuf2-core.h
copy to include/media/videobuf2-v4l2.h
index bd2cec2..80b08cb 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-v4l2.h
@@ -9,8 +9,8 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  */
-#ifndef _MEDIA_VIDEOBUF2_CORE_H
-#define _MEDIA_VIDEOBUF2_CORE_H
+#ifndef _MEDIA_VIDEOBUF2_V4L2_H
+#define _MEDIA_VIDEOBUF2_V4L2_H
 
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
@@ -171,18 +171,7 @@ enum vb2_buffer_state {
 struct vb2_queue;
 
 /**
- * struct vb2_buffer - represents a video buffer
- * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as timestamp)
- * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as bytesused); NOTE that even for single-planar
- *			types, the v4l2_planes[0] struct should be used
- *			instead of v4l2_buf for filling bytesused - drivers
- *			should use the vb2_set_plane_payload() function for that
+ * struct vb2_buffer - represents a common video buffer
  * @vb2_queue:		the queue to which this driver belongs
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
@@ -194,11 +183,7 @@ struct vb2_queue;
  * @planes:		private per-plane information; do not change
  */
 struct vb2_buffer {
-	struct v4l2_buffer	v4l2_buf;
-	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
-
 	struct vb2_queue	*vb2_queue;
-
 	unsigned int		num_planes;
 
 /* Private: internal use only */
@@ -242,6 +227,27 @@ struct vb2_buffer {
 };
 
 /**
+ * struct vb2_v4l2_buffer - represents a video buffer for v4l2
+ * @vb2_buf:		common video buffer
+ * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as timestamp)
+ * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as bytesused); NOTE that even for single-planar
+ *			types, the v4l2_planes[0] struct should be used
+ *			instead of v4l2_buf for filling bytesused - drivers
+ *			should use the vb2_set_plane_payload() function for that
+ */
+struct vb2_v4l2_buffer {
+	struct vb2_buffer	vb2;
+	struct v4l2_buffer	v4l2_buf;
+	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
+};
+
+/**
  * struct vb2_ops - driver-specific callbacks
  *
  * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
@@ -328,15 +334,15 @@ struct vb2_ops {
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
-	int (*buf_init)(struct vb2_buffer *vb);
-	int (*buf_prepare)(struct vb2_buffer *vb);
-	void (*buf_finish)(struct vb2_buffer *vb);
-	void (*buf_cleanup)(struct vb2_buffer *vb);
+	int (*buf_init)(struct vb2_v4l2_buffer *vb);
+	int (*buf_prepare)(struct vb2_v4l2_buffer *vb);
+	void (*buf_finish)(struct vb2_v4l2_buffer *vb);
+	void (*buf_cleanup)(struct vb2_v4l2_buffer *vb);
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	void (*stop_streaming)(struct vb2_queue *q);
 
-	void (*buf_queue)(struct vb2_buffer *vb);
+	void (*buf_queue)(struct vb2_v4l2_buffer *vb);
 };
 
 struct v4l2_fh;
@@ -361,7 +367,7 @@ struct v4l2_fh;
  * @drv_priv:	driver private data
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
- *		structure type, so sizeof(struct vb2_buffer) will is used
+ *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
  * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
  *		V4L2_BUF_FLAG_TSTAMP_SRC_*
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
@@ -398,7 +404,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	unsigned int			io_flags;
 	struct mutex			*lock;
-	struct v4l2_fh			*owner;
+	void					*owner;
 
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
@@ -411,7 +417,7 @@ struct vb2_queue {
 /* private: internal use only */
 	struct mutex			mmap_lock;
 	enum v4l2_memory		memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	void					*bufs[VIDEO_MAX_FRAME];
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
@@ -446,10 +452,10 @@ struct vb2_queue {
 #endif
 };
 
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
-void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
 
-void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
@@ -489,7 +495,7 @@ size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
  *
  * This is called whenever a buffer is dequeued in the thread.
  */
-typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
+typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *vb, void *priv);
 
 /**
  * vb2_thread_start() - start a thread for the given queue.
@@ -566,10 +572,10 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
  */
-static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
+static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2.num_planes)
 		vb->v4l2_planes[plane_no].bytesused = size;
 }
 
@@ -579,10 +585,10 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
  */
-static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
+static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
 				 unsigned int plane_no)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2.num_planes)
 		return vb->v4l2_planes[plane_no].bytesused;
 	return 0;
 }
@@ -593,9 +599,9 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
  * @plane_no:	plane number for which size should be returned
  */
 static inline unsigned long
-vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
+vb2_plane_size(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no < vb->num_planes)
+	if (plane_no < vb->vb2.num_planes)
 		return vb->v4l2_planes[plane_no].length;
 	return 0;
 }
@@ -653,4 +659,4 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 void vb2_ops_wait_prepare(struct vb2_queue *vq);
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
-#endif /* _MEDIA_VIDEOBUF2_CORE_H */
+#endif /* _MEDIA_VIDEOBUF2_V4L2_H */
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


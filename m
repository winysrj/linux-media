Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57313 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbbGaIpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 04:45:03 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSC015R0GAG8Q30@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Jul 2015 17:44:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH v2 3/5] media: videobuf2: Divide videobuf2-core into 2 parts
Date: Fri, 31 Jul 2015 17:44:35 +0900
Message-id: <1438332277-6542-4-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Divide videobuf2-core into core part and v4l2-specific part
 - core part: videobuf2 core related with buffer management & memory allocation
 - v4l2-specific part: v4l2-specific stuff

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |    4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    3 +-
 drivers/media/pci/cx25821/cx25821.h                |    1 +
 drivers/media/pci/cx88/cx88-blackbird.c            |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |    2 +-
 drivers/media/pci/cx88/cx88-video.c                |    4 +-
 drivers/media/pci/dt3155/dt3155.c                  |    4 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/saa7134/saa7134.h                |    3 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    3 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/tw68/tw68-video.c                |    3 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    4 +-
 drivers/media/platform/coda/coda-common.c          |    3 +-
 drivers/media/platform/davinci/vpbe_display.c      |    3 +-
 drivers/media/platform/davinci/vpif_capture.c      |    4 +-
 drivers/media/platform/davinci/vpif_display.c      |    4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    3 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    3 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    3 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    7 +-
 drivers/media/platform/mx2_emmaprp.c               |    3 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    3 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    3 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    3 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    2 +-
 drivers/media/platform/sh_veu.c                    |    4 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    3 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    4 +-
 drivers/media/platform/ti-vpe/vpe.c                |    3 +-
 drivers/media/platform/vim2m.c                     |    3 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    3 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    3 +-
 drivers/media/platform/vsp1/vsp1_video.c           |    3 +-
 drivers/media/usb/airspy/airspy.c                  |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    3 +-
 drivers/media/usb/au0828/au0828-video.c            |    3 +-
 drivers/media/usb/au0828/au0828.h                  |    1 +
 drivers/media/usb/em28xx/em28xx-vbi.c              |    3 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    3 +-
 drivers/media/usb/em28xx/em28xx.h                  |    1 +
 drivers/media/usb/go7007/go7007-v4l2.c             |    3 +-
 drivers/media/usb/hackrf/hackrf.c                  |    2 +-
 drivers/media/usb/msi2500/msi2500.c                |    3 +-
 drivers/media/usb/pwc/pwc-if.c                     |    2 +-
 drivers/media/usb/pwc/pwc.h                        |    1 +
 drivers/media/usb/s2255/s2255drv.c                 |    3 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    3 +-
 drivers/media/usb/usbtv/usbtv.h                    |    1 +
 drivers/media/usb/uvc/uvc_queue.c                  |    3 +-
 drivers/media/v4l2-core/Makefile                   |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 1797 ++++++++++++++++
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
 drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 2260 +++-----------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    2 +-
 drivers/usb/gadget/function/uvc_queue.c            |    2 +-
 include/media/videobuf2-core.h                     |  724 +++++++
 include/media/videobuf2-dma-contig.h               |    2 +-
 include/media/videobuf2-dma-sg.h                   |    2 +-
 include/media/videobuf2-memops.h                   |    2 +-
 include/media/videobuf2-v4l2.h                     |  509 +----
 include/media/videobuf2-vmalloc.h                  |    2 +-
 include/trace/events/v4l2.h                        |    3 +-
 88 files changed, 2919 insertions(+), 2591 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-core.c
 create mode 100644 include/media/videobuf2-core.h

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 2147a90..d7ea662 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
 /* read 512 bytes from endpoint 0x86 -> get header + blobs */
@@ -642,10 +643,11 @@ static void sur40_disconnect(struct usb_interface *interface)
  * minimum number: many DMA engines need a minimum of 2 buffers in the
  * queue and you need to have another available for userspace processing.
  */
-static int sur40_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int sur40_queue_setup(struct vb2_queue *q, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
+	const struct v4l2_format *fmt = (const struct v4l2_format *) parg;
 	struct sur40_state *sur40 = vb2_get_drv_priv(q);
 
 	if (q->num_buffers + *nbuffers < 3)
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index c900185d..8d36149 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -488,7 +488,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		const void *parg, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 316a322..88a3afb 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1138,7 +1138,7 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 09ad512..c4307ad 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -92,7 +92,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index e84e5bd..d1fd585 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -121,7 +121,7 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index d06fc87..d7c6729 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -315,7 +315,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 	return 0;
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index af0e425..5e672f2 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -141,10 +141,11 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	return handled;
 }
 
-static int cx25821_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int cx25821_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct cx25821_channel *chan = q->drv_priv;
 	unsigned size = (chan->fmt->depth * chan->width * chan->height) >> 3;
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index fb2920c..a513b68 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -34,6 +34,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
 #include "cx25821-reg.h"
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 49d0b7c..8b88913 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -637,7 +637,7 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index f0923fb..f048350 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -82,7 +82,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index a4f5e1e..a315cd6 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -225,7 +225,7 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 			struct cx88_buffer *buf)
 {
 	int size = dev->ts_packet_size * dev->ts_packet_count;
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
 	struct cx88_riscmem *risc = &buf->risc;
 	int rc;
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index cd2f3fb..2bdfbb9 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -107,7 +107,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index fae28e7..4af3808 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -429,7 +429,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -447,7 +447,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	buf->bpl = core->width * dev->fmt->depth >> 3;
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index f4f8355..0aa45d0 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "dt3155.h"
@@ -131,11 +132,12 @@ static int wait_i2c_reg(void __iomem *addr)
 }
 
 static int
-dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+dt3155_queue_setup(struct vb2_queue *vq, const void *parg,
 		unsigned int *nbuffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 
 {
+	const struct v4l2_format *fmt = (const struct v4l2_format *) parg;
 	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
 	unsigned size = pd->width * pd->height;
 
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 62b218b..b19a00f 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -116,7 +116,7 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb)
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
-int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index ecc4e61..c3cdb89 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -138,7 +138,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index a03bbb8..7ea9411 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -904,7 +904,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index f3f9ba4..ffeaf65 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -43,6 +43,7 @@
 #include <media/tuner.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -819,7 +820,7 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb);
-int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
 int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 6238e09..19dc488 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -660,8 +660,7 @@ static int solo_ring_thread(void *data)
 	return 0;
 }
 
-static int solo_enc_queue_setup(struct vb2_queue *q,
-				const struct v4l2_format *fmt,
+static int solo_enc_queue_setup(struct vb2_queue *q, const void *parg,
 				unsigned int *num_buffers,
 				unsigned int *num_planes, unsigned int sizes[],
 				void *alloc_ctxs[])
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index b46196b..628d019 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -312,7 +312,7 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 	solo_dev->kthread = NULL;
 }
 
-static int solo_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int solo_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 1edc1f2..a4dc2d5 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -265,7 +265,7 @@ static void vip_active_buf_next(struct sta2x11_vip *vip)
 
 
 /* Videobuf2 Operations */
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index a2ecc5c..82dbc9a 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -376,10 +376,11 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
 /* ------------------------------------------------------------- */
 /* vb2 queue operations                                          */
 
-static int tw68_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int tw68_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct tw68_dev *dev = vb2_get_drv_priv(q);
 	unsigned tot_bufs = q->num_buffers + *num_buffers;
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 2a03c1a..1c87afe 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -201,11 +201,11 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 	bcap_dev->sensor_formats = NULL;
 }
 
-static int bcap_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int bcap_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	const struct v4l2_format *fmt = (const struct v4l2_format *)parg;
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 
 	if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0b84bd3..10c4a9e 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1131,8 +1131,7 @@ static void set_default_params(struct coda_ctx *ctx)
 /*
  * Queue operations
  */
-static int coda_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int coda_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index bf5bf69..c0703aa 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -228,11 +228,12 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
  * This function allocates memory for the buffers
  */
 static int
-vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+vpbe_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *nbuffers, unsigned int *nplanes,
 			unsigned int sizes[], void *alloc_ctxs[])
 
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	/* Get the file handle object and layer object */
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
 	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d0d76e2..b583ff1 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -112,11 +112,11 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * This callback function is called when reqbuf() is called to adjust
  * the buffer count and buffer size
  */
-static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int vpif_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 46fc783..f7963bd 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -107,11 +107,11 @@ static int vpif_buffer_prepare(struct vb2_v4l2_buffer *vb)
  * This callback function is called when reqbuf() is called to adjust
  * the buffer count and buffer size
  */
-static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int vpif_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 6003a4f..95df3a9 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -211,8 +211,7 @@ put_device:
 	spin_unlock_irqrestore(&gsc->slock, flags);
 }
 
-static int gsc_m2m_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+static int gsc_m2m_queue_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 78133c1..01bb3d7 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -345,10 +345,11 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
+	struct v4l2_format *pfmt = (struct v4l2_format *)parg;
 	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_ctx *ctx = vq->drv_priv;
 	struct fimc_frame *frame = &ctx->d_frame;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 52e1d61..2383724 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -39,10 +39,11 @@
 #include "fimc-is-param.h"
 
 static int isp_video_capture_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *pfmt,
+			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
+	struct v4l2_format *pfmt = (struct v4l2_format *)parg;
 	struct fimc_isp *isp = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format_mplane *vid_fmt = &isp->video_capture.pixfmt;
 	const struct v4l2_pix_format_mplane *pixm = NULL;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 316d25b..e9aaee7 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -361,10 +361,11 @@ static void stop_streaming(struct vb2_queue *q)
 	fimc_lite_stop_capture(fimc, false);
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
+	struct v4l2_format *pfmt = (struct v4l2_format *)parg;
 	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_lite *fimc = vq->drv_priv;
 	struct flite_frame *frame = &fimc->out_frame;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index f6e72b4..06d6436 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -176,7 +176,7 @@ static void fimc_job_abort(void *priv)
 	fimc_m2m_shutdown(priv);
 }
 
-static int fimc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int fimc_queue_setup(struct vb2_queue *vq, const void *parg,
 			    unsigned int *num_buffers, unsigned int *num_planes,
 			    unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 475e82d..e67f9d2 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -797,8 +797,7 @@ struct vb2_dc_conf {
 	struct device           *dev;
 };
 
-static int deinterlace_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int deinterlace_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 645ebf8..b3735a7 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1049,10 +1049,11 @@ static int mcam_read_setup(struct mcam_camera *cam)
  */
 
 static int mcam_vb_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbufs,
+		const void *parg, unsigned int *nbufs,
 		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
+	const struct v4l2_format *fmt = (const struct v4l2_format *) parg;
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
@@ -1098,14 +1099,14 @@ static void mcam_vb_requeue_bufs(struct vb2_queue *vq,
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	list_for_each_entry_safe(buf, node, &cam->buffers, queue) {
-		vb2_buffer_done(&buf->vb_buf, state);
+		vb2_buffer_done(&buf->vb_buf.vb2_buf, state);
 		list_del(&buf->queue);
 	}
 	for (i = 0; i < MAX_DMA_BUFS; i++) {
 		buf = cam->vb_bufs[i];
 
 		if (buf) {
-			vb2_buffer_done(&buf->vb_buf, state);
+			vb2_buffer_done(&buf->vb_buf.vb2_buf, state);
 			cam->vb_bufs[i] = NULL;
 		}
 	}
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 03072e2..269e1bc 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -688,8 +688,7 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
 /*
  * Queue operations
  */
-static int emmaprp_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int emmaprp_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 09d4c82..65f57a2 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -319,8 +319,7 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
  * Video queue operations
  */
 
-static int isp_video_queue_setup(struct vb2_queue *queue,
-				 const struct v4l2_format *fmt,
+static int isp_video_queue_setup(struct vb2_queue *queue, const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index c8bf624..8f4e9f4 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -442,10 +442,11 @@ static void stop_streaming(struct vb2_queue *vq)
 	camif_stop_capture(vp);
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
+	struct v4l2_format *pfmt = (struct v4l2_format *)parg;
 	const struct v4l2_pix_format *pix = NULL;
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
 	struct camif_dev *camif = vp->camif;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 9e50173..9fade63 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -101,7 +101,7 @@ static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
 	}
 }
 
-static int g2d_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int g2d_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 2300740..8fd178d 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2121,8 +2121,7 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
  * ============================================================================
  */
 
-static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+static int s5p_jpeg_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 7d75d8e..1de804d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -883,7 +883,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 };
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt, unsigned int *buf_count,
+			const void *parg, unsigned int *buf_count,
 			unsigned int *plane_count, unsigned int psize[],
 			void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e65249a..3b4b556 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1816,8 +1816,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 	return 0;
 }
 
-static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+static int s5p_mfc_queue_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *buf_count, unsigned int *plane_count,
 			unsigned int psize[], void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index dba92b5..dc1c679 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -881,7 +881,7 @@ static const struct v4l2_file_operations mxr_fops = {
 	.unlocked_ioctl = video_ioctl2,
 };
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 	unsigned int *nbuffers, unsigned int *nplanes, unsigned int sizes[],
 	void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index a0910d9..1affcae 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -864,11 +864,11 @@ static const struct v4l2_ioctl_ops sh_veu_ioctl_ops = {
 
 		/* ========== Queue operations ========== */
 
-static int sh_veu_queue_setup(struct vb2_queue *vq,
-			      const struct v4l2_format *f,
+static int sh_veu_queue_setup(struct vb2_queue *vq, const void *parg,
 			      unsigned int *nbuffers, unsigned int *nplanes,
 			      unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *f = (struct v4l2_format *)parg;
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vq);
 	struct sh_veu_vfmt *vfmt;
 	unsigned int size, count = *nbuffers;
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 621a1a7..7268a2f 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -235,7 +235,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index b250706..57e8ad0 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -469,10 +469,11 @@ static void mx2_camera_clock_stop(struct soc_camera_host *ici)
  *  Videobuf operations
  */
 static int mx2_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 6c566b8..fa8849f 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -184,11 +184,11 @@ static void mx3_cam_dma_done(void *arg)
 /*
  * Calculate the __buffer__ (not data) size and number of buffers.
  */
-static int mx3_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+static int mx3_videobuf_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index afa887e..c529d10 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -526,11 +526,11 @@ struct rcar_vin_cam {
  * required
  */
 static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
-				   const struct v4l2_format *fmt,
-				   unsigned int *count,
+				   const void *parg, unsigned int *count,
 				   unsigned int *num_planes,
 				   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index b46c3e3..7335b79 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -209,11 +209,11 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  *		  requested number of buffers and to fill in plane sizes
  *		  for the current frame format if required
  */
-static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 19fea47..6934a95 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1797,8 +1797,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 /*
  * Queue operations
  */
-static int vpe_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+static int vpe_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 267525a..7664319 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -709,8 +709,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
  * Queue operations
  */
 
-static int vim2m_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+static int vim2m_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 2b46175..cf7f56c 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -210,7 +210,7 @@ static int vivid_thread_sdr_cap(void *data)
 	return 0;
 }
 
-static int sdr_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int sdr_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 0ea990b..26837e4 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -136,7 +136,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
-static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 65097c6..a51fc70 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -27,7 +27,7 @@
 #include "vivid-vbi-out.h"
 #include "vivid-vbi-cap.h"
 
-static int vbi_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vbi_out_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1828a27..3ffa410 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -95,10 +95,11 @@ static const struct v4l2_discrete_probe webcam_probe = {
 	VIVID_WEBCAM_SIZES
 };
 
-static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vid_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	unsigned buffers = tpg_g_buffers(&dev->tpg);
 	unsigned h = dev->fmt_cap_rect.height;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index de7a076..9d3055c 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -31,10 +31,11 @@
 #include "vivid-kthread-out.h"
 #include "vivid-vid-out.h"
 
-static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vid_out_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	const struct vivid_fmt *vfmt = dev->fmt_out;
 	unsigned planes = vfmt->buffers;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 389fb0b..ee47aaf 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -788,10 +788,11 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
  */
 
 static int
-vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+vsp1_video_queue_setup(struct vb2_queue *vq, const void *parg,
 		     unsigned int *nbuffers, unsigned int *nplanes,
 		     unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	const struct v4l2_pix_format_mplane *format;
 	struct v4l2_pix_format_mplane pix_mp;
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 253884a..826687b 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -486,7 +486,7 @@ static void airspy_disconnect(struct usb_interface *intf)
 
 /* Videobuf2 operations */
 static int airspy_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		const void *parg, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 5fbf279..c207c03 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -30,10 +30,11 @@
 
 /* ------------------------------------------------------------------ */
 
-static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vbi_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long img_size = dev->vbi_width * dev->vbi_height * 2;
 	unsigned long size;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 28e374e..c73c627 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -638,10 +638,11 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long img_size = dev->height * dev->bytesperline;
 	unsigned long size;
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 270aa47..073ee00 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -29,6 +29,7 @@
 /* Analog */
 #include <linux/videodev2.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 50b33c9..4007b44 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -31,10 +31,11 @@
 
 /* ------------------------------------------------------------------ */
 
-static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vbi_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	unsigned long size;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index bbccaed..b34ff421 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -871,10 +871,11 @@ static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
 	Videobuf2 operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	unsigned long size;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e8512c4..76bf8ba 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -35,6 +35,7 @@
 #include <linux/kref.h>
 #include <linux/videodev2.h>
 
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 3d4e5db..8183a1d 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -368,8 +368,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return set_capture_size(go, fmt, 0);
 }
 
-static int go7007_queue_setup(struct vb2_queue *q,
-		const struct v4l2_format *fmt,
+static int go7007_queue_setup(struct vb2_queue *q, const void *parg,
 		unsigned int *num_buffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 935b920..c07b44f 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -464,7 +464,7 @@ static void hackrf_disconnect(struct usb_interface *intf)
 
 /* Videobuf2 operations */
 static int hackrf_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		const void *parg, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 77cfb7d..af4dd23 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -613,8 +613,7 @@ static int msi2500_querycap(struct file *file, void *fh,
 }
 
 /* Videobuf2 operations */
-static int msi2500_queue_setup(struct vb2_queue *vq,
-			       const struct v4l2_format *fmt,
+static int msi2500_queue_setup(struct vb2_queue *vq, const void *parg,
 			       unsigned int *nbuffers,
 			       unsigned int *nplanes, unsigned int sizes[],
 			       void *alloc_ctxs[])
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 2fc3c0f..79e4ca2 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -572,7 +572,7 @@ static void pwc_video_release(struct v4l2_device *v)
 /***************************************************************************/
 /* Videobuf2 operations */
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/pwc/pwc.h b/drivers/media/usb/pwc/pwc.h
index e2c12dc..e0d9125 100644
--- a/drivers/media/usb/pwc/pwc.h
+++ b/drivers/media/usb/pwc/pwc.h
@@ -40,6 +40,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 #include <linux/input.h>
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 4284e56..0d909a4 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -45,6 +45,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/usb.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
@@ -660,7 +661,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
    Videobuf operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 6e23b2b..a7daa08 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -664,7 +664,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 /*
  * Videobuf2 operations
  */
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 2f8674d..3e17802 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -599,9 +599,10 @@ static struct v4l2_file_operations usbtv_fops = {
 };
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
-	const struct v4l2_format *fmt, unsigned int *nbuffers,
+	const void *varg, unsigned int *nbuffers,
 	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
+	const struct v4l2_format *fmt = (const struct v4l2_format *)varg;
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
 	unsigned size = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
 
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index a1a4d95..19cb8bf 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -24,6 +24,7 @@
 #include <linux/usb.h>
 
 #include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 /* Hardware. */
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 2db04b2..2905123 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -68,10 +68,11 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
  * videobuf2 queue operations
  */
 
-static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int uvc_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 16865b8..c54dd26 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 
-obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-v4l2.o
+obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
new file mode 100644
index 0000000..0460a99
--- /dev/null
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -0,0 +1,1797 @@
+/*
+ * videobuf2-core.c - Video Buffer 2 Core Framework
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <pawel@osciak.com>
+ *	   Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * The vb2_thread implementation was based on code from videobuf-dvb.c:
+ *	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+
+#include <media/videobuf2-core.h>
+
+#include <trace/events/v4l2.h>
+
+int vb2_debug;
+module_param_named(debug, vb2_debug, int, 0644);
+
+static void __enqueue_in_driver(struct vb2_buffer *vb);
+static void __vb2_queue_cancel(struct vb2_queue *q);
+
+/**
+ * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
+ */
+static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	void *mem_priv;
+	int plane;
+
+	/*
+	 * Allocate memory for all planes in this buffer
+	 * NOTE: mmapped areas should be page aligned
+	 */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
+
+		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
+				      size, dma_dir, q->gfp_flags);
+		if (IS_ERR_OR_NULL(mem_priv))
+			goto free;
+
+		/* Associate allocator private data with this plane */
+		vb->planes[plane].mem_priv = mem_priv;
+		call_bufop(q, set_plane_length, vb, plane,
+				q->plane_sizes[plane]);
+	}
+
+	return 0;
+free:
+	/* Free already allocated memory if one of the allocations failed */
+	for (; plane > 0; --plane) {
+		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
+		vb->planes[plane - 1].mem_priv = NULL;
+	}
+
+	return -ENOMEM;
+}
+
+/**
+ * __vb2_buf_mem_free() - free memory of the given buffer
+ */
+static void __vb2_buf_mem_free(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		call_void_memop(vb, put, vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
+		VB2_DEBUG(3, "freed plane %d of buffer %d\n", plane,
+			vb2_index(vb));
+	}
+}
+
+/**
+ * __vb2_buf_userptr_put() - release userspace memory associated with
+ * a USERPTR buffer
+ */
+static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		if (vb->planes[plane].mem_priv)
+			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
+	}
+}
+
+/**
+ * __vb2_plane_dmabuf_put() - release memory associated with
+ * a DMABUF shared plane
+ */
+void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
+{
+	if (!p->mem_priv)
+		return;
+
+	if (p->dbuf_mapped)
+		call_void_memop(vb, unmap_dmabuf, p->mem_priv);
+
+	call_void_memop(vb, detach_dmabuf, p->mem_priv);
+	dma_buf_put(p->dbuf);
+	memset(p, 0, sizeof(*p));
+}
+
+/**
+ * __vb2_buf_dmabuf_put() - release memory associated with
+ * a DMABUF shared buffer
+ */
+void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
+{
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
+}
+
+/**
+ * __setup_lengths() - setup initial lengths for every plane in
+ * every buffer on the queue
+ */
+static void __setup_lengths(struct vb2_queue *q, unsigned int n)
+{
+	unsigned int buffer, plane;
+	struct vb2_buffer *vb;
+
+	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			call_bufop(q, set_plane_length, vb, plane,
+					q->plane_sizes[plane]);
+	}
+}
+
+/**
+ * __setup_offsets() - setup unique offsets ("cookies") for every plane in
+ * every buffer on the queue
+ */
+static void __setup_offsets(struct vb2_queue *q, unsigned int n)
+{
+	unsigned int buffer, plane;
+	struct vb2_buffer *vb;
+	unsigned long off;
+
+	if (q->num_buffers) {
+		vb = q->bufs[q->num_buffers - 1];
+		off = call_u32_bufop(q, get_plane_offset, vb, vb->num_planes - 1);
+		off += call_u32_bufop(q, get_plane_length, vb, vb->num_planes - 1);
+		off = PAGE_ALIGN(off);
+	} else {
+		off = 0;
+	}
+
+	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			call_bufop(q, set_plane_offset, vb, plane, off);
+
+			VB2_DEBUG(3, "buffer %d, plane %d offset 0x%08lx\n",
+					buffer, plane, off);
+
+			off += call_u32_bufop(q, get_plane_length, vb, plane);
+			off = PAGE_ALIGN(off);
+		}
+	}
+}
+
+/**
+ * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
+ * video buffer memory for all buffers/planes on the queue and initializes the
+ * queue
+ *
+ * Returns the number of buffers successfully allocated.
+ */
+static int __vb2_queue_alloc(struct vb2_queue *q, unsigned int memory,
+			     unsigned int num_buffers, unsigned int num_planes)
+{
+	unsigned int buffer;
+	struct vb2_buffer *vb;
+	int ret;
+
+	for (buffer = 0; buffer < num_buffers; ++buffer) {
+		/* Allocate videobuf buffer structures */
+		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
+		if (!vb) {
+			VB2_DEBUG(1, "memory alloc for buffer struct failed\n");
+			break;
+		}
+
+		vb->state = VB2_BUF_STATE_DEQUEUED;
+		vb->vb2_queue = q;
+		vb->num_planes = num_planes;
+		call_bufop(q, init_buffer, vb, memory, q->type,
+				q->num_buffers + buffer, num_planes);
+
+		/* Allocate video buffer memory for the MMAP type */
+		if (memory == V4L2_MEMORY_MMAP) {
+			ret = __vb2_buf_mem_alloc(vb);
+			if (ret) {
+				VB2_DEBUG(1, "failed allocating memory for "
+						"buffer %d\n", buffer);
+				kfree(vb);
+				break;
+			}
+			/*
+			 * Call the driver-provided buffer initialization
+			 * callback, if given. An error in initialization
+			 * results in queue setup failure.
+			 */
+			ret = call_vb_qop(vb, buf_init, vb);
+			if (ret) {
+				VB2_DEBUG(1, "buffer %d %p initialization"
+					" failed\n", buffer, vb);
+				__vb2_buf_mem_free(vb);
+				kfree(vb);
+				break;
+			}
+		}
+
+		q->bufs[q->num_buffers + buffer] = vb;
+	}
+
+	__setup_lengths(q, buffer);
+	if (memory == V4L2_MEMORY_MMAP)
+		__setup_offsets(q, buffer);
+
+	VB2_DEBUG(1, "allocated %d buffers, %d plane(s) each\n",
+			buffer, num_planes);
+
+	return buffer;
+}
+
+/**
+ * __vb2_free_mem() - release all video buffer memory for a given queue
+ */
+static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
+{
+	unsigned int buffer;
+	struct vb2_buffer *vb;
+
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		/* Free MMAP buffers or release USERPTR buffers */
+		if (q->memory == V4L2_MEMORY_MMAP)
+			__vb2_buf_mem_free(vb);
+		else if (q->memory == V4L2_MEMORY_DMABUF)
+			__vb2_buf_dmabuf_put(vb);
+		else
+			__vb2_buf_userptr_put(vb);
+	}
+}
+
+/**
+ * __vb2_queue_free() - free buffers at the end of the queue - video memory and
+ * related information, if no buffers are left return the queue to an
+ * uninitialized state. Might be called even if the queue has already been freed.
+ */
+static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
+{
+	unsigned int buffer;
+
+	/*
+	 * Sanity check: when preparing a buffer the queue lock is released for
+	 * a short while (see __buf_prepare for the details), which would allow
+	 * a race with a reqbufs which can call this function. Removing the
+	 * buffers from underneath __buf_prepare is obviously a bad idea, so we
+	 * check if any of the buffers is in the state PREPARING, and if so we
+	 * just return -EAGAIN.
+	 */
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
+		if (q->bufs[buffer] == NULL)
+			continue;
+		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
+			VB2_DEBUG(1, "preparing buffers, cannot free\n");
+			return -EAGAIN;
+		}
+	}
+
+	/* Call driver-provided cleanup function for each buffer, if provided */
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
+		struct vb2_buffer *vb = q->bufs[buffer];
+
+		if (vb && vb->planes[0].mem_priv)
+			call_void_vb_qop(vb, buf_cleanup, vb);
+	}
+
+	/* Release video buffer memory */
+	__vb2_free_mem(q, buffers);
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	/*
+	 * Check that all the calls were balances during the life-time of this
+	 * queue. If not (or if the debug level is 1 or up), then dump the
+	 * counters to the kernel log.
+	 */
+	if (q->num_buffers) {
+		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
+				  q->cnt_wait_prepare != q->cnt_wait_finish;
+
+		if (unbalanced || debug) {
+			pr_info("vb2: counters for queue %p:%s\n", q,
+				unbalanced ? " UNBALANCED!" : "");
+			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
+				q->cnt_queue_setup, q->cnt_start_streaming,
+				q->cnt_stop_streaming);
+			pr_info("vb2:     wait_prepare: %u wait_finish: %u\n",
+				q->cnt_wait_prepare, q->cnt_wait_finish);
+		}
+		q->cnt_queue_setup = 0;
+		q->cnt_wait_prepare = 0;
+		q->cnt_wait_finish = 0;
+		q->cnt_start_streaming = 0;
+		q->cnt_stop_streaming = 0;
+	}
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		struct vb2_buffer *vb = q->bufs[buffer];
+		bool unbalanced = vb->cnt_mem_alloc != vb->cnt_mem_put ||
+				  vb->cnt_mem_prepare != vb->cnt_mem_finish ||
+				  vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
+				  vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
+				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
+				  vb->cnt_buf_queue != vb->cnt_buf_done ||
+				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
+				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
+
+		if (unbalanced || debug) {
+			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
+				q, buffer, unbalanced ? " UNBALANCED!" : "");
+			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
+				vb->cnt_buf_init, vb->cnt_buf_cleanup,
+				vb->cnt_buf_prepare, vb->cnt_buf_finish);
+			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
+				vb->cnt_buf_queue, vb->cnt_buf_done);
+			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
+				vb->cnt_mem_alloc, vb->cnt_mem_put,
+				vb->cnt_mem_prepare, vb->cnt_mem_finish,
+				vb->cnt_mem_mmap);
+			pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
+				vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
+			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
+				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
+				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
+			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
+				vb->cnt_mem_get_dmabuf,
+				vb->cnt_mem_num_users,
+				vb->cnt_mem_vaddr,
+				vb->cnt_mem_cookie);
+		}
+	}
+#endif
+
+	/* Free videobuf buffers */
+	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
+	     ++buffer) {
+		kfree(q->bufs[buffer]);
+		q->bufs[buffer] = NULL;
+	}
+
+	q->num_buffers -= buffers;
+	if (!q->num_buffers) {
+		q->memory = 0;
+		INIT_LIST_HEAD(&q->queued_list);
+	}
+	return 0;
+}
+
+/**
+ * __buffer_in_use() - return true if the buffer is in use and
+ * the queue cannot be freed (by the means of REQBUFS(0)) call
+ */
+bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
+{
+	unsigned int plane;
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		void *mem_priv = vb->planes[plane].mem_priv;
+		/*
+		 * If num_users() has not been provided, call_memop
+		 * will return 0, apparently nobody cares about this
+		 * case anyway. If num_users() returns more than 1,
+		 * we are not the only user of the plane's memory.
+		 */
+		if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * __buffers_in_use() - return true if any buffers on the queue are in use and
+ * the queue cannot be freed (by the means of REQBUFS(0)) call
+ */
+static bool __buffers_in_use(struct vb2_queue *q)
+{
+	unsigned int buffer;
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		if (__buffer_in_use(q, q->bufs[buffer]))
+			return true;
+	}
+	return false;
+}
+
+/**
+ * vb2_core_querybuf() - query video buffer information
+ * @q:		videobuf queue
+ * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
+ *		multiplanar buffers);
+ * @index:	id number of the buffer
+ * @pb:		private buffer struct passed from userspace to vidioc_querybuf
+ *		handler in driver
+ *
+ * Should be called from vidioc_querybuf ioctl handler in driver.
+ * This function will verify the passed v4l2_buffer structure and fill the
+ * relevant information for the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_querybuf handler in driver.
+ */
+int vb2_core_querybuf(struct vb2_queue *q, unsigned int type,
+		unsigned int index, void *pb)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	if (type != q->type) {
+		VB2_DEBUG(1, "wrong buffer type\n");
+		return -EINVAL;
+	}
+
+	if (index >= q->num_buffers) {
+		VB2_DEBUG(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+	vb = q->bufs[index];
+	ret = call_bufop(q, verify_planes, vb, pb);
+	if (!ret)
+		ret = call_bufop(q, fill_buffer, vb, pb);
+
+	return ret;
+}
+
+/**
+ * __verify_userptr_ops() - verify that all memory operations required for
+ * USERPTR queue type have been provided
+ */
+static int __verify_userptr_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_USERPTR) || !q->mem_ops->get_userptr ||
+	    !q->mem_ops->put_userptr)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * __verify_mmap_ops() - verify that all memory operations required for
+ * MMAP queue type have been provided
+ */
+static int __verify_mmap_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_MMAP) || !q->mem_ops->alloc ||
+	    !q->mem_ops->put || !q->mem_ops->mmap)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * __verify_dmabuf_ops() - verify that all memory operations required for
+ * DMABUF queue type have been provided
+ */
+static int __verify_dmabuf_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
+	    !q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
+	    !q->mem_ops->unmap_dmabuf)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * __verify_memory_type() - Check whether the memory type and buffer type
+ * passed to a buffer operation are compatible with the queue.
+ */
+int __verify_memory_type(struct vb2_queue *q,
+		unsigned int memory, enum v4l2_buf_type type)
+{
+	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
+	    memory != V4L2_MEMORY_DMABUF) {
+		VB2_DEBUG(1, "unsupported memory type\n");
+		return -EINVAL;
+	}
+
+	if (type != q->type) {
+		VB2_DEBUG(1, "requested type is incorrect\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Make sure all the required memory ops for given memory type
+	 * are available.
+	 */
+	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
+		VB2_DEBUG(1, "MMAP for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+		VB2_DEBUG(1, "USERPTR for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+		VB2_DEBUG(1, "DMABUF for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Place the busy tests at the end: -EBUSY can be ignored when
+	 * create_bufs is called with count == 0, but count == 0 should still
+	 * do the memory and type validation.
+	 */
+	if (vb2_fileio_is_active(q)) {
+		VB2_DEBUG(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+
+/**
+ * vb2_core_reqbufs() - Initiate streaming
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
+ *
+ * Should be called from vidioc_reqbufs ioctl handler of a driver.
+ * This function:
+ * 1) verifies streaming parameters passed from the userspace,
+ * 2) sets up the queue,
+ * 3) negotiates number of buffers and planes per buffer with the driver
+ *    to be used during streaming,
+ * 4) allocates internal buffer structures (struct vb2_buffer), according to
+ *    the agreed parameters,
+ * 5) for MMAP memory type, allocates actual video memory, using the
+ *    memory handling/allocation routines provided during queue initialization
+ *
+ * If req->count is 0, all the memory will be freed instead.
+ * If the queue has been allocated previously (by a previous vb2_reqbufs) call
+ * and the queue is not busy, memory will be reallocated.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_reqbufs handler in driver.
+ */
+int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *count)
+{
+	unsigned int num_buffers, allocated_buffers, num_planes = 0;
+	int ret;
+
+	if (q->streaming) {
+		VB2_DEBUG(1, "streaming active\n");
+		return -EBUSY;
+	}
+
+	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
+		/*
+		 * We already have buffers allocated, so first check if they
+		 * are not in use and can be freed.
+		 */
+		mutex_lock(&q->mmap_lock);
+		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
+			mutex_unlock(&q->mmap_lock);
+			VB2_DEBUG(1, "memory in use, cannot free\n");
+			return -EBUSY;
+		}
+
+		/*
+		 * Call queue_cancel to clean up any buffers in the PREPARED or
+		 * QUEUED state which is possible if buffers were prepared or
+		 * queued without ever calling STREAMON.
+		 */
+		__vb2_queue_cancel(q);
+		ret = __vb2_queue_free(q, q->num_buffers);
+		mutex_unlock(&q->mmap_lock);
+		if (ret)
+			return ret;
+
+		/*
+		 * In case of REQBUFS(0) return immediately without calling
+		 * driver's queue_setup() callback and allocating resources.
+		 */
+		if (*count == 0)
+			return 0;
+	}
+
+	/*
+	 * Make sure the requested values and current defaults are sane.
+	 */
+	num_buffers = min_t(unsigned int, *count, VIDEO_MAX_FRAME);
+	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
+	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
+	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+	q->memory = memory;
+
+	/*
+	 * Ask the driver how many buffers and planes per buffer it requires.
+	 * Driver also sets the size and allocator context for each plane.
+	 */
+	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
+		       q->plane_sizes, q->alloc_ctx);
+	if (ret)
+		return ret;
+
+	/* Finally, allocate buffers and video memory */
+	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers, num_planes);
+	if (allocated_buffers == 0) {
+		VB2_DEBUG(1, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * There is no point in continuing if we can't allocate the minimum
+	 * number of buffers needed by this vb2_queue.
+	 */
+	if (allocated_buffers < q->min_buffers_needed)
+		ret = -ENOMEM;
+
+	/*
+	 * Check if driver can handle the allocated number of buffers.
+	 */
+	if (!ret && allocated_buffers < num_buffers) {
+		num_buffers = allocated_buffers;
+
+		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
+			       &num_planes, q->plane_sizes, q->alloc_ctx);
+
+		if (!ret && allocated_buffers < num_buffers)
+			ret = -ENOMEM;
+
+		/*
+		 * Either the driver has accepted a smaller number of buffers,
+		 * or .queue_setup() returned an error
+		 */
+	}
+
+	mutex_lock(&q->mmap_lock);
+	q->num_buffers = allocated_buffers;
+
+	if (ret < 0) {
+		/*
+		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
+		 * from q->num_buffers.
+		 */
+		__vb2_queue_free(q, allocated_buffers);
+		mutex_unlock(&q->mmap_lock);
+		return ret;
+	}
+	mutex_unlock(&q->mmap_lock);
+
+	/*
+	 * Return the number of successfully allocated buffers
+	 * to the userspace.
+	 */
+	*count = allocated_buffers;
+	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+
+	return 0;
+}
+
+/**
+ * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
+ *
+ * Should be called from vidioc_create_bufs ioctl handler of a driver.
+ * This function:
+ * 1) verifies parameter sanity
+ * 2) calls the .queue_setup() queue operation
+ * 3) performs any necessary memory allocations
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_create_bufs handler in driver.
+ */
+int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
+		unsigned int *count, void *parg)
+{
+	unsigned int num_planes = 0, num_buffers, allocated_buffers;
+	int ret;
+
+	if (q->num_buffers == VIDEO_MAX_FRAME) {
+		VB2_DEBUG(1, "maximum number of buffers already allocated\n");
+		return -ENOBUFS;
+	}
+
+	if (!q->num_buffers) {
+		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
+		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+		q->memory = memory;
+		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	}
+
+	num_buffers = min(*count, VIDEO_MAX_FRAME - q->num_buffers);
+
+	/*
+	 * Ask the driver, whether the requested number of buffers, planes per
+	 * buffer and their sizes are acceptable
+	 */
+	ret = call_qop(q, queue_setup, q, parg, &num_buffers,
+		       &num_planes, q->plane_sizes, q->alloc_ctx);
+	if (ret)
+		return ret;
+
+	/* Finally, allocate buffers and video memory */
+	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
+				num_planes);
+	if (allocated_buffers == 0) {
+		VB2_DEBUG(1, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Check if driver can handle the so far allocated number of buffers.
+	 */
+	if (allocated_buffers < num_buffers) {
+		num_buffers = allocated_buffers;
+
+		/*
+		 * q->num_buffers contains the total number of buffers, that the
+		 * queue driver has set up
+		 */
+		ret = call_qop(q, queue_setup, q, parg, &num_buffers,
+			       &num_planes, q->plane_sizes, q->alloc_ctx);
+
+		if (!ret && allocated_buffers < num_buffers)
+			ret = -ENOMEM;
+
+		/*
+		 * Either the driver has accepted a smaller number of buffers,
+		 * or .queue_setup() returned an error
+		 */
+	}
+
+	mutex_lock(&q->mmap_lock);
+	q->num_buffers += allocated_buffers;
+
+	if (ret < 0) {
+		/*
+		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
+		 * from q->num_buffers.
+		 */
+		__vb2_queue_free(q, allocated_buffers);
+		mutex_unlock(&q->mmap_lock);
+		return -ENOMEM;
+	}
+	mutex_unlock(&q->mmap_lock);
+
+	/*
+	 * Return the number of successfully allocated buffers
+	 * to the userspace.
+	 */
+	*count = allocated_buffers;
+
+	return 0;
+}
+
+/**
+ * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the address is to be returned
+ *
+ * This function returns a kernel virtual address of a given plane if
+ * such a mapping exist, NULL otherwise.
+ */
+void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+		return NULL;
+
+	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
+
+}
+EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
+
+/**
+ * vb2_plane_cookie() - Return allocator specific cookie for the given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the cookie is to be returned
+ *
+ * This function returns an allocator specific cookie for a given plane if
+ * available, NULL otherwise. The allocator should provide some simple static
+ * inline function, which would convert this cookie to the allocator specific
+ * type that can be used directly by the driver to access the buffer. This can
+ * be for example physical address, pointer to scatter list or IOMMU mapping.
+ */
+void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
+		return NULL;
+
+	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
+}
+EXPORT_SYMBOL_GPL(vb2_plane_cookie);
+
+/**
+ * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
+ * @vb:		vb2_buffer returned from the driver
+ * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully,
+ *		VB2_BUF_STATE_ERROR if the operation finished with an error or
+ *		VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
+ *		If start_streaming fails then it should return buffers with state
+ *		VB2_BUF_STATE_QUEUED to put them back into the queue.
+ *
+ * This function should be called by the driver after a hardware operation on
+ * a buffer is finished and the buffer may be returned to userspace. The driver
+ * cannot use this buffer anymore until it is queued back to it by videobuf
+ * by the means of buf_queue callback. Only buffers previously queued to the
+ * driver by buf_queue can be passed to this function.
+ *
+ * While streaming a buffer can only be returned in state DONE or ERROR.
+ * The start_streaming op can also return them in case the DMA engine cannot
+ * be started for some reason. In that case the buffers should be returned with
+ * state QUEUED.
+ */
+void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned long flags;
+	unsigned int plane;
+
+	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
+		return;
+
+	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
+		    state != VB2_BUF_STATE_ERROR &&
+		    state != VB2_BUF_STATE_QUEUED))
+		state = VB2_BUF_STATE_ERROR;
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	/*
+	 * Although this is not a callback, it still does have to balance
+	 * with the buf_queue op. So update this counter manually.
+	 */
+	vb->cnt_buf_done++;
+#endif
+	VB2_DEBUG(4, "done processing on buffer %d, state: %d\n",
+			vb2_index(vb), state);
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
+
+	/* Add the buffer to the done buffers list */
+	spin_lock_irqsave(&q->done_lock, flags);
+	vb->state = state;
+	if (state != VB2_BUF_STATE_QUEUED)
+		list_add_tail(&vb->done_entry, &q->done_list);
+	atomic_dec(&q->owned_by_drv_count);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	trace_vb2_buf_done(q, vb);
+
+	if (state == VB2_BUF_STATE_QUEUED) {
+		if (q->start_streaming_called)
+			__enqueue_in_driver(vb);
+		return;
+	}
+
+	/* Inform any processes that may be waiting for buffers */
+	wake_up(&q->done_wq);
+}
+EXPORT_SYMBOL_GPL(vb2_buffer_done);
+
+/**
+ * vb2_discard_done() - discard all buffers marked as DONE
+ * @q:		videobuf2 queue
+ *
+ * This function is intended to be used with suspend/resume operations. It
+ * discards all 'done' buffers as they would be too old to be requested after
+ * resume.
+ *
+ * Drivers must stop the hardware and synchronize with interrupt handlers and/or
+ * delayed works before calling this function to make sure no buffer will be
+ * touched by the driver and/or hardware.
+ */
+void vb2_discard_done(struct vb2_queue *q)
+{
+	struct vb2_buffer *vb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->done_lock, flags);
+	list_for_each_entry(vb, &q->done_list, done_entry)
+		vb->state = VB2_BUF_STATE_ERROR;
+	spin_unlock_irqrestore(&q->done_lock, flags);
+}
+EXPORT_SYMBOL_GPL(vb2_discard_done);
+
+/**
+ * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
+ */
+static void __enqueue_in_driver(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	vb->state = VB2_BUF_STATE_ACTIVE;
+	atomic_inc(&q->owned_by_drv_count);
+
+	trace_vb2_buf_queue(q, vb);
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
+
+	call_void_vb_qop(vb, buf_queue, vb);
+}
+
+static int vb2_queue_or_prepare_buf(struct vb2_queue *q, unsigned int memory,
+		unsigned int type, unsigned int index, void *pb,
+		const char *opname)
+{
+	if (type != q->type) {
+		VB2_DEBUG(1, "%s: invalid buffer type\n", opname);
+		return -EINVAL;
+	}
+
+	if (index >= q->num_buffers) {
+		VB2_DEBUG(1, "%s: buffer index out of range\n", opname);
+		return -EINVAL;
+	}
+
+	if (q->bufs[index] == NULL) {
+		/* Should never happen */
+		VB2_DEBUG(1, "%s: buffer is NULL\n", opname);
+		return -EINVAL;
+	}
+
+	if (memory != q->memory) {
+		VB2_DEBUG(1, "%s: invalid memory type\n", opname);
+		return -EINVAL;
+	}
+
+	return call_bufop(q, verify_planes, q->bufs[index], pb);
+}
+
+/**
+ * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_prepare_buf
+ *		handler in driver
+ *
+ * Should be called from vidioc_prepare_buf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_prepare callback in the driver (if provided), in which
+ *    driver-specific buffer initialization can be performed,
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_prepare_buf handler in driver.
+ */
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int memory,
+		unsigned int type, unsigned int index, void *pb)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	if (vb2_fileio_is_active(q)) {
+		VB2_DEBUG(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	ret = vb2_queue_or_prepare_buf(q, memory, type, index, pb,
+			"prepare_buf");
+	if (ret)
+		return ret;
+
+	vb = q->bufs[index];
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		VB2_DEBUG(1, "invalid buffer state %d\n",
+			vb->state);
+		return -EINVAL;
+	}
+
+	ret = call_bufop(q, prepare_buffer, vb, pb);
+	if (!ret) {
+		/* Fill buffer information for the userspace */
+		call_bufop(q, fill_buffer, vb, pb);
+		VB2_DEBUG(1, "prepare of buffer %d succeeded\n",
+			vb2_index(vb));
+	}
+	return ret;
+}
+
+/**
+ * vb2_start_streaming() - Attempt to start streaming.
+ * @q:		videobuf2 queue
+ *
+ * Attempt to start streaming. When this function is called there must be
+ * at least q->min_buffers_needed buffers queued up (i.e. the minimum
+ * number of buffers required for the DMA engine to function). If the
+ * @start_streaming op fails it is supposed to return all the driver-owned
+ * buffers back to vb2 in state QUEUED. Check if that happened and if
+ * not warn and reclaim them forcefully.
+ */
+static int vb2_start_streaming(struct vb2_queue *q)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	/*
+	 * If any buffers were queued before streamon,
+	 * we can now pass them to driver for processing.
+	 */
+	list_for_each_entry(vb, &q->queued_list, queued_entry)
+		__enqueue_in_driver(vb);
+
+	/* Tell the driver to start streaming */
+	q->start_streaming_called = 1;
+	ret = call_qop(q, start_streaming, q,
+		       atomic_read(&q->owned_by_drv_count));
+	if (!ret)
+		return 0;
+
+	q->start_streaming_called = 0;
+
+	VB2_DEBUG(1, "driver refused to start streaming\n");
+	/*
+	 * If you see this warning, then the driver isn't cleaning up properly
+	 * after a failed start_streaming(). See the start_streaming()
+	 * documentation in videobuf2-core.h for more information how buffers
+	 * should be returned to vb2 in start_streaming().
+	 */
+	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
+		unsigned i;
+
+		/*
+		 * Forcefully reclaim buffers if the driver did not
+		 * correctly return them to vb2.
+		 */
+		for (i = 0; i < q->num_buffers; ++i) {
+			vb = q->bufs[i];
+			if (vb->state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED);
+		}
+		/* Must be zero now */
+		WARN_ON(atomic_read(&q->owned_by_drv_count));
+	}
+	/*
+	 * If done_list is not empty, then start_streaming() didn't call
+	 * vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED) but STATE_ERROR or
+	 * STATE_DONE.
+	 */
+	WARN_ON(!list_empty(&q->done_list));
+	return ret;
+}
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory,
+		unsigned int type, unsigned int index, void *pb)
+{
+	int ret = vb2_queue_or_prepare_buf(q, memory, type, index, pb, "qbuf");
+	struct vb2_buffer *vb;
+
+	if (ret)
+		return ret;
+
+	vb = q->bufs[index];
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_DEQUEUED:
+		ret = call_bufop(q, prepare_buffer, vb, pb);
+		if (ret)
+			return ret;
+		break;
+	case VB2_BUF_STATE_PREPARED:
+		break;
+	case VB2_BUF_STATE_PREPARING:
+		VB2_DEBUG(1, "buffer still being prepared\n");
+		return -EINVAL;
+	default:
+		VB2_DEBUG(1, "invalid buffer state %d\n", vb->state);
+		return -EINVAL;
+	}
+
+	/*
+	 * Add to the queued buffers list, a buffer will stay on it until
+	 * dequeued in dqbuf.
+	 */
+	list_add_tail(&vb->queued_entry, &q->queued_list);
+	q->queued_count++;
+	q->waiting_for_buffers = false;
+	vb->state = VB2_BUF_STATE_QUEUED;
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		/*
+		 * For output buffers copy the timestamp if needed,
+		 * and the timecode field and flag if needed.
+		 */
+		call_bufop(q, set_timestamp, vb, pb);
+	}
+
+	trace_vb2_qbuf(q, vb);
+
+	/*
+	 * If already streaming, give the buffer to driver for processing.
+	 * If not, the buffer will be given to driver on next streamon.
+	 */
+	if (q->start_streaming_called)
+		__enqueue_in_driver(vb);
+
+	/* Fill buffer information for the userspace */
+	call_bufop(q, fill_buffer, vb, pb);
+
+	/*
+	 * If streamon has been called, and we haven't yet called
+	 * start_streaming() since not enough buffers were queued, and
+	 * we now have reached the minimum number of queued buffers,
+	 * then we can finally call start_streaming().
+	 */
+	if (q->streaming && !q->start_streaming_called &&
+	    q->queued_count >= q->min_buffers_needed) {
+		ret = vb2_start_streaming(q);
+		if (ret)
+			return ret;
+	}
+
+	VB2_DEBUG(1, "qbuf of buffer %d succeeded\n", vb2_index(vb));
+	return 0;
+}
+
+/**
+ * __vb2_wait_for_done_vb() - wait for a buffer to become available
+ * for dequeuing
+ *
+ * Will sleep if required for nonblocking == false.
+ */
+static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
+{
+	/*
+	 * All operations on vb_done_list are performed under done_lock
+	 * spinlock protection. However, buffers may be removed from
+	 * it and returned to userspace only while holding both driver's
+	 * lock and the done_lock spinlock. Thus we can be sure that as
+	 * long as we hold the driver's lock, the list will remain not
+	 * empty if list_empty() check succeeds.
+	 */
+
+	for (;;) {
+		int ret;
+
+		if (!q->streaming) {
+			VB2_DEBUG(1, "streaming off, will not wait for buffers\n");
+			return -EINVAL;
+		}
+
+		if (q->error) {
+			VB2_DEBUG(1, "Queue in error state, will not wait for buffers\n");
+			return -EIO;
+		}
+
+		if (q->last_buffer_dequeued) {
+			VB2_DEBUG(3, "last buffer dequeued already, will not wait for buffers\n");
+			return -EPIPE;
+		}
+
+		if (!list_empty(&q->done_list)) {
+			/*
+			 * Found a buffer that we were waiting for.
+			 */
+			break;
+		}
+
+		if (nonblocking) {
+			VB2_DEBUG(1, "nonblocking and no buffers to dequeue, "
+								"will not wait\n");
+			return -EAGAIN;
+		}
+
+		/*
+		 * We are streaming and blocking, wait for another buffer to
+		 * become ready or for streamoff. Driver's lock is released to
+		 * allow streamoff or qbuf to be called while waiting.
+		 */
+		call_void_qop(q, wait_prepare, q);
+
+		/*
+		 * All locks have been released, it is safe to sleep now.
+		 */
+		VB2_DEBUG(3, "will sleep waiting for buffers\n");
+		ret = wait_event_interruptible(q->done_wq,
+				!list_empty(&q->done_list) || !q->streaming ||
+				q->error);
+
+		/*
+		 * We need to reevaluate both conditions again after reacquiring
+		 * the locks or return an error if one occurred.
+		 */
+		call_void_qop(q, wait_finish, q);
+		if (ret) {
+			VB2_DEBUG(1, "sleep was interrupted\n");
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * __vb2_get_done_vb() - get a buffer ready for dequeuing
+ *
+ * Will sleep if required for nonblocking == false.
+ */
+static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
+				void *pb, int nonblocking)
+{
+	unsigned long flags;
+	int ret;
+
+	/*
+	 * Wait for at least one buffer to become available on the done_list.
+	 */
+	ret = __vb2_wait_for_done_vb(q, nonblocking);
+	if (ret)
+		return ret;
+
+	/*
+	 * Driver's lock has been held since we last verified that done_list
+	 * is not empty, so no need for another list_empty(done_list) check.
+	 */
+	spin_lock_irqsave(&q->done_lock, flags);
+	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
+	/*
+	 * Only remove the buffer from done_list if v4l2_buffer can handle all
+	 * the planes.
+	 */
+	call_bufop(q, verify_planes, *vb, pb);
+
+	if (!ret)
+		list_del(&(*vb)->done_entry);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	return ret;
+}
+
+/**
+ * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2
+ * @q:		videobuf2 queue
+ *
+ * This function will wait until all buffers that have been given to the driver
+ * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
+ * wait_prepare, wait_finish pair. It is intended to be called with all locks
+ * taken, for example from stop_streaming() callback.
+ */
+int vb2_wait_for_all_buffers(struct vb2_queue *q)
+{
+	if (!q->streaming) {
+		VB2_DEBUG(1, "streaming off, will not wait for buffers\n");
+		return -EINVAL;
+	}
+
+	if (q->start_streaming_called)
+		wait_event(q->done_wq, !atomic_read(&q->owned_by_drv_count));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
+
+/**
+ * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
+ */
+static void __vb2_dqbuf(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int i;
+
+	/* nothing to do if the buffer is already dequeued */
+	if (vb->state == VB2_BUF_STATE_DEQUEUED)
+		return;
+
+	vb->state = VB2_BUF_STATE_DEQUEUED;
+
+	/* unmap DMABUF buffer */
+	if (q->memory == V4L2_MEMORY_DMABUF)
+		for (i = 0; i < vb->num_planes; ++i) {
+			if (!vb->planes[i].dbuf_mapped)
+				continue;
+			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
+			vb->planes[i].dbuf_mapped = 0;
+		}
+}
+
+int vb2_core_dqbuf(struct vb2_queue *q, unsigned int type, void *pb,
+		bool nonblocking)
+{
+	struct vb2_buffer *vb = NULL;
+	int ret;
+
+	if (type != q->type) {
+		VB2_DEBUG(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+	ret = __vb2_get_done_vb(q, &vb, pb, nonblocking);
+	if (ret < 0)
+		return ret;
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_DONE:
+		VB2_DEBUG(3, "returning done buffer\n");
+		break;
+	case VB2_BUF_STATE_ERROR:
+		VB2_DEBUG(3, "returning done buffer with errors\n");
+		break;
+	default:
+		VB2_DEBUG(1, "invalid buffer state\n");
+		return -EINVAL;
+	}
+
+	call_void_vb_qop(vb, buf_finish, vb);
+
+	/* Fill buffer information for the userspace */
+	call_bufop(q, fill_buffer, vb, pb);
+	/* Remove from videobuf queue */
+	list_del(&vb->queued_entry);
+	q->queued_count--;
+
+	trace_vb2_dqbuf(q, vb);
+
+	if (!V4L2_TYPE_IS_OUTPUT(q->type) && call_bufop(q, is_last, vb))
+		q->last_buffer_dequeued = true;
+	/* go back to dequeued state */
+	__vb2_dqbuf(vb);
+
+	VB2_DEBUG(1, "dqbuf of buffer %d, with state %d\n",
+			vb2_index(vb), vb->state);
+
+	return 0;
+}
+
+/**
+ * __vb2_queue_cancel() - cancel and stop (pause) streaming
+ *
+ * Removes all queued buffers from driver's queue and all buffers queued by
+ * userspace from videobuf's queue. Returns to state after reqbufs.
+ */
+static void __vb2_queue_cancel(struct vb2_queue *q)
+{
+	unsigned int i;
+
+	/*
+	 * Tell driver to stop all transactions and release all queued
+	 * buffers.
+	 */
+	if (q->start_streaming_called)
+		call_void_qop(q, stop_streaming, q);
+
+	/*
+	 * If you see this warning, then the driver isn't cleaning up properly
+	 * in stop_streaming(). See the stop_streaming() documentation in
+	 * videobuf2-core.h for more information how buffers should be returned
+	 * to vb2 in stop_streaming().
+	 */
+	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
+		for (i = 0; i < q->num_buffers; ++i)
+			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
+				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+		/* Must be zero now */
+		WARN_ON(atomic_read(&q->owned_by_drv_count));
+	}
+
+	q->streaming = 0;
+	q->start_streaming_called = 0;
+	q->queued_count = 0;
+	q->error = 0;
+
+	/*
+	 * Remove all buffers from videobuf's list...
+	 */
+	INIT_LIST_HEAD(&q->queued_list);
+	/*
+	 * ...and done list; userspace will not receive any buffers it
+	 * has not already dequeued before initiating cancel.
+	 */
+	INIT_LIST_HEAD(&q->done_list);
+	atomic_set(&q->owned_by_drv_count, 0);
+	wake_up_all(&q->done_wq);
+
+	/*
+	 * Reinitialize all buffers for next use.
+	 * Make sure to call buf_finish for any queued buffers. Normally
+	 * that's done in dqbuf, but that's not going to happen when we
+	 * cancel the whole queue. Note: this code belongs here, not in
+	 * __vb2_dqbuf() since in vb2_internal_dqbuf() there is a critical
+	 * call to __fill_v4l2_buffer() after buf_finish(). That order can't
+	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
+	 */
+	for (i = 0; i < q->num_buffers; ++i) {
+		struct vb2_buffer *vb = q->bufs[i];
+
+		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+			vb->state = VB2_BUF_STATE_PREPARED;
+			call_void_vb_qop(vb, buf_finish, vb);
+		}
+		__vb2_dqbuf(vb);
+	}
+}
+
+int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
+{
+	int ret;
+
+	if (type != q->type) {
+		VB2_DEBUG(1, "invalid stream type\n");
+		return -EINVAL;
+	}
+
+	if (q->streaming) {
+		VB2_DEBUG(3, "already streaming\n");
+		return 0;
+	}
+
+	if (!q->num_buffers) {
+		VB2_DEBUG(1, "no buffers have been allocated\n");
+		return -EINVAL;
+	}
+
+	if (q->num_buffers < q->min_buffers_needed) {
+		VB2_DEBUG(1, "need at least %u allocated buffers\n",
+				q->min_buffers_needed);
+		return -EINVAL;
+	}
+
+	/*
+	 * Tell driver to start streaming provided sufficient buffers
+	 * are available.
+	 */
+	if (q->queued_count >= q->min_buffers_needed) {
+		ret = vb2_start_streaming(q);
+		if (ret) {
+			__vb2_queue_cancel(q);
+			return ret;
+		}
+	}
+
+	q->streaming = 1;
+
+	VB2_DEBUG(3, "successful\n");
+	return 0;
+}
+
+/**
+ * vb2_queue_error() - signal a fatal error on the queue
+ * @q:		videobuf2 queue
+ *
+ * Flag that a fatal unrecoverable error has occurred and wake up all processes
+ * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
+ * buffers will return -EIO.
+ *
+ * The error flag will be cleared when cancelling the queue, either from
+ * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
+ * function before starting the stream, otherwise the error flag will remain set
+ * until the queue is released when closing the device node.
+ */
+void vb2_queue_error(struct vb2_queue *q)
+{
+	q->error = 1;
+
+	wake_up_all(&q->done_wq);
+}
+EXPORT_SYMBOL_GPL(vb2_queue_error);
+
+int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
+{
+	if (type != q->type) {
+		VB2_DEBUG(1, "invalid stream type\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Cancel will pause streaming and remove all buffers from the driver
+	 * and videobuf, effectively returning control over them to userspace.
+	 *
+	 * Note that we do this even if q->streaming == 0: if you prepare or
+	 * queue buffers, and then call streamoff without ever having called
+	 * streamon, you would still expect those buffers to be returned to
+	 * their normal dequeued state.
+	 */
+	__vb2_queue_cancel(q);
+	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	q->last_buffer_dequeued = false;
+
+	VB2_DEBUG(3, "successful\n");
+	return 0;
+}
+
+/**
+ * __find_plane_by_offset() - find plane associated with the given offset off
+ */
+static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
+			unsigned int *_buffer, unsigned int *_plane)
+{
+	struct vb2_buffer *vb;
+	unsigned int buffer, plane;
+
+	/*
+	 * Go over all buffers and their planes, comparing the given offset
+	 * with an offset assigned to each plane. If a match is found,
+	 * return its buffer and plane numbers.
+	 */
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		vb = q->bufs[buffer];
+
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			if (call_bufop(q, get_plane_offset, vb, plane) == off) {
+				*_buffer = buffer;
+				*_plane = plane;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * vb2_core_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @eb:		export buffer structure passed from userspace to vidioc_expbuf
+ *		handler in driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
+int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
+		unsigned int plane, unsigned int flags)
+{
+	struct vb2_buffer *vb = NULL;
+	struct vb2_plane *vb_plane;
+	int ret;
+	struct dma_buf *dbuf;
+
+	if (q->memory != V4L2_MEMORY_MMAP) {
+		VB2_DEBUG(1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (!q->mem_ops->get_dmabuf) {
+		VB2_DEBUG(1, "queue does not support DMA buffer exporting\n");
+		return -EINVAL;
+	}
+
+	if (flags & ~(O_CLOEXEC | O_ACCMODE)) {
+		VB2_DEBUG(1, "queue does support only O_CLOEXEC and access mode flags\n");
+		return -EINVAL;
+	}
+
+	if (type != q->type) {
+		VB2_DEBUG(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	if (index >= q->num_buffers) {
+		VB2_DEBUG(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+
+	vb = q->bufs[index];
+
+	if (plane >= vb->num_planes) {
+		VB2_DEBUG(1, "buffer plane out of range\n");
+		return -EINVAL;
+	}
+
+	if (vb2_fileio_is_active(q)) {
+		VB2_DEBUG(1, "expbuf: file io in progress\n");
+		return -EBUSY;
+	}
+
+	vb_plane = &vb->planes[plane];
+
+	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, flags & O_ACCMODE);
+	if (IS_ERR_OR_NULL(dbuf)) {
+		VB2_DEBUG(1, "failed to export buffer %d, plane %d\n", index, plane);
+		return -EINVAL;
+	}
+
+	ret = dma_buf_fd(dbuf, flags & ~O_ACCMODE);
+	if (ret < 0) {
+		VB2_DEBUG(3, "buffer %d, plane %d failed to export (%d)\n",
+			index, plane, ret);
+		dma_buf_put(dbuf);
+		return ret;
+	}
+
+	VB2_DEBUG(3, "buffer %d, plane %d exported as %d descriptor\n",
+		index, plane, ret);
+
+	return ret;
+}
+
+/**
+ * vb2_mmap() - map video buffers into application address space
+ * @q:		videobuf2 queue
+ * @vma:	vma passed to the mmap file operation handler in the driver
+ *
+ * Should be called from mmap file operation handler of a driver.
+ * This function maps one plane of one of the available video buffers to
+ * userspace. To map whole video memory allocated on reqbufs, this function
+ * has to be called once per each plane per each buffer previously allocated.
+ *
+ * When the userspace application calls mmap, it passes to it an offset returned
+ * to it earlier by the means of vidioc_querybuf handler. That offset acts as
+ * a "cookie", which is then used to identify the plane to be mapped.
+ * This function finds a plane with a matching offset and a mapping is performed
+ * by the means of a provided memory operation.
+ *
+ * The return values from this function are intended to be directly returned
+ * from the mmap handler in driver.
+ */
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
+{
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	struct vb2_buffer *vb;
+	unsigned int buffer = 0, plane = 0;
+	int ret;
+	unsigned long length;
+
+	if (q->memory != V4L2_MEMORY_MMAP) {
+		VB2_DEBUG(1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Check memory area access mode.
+	 */
+	if (!(vma->vm_flags & VM_SHARED)) {
+		VB2_DEBUG(1, "invalid vma flags, VM_SHARED needed\n");
+		return -EINVAL;
+	}
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		if (!(vma->vm_flags & VM_WRITE)) {
+			VB2_DEBUG(1, "invalid vma flags, VM_WRITE needed\n");
+			return -EINVAL;
+		}
+	} else {
+		if (!(vma->vm_flags & VM_READ)) {
+			VB2_DEBUG(1, "invalid vma flags, VM_READ needed\n");
+			return -EINVAL;
+		}
+	}
+	if (vb2_fileio_is_active(q)) {
+		VB2_DEBUG(1, "mmap: file io in progress\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Find the plane corresponding to the offset passed by userspace.
+	 */
+	ret = __find_plane_by_offset(q, off, &buffer, &plane);
+	if (ret)
+		return ret;
+
+	vb = q->bufs[buffer];
+
+	/*
+	 * MMAP requires page_aligned buffers.
+	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
+	 * so, we need to do the same here.
+	 */
+	length = PAGE_ALIGN(call_u32_bufop(q, get_plane_length, vb, plane));
+	if (length < (vma->vm_end - vma->vm_start)) {
+		VB2_DEBUG(1,
+			"MMAP invalid, as it would overflow buffer length\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&q->mmap_lock);
+	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
+	mutex_unlock(&q->mmap_lock);
+	if (ret)
+		return ret;
+
+	VB2_DEBUG(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_mmap);
+
+#ifndef CONFIG_MMU
+unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
+				    unsigned long addr,
+				    unsigned long len,
+				    unsigned long pgoff,
+				    unsigned long flags)
+{
+	unsigned long off = pgoff << PAGE_SHIFT;
+	struct vb2_buffer *vb;
+	unsigned int buffer, plane;
+	void *vaddr;
+	int ret;
+
+	if (q->memory != V4L2_MEMORY_MMAP) {
+		VB2_DEBUG(1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Find the plane corresponding to the offset passed by userspace.
+	 */
+	ret = __find_plane_by_offset(q, off, &buffer, &plane);
+	if (ret)
+		return ret;
+
+	vb = q->bufs[buffer];
+
+	vaddr = vb2_plane_vaddr(vb, plane);
+	return vaddr ? (unsigned long)vaddr : -EINVAL;
+}
+EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
+#endif
+
+/**
+ * vb2_core_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ *
+ * The vb2_queue structure should be allocated by the driver. The driver is
+ * responsible of clearing it's content and setting initial values for some
+ * required entries before calling this function.
+ * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
+ * for more information.
+ */
+int vb2_core_queue_init(struct vb2_queue *q)
+{
+	/*
+	 * Sanity check
+	 */
+	if (WARN_ON(!q)			  ||
+	    WARN_ON(!q->ops)		  ||
+	    WARN_ON(!q->mem_ops)	  ||
+	    WARN_ON(!q->type)		  ||
+	    WARN_ON(!q->io_modes)	  ||
+	    WARN_ON(!q->ops->queue_setup) ||
+	    WARN_ON(!q->ops->buf_queue))
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&q->queued_list);
+	INIT_LIST_HEAD(&q->done_list);
+	spin_lock_init(&q->done_lock);
+	mutex_init(&q->mmap_lock);
+	init_waitqueue_head(&q->done_wq);
+
+	return 0;
+}
+
+/**
+ * vb2_core_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
+ */
+void vb2_core_queue_release(struct vb2_queue *q)
+{
+	__vb2_queue_cancel(q);
+	mutex_lock(&q->mmap_lock);
+	__vb2_queue_free(q, q->num_buffers);
+	mutex_unlock(&q->mmap_lock);
+}
+
+MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
+MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 437b769..94c1e64 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-memops.h>
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index eb90188..7289b81 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
 #include <media/videobuf2-dma-sg.h>
 
diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index e5da47a..81c1ad8 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -19,7 +19,7 @@
 #include <linux/sched.h>
 #include <linux/file.h>
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
 
 /**
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 7956776..85527e9 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -32,148 +32,6 @@
 
 #include <trace/events/v4l2.h>
 
-static int debug;
-module_param(debug, int, 0644);
-
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (debug >= level)					      \
-			pr_info("vb2: %s: " fmt, __func__, ## arg); \
-	} while (0)
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-
-/*
- * If advanced debugging is on, then count how often each op is called
- * successfully, which can either be per-buffer or per-queue.
- *
- * This makes it easy to check that the 'init' and 'cleanup'
- * (and variations thereof) stay balanced.
- */
-
-#define log_memop(vb, op)						\
-	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, vb2_v4l2_index(vb), #op,		\
-		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
-
-#define call_memop(vb, op, args...)					\
-({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-	int err;							\
-									\
-	log_memop(vb, op);						\
-	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
-	if (!err)							\
-		(vb)->cnt_mem_ ## op++;					\
-	err;								\
-})
-
-#define call_ptr_memop(vb, op, args...)					\
-({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-	void *ptr;							\
-									\
-	log_memop(vb, op);						\
-	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
-	if (!IS_ERR_OR_NULL(ptr))					\
-		(vb)->cnt_mem_ ## op++;					\
-	ptr;								\
-})
-
-#define call_void_memop(vb, op, args...)				\
-({									\
-	struct vb2_queue *_q = (vb)->vb2_queue;				\
-									\
-	log_memop(vb, op);						\
-	if (_q->mem_ops->op)						\
-		_q->mem_ops->op(args);					\
-	(vb)->cnt_mem_ ## op++;						\
-})
-
-#define log_qop(q, op)							\
-	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
-		(q)->ops->op ? "" : " (nop)")
-
-#define call_qop(q, op, args...)					\
-({									\
-	int err;							\
-									\
-	log_qop(q, op);							\
-	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
-	if (!err)							\
-		(q)->cnt_ ## op++;					\
-	err;								\
-})
-
-#define call_void_qop(q, op, args...)					\
-({									\
-	log_qop(q, op);							\
-	if ((q)->ops->op)						\
-		(q)->ops->op(args);					\
-	(q)->cnt_ ## op++;						\
-})
-
-#define log_vb_qop(vb, op, args...)					\
-	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, vb2_v4l2_index(vb), #op,		\
-		(vb)->vb2_queue->ops->op ? "" : " (nop)")
-
-#define call_vb_qop(vb, op, args...)					\
-({									\
-	int err;							\
-									\
-	log_vb_qop(vb, op);						\
-	err = (vb)->vb2_queue->ops->op ?				\
-		(vb)->vb2_queue->ops->op(args) : 0;			\
-	if (!err)							\
-		(vb)->cnt_ ## op++;					\
-	err;								\
-})
-
-#define call_void_vb_qop(vb, op, args...)				\
-({									\
-	log_vb_qop(vb, op);						\
-	if ((vb)->vb2_queue->ops->op)					\
-		(vb)->vb2_queue->ops->op(args);				\
-	(vb)->cnt_ ## op++;						\
-})
-
-#else
-
-#define call_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : 0)
-
-#define call_ptr_memop(vb, op, args...)					\
-	((vb)->vb2_queue->mem_ops->op ?					\
-		(vb)->vb2_queue->mem_ops->op(args) : NULL)
-
-#define call_void_memop(vb, op, args...)				\
-	do {								\
-		if ((vb)->vb2_queue->mem_ops->op)			\
-			(vb)->vb2_queue->mem_ops->op(args);		\
-	} while (0)
-
-#define call_qop(q, op, args...)					\
-	((q)->ops->op ? (q)->ops->op(args) : 0)
-
-#define call_void_qop(q, op, args...)					\
-	do {								\
-		if ((q)->ops->op)					\
-			(q)->ops->op(args);				\
-	} while (0)
-
-#define call_vb_qop(vb, op, args...)					\
-	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
-
-#define call_void_vb_qop(vb, op, args...)				\
-	do {								\
-		if ((vb)->vb2_queue->ops->op)				\
-			(vb)->vb2_queue->ops->op(args);			\
-	} while (0)
-
-#endif
-
 /* Flags that are set by the vb2 core */
 #define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
 				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
@@ -183,399 +41,82 @@ module_param(debug, int, 0644);
 #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
 				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
 
-static void __vb2_queue_cancel(struct vb2_queue *q);
-static void __enqueue_in_driver(struct vb2_buffer *vb);
-
-/**
- * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
- */
-static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
+static int v4l2_init_buffer(struct vb2_buffer *vb,
+		unsigned int memory, unsigned int type, unsigned int index,
+		unsigned int planes)
 {
-	struct vb2_queue *q = vb->vb2_queue;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	void *mem_priv;
-	int plane;
-
-	/*
-	 * Allocate memory for all planes in this buffer
-	 * NOTE: mmapped areas should be page aligned
-	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
-		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, dma_dir, q->gfp_flags);
-		if (IS_ERR_OR_NULL(mem_priv))
-			goto free;
+	/* Length stores number of planes for multiplanar buffers */
+	if (V4L2_TYPE_IS_MULTIPLANAR(type))
+		vbuf->v4l2_buf.length = planes;
 
-		/* Associate allocator private data with this plane */
-		vb->planes[plane].mem_priv = mem_priv;
-		vbuf->v4l2_planes[plane].length = q->plane_sizes[plane];
-	}
+	vbuf->v4l2_buf.index = index;
+	vbuf->v4l2_buf.type = type;
+	vbuf->v4l2_buf.memory = memory;
 
 	return 0;
-free:
-	/* Free already allocated memory if one of the allocations failed */
-	for (; plane > 0; --plane) {
-		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
-		vb->planes[plane - 1].mem_priv = NULL;
-	}
-
-	return -ENOMEM;
-}
-
-/**
- * __vb2_buf_mem_free() - free memory of the given buffer
- */
-static void __vb2_buf_mem_free(struct vb2_buffer *vb)
-{
-	unsigned int plane;
-
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		call_void_memop(vb, put, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
-		dprintk(3, "freed plane %d of buffer %d\n", plane,
-			vb2_v4l2_index(vb));
-	}
-}
-
-/**
- * __vb2_buf_userptr_put() - release userspace memory associated with
- * a USERPTR buffer
- */
-static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
-{
-	unsigned int plane;
-
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
-	}
-}
-
-/**
- * __vb2_plane_dmabuf_put() - release memory associated with
- * a DMABUF shared plane
- */
-static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
-{
-	if (!p->mem_priv)
-		return;
-
-	if (p->dbuf_mapped)
-		call_void_memop(vb, unmap_dmabuf, p->mem_priv);
-
-	call_void_memop(vb, detach_dmabuf, p->mem_priv);
-	dma_buf_put(p->dbuf);
-	memset(p, 0, sizeof(*p));
 }
 
-/**
- * __vb2_buf_dmabuf_put() - release memory associated with
- * a DMABUF shared buffer
- */
-static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
+static unsigned int v4l2_get_index(struct vb2_buffer *vb)
 {
-	unsigned int plane;
-
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
-}
-
-/**
- * __setup_lengths() - setup initial lengths for every plane in
- * every buffer on the queue
- */
-static void __setup_lengths(struct vb2_queue *q, unsigned int n)
-{
-	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-
-	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-		vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-		for (plane = 0; plane < vb->num_planes; ++plane)
-			vbuf->v4l2_planes[plane].length = q->plane_sizes[plane];
-	}
+	return (vbuf->v4l2_buf.index);
 }
 
-/**
- * __setup_offsets() - setup unique offsets ("cookies") for every plane in
- * every buffer on the queue
- */
-static void __setup_offsets(struct vb2_queue *q, unsigned int n)
+static int v4l2_set_plane_length(struct vb2_buffer *vb, int plane,
+				unsigned int length)
 {
-	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-	unsigned long off;
-
-	if (q->num_buffers) {
-		struct v4l2_plane *p;
-		vb = q->bufs[q->num_buffers - 1];
-		vbuf = to_vb2_v4l2_buffer(vb);
-		p = &vbuf->v4l2_planes[vb->num_planes - 1];
-		off = PAGE_ALIGN(p->m.mem_offset + p->length);
-	} else {
-		off = 0;
-	}
-
-	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-		vbuf = to_vb2_v4l2_buffer(vb);
-
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			vbuf->v4l2_planes[plane].m.mem_offset = off;
-
-			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
-					buffer, plane, off);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-			off += vbuf->v4l2_planes[plane].length;
-			off = PAGE_ALIGN(off);
-		}
-	}
+	vbuf->v4l2_planes[plane].length = length;
+	return 0;
 }
 
-/**
- * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
- * video buffer memory for all buffers/planes on the queue and initializes the
- * queue
- *
- * Returns the number of buffers successfully allocated.
- */
-static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
-			     unsigned int num_buffers, unsigned int num_planes)
+static unsigned int v4l2_get_plane_length(struct vb2_buffer *vb, int plane)
 {
-	unsigned int buffer;
-	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-	int ret;
-
-	for (buffer = 0; buffer < num_buffers; ++buffer) {
-		/* Allocate videobuf buffer structures */
-		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
-		if (!vb) {
-			dprintk(1, "memory alloc for buffer struct failed\n");
-			break;
-		}
-
-		vbuf = to_vb2_v4l2_buffer(vb);
-
-		/* Length stores number of planes for multiplanar buffers */
-		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
-			vbuf->v4l2_buf.length = num_planes;
-
-		vb->state = VB2_BUF_STATE_DEQUEUED;
-		vb->vb2_queue = q;
-		vb->num_planes = num_planes;
-		vbuf->v4l2_buf.index = q->num_buffers + buffer;
-		vbuf->v4l2_buf.type = q->type;
-		vbuf->v4l2_buf.memory = memory;
-
-		/* Allocate video buffer memory for the MMAP type */
-		if (memory == V4L2_MEMORY_MMAP) {
-			ret = __vb2_buf_mem_alloc(vb);
-			if (ret) {
-				dprintk(1, "failed allocating memory for "
-						"buffer %d\n", buffer);
-				kfree(vb);
-				break;
-			}
-			/*
-			 * Call the driver-provided buffer initialization
-			 * callback, if given. An error in initialization
-			 * results in queue setup failure.
-			 */
-			ret = call_vb_qop(vb, buf_init, vb);
-			if (ret) {
-				dprintk(1, "buffer %d %p initialization"
-					" failed\n", buffer, vb);
-				__vb2_buf_mem_free(vb);
-				kfree(vb);
-				break;
-			}
-		}
-
-		q->bufs[q->num_buffers + buffer] = vb;
-	}
-
-	__setup_lengths(q, buffer);
-	if (memory == V4L2_MEMORY_MMAP)
-		__setup_offsets(q, buffer);
-
-	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
-			buffer, num_planes);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-	return buffer;
+	return (vbuf->v4l2_planes[plane].length);
 }
 
-/**
- * __vb2_free_mem() - release all video buffer memory for a given queue
- */
-static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
+static int v4l2_set_plane_offset(struct vb2_buffer *vb, int plane,
+				unsigned int offset)
 {
-	unsigned int buffer;
-	struct vb2_buffer *vb;
-
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-		/* Free MMAP buffers or release USERPTR buffers */
-		if (q->memory == V4L2_MEMORY_MMAP)
-			__vb2_buf_mem_free(vb);
-		else if (q->memory == V4L2_MEMORY_DMABUF)
-			__vb2_buf_dmabuf_put(vb);
-		else
-			__vb2_buf_userptr_put(vb);
-	}
+	vbuf->v4l2_planes[plane].m.mem_offset = offset;
+	return 0;
 }
 
-/**
- * __vb2_queue_free() - free buffers at the end of the queue - video memory and
- * related information, if no buffers are left return the queue to an
- * uninitialized state. Might be called even if the queue has already been freed.
- */
-static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
+static unsigned int v4l2_get_plane_offset(struct vb2_buffer *vb, int plane)
 {
-	unsigned int buffer;
-
-	/*
-	 * Sanity check: when preparing a buffer the queue lock is released for
-	 * a short while (see __buf_prepare for the details), which would allow
-	 * a race with a reqbufs which can call this function. Removing the
-	 * buffers from underneath __buf_prepare is obviously a bad idea, so we
-	 * check if any of the buffers is in the state PREPARING, and if so we
-	 * just return -EAGAIN.
-	 */
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		if (q->bufs[buffer] == NULL)
-			continue;
-		if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
-			dprintk(1, "preparing buffers, cannot free\n");
-			return -EAGAIN;
-		}
-	}
-
-	/* Call driver-provided cleanup function for each buffer, if provided */
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		struct vb2_buffer *vb = q->bufs[buffer];
-
-		if (vb && vb->planes[0].mem_priv)
-			call_void_vb_qop(vb, buf_cleanup, vb);
-	}
-
-	/* Release video buffer memory */
-	__vb2_free_mem(q, buffers);
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	/*
-	 * Check that all the calls were balances during the life-time of this
-	 * queue. If not (or if the debug level is 1 or up), then dump the
-	 * counters to the kernel log.
-	 */
-	if (q->num_buffers) {
-		bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
-				  q->cnt_wait_prepare != q->cnt_wait_finish;
-
-		if (unbalanced || debug) {
-			pr_info("vb2: counters for queue %p:%s\n", q,
-				unbalanced ? " UNBALANCED!" : "");
-			pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
-				q->cnt_queue_setup, q->cnt_start_streaming,
-				q->cnt_stop_streaming);
-			pr_info("vb2:     wait_prepare: %u wait_finish: %u\n",
-				q->cnt_wait_prepare, q->cnt_wait_finish);
-		}
-		q->cnt_queue_setup = 0;
-		q->cnt_wait_prepare = 0;
-		q->cnt_wait_finish = 0;
-		q->cnt_start_streaming = 0;
-		q->cnt_stop_streaming = 0;
-	}
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		struct vb2_buffer *vb = q->bufs[buffer];
-		bool unbalanced = vb->cnt_mem_alloc != vb->cnt_mem_put ||
-				  vb->cnt_mem_prepare != vb->cnt_mem_finish ||
-				  vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
-				  vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
-				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
-				  vb->cnt_buf_queue != vb->cnt_buf_done ||
-				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
-				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
-
-		if (unbalanced || debug) {
-			pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
-				q, buffer, unbalanced ? " UNBALANCED!" : "");
-			pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
-				vb->cnt_buf_init, vb->cnt_buf_cleanup,
-				vb->cnt_buf_prepare, vb->cnt_buf_finish);
-			pr_info("vb2:     buf_queue: %u buf_done: %u\n",
-				vb->cnt_buf_queue, vb->cnt_buf_done);
-			pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
-				vb->cnt_mem_alloc, vb->cnt_mem_put,
-				vb->cnt_mem_prepare, vb->cnt_mem_finish,
-				vb->cnt_mem_mmap);
-			pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
-				vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
-			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
-				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
-				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
-			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
-				vb->cnt_mem_get_dmabuf,
-				vb->cnt_mem_num_users,
-				vb->cnt_mem_vaddr,
-				vb->cnt_mem_cookie);
-		}
-	}
-#endif
-
-	/* Free videobuf buffers */
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		kfree(q->bufs[buffer]);
-		q->bufs[buffer] = NULL;
-	}
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-	q->num_buffers -= buffers;
-	if (!q->num_buffers) {
-		q->memory = 0;
-		INIT_LIST_HEAD(&q->queued_list);
-	}
-	return 0;
+	return (vbuf->v4l2_planes[plane].m.mem_offset);
 }
 
 /**
- * __verify_planes_array() - verify that the planes array passed in struct
+ * v4l2_verify_planes() - verify that the planes array passed in struct
  * v4l2_buffer from userspace can be safely used
  */
-static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int v4l2_verify_planes(struct vb2_buffer *vb, void *pb)
 {
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+
 	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
 		return 0;
 
 	/* Is memory for copying plane information present? */
 	if (NULL == b->m.planes) {
-		dprintk(1, "multi-planar buffer passed but "
+		VB2_DEBUG(1, "multi-planar buffer passed but "
 			   "planes array not provided\n");
 		return -EINVAL;
 	}
 
 	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
-		dprintk(1, "incorrect planes array length, "
+		VB2_DEBUG(1, "incorrect planes array length, "
 			   "expected %d, got %d\n", vb->num_planes, b->length);
 		return -EINVAL;
 	}
@@ -584,88 +125,12 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 }
 
 /**
- * __verify_length() - Verify that the bytesused value for each plane fits in
- * the plane length and that the data offset doesn't exceed the bytesused value.
- */
-static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
-{
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	unsigned int length;
-	unsigned int bytesused;
-	unsigned int plane;
-
-	if (!V4L2_TYPE_IS_OUTPUT(b->type))
-		return 0;
-
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			length = (b->memory == V4L2_MEMORY_USERPTR ||
-				  b->memory == V4L2_MEMORY_DMABUF)
-			       ? b->m.planes[plane].length
-			       : vbuf->v4l2_planes[plane].length;
-			bytesused = b->m.planes[plane].bytesused
-				  ? b->m.planes[plane].bytesused : length;
-
-			if (b->m.planes[plane].bytesused > length)
-				return -EINVAL;
-
-			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >= bytesused)
-				return -EINVAL;
-		}
-	} else {
-		length = (b->memory == V4L2_MEMORY_USERPTR)
-		       ? b->length : vbuf->v4l2_planes[0].length;
-		bytesused = b->bytesused ? b->bytesused : length;
-
-		if (b->bytesused > length)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * __buffer_in_use() - return true if the buffer is in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
- */
-static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
-{
-	unsigned int plane;
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		void *mem_priv = vb->planes[plane].mem_priv;
-		/*
-		 * If num_users() has not been provided, call_memop
-		 * will return 0, apparently nobody cares about this
-		 * case anyway. If num_users() returns more than 1,
-		 * we are not the only user of the plane's memory.
-		 */
-		if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
-			return true;
-	}
-	return false;
-}
-
-/**
- * __buffers_in_use() - return true if any buffers on the queue are in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
- */
-static bool __buffers_in_use(struct vb2_queue *q)
-{
-	unsigned int buffer;
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		if (__buffer_in_use(q, q->bufs[buffer]))
-			return true;
-	}
-	return false;
-}
-
-/**
- * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
+ * v4l2_fill_buffer() - fill in a struct v4l2_buffer with information to be
  * returned to userspace
  */
-static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+static int v4l2_fill_buffer(struct vb2_buffer *vb, void *pb)
 {
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
 	struct vb2_queue *q = vb->vb2_queue;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
@@ -734,530 +199,11 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 	if (__buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
-}
-
-/**
- * vb2_querybuf() - query video buffer information
- * @q:		videobuf queue
- * @b:		buffer struct passed from userspace to vidioc_querybuf handler
- *		in driver
- *
- * Should be called from vidioc_querybuf ioctl handler in driver.
- * This function will verify the passed v4l2_buffer structure and fill the
- * relevant information for the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_querybuf handler in driver.
- */
-int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb;
-	int ret;
-
-	if (b->type != q->type) {
-		dprintk(1, "wrong buffer type\n");
-		return -EINVAL;
-	}
-
-	if (b->index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
-		return -EINVAL;
-	}
-	vb = q->bufs[b->index];
-	ret = __verify_planes_array(vb, b);
-	if (!ret)
-		__fill_v4l2_buffer(vb, b);
-	return ret;
-}
-EXPORT_SYMBOL(vb2_querybuf);
-
-/**
- * __verify_userptr_ops() - verify that all memory operations required for
- * USERPTR queue type have been provided
- */
-static int __verify_userptr_ops(struct vb2_queue *q)
-{
-	if (!(q->io_modes & VB2_USERPTR) || !q->mem_ops->get_userptr ||
-	    !q->mem_ops->put_userptr)
-		return -EINVAL;
-
-	return 0;
-}
-
-/**
- * __verify_mmap_ops() - verify that all memory operations required for
- * MMAP queue type have been provided
- */
-static int __verify_mmap_ops(struct vb2_queue *q)
-{
-	if (!(q->io_modes & VB2_MMAP) || !q->mem_ops->alloc ||
-	    !q->mem_ops->put || !q->mem_ops->mmap)
-		return -EINVAL;
 
 	return 0;
 }
 
-/**
- * __verify_dmabuf_ops() - verify that all memory operations required for
- * DMABUF queue type have been provided
- */
-static int __verify_dmabuf_ops(struct vb2_queue *q)
-{
-	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
-	    !q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
-	    !q->mem_ops->unmap_dmabuf)
-		return -EINVAL;
-
-	return 0;
-}
-
-/**
- * __verify_memory_type() - Check whether the memory type and buffer type
- * passed to a buffer operation are compatible with the queue.
- */
-static int __verify_memory_type(struct vb2_queue *q,
-		enum v4l2_memory memory, enum v4l2_buf_type type)
-{
-	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
-	    memory != V4L2_MEMORY_DMABUF) {
-		dprintk(1, "unsupported memory type\n");
-		return -EINVAL;
-	}
-
-	if (type != q->type) {
-		dprintk(1, "requested type is incorrect\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * Make sure all the required memory ops for given memory type
-	 * are available.
-	 */
-	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
-		dprintk(1, "MMAP for current setup unsupported\n");
-		return -EINVAL;
-	}
-
-	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
-		dprintk(1, "USERPTR for current setup unsupported\n");
-		return -EINVAL;
-	}
-
-	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
-		dprintk(1, "DMABUF for current setup unsupported\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * Place the busy tests at the end: -EBUSY can be ignored when
-	 * create_bufs is called with count == 0, but count == 0 should still
-	 * do the memory and type validation.
-	 */
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-	return 0;
-}
-
-/**
- * __reqbufs() - Initiate streaming
- * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
- *
- * Should be called from vidioc_reqbufs ioctl handler of a driver.
- * This function:
- * 1) verifies streaming parameters passed from the userspace,
- * 2) sets up the queue,
- * 3) negotiates number of buffers and planes per buffer with the driver
- *    to be used during streaming,
- * 4) allocates internal buffer structures (struct vb2_buffer), according to
- *    the agreed parameters,
- * 5) for MMAP memory type, allocates actual video memory, using the
- *    memory handling/allocation routines provided during queue initialization
- *
- * If req->count is 0, all the memory will be freed instead.
- * If the queue has been allocated previously (by a previous vb2_reqbufs) call
- * and the queue is not busy, memory will be reallocated.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_reqbufs handler in driver.
- */
-static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
-{
-	unsigned int num_buffers, allocated_buffers, num_planes = 0;
-	int ret;
-
-	if (q->streaming) {
-		dprintk(1, "streaming active\n");
-		return -EBUSY;
-	}
-
-	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
-		/*
-		 * We already have buffers allocated, so first check if they
-		 * are not in use and can be freed.
-		 */
-		mutex_lock(&q->mmap_lock);
-		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
-			mutex_unlock(&q->mmap_lock);
-			dprintk(1, "memory in use, cannot free\n");
-			return -EBUSY;
-		}
-
-		/*
-		 * Call queue_cancel to clean up any buffers in the PREPARED or
-		 * QUEUED state which is possible if buffers were prepared or
-		 * queued without ever calling STREAMON.
-		 */
-		__vb2_queue_cancel(q);
-		ret = __vb2_queue_free(q, q->num_buffers);
-		mutex_unlock(&q->mmap_lock);
-		if (ret)
-			return ret;
-
-		/*
-		 * In case of REQBUFS(0) return immediately without calling
-		 * driver's queue_setup() callback and allocating resources.
-		 */
-		if (req->count == 0)
-			return 0;
-	}
-
-	/*
-	 * Make sure the requested values and current defaults are sane.
-	 */
-	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
-	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
-	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
-	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-	q->memory = req->memory;
-
-	/*
-	 * Ask the driver how many buffers and planes per buffer it requires.
-	 * Driver also sets the size and allocator context for each plane.
-	 */
-	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
-		       q->plane_sizes, q->alloc_ctx);
-	if (ret)
-		return ret;
-
-	/* Finally, allocate buffers and video memory */
-	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
-	if (allocated_buffers == 0) {
-		dprintk(1, "memory allocation failed\n");
-		return -ENOMEM;
-	}
-
-	/*
-	 * There is no point in continuing if we can't allocate the minimum
-	 * number of buffers needed by this vb2_queue.
-	 */
-	if (allocated_buffers < q->min_buffers_needed)
-		ret = -ENOMEM;
-
-	/*
-	 * Check if driver can handle the allocated number of buffers.
-	 */
-	if (!ret && allocated_buffers < num_buffers) {
-		num_buffers = allocated_buffers;
-
-		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
-
-		if (!ret && allocated_buffers < num_buffers)
-			ret = -ENOMEM;
-
-		/*
-		 * Either the driver has accepted a smaller number of buffers,
-		 * or .queue_setup() returned an error
-		 */
-	}
-
-	mutex_lock(&q->mmap_lock);
-	q->num_buffers = allocated_buffers;
-
-	if (ret < 0) {
-		/*
-		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
-		 */
-		__vb2_queue_free(q, allocated_buffers);
-		mutex_unlock(&q->mmap_lock);
-		return ret;
-	}
-	mutex_unlock(&q->mmap_lock);
-
-	/*
-	 * Return the number of successfully allocated buffers
-	 * to the userspace.
-	 */
-	req->count = allocated_buffers;
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
-
-	return 0;
-}
-
-/**
- * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
- * type values.
- * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
- */
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
-{
-	int ret = __verify_memory_type(q, req->memory, req->type);
-
-	return ret ? ret : __reqbufs(q, req);
-}
-EXPORT_SYMBOL_GPL(vb2_reqbufs);
-
-/**
- * __create_bufs() - Allocate buffers and any required auxiliary structs
- * @q:		videobuf2 queue
- * @create:	creation parameters, passed from userspace to vidioc_create_bufs
- *		handler in driver
- *
- * Should be called from vidioc_create_bufs ioctl handler of a driver.
- * This function:
- * 1) verifies parameter sanity
- * 2) calls the .queue_setup() queue operation
- * 3) performs any necessary memory allocations
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_create_bufs handler in driver.
- */
-static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
-{
-	unsigned int num_planes = 0, num_buffers, allocated_buffers;
-	int ret;
-
-	if (q->num_buffers == VIDEO_MAX_FRAME) {
-		dprintk(1, "maximum number of buffers already allocated\n");
-		return -ENOBUFS;
-	}
-
-	if (!q->num_buffers) {
-		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
-		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-		q->memory = create->memory;
-		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
-	}
-
-	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
-
-	/*
-	 * Ask the driver, whether the requested number of buffers, planes per
-	 * buffer and their sizes are acceptable
-	 */
-	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-		       &num_planes, q->plane_sizes, q->alloc_ctx);
-	if (ret)
-		return ret;
-
-	/* Finally, allocate buffers and video memory */
-	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
-				num_planes);
-	if (allocated_buffers == 0) {
-		dprintk(1, "memory allocation failed\n");
-		return -ENOMEM;
-	}
-
-	/*
-	 * Check if driver can handle the so far allocated number of buffers.
-	 */
-	if (allocated_buffers < num_buffers) {
-		num_buffers = allocated_buffers;
-
-		/*
-		 * q->num_buffers contains the total number of buffers, that the
-		 * queue driver has set up
-		 */
-		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
-
-		if (!ret && allocated_buffers < num_buffers)
-			ret = -ENOMEM;
-
-		/*
-		 * Either the driver has accepted a smaller number of buffers,
-		 * or .queue_setup() returned an error
-		 */
-	}
-
-	mutex_lock(&q->mmap_lock);
-	q->num_buffers += allocated_buffers;
-
-	if (ret < 0) {
-		/*
-		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
-		 */
-		__vb2_queue_free(q, allocated_buffers);
-		mutex_unlock(&q->mmap_lock);
-		return -ENOMEM;
-	}
-	mutex_unlock(&q->mmap_lock);
-
-	/*
-	 * Return the number of successfully allocated buffers
-	 * to the userspace.
-	 */
-	create->count = allocated_buffers;
-
-	return 0;
-}
-
-/**
- * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
- * memory and type values.
- * @q:		videobuf2 queue
- * @create:	creation parameters, passed from userspace to vidioc_create_bufs
- *		handler in driver
- */
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
-{
-	int ret = __verify_memory_type(q, create->memory, create->format.type);
-
-	create->index = q->num_buffers;
-	if (create->count == 0)
-		return ret != -EBUSY ? ret : 0;
-	return ret ? ret : __create_bufs(q, create);
-}
-EXPORT_SYMBOL_GPL(vb2_create_bufs);
-
-/**
- * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the address is to be returned
- *
- * This function returns a kernel virtual address of a given plane if
- * such a mapping exist, NULL otherwise.
- */
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
-{
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
-		return NULL;
-
-	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
-
-}
-EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
-
-/**
- * vb2_plane_cookie() - Return allocator specific cookie for the given plane
- * @vb:		vb2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the cookie is to be returned
- *
- * This function returns an allocator specific cookie for a given plane if
- * available, NULL otherwise. The allocator should provide some simple static
- * inline function, which would convert this cookie to the allocator specific
- * type that can be used directly by the driver to access the buffer. This can
- * be for example physical address, pointer to scatter list or IOMMU mapping.
- */
-void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
-{
-	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
-		return NULL;
-
-	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
-}
-EXPORT_SYMBOL_GPL(vb2_plane_cookie);
-
-/**
- * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
- * @vb:		vb2_buffer returned from the driver
- * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully,
- *		VB2_BUF_STATE_ERROR if the operation finished with an error or
- *		VB2_BUF_STATE_QUEUED if the driver wants to requeue buffers.
- *		If start_streaming fails then it should return buffers with state
- *		VB2_BUF_STATE_QUEUED to put them back into the queue.
- *
- * This function should be called by the driver after a hardware operation on
- * a buffer is finished and the buffer may be returned to userspace. The driver
- * cannot use this buffer anymore until it is queued back to it by videobuf
- * by the means of buf_queue callback. Only buffers previously queued to the
- * driver by buf_queue can be passed to this function.
- *
- * While streaming a buffer can only be returned in state DONE or ERROR.
- * The start_streaming op can also return them in case the DMA engine cannot
- * be started for some reason. In that case the buffers should be returned with
- * state QUEUED.
- */
-void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
-{
-	struct vb2_queue *q = vb->vb2_queue;
-	unsigned long flags;
-	unsigned int plane;
-
-	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
-		return;
-
-	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
-		    state != VB2_BUF_STATE_ERROR &&
-		    state != VB2_BUF_STATE_QUEUED))
-		state = VB2_BUF_STATE_ERROR;
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	/*
-	 * Although this is not a callback, it still does have to balance
-	 * with the buf_queue op. So update this counter manually.
-	 */
-	vb->cnt_buf_done++;
-#endif
-	dprintk(4, "done processing on buffer %d, state: %d\n",
-			vb2_v4l2_index(vb), state);
-
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
-
-	/* Add the buffer to the done buffers list */
-	spin_lock_irqsave(&q->done_lock, flags);
-	vb->state = state;
-	if (state != VB2_BUF_STATE_QUEUED)
-		list_add_tail(&vb->done_entry, &q->done_list);
-	atomic_dec(&q->owned_by_drv_count);
-	spin_unlock_irqrestore(&q->done_lock, flags);
-
-	trace_vb2_buf_done(q, vb);
-
-	if (state == VB2_BUF_STATE_QUEUED) {
-		if (q->start_streaming_called)
-			__enqueue_in_driver(vb);
-		return;
-	}
-
-	/* Inform any processes that may be waiting for buffers */
-	wake_up(&q->done_wq);
-}
-EXPORT_SYMBOL_GPL(vb2_buffer_done);
-
-/**
- * vb2_discard_done() - discard all buffers marked as DONE
- * @q:		videobuf2 queue
- *
- * This function is intended to be used with suspend/resume operations. It
- * discards all 'done' buffers as they would be too old to be requested after
- * resume.
- *
- * Drivers must stop the hardware and synchronize with interrupt handlers and/or
- * delayed works before calling this function to make sure no buffer will be
- * touched by the driver and/or hardware.
- */
-void vb2_discard_done(struct vb2_queue *q)
-{
-	struct vb2_buffer *vb;
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->done_lock, flags);
-	list_for_each_entry(vb, &q->done_list, done_entry)
-		vb->state = VB2_BUF_STATE_ERROR;
-	spin_unlock_irqrestore(&q->done_lock, flags);
-}
-EXPORT_SYMBOL_GPL(vb2_discard_done);
-
-static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
+static void __warn_zero_bytesused(struct vb2_buffer *vb)
 {
 	static bool __check_once __read_mostly;
 
@@ -1275,15 +221,17 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 }
 
 /**
- * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
+ * v4l2_fill_vb2_buffer() - fill a vb2_buffer with information provided in a
  * v4l2_buffer by the userspace. The caller has already verified that struct
  * v4l2_buffer has a valid number of planes.
  */
-static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
-				struct v4l2_plane *v4l2_planes)
+static int v4l2_fill_vb2_buffer(struct vb2_buffer *vb,
+		const void *pb, void *planes)
 {
-	unsigned int plane;
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct v4l2_plane *v4l2_planes = (struct v4l2_plane *)planes;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	unsigned int plane;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == V4L2_MEMORY_USERPTR) {
@@ -1326,7 +274,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 				struct v4l2_plane *psrc = &b->m.planes[plane];
 
 				if (psrc->bytesused == 0)
-					vb2_warn_zero_bytesused(vb);
+					__warn_zero_bytesused(vb);
 
 				if (vb->vb2_queue->allow_zero_bytesused)
 					pdst->bytesused = psrc->bytesused;
@@ -1363,7 +311,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 
 		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 			if (b->bytesused == 0)
-				vb2_warn_zero_bytesused(vb);
+				__warn_zero_bytesused(vb);
 
 			if (vb->vb2_queue->allow_zero_bytesused)
 				v4l2_planes[0].bytesused = b->bytesused;
@@ -1387,19 +335,64 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
 
-	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-		/*
-		 * For output buffers mask out the timecode flag:
-		 * this will be handled later in vb2_internal_qbuf().
-		 * The 'field' is valid metadata for this output buffer
-		 * and so that needs to be copied here.
-		 */
-		vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
-		vbuf->v4l2_buf.field = b->field;
+	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+		/*
+		 * For output buffers mask out the timecode flag:
+		 * this will be handled later in vb2_internal_qbuf().
+		 * The 'field' is valid metadata for this output buffer
+		 * and so that needs to be copied here.
+		 */
+		vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vbuf->v4l2_buf.field = b->field;
+	} else {
+		/* Zero any output buffer flags as this is a capture buffer */
+		vbuf->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
+	}
+
+	return 0;
+}
+
+/**
+ * __verify_length() - Verify that the bytesused value for each plane fits in
+ * the plane length and that the data offset doesn't exceed the bytesused value.
+ */
+static int __verify_length(struct vb2_buffer *vb, void *pb)
+{
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	unsigned int length;
+	unsigned int bytesused;
+	unsigned int plane;
+
+	if (!V4L2_TYPE_IS_OUTPUT(b->type))
+		return 0;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			length = (b->memory == V4L2_MEMORY_USERPTR ||
+				  b->memory == V4L2_MEMORY_DMABUF)
+			       ? b->m.planes[plane].length
+			       : vbuf->v4l2_planes[plane].length;
+			bytesused = b->m.planes[plane].bytesused
+				  ? b->m.planes[plane].bytesused : length;
+
+			if (b->m.planes[plane].bytesused > length)
+				return -EINVAL;
+
+			if (b->m.planes[plane].data_offset > 0 &&
+			    b->m.planes[plane].data_offset >= bytesused)
+				return -EINVAL;
+		}
 	} else {
-		/* Zero any output buffer flags as this is a capture buffer */
-		vbuf->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
+		length = (b->memory == V4L2_MEMORY_USERPTR)
+		       ? b->length : vbuf->v4l2_planes[0].length;
+		bytesused = b->bytesused ? b->bytesused : length;
+
+		if (b->bytesused > length)
+			return -EINVAL;
 	}
+
+	return 0;
 }
 
 /**
@@ -1409,7 +402,7 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-	__fill_vb2_buffer(vb, b, vbuf->v4l2_planes);
+	v4l2_fill_vb2_buffer(vb, b, vbuf->v4l2_planes);
 	return call_vb_qop(vb, buf_prepare, vb);
 }
 
@@ -1430,7 +423,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(vb, b, planes);
+	v4l2_fill_vb2_buffer(vb, b, planes);
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
@@ -1439,12 +432,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		    && vbuf->v4l2_planes[plane].length == planes[plane].length)
 			continue;
 
-		dprintk(3, "userspace address for plane %d changed, "
+		VB2_DEBUG(3, "userspace address for plane %d changed, "
 				"reacquiring memory\n", plane);
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "provided buffer size %u is less than "
+			VB2_DEBUG(1, "provided buffer size %u is less than "
 						"setup size %u for plane %d\n",
 						planes[plane].length,
 						q->plane_sizes[plane], plane);
@@ -1469,7 +462,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				      planes[plane].m.userptr,
 				      planes[plane].length, dma_dir);
 		if (IS_ERR_OR_NULL(mem_priv)) {
-			dprintk(1, "failed acquiring userspace "
+			VB2_DEBUG(1, "failed acquiring userspace "
 						"memory for plane %d\n", plane);
 			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
 			goto err;
@@ -1492,14 +485,14 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "buffer initialization failed\n");
+			VB2_DEBUG(1, "buffer initialization failed\n");
 			goto err;
 		}
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
+		VB2_DEBUG(1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1535,13 +528,13 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(vb, b, planes);
+	v4l2_fill_vb2_buffer(vb, b, planes);
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
 		if (IS_ERR_OR_NULL(dbuf)) {
-			dprintk(1, "invalid dmabuf fd for plane %d\n",
+			VB2_DEBUG(1, "invalid dmabuf fd for plane %d\n",
 				plane);
 			ret = -EINVAL;
 			goto err;
@@ -1552,7 +545,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "invalid dmabuf length for plane %d\n",
+			VB2_DEBUG(1, "invalid dmabuf length for plane %d\n",
 				plane);
 			ret = -EINVAL;
 			goto err;
@@ -1565,7 +558,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			continue;
 		}
 
-		dprintk(1, "buffer for plane %d changed\n", plane);
+		VB2_DEBUG(1, "buffer for plane %d changed\n", plane);
 
 		if (!reacquired) {
 			reacquired = true;
@@ -1580,7 +573,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
 			dbuf, planes[plane].length, dma_dir);
 		if (IS_ERR(mem_priv)) {
-			dprintk(1, "failed to attach dmabuf\n");
+			VB2_DEBUG(1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
 			dma_buf_put(dbuf);
 			goto err;
@@ -1597,7 +590,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
 		if (ret) {
-			dprintk(1, "failed to map dmabuf for plane %d\n",
+			VB2_DEBUG(1, "failed to map dmabuf for plane %d\n",
 				plane);
 			goto err;
 		}
@@ -1618,14 +611,14 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 */
 		ret = call_vb_qop(vb, buf_init, vb);
 		if (ret) {
-			dprintk(1, "buffer initialization failed\n");
+			VB2_DEBUG(1, "buffer initialization failed\n");
 			goto err;
 		}
 	}
 
 	ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
+		VB2_DEBUG(1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
 		goto err;
 	}
@@ -1638,35 +631,16 @@ err:
 	return ret;
 }
 
-/**
- * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
- */
-static void __enqueue_in_driver(struct vb2_buffer *vb)
-{
-	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int plane;
-
-	vb->state = VB2_BUF_STATE_ACTIVE;
-	atomic_inc(&q->owned_by_drv_count);
-
-	trace_vb2_buf_queue(q, vb);
-
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
-
-	call_void_vb_qop(vb, buf_queue, vb);
-}
-
-static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int v4l2_buf_prepare(struct vb2_buffer *vb, void *pb)
 {
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
 	struct vb2_queue *q = vb->vb2_queue;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	int ret;
 
 	ret = __verify_length(vb, b);
 	if (ret < 0) {
-		dprintk(1, "plane parameters verification failed: %d\n", ret);
+		VB2_DEBUG(1, "plane parameters verification failed: %d\n", ret);
 		return ret;
 	}
 	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
@@ -1679,12 +653,12 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		 * that just says that it is either a top or a bottom field,
 		 * but not which of the two it is.
 		 */
-		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
+		VB2_DEBUG(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
 		return -EINVAL;
 	}
 
 	if (q->error) {
-		dprintk(1, "fatal error occurred on queue\n");
+		VB2_DEBUG(1, "fatal error occurred on queue\n");
 		return -EIO;
 	}
 
@@ -1711,463 +685,149 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	if (ret)
-		dprintk(1, "buffer preparation failed: %d\n", ret);
+		VB2_DEBUG(1, "buffer preparation failed: %d\n", ret);
 	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
 
 	return ret;
 }
 
-static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname)
-{
-	if (b->type != q->type) {
-		dprintk(1, "%s: invalid buffer type\n", opname);
-		return -EINVAL;
-	}
-
-	if (b->index >= q->num_buffers) {
-		dprintk(1, "%s: buffer index out of range\n", opname);
-		return -EINVAL;
-	}
-
-	if (q->bufs[b->index] == NULL) {
-		/* Should never happen */
-		dprintk(1, "%s: buffer is NULL\n", opname);
-		return -EINVAL;
-	}
-
-	if (b->memory != q->memory) {
-		dprintk(1, "%s: invalid memory type\n", opname);
-		return -EINVAL;
-	}
-
-	return __verify_planes_array(q->bufs[b->index], b);
-}
-
-/**
- * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_prepare_buf
- *		handler in driver
- *
- * Should be called from vidioc_prepare_buf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_prepare callback in the driver (if provided), in which
- *    driver-specific buffer initialization can be performed,
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_prepare_buf handler in driver.
- */
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb;
-	int ret;
-
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-
-	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
-	if (ret)
-		return ret;
-
-	vb = q->bufs[b->index];
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "invalid buffer state %d\n",
-			vb->state);
-		return -EINVAL;
-	}
-
-	ret = __buf_prepare(vb, b);
-	if (!ret) {
-		/* Fill buffer information for the userspace */
-		__fill_v4l2_buffer(vb, b);
-
-		dprintk(1, "prepare of buffer %d succeeded\n",
-			vb2_v4l2_index(vb));
-	}
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vb2_prepare_buf);
-
-/**
- * vb2_start_streaming() - Attempt to start streaming.
- * @q:		videobuf2 queue
- *
- * Attempt to start streaming. When this function is called there must be
- * at least q->min_buffers_needed buffers queued up (i.e. the minimum
- * number of buffers required for the DMA engine to function). If the
- * @start_streaming op fails it is supposed to return all the driver-owned
- * buffers back to vb2 in state QUEUED. Check if that happened and if
- * not warn and reclaim them forcefully.
- */
-static int vb2_start_streaming(struct vb2_queue *q)
+static int v4l2_set_timestamp(struct vb2_buffer *vb, void *pb)
 {
-	struct vb2_buffer *vb;
-	int ret;
-
-	/*
-	 * If any buffers were queued before streamon,
-	 * we can now pass them to driver for processing.
-	 */
-	list_for_each_entry(vb, &q->queued_list, queued_entry)
-		__enqueue_in_driver(vb);
-
-	/* Tell the driver to start streaming */
-	q->start_streaming_called = 1;
-	ret = call_qop(q, start_streaming, q,
-		       atomic_read(&q->owned_by_drv_count));
-	if (!ret)
-		return 0;
-
-	q->start_streaming_called = 0;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_queue *q = vb->vb2_queue;
 
-	dprintk(1, "driver refused to start streaming\n");
-	/*
-	 * If you see this warning, then the driver isn't cleaning up properly
-	 * after a failed start_streaming(). See the start_streaming()
-	 * documentation in videobuf2-v4l2.h for more information how buffers
-	 * should be returned to vb2 in start_streaming().
-	 */
-	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
-		unsigned i;
+	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY)
+		vbuf->v4l2_buf.timestamp = b->timestamp;
+	vbuf->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+		vbuf->v4l2_buf.timecode = b->timecode;
 
-		/*
-		 * Forcefully reclaim buffers if the driver did not
-		 * correctly return them to vb2.
-		 */
-		for (i = 0; i < q->num_buffers; ++i) {
-			vb = q->bufs[i];
-			if (vb->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED);
-		}
-		/* Must be zero now */
-		WARN_ON(atomic_read(&q->owned_by_drv_count));
-	}
-	/*
-	 * If done_list is not empty, then start_streaming() didn't call
-	 * vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED) but STATE_ERROR or
-	 * STATE_DONE.
-	 */
-	WARN_ON(!list_empty(&q->done_list));
-	return ret;
+	return 0;
 }
 
-static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+static int v4l2_is_last(struct vb2_buffer *vb)
 {
-	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	struct vb2_buffer *vb;
-
-	if (ret)
-		return ret;
-
-	vb = q->bufs[b->index];
-
-	switch (vb->state) {
-	case VB2_BUF_STATE_DEQUEUED:
-		ret = __buf_prepare(vb, b);
-		if (ret)
-			return ret;
-		break;
-	case VB2_BUF_STATE_PREPARED:
-		break;
-	case VB2_BUF_STATE_PREPARING:
-		dprintk(1, "buffer still being prepared\n");
-		return -EINVAL;
-	default:
-		dprintk(1, "invalid buffer state %d\n", vb->state);
-		return -EINVAL;
-	}
-
-	/*
-	 * Add to the queued buffers list, a buffer will stay on it until
-	 * dequeued in dqbuf.
-	 */
-	list_add_tail(&vb->queued_entry, &q->queued_list);
-	q->queued_count++;
-	q->waiting_for_buffers = false;
-	vb->state = VB2_BUF_STATE_QUEUED;
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
-		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-
-		/*
-		 * For output buffers copy the timestamp if needed,
-		 * and the timecode field and flag if needed.
-		 */
-		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vbuf->v4l2_buf.timestamp = b->timestamp;
-		vbuf->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
-		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			vbuf->v4l2_buf.timecode = b->timecode;
-	}
-
-	trace_vb2_qbuf(q, vb);
-
-	/*
-	 * If already streaming, give the buffer to driver for processing.
-	 * If not, the buffer will be given to driver on next streamon.
-	 */
-	if (q->start_streaming_called)
-		__enqueue_in_driver(vb);
-
-	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
-
-	/*
-	 * If streamon has been called, and we haven't yet called
-	 * start_streaming() since not enough buffers were queued, and
-	 * we now have reached the minimum number of queued buffers,
-	 * then we can finally call start_streaming().
-	 */
-	if (q->streaming && !q->start_streaming_called &&
-	    q->queued_count >= q->min_buffers_needed) {
-		ret = vb2_start_streaming(q);
-		if (ret)
-			return ret;
-	}
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-	dprintk(1, "qbuf of buffer %d succeeded\n", vb2_v4l2_index(vb));
-	return 0;
-}
+	return (vbuf->v4l2_buf.flags & V4L2_BUF_FLAG_LAST);
+}
+
+const struct vb2_buf_ops vb2_v4l2_buf_ops = {
+	.init_buffer		= v4l2_init_buffer,
+	.get_index 		= v4l2_get_index,
+	.set_plane_length	= v4l2_set_plane_length,
+	.get_plane_length	= v4l2_get_plane_length,
+	.set_plane_offset	= v4l2_set_plane_offset,
+	.get_plane_offset	= v4l2_get_plane_offset,
+	.verify_planes		= v4l2_verify_planes,
+	.fill_buffer		= v4l2_fill_buffer,
+	.fill_vb2_buffer	= v4l2_fill_vb2_buffer,
+	.prepare_buffer		= v4l2_buf_prepare,
+	.set_timestamp		= v4l2_set_timestamp,
+	.is_last		= v4l2_is_last,
+};
 
 /**
- * vb2_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ * vb2_querybuf() - query video buffer information
+ * @q:		videobuf queue
+ * @b:		buffer struct passed from userspace to vidioc_querybuf handler
  *		in driver
  *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
+ * Should be called from vidioc_querybuf ioctl handler in driver.
+ * This function will verify the passed v4l2_buffer structure and fill the
+ * relevant information for the userspace.
  *
  * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
+ * from vidioc_querybuf handler in driver.
  */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-
-	return vb2_internal_qbuf(q, b);
+	return vb2_core_querybuf(q, b->type, b->index, b);
 }
-EXPORT_SYMBOL_GPL(vb2_qbuf);
+EXPORT_SYMBOL(vb2_querybuf);
 
 /**
- * __vb2_wait_for_done_vb() - wait for a buffer to become available
- * for dequeuing
- *
- * Will sleep if required for nonblocking == false.
+ * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
+ * type values.
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
  */
-static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
-	/*
-	 * All operations on vb_done_list are performed under done_lock
-	 * spinlock protection. However, buffers may be removed from
-	 * it and returned to userspace only while holding both driver's
-	 * lock and the done_lock spinlock. Thus we can be sure that as
-	 * long as we hold the driver's lock, the list will remain not
-	 * empty if list_empty() check succeeds.
-	 */
-
-	for (;;) {
-		int ret;
-
-		if (!q->streaming) {
-			dprintk(1, "streaming off, will not wait for buffers\n");
-			return -EINVAL;
-		}
-
-		if (q->error) {
-			dprintk(1, "Queue in error state, will not wait for buffers\n");
-			return -EIO;
-		}
-
-		if (q->last_buffer_dequeued) {
-			dprintk(3, "last buffer dequeued already, will not wait for buffers\n");
-			return -EPIPE;
-		}
-
-		if (!list_empty(&q->done_list)) {
-			/*
-			 * Found a buffer that we were waiting for.
-			 */
-			break;
-		}
-
-		if (nonblocking) {
-			dprintk(1, "nonblocking and no buffers to dequeue, "
-								"will not wait\n");
-			return -EAGAIN;
-		}
-
-		/*
-		 * We are streaming and blocking, wait for another buffer to
-		 * become ready or for streamoff. Driver's lock is released to
-		 * allow streamoff or qbuf to be called while waiting.
-		 */
-		call_void_qop(q, wait_prepare, q);
-
-		/*
-		 * All locks have been released, it is safe to sleep now.
-		 */
-		dprintk(3, "will sleep waiting for buffers\n");
-		ret = wait_event_interruptible(q->done_wq,
-				!list_empty(&q->done_list) || !q->streaming ||
-				q->error);
+	int ret = __verify_memory_type(q, req->memory, req->type);
 
-		/*
-		 * We need to reevaluate both conditions again after reacquiring
-		 * the locks or return an error if one occurred.
-		 */
-		call_void_qop(q, wait_finish, q);
-		if (ret) {
-			dprintk(1, "sleep was interrupted\n");
-			return ret;
-		}
-	}
-	return 0;
+	return ret ? ret : vb2_core_reqbufs(q, req->memory, &req->count);
 }
+EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
- * __vb2_get_done_vb() - get a buffer ready for dequeuing
- *
- * Will sleep if required for nonblocking == false.
+ * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
+ * memory and type values.
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
  */
-static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
-				struct v4l2_buffer *b, int nonblocking)
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb)
 {
-	unsigned long flags;
-	int ret;
+	int ret = __verify_memory_type(q, cb->memory, cb->format.type);
 
-	/*
-	 * Wait for at least one buffer to become available on the done_list.
-	 */
-	ret = __vb2_wait_for_done_vb(q, nonblocking);
-	if (ret)
-		return ret;
-
-	/*
-	 * Driver's lock has been held since we last verified that done_list
-	 * is not empty, so no need for another list_empty(done_list) check.
-	 */
-	spin_lock_irqsave(&q->done_lock, flags);
-	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
-	/*
-	 * Only remove the buffer from done_list if v4l2_buffer can handle all
-	 * the planes.
-	 */
-	ret = __verify_planes_array(*vb, b);
-	if (!ret)
-		list_del(&(*vb)->done_entry);
-	spin_unlock_irqrestore(&q->done_lock, flags);
-
-	return ret;
+	cb->index = q->num_buffers;
+	if (cb->count == 0)
+		return ret != -EBUSY ? ret : 0;
+	return ret ? ret : vb2_core_create_bufs(q, cb->memory, &cb->count, &cb->format);
 }
+EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
- * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2
+ * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
  * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_prepare_buf
+ *		handler in driver
  *
- * This function will wait until all buffers that have been given to the driver
- * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
- * wait_prepare, wait_finish pair. It is intended to be called with all locks
- * taken, for example from stop_streaming() callback.
- */
-int vb2_wait_for_all_buffers(struct vb2_queue *q)
-{
-	if (!q->streaming) {
-		dprintk(1, "streaming off, will not wait for buffers\n");
-		return -EINVAL;
-	}
-
-	if (q->start_streaming_called)
-		wait_event(q->done_wq, !atomic_read(&q->owned_by_drv_count));
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
-
-/**
- * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
+ * Should be called from vidioc_prepare_buf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_prepare callback in the driver (if provided), in which
+ *    driver-specific buffer initialization can be performed,
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_prepare_buf handler in driver.
  */
-static void __vb2_dqbuf(struct vb2_buffer *vb)
+int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int i;
-
-	/* nothing to do if the buffer is already dequeued */
-	if (vb->state == VB2_BUF_STATE_DEQUEUED)
-		return;
-
-	vb->state = VB2_BUF_STATE_DEQUEUED;
-
-	/* unmap DMABUF buffer */
-	if (q->memory == V4L2_MEMORY_DMABUF)
-		for (i = 0; i < vb->num_planes; ++i) {
-			if (!vb->planes[i].dbuf_mapped)
-				continue;
-			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
-			vb->planes[i].dbuf_mapped = 0;
-		}
+	return vb2_core_prepare_buf(q, b->memory, b->type, b->index, b);
 }
+EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
-static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+/**
+ * vb2_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
+ *    which driver-specific buffer initialization can be performed,
+ * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb = NULL;
-	struct vb2_v4l2_buffer *vbuf = NULL;
-	int ret;
-
-	if (b->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
-		return -EINVAL;
-	}
-	ret = __vb2_get_done_vb(q, &vb, b, nonblocking);
-	if (ret < 0)
-		return ret;
-
-	switch (vb->state) {
-	case VB2_BUF_STATE_DONE:
-		dprintk(3, "returning done buffer\n");
-		break;
-	case VB2_BUF_STATE_ERROR:
-		dprintk(3, "returning done buffer with errors\n");
-		break;
-	default:
-		dprintk(1, "invalid buffer state\n");
-		return -EINVAL;
+	if (vb2_fileio_is_active(q)) {
+		VB2_DEBUG(1, "file io in progress\n");
+		return -EBUSY;
 	}
 
-	call_void_vb_qop(vb, buf_finish, vb);
-
-	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
-	/* Remove from videobuf queue */
-	list_del(&vb->queued_entry);
-	q->queued_count--;
-
-	trace_vb2_dqbuf(q, vb);
-
-	vbuf = to_vb2_v4l2_buffer(vb);
-
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
-	    vbuf->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-	/* go back to dequeued state */
-	__vb2_dqbuf(vb);
-
-	dprintk(1, "dqbuf of buffer %d, with state %d\n",
-			vb2_v4l2_index(vb), vb->state);
-
-	return 0;
+	return vb2_core_qbuf(q, b->memory, b->type, b->index, b);
 }
+EXPORT_SYMBOL_GPL(vb2_qbuf);
 
 /**
  * vb2_dqbuf() - Dequeue a buffer to the userspace
@@ -2193,144 +853,29 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_internal_dqbuf(q, b, nonblocking);
+	return vb2_core_dqbuf(q, b->type, b, nonblocking);
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 /**
- * __vb2_queue_cancel() - cancel and stop (pause) streaming
- *
- * Removes all queued buffers from driver's queue and all buffers queued by
- * userspace from videobuf's queue. Returns to state after reqbufs.
- */
-static void __vb2_queue_cancel(struct vb2_queue *q)
-{
-	unsigned int i;
-
-	/*
-	 * Tell driver to stop all transactions and release all queued
-	 * buffers.
-	 */
-	if (q->start_streaming_called)
-		call_void_qop(q, stop_streaming, q);
-
-	/*
-	 * If you see this warning, then the driver isn't cleaning up properly
-	 * in stop_streaming(). See the stop_streaming() documentation in
-	 * videobuf2-v4l2.h for more information how buffers should be returned
-	 * to vb2 in stop_streaming().
-	 */
-	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
-		for (i = 0; i < q->num_buffers; ++i)
-			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
-		/* Must be zero now */
-		WARN_ON(atomic_read(&q->owned_by_drv_count));
-	}
-
-	q->streaming = 0;
-	q->start_streaming_called = 0;
-	q->queued_count = 0;
-	q->error = 0;
-
-	/*
-	 * Remove all buffers from videobuf's list...
-	 */
-	INIT_LIST_HEAD(&q->queued_list);
-	/*
-	 * ...and done list; userspace will not receive any buffers it
-	 * has not already dequeued before initiating cancel.
-	 */
-	INIT_LIST_HEAD(&q->done_list);
-	atomic_set(&q->owned_by_drv_count, 0);
-	wake_up_all(&q->done_wq);
-
-	/*
-	 * Reinitialize all buffers for next use.
-	 * Make sure to call buf_finish for any queued buffers. Normally
-	 * that's done in dqbuf, but that's not going to happen when we
-	 * cancel the whole queue. Note: this code belongs here, not in
-	 * __vb2_dqbuf() since in vb2_internal_dqbuf() there is a critical
-	 * call to __fill_v4l2_buffer() after buf_finish(). That order can't
-	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
-	 */
-	for (i = 0; i < q->num_buffers; ++i) {
-		struct vb2_buffer *vb = q->bufs[i];
-
-		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-			vb->state = VB2_BUF_STATE_PREPARED;
-			call_void_vb_qop(vb, buf_finish, vb);
-		}
-		__vb2_dqbuf(vb);
-	}
-}
-
-static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
-{
-	int ret;
-
-	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
-		return -EINVAL;
-	}
-
-	if (q->streaming) {
-		dprintk(3, "already streaming\n");
-		return 0;
-	}
-
-	if (!q->num_buffers) {
-		dprintk(1, "no buffers have been allocated\n");
-		return -EINVAL;
-	}
-
-	if (q->num_buffers < q->min_buffers_needed) {
-		dprintk(1, "need at least %u allocated buffers\n",
-				q->min_buffers_needed);
-		return -EINVAL;
-	}
-
-	/*
-	 * Tell driver to start streaming provided sufficient buffers
-	 * are available.
-	 */
-	if (q->queued_count >= q->min_buffers_needed) {
-		ret = vb2_start_streaming(q);
-		if (ret) {
-			__vb2_queue_cancel(q);
-			return ret;
-		}
-	}
-
-	q->streaming = 1;
-
-	dprintk(3, "successful\n");
-	return 0;
-}
-
-/**
- * vb2_queue_error() - signal a fatal error on the queue
+ * vb2_expbuf() - Export a buffer as a file descriptor
  * @q:		videobuf2 queue
+ * @eb:		export buffer structure passed from userspace to vidioc_expbuf
+ *		handler in driver
  *
- * Flag that a fatal unrecoverable error has occurred and wake up all processes
- * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
- * buffers will return -EIO.
- *
- * The error flag will be cleared when cancelling the queue, either from
- * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
- * function before starting the stream, otherwise the error flag will remain set
- * until the queue is released when closing the device node.
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
  */
-void vb2_queue_error(struct vb2_queue *q)
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
-	q->error = 1;
+	eb->fd = vb2_core_expbuf(q, eb->type, eb->index, eb->plane, eb->flags);
 
-	wake_up_all(&q->done_wq);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_queue_error);
+EXPORT_SYMBOL_GPL(vb2_expbuf);
 
 /**
  * vb2_streamon - start streaming
@@ -2348,36 +893,13 @@ EXPORT_SYMBOL_GPL(vb2_queue_error);
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_internal_streamon(q, type);
-}
-EXPORT_SYMBOL_GPL(vb2_streamon);
-
-static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
-{
-	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
-		return -EINVAL;
-	}
 
-	/*
-	 * Cancel will pause streaming and remove all buffers from the driver
-	 * and videobuf, effectively returning control over them to userspace.
-	 *
-	 * Note that we do this even if q->streaming == 0: if you prepare or
-	 * queue buffers, and then call streamoff without ever having called
-	 * streamon, you would still expect those buffers to be returned to
-	 * their normal dequeued state.
-	 */
-	__vb2_queue_cancel(q);
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
-	q->last_buffer_dequeued = false;
-
-	dprintk(3, "successful\n");
-	return 0;
+	return vb2_core_streamon(q, type);
 }
+EXPORT_SYMBOL_GPL(vb2_streamon);
 
 /**
  * vb2_streamoff - stop streaming
@@ -2397,243 +919,13 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_internal_streamoff(q, type);
+	return vb2_core_streamoff(q, type);
 }
 EXPORT_SYMBOL_GPL(vb2_streamoff);
 
-/**
- * __find_plane_by_offset() - find plane associated with the given offset off
- */
-static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
-			unsigned int *_buffer, unsigned int *_plane)
-{
-	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-	unsigned int buffer, plane;
-
-	/*
-	 * Go over all buffers and their planes, comparing the given offset
-	 * with an offset assigned to each plane. If a match is found,
-	 * return its buffer and plane numbers.
-	 */
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		vb = q->bufs[buffer];
-		vbuf = to_vb2_v4l2_buffer(vb);
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			if (vbuf->v4l2_planes[plane].m.mem_offset == off) {
-				*_buffer = buffer;
-				*_plane = plane;
-				return 0;
-			}
-		}
-	}
-
-	return -EINVAL;
-}
-
-/**
- * vb2_expbuf() - Export a buffer as a file descriptor
- * @q:		videobuf2 queue
- * @eb:		export buffer structure passed from userspace to vidioc_expbuf
- *		handler in driver
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_expbuf handler in driver.
- */
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
-{
-	struct vb2_buffer *vb = NULL;
-	struct vb2_plane *vb_plane;
-	int ret;
-	struct dma_buf *dbuf;
-
-	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
-
-	if (!q->mem_ops->get_dmabuf) {
-		dprintk(1, "queue does not support DMA buffer exporting\n");
-		return -EINVAL;
-	}
-
-	if (eb->flags & ~(O_CLOEXEC | O_ACCMODE)) {
-		dprintk(1, "queue does support only O_CLOEXEC and access mode flags\n");
-		return -EINVAL;
-	}
-
-	if (eb->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
-		return -EINVAL;
-	}
-
-	if (eb->index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
-		return -EINVAL;
-	}
-
-	vb = q->bufs[eb->index];
-
-	if (eb->plane >= vb->num_planes) {
-		dprintk(1, "buffer plane out of range\n");
-		return -EINVAL;
-	}
-
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "expbuf: file io in progress\n");
-		return -EBUSY;
-	}
-
-	vb_plane = &vb->planes[eb->plane];
-
-	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
-	if (IS_ERR_OR_NULL(dbuf)) {
-		dprintk(1, "failed to export buffer %d, plane %d\n",
-			eb->index, eb->plane);
-		return -EINVAL;
-	}
-
-	ret = dma_buf_fd(dbuf, eb->flags & ~O_ACCMODE);
-	if (ret < 0) {
-		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
-			eb->index, eb->plane, ret);
-		dma_buf_put(dbuf);
-		return ret;
-	}
-
-	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
-		eb->index, eb->plane, ret);
-	eb->fd = ret;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vb2_expbuf);
-
-/**
- * vb2_mmap() - map video buffers into application address space
- * @q:		videobuf2 queue
- * @vma:	vma passed to the mmap file operation handler in the driver
- *
- * Should be called from mmap file operation handler of a driver.
- * This function maps one plane of one of the available video buffers to
- * userspace. To map whole video memory allocated on reqbufs, this function
- * has to be called once per each plane per each buffer previously allocated.
- *
- * When the userspace application calls mmap, it passes to it an offset returned
- * to it earlier by the means of vidioc_querybuf handler. That offset acts as
- * a "cookie", which is then used to identify the plane to be mapped.
- * This function finds a plane with a matching offset and a mapping is performed
- * by the means of a provided memory operation.
- *
- * The return values from this function are intended to be directly returned
- * from the mmap handler in driver.
- */
-int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
-{
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
-	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *vbuf;
-	unsigned int buffer = 0, plane = 0;
-	int ret;
-	unsigned long length;
-
-	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * Check memory area access mode.
-	 */
-	if (!(vma->vm_flags & VM_SHARED)) {
-		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
-		return -EINVAL;
-	}
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
-		if (!(vma->vm_flags & VM_WRITE)) {
-			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
-			return -EINVAL;
-		}
-	} else {
-		if (!(vma->vm_flags & VM_READ)) {
-			dprintk(1, "invalid vma flags, VM_READ needed\n");
-			return -EINVAL;
-		}
-	}
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "mmap: file io in progress\n");
-		return -EBUSY;
-	}
-
-	/*
-	 * Find the plane corresponding to the offset passed by userspace.
-	 */
-	ret = __find_plane_by_offset(q, off, &buffer, &plane);
-	if (ret)
-		return ret;
-
-	vb = q->bufs[buffer];
-	vbuf = to_vb2_v4l2_buffer(vb);
-
-	/*
-	 * MMAP requires page_aligned buffers.
-	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
-	 * so, we need to do the same here.
-	 */
-	length = PAGE_ALIGN(vbuf->v4l2_planes[plane].length);
-	if (length < (vma->vm_end - vma->vm_start)) {
-		dprintk(1,
-			"MMAP invalid, as it would overflow buffer length\n");
-		return -EINVAL;
-	}
-
-	mutex_lock(&q->mmap_lock);
-	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
-	mutex_unlock(&q->mmap_lock);
-	if (ret)
-		return ret;
-
-	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vb2_mmap);
-
-#ifndef CONFIG_MMU
-unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
-				    unsigned long addr,
-				    unsigned long len,
-				    unsigned long pgoff,
-				    unsigned long flags)
-{
-	unsigned long off = pgoff << PAGE_SHIFT;
-	struct vb2_buffer *vb;
-	unsigned int buffer, plane;
-	void *vaddr;
-	int ret;
-
-	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * Find the plane corresponding to the offset passed by userspace.
-	 */
-	ret = __find_plane_by_offset(q, off, &buffer, &plane);
-	if (ret)
-		return ret;
-
-	vb = q->bufs[buffer];
-
-	vaddr = vb2_plane_vaddr(vb, plane);
-	return vaddr ? (unsigned long)vaddr : -EINVAL;
-}
-EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
-#endif
-
 static int __vb2_init_fileio(struct vb2_queue *q, int read);
 static int __vb2_cleanup_fileio(struct vb2_queue *q);
 
@@ -2757,22 +1049,20 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * responsible of clearing it's content and setting initial values for some
  * required entries before calling this function.
  * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
 int vb2_queue_init(struct vb2_queue *q)
 {
+	int ret = vb2_core_queue_init(q);
+
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * Sanity check
 	 */
-	if (WARN_ON(!q)			  ||
-	    WARN_ON(!q->ops)		  ||
-	    WARN_ON(!q->mem_ops)	  ||
-	    WARN_ON(!q->type)		  ||
-	    WARN_ON(!q->io_modes)	  ||
-	    WARN_ON(!q->ops->queue_setup) ||
-	    WARN_ON(!q->ops->buf_queue)   ||
-	    WARN_ON(q->timestamp_flags &
+	if (WARN_ON(q->timestamp_flags &
 		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
 		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
 		return -EINVAL;
@@ -2781,15 +1071,11 @@ int vb2_queue_init(struct vb2_queue *q)
 	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
 		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
 
-	INIT_LIST_HEAD(&q->queued_list);
-	INIT_LIST_HEAD(&q->done_list);
-	spin_lock_init(&q->done_lock);
-	mutex_init(&q->mmap_lock);
-	init_waitqueue_head(&q->done_wq);
-
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
+	q->buf_ops = &vb2_v4l2_buf_ops;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
@@ -2805,10 +1091,7 @@ EXPORT_SYMBOL_GPL(vb2_queue_init);
 void vb2_queue_release(struct vb2_queue *q)
 {
 	__vb2_cleanup_fileio(q);
-	__vb2_queue_cancel(q);
-	mutex_lock(&q->mmap_lock);
-	__vb2_queue_free(q, q->num_buffers);
-	mutex_unlock(&q->mmap_lock);
+	vb2_core_queue_release(q);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
@@ -2898,7 +1181,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 */
 	count = 1;
 
-	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
+	VB2_DEBUG(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
 		(read) ? "read" : "write", count, q->fileio_read_once,
 		q->fileio_write_immediately);
 
@@ -2917,7 +1200,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	fileio->req.memory = V4L2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
-	ret = __reqbufs(q, &fileio->req);
+	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
 	if (ret)
 		goto err_kfree;
 
@@ -2963,7 +1246,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			}
 			b->memory = q->memory;
 			b->index = i;
-			ret = vb2_internal_qbuf(q, b);
+			ret = vb2_core_qbuf(q, b->memory, b->type, i, b);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -2979,7 +1262,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Start streaming.
 	 */
-	ret = vb2_internal_streamon(q, q->type);
+	ret = vb2_core_streamon(q, q->type);
 	if (ret)
 		goto err_reqbufs;
 
@@ -2987,7 +1270,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 
 err_reqbufs:
 	fileio->req.count = 0;
-	__reqbufs(q, &fileio->req);
+	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -3004,12 +1287,12 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 	struct vb2_fileio_data *fileio = q->fileio;
 
 	if (fileio) {
-		vb2_internal_streamoff(q, q->type);
+		vb2_core_streamoff(q, q->type);
 		q->fileio = NULL;
 		fileio->req.count = 0;
 		vb2_reqbufs(q, &fileio->req);
 		kfree(fileio);
-		dprintk(3, "file io emulator closed\n");
+		VB2_DEBUG(3, "file io emulator closed\n");
 	}
 	return 0;
 }
@@ -3039,7 +1322,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	int ret, index;
 
-	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
+	VB2_DEBUG(3, "mode %s, offset %ld, count %zd, %sblocking\n",
 		read ? "read" : "write", (long)*ppos, count,
 		nonblock ? "non" : "");
 
@@ -3051,7 +1334,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	if (!vb2_fileio_is_active(q)) {
 		ret = __vb2_init_fileio(q, read);
-		dprintk(3, "vb2_init_fileio result: %d\n", ret);
+		VB2_DEBUG(3, "vb2_init_fileio result: %d\n", ret);
 		if (ret)
 			return ret;
 	}
@@ -3073,8 +1356,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			fileio->b.m.planes = &fileio->p;
 			fileio->b.length = 1;
 		}
-		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
-		dprintk(5, "vb2_dqbuf result: %d\n", ret);
+		ret = vb2_core_dqbuf(q, fileio->b.type, &fileio->b, nonblock);
+		VB2_DEBUG(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 		fileio->dq_count += 1;
@@ -3104,20 +1387,20 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	 */
 	if (buf->pos + count > buf->size) {
 		count = buf->size - buf->pos;
-		dprintk(5, "reducing read count: %zd\n", count);
+		VB2_DEBUG(5, "reducing read count: %zd\n", count);
 	}
 
 	/*
 	 * Transfer data to userspace.
 	 */
-	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
+	VB2_DEBUG(3, "copying %zd bytes - buffer %d, offset %u\n",
 		count, index, buf->pos);
 	if (read)
 		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
 	else
 		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
 	if (ret) {
-		dprintk(3, "error copying data\n");
+		VB2_DEBUG(3, "error copying data\n");
 		return -EFAULT;
 	}
 
@@ -3135,7 +1418,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 * Check if this is the last buffer to read.
 		 */
 		if (read && fileio->read_once && fileio->dq_count == 1) {
-			dprintk(3, "read limit reached\n");
+			VB2_DEBUG(3, "read limit reached\n");
 			return __vb2_cleanup_fileio(q);
 		}
 
@@ -3155,8 +1438,9 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		}
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
-		dprintk(5, "vb2_dbuf result: %d\n", ret);
+		ret = vb2_core_qbuf(q, fileio->b.memory, fileio->b.type, index,
+				&fileio->b);
+		VB2_DEBUG(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 
@@ -3247,9 +1531,9 @@ static int vb2_thread(void *data)
 		} else {
 			call_void_qop(q, wait_finish, q);
 			if (!threadio->stop)
-				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
+				ret = vb2_core_dqbuf(q, fileio->b.type, &fileio->b, 0);
 			call_void_qop(q, wait_prepare, q);
-			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+			VB2_DEBUG(5, "file io: vb2_dqbuf result: %d\n", ret);
 		}
 		if (ret || threadio->stop)
 			break;
@@ -3263,7 +1547,8 @@ static int vb2_thread(void *data)
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
 		if (!threadio->stop)
-			ret = vb2_internal_qbuf(q, &fileio->b);
+			ret = vb2_core_qbuf(q, fileio->b.memory,
+				fileio->b.type, fileio->b.index, &fileio->b);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
 			break;
@@ -3302,7 +1587,7 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 	threadio->priv = priv;
 
 	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
-	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
+	VB2_DEBUG(3, "file io: vb2_init_fileio result: %d\n", ret);
 	if (ret)
 		goto nomem;
 	q->threadio = threadio;
@@ -3367,7 +1652,7 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = __reqbufs(vdev->queue, p);
+	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
 	/* If count == 0, then the owner has released all buffers and he
 	   is no longer owner of the queue. Otherwise we have a new owner. */
 	if (res == 0)
@@ -3391,7 +1676,7 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = __create_bufs(vdev->queue, p);
+	res = vb2_core_create_bufs(vdev->queue, p->memory, &p->count, &p->format);
 	if (res == 0)
 		vdev->queue->owner = file->private_data;
 	return res;
@@ -3405,7 +1690,8 @@ int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_prepare_buf(vdev->queue, p);
+	return vb2_core_prepare_buf(vdev->queue,
+			p->memory, p->type, p->index, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
 
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 45da6cd..2fe4c27 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-memops.h>
 
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index d903ece..264d76f 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -41,7 +41,7 @@
  * videobuf2 queue operations
  */
 
-static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int uvc_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
new file mode 100644
index 0000000..dc405da
--- /dev/null
+++ b/include/media/videobuf2-core.h
@@ -0,0 +1,724 @@
+/*
+ * videobuf2-core.h - Video Buffer 2 Core Framework
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <pawel@osciak.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+#ifndef _MEDIA_VIDEOBUF2_CORE_H
+#define _MEDIA_VIDEOBUF2_CORE_H
+
+#include <linux/mm_types.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+#include <linux/videodev2.h>
+#include <linux/dma-buf.h>
+
+struct vb2_alloc_ctx;
+struct vb2_fileio_data;
+struct vb2_threadio_data;
+
+/**
+ * struct vb2_mem_ops - memory handling/memory allocator operations
+ * @alloc:	allocate video memory and, optionally, allocator private data,
+ *		return NULL on failure or a pointer to allocator private,
+ *		per-buffer data on success; the returned private structure
+ *		will then be passed as buf_priv argument to other ops in this
+ *		structure. Additional gfp_flags to use when allocating the
+ *		are also passed to this operation. These flags are from the
+ *		gfp_flags field of vb2_queue.
+ * @put:	inform the allocator that the buffer will no longer be used;
+ *		usually will result in the allocator freeing the buffer (if
+ *		no other users of this buffer are present); the buf_priv
+ *		argument is the allocator private per-buffer structure
+ *		previously returned from the alloc callback.
+ * @get_userptr: acquire userspace memory for a hardware operation; used for
+ *		 USERPTR memory types; vaddr is the address passed to the
+ *		 videobuf layer when queuing a video buffer of USERPTR type;
+ *		 should return an allocator private per-buffer structure
+ *		 associated with the buffer on success, NULL on failure;
+ *		 the returned private structure will then be passed as buf_priv
+ *		 argument to other ops in this structure.
+ * @put_userptr: inform the allocator that a USERPTR buffer will no longer
+ *		 be used.
+ * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
+ *		   used for DMABUF memory types; alloc_ctx is the alloc context
+ *		   dbuf is the shared dma_buf; returns NULL on failure;
+ *		   allocator private per-buffer structure on success;
+ *		   this needs to be used for further accesses to the buffer.
+ * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
+ *		   buffer is no longer used; the buf_priv argument is the
+ *		   allocator private per-buffer structure previously returned
+ *		   from the attach_dmabuf callback.
+ * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
+ *		of dmabuf is informed that this driver is going to use the
+ *		dmabuf.
+ * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
+ *		  that this driver is done using the dmabuf for now.
+ * @prepare:	called every time the buffer is passed from userspace to the
+ *		driver, useful for cache synchronisation, optional.
+ * @finish:	called every time the buffer is passed back from the driver
+ *		to the userspace, also optional.
+ * @vaddr:	return a kernel virtual address to a given memory buffer
+ *		associated with the passed private structure or NULL if no
+ *		such mapping exists.
+ * @cookie:	return allocator specific cookie for a given memory buffer
+ *		associated with the passed private structure or NULL if not
+ *		available.
+ * @num_users:	return the current number of users of a memory buffer;
+ *		return 1 if the videobuf layer (or actually the driver using
+ *		it) is the only user.
+ * @mmap:	setup a userspace mapping for a given memory buffer under
+ *		the provided virtual memory region.
+ *
+ * Required ops for USERPTR types: get_userptr, put_userptr.
+ * Required ops for MMAP types: alloc, put, num_users, mmap.
+ * Required ops for read/write access types: alloc, put, num_users, vaddr.
+ * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
+ *				  unmap_dmabuf.
+ */
+struct vb2_mem_ops {
+	void		*(*alloc)(void *alloc_ctx, unsigned long size,
+				  enum dma_data_direction dma_dir,
+				  gfp_t gfp_flags);
+	void		(*put)(void *buf_priv);
+	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
+
+	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
+					unsigned long size,
+					enum dma_data_direction dma_dir);
+	void		(*put_userptr)(void *buf_priv);
+
+	void		(*prepare)(void *buf_priv);
+	void		(*finish)(void *buf_priv);
+
+	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
+					  unsigned long size,
+					  enum dma_data_direction dma_dir);
+	void		(*detach_dmabuf)(void *buf_priv);
+	int		(*map_dmabuf)(void *buf_priv);
+	void		(*unmap_dmabuf)(void *buf_priv);
+
+	void		*(*vaddr)(void *buf_priv);
+	void		*(*cookie)(void *buf_priv);
+
+	unsigned int	(*num_users)(void *buf_priv);
+
+	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
+};
+
+struct vb2_plane {
+	void			*mem_priv;
+	struct dma_buf		*dbuf;
+	unsigned int		dbuf_mapped;
+};
+
+/**
+ * enum vb2_io_modes - queue access methods
+ * @VB2_MMAP:		driver supports MMAP with streaming API
+ * @VB2_USERPTR:	driver supports USERPTR with streaming API
+ * @VB2_READ:		driver supports read() style access
+ * @VB2_WRITE:		driver supports write() style access
+ * @VB2_DMABUF:		driver supports DMABUF with streaming API
+ */
+enum vb2_io_modes {
+	VB2_MMAP	= (1 << 0),
+	VB2_USERPTR	= (1 << 1),
+	VB2_READ	= (1 << 2),
+	VB2_WRITE	= (1 << 3),
+	VB2_DMABUF	= (1 << 4),
+};
+
+/**
+ * enum vb2_buffer_state - current video buffer state
+ * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
+ * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
+ * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
+ * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
+ * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
+ *				in a hardware operation
+ * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
+ *				not yet dequeued to userspace
+ * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
+ *				has ended with an error, which will be reported
+ *				to the userspace when it is dequeued
+ */
+enum vb2_buffer_state {
+	VB2_BUF_STATE_DEQUEUED,
+	VB2_BUF_STATE_PREPARING,
+	VB2_BUF_STATE_PREPARED,
+	VB2_BUF_STATE_QUEUED,
+	VB2_BUF_STATE_ACTIVE,
+	VB2_BUF_STATE_DONE,
+	VB2_BUF_STATE_ERROR,
+};
+
+struct vb2_queue;
+
+/**
+ * struct vb2_buffer - represents a video buffer
+ * @vb2_queue:		the queue to which this driver belongs
+ * @num_planes:		number of planes in the buffer
+ *			on an internal driver queue
+ * @state:		current buffer state; do not change
+ * @queued_entry:	entry on the queued buffers list, which holds all
+ *			buffers queued from userspace
+ * @done_entry:		entry on the list that stores all buffers ready to
+ *			be dequeued to userspace
+ * @planes:		private per-plane information; do not change
+ */
+struct vb2_buffer {
+	struct vb2_queue	*vb2_queue;
+	unsigned int		num_planes;
+
+/* Private: internal use only */
+	enum vb2_buffer_state	state;
+
+	struct list_head	queued_entry;
+	struct list_head	done_entry;
+
+	struct vb2_plane	planes[VIDEO_MAX_PLANES];
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	/*
+	 * Counters for how often these buffer-related ops are
+	 * called. Used to check for unbalanced ops.
+	 */
+	u32		cnt_mem_alloc;
+	u32		cnt_mem_put;
+	u32		cnt_mem_get_dmabuf;
+	u32		cnt_mem_get_userptr;
+	u32		cnt_mem_put_userptr;
+	u32		cnt_mem_prepare;
+	u32		cnt_mem_finish;
+	u32		cnt_mem_attach_dmabuf;
+	u32		cnt_mem_detach_dmabuf;
+	u32		cnt_mem_map_dmabuf;
+	u32		cnt_mem_unmap_dmabuf;
+	u32		cnt_mem_vaddr;
+	u32		cnt_mem_cookie;
+	u32		cnt_mem_num_users;
+	u32		cnt_mem_mmap;
+
+	u32		cnt_buf_init;
+	u32		cnt_buf_prepare;
+	u32		cnt_buf_finish;
+	u32		cnt_buf_cleanup;
+	u32		cnt_buf_queue;
+
+	/* This counts the number of calls to vb2_buffer_done() */
+	u32		cnt_buf_done;
+#endif
+};
+
+/**
+ * struct vb2_ops - driver-specific callbacks
+ *
+ * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
+ *			handlers before memory allocation, or, if
+ *			*num_planes != 0, after the allocation to verify a
+ *			smaller number of buffers. Driver should return
+ *			the required number of buffers in *num_buffers, the
+ *			required number of planes per buffer in *num_planes; the
+ *			size of each plane should be set in the sizes[] array
+ *			and optional per-plane allocator specific context in the
+ *			alloc_ctxs[] array. When called from VIDIOC_REQBUFS,
+ *			fmt == NULL, the driver has to use the currently
+ *			configured format and *num_buffers is the total number
+ *			of buffers, that are being allocated. When called from
+ *			VIDIOC_CREATE_BUFS, fmt != NULL and it describes the
+ *			target frame format (if the format isn't valid the
+ *			callback must return -EINVAL). In this case *num_buffers
+ *			are being allocated additionally to q->num_buffers.
+ * @wait_prepare:	release any locks taken while calling vb2 functions;
+ *			it is called before an ioctl needs to wait for a new
+ *			buffer to arrive; required to avoid a deadlock in
+ *			blocking access type.
+ * @wait_finish:	reacquire all locks released in the previous callback;
+ *			required to continue operation after sleeping while
+ *			waiting for a new buffer to arrive.
+ * @buf_init:		called once after allocating a buffer (in MMAP case)
+ *			or after acquiring a new USERPTR buffer; drivers may
+ *			perform additional buffer-related initialization;
+ *			initialization failure (return != 0) will prevent
+ *			queue setup from completing successfully; optional.
+ * @buf_prepare:	called every time the buffer is queued from userspace
+ *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
+ *			perform any initialization required before each
+ *			hardware operation in this callback; drivers can
+ *			access/modify the buffer here as it is still synced for
+ *			the CPU; drivers that support VIDIOC_CREATE_BUFS must
+ *			also validate the buffer size; if an error is returned,
+ *			the buffer will not be queued in driver; optional.
+ * @buf_finish:		called before every dequeue of the buffer back to
+ *			userspace; the buffer is synced for the CPU, so drivers
+ *			can access/modify the buffer contents; drivers may
+ *			perform any operations required before userspace
+ *			accesses the buffer; optional. The buffer state can be
+ *			one of the following: DONE and ERROR occur while
+ *			streaming is in progress, and the PREPARED state occurs
+ *			when the queue has been canceled and all pending
+ *			buffers are being returned to their default DEQUEUED
+ *			state. Typically you only have to do something if the
+ *			state is VB2_BUF_STATE_DONE, since in all other cases
+ *			the buffer contents will be ignored anyway.
+ * @buf_cleanup:	called once before the buffer is freed; drivers may
+ *			perform any additional cleanup; optional.
+ * @start_streaming:	called once to enter 'streaming' state; the driver may
+ *			receive buffers with @buf_queue callback before
+ *			@start_streaming is called; the driver gets the number
+ *			of already queued buffers in count parameter; driver
+ *			can return an error if hardware fails, in that case all
+ *			buffers that have been already given by the @buf_queue
+ *			callback are to be returned by the driver by calling
+ *			@vb2_buffer_done(VB2_BUF_STATE_QUEUED).
+ *			If you need a minimum number of buffers before you can
+ *			start streaming, then set @min_buffers_needed in the
+ *			vb2_queue structure. If that is non-zero then
+ *			start_streaming won't be called until at least that
+ *			many buffers have been queued up by userspace.
+ * @stop_streaming:	called when 'streaming' state must be disabled; driver
+ *			should stop any DMA transactions or wait until they
+ *			finish and give back all buffers it got from buf_queue()
+ *			callback by calling @vb2_buffer_done() with either
+ *			VB2_BUF_STATE_DONE or VB2_BUF_STATE_ERROR; may use
+ *			vb2_wait_for_all_buffers() function
+ * @buf_queue:		passes buffer vb to the driver; driver may start
+ *			hardware operation on this buffer; driver should give
+ *			the buffer back by calling vb2_buffer_done() function;
+ *			it is allways called after calling STREAMON ioctl;
+ *			might be called before start_streaming callback if user
+ *			pre-queued buffers before calling STREAMON.
+ */
+struct vb2_ops {
+	int (*queue_setup)(struct vb2_queue *q, const void *parg,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned int sizes[], void *alloc_ctxs[]);
+
+	void (*wait_prepare)(struct vb2_queue *q);
+	void (*wait_finish)(struct vb2_queue *q);
+
+	int (*buf_init)(struct vb2_buffer *vb);
+	int (*buf_prepare)(struct vb2_buffer *vb);
+	void (*buf_finish)(struct vb2_buffer *vb);
+	void (*buf_cleanup)(struct vb2_buffer *vb);
+
+	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
+	void (*stop_streaming)(struct vb2_queue *q);
+
+	void (*buf_queue)(struct vb2_buffer *vb);
+};
+
+struct vb2_buf_ops {
+	int (*init_buffer)(struct vb2_buffer *vb, unsigned int memory,
+		unsigned int type, unsigned int index, unsigned int planes);
+	unsigned int (*get_index)(struct vb2_buffer *vb);
+	int (*set_plane_length)(struct vb2_buffer *vb, int plane,
+		unsigned int length);
+	unsigned int (*get_plane_length)(struct vb2_buffer *vb, int plane);
+	int (*set_plane_offset)(struct vb2_buffer *vb, int plane,
+		unsigned int offset);
+	unsigned int (*get_plane_offset)(struct vb2_buffer *vb, int plane);
+	int (*verify_planes)(struct vb2_buffer *vb, void *pb);
+	int (*fill_buffer)(struct vb2_buffer *vb, void *pb);
+	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
+		void *planes);
+	int (*prepare_buffer)(struct vb2_buffer *vb, void *pb);
+	int (*set_timestamp)(struct vb2_buffer *vb, void *pb);
+	int (*is_last)(struct vb2_buffer *vb);
+};
+
+/**
+ * struct vb2_queue - a videobuf queue
+ *
+ * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
+ * @io_modes:	supported io methods (see vb2_io_modes enum)
+ * @fileio_read_once:		report EOF after reading the first buffer
+ * @fileio_write_immediately:	queue buffer after each write() call
+ * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
+ * @lock:	pointer to a mutex that protects the vb2_queue struct. The
+ *		driver can set this to a mutex to let the vb2 core serialize
+ *		the queuing ioctls. If the driver wants to handle locking
+ *		itself, then this should be set to NULL. This lock is not used
+ *		by the videobuf2 core API.
+ * @owner:	The filehandle that 'owns' the buffers, i.e. the filehandle
+ *		that called reqbufs, create_buffers or started fileio.
+ *		This field is not used by the videobuf2 core API, but it allows
+ *		drivers to easily associate an owner filehandle with the queue.
+ * @ops:	driver-specific callbacks
+ * @mem_ops:	memory allocator specific callbacks
+ * @drv_priv:	driver private data
+ * @buf_struct_size: size of the driver-specific buffer structure;
+ *		"0" indicates the driver doesn't want to use a custom buffer
+ *		structure type, so, sizeof(struct vb2_v4l2_buffer) will is used
+ *		in case of v4l2.
+ * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
+ *		V4L2_BUF_FLAG_TSTAMP_SRC_*
+ * @gfp_flags:	additional gfp flags used when allocating the buffers.
+ *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
+ *		to force the buffer allocation to a specific memory zone.
+ * @min_buffers_needed: the minimum number of buffers needed before
+ *		start_streaming() can be called. Used when a DMA engine
+ *		cannot be started unless at least this number of buffers
+ *		have been queued into the driver.
+ *
+ * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
+ * @memory:	current memory type used
+ * @bufs:	videobuf buffer structures
+ * @num_buffers: number of allocated/used buffers
+ * @queued_list: list of buffers currently queued from userspace
+ * @queued_count: number of buffers queued and ready for streaming.
+ * @owned_by_drv_count: number of buffers owned by the driver
+ * @done_list:	list of buffers ready to be dequeued to userspace
+ * @done_lock:	lock to protect done_list list
+ * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
+ * @alloc_ctx:	memory type/allocator-specific contexts for each plane
+ * @streaming:	current streaming state
+ * @start_streaming_called: start_streaming() was called successfully and we
+ *		started streaming.
+ * @error:	a fatal error occurred on the queue
+ * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
+ *		buffers. Only set for capture queues if qbuf has not yet been
+ *		called since poll() needs to return POLLERR in that situation.
+ * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
+ *		last decoded buffer was already dequeued. Set for capture queues
+ *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
+ * @fileio:	file io emulator internal data, used only if emulator is active
+ * @threadio:	thread io internal data, used only if thread is active
+ */
+struct vb2_queue {
+	unsigned int			type;
+	unsigned int			io_modes;
+	unsigned			fileio_read_once:1;
+	unsigned			fileio_write_immediately:1;
+	unsigned			allow_zero_bytesused:1;
+
+	struct mutex			*lock;
+	void				*owner;
+
+	const struct vb2_ops		*ops;
+	const struct vb2_mem_ops	*mem_ops;
+	const struct vb2_buf_ops	*buf_ops;
+
+	void				*drv_priv;
+	unsigned int			buf_struct_size;
+	u32				timestamp_flags;
+	gfp_t				gfp_flags;
+	u32				min_buffers_needed;
+
+/* private: internal use only */
+	struct mutex			mmap_lock;
+	unsigned int			memory;
+	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	unsigned int			num_buffers;
+
+	struct list_head		queued_list;
+	unsigned int			queued_count;
+
+	atomic_t			owned_by_drv_count;
+	struct list_head		done_list;
+	spinlock_t			done_lock;
+	wait_queue_head_t		done_wq;
+
+	void				*alloc_ctx[VIDEO_MAX_PLANES];
+	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
+
+	unsigned int			streaming:1;
+	unsigned int			start_streaming_called:1;
+	unsigned int			error:1;
+	unsigned int			waiting_for_buffers:1;
+	unsigned int			last_buffer_dequeued:1;
+
+	struct vb2_fileio_data		*fileio;
+	struct vb2_threadio_data	*threadio;
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	/*
+	 * Counters for how often these queue-related ops are
+	 * called. Used to check for unbalanced ops.
+	 */
+	u32				cnt_queue_setup;
+	u32				cnt_wait_prepare;
+	u32				cnt_wait_finish;
+	u32				cnt_start_streaming;
+	u32				cnt_stop_streaming;
+#endif
+};
+
+extern int vb2_debug;
+
+#define VB2_DEBUG(level, fmt, arg...)					 \
+	do {								 \
+		if (vb2_debug >= level)					 \
+			pr_info("vb2-core: %s: " fmt, __func__, ## arg); \
+	} while (0)
+
+#define call_bufop(q, op, args...)					\
+({ 									\
+	int ret = 0;							\
+									\
+	if(q && q->buf_ops && q->buf_ops->op)				\
+		ret = q->buf_ops->op(args);				\
+	ret;								\
+})
+
+#define call_u32_bufop(q, op, args...)					\
+({ 									\
+	unsigned int ret = 0;						\
+									\
+	if(q && q->buf_ops && q->buf_ops->op)				\
+		ret = q->buf_ops->op(args);				\
+	ret;								\
+})
+
+#define vb2_index(vb) (call_u32_bufop((vb)->vb2_queue, get_index, vb))
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+
+/*
+ * If advanced debugging is on, then count how often each op is called
+ * successfully, which can either be per-buffer or per-queue.
+ *
+ * This makes it easy to check that the 'init' and 'cleanup'
+ * (and variations thereof) stay balanced.
+ */
+
+#define log_memop(vb, op)						\
+	VB2_DEBUG(2, "call_memop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, vb2_index(vb), #op,			\
+		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
+
+#define call_memop(vb, op, args...)					\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	int err;							\
+									\
+	log_memop(vb, op);						\
+	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
+	if (!err)							\
+		(vb)->cnt_mem_ ## op++;					\
+	err;								\
+})
+
+#define call_ptr_memop(vb, op, args...)					\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+	void *ptr;							\
+									\
+	log_memop(vb, op);						\
+	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
+	if (!IS_ERR_OR_NULL(ptr))					\
+		(vb)->cnt_mem_ ## op++;					\
+	ptr;								\
+})
+
+#define call_void_memop(vb, op, args...)				\
+({									\
+	struct vb2_queue *_q = (vb)->vb2_queue;				\
+									\
+	log_memop(vb, op);						\
+	if (_q->mem_ops->op)						\
+		_q->mem_ops->op(args);					\
+	(vb)->cnt_mem_ ## op++;						\
+})
+
+#define log_qop(q, op)							\
+	VB2_DEBUG(2, "call_qop(%p, %s)%s\n", q, #op,			\
+		(q)->ops->op ? "" : " (nop)")
+
+#define call_qop(q, op, args...)					\
+({									\
+	int err;							\
+									\
+	log_qop(q, op);							\
+	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
+	if (!err)							\
+		(q)->cnt_ ## op++;					\
+	err;								\
+})
+
+#define call_void_qop(q, op, args...)					\
+({									\
+	log_qop(q, op);							\
+	if ((q)->ops->op)						\
+		(q)->ops->op(args);					\
+	(q)->cnt_ ## op++;						\
+})
+
+#define log_vb_qop(vb, op, args...)					\
+	VB2_DEBUG(2, "call_vb_qop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, vb2_index(vb), #op,			\
+		(vb)->vb2_queue->ops->op ? "" : " (nop)")
+
+#define call_vb_qop(vb, op, args...)					\
+({									\
+	int err;							\
+									\
+	log_vb_qop(vb, op);						\
+	err = (vb)->vb2_queue->ops->op ?				\
+		(vb)->vb2_queue->ops->op(args) : 0;			\
+	if (!err)							\
+		(vb)->cnt_ ## op++;					\
+	err;								\
+})
+
+#define call_void_vb_qop(vb, op, args...)				\
+({									\
+	log_vb_qop(vb, op);						\
+	if ((vb)->vb2_queue->ops->op)					\
+		(vb)->vb2_queue->ops->op(args);				\
+	(vb)->cnt_ ## op++;						\
+})
+
+#else
+
+#define call_memop(vb, op, args...)					\
+	((vb)->vb2_queue->mem_ops->op ?					\
+		(vb)->vb2_queue->mem_ops->op(args) : 0)
+
+#define call_ptr_memop(vb, op, args...)					\
+	((vb)->vb2_queue->mem_ops->op ?					\
+		(vb)->vb2_queue->mem_ops->op(args) : NULL)
+
+#define call_void_memop(vb, op, args...)				\
+	do {								\
+		if ((vb)->vb2_queue->mem_ops->op)			\
+			(vb)->vb2_queue->mem_ops->op(args);		\
+	} while (0)
+
+#define call_qop(q, op, args...)					\
+	((q)->ops->op ? (q)->ops->op(args) : 0)
+
+#define call_void_qop(q, op, args...)					\
+	do {								\
+		if ((q)->ops->op)					\
+			(q)->ops->op(args);				\
+	} while (0)
+
+#define call_vb_qop(vb, op, args...)					\
+	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
+
+#define call_void_vb_qop(vb, op, args...)				\
+	do {								\
+		if ((vb)->vb2_queue->ops->op)				\
+			(vb)->vb2_queue->ops->op(args);			\
+	} while (0)
+
+#endif
+
+void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
+
+void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+void vb2_discard_done(struct vb2_queue *q);
+int vb2_wait_for_all_buffers(struct vb2_queue *q);
+
+int vb2_core_querybuf(struct vb2_queue *q, unsigned int type,
+		unsigned int index, void *pb);
+int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory, unsigned int *count);
+int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
+		unsigned int *count, void *parg);
+int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int memory,
+		unsigned int type, unsigned int index, void *pb);
+
+int __must_check vb2_core_queue_init(struct vb2_queue *q);
+
+void vb2_core_queue_release(struct vb2_queue *q);
+void vb2_queue_error(struct vb2_queue *q);
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int memory, unsigned int type,
+		unsigned int index, void *pb);
+int vb2_core_dqbuf(struct vb2_queue *q, unsigned int type, void *pb, bool nonblock);
+int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
+		unsigned int plane, unsigned int flags);
+
+int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
+int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);
+
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
+#ifndef CONFIG_MMU
+unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
+				    unsigned long addr,
+				    unsigned long len,
+				    unsigned long pgoff,
+				    unsigned long flags);
+#endif
+
+/*
+ * The following functions are for internal uses.
+ */
+bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
+void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p);
+void __vb2_buf_dmabuf_put(struct vb2_buffer *vb);
+int __verify_memory_type(struct vb2_queue *q,
+		enum v4l2_memory memory, enum v4l2_buf_type type);
+
+/**
+ * vb2_is_streaming() - return streaming status of the queue
+ * @q:		videobuf queue
+ */
+static inline bool vb2_is_streaming(struct vb2_queue *q)
+{
+	return q->streaming;
+}
+
+/**
+ * vb2_fileio_is_active() - return true if fileio is active.
+ * @q:		videobuf queue
+ *
+ * This returns true if read() or write() is used to stream the data
+ * as opposed to stream I/O. This is almost never an important distinction,
+ * except in rare cases. One such case is that using read() or write() to
+ * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
+ * is no way you can pass the field information of each buffer to/from
+ * userspace. A driver that supports this field format should check for
+ * this in the queue_setup op and reject it if this function returns true.
+ */
+static inline bool vb2_fileio_is_active(struct vb2_queue *q)
+{
+	return q->fileio;
+}
+
+/**
+ * vb2_is_busy() - return busy status of the queue
+ * @q:		videobuf queue
+ *
+ * This function checks if queue has any buffers allocated.
+ */
+static inline bool vb2_is_busy(struct vb2_queue *q)
+{
+	return (q->num_buffers > 0);
+}
+
+/**
+ * vb2_get_drv_priv() - return driver private data associated with the queue
+ * @q:		videobuf queue
+ */
+static inline void *vb2_get_drv_priv(struct vb2_queue *q)
+{
+	return q->drv_priv;
+}
+
+/**
+ * vb2_start_streaming_called() - return streaming status of driver
+ * @q:		videobuf queue
+ */
+static inline bool vb2_start_streaming_called(struct vb2_queue *q)
+{
+	return q->start_streaming_called;
+}
+
+/**
+ * vb2_clear_last_buffer_dequeued() - clear last buffer dequeued flag of queue
+ * @q:		videobuf queue
+ */
+static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
+{
+	q->last_buffer_dequeued = false;
+}
+
+#endif /* _MEDIA_VIDEOBUF2_CORE_H */
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index c33dfa6..8197f87 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -13,7 +13,7 @@
 #ifndef _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 #define _MEDIA_VIDEOBUF2_DMA_CONTIG_H
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 #include <linux/dma-mapping.h>
 
 static inline dma_addr_t
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 8d1083f..14ce306 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -13,7 +13,7 @@
 #ifndef _MEDIA_VIDEOBUF2_DMA_SG_H
 #define _MEDIA_VIDEOBUF2_DMA_SG_H
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 
 static inline struct sg_table *vb2_dma_sg_plane_desc(
 		struct vb2_buffer *vb, unsigned int plane_no)
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index 7b6d475..f05444c 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -14,7 +14,7 @@
 #ifndef _MEDIA_VIDEOBUF2_MEMOPS_H
 #define _MEDIA_VIDEOBUF2_MEMOPS_H
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 
 /**
  * vb2_vmarea_handler - common vma refcount tracking handler
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 76500f4..3f76e53 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -12,212 +12,11 @@
 #ifndef _MEDIA_VIDEOBUF2_V4L2_H
 #define _MEDIA_VIDEOBUF2_V4L2_H
 
-#include <linux/mm_types.h>
-#include <linux/mutex.h>
-#include <linux/poll.h>
-#include <linux/videodev2.h>
-#include <linux/dma-buf.h>
-
-struct vb2_alloc_ctx;
-struct vb2_fileio_data;
-struct vb2_threadio_data;
-
-/**
- * struct vb2_mem_ops - memory handling/memory allocator operations
- * @alloc:	allocate video memory and, optionally, allocator private data,
- *		return NULL on failure or a pointer to allocator private,
- *		per-buffer data on success; the returned private structure
- *		will then be passed as buf_priv argument to other ops in this
- *		structure. Additional gfp_flags to use when allocating the
- *		are also passed to this operation. These flags are from the
- *		gfp_flags field of vb2_queue.
- * @put:	inform the allocator that the buffer will no longer be used;
- *		usually will result in the allocator freeing the buffer (if
- *		no other users of this buffer are present); the buf_priv
- *		argument is the allocator private per-buffer structure
- *		previously returned from the alloc callback.
- * @get_userptr: acquire userspace memory for a hardware operation; used for
- *		 USERPTR memory types; vaddr is the address passed to the
- *		 videobuf layer when queuing a video buffer of USERPTR type;
- *		 should return an allocator private per-buffer structure
- *		 associated with the buffer on success, NULL on failure;
- *		 the returned private structure will then be passed as buf_priv
- *		 argument to other ops in this structure.
- * @put_userptr: inform the allocator that a USERPTR buffer will no longer
- *		 be used.
- * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
- *		   used for DMABUF memory types; alloc_ctx is the alloc context
- *		   dbuf is the shared dma_buf; returns NULL on failure;
- *		   allocator private per-buffer structure on success;
- *		   this needs to be used for further accesses to the buffer.
- * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
- *		   buffer is no longer used; the buf_priv argument is the
- *		   allocator private per-buffer structure previously returned
- *		   from the attach_dmabuf callback.
- * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
- *		of dmabuf is informed that this driver is going to use the
- *		dmabuf.
- * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
- *		  that this driver is done using the dmabuf for now.
- * @prepare:	called every time the buffer is passed from userspace to the
- *		driver, useful for cache synchronisation, optional.
- * @finish:	called every time the buffer is passed back from the driver
- *		to the userspace, also optional.
- * @vaddr:	return a kernel virtual address to a given memory buffer
- *		associated with the passed private structure or NULL if no
- *		such mapping exists.
- * @cookie:	return allocator specific cookie for a given memory buffer
- *		associated with the passed private structure or NULL if not
- *		available.
- * @num_users:	return the current number of users of a memory buffer;
- *		return 1 if the videobuf layer (or actually the driver using
- *		it) is the only user.
- * @mmap:	setup a userspace mapping for a given memory buffer under
- *		the provided virtual memory region.
- *
- * Required ops for USERPTR types: get_userptr, put_userptr.
- * Required ops for MMAP types: alloc, put, num_users, mmap.
- * Required ops for read/write access types: alloc, put, num_users, vaddr.
- * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
- *				  unmap_dmabuf.
- */
-struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size,
-				  enum dma_data_direction dma_dir,
-				  gfp_t gfp_flags);
-	void		(*put)(void *buf_priv);
-	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
-
-	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
-					unsigned long size,
-					enum dma_data_direction dma_dir);
-	void		(*put_userptr)(void *buf_priv);
-
-	void		(*prepare)(void *buf_priv);
-	void		(*finish)(void *buf_priv);
-
-	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
-					  unsigned long size,
-					  enum dma_data_direction dma_dir);
-	void		(*detach_dmabuf)(void *buf_priv);
-	int		(*map_dmabuf)(void *buf_priv);
-	void		(*unmap_dmabuf)(void *buf_priv);
-
-	void		*(*vaddr)(void *buf_priv);
-	void		*(*cookie)(void *buf_priv);
-
-	unsigned int	(*num_users)(void *buf_priv);
-
-	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
-};
-
-struct vb2_plane {
-	void			*mem_priv;
-	struct dma_buf		*dbuf;
-	unsigned int		dbuf_mapped;
-};
-
-/**
- * enum vb2_io_modes - queue access methods
- * @VB2_MMAP:		driver supports MMAP with streaming API
- * @VB2_USERPTR:	driver supports USERPTR with streaming API
- * @VB2_READ:		driver supports read() style access
- * @VB2_WRITE:		driver supports write() style access
- * @VB2_DMABUF:		driver supports DMABUF with streaming API
- */
-enum vb2_io_modes {
-	VB2_MMAP	= (1 << 0),
-	VB2_USERPTR	= (1 << 1),
-	VB2_READ	= (1 << 2),
-	VB2_WRITE	= (1 << 3),
-	VB2_DMABUF	= (1 << 4),
-};
-
-/**
- * enum vb2_buffer_state - current video buffer state
- * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
- * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
- * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
- * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
- * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
- *				in a hardware operation
- * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
- *				not yet dequeued to userspace
- * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
- *				has ended with an error, which will be reported
- *				to the userspace when it is dequeued
- */
-enum vb2_buffer_state {
-	VB2_BUF_STATE_DEQUEUED,
-	VB2_BUF_STATE_PREPARING,
-	VB2_BUF_STATE_PREPARED,
-	VB2_BUF_STATE_QUEUED,
-	VB2_BUF_STATE_ACTIVE,
-	VB2_BUF_STATE_DONE,
-	VB2_BUF_STATE_ERROR,
-};
-
-struct vb2_queue;
-
-/**
- * struct vb2_buffer - represents a video buffer
- * @vb2_queue:		the queue to which this driver belongs
- * @num_planes:		number of planes in the buffer
- *			on an internal driver queue
- * @state:		current buffer state; do not change
- * @queued_entry:	entry on the queued buffers list, which holds all
- *			buffers queued from userspace
- * @done_entry:		entry on the list that stores all buffers ready to
- *			be dequeued to userspace
- * @planes:		private per-plane information; do not change
- */
-struct vb2_buffer {
-	struct vb2_queue	*vb2_queue;
-
-	unsigned int		num_planes;
-
-/* Private: internal use only */
-	enum vb2_buffer_state	state;
-
-	struct list_head	queued_entry;
-	struct list_head	done_entry;
-
-	struct vb2_plane	planes[VIDEO_MAX_PLANES];
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	/*
-	 * Counters for how often these buffer-related ops are
-	 * called. Used to check for unbalanced ops.
-	 */
-	u32		cnt_mem_alloc;
-	u32		cnt_mem_put;
-	u32		cnt_mem_get_dmabuf;
-	u32		cnt_mem_get_userptr;
-	u32		cnt_mem_put_userptr;
-	u32		cnt_mem_prepare;
-	u32		cnt_mem_finish;
-	u32		cnt_mem_attach_dmabuf;
-	u32		cnt_mem_detach_dmabuf;
-	u32		cnt_mem_map_dmabuf;
-	u32		cnt_mem_unmap_dmabuf;
-	u32		cnt_mem_vaddr;
-	u32		cnt_mem_cookie;
-	u32		cnt_mem_num_users;
-	u32		cnt_mem_mmap;
-
-	u32		cnt_buf_init;
-	u32		cnt_buf_prepare;
-	u32		cnt_buf_finish;
-	u32		cnt_buf_cleanup;
-	u32		cnt_buf_queue;
-
-	/* This counts the number of calls to vb2_buffer_done() */
-	u32		cnt_buf_done;
-#endif
-};
+#include <media/videobuf2-core.h>
 
 /**
  * struct vb2_v4l2_buffer - represents a video buffer for v4l2
+ * @vb2_buf:		videobuf2
  * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
  *			be read by the driver and relevant entries can be
  *			changed by the driver in case of CAPTURE types
@@ -237,266 +36,34 @@ struct vb2_v4l2_buffer {
 };
 
 /**
- * struct vb2_ops - driver-specific callbacks
- *
- * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
- *			handlers before memory allocation, or, if
- *			*num_planes != 0, after the allocation to verify a
- *			smaller number of buffers. Driver should return
- *			the required number of buffers in *num_buffers, the
- *			required number of planes per buffer in *num_planes; the
- *			size of each plane should be set in the sizes[] array
- *			and optional per-plane allocator specific context in the
- *			alloc_ctxs[] array. When called from VIDIOC_REQBUFS,
- *			fmt == NULL, the driver has to use the currently
- *			configured format and *num_buffers is the total number
- *			of buffers, that are being allocated. When called from
- *			VIDIOC_CREATE_BUFS, fmt != NULL and it describes the
- *			target frame format (if the format isn't valid the
- *			callback must return -EINVAL). In this case *num_buffers
- *			are being allocated additionally to q->num_buffers.
- * @wait_prepare:	release any locks taken while calling vb2 functions;
- *			it is called before an ioctl needs to wait for a new
- *			buffer to arrive; required to avoid a deadlock in
- *			blocking access type.
- * @wait_finish:	reacquire all locks released in the previous callback;
- *			required to continue operation after sleeping while
- *			waiting for a new buffer to arrive.
- * @buf_init:		called once after allocating a buffer (in MMAP case)
- *			or after acquiring a new USERPTR buffer; drivers may
- *			perform additional buffer-related initialization;
- *			initialization failure (return != 0) will prevent
- *			queue setup from completing successfully; optional.
- * @buf_prepare:	called every time the buffer is queued from userspace
- *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
- *			perform any initialization required before each
- *			hardware operation in this callback; drivers can
- *			access/modify the buffer here as it is still synced for
- *			the CPU; drivers that support VIDIOC_CREATE_BUFS must
- *			also validate the buffer size; if an error is returned,
- *			the buffer will not be queued in driver; optional.
- * @buf_finish:		called before every dequeue of the buffer back to
- *			userspace; the buffer is synced for the CPU, so drivers
- *			can access/modify the buffer contents; drivers may
- *			perform any operations required before userspace
- *			accesses the buffer; optional. The buffer state can be
- *			one of the following: DONE and ERROR occur while
- *			streaming is in progress, and the PREPARED state occurs
- *			when the queue has been canceled and all pending
- *			buffers are being returned to their default DEQUEUED
- *			state. Typically you only have to do something if the
- *			state is VB2_BUF_STATE_DONE, since in all other cases
- *			the buffer contents will be ignored anyway.
- * @buf_cleanup:	called once before the buffer is freed; drivers may
- *			perform any additional cleanup; optional.
- * @start_streaming:	called once to enter 'streaming' state; the driver may
- *			receive buffers with @buf_queue callback before
- *			@start_streaming is called; the driver gets the number
- *			of already queued buffers in count parameter; driver
- *			can return an error if hardware fails, in that case all
- *			buffers that have been already given by the @buf_queue
- *			callback are to be returned by the driver by calling
- *			@vb2_buffer_done(VB2_BUF_STATE_QUEUED).
- *			If you need a minimum number of buffers before you can
- *			start streaming, then set @min_buffers_needed in the
- *			vb2_queue structure. If that is non-zero then
- *			start_streaming won't be called until at least that
- *			many buffers have been queued up by userspace.
- * @stop_streaming:	called when 'streaming' state must be disabled; driver
- *			should stop any DMA transactions or wait until they
- *			finish and give back all buffers it got from buf_queue()
- *			callback by calling @vb2_buffer_done() with either
- *			VB2_BUF_STATE_DONE or VB2_BUF_STATE_ERROR; may use
- *			vb2_wait_for_all_buffers() function
- * @buf_queue:		passes buffer vb to the driver; driver may start
- *			hardware operation on this buffer; driver should give
- *			the buffer back by calling vb2_buffer_done() function;
- *			it is allways called after calling STREAMON ioctl;
- *			might be called before start_streaming callback if user
- *			pre-queued buffers before calling STREAMON.
- */
-struct vb2_ops {
-	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[]);
-
-	void (*wait_prepare)(struct vb2_queue *q);
-	void (*wait_finish)(struct vb2_queue *q);
-
-	int (*buf_init)(struct vb2_buffer *vb);
-	int (*buf_prepare)(struct vb2_buffer *vb);
-	void (*buf_finish)(struct vb2_buffer *vb);
-	void (*buf_cleanup)(struct vb2_buffer *vb);
-
-	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
-	void (*stop_streaming)(struct vb2_queue *q);
-
-	void (*buf_queue)(struct vb2_buffer *vb);
-};
-
-struct v4l2_fh;
-
-/**
- * struct vb2_queue - a videobuf queue
- *
- * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
- * @io_modes:	supported io methods (see vb2_io_modes enum)
- * @fileio_read_once:		report EOF after reading the first buffer
- * @fileio_write_immediately:	queue buffer after each write() call
- * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
- * @lock:	pointer to a mutex that protects the vb2_queue struct. The
- *		driver can set this to a mutex to let the vb2 core serialize
- *		the queuing ioctls. If the driver wants to handle locking
- *		itself, then this should be set to NULL. This lock is not used
- *		by the videobuf2 core API.
- * @owner:	The filehandle that 'owns' the buffers, i.e. the filehandle
- *		that called reqbufs, create_buffers or started fileio.
- *		This field is not used by the videobuf2 core API, but it allows
- *		drivers to easily associate an owner filehandle with the queue.
- * @ops:	driver-specific callbacks
- * @mem_ops:	memory allocator specific callbacks
- * @drv_priv:	driver private data
- * @buf_struct_size: size of the driver-specific buffer structure;
- *		"0" indicates the driver doesn't want to use a custom buffer
- *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
- * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
- *		V4L2_BUF_FLAG_TSTAMP_SRC_*
- * @gfp_flags:	additional gfp flags used when allocating the buffers.
- *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
- *		to force the buffer allocation to a specific memory zone.
- * @min_buffers_needed: the minimum number of buffers needed before
- *		start_streaming() can be called. Used when a DMA engine
- *		cannot be started unless at least this number of buffers
- *		have been queued into the driver.
- *
- * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
- * @memory:	current memory type used
- * @bufs:	videobuf buffer structures
- * @num_buffers: number of allocated/used buffers
- * @queued_list: list of buffers currently queued from userspace
- * @queued_count: number of buffers queued and ready for streaming.
- * @owned_by_drv_count: number of buffers owned by the driver
- * @done_list:	list of buffers ready to be dequeued to userspace
- * @done_lock:	lock to protect done_list list
- * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
- * @alloc_ctx:	memory type/allocator-specific contexts for each plane
- * @streaming:	current streaming state
- * @start_streaming_called: start_streaming() was called successfully and we
- *		started streaming.
- * @error:	a fatal error occurred on the queue
- * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
- *		buffers. Only set for capture queues if qbuf has not yet been
- *		called since poll() needs to return POLLERR in that situation.
- * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
- *		last decoded buffer was already dequeued. Set for capture queues
- *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
- * @fileio:	file io emulator internal data, used only if emulator is active
- * @threadio:	thread io internal data, used only if thread is active
- */
-struct vb2_queue {
-	enum v4l2_buf_type		type;
-	unsigned int			io_modes;
-	unsigned			fileio_read_once:1;
-	unsigned			fileio_write_immediately:1;
-	unsigned			allow_zero_bytesused:1;
-
-	struct mutex			*lock;
-	struct v4l2_fh			*owner;
-
-	const struct vb2_ops		*ops;
-	const struct vb2_mem_ops	*mem_ops;
-	void				*drv_priv;
-	unsigned int			buf_struct_size;
-	u32				timestamp_flags;
-	gfp_t				gfp_flags;
-	u32				min_buffers_needed;
-
-/* private: internal use only */
-	struct mutex			mmap_lock;
-	enum v4l2_memory		memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
-	unsigned int			num_buffers;
-
-	struct list_head		queued_list;
-	unsigned int			queued_count;
-
-	atomic_t			owned_by_drv_count;
-	struct list_head		done_list;
-	spinlock_t			done_lock;
-	wait_queue_head_t		done_wq;
-
-	void				*alloc_ctx[VIDEO_MAX_PLANES];
-	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
-
-	unsigned int			streaming:1;
-	unsigned int			start_streaming_called:1;
-	unsigned int			error:1;
-	unsigned int			waiting_for_buffers:1;
-	unsigned int			last_buffer_dequeued:1;
-
-	struct vb2_fileio_data		*fileio;
-	struct vb2_threadio_data	*threadio;
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	/*
-	 * Counters for how often these queue-related ops are
-	 * called. Used to check for unbalanced ops.
-	 */
-	u32				cnt_queue_setup;
-	u32				cnt_wait_prepare;
-	u32				cnt_wait_finish;
-	u32				cnt_start_streaming;
-	u32				cnt_stop_streaming;
-#endif
-};
-
-/**
  * to_vb2_v4l2_buffer() - cast to struct vb2_v4l2_buffer *
  * @vb:		struct vb2_buffer *vb
  */
 #define to_vb2_v4l2_buffer(vb) \
 	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
 
-#define vb2_v4l2_index(vb)						\
+#define vb2_v4l2_index(vb)					\
 ({								\
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);	\
-	int ret = vbuf->v4l2_buf.index;				\
+	unsigned int ret = vbuf->v4l2_buf.index;		\
 	ret;							\
 })
 
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
-void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
-
-void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
-void vb2_discard_done(struct vb2_queue *q);
-int vb2_wait_for_all_buffers(struct vb2_queue *q);
-
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb);
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 int __must_check vb2_queue_init(struct vb2_queue *q);
-
 void vb2_queue_release(struct vb2_queue *q);
-void vb2_queue_error(struct vb2_queue *q);
-
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblock);
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
-int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
-#ifndef CONFIG_MMU
-unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
-				    unsigned long addr,
-				    unsigned long len,
-				    unsigned long pgoff,
-				    unsigned long flags);
-#endif
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
 size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
@@ -533,52 +100,6 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 int vb2_thread_stop(struct vb2_queue *q);
 
 /**
- * vb2_is_streaming() - return streaming status of the queue
- * @q:		videobuf queue
- */
-static inline bool vb2_is_streaming(struct vb2_queue *q)
-{
-	return q->streaming;
-}
-
-/**
- * vb2_fileio_is_active() - return true if fileio is active.
- * @q:		videobuf queue
- *
- * This returns true if read() or write() is used to stream the data
- * as opposed to stream I/O. This is almost never an important distinction,
- * except in rare cases. One such case is that using read() or write() to
- * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
- * is no way you can pass the field information of each buffer to/from
- * userspace. A driver that supports this field format should check for
- * this in the queue_setup op and reject it if this function returns true.
- */
-static inline bool vb2_fileio_is_active(struct vb2_queue *q)
-{
-	return q->fileio;
-}
-
-/**
- * vb2_is_busy() - return busy status of the queue
- * @q:		videobuf queue
- *
- * This function checks if queue has any buffers allocated.
- */
-static inline bool vb2_is_busy(struct vb2_queue *q)
-{
-	return (q->num_buffers > 0);
-}
-
-/**
- * vb2_get_drv_priv() - return driver private data associated with the queue
- * @q:		videobuf queue
- */
-static inline void *vb2_get_drv_priv(struct vb2_queue *q)
-{
-	return q->drv_priv;
-}
-
-/**
  * vb2_set_plane_payload() - set bytesused for the plane plane_no
  * @vb:		buffer for which plane payload should be set
  * @plane_no:	plane number for which payload should be set
@@ -624,24 +145,6 @@ vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 	return 0;
 }
 
-/**
- * vb2_start_streaming_called() - return streaming status of driver
- * @q:		videobuf queue
- */
-static inline bool vb2_start_streaming_called(struct vb2_queue *q)
-{
-	return q->start_streaming_called;
-}
-
-/**
- * vb2_clear_last_buffer_dequeued() - clear last buffer dequeued flag of queue
- * @q:		videobuf queue
- */
-static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
-{
-	q->last_buffer_dequeued = false;
-}
-
 /*
  * The following functions are not part of the vb2 core API, but are simple
  * helper functions that you can use in your struct v4l2_file_operations,
diff --git a/include/media/videobuf2-vmalloc.h b/include/media/videobuf2-vmalloc.h
index a63fe66..93a76b4 100644
--- a/include/media/videobuf2-vmalloc.h
+++ b/include/media/videobuf2-vmalloc.h
@@ -13,7 +13,7 @@
 #ifndef _MEDIA_VIDEOBUF2_VMALLOC_H
 #define _MEDIA_VIDEOBUF2_VMALLOC_H
 
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 
 extern const struct vb2_mem_ops vb2_vmalloc_memops;
 
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index dabd780..0ae549f 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -203,7 +203,8 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 
 	TP_fast_assign(
 		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-		__entry->minor = q->owner ? q->owner->vdev->minor : -1;
+		struct v4l2_fh *owner = (struct v4l2_fh *)q->owner;
+		__entry->minor = owner ? owner->vdev->minor : -1;
 		__entry->queued_count = q->queued_count;
 		__entry->owned_by_drv_count =
 			atomic_read(&q->owned_by_drv_count);
-- 
1.7.9.5


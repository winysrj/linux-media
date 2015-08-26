Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:55113 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbbHZL7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 07:59:42 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NTO01TLHUNBELB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Aug 2015 20:59:35 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	jh1009.sung@samsung.com, rany.kwon@samsung.com
Subject: [RFC PATCH v3 4/5] media: videobuf2: Change queue_setup argument
Date: Wed, 26 Aug 2015 20:59:31 +0900
Message-id: <1440590372-2377-5-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace struct v4l2_format * with void * to make queue_setup()
for common use.
And then, modify all device drivers related with this change.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |    3 ++-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    3 ++-
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    3 ++-
 drivers/media/pci/cx88/cx88-blackbird.c            |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |    2 +-
 drivers/media/pci/cx88/cx88-video.c                |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |    3 ++-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/saa7134/saa7134.h                |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/tw68/tw68-video.c                |    3 ++-
 drivers/media/platform/am437x/am437x-vpfe.c        |    3 ++-
 drivers/media/platform/blackfin/bfin_capture.c     |    3 ++-
 drivers/media/platform/coda/coda-common.c          |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |    3 ++-
 drivers/media/platform/davinci/vpif_capture.c      |    3 ++-
 drivers/media/platform/davinci/vpif_display.c      |    3 ++-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    3 ++-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    3 ++-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    3 ++-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    3 ++-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    2 +-
 drivers/media/platform/rcar_jpu.c                  |    3 ++-
 drivers/media/platform/s3c-camif/camif-capture.c   |    3 ++-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    2 +-
 drivers/media/platform/sh_veu.c                    |    3 ++-
 drivers/media/platform/sh_vou.c                    |    3 ++-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    3 ++-
 drivers/media/platform/soc_camera/mx3_camera.c     |    3 ++-
 drivers/media/platform/soc_camera/rcar_vin.c       |    3 ++-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    6 ++++--
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    3 ++-
 drivers/media/platform/ti-vpe/vpe.c                |    2 +-
 drivers/media/platform/vim2m.c                     |    3 ++-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    3 ++-
 drivers/media/platform/vivid/vivid-vid-out.c       |    3 ++-
 drivers/media/platform/vsp1/vsp1_video.c           |    3 ++-
 drivers/media/platform/xilinx/xilinx-dma.c         |    3 ++-
 drivers/media/usb/airspy/airspy.c                  |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    3 ++-
 drivers/media/usb/au0828/au0828-video.c            |    3 ++-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    3 ++-
 drivers/media/usb/em28xx/em28xx-video.c            |    3 ++-
 drivers/media/usb/go7007/go7007-v4l2.c             |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |    2 +-
 drivers/media/usb/msi2500/msi2500.c                |    2 +-
 drivers/media/usb/pwc/pwc-if.c                     |    2 +-
 drivers/media/usb/s2255/s2255drv.c                 |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    3 ++-
 drivers/media/usb/uvc/uvc_queue.c                  |    3 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
 drivers/staging/media/omap4iss/iss_video.c         |    2 +-
 drivers/usb/gadget/function/uvc_queue.c            |    2 +-
 include/media/videobuf2-core.h                     |    2 +-
 78 files changed, 114 insertions(+), 79 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 8d0b6f0..767ddc8 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -643,10 +643,11 @@ static void sur40_disconnect(struct usb_interface *interface)
  * minimum number: many DMA engines need a minimum of 2 buffers in the
  * queue and you need to have another available for userspace processing.
  */
-static int sur40_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int sur40_queue_setup(struct vb2_queue *q, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct sur40_state *sur40 = vb2_get_drv_priv(q);
 
 	if (q->num_buffers + *nbuffers < 3)
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 3501215..7d884c5 100644
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
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index e72480a..0c083b3 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -44,10 +44,11 @@ static const struct v4l2_dv_timings cea1080p60 = V4L2_DV_BT_CEA_1920X1080P60;
 /* vb2 DMA streaming ops */
 
 static int cobalt_queue_setup(struct vb2_queue *q,
-			const struct v4l2_format *fmt,
+			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct cobalt_stream *s = q->drv_priv;
 	unsigned size = s->stride * s->height;
 
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
index 6c9bb03..cf3cb13 100644
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
index b6a193d..71a80e2 100644
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
index f1deb8f..69ee134 100644
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
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 1d65543..007a5ee 100644
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
index c6a337a..f3b12db 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -429,7 +429,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index f27a858..d041526 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -131,11 +131,12 @@ static int wait_i2c_reg(void __iomem *addr)
 }
 
 static int
-dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+dt3155_queue_setup(struct vb2_queue *vq, const void *parg,
 		unsigned int *nbuffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
 	unsigned size = pd->width * pd->height;
 
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index b012aa65..f0d5a40 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -279,7 +279,7 @@ static irqreturn_t netup_unidvb_isr(int irq, void *dev_id)
 }
 
 static int netup_unidvb_queue_setup(struct vb2_queue *vq,
-				    const struct v4l2_format *fmt,
+				    const void *parg,
 				    unsigned int *nbuffers,
 				    unsigned int *nplanes,
 				    unsigned int sizes[],
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index b0ef37d..7fb5ee7 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -116,7 +116,7 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
-int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index fb1605e..6271b0e 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -138,7 +138,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 602d53d..518086c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -904,7 +904,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 002ba1d8..984e81d 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -819,7 +819,7 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
-int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
 int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index fb71f2f..b79fc6f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -659,7 +659,7 @@ static int solo_ring_thread(void *data)
 }
 
 static int solo_enc_queue_setup(struct vb2_queue *q,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *num_buffers,
 				unsigned int *num_planes, unsigned int sizes[],
 				void *alloc_ctxs[])
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 63ae8a6..d2c9a83 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -311,7 +311,7 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 	solo_dev->kthread = NULL;
 }
 
-static int solo_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int solo_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 8fe6ea6..7a8e4b4 100644
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
index ae06535..85ad311 100644
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
 
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 85649ca..5ef5a1e 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1907,10 +1907,11 @@ static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
  * the buffer count and buffer size
  */
 static int vpfe_queue_setup(struct vb2_queue *vq,
-			    const struct v4l2_format *fmt,
+			    const void *parg,
 			    unsigned int *nbuffers, unsigned int *nplanes,
 			    unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
 
 	if (fmt && fmt->fmt.pix.sizeimage < vpfe->fmt.fmt.pix.sizeimage)
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 4bb3208..2dc2351 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -202,10 +202,11 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 }
 
 static int bcap_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 
 	if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6e0c9be..be63ab9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1132,7 +1132,7 @@ static void set_default_params(struct coda_ctx *ctx)
  * Queue operations
  */
 static int coda_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index f69cdd7..5798247 100644
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
index d7ddc7d..f8a7338 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -112,10 +112,11 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index f641bc0..5df9b1e 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -107,10 +107,11 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d5cffef..d967f17 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -212,7 +212,7 @@ put_device:
 }
 
 static int gsc_m2m_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 3844d6c..fd545a0 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -344,10 +344,11 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
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
index 195f9b5..4b583ed 100644
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
index 21527cf..fdb4fcf 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -360,10 +360,11 @@ static void stop_streaming(struct vb2_queue *q)
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
index 9c27335..bd72ab3 100644
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
index bdd8f11..29973f9 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -798,7 +798,7 @@ struct vb2_dc_conf {
 };
 
 static int deinterlace_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 1d95842..fb9615b 100644
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
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 87314b7..0a4c336 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -689,7 +689,7 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
  * Queue operations
  */
 static int emmaprp_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 08c9f62..3aa61e8 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -320,7 +320,7 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
  */
 
 static int isp_video_queue_setup(struct vb2_queue *queue,
-				 const struct v4l2_format *fmt,
+				 const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 18e62d0..935eadb 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1015,10 +1015,11 @@ error_free:
  * ============================================================================
  */
 static int jpu_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
 	struct jpu_q_data *q_data;
 	unsigned int i;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index dc67c4ec..8573922 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -441,10 +441,11 @@ static void stop_streaming(struct vb2_queue *vq)
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
index 81483da..b11497f 100644
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
index 5b1861b..b89976e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2120,7 +2120,7 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
  */
 
 static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 2fd59e7..8443cb3 100644
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
index e42014c..c94f6d2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1812,7 +1812,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 }
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const void *parg,
 			unsigned int *buf_count, unsigned int *plane_count,
 			unsigned int psize[], void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 5347a6c..6117045 100644
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
index 6455cb9..461099e 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -865,10 +865,11 @@ static const struct v4l2_ioctl_ops sh_veu_ioctl_ops = {
 		/* ========== Queue operations ========== */
 
 static int sh_veu_queue_setup(struct vb2_queue *vq,
-			      const struct v4l2_format *f,
+			      const void *parg,
 			      unsigned int *nbuffers, unsigned int *nplanes,
 			      unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *f = (struct v4l2_format *)parg;
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vq);
 	struct sh_veu_vfmt *vfmt;
 	unsigned int size, count = *nbuffers;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 7014f2e..e624ada 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -241,10 +241,11 @@ static void sh_vou_stream_config(struct sh_vou_device *vou_dev)
 }
 
 /* Locking: caller holds fop_lock mutex */
-static int sh_vou_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int sh_vou_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	int bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 6b312a4..f604114 100644
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
index f4398bb..e07e1ec 100644
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
index dcd7dc1..16ad897 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -185,10 +185,11 @@ static void mx3_cam_dma_done(void *arg)
  * Calculate the __buffer__ (not data) size and number of buffers.
  */
 static int mx3_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index cd45fa9..b983361 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -527,11 +527,12 @@ struct rcar_vin_cam {
  * required
  */
 static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
-				   const struct v4l2_format *fmt,
+				   const void *parg,
 				   unsigned int *count,
 				   unsigned int *num_planes,
 				   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 161b614..ac68c55 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -210,11 +210,13 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  *		  for the current frame format if required
  */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
+	struct soc_camera_device *icd = container_of(vq,
+			struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index df61355..5bb3354 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -438,10 +438,11 @@ static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
 }
 
 static int bdisp_queue_setup(struct vb2_queue *vq,
-			     const struct v4l2_format *fmt,
+			     const void *parg,
 			     unsigned int *nb_buf, unsigned int *nb_planes,
 			     unsigned int sizes[], void *allocators[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
 	struct bdisp_frame *frame = ctx_get_frame(ctx, vq->type);
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d82c2f2..22f820c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1798,7 +1798,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
  * Queue operations
  */
 static int vpe_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 295fde5..fad0ac9 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -710,10 +710,11 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
  */
 
 static int vim2m_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vq);
 	struct vim2m_q_data *q_data;
 	unsigned int size, count = *nbuffers;
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index bae5b8a..a5ff809 100644
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
index 73e9c0b..83aee19 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -135,7 +135,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
-static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 1333f96..055cef6 100644
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
index 4572709..79fc026 100644
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
index 73c8f97..fe9a72d 100644
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
index 5837bc1..a1d8892 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -787,10 +787,11 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
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
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 3b6112e..bd9c29b 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -309,10 +309,11 @@ static void xvip_dma_complete(void *param)
 }
 
 static int
-xvip_dma_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+xvip_dma_queue_setup(struct vb2_queue *vq, const void *parg,
 		     unsigned int *nbuffers, unsigned int *nplanes,
 		     unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct xvip_dma *dma = vb2_get_drv_priv(vq);
 
 	/* Make sure the image size is large enough. */
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index bc45104..e346619 100644
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
index 44d1d46..d4ae272 100644
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
index 065b9c8..6b6e772 100644
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
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index a4d7f41..db76cf1 100644
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
index 5b6fdd2..a7f034c 100644
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
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 63d87a2..f3d187d 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -369,7 +369,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int go7007_queue_setup(struct vb2_queue *q,
-		const struct v4l2_format *fmt,
+		const void *parg,
 		unsigned int *num_buffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e932f0b..458514d 100644
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
index 6ba87d0..9345a84 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -614,7 +614,7 @@ static int msi2500_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int msi2500_queue_setup(struct vb2_queue *vq,
-			       const struct v4l2_format *fmt,
+			       const void *parg,
 			       unsigned int *nbuffers,
 			       unsigned int *nplanes, unsigned int sizes[],
 			       void *alloc_ctxs[])
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index a33ce99..30d0957 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -571,7 +571,7 @@ static void pwc_video_release(struct v4l2_device *v)
 /***************************************************************************/
 /* Videobuf2 operations */
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 32b5115..e7acb12 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -660,7 +660,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
    Videobuf operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 10e35e6..0bd34f1 100644
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
index ce5d502..9116289 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -599,9 +599,10 @@ static struct v4l2_file_operations usbtv_fops = {
 };
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
-	const struct v4l2_format *fmt, unsigned int *nbuffers,
+	const void *parg, unsigned int *nbuffers,
 	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct v4l2_format *fmt = (struct v4l2_format *)parg;
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
 	unsigned size = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
 
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index b49bcab..bccb2da 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -69,10 +69,11 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
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
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 87048a1..c7de69b 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1078,7 +1078,7 @@ vpfe_g_dv_timings(struct file *file, void *fh,
  * the buffer nbuffers and buffer size
  */
 static int
-vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+vpfe_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *nbuffers, unsigned int *nplanes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 40405d8..1cb307a 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -288,7 +288,7 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
  */
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
-				 const struct v4l2_format *fmt,
+				 const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 3628938..51d4a17 100644
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
index 8787a6c..09d7529 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -312,7 +312,7 @@ struct vb2_buffer {
  *			pre-queued buffers before calling STREAMON.
  */
 struct vb2_ops {
-	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
+	int (*queue_setup)(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
 
-- 
1.7.9.5


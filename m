Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34967 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428AbbIVNa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 09:30:58 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NV202OJXYV4M760@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Sep 2015 22:30:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v5 5/8] media: videobuf2: Change queue_setup argument
Date: Tue, 22 Sep 2015 22:30:33 +0900
Message-id: <1442928636-3589-6-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace struct v4l2_format * with vb2_format * to make queue_setup()
for common use.

struct vb2_format {
	unsigned int	type;
	unsigned int	pixelformat;
	unsigned int	width;
	unsigned int	height;
	unsigned int	num_planes;
	unsigned int	bytesperline[VIDEO_MAX_PLANES];
	unsigned int	req_sizes[VIDEO_MAX_PLANES];
};

And then, modify all device drivers related with this change.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |   11 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    6 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   11 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |    2 +-
 drivers/media/pci/cx88/cx88-video.c                |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |    6 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/saa7134/saa7134.h                |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    7 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/tw68/tw68-video.c                |    9 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |    6 +-
 drivers/media/platform/coda/coda-common.c          |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |    6 +-
 drivers/media/platform/davinci/vpif_capture.c      |    6 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   12 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   12 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   12 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    6 +-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    2 +-
 drivers/media/platform/rcar_jpu.c                  |    5 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   12 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    7 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    2 +-
 drivers/media/platform/sh_veu.c                    |   51 +++++++--
 drivers/media/platform/sh_vou.c                    |   11 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   14 +--
 drivers/media/platform/soc_camera/rcar_vin.c       |   14 +--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   14 +--
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    6 +-
 drivers/media/platform/ti-vpe/vpe.c                |    2 +-
 drivers/media/platform/vim2m.c                     |    6 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    7 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    7 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   20 ++--
 drivers/media/platform/vivid/vivid-vid-out.c       |   21 ++--
 drivers/media/platform/vsp1/vsp1_video.c           |  115 +++++++++++++++++---
 drivers/media/platform/xilinx/xilinx-dma.c         |    6 +-
 drivers/media/usb/airspy/airspy.c                  |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |   10 +-
 drivers/media/usb/au0828/au0828-video.c            |    4 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    9 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    4 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |    2 +-
 drivers/media/usb/msi2500/msi2500.c                |    2 +-
 drivers/media/usb/pwc/pwc-if.c                     |    2 +-
 drivers/media/usb/s2255/s2255drv.c                 |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    6 +-
 drivers/media/usb/uvc/uvc_queue.c                  |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   58 +++++++++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    3 +-
 drivers/staging/media/omap4iss/iss_video.c         |    2 +-
 drivers/usb/gadget/function/uvc_queue.c            |    2 +-
 include/media/videobuf2-core.h                     |   30 ++++-
 77 files changed, 403 insertions(+), 231 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 98d0945..c2a8b83 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -644,20 +644,21 @@ static void sur40_disconnect(struct usb_interface *interface)
  * minimum number: many DMA engines need a minimum of 2 buffers in the
  * queue and you need to have another available for userspace processing.
  */
-static int sur40_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
-		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+static int sur40_queue_setup(struct vb2_queue *q,
+			const struct vb2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct sur40_state *sur40 = vb2_get_drv_priv(q);
 
 	if (q->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - q->num_buffers;
 
-	if (fmt && fmt->fmt.pix.sizeimage < sur40_video_format.sizeimage)
+	if (fmt && fmt->req_sizes[0] < sur40_video_format.sizeimage)
 		return -EINVAL;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : sur40_video_format.sizeimage;
+	sizes[0] = fmt ? fmt->req_sizes[0] : sur40_video_format.sizeimage;
 	alloc_ctxs[0] = sur40->alloc_ctx;
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index bf306a2..486fe98 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -490,7 +490,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		const struct vb2_format *fmt, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 7d331a4..d0241b5 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -44,7 +44,7 @@ static const struct v4l2_dv_timings cea1080p60 = V4L2_DV_BT_CEA_1920X1080P60;
 /* vb2 DMA streaming ops */
 
 static int cobalt_queue_setup(struct vb2_queue *q,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -57,9 +57,9 @@ static int cobalt_queue_setup(struct vb2_queue *q,
 		*num_buffers = NR_BUFS;
 	*num_planes = 1;
 	if (fmt) {
-		if (fmt->fmt.pix.sizeimage < size)
+		if (fmt->req_sizes[0] < size)
 			return -EINVAL;
-		size = fmt->fmt.pix.sizeimage;
+		size = fmt->req_sizes[0];
 	}
 	sizes[0] = size;
 	alloc_ctxs[0] = s->cobalt->alloc_ctx;
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 316a322..f3cdd8c 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1138,7 +1138,7 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 09ad512..c83581b 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -92,7 +92,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 6c9bb03..a4ef1c2 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -121,7 +121,7 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index b6a193d..d3f2d14 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -315,7 +315,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 	return 0;
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index f1deb8f..5cade48 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -141,18 +141,19 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	return handled;
 }
 
-static int cx25821_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+static int cx25821_queue_setup(struct vb2_queue *q,
+			const struct vb2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct cx25821_channel *chan = q->drv_priv;
 	unsigned size = (chan->fmt->depth * chan->width * chan->height) >> 3;
 
-	if (fmt && fmt->fmt.pix.sizeimage < size)
+	if (fmt && fmt->req_sizes[0] < size)
 		return -EINVAL;
 
 	*num_planes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
+	sizes[0] = fmt ? fmt->req_sizes[0] : size;
 	alloc_ctxs[0] = chan->dev->alloc_ctx;
 	return 0;
 }
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 49d0b7c..1be9bf2 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -637,7 +637,7 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index f0923fb..1c4314d 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -82,7 +82,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 1d65543..a1889d0 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -107,7 +107,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index c6a337a..902495c 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -429,7 +429,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index f27a858..585da3d 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -131,7 +131,7 @@ static int wait_i2c_reg(void __iomem *addr)
 }
 
 static int
-dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+dt3155_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		unsigned int *nbuffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 
@@ -141,10 +141,10 @@ dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
-	if (fmt && fmt->fmt.pix.sizeimage < size)
+	if (fmt && fmt->req_sizes[0] < size)
 		return -EINVAL;
 	*num_planes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
+	sizes[0] = fmt ? fmt->req_sizes[0] : size;
 	alloc_ctxs[0] = pd->alloc_ctx;
 	return 0;
 }
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index b012aa65..af28bc6 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -279,7 +279,7 @@ static irqreturn_t netup_unidvb_isr(int irq, void *dev_id)
 }
 
 static int netup_unidvb_queue_setup(struct vb2_queue *vq,
-				    const struct v4l2_format *fmt,
+				    const struct vb2_format *fmt,
 				    unsigned int *nbuffers,
 				    unsigned int *nplanes,
 				    unsigned int sizes[],
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index b0ef37d..4dc4292c 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -116,7 +116,7 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
-int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+int saa7134_ts_queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index fb1605e..668beb6 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -138,7 +138,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 602d53d..c3a2c3f 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -904,7 +904,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 002ba1d8..4674f13 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -819,7 +819,7 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
-int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+int saa7134_ts_queue_setup(struct vb2_queue *q, const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
 int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 78ac3fe..bb420b0 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -663,7 +663,7 @@ static int solo_ring_thread(void *data)
 }
 
 static int solo_enc_queue_setup(struct vb2_queue *q,
-				const struct v4l2_format *fmt,
+				const struct vb2_format *fmt,
 				unsigned int *num_buffers,
 				unsigned int *num_planes, unsigned int sizes[],
 				void *alloc_ctxs[])
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 57d0d9c..083b7df 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -313,9 +313,10 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 	solo_dev->kthread = NULL;
 }
 
-static int solo_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+static int solo_queue_setup(struct vb2_queue *q,
+			const struct vb2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 8fe6ea6..cca487b 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -265,7 +265,7 @@ static void vip_active_buf_next(struct sta2x11_vip *vip)
 
 
 /* Videobuf2 Operations */
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 3237214..afd44f0 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -376,9 +376,10 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
 /* ------------------------------------------------------------- */
 /* vb2 queue operations                                          */
 
-static int tw68_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+static int tw68_queue_setup(struct vb2_queue *q,
+			const struct vb2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct tw68_dev *dev = vb2_get_drv_priv(q);
 	unsigned tot_bufs = q->num_buffers + *num_buffers;
@@ -390,7 +391,7 @@ static int tw68_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	 * current sizeimage. The tw68_buffer_count calculation becomes quite
 	 * difficult otherwise.
 	 */
-	if (fmt && fmt->fmt.pix.sizeimage < sizes[0])
+	if (fmt && fmt->req_sizes[0] < sizes[0])
 		return -EINVAL;
 	*num_planes = 1;
 	if (tot_bufs < 2)
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 488d275..fe40e98 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1908,20 +1908,20 @@ static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
  * the buffer count and buffer size
  */
 static int vpfe_queue_setup(struct vb2_queue *vq,
-			    const struct v4l2_format *fmt,
+			    const struct vb2_format *fmt,
 			    unsigned int *nbuffers, unsigned int *nplanes,
 			    unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
 
-	if (fmt && fmt->fmt.pix.sizeimage < vpfe->fmt.fmt.pix.sizeimage)
+	if (fmt && fmt->req_sizes[0] < vpfe->fmt.fmt.pix.sizeimage)
 		return -EINVAL;
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : vpfe->fmt.fmt.pix.sizeimage;
+	sizes[0] = fmt ? fmt->req_sizes[0] : vpfe->fmt.fmt.pix.sizeimage;
 	alloc_ctxs[0] = vpfe->alloc_ctx;
 
 	vpfe_dbg(1, vpfe,
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 60336ee..c5da588 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1132,7 +1132,7 @@ static void set_default_params(struct coda_ctx *ctx)
  * Queue operations
  */
 static int coda_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 39f8ccf..523e344 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -228,7 +228,7 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
  * This function allocates memory for the buffers
  */
 static int
-vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 			unsigned int *nbuffers, unsigned int *nplanes,
 			unsigned int sizes[], void *alloc_ctxs[])
 
@@ -239,7 +239,7 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_buffer_setup\n");
 
-	if (fmt && fmt->fmt.pix.sizeimage < layer->pix_fmt.sizeimage)
+	if (info && info->req_sizes[0] < layer->pix_fmt.sizeimage)
 		return -EINVAL;
 
 	/* Store number of buffers allocated in numbuffer member */
@@ -247,7 +247,7 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		*nbuffers = VPBE_DEFAULT_NUM_BUFS - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : layer->pix_fmt.sizeimage;
+	sizes[0] = info ? info->req_sizes[0] : layer->pix_fmt.sizeimage;
 	alloc_ctxs[0] = layer->alloc_ctx;
 
 	return 0;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b29bb64..68105f8 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -114,7 +114,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -125,14 +125,14 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 
 	vpif_dbg(2, debug, "vpif_buffer_setup\n");
 
-	if (fmt && fmt->fmt.pix.sizeimage < common->fmt.fmt.pix.sizeimage)
+	if (fmt && fmt->req_sizes[0] < common->fmt.fmt.pix.sizeimage)
 		return -EINVAL;
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;
+	sizes[0] = fmt ? fmt->req_sizes[0] : common->fmt.fmt.pix.sizeimage;
 	alloc_ctxs[0] = common->alloc_ctx;
 
 	/* Calculate the offset for Y and C data in the buffer */
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 59d134d..8bb1050 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -212,7 +212,7 @@ put_device:
 }
 
 static int gsc_m2m_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 84b9817..11c20ba 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -344,11 +344,10 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *pfmt,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_ctx *ctx = vq->drv_priv;
 	struct fimc_frame *frame = &ctx->d_frame;
 	struct fimc_fmt *fmt = frame->fmt;
@@ -356,10 +355,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	int i;
 
 	if (pfmt) {
-		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_find_format(&pixm->pixelformat, NULL,
+		fmt = fimc_find_format(&pfmt->pixelformat, NULL,
 				       FMT_FLAGS_CAM | FMT_FLAGS_M2M, -1);
-		wh = pixm->width * pixm->height;
+		wh = pfmt->width * pfmt->height;
 	} else {
 		wh = frame->f_width * frame->f_height;
 	}
@@ -371,8 +369,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 
 	for (i = 0; i < fmt->memplanes; i++) {
 		unsigned int size = (wh * fmt->depth[i]) / 8;
-		if (pixm)
-			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		if (pfmt)
+			sizes[i] = max(size, pfmt->req_sizes[i]);
 		else if (fimc_fmt_is_user_defined(fmt->color))
 			sizes[i] = frame->payload[i];
 		else
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index bacc3a3..9ff17d6 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -39,20 +39,18 @@
 #include "fimc-is-param.h"
 
 static int isp_video_capture_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *pfmt,
+			const struct vb2_format *pfmt,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
 	struct fimc_isp *isp = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format_mplane *vid_fmt = &isp->video_capture.pixfmt;
-	const struct v4l2_pix_format_mplane *pixm = NULL;
 	const struct fimc_fmt *fmt;
 	unsigned int wh, i;
 
 	if (pfmt) {
-		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, -1);
-		wh = pixm->width * pixm->height;
+		fmt = fimc_isp_find_format(&pfmt->pixelformat, NULL, -1);
+		wh = pfmt->width * pfmt->height;
 	} else {
 		fmt = isp->video_capture.format;
 		wh = vid_fmt->width * vid_fmt->height;
@@ -67,8 +65,8 @@ static int isp_video_capture_queue_setup(struct vb2_queue *vq,
 
 	for (i = 0; i < fmt->memplanes; i++) {
 		unsigned int size = (wh * fmt->depth[i]) / 8;
-		if (pixm)
-			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		if (pfmt)
+			sizes[i] = max(size, pfmt->req_sizes[i]);
 		else
 			sizes[i] = size;
 		allocators[i] = isp->alloc_ctx;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 04c245b..6cc01da 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -360,11 +360,10 @@ static void stop_streaming(struct vb2_queue *q)
 	fimc_lite_stop_capture(fimc, false);
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *pfmt,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_lite *fimc = vq->drv_priv;
 	struct flite_frame *frame = &fimc->out_frame;
 	const struct fimc_fmt *fmt = frame->fmt;
@@ -372,9 +371,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	int i;
 
 	if (pfmt) {
-		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, 0, -1);
-		wh = pixm->width * pixm->height;
+		fmt = fimc_lite_find_format(&pfmt->pixelformat, NULL, 0, -1);
+		wh = pfmt->width * pfmt->height;
 	} else {
 		wh = frame->f_width * frame->f_height;
 	}
@@ -386,8 +384,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 
 	for (i = 0; i < fmt->memplanes; i++) {
 		unsigned int size = (wh * fmt->depth[i]) / 8;
-		if (pixm)
-			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		if (pfmt)
+			sizes[i] = max(size, pfmt->req_sizes[i]);
 		else
 			sizes[i] = size;
 		allocators[i] = fimc->alloc_ctx;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 79b8a3b..85479d6 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -176,7 +176,7 @@ static void fimc_job_abort(void *priv)
 	fimc_m2m_shutdown(priv);
 }
 
-static int fimc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int fimc_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 			    unsigned int *num_buffers, unsigned int *num_planes,
 			    unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index bdd8f11..63f71c8 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -798,7 +798,7 @@ struct vb2_dc_conf {
 };
 
 static int deinterlace_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 1d95842..4df9b5b 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1049,16 +1049,16 @@ static int mcam_read_setup(struct mcam_camera *cam)
  */
 
 static int mcam_vb_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbufs,
+		const struct vb2_format *fmt, unsigned int *nbufs,
 		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
-	if (fmt && fmt->fmt.pix.sizeimage < cam->pix_format.sizeimage)
+	if (fmt && fmt->req_sizes[0] < cam->pix_format.sizeimage)
 		return -EINVAL;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : cam->pix_format.sizeimage;
+	sizes[0] = fmt ? fmt->req_sizes[0] : cam->pix_format.sizeimage;
 	*num_planes = 1; /* Someday we have to support planar formats... */
 	if (*nbufs < minbufs)
 		*nbufs = minbufs;
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index b7cea27..d92f6cd 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -689,7 +689,7 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
  * Queue operations
  */
 static int emmaprp_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 786cc85..a4c7e12 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -320,7 +320,7 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
  */
 
 static int isp_video_queue_setup(struct vb2_queue *queue,
-				 const struct v4l2_format *fmt,
+				 const struct vb2_format *fmt,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 7533b9e..aff40dc 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1015,7 +1015,7 @@ error_free:
  * ============================================================================
  */
 static int jpu_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+			   const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -1029,8 +1029,7 @@ static int jpu_queue_setup(struct vb2_queue *vq,
 
 	for (i = 0; i < *nplanes; i++) {
 		unsigned int q_size = q_data->format.plane_fmt[i].sizeimage;
-		unsigned int f_size = fmt ?
-			fmt->fmt.pix_mp.plane_fmt[i].sizeimage : 0;
+		unsigned int f_size = fmt ? fmt->req_sizes[i] : 0;
 
 		if (fmt && f_size < q_size)
 			return -EINVAL;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 9df34c7..05a36ce 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -441,11 +441,10 @@ static void stop_streaming(struct vb2_queue *vq)
 	camif_stop_capture(vp);
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *pfmt,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_pix_format *pix = NULL;
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
 	struct camif_dev *camif = vp->camif;
 	struct camif_frame *frame = &vp->out_frame;
@@ -453,11 +452,10 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	unsigned int size;
 
 	if (pfmt) {
-		pix = &pfmt->fmt.pix;
-		fmt = s3c_camif_find_format(vp, &pix->pixelformat, -1);
+		fmt = s3c_camif_find_format(vp, &pfmt->pixelformat, -1);
 		if (fmt == NULL)
 			return -EINVAL;
-		size = (pix->width * pix->height * fmt->depth) / 8;
+		size = (pfmt->width * pfmt->height * fmt->depth) / 8;
 	} else {
 		fmt = vp->out_fmt;
 		if (fmt == NULL)
@@ -467,8 +465,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 
 	*num_planes = 1;
 
-	if (pix)
-		sizes[0] = max(size, pix->sizeimage);
+	if (pfmt)
+		sizes[0] = max(size, pfmt->req_sizes[0]);
 	else
 		sizes[0] = size;
 	allocators[0] = camif->alloc_ctx;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 4db507a..4e652d9 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -101,9 +101,10 @@ static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
 	}
 }
 
-static int g2d_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+static int g2d_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct g2d_ctx *ctx = vb2_get_drv_priv(vq);
 	struct g2d_frame *f = get_frame(ctx, vq->type);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d742457..ada177a 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2120,7 +2120,7 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
  */
 
 static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+			   const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 1734775..ae94ed6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -883,7 +883,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 };
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt, unsigned int *buf_count,
+			const struct vb2_format *fmt, unsigned int *buf_count,
 			unsigned int *plane_count, unsigned int psize[],
 			void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 94868f7..e10e7a5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1817,7 +1817,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 }
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned int *buf_count, unsigned int *plane_count,
 			unsigned int psize[], void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index dba92b5..4fe3828 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -881,7 +881,7 @@ static const struct v4l2_file_operations mxr_fops = {
 	.unlocked_ioctl = video_ioctl2,
 };
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *pfmt,
 	unsigned int *nbuffers, unsigned int *nplanes, unsigned int sizes[],
 	void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 6455cb9..839e97a 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -490,6 +490,35 @@ static const struct sh_veu_format *sh_veu_find_fmt(const struct v4l2_format *f)
 	return &sh_veu_fmt[dflt];
 }
 
+static
+const struct sh_veu_format *sh_veu_find_fmt_vb2(const struct vb2_format *f)
+{
+	const int *fmt;
+	int i, n, dflt;
+
+	pr_debug("%s(%d)\n", __func__, f->type);
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		fmt = sh_veu_fmt_out;
+		n = ARRAY_SIZE(sh_veu_fmt_out);
+		dflt = DEFAULT_OUT_FMTIDX;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+	default:
+		fmt = sh_veu_fmt_in;
+		n = ARRAY_SIZE(sh_veu_fmt_in);
+		dflt = DEFAULT_IN_FMTIDX;
+		break;
+	}
+
+	for (i = 0; i < n; i++)
+		if (sh_veu_fmt[fmt[i]].fourcc == f->pixelformat)
+			return &sh_veu_fmt[fmt[i]];
+
+	return &sh_veu_fmt[dflt];
+}
+
 static int sh_veu_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
@@ -865,7 +894,7 @@ static const struct v4l2_ioctl_ops sh_veu_ioctl_ops = {
 		/* ========== Queue operations ========== */
 
 static int sh_veu_queue_setup(struct vb2_queue *vq,
-			      const struct v4l2_format *f,
+			      const struct vb2_format *f,
 			      unsigned int *nbuffers, unsigned int *nplanes,
 			      unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -874,18 +903,20 @@ static int sh_veu_queue_setup(struct vb2_queue *vq,
 	unsigned int size, count = *nbuffers;
 
 	if (f) {
-		const struct v4l2_pix_format *pix = &f->fmt.pix;
-		const struct sh_veu_format *fmt = sh_veu_find_fmt(f);
-		struct v4l2_format ftmp = *f;
+		const struct sh_veu_format *fmt = sh_veu_find_fmt_vb2(f);
+		unsigned int w, h;
 
-		if (fmt->fourcc != pix->pixelformat)
+		if (fmt->fourcc != f->pixelformat)
 			return -EINVAL;
-		sh_veu_try_fmt(&ftmp, fmt);
-		if (ftmp.fmt.pix.width != pix->width ||
-		    ftmp.fmt.pix.height != pix->height)
+		v4l_bound_align_image(&w, MIN_W, MAX_W, ALIGN_W,
+			      &h, MIN_H, MAX_H, 0, 0);
+
+		if (w != f->width || h != f->height)
 			return -EINVAL;
-		size = pix->bytesperline ? pix->bytesperline * pix->height * fmt->depth / fmt->ydepth :
-			pix->width * pix->height * fmt->depth / fmt->ydepth;
+		size = f->bytesperline[0] ?
+			f->bytesperline[0] *
+			f->height * fmt->depth / fmt->ydepth :
+			f->width * f->height * fmt->depth / fmt->ydepth;
 	} else {
 		vfmt = sh_veu_get_vfmt(veu, vq->type);
 		size = vfmt->bytesperline * vfmt->frame.height * vfmt->fmt->depth / vfmt->fmt->ydepth;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 7967a75..9eebf24 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -243,9 +243,10 @@ static void sh_vou_stream_config(struct sh_vou_device *vou_dev)
 }
 
 /* Locking: caller holds fop_lock mutex */
-static int sh_vou_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+static int sh_vou_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format *pix = &vou_dev->pix;
@@ -253,10 +254,10 @@ static int sh_vou_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fm
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	if (fmt && fmt->fmt.pix.sizeimage < pix->height * bytes_per_line)
+	if (fmt && fmt->req_sizes[0] < pix->height * bytes_per_line)
 		return -EINVAL;
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : pix->height * bytes_per_line;
+	sizes[0] = fmt ? fmt->req_sizes[0] : pix->height * bytes_per_line;
 	alloc_ctxs[0] = vou_dev->alloc_ctx;
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f24f603..0f8ad6d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -235,7 +235,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 9079196..8f088eb 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -469,7 +469,7 @@ static void mx2_camera_clock_stop(struct soc_camera_host *ici)
  *  Videobuf operations
  */
 static int mx2_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 5ea4350..42e8329 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -185,7 +185,7 @@ static void mx3_cam_dma_done(void *arg)
  * Calculate the __buffer__ (not data) size and number of buffers.
  */
 static int mx3_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -197,27 +197,27 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 		return -EINVAL;
 
 	if (fmt) {
-		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
-								fmt->fmt.pix.pixelformat);
+		const struct soc_camera_format_xlate *xlate =
+			soc_camera_xlate_by_fourcc(icd, fmt->pixelformat);
 		unsigned int bytes_per_line;
 		int ret;
 
 		if (!xlate)
 			return -EINVAL;
 
-		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
+		ret = soc_mbus_bytes_per_line(fmt->width,
 					      xlate->host_fmt);
 		if (ret < 0)
 			return ret;
 
-		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
+		bytes_per_line = max_t(u32, fmt->bytesperline[0], ret);
 
 		ret = soc_mbus_image_size(xlate->host_fmt, bytes_per_line,
-					  fmt->fmt.pix.height);
+					  fmt->height);
 		if (ret < 0)
 			return ret;
 
-		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
+		sizes[0] = max_t(u32, fmt->req_sizes[0], ret);
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
 		sizes[0] = icd->sizeimage;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 1dcf4d1..cacc90d 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -527,7 +527,7 @@ struct rcar_vin_cam {
  * required
  */
 static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
-				   const struct v4l2_format *fmt,
+				   const struct vb2_format *fmt,
 				   unsigned int *count,
 				   unsigned int *num_planes,
 				   unsigned int sizes[], void *alloc_ctxs[])
@@ -541,26 +541,26 @@ static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
 		unsigned int bytes_per_line;
 		int ret;
 
-		if (fmt->fmt.pix.sizeimage < icd->sizeimage)
+		if (fmt->req_sizes[0] < icd->sizeimage)
 			return -EINVAL;
 
 		xlate = soc_camera_xlate_by_fourcc(icd,
-						   fmt->fmt.pix.pixelformat);
+						fmt->pixelformat);
 		if (!xlate)
 			return -EINVAL;
-		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
+		ret = soc_mbus_bytes_per_line(fmt->width,
 					      xlate->host_fmt);
 		if (ret < 0)
 			return ret;
 
-		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
+		bytes_per_line = max_t(u32, fmt->bytesperline[0], ret);
 
 		ret = soc_mbus_image_size(xlate->host_fmt, bytes_per_line,
-					  fmt->fmt.pix.height);
+					  fmt->height);
 		if (ret < 0)
 			return ret;
 
-		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
+		sizes[0] = max_t(u32, fmt->req_sizes[0], ret);
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
 		sizes[0] = icd->sizeimage;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 1719942..4a9c51f 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -210,7 +210,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  *		  for the current frame format if required
  */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -219,27 +219,27 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
 	if (fmt) {
-		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
-								fmt->fmt.pix.pixelformat);
+		const struct soc_camera_format_xlate *xlate =
+			soc_camera_xlate_by_fourcc(icd, fmt->pixelformat);
 		unsigned int bytes_per_line;
 		int ret;
 
 		if (!xlate)
 			return -EINVAL;
 
-		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
+		ret = soc_mbus_bytes_per_line(fmt->width,
 					      xlate->host_fmt);
 		if (ret < 0)
 			return ret;
 
-		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
+		bytes_per_line = max_t(u32, fmt->bytesperline[0], ret);
 
 		ret = soc_mbus_image_size(xlate->host_fmt, bytes_per_line,
-					  fmt->fmt.pix.height);
+					  fmt->height);
 		if (ret < 0)
 			return ret;
 
-		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
+		sizes[0] = max_t(u32, fmt->req_sizes[0], ret);
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
 		sizes[0] = icd->sizeimage;
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 62b9842..9d6bb2e 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -438,7 +438,7 @@ static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
 }
 
 static int bdisp_queue_setup(struct vb2_queue *vq,
-			     const struct v4l2_format *fmt,
+			     const struct vb2_format *fmt,
 			     unsigned int *nb_buf, unsigned int *nb_planes,
 			     unsigned int sizes[], void *allocators[])
 {
@@ -455,11 +455,11 @@ static int bdisp_queue_setup(struct vb2_queue *vq,
 		return -EINVAL;
 	}
 
-	if (fmt && fmt->fmt.pix.sizeimage < frame->sizeimage)
+	if (fmt && fmt->req_sizes[0] < frame->sizeimage)
 		return -EINVAL;
 
 	*nb_planes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : frame->sizeimage;
+	sizes[0] = fmt ? fmt->req_sizes[0] : frame->sizeimage;
 	allocators[0] = ctx->bdisp_dev->alloc_ctx;
 
 	return 0;
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4902453..bd53f30 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1796,7 +1796,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
  * Queue operations
  */
 static int vpe_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
+			   const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index f2d38b9..2931cbe 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -712,7 +712,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
  */
 
 static int vim2m_queue_setup(struct vb2_queue *vq,
-				const struct v4l2_format *fmt,
+				const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -725,9 +725,9 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
 
 	if (fmt) {
-		if (fmt->fmt.pix.sizeimage < size)
+		if (fmt->req_sizes[0] < size)
 			return -EINVAL;
-		size = fmt->fmt.pix.sizeimage;
+		size = fmt->req_sizes[0];
 	}
 
 	while (size * count > MEM2MEM_VID_MEM_LIMIT)
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index bdc9f33..eded933 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -212,9 +212,10 @@ static int vivid_thread_sdr_cap(void *data)
 	return 0;
 }
 
-static int sdr_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+static int sdr_cap_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned *nbuffers, unsigned *nplanes,
+			unsigned sizes[], void *alloc_ctxs[])
 {
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = SDR_CAP_SAMPLES_PER_BUF * 2;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 2993149..9ef866c 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -138,7 +138,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
 }
 
 static int vbi_cap_queue_setup(struct vb2_queue *vq,
-			const struct v4l2_format *fmt,
+			const struct vb2_format *fmt,
 			unsigned *nbuffers, unsigned *nplanes,
 			unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 91c1688..50695e10 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -27,9 +27,10 @@
 #include "vivid-vbi-out.h"
 #include "vivid-vbi-cap.h"
 
-static int vbi_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+static int vbi_out_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned *nbuffers, unsigned *nplanes,
+			unsigned sizes[], void *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	bool is_60hz = dev->std_out & V4L2_STD_525_60;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 2497107..b7b88ea 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -95,9 +95,10 @@ static const struct v4l2_discrete_probe webcam_probe = {
 	VIVID_WEBCAM_SIZES
 };
 
-static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+static int vid_cap_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned *nbuffers, unsigned *nplanes,
+			unsigned sizes[], void *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	unsigned buffers = tpg_g_buffers(&dev->tpg);
@@ -122,24 +123,17 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		return -EINVAL;
 	}
 	if (fmt) {
-		const struct v4l2_pix_format_mplane *mp;
-		struct v4l2_format mp_fmt;
 		const struct vivid_fmt *vfmt;
 
-		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
-			fmt_sp2mp(fmt, &mp_fmt);
-			fmt = &mp_fmt;
-		}
-		mp = &fmt->fmt.pix_mp;
 		/*
 		 * Check if the number of planes in the specified format match
 		 * the number of buffers in the current format. You can't mix that.
 		 */
-		if (mp->num_planes != buffers)
+		if (fmt->num_planes != buffers)
 			return -EINVAL;
-		vfmt = vivid_get_format(dev, mp->pixelformat);
+		vfmt = vivid_get_format(dev, fmt->pixelformat);
 		for (p = 0; p < buffers; p++) {
-			sizes[p] = mp->plane_fmt[p].sizeimage;
+			sizes[p] = fmt->req_sizes[p];
 			if (sizes[p] < tpg_g_line_width(&dev->tpg, p) * h +
 							vfmt->data_offset[p])
 				return -EINVAL;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 376f865..3430b75 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -31,9 +31,10 @@
 #include "vivid-kthread-out.h"
 #include "vivid-vid-out.h"
 
-static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+static int vid_out_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned *nbuffers, unsigned *nplanes,
+			unsigned sizes[], void *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	const struct vivid_fmt *vfmt = dev->fmt_out;
@@ -64,25 +65,17 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	}
 
 	if (fmt) {
-		const struct v4l2_pix_format_mplane *mp;
-		struct v4l2_format mp_fmt;
-
-		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
-			fmt_sp2mp(fmt, &mp_fmt);
-			fmt = &mp_fmt;
-		}
-		mp = &fmt->fmt.pix_mp;
 		/*
 		 * Check if the number of planes in the specified format match
 		 * the number of planes in the current format. You can't mix that.
 		 */
-		if (mp->num_planes != planes)
+		if (fmt->num_planes != planes)
 			return -EINVAL;
-		sizes[0] = mp->plane_fmt[0].sizeimage;
+		sizes[0] = fmt->req_sizes[0];
 		if (sizes[0] < size)
 			return -EINVAL;
 		for (p = 1; p < planes; p++) {
-			sizes[p] = mp->plane_fmt[p].sizeimage;
+			sizes[p] = fmt->req_sizes[p];
 			if (sizes[p] < dev->bytesperline_out[p] * h)
 				return -EINVAL;
 		}
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 13e4fdc..ae97991 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -274,15 +274,89 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	return 0;
 }
 
+static int __vsp1_video_try_format_vb2(struct vsp1_video *video,
+				   struct vb2_format *fmt)
+{
+	static const u32 xrgb_formats[][2] = {
+		{ V4L2_PIX_FMT_RGB444, V4L2_PIX_FMT_XRGB444 },
+		{ V4L2_PIX_FMT_RGB555, V4L2_PIX_FMT_XRGB555 },
+		{ V4L2_PIX_FMT_BGR32, V4L2_PIX_FMT_XBGR32 },
+		{ V4L2_PIX_FMT_RGB32, V4L2_PIX_FMT_XRGB32 },
+	};
+
+	const struct vsp1_format_info *info;
+	unsigned int width = fmt->width;
+	unsigned int height = fmt->height;
+	unsigned int i;
+
+	/* Backward compatibility: replace deprecated RGB formats by their XRGB
+	 * equivalent. This selects the format older userspace applications want
+	 * while still exposing the new format.
+	 */
+	for (i = 0; i < ARRAY_SIZE(xrgb_formats); ++i) {
+		if (xrgb_formats[i][0] == fmt->pixelformat) {
+			fmt->pixelformat = xrgb_formats[i][1];
+			break;
+		}
+	}
+
+	/* Retrieve format information and select the default format if the
+	 * requested format isn't supported.
+	 */
+	info = vsp1_get_format_info(fmt->pixelformat);
+	if (info == NULL)
+		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
+
+	fmt->pixelformat = info->fourcc;
+
+	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
+	width = round_down(width, info->hsub);
+	height = round_down(height, info->vsub);
+
+	/* Clamp the width and height. */
+	fmt->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, VSP1_VIDEO_MAX_WIDTH);
+	fmt->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
+			    VSP1_VIDEO_MAX_HEIGHT);
+
+	/* Compute and clamp the stride and image size. While not documented in
+	 * the datasheet, strides not aligned to a multiple of 128 bytes result
+	 * in image corruption.
+	 */
+	for (i = 0; i < min(info->planes, 2U); ++i) {
+		unsigned int hsub = i > 0 ? info->hsub : 1;
+		unsigned int vsub = i > 0 ? info->vsub : 1;
+		unsigned int align = 128;
+		unsigned int bpl;
+
+		bpl = clamp_t(unsigned int, fmt->bytesperline[i],
+			      fmt->width / hsub * info->bpp[i] / 8,
+			      round_down(65535U, align));
+
+		fmt->bytesperline[i] = round_up(bpl, align);
+		fmt->req_sizes[i] = fmt->bytesperline[i]
+					    * fmt->height / vsub;
+	}
+
+	if (info->planes == 3) {
+		/* The second and third planes must have the same stride. */
+		fmt->bytesperline[2] = fmt->bytesperline[1];
+		fmt->req_sizes[2] = fmt->req_sizes[1];
+	}
+
+	fmt->num_planes = info->planes;
+
+	return 0;
+}
+
 static bool
 vsp1_video_format_adjust(struct vsp1_video *video,
-			 const struct v4l2_pix_format_mplane *format,
-			 struct v4l2_pix_format_mplane *adjust)
+			 const struct vb2_format *format,
+			 struct vb2_format *adjust)
 {
 	unsigned int i;
 
 	*adjust = *format;
-	__vsp1_video_try_format(video, adjust, NULL);
+	__vsp1_video_try_format_vb2(video, adjust);
 
 	if (format->width != adjust->width ||
 	    format->height != adjust->height ||
@@ -291,13 +365,13 @@ vsp1_video_format_adjust(struct vsp1_video *video,
 		return false;
 
 	for (i = 0; i < format->num_planes; ++i) {
-		if (format->plane_fmt[i].bytesperline !=
-		    adjust->plane_fmt[i].bytesperline)
+		if (format->bytesperline[i] !=
+		    adjust->bytesperline[i])
 			return false;
 
-		adjust->plane_fmt[i].sizeimage =
-			max(adjust->plane_fmt[i].sizeimage,
-			    format->plane_fmt[i].sizeimage);
+		adjust->req_sizes[i] =
+			max(adjust->req_sizes[i],
+			    format->req_sizes[i]);
 	}
 
 	return true;
@@ -787,32 +861,37 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
  */
 
 static int
-vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+vsp1_video_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		     unsigned int *nbuffers, unsigned int *nplanes,
 		     unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	const struct v4l2_pix_format_mplane *format;
-	struct v4l2_pix_format_mplane pix_mp;
+	struct vb2_format vfmt;
 	unsigned int i;
 
 	if (fmt) {
 		/* Make sure the format is valid and adjust the sizeimage field
 		 * if needed.
 		 */
-		if (!vsp1_video_format_adjust(video, &fmt->fmt.pix_mp, &pix_mp))
+		if (!vsp1_video_format_adjust(video, fmt, &vfmt))
 			return -EINVAL;
 
-		format = &pix_mp;
+		*nplanes = vfmt.num_planes;
+
+		for (i = 0; i < vfmt.num_planes; ++i) {
+			sizes[i] = vfmt.req_sizes[i];
+			alloc_ctxs[i] = video->alloc_ctx;
+		}
+
 	} else {
 		format = &video->format;
-	}
+		*nplanes = format->num_planes;
 
-	*nplanes = format->num_planes;
-
-	for (i = 0; i < format->num_planes; ++i) {
-		sizes[i] = format->plane_fmt[i].sizeimage;
-		alloc_ctxs[i] = video->alloc_ctx;
+		for (i = 0; i < format->num_planes; ++i) {
+			sizes[i] = format->plane_fmt[i].sizeimage;
+			alloc_ctxs[i] = video->alloc_ctx;
+		}
 	}
 
 	return 0;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 5af66c2..3ae25ac 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -309,19 +309,19 @@ static void xvip_dma_complete(void *param)
 }
 
 static int
-xvip_dma_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+xvip_dma_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		     unsigned int *nbuffers, unsigned int *nplanes,
 		     unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct xvip_dma *dma = vb2_get_drv_priv(vq);
 
 	/* Make sure the image size is large enough. */
-	if (fmt && fmt->fmt.pix.sizeimage < dma->format.sizeimage)
+	if (fmt && fmt->req_sizes[0] < dma->format.sizeimage)
 		return -EINVAL;
 
 	*nplanes = 1;
 
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : dma->format.sizeimage;
+	sizes[0] = fmt ? fmt->req_sizes[0] : dma->format.sizeimage;
 	alloc_ctxs[0] = dma->alloc_ctx;
 
 	return 0;
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 2542af3..c089f8e 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -488,7 +488,7 @@ static void airspy_disconnect(struct usb_interface *intf)
 
 /* Videobuf2 operations */
 static int airspy_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		const struct vb2_format *fmt, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 5ec507e..4bedc68 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -30,16 +30,16 @@
 
 /* ------------------------------------------------------------------ */
 
-static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+static int vbi_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long img_size = dev->vbi_width * dev->vbi_height * 2;
 	unsigned long size;
 
-	size = fmt ? (fmt->fmt.vbi.samples_per_line *
-		(fmt->fmt.vbi.count[0] + fmt->fmt.vbi.count[1])) : img_size;
+	size = fmt ? fmt->req_sizes[0] : img_size;
 	if (size < img_size)
 		return -EINVAL;
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 065b9c8..76d6241 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -638,7 +638,7 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -646,7 +646,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	unsigned long img_size = dev->height * dev->bytesperline;
 	unsigned long size;
 
-	size = fmt ? fmt->fmt.pix.sizeimage : img_size;
+	size = fmt ? fmt->req_sizes[0] : img_size;
 	if (size < img_size)
 		return -EINVAL;
 
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 23a6148..02e7877 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -31,16 +31,17 @@
 
 /* ------------------------------------------------------------------ */
 
-static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+static int vbi_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
+			unsigned int *nbuffers, unsigned int *nplanes,
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	unsigned long size;
 
 	if (fmt)
-		size = fmt->fmt.pix.sizeimage;
+		size = fmt->req_sizes[0];
 	else
 		size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 262e032..3176abc 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -871,7 +871,7 @@ static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
 	Videobuf2 operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -880,7 +880,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	unsigned long size;
 
 	if (fmt)
-		size = fmt->fmt.pix.sizeimage;
+		size = fmt->req_sizes[0];
 	else
 		size =
 		    (v4l2->width * v4l2->height * v4l2->format->depth + 7) >> 3;
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 63d87a2..fc44550 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -369,7 +369,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int go7007_queue_setup(struct vb2_queue *q,
-		const struct v4l2_format *fmt,
+		const struct vb2_format *fmt,
 		unsigned int *num_buffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e1d4d16..4ab7912 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -466,7 +466,7 @@ static void hackrf_disconnect(struct usb_interface *intf)
 
 /* Videobuf2 operations */
 static int hackrf_queue_setup(struct vb2_queue *vq,
-		const struct v4l2_format *fmt, unsigned int *nbuffers,
+		const struct vb2_format *fmt, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 26a76e0..4314a7e 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -616,7 +616,7 @@ static int msi2500_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int msi2500_queue_setup(struct vb2_queue *vq,
-			       const struct v4l2_format *fmt,
+			       const struct vb2_format *fmt,
 			       unsigned int *nbuffers,
 			       unsigned int *nplanes, unsigned int sizes[],
 			       void *alloc_ctxs[])
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 3f5395a..4529f30 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -571,7 +571,7 @@ static void pwc_video_release(struct v4l2_device *v)
 /***************************************************************************/
 /* Videobuf2 operations */
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 32b5115..afd61e4 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -660,7 +660,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
    Videobuf operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 10e35e6..8b24d2c 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -664,7 +664,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 /*
  * Videobuf2 operations
  */
-static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
+static int queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index ce5d502..8d5f0ca 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -599,7 +599,7 @@ static struct v4l2_file_operations usbtv_fops = {
 };
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
-	const struct v4l2_format *fmt, unsigned int *nbuffers,
+	const struct vb2_format *fmt, unsigned int *nbuffers,
 	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
@@ -608,9 +608,9 @@ static int usbtv_queue_setup(struct vb2_queue *vq,
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
 	*nplanes = 1;
-	if (fmt && fmt->fmt.pix.sizeimage < size)
+	if (fmt && fmt->req_sizes[0] < size)
 		return -EINVAL;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
+	sizes[0] = fmt ? fmt->req_sizes[0] : size;
 
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index b49bcab..9c2f758 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -69,7 +69,7 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
  * videobuf2 queue operations
  */
 
-static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int uvc_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -77,12 +77,12 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 
 	/* Make sure the image size is large enough. */
-	if (fmt && fmt->fmt.pix.sizeimage < stream->ctrl.dwMaxVideoFrameSize)
+	if (fmt && fmt->req_sizes[0] < stream->ctrl.dwMaxVideoFrameSize)
 		return -EINVAL;
 
 	*nplanes = 1;
 
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage
+	sizes[0] = fmt ? fmt->req_sizes[0]
 		 : stream->ctrl.dwMaxVideoFrameSize;
 
 	return 0;
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8c456f7..aeef76c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1022,6 +1022,51 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
+static struct vb2_format *__to_vb2_format(struct vb2_format *dfmt,
+			struct v4l2_format *sfmt)
+{
+	int i;
+
+	if (!dfmt || !sfmt)
+		return NULL;
+
+	dfmt->type = sfmt->type;
+
+	switch (sfmt->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		dfmt->pixelformat = sfmt->fmt.pix.pixelformat;
+		dfmt->width = sfmt->fmt.pix.width;
+		dfmt->height = sfmt->fmt.pix.height;
+		dfmt->num_planes = 1;
+		dfmt->bytesperline[0] = sfmt->fmt.pix.bytesperline;
+		dfmt->req_sizes[0] = sfmt->fmt.pix.sizeimage;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		dfmt->pixelformat = sfmt->fmt.pix_mp.pixelformat;
+		dfmt->width = sfmt->fmt.pix_mp.width;
+		dfmt->height = sfmt->fmt.pix_mp.height;
+		dfmt->num_planes = sfmt->fmt.pix_mp.num_planes;
+		for (i = 0; i < sfmt->fmt.pix_mp.num_planes; i++) {
+			dfmt->req_sizes[i] =
+				sfmt->fmt.pix_mp.plane_fmt[i].sizeimage;
+			dfmt->bytesperline[i] =
+				sfmt->fmt.pix_mp.plane_fmt[i].bytesperline;
+		}
+		break;
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		dfmt->req_sizes[0] = sfmt->fmt.vbi.samples_per_line *
+			(sfmt->fmt.vbi.count[0] + sfmt->fmt.vbi.count[1]);
+		break;
+	default:
+		return NULL;
+	}
+
+	return dfmt;
+}
+
 /**
  * __create_bufs() - Allocate buffers and any required auxiliary structs
  * @q:		videobuf2 queue
@@ -1040,6 +1085,7 @@ EXPORT_SYMBOL_GPL(vb2_reqbufs);
 static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
+	struct vb2_format fmt;
 	int ret;
 
 	if (q->num_buffers == VIDEO_MAX_FRAME) {
@@ -1060,8 +1106,10 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 	 * Ask the driver, whether the requested number of buffers, planes per
 	 * buffer and their sizes are acceptable
 	 */
-	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-		       &num_planes, q->plane_sizes, q->alloc_ctx);
+	ret = call_qop(q, queue_setup, q,
+			__to_vb2_format(&fmt, &create->format),
+			&num_buffers, &num_planes, q->plane_sizes,
+			q->alloc_ctx);
 	if (ret)
 		return ret;
 
@@ -1083,8 +1131,10 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 * q->num_buffers contains the total number of buffers, that the
 		 * queue driver has set up
 		 */
-		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
+		ret = call_qop(q, queue_setup, q,
+				__to_vb2_format(&fmt, &create->format),
+				&num_buffers, &num_planes, q->plane_sizes,
+				q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index fbcc1c3..6dd2988 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1078,7 +1078,8 @@ vpfe_g_dv_timings(struct file *file, void *fh,
  * the buffer nbuffers and buffer size
  */
 static int
-vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+vpfe_buffer_queue_setup(struct vb2_queue *vq,
+			const struct vb2_format *fmt,
 			unsigned int *nbuffers, unsigned int *nplanes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index e0cf499..5ac9b28 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -288,7 +288,7 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
  */
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
-				 const struct v4l2_format *fmt,
+				 const struct vb2_format *fmt,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 3628938..1597c2b 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -41,7 +41,7 @@
  * videobuf2 queue operations
  */
 
-static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+static int uvc_queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 108fa16..29b95fa 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -250,6 +250,29 @@ struct vb2_buffer {
 };
 
 /**
+ * struct vb2_format - format information which is passed to queue setup
+ *
+ * @type:	buffer type
+ * @pixelformat:	little endian four character code (fourcc)
+ * @width:	image width in pixels
+ * @height:	image height in pixels
+ * @num_planes:	number of planes in the buffer
+ * @bytesperline:	distance in bytes between the leftmost pixels in two
+ *		adjacent lines
+ * @req_sizes:	required size in bytes for data, for which
+ *		this plane will be used
+ */
+struct vb2_format {
+	unsigned int	type;
+	unsigned int	pixelformat;
+	unsigned int	width;
+	unsigned int	height;
+	unsigned int	num_planes;
+	unsigned int	bytesperline[VIDEO_MAX_PLANES];
+	unsigned int	req_sizes[VIDEO_MAX_PLANES];
+};
+
+/**
  * struct vb2_ops - driver-specific callbacks
  *
  * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
@@ -329,9 +352,10 @@ struct vb2_buffer {
  *			pre-queued buffers before calling STREAMON.
  */
 struct vb2_ops {
-	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[]);
+	int (*queue_setup)(struct vb2_queue *q,
+			const struct vb2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[]);
 
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
-- 
1.7.9.5


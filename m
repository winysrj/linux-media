Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51829 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbbJ2E0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 00:26:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: jh1009.sung@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] vb2: drop v4l2_format argument from queue_setup
Date: Thu, 29 Oct 2015 05:24:25 +0100
Message-Id: <1446092666-2313-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
References: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The queue_setup callback has a void pointer that is just for V4L2
and is the pointer to the v4l2_format struct that was passed to
VIDIOC_CREATE_BUFS. The idea was that drivers would use the information
from that struct to buffers suitable for the requested format.

After the vb2 split series this pointer is now a void pointer,
which is ugly, and the reality is that all existing drivers will
effectively just look at the sizeimage field of v4l2_format.

To make this more generic the queue_setup callback is changed:
the void pointer is dropped, instead if the *num_planes argument
is 0, then use the current format size, if it is non-zero, then
it contains the number of requested planes and the sizes array
contains the requested sizes. If either is unsupported, then return
-EINVAL, otherwise use the requested size(s).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c      | 10 ++---
 drivers/input/touchscreen/sur40.c                  | 11 +++--
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 12 ++---
 drivers/media/pci/cx23885/cx23885-417.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  2 +-
 drivers/media/pci/cx25821/cx25821-video.c          | 12 ++---
 drivers/media/pci/cx88/cx88-blackbird.c            |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |  2 +-
 drivers/media/pci/cx88/cx88-video.c                |  2 +-
 drivers/media/pci/dt3155/dt3155.c                  | 11 +++--
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  1 -
 drivers/media/pci/saa7134/saa7134-ts.c             |  2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
 drivers/media/pci/saa7134/saa7134.h                |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  1 -
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  2 +-
 drivers/media/pci/tw68/tw68-video.c                | 20 ++++-----
 drivers/media/platform/am437x/am437x-vpfe.c        | 17 ++++----
 drivers/media/platform/blackfin/bfin_capture.c     | 12 +++--
 drivers/media/platform/coda/coda-common.c          |  2 +-
 drivers/media/platform/davinci/vpbe_display.c      | 13 +++---
 drivers/media/platform/davinci/vpif_capture.c      | 17 ++++----
 drivers/media/platform/davinci/vpif_display.c      | 13 +++---
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  1 -
 drivers/media/platform/exynos4-is/fimc-capture.c   | 31 +++++++------
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 31 ++++++-------
 drivers/media/platform/exynos4-is/fimc-lite.c      | 31 ++++++-------
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
 drivers/media/platform/m2m-deinterlace.c           |  1 -
 drivers/media/platform/marvell-ccic/mcam-core.c    | 13 +++---
 drivers/media/platform/mx2_emmaprp.c               |  1 -
 drivers/media/platform/omap3isp/ispvideo.c         |  1 -
 drivers/media/platform/rcar_jpu.c                  | 25 ++++++-----
 drivers/media/platform/s3c-camif/camif-capture.c   | 33 +++++---------
 drivers/media/platform/s5p-g2d/g2d.c               |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  1 -
 drivers/media/platform/s5p-tv/mixer_video.c        |  2 +-
 drivers/media/platform/sh_veu.c                    | 31 ++++---------
 drivers/media/platform/sh_vou.c                    | 11 +++--
 drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  6 ---
 drivers/media/platform/soc_camera/mx3_camera.c     | 38 +++-------------
 drivers/media/platform/soc_camera/rcar_vin.c       | 40 +++--------------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 37 +++-------------
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 10 ++---
 drivers/media/platform/ti-vpe/vpe.c                |  1 -
 drivers/media/platform/vim2m.c                     | 13 ++----
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       | 22 +++-------
 drivers/media/platform/vivid/vivid-vid-out.c       | 19 ++------
 drivers/media/platform/vsp1/vsp1_video.c           | 51 +++++-----------------
 drivers/media/platform/xilinx/xilinx-dma.c         | 12 +++--
 drivers/media/usb/airspy/airspy.c                  |  2 +-
 drivers/media/usb/au0828/au0828-vbi.c              | 14 ++----
 drivers/media/usb/au0828/au0828-video.c            | 12 ++---
 drivers/media/usb/em28xx/em28xx-vbi.c              | 20 ++++-----
 drivers/media/usb/em28xx/em28xx-video.c            | 19 ++------
 drivers/media/usb/go7007/go7007-v4l2.c             |  1 -
 drivers/media/usb/hackrf/hackrf.c                  |  2 +-
 drivers/media/usb/msi2500/msi2500.c                |  1 -
 drivers/media/usb/pwc/pwc-if.c                     |  2 +-
 drivers/media/usb/s2255/s2255drv.c                 |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  9 ++--
 drivers/media/usb/uvc/uvc_queue.c                  | 14 +++---
 drivers/media/v4l2-core/videobuf2-core.c           | 23 +++++++---
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 48 +++++++++++++++++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  1 -
 drivers/usb/gadget/function/uvc_queue.c            |  2 +-
 include/media/videobuf2-core.h                     | 40 +++++++++--------
 81 files changed, 356 insertions(+), 519 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 95ae828..2f08638 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -163,7 +163,7 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
  * minimum number: many DMA engines need a minimum of 2 buffers in the
  * queue and you need to have another available for userspace processing.
  */
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -183,12 +183,12 @@ static int queue_setup(struct vb2_queue *vq, const void *parg,
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
+	alloc_ctxs[0] = skel->alloc_ctx;
 
-	if (fmt && fmt->fmt.pix.sizeimage < skel->format.sizeimage)
-		return -EINVAL;
+	if (*nplanes)
+		return sizes[0] < skel->format.sizeimage ? -EINVAL : 0;
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : skel->format.sizeimage;
-	alloc_ctxs[0] = skel->alloc_ctx;
+	sizes[0] = skel->format.sizeimage;
 	return 0;
 }
 
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index d214f22..3f3e2b1 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -644,22 +644,21 @@ static void sur40_disconnect(struct usb_interface *interface)
  * minimum number: many DMA engines need a minimum of 2 buffers in the
  * queue and you need to have another available for userspace processing.
  */
-static int sur40_queue_setup(struct vb2_queue *q, const void *parg,
+static int sur40_queue_setup(struct vb2_queue *q,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct sur40_state *sur40 = vb2_get_drv_priv(q);
 
 	if (q->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - q->num_buffers;
+	alloc_ctxs[0] = sur40->alloc_ctx;
 
-	if (fmt && fmt->fmt.pix.sizeimage < sur40_video_format.sizeimage)
-		return -EINVAL;
+	if (*nplanes)
+		return sizes[0] < sur40_video_format.sizeimage ? -EINVAL : 0;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : sur40_video_format.sizeimage;
-	alloc_ctxs[0] = sur40->alloc_ctx;
+	sizes[0] = sur40_video_format.sizeimage;
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index dcd8d94..238191d 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -490,7 +490,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
-		const void *parg, unsigned int *nbuffers,
+		unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index ff46e42..c81e9ec 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -43,11 +43,10 @@ static const struct v4l2_dv_timings cea1080p60 = V4L2_DV_BT_CEA_1920X1080P60;
 
 /* vb2 DMA streaming ops */
 
-static int cobalt_queue_setup(struct vb2_queue *q, const void *parg,
+static int cobalt_queue_setup(struct vb2_queue *q,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct cobalt_stream *s = q->drv_priv;
 	unsigned size = s->stride * s->height;
 
@@ -55,14 +54,11 @@ static int cobalt_queue_setup(struct vb2_queue *q, const void *parg,
 		*num_buffers = 3;
 	if (*num_buffers > NR_BUFS)
 		*num_buffers = NR_BUFS;
+	alloc_ctxs[0] = s->cobalt->alloc_ctx;
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*num_planes = 1;
-	if (fmt) {
-		if (fmt->fmt.pix.sizeimage < size)
-			return -EINVAL;
-		size = fmt->fmt.pix.sizeimage;
-	}
 	sizes[0] = size;
-	alloc_ctxs[0] = s->cobalt->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 88a3afb..81450ae 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1138,7 +1138,7 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index c4307ad..5378d93 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -92,7 +92,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index cf3cb13..73763c2 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -121,7 +121,7 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 71a80e2..745bfe5 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -315,7 +315,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 	return 0;
 }
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 26e3e29..644373d 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -141,20 +141,20 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	return handled;
 }
 
-static int cx25821_queue_setup(struct vb2_queue *q, const void *parg,
+static int cx25821_queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct cx25821_channel *chan = q->drv_priv;
 	unsigned size = (chan->fmt->depth * chan->width * chan->height) >> 3;
 
-	if (fmt && fmt->fmt.pix.sizeimage < size)
-		return -EINVAL;
+	alloc_ctxs[0] = chan->dev->alloc_ctx;
+
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
 
 	*num_planes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
-	alloc_ctxs[0] = chan->dev->alloc_ctx;
+	sizes[0] = size;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 8b88913..38113f5 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -637,7 +637,7 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index f048350..afb2075 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -82,7 +82,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 007a5ee..ccc646d 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -107,7 +107,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index f3b12db..8612c27 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -429,7 +429,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 /* ------------------------------------------------------------------ */
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index d84abde..1981382 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -131,22 +131,21 @@ static int wait_i2c_reg(void __iomem *addr)
 }
 
 static int
-dt3155_queue_setup(struct vb2_queue *vq, const void *parg,
+dt3155_queue_setup(struct vb2_queue *vq,
 		unsigned int *nbuffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 
 {
-	const struct v4l2_format *fmt = parg;
 	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
 	unsigned size = pd->width * pd->height;
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
-	if (fmt && fmt->fmt.pix.sizeimage < size)
-		return -EINVAL;
-	*num_planes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
 	alloc_ctxs[0] = pd->alloc_ctx;
+	if (num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+	*num_planes = 1;
+	sizes[0] = size;
 	return 0;
 }
 
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 83c90d3..9015ea3 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -277,7 +277,6 @@ static irqreturn_t netup_unidvb_isr(int irq, void *dev_id)
 }
 
 static int netup_unidvb_queue_setup(struct vb2_queue *vq,
-				    const void *parg,
 				    unsigned int *nbuffers,
 				    unsigned int *nplanes,
 				    unsigned int sizes[],
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 7fb5ee7..0584a2a 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -116,7 +116,7 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
-int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
+int saa7134_ts_queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 6271b0e..e76da37 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -138,7 +138,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 518086c..eaa2ced 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -904,7 +904,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 				    saa7134_buffer_startpage(buf));
 }
 
-static int queue_setup(struct vb2_queue *q, const void *parg,
+static int queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 6b6d234..1aa68d7 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -820,7 +820,7 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
-int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
+int saa7134_ts_queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
 int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 1bd2fd4..b9c6fa8 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -663,7 +663,6 @@ static int solo_ring_thread(void *data)
 }
 
 static int solo_enc_queue_setup(struct vb2_queue *q,
-				const void *parg,
 				unsigned int *num_buffers,
 				unsigned int *num_planes, unsigned int sizes[],
 				void *alloc_ctxs[])
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 26df903..1cdf491 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -313,7 +313,7 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 	solo_dev->kthread = NULL;
 }
 
-static int solo_queue_setup(struct vb2_queue *q, const void *parg,
+static int solo_queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 6367b45..b8b06fb 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -265,7 +265,7 @@ static void vip_active_buf_next(struct sta2x11_vip *vip)
 
 
 /* Videobuf2 Operations */
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 4c3293d..5b5bc5c 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -376,28 +376,28 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
 /* ------------------------------------------------------------- */
 /* vb2 queue operations                                          */
 
-static int tw68_queue_setup(struct vb2_queue *q, const void *parg,
+static int tw68_queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct tw68_dev *dev = vb2_get_drv_priv(q);
 	unsigned tot_bufs = q->num_buffers + *num_buffers;
+	unsigned size = (dev->fmt->depth * dev->width * dev->height) >> 3;
 
-	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
+	if (tot_bufs < 2)
+		tot_bufs = 2;
+	tot_bufs = tw68_buffer_count(sizes[0], tot_bufs);
+	*num_buffers = tot_bufs - q->num_buffers;
 	alloc_ctxs[0] = dev->alloc_ctx;
 	/*
-	 * We allow create_bufs, but only if the sizeimage is the same as the
+	 * We allow create_bufs, but only if the sizeimage is >= as the
 	 * current sizeimage. The tw68_buffer_count calculation becomes quite
 	 * difficult otherwise.
 	 */
-	if (fmt && fmt->fmt.pix.sizeimage < sizes[0])
-		return -EINVAL;
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*num_planes = 1;
-	if (tot_bufs < 2)
-		tot_bufs = 2;
-	tot_bufs = tw68_buffer_count(sizes[0], tot_bufs);
-	*num_buffers = tot_bufs - q->num_buffers;
+	sizes[0] = size;
 
 	return 0;
 }
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index f0480d6..e434c8e 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1898,7 +1898,6 @@ static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
 /*
  * vpfe_queue_setup - Callback function for buffer setup.
  * @vq: vb2_queue ptr
- * @fmt: v4l2 format
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
@@ -1908,22 +1907,24 @@ static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
  * the buffer count and buffer size
  */
 static int vpfe_queue_setup(struct vb2_queue *vq,
-			    const void *parg,
 			    unsigned int *nbuffers, unsigned int *nplanes,
 			    unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
-
-	if (fmt && fmt->fmt.pix.sizeimage < vpfe->fmt.fmt.pix.sizeimage)
-		return -EINVAL;
+	unsigned size = vpfe->fmt.fmt.pix.sizeimage;
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
+	alloc_ctxs[0] = vpfe->alloc_ctx;
+
+	if (*nplanes) {
+		if (sizes[0] < size)
+			return -EINVAL;
+		size = sizes[0];
+	}
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : vpfe->fmt.fmt.pix.sizeimage;
-	alloc_ctxs[0] = vpfe->alloc_ctx;
+	sizes[0] = size;
 
 	vpfe_dbg(1, vpfe,
 		"nbuffers=%d, size=%u\n", *nbuffers, sizes[0]);
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 7764b9c..8ecc05a 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -202,22 +202,20 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 }
 
 static int bcap_queue_setup(struct vb2_queue *vq,
-				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 
-	if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
-		return -EINVAL;
-
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2;
+	alloc_ctxs[0] = bcap_dev->alloc_ctx;
+
+	if (*nplanes)
+		return sizes[0] < bcap_dev->fmt.sizeimage ? -EINVAL : 0;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : bcap_dev->fmt.sizeimage;
-	alloc_ctxs[0] = bcap_dev->alloc_ctx;
+	sizes[0] = bcap_dev->fmt.sizeimage;
 
 	return 0;
 }
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 15516a6..196333c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1131,7 +1131,7 @@ static void set_default_params(struct coda_ctx *ctx)
 /*
  * Queue operations
  */
-static int coda_queue_setup(struct vb2_queue *vq, const void *parg,
+static int coda_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6d91422..3fc2176 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -228,28 +228,27 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
  * This function allocates memory for the buffers
  */
 static int
-vpbe_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
+vpbe_buffer_queue_setup(struct vb2_queue *vq,
 			unsigned int *nbuffers, unsigned int *nplanes,
 			unsigned int sizes[], void *alloc_ctxs[])
 
 {
-	const struct v4l2_format *fmt = parg;
 	/* Get the file handle object and layer object */
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
 	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_buffer_setup\n");
 
-	if (fmt && fmt->fmt.pix.sizeimage < layer->pix_fmt.sizeimage)
-		return -EINVAL;
-
 	/* Store number of buffers allocated in numbuffer member */
 	if (vq->num_buffers + *nbuffers < VPBE_DEFAULT_NUM_BUFS)
 		*nbuffers = VPBE_DEFAULT_NUM_BUFS - vq->num_buffers;
+	alloc_ctxs[0] = layer->alloc_ctx;
+
+	if (*nplanes)
+		return sizes[0] < layer->pix_fmt.sizeimage ? -EINVAL : 0;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : layer->pix_fmt.sizeimage;
-	alloc_ctxs[0] = layer->alloc_ctx;
+	sizes[0] = layer->pix_fmt.sizeimage;
 
 	return 0;
 }
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index c1e573b..fad5b38 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -104,7 +104,6 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 /**
  * vpif_buffer_queue_setup : Callback function for buffer setup.
  * @vq: vb2_queue ptr
- * @fmt: v4l2 format
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
@@ -114,26 +113,26 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	unsigned size = common->fmt.fmt.pix.sizeimage;
 
 	vpif_dbg(2, debug, "vpif_buffer_setup\n");
 
-	if (fmt && fmt->fmt.pix.sizeimage < common->fmt.fmt.pix.sizeimage)
-		return -EINVAL;
+	if (*nplanes) {
+		if (sizes[0] < size)
+			return -EINVAL;
+		size = sizes[0];
+	}
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;
+	sizes[0] = size;
 	alloc_ctxs[0] = common->alloc_ctx;
 
 	/* Calculate the offset for Y and C data in the buffer */
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index fd27803..534b50a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -99,7 +99,6 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 /**
  * vpif_buffer_queue_setup : Callback function for buffer setup.
  * @vq: vb2_queue ptr
- * @fmt: v4l2 format
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
@@ -109,22 +108,24 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
-				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	unsigned size = common->fmt.fmt.pix.sizeimage;
 
-	if (fmt && fmt->fmt.pix.sizeimage < common->fmt.fmt.pix.sizeimage)
-		return -EINVAL;
+	if (*nplanes) {
+		if (sizes[0] < size)
+			return -EINVAL;
+		size = sizes[0];
+	}
 
 	if (vq->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;
+	sizes[0] = size;
 	alloc_ctxs[0] = common->alloc_ctx;
 
 	/* Calculate the offset for Y and C data  in the buffer */
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d82e717..ea9230e 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -212,7 +212,6 @@ put_device:
 }
 
 static int gsc_m2m_queue_setup(struct vb2_queue *vq,
-			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 99e5732..beadccb 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -338,37 +338,36 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 }
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_format *pfmt = parg;
-	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_ctx *ctx = vq->drv_priv;
 	struct fimc_frame *frame = &ctx->d_frame;
 	struct fimc_fmt *fmt = frame->fmt;
-	unsigned long wh;
+	unsigned long wh = frame->f_width * frame->f_height;
 	int i;
 
-	if (pfmt) {
-		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_find_format(&pixm->pixelformat, NULL,
-				       FMT_FLAGS_CAM | FMT_FLAGS_M2M, -1);
-		wh = pixm->width * pixm->height;
-	} else {
-		wh = frame->f_width * frame->f_height;
-	}
-
 	if (fmt == NULL)
 		return -EINVAL;
 
+	if (*num_planes) {
+		if (*num_planes != fmt->memplanes)
+			return -EINVAL;
+		for (i = 0; i < *num_planes; i++) {
+			if (sizes[i] < (wh * fmt->depth[i]) / 8)
+				return -EINVAL;
+			allocators[i] = ctx->fimc_dev->alloc_ctx;
+		}
+		return 0;
+	}
+
 	*num_planes = fmt->memplanes;
 
 	for (i = 0; i < fmt->memplanes; i++) {
 		unsigned int size = (wh * fmt->depth[i]) / 8;
-		if (pixm)
-			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
-		else if (fimc_fmt_is_user_defined(fmt->color))
+
+		if (fimc_fmt_is_user_defined(fmt->color))
 			sizes[i] = frame->payload[i];
 		else
 			sizes[i] = max_t(u32, size, frame->payload[i]);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 6e66484..dd08305 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -39,39 +39,36 @@
 #include "fimc-is-param.h"
 
 static int isp_video_capture_queue_setup(struct vb2_queue *vq,
-			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
 			unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_format *pfmt = parg;
 	struct fimc_isp *isp = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format_mplane *vid_fmt = &isp->video_capture.pixfmt;
-	const struct v4l2_pix_format_mplane *pixm = NULL;
-	const struct fimc_fmt *fmt;
+	const struct fimc_fmt *fmt = isp->video_capture.format;
 	unsigned int wh, i;
 
-	if (pfmt) {
-		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, -1);
-		wh = pixm->width * pixm->height;
-	} else {
-		fmt = isp->video_capture.format;
-		wh = vid_fmt->width * vid_fmt->height;
-	}
+	wh = vid_fmt->width * vid_fmt->height;
 
 	if (fmt == NULL)
 		return -EINVAL;
 
 	*num_buffers = clamp_t(u32, *num_buffers, FIMC_ISP_REQ_BUFS_MIN,
 						FIMC_ISP_REQ_BUFS_MAX);
+	if (*num_planes) {
+		if (*num_planes != fmt->memplanes)
+			return -EINVAL;
+		for (i = 0; i < *num_planes; i++) {
+			if (sizes[i] < (wh * fmt->depth[i]) / 8)
+				return -EINVAL;
+			allocators[i] = isp->alloc_ctx;
+		}
+		return 0;
+	}
+
 	*num_planes = fmt->memplanes;
 
 	for (i = 0; i < fmt->memplanes; i++) {
-		unsigned int size = (wh * fmt->depth[i]) / 8;
-		if (pixm)
-			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
-		else
-			sizes[i] = size;
+		sizes[i] = (wh * fmt->depth[i]) / 8;
 		allocators[i] = isp->alloc_ctx;
 	}
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 60660c3..0b6f12c 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -355,37 +355,34 @@ static void stop_streaming(struct vb2_queue *q)
 	fimc_lite_stop_capture(fimc, false);
 }
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_format *pfmt = parg;
-	const struct v4l2_pix_format_mplane *pixm = NULL;
 	struct fimc_lite *fimc = vq->drv_priv;
 	struct flite_frame *frame = &fimc->out_frame;
 	const struct fimc_fmt *fmt = frame->fmt;
-	unsigned long wh;
+	unsigned long wh = frame->f_width * frame->f_height;
 	int i;
 
-	if (pfmt) {
-		pixm = &pfmt->fmt.pix_mp;
-		fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, 0, -1);
-		wh = pixm->width * pixm->height;
-	} else {
-		wh = frame->f_width * frame->f_height;
-	}
-
 	if (fmt == NULL)
 		return -EINVAL;
 
+	if (*num_planes) {
+		if (*num_planes != fmt->memplanes)
+			return -EINVAL;
+		for (i = 0; i < *num_planes; i++) {
+			if (sizes[i] < (wh * fmt->depth[i]) / 8)
+				return -EINVAL;
+			allocators[i] = fimc->alloc_ctx;
+		}
+		return 0;
+	}
+
 	*num_planes = fmt->memplanes;
 
 	for (i = 0; i < fmt->memplanes; i++) {
-		unsigned int size = (wh * fmt->depth[i]) / 8;
-		if (pixm)
-			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
-		else
-			sizes[i] = size;
+		sizes[i] = (wh * fmt->depth[i]) / 8;
 		allocators[i] = fimc->alloc_ctx;
 	}
 
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 4d1d64a4..4c04b59 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -176,7 +176,7 @@ static void fimc_job_abort(void *priv)
 	fimc_m2m_shutdown(priv);
 }
 
-static int fimc_queue_setup(struct vb2_queue *vq, const void *parg,
+static int fimc_queue_setup(struct vb2_queue *vq,
 			    unsigned int *num_buffers, unsigned int *num_planes,
 			    unsigned int sizes[], void *allocators[])
 {
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 29973f9..652eebd 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -798,7 +798,6 @@ struct vb2_dc_conf {
 };
 
 static int deinterlace_queue_setup(struct vb2_queue *vq,
-				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index aa2b440..0805c08 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1049,24 +1049,25 @@ static int mcam_read_setup(struct mcam_camera *cam)
  */
 
 static int mcam_vb_queue_setup(struct vb2_queue *vq,
-		const void *parg, unsigned int *nbufs,
+		unsigned int *nbufs,
 		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
+	unsigned size = cam->pix_format.sizeimage;
 
-	if (fmt && fmt->fmt.pix.sizeimage < cam->pix_format.sizeimage)
-		return -EINVAL;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : cam->pix_format.sizeimage;
-	*num_planes = 1; /* Someday we have to support planar formats... */
 	if (*nbufs < minbufs)
 		*nbufs = minbufs;
 	if (cam->buffer_mode == B_DMA_contig)
 		alloc_ctxs[0] = cam->vb_alloc_ctx;
 	else if (cam->buffer_mode == B_DMA_sg)
 		alloc_ctxs[0] = cam->vb_alloc_ctx_sg;
+
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+	sizes[0] = size;
+	*num_planes = 1; /* Someday we have to support planar formats... */
 	return 0;
 }
 
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 03a1b60..cb7d4b5 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -689,7 +689,6 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
  * Queue operations
  */
 static int emmaprp_queue_setup(struct vb2_queue *vq,
-				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index f4f5916..9cc4878 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -320,7 +320,6 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
  */
 
 static int isp_video_queue_setup(struct vb2_queue *queue,
-				 const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index f8e3e83..23dadae 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1015,28 +1015,33 @@ error_free:
  * ============================================================================
  */
 static int jpu_queue_setup(struct vb2_queue *vq,
-			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
 	struct jpu_q_data *q_data;
 	unsigned int i;
 
 	q_data = jpu_get_q_data(ctx, vq->type);
 
-	*nplanes = q_data->format.num_planes;
+	if (*nplanes) {
+		if (*nplanes != q_data->format.num_planes)
+			return -EINVAL;
 
-	for (i = 0; i < *nplanes; i++) {
-		unsigned int q_size = q_data->format.plane_fmt[i].sizeimage;
-		unsigned int f_size = fmt ?
-			fmt->fmt.pix_mp.plane_fmt[i].sizeimage : 0;
+		for (i = 0; i < *nplanes; i++) {
+			unsigned int q_size = q_data->format.plane_fmt[i].sizeimage;
 
-		if (fmt && f_size < q_size)
-			return -EINVAL;
+			if (sizes[i] < q_size)
+				return -EINVAL;
+			alloc_ctxs[i] = ctx->jpu->alloc_ctx;
+		}
+		return 0;
+	}
 
-		sizes[i] = fmt ? f_size : q_size;
+	*nplanes = q_data->format.num_planes;
+
+	for (i = 0; i < *nplanes; i++) {
+		sizes[i] = q_data->format.plane_fmt[i].sizeimage;
 		alloc_ctxs[i] = ctx->jpu->alloc_ctx;
 	}
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 537b858..68e6512 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -435,39 +435,28 @@ static void stop_streaming(struct vb2_queue *vq)
 	camif_stop_capture(vp);
 }
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *num_buffers, unsigned int *num_planes,
 		       unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_format *pfmt = parg;
-	const struct v4l2_pix_format *pix = NULL;
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
 	struct camif_dev *camif = vp->camif;
 	struct camif_frame *frame = &vp->out_frame;
-	const struct camif_fmt *fmt;
+	const struct camif_fmt *fmt = vp->out_fmt;
 	unsigned int size;
 
-	if (pfmt) {
-		pix = &pfmt->fmt.pix;
-		fmt = s3c_camif_find_format(vp, &pix->pixelformat, -1);
-		if (fmt == NULL)
-			return -EINVAL;
-		size = (pix->width * pix->height * fmt->depth) / 8;
-	} else {
-		fmt = vp->out_fmt;
-		if (fmt == NULL)
-			return -EINVAL;
-		size = (frame->f_width * frame->f_height * fmt->depth) / 8;
-	}
-
-	*num_planes = 1;
+	if (fmt == NULL)
+		return -EINVAL;
 
-	if (pix)
-		sizes[0] = max(size, pix->sizeimage);
-	else
-		sizes[0] = size;
+	size = (frame->f_width * frame->f_height * fmt->depth) / 8;
 	allocators[0] = camif->alloc_ctx;
 
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*num_planes = 1;
+	sizes[0] = size;
+
 	pr_debug("size: %u\n", sizes[0]);
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e1936d9..12b4415 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -101,7 +101,7 @@ static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
 	}
 }
 
-static int g2d_queue_setup(struct vb2_queue *vq, const void *parg,
+static int g2d_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 4a608cb..30440b0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2430,7 +2430,6 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
  */
 
 static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
-			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8c5060a..52cb687 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -888,7 +888,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 };
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const void *parg, unsigned int *buf_count,
+			unsigned int *buf_count,
 			unsigned int *plane_count, unsigned int psize[],
 			void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 5c678ec..0a09f0b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1818,7 +1818,6 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 }
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-			const void *parg,
 			unsigned int *buf_count, unsigned int *plane_count,
 			unsigned int psize[], void *allocators[])
 {
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index dc1c679..d9e7f03 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -881,7 +881,7 @@ static const struct v4l2_file_operations mxr_fops = {
 	.unlocked_ioctl = video_ioctl2,
 };
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 	unsigned int *nbuffers, unsigned int *nplanes, unsigned int sizes[],
 	void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index d6ab33e..82c39f3 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -865,32 +865,14 @@ static const struct v4l2_ioctl_ops sh_veu_ioctl_ops = {
 		/* ========== Queue operations ========== */
 
 static int sh_veu_queue_setup(struct vb2_queue *vq,
-			      const void *parg,
 			      unsigned int *nbuffers, unsigned int *nplanes,
 			      unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *f = parg;
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vq);
-	struct sh_veu_vfmt *vfmt;
-	unsigned int size, count = *nbuffers;
-
-	if (f) {
-		const struct v4l2_pix_format *pix = &f->fmt.pix;
-		const struct sh_veu_format *fmt = sh_veu_find_fmt(f);
-		struct v4l2_format ftmp = *f;
-
-		if (fmt->fourcc != pix->pixelformat)
-			return -EINVAL;
-		sh_veu_try_fmt(&ftmp, fmt);
-		if (ftmp.fmt.pix.width != pix->width ||
-		    ftmp.fmt.pix.height != pix->height)
-			return -EINVAL;
-		size = pix->bytesperline ? pix->bytesperline * pix->height * fmt->depth / fmt->ydepth :
-			pix->width * pix->height * fmt->depth / fmt->ydepth;
-	} else {
-		vfmt = sh_veu_get_vfmt(veu, vq->type);
-		size = vfmt->bytesperline * vfmt->frame.height * vfmt->fmt->depth / vfmt->fmt->ydepth;
-	}
+	struct sh_veu_vfmt *vfmt = sh_veu_get_vfmt(veu, vq->type);
+	unsigned int count = *nbuffers;
+	unsigned int size = vfmt->bytesperline * vfmt->frame.height *
+		vfmt->fmt->depth / vfmt->fmt->ydepth;
 
 	if (count < 2)
 		*nbuffers = count = 2;
@@ -900,6 +882,11 @@ static int sh_veu_queue_setup(struct vb2_queue *vq,
 		*nbuffers = count;
 	}
 
+	if (*nplanes) {
+		alloc_ctxs[0] = veu->alloc_ctx;
+		return sizes[0] < size ? -EINVAL : 0;
+	}
+
 	*nplanes = 1;
 	sizes[0] = size;
 	alloc_ctxs[0] = veu->alloc_ctx;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 2231f89..8f9394d 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -243,22 +243,21 @@ static void sh_vou_stream_config(struct sh_vou_device *vou_dev)
 }
 
 /* Locking: caller holds fop_lock mutex */
-static int sh_vou_queue_setup(struct vb2_queue *vq, const void *parg,
+static int sh_vou_queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	int bytes_per_line = vou_fmt[vou_dev->pix_idx].bpp * pix->width / 8;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	if (fmt && fmt->fmt.pix.sizeimage < pix->height * bytes_per_line)
-		return -EINVAL;
-	*nplanes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : pix->height * bytes_per_line;
 	alloc_ctxs[0] = vou_dev->alloc_ctx;
+	if (*nplanes)
+		return sizes[0] < pix->height * bytes_per_line ? -EINVAL : 0;
+	*nplanes = 1;
+	sizes[0] = pix->height * bytes_per_line;
 	return 0;
 }
 
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 454f68f..6669c2d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -245,7 +245,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 1f28d21..e30b39b 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -469,21 +469,15 @@ static void mx2_camera_clock_stop(struct soc_camera_host *ici)
  *  Videobuf operations
  */
 static int mx2_videobuf_setup(struct vb2_queue *vq,
-			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 
 	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, sizes[0]);
 
-	/* TODO: support for VIDIOC_CREATE_BUFS not ready */
-	if (fmt != NULL)
-		return -ENOTTY;
-
 	alloc_ctxs[0] = pcdev->alloc_ctx;
 
 	sizes[0] = icd->sizeimage;
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 49c3a25..a524961 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -185,11 +185,9 @@ static void mx3_cam_dma_done(void *arg)
  * Calculate the __buffer__ (not data) size and number of buffers.
  */
 static int mx3_videobuf_setup(struct vb2_queue *vq,
-			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
@@ -197,33 +195,6 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	if (fmt) {
-		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
-								fmt->fmt.pix.pixelformat);
-		unsigned int bytes_per_line;
-		int ret;
-
-		if (!xlate)
-			return -EINVAL;
-
-		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
-					      xlate->host_fmt);
-		if (ret < 0)
-			return ret;
-
-		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
-
-		ret = soc_mbus_image_size(xlate->host_fmt, bytes_per_line,
-					  fmt->fmt.pix.height);
-		if (ret < 0)
-			return ret;
-
-		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
-	} else {
-		/* Called from VIDIOC_REQBUFS or in compatibility mode */
-		sizes[0] = icd->sizeimage;
-	}
-
 	alloc_ctxs[0] = mx3_cam->alloc_ctx;
 
 	if (!vq->num_buffers)
@@ -232,9 +203,14 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	if (!*count)
 		*count = 2;
 
+	/* Called from VIDIOC_REQBUFS or in compatibility mode */
+	if (!*num_planes)
+		sizes[0] = icd->sizeimage;
+	else if (sizes[0] < icd->sizeimage)
+		return -EINVAL;
+
 	/* If *num_planes != 0, we have already verified *count. */
-	if (!*num_planes &&
-	    sizes[0] * *count + mx3_cam->buf_total > MAX_VIDEO_MEM * 1024 * 1024)
+	if (sizes[0] * *count + mx3_cam->buf_total > MAX_VIDEO_MEM * 1024 * 1024)
 		*count = (MAX_VIDEO_MEM * 1024 * 1024 - mx3_cam->buf_total) /
 			sizes[0];
 
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index efe57b2..f3a40af 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -527,46 +527,14 @@ struct rcar_vin_cam {
  * required
  */
 static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
-				   const void *parg,
 				   unsigned int *count,
 				   unsigned int *num_planes,
 				   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
 
-	if (fmt) {
-		const struct soc_camera_format_xlate *xlate;
-		unsigned int bytes_per_line;
-		int ret;
-
-		if (fmt->fmt.pix.sizeimage < icd->sizeimage)
-			return -EINVAL;
-
-		xlate = soc_camera_xlate_by_fourcc(icd,
-						   fmt->fmt.pix.pixelformat);
-		if (!xlate)
-			return -EINVAL;
-		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
-					      xlate->host_fmt);
-		if (ret < 0)
-			return ret;
-
-		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
-
-		ret = soc_mbus_image_size(xlate->host_fmt, bytes_per_line,
-					  fmt->fmt.pix.height);
-		if (ret < 0)
-			return ret;
-
-		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
-	} else {
-		/* Called from VIDIOC_REQBUFS or in compatibility mode */
-		sizes[0] = icd->sizeimage;
-	}
-
 	alloc_ctxs[0] = priv->alloc_ctx;
 
 	if (!vq->num_buffers)
@@ -576,14 +544,18 @@ static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
 		*count = 2;
 	priv->vb_count = *count;
 
-	*num_planes = 1;
-
 	/* Number of hardware slots */
 	if (is_continuous_transfer(priv))
 		priv->nr_hw_slots = MAX_BUFFER_NUM;
 	else
 		priv->nr_hw_slots = 1;
 
+	if (*num_planes)
+		return sizes[0] < icd->sizeimage ? -EINVAL : 0;
+
+	sizes[0] = icd->sizeimage;
+	*num_planes = 1;
+
 	dev_dbg(icd->parent, "count=%d, size=%u\n", *count, sizes[0]);
 
 	return 0;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 67a669d..90e4c5c 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -210,43 +210,14 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  *		  for the current frame format if required
  */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
-			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = container_of(vq,
 			struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
-	if (fmt) {
-		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
-								fmt->fmt.pix.pixelformat);
-		unsigned int bytes_per_line;
-		int ret;
-
-		if (!xlate)
-			return -EINVAL;
-
-		ret = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
-					      xlate->host_fmt);
-		if (ret < 0)
-			return ret;
-
-		bytes_per_line = max_t(u32, fmt->fmt.pix.bytesperline, ret);
-
-		ret = soc_mbus_image_size(xlate->host_fmt, bytes_per_line,
-					  fmt->fmt.pix.height);
-		if (ret < 0)
-			return ret;
-
-		sizes[0] = max_t(u32, fmt->fmt.pix.sizeimage, ret);
-	} else {
-		/* Called from VIDIOC_REQBUFS or in compatibility mode */
-		sizes[0] = icd->sizeimage;
-	}
-
 	alloc_ctxs[0] = pcdev->alloc_ctx;
 
 	if (!vq->num_buffers)
@@ -255,8 +226,14 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 	if (!*count)
 		*count = 2;
 
+	/* Called from VIDIOC_REQBUFS or in compatibility mode */
+	if (!*num_planes)
+		sizes[0] = icd->sizeimage;
+	else if (sizes[0] < icd->sizeimage)
+		return -EINVAL;
+
 	/* If *num_planes != 0, we have already verified *count. */
-	if (pcdev->video_limit && !*num_planes) {
+	if (pcdev->video_limit) {
 		size_t size = PAGE_ALIGN(sizes[0]) * *count;
 
 		if (size + pcdev->buf_total > pcdev->video_limit)
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index a0d267e..81871d6 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -438,11 +438,9 @@ static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
 }
 
 static int bdisp_queue_setup(struct vb2_queue *vq,
-			     const void *parg,
 			     unsigned int *nb_buf, unsigned int *nb_planes,
 			     unsigned int sizes[], void *allocators[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
 	struct bdisp_frame *frame = ctx_get_frame(ctx, vq->type);
 
@@ -455,13 +453,13 @@ static int bdisp_queue_setup(struct vb2_queue *vq,
 		dev_err(ctx->bdisp_dev->dev, "Invalid format\n");
 		return -EINVAL;
 	}
+	allocators[0] = ctx->bdisp_dev->alloc_ctx;
 
-	if (fmt && fmt->fmt.pix.sizeimage < frame->sizeimage)
-		return -EINVAL;
+	if (*nb_planes)
+		return sizes[0] < frame->sizeimage ? -EINVAL : 0;
 
 	*nb_planes = 1;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : frame->sizeimage;
-	allocators[0] = ctx->bdisp_dev->alloc_ctx;
+	sizes[0] = frame->sizeimage;
 
 	return 0;
 }
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index de24eff..e8ed265 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1796,7 +1796,6 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
  * Queue operations
  */
 static int vpe_queue_setup(struct vb2_queue *vq,
-			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e18fb9f..93e1d25 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -710,11 +710,9 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
  */
 
 static int vim2m_queue_setup(struct vb2_queue *vq,
-				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vq);
 	struct vim2m_q_data *q_data;
 	unsigned int size, count = *nbuffers;
@@ -723,17 +721,14 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 
 	size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
 
-	if (fmt) {
-		if (fmt->fmt.pix.sizeimage < size)
-			return -EINVAL;
-		size = fmt->fmt.pix.sizeimage;
-	}
-
 	while (size * count > MEM2MEM_VID_MEM_LIMIT)
 		(count)--;
+	*nbuffers = count;
+
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 
 	*nplanes = 1;
-	*nbuffers = count;
 	sizes[0] = size;
 
 	/*
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 082c401..6eeeff9 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -213,7 +213,7 @@ static int vivid_thread_sdr_cap(void *data)
 	return 0;
 }
 
-static int sdr_cap_queue_setup(struct vb2_queue *vq, const void *parg,
+static int sdr_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index e903d02..d6d12e1 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -137,7 +137,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
 	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
-static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
+static int vbi_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 75c5709..3c5a469 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -27,7 +27,7 @@
 #include "vivid-vbi-out.h"
 #include "vivid-vbi-cap.h"
 
-static int vbi_out_queue_setup(struct vb2_queue *vq, const void *parg,
+static int vbi_out_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index ef54123..80d4741 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -95,11 +95,10 @@ static const struct v4l2_discrete_probe webcam_probe = {
 	VIVID_WEBCAM_SIZES
 };
 
-static int vid_cap_queue_setup(struct vb2_queue *vq, const void *parg,
+static int vid_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	unsigned buffers = tpg_g_buffers(&dev->tpg);
 	unsigned h = dev->fmt_cap_rect.height;
@@ -122,27 +121,16 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		dev->queue_setup_error = false;
 		return -EINVAL;
 	}
-	if (fmt) {
-		const struct v4l2_pix_format_mplane *mp;
-		struct v4l2_format mp_fmt;
-		const struct vivid_fmt *vfmt;
-
-		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
-			fmt_sp2mp(fmt, &mp_fmt);
-			fmt = &mp_fmt;
-		}
-		mp = &fmt->fmt.pix_mp;
+	if (*nplanes) {
 		/*
-		 * Check if the number of planes in the specified format match
+		 * Check if the number of requested planes match
 		 * the number of buffers in the current format. You can't mix that.
 		 */
-		if (mp->num_planes != buffers)
+		if (*nplanes != buffers)
 			return -EINVAL;
-		vfmt = vivid_get_format(dev, mp->pixelformat);
 		for (p = 0; p < buffers; p++) {
-			sizes[p] = mp->plane_fmt[p].sizeimage;
 			if (sizes[p] < tpg_g_line_width(&dev->tpg, p) * h +
-							vfmt->data_offset[p])
+						dev->fmt_cap->data_offset[p])
 				return -EINVAL;
 		}
 	} else {
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index b77acb6..0abbbe9 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -31,11 +31,10 @@
 #include "vivid-kthread-out.h"
 #include "vivid-vid-out.h"
 
-static int vid_out_queue_setup(struct vb2_queue *vq, const void *parg,
+static int vid_out_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	const struct vivid_fmt *vfmt = dev->fmt_out;
 	unsigned planes = vfmt->buffers;
@@ -64,26 +63,16 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const void *parg,
 		return -EINVAL;
 	}
 
-	if (fmt) {
-		const struct v4l2_pix_format_mplane *mp;
-		struct v4l2_format mp_fmt;
-
-		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
-			fmt_sp2mp(fmt, &mp_fmt);
-			fmt = &mp_fmt;
-		}
-		mp = &fmt->fmt.pix_mp;
+	if (*nplanes) {
 		/*
-		 * Check if the number of planes in the specified format match
+		 * Check if the number of requested planes match
 		 * the number of planes in the current format. You can't mix that.
 		 */
-		if (mp->num_planes != planes)
+		if (*nplanes != planes)
 			return -EINVAL;
-		sizes[0] = mp->plane_fmt[0].sizeimage;
 		if (sizes[0] < size)
 			return -EINVAL;
 		for (p = 1; p < planes; p++) {
-			sizes[p] = mp->plane_fmt[p].sizeimage;
 			if (sizes[p] < dev->bytesperline_out[p] * h)
 				return -EINVAL;
 		}
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 5ce88e1..1eebf58 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -274,35 +274,6 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	return 0;
 }
 
-static bool
-vsp1_video_format_adjust(struct vsp1_video *video,
-			 const struct v4l2_pix_format_mplane *format,
-			 struct v4l2_pix_format_mplane *adjust)
-{
-	unsigned int i;
-
-	*adjust = *format;
-	__vsp1_video_try_format(video, adjust, NULL);
-
-	if (format->width != adjust->width ||
-	    format->height != adjust->height ||
-	    format->pixelformat != adjust->pixelformat ||
-	    format->num_planes != adjust->num_planes)
-		return false;
-
-	for (i = 0; i < format->num_planes; ++i) {
-		if (format->plane_fmt[i].bytesperline !=
-		    adjust->plane_fmt[i].bytesperline)
-			return false;
-
-		adjust->plane_fmt[i].sizeimage =
-			max(adjust->plane_fmt[i].sizeimage,
-			    format->plane_fmt[i].sizeimage);
-	}
-
-	return true;
-}
-
 /* -----------------------------------------------------------------------------
  * Pipeline Management
  */
@@ -787,26 +758,24 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
  */
 
 static int
-vsp1_video_queue_setup(struct vb2_queue *vq, const void *parg,
+vsp1_video_queue_setup(struct vb2_queue *vq,
 		     unsigned int *nbuffers, unsigned int *nplanes,
 		     unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
-	const struct v4l2_pix_format_mplane *format;
-	struct v4l2_pix_format_mplane pix_mp;
+	const struct v4l2_pix_format_mplane *format = &video->format;
 	unsigned int i;
 
-	if (fmt) {
-		/* Make sure the format is valid and adjust the sizeimage field
-		 * if needed.
-		 */
-		if (!vsp1_video_format_adjust(video, &fmt->fmt.pix_mp, &pix_mp))
+	if (*nplanes) {
+		if (*nplanes != format->num_planes)
 			return -EINVAL;
 
-		format = &pix_mp;
-	} else {
-		format = &video->format;
+		for (i = 0; i < *nplanes; i++) {
+			if (sizes[i] < format->plane_fmt[i].sizeimage)
+				return -EINVAL;
+			alloc_ctxs[i] = video->alloc_ctx;
+		}
+		return 0;
 	}
 
 	*nplanes = format->num_planes;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d11cc70..8532cab 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -309,21 +309,19 @@ static void xvip_dma_complete(void *param)
 }
 
 static int
-xvip_dma_queue_setup(struct vb2_queue *vq, const void *parg,
+xvip_dma_queue_setup(struct vb2_queue *vq,
 		     unsigned int *nbuffers, unsigned int *nplanes,
 		     unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct xvip_dma *dma = vb2_get_drv_priv(vq);
 
+	alloc_ctxs[0] = dma->alloc_ctx;
 	/* Make sure the image size is large enough. */
-	if (fmt && fmt->fmt.pix.sizeimage < dma->format.sizeimage)
-		return -EINVAL;
+	if (*nplanes)
+		return sizes[0] < dma->format.sizeimage ? -EINVAL : 0;
 
 	*nplanes = 1;
-
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : dma->format.sizeimage;
-	alloc_ctxs[0] = dma->alloc_ctx;
+	sizes[0] = dma->format.sizeimage;
 
 	return 0;
 }
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index fcbb497..518d511 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -488,7 +488,7 @@ static void airspy_disconnect(struct usb_interface *intf)
 
 /* Videobuf2 operations */
 static int airspy_queue_setup(struct vb2_queue *vq,
-		const void *parg, unsigned int *nbuffers,
+		unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 130c8b4..b4efc10 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -30,23 +30,17 @@
 
 /* ------------------------------------------------------------------ */
 
-static int vbi_queue_setup(struct vb2_queue *vq, const void *parg,
+static int vbi_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
-	unsigned long img_size = dev->vbi_width * dev->vbi_height * 2;
-	unsigned long size;
-
-	size = fmt ? (fmt->fmt.vbi.samples_per_line *
-		(fmt->fmt.vbi.count[0] + fmt->fmt.vbi.count[1])) : img_size;
-	if (size < img_size)
-		return -EINVAL;
+	unsigned long size = dev->vbi_width * dev->vbi_height * 2;
 
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
 	sizes[0] = size;
-
 	return 0;
 }
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 45c622e..427d58e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -638,19 +638,15 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
-	unsigned long img_size = dev->height * dev->bytesperline;
-	unsigned long size;
-
-	size = fmt ? fmt->fmt.pix.sizeimage : img_size;
-	if (size < img_size)
-		return -EINVAL;
+	unsigned long size = dev->height * dev->bytesperline;
 
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
 	sizes[0] = size;
 
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index e23c285..fe94c92 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -31,26 +31,22 @@
 
 /* ------------------------------------------------------------------ */
 
-static int vbi_queue_setup(struct vb2_queue *vq, const void *parg,
+static int vbi_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
-	unsigned long size;
+	unsigned long size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
-	if (fmt)
-		size = fmt->fmt.pix.sizeimage;
-	else
-		size = v4l2->vbi_width * v4l2->vbi_height * 2;
-
-	if (0 == *nbuffers)
-		*nbuffers = 32;
 	if (*nbuffers < 2)
 		*nbuffers = 2;
-	if (*nbuffers > 32)
-		*nbuffers = 32;
+
+	if (*nplanes) {
+		if (sizes[0] < size)
+			return -EINVAL;
+		size = sizes[0];
+	}
 
 	*nplanes = 1;
 	sizes[0] = size;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6a3cf34..887fd25 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -871,30 +871,19 @@ static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
 	Videobuf2 operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
-	unsigned long size;
-
-	if (fmt)
-		size = fmt->fmt.pix.sizeimage;
-	else
-		size =
+	unsigned long size =
 		    (v4l2->width * v4l2->height * v4l2->format->depth + 7) >> 3;
 
-	if (size == 0)
-		return -EINVAL;
-
-	if (0 == *nbuffers)
-		*nbuffers = 32;
-
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
 	sizes[0] = size;
-
 	return 0;
 }
 
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index f3d187d..8da28c8 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -369,7 +369,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int go7007_queue_setup(struct vb2_queue *q,
-		const void *parg,
 		unsigned int *num_buffers, unsigned int *num_planes,
 		unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e05bfec..d0c416d 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -750,7 +750,7 @@ static void hackrf_return_all_buffers(struct vb2_queue *vq,
 }
 
 static int hackrf_queue_setup(struct vb2_queue *vq,
-		const void *parg, unsigned int *nbuffers,
+		unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index e06a21a..c104315 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -616,7 +616,6 @@ static int msi2500_querycap(struct file *file, void *fh,
 
 /* Videobuf2 operations */
 static int msi2500_queue_setup(struct vb2_queue *vq,
-			       const void *parg,
 			       unsigned int *nbuffers,
 			       unsigned int *nplanes, unsigned int sizes[],
 			       void *alloc_ctxs[])
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index b79c36f..e90e494 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -571,7 +571,7 @@ static void pwc_video_release(struct v4l2_device *v)
 /***************************************************************************/
 /* Videobuf2 operations */
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index e7acb12..82bdd42 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -660,7 +660,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
    Videobuf operations
    ------------------------------------------------------------------*/
 
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 0bd34f1..3a9a296 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -664,7 +664,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 /*
  * Videobuf2 operations
  */
-static int queue_setup(struct vb2_queue *vq, const void *parg,
+static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index e645c9d..05cbd2f 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -599,19 +599,18 @@ static struct v4l2_file_operations usbtv_fops = {
 };
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
-	const void *parg, unsigned int *nbuffers,
+	unsigned int *nbuffers,
 	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
 	unsigned size = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
-	if (fmt && fmt->fmt.pix.sizeimage < size)
-		return -EINVAL;
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
+	sizes[0] = size;
 
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cfb868a..5439472 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -69,23 +69,19 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
  * videobuf2 queue operations
  */
 
-static int uvc_queue_setup(struct vb2_queue *vq, const void *parg,
+static int uvc_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	const struct v4l2_format *fmt = parg;
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
+	unsigned size = stream->ctrl.dwMaxVideoFrameSize;
 
 	/* Make sure the image size is large enough. */
-	if (fmt && fmt->fmt.pix.sizeimage < stream->ctrl.dwMaxVideoFrameSize)
-		return -EINVAL;
-
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
-
-	sizes[0] = fmt ? fmt->fmt.pix.sizeimage
-		 : stream->ctrl.dwMaxVideoFrameSize;
-
+	sizes[0] = size;
 	return 0;
 }
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 33bdd81..ebce7c7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -621,7 +621,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 * Ask the driver how many buffers and planes per buffer it requires.
 	 * Driver also sets the size and allocator context for each plane.
 	 */
-	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
+	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
 		       q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
@@ -646,8 +646,15 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 */
 	if (!ret && allocated_buffers < num_buffers) {
 		num_buffers = allocated_buffers;
+		/*
+		 * num_planes is set by the previous queue_setup(), but since it
+		 * signals to queue_setup() whether it is called from create_bufs()
+		 * vs reqbufs() we zero it here to signal that queue_setup() is
+		 * called for the reqbufs() case.
+		 */
+		num_planes = 0;
 
-		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
+		ret = call_qop(q, queue_setup, q, &num_buffers,
 			       &num_planes, q->plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
@@ -701,7 +708,8 @@ EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
  * from vidioc_create_bufs handler in driver.
  */
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
-		unsigned int *count, const void *parg)
+		unsigned int *count, unsigned requested_planes,
+		const unsigned requested_sizes[])
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	int ret;
@@ -720,11 +728,16 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 
 	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
 
+	if (requested_planes && requested_sizes) {
+		num_planes = requested_planes;
+		memcpy(q->plane_sizes, requested_sizes, sizeof(q->plane_sizes));
+	}
+
 	/*
 	 * Ask the driver, whether the requested number of buffers, planes per
 	 * buffer and their sizes are acceptable
 	 */
-	ret = call_qop(q, queue_setup, q, parg, &num_buffers,
+	ret = call_qop(q, queue_setup, q, &num_buffers,
 		       &num_planes, q->plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
@@ -747,7 +760,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		 * q->num_buffers contains the total number of buffers, that the
 		 * queue driver has set up
 		 */
-		ret = call_qop(q, queue_setup, q, parg, &num_buffers,
+		ret = call_qop(q, queue_setup, q, &num_buffers,
 			       &num_planes, q->plane_sizes, q->alloc_ctx);
 
 		if (!ret && allocated_buffers < num_buffers)
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 27b4b9e..dda525b 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -525,14 +525,52 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
  */
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 {
-	int ret = vb2_verify_memory_type(q, create->memory,
-			create->format.type);
+	unsigned requested_planes = 1;
+	unsigned requested_sizes[VIDEO_MAX_PLANES];
+	struct v4l2_format *f = &create->format;
+	int ret = vb2_verify_memory_type(q, create->memory, f->type);
+	unsigned i;
 
 	create->index = q->num_buffers;
 	if (create->count == 0)
 		return ret != -EBUSY ? ret : 0;
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		requested_planes = f->fmt.pix_mp.num_planes;
+		if (requested_planes == 0 ||
+		    requested_planes > VIDEO_MAX_PLANES)
+			return -EINVAL;
+		for (i = 0; i < requested_planes; i++)
+			requested_sizes[i] =
+				f->fmt.pix_mp.plane_fmt[i].sizeimage;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		requested_sizes[0] = f->fmt.pix.sizeimage;
+		break;
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		requested_sizes[0] = f->fmt.vbi.samples_per_line *
+			(f->fmt.vbi.count[0] + f->fmt.vbi.count[1]);
+		break;
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+		requested_sizes[0] = f->fmt.sliced.io_size;
+		break;
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+	case V4L2_BUF_TYPE_SDR_OUTPUT:
+		requested_sizes[0] = f->fmt.sdr.buffersize;
+		break;
+	default:
+		return -EINVAL;
+	}
+	for (i = 0; i < requested_planes; i++)
+		if (requested_sizes[i] == 0)
+			return -EINVAL;
 	return ret ? ret : vb2_core_create_bufs(q, create->memory,
-		&create->count, &create->format);
+		&create->count, requested_planes, requested_sizes);
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
@@ -1440,8 +1478,8 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	res = vb2_core_create_bufs(vdev->queue, p->memory, &p->count,
-			&p->format);
+
+	res = vb2_create_bufs(vdev->queue, p);
 	if (res == 0)
 		vdev->queue->owner = file->private_data;
 	return res;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 0fdff91..77b4fc6 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1078,7 +1078,7 @@ vpfe_g_dv_timings(struct file *file, void *fh,
  * the buffer nbuffers and buffer size
  */
 static int
-vpfe_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
+vpfe_buffer_queue_setup(struct vb2_queue *vq,
 			unsigned int *nbuffers, unsigned int *nplanes,
 			unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 28c067d..e3c7ddd 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -288,7 +288,6 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
  */
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
-				 const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
 				 unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 51d4a17..f592198 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -41,7 +41,7 @@
  * videobuf2 queue operations
  */
 
-static int uvc_queue_setup(struct vb2_queue *vq, const void *parg,
+static int uvc_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 647ebfe..b47d1e2 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -268,21 +268,26 @@ struct vb2_buffer {
  * struct vb2_ops - driver-specific callbacks
  *
  * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
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
+ *			handlers before memory allocation. It can be called
+ *			twice: if the original number of requested buffers
+ *			could not be allocated, then it will be called a
+ *			second time with the actually allocated number of
+ *			buffers to verify if that is OK.
+ *			The driver should return the required number of buffers
+ *			in *num_buffers, the required number of planes per
+ *			buffer in *num_planes, the size of each plane should be
+ *			set in the sizes[] array and optional per-plane
+ *			allocator specific context in the alloc_ctxs[] array.
+ *			When called from VIDIOC_REQBUFS, *num_planes == 0, the
+ *			driver has to use the currently configured format to
+ *			determine the plane sizes and *num_buffers is the total
+ *			number of buffers that are being allocated. When called
+ *			from VIDIOC_CREATE_BUFS, *num_planes != 0 and it
+ *			describes the requested number of planes and sizes[]
+ *			contains the requested plane sizes. If either
+ *			*num_planes or the requested sizes are invalid callback
+ *			must return -EINVAL. In this case *num_buffers are
+ *			being allocated additionally to q->num_buffers.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
  *			buffer to arrive; required to avoid a deadlock in
@@ -344,7 +349,7 @@ struct vb2_buffer {
  *			pre-queued buffers before calling STREAMON.
  */
 struct vb2_ops {
-	int (*queue_setup)(struct vb2_queue *q, const void *parg,
+	int (*queue_setup)(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
 
@@ -507,7 +512,8 @@ int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count);
 int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
-		unsigned int *count, const void *parg);
+		unsigned int *count, unsigned requested_planes,
+		const unsigned int requested_sizes[]);
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
 int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking);
-- 
2.1.4


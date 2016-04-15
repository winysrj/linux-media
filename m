Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44792 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbcDONEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 09:04:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv2 12/12] vb2: replace void *alloc_ctxs by struct device *alloc_devs
Date: Fri, 15 Apr 2016 15:03:56 +0200
Message-Id: <1460725436-20045-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
References: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make this a proper typed array. Drop the old allocate context code since
that is no longer used.

Note that the memops functions now get a struct device pointer instead of
the struct device ** that was there initially (actually a void pointer to
a struct containing only a struct device pointer).

This code is now a lot cleaner.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c      |  2 +-
 drivers/input/touchscreen/sur40.c                  |  2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |  2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |  2 +-
 drivers/media/pci/cx88/cx88-video.c                |  2 +-
 drivers/media/pci/dt3155/dt3155.c                  |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  2 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |  2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
 drivers/media/pci/saa7134/saa7134.h                |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  2 +-
 drivers/media/pci/tw68/tw68-video.c                |  2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |  4 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  2 +-
 drivers/media/platform/coda/coda-common.c          |  2 +-
 drivers/media/platform/davinci/vpbe_display.c      |  2 +-
 drivers/media/platform/davinci/vpif_capture.c      |  4 +-
 drivers/media/platform/davinci/vpif_display.c      |  4 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |  1 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
 drivers/media/platform/m2m-deinterlace.c           |  2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  2 +-
 drivers/media/platform/mx2_emmaprp.c               |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  2 +-
 drivers/media/platform/rcar_jpu.c                  |  2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |  2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 10 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 12 +++---
 drivers/media/platform/s5p-tv/mixer_video.c        |  2 +-
 drivers/media/platform/sh_veu.c                    |  2 +-
 drivers/media/platform/sh_vou.c                    |  2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |  2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  2 +-
 drivers/media/platform/ti-vpe/cal.c                |  2 +-
 drivers/media/platform/ti-vpe/vpe.c                |  2 +-
 drivers/media/platform/vim2m.c                     |  7 +---
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  7 +---
 drivers/media/platform/vivid/vivid-vid-out.c       |  7 +---
 drivers/media/platform/vsp1/vsp1_video.c           |  4 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  2 +-
 drivers/media/usb/airspy/airspy.c                  |  2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |  2 +-
 drivers/media/usb/au0828/au0828-video.c            |  2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |  2 +-
 drivers/media/usb/hackrf/hackrf.c                  |  2 +-
 drivers/media/usb/msi2500/msi2500.c                |  2 +-
 drivers/media/usb/pwc/pwc-if.c                     |  2 +-
 drivers/media/usb/s2255/s2255drv.c                 |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 20 ++++-----
 drivers/media/v4l2-core/videobuf2-dma-contig.c     | 49 ++++------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c         | 45 ++++----------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |  9 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  4 +-
 drivers/staging/media/mx2/mx2_camera.c             |  2 +-
 drivers/staging/media/mx3/mx3_camera.c             |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  2 +-
 drivers/usb/gadget/function/uvc_queue.c            |  2 +-
 include/media/videobuf2-core.h                     | 23 +++++-----
 include/media/videobuf2-dma-contig.h               | 10 -----
 include/media/videobuf2-dma-sg.h                   |  3 --
 87 files changed, 138 insertions(+), 223 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 5f91d76..93b76c3 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -163,7 +163,7 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
  */
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct skeleton *skel = vb2_get_drv_priv(vq);
 
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index cc4bd3e..f124f3a 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -645,7 +645,7 @@ static void sur40_disconnect(struct usb_interface *interface)
  */
 static int sur40_queue_setup(struct vb2_queue *q,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	if (q->num_buffers + *nbuffers < 3)
 		*nbuffers = 3 - q->num_buffers;
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index b860f02..dfe2667 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -491,7 +491,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 /* Videobuf2 operations */
 static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 		unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int *nplanes, unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 	struct platform_device *pdev = dev->pdev;
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 6c19cdf..d05672f 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -45,7 +45,7 @@ static const struct v4l2_dv_timings cea1080p60 = V4L2_DV_BT_CEA_1920X1080P60;
 
 static int cobalt_queue_setup(struct vb2_queue *q,
 			unsigned int *num_buffers, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cobalt_stream *s = q->drv_priv;
 	unsigned size = s->stride * s->height;
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 0174d08..efec2d1 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1140,7 +1140,7 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx23885_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 6ad07f5..95aaa2e 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -94,7 +94,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx23885_tsport *port = q->drv_priv;
 
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 2de9485..75e7fa7 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -122,7 +122,7 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx23885_dev *dev = q->drv_priv;
 	unsigned lines = VBI_PAL_LINE_COUNT;
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 3ff86d6..6d73522 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -335,7 +335,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx23885_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 45fc23e..adcd09b 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -143,7 +143,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 
 static int cx25821_queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx25821_channel *chan = q->drv_priv;
 	unsigned size = (chan->fmt->depth * chan->width * chan->height) >> 3;
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 7c026c1c..04fe9af 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -639,7 +639,7 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8802_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 4d91d16..5bb63e7 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -84,7 +84,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8802_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 2479f7d..d3237cf 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -109,7 +109,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 9764d6f..5dc1e3f 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -431,7 +431,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
 	struct cx88_core *core = dev->core;
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index ec8f58a..6a21969 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -133,7 +133,7 @@ static int wait_i2c_reg(void __iomem *addr)
 static int
 dt3155_queue_setup(struct vb2_queue *vq,
 		unsigned int *nbuffers, unsigned int *num_planes,
-		unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int sizes[], struct device *alloc_devs[])
 
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 2b667b3..fd6443d 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -280,7 +280,7 @@ static int netup_unidvb_queue_setup(struct vb2_queue *vq,
 				    unsigned int *nbuffers,
 				    unsigned int *nplanes,
 				    unsigned int sizes[],
-				    void *alloc_ctxs[])
+				    struct device *alloc_devs[])
 {
 	struct netup_dma *dma = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 8c68a93..7eaf36a 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
 int saa7134_ts_queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct saa7134_dmaqueue *dmaq = q->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index e9bffb3..cf9a31e 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -140,7 +140,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct saa7134_dmaqueue *dmaq = q->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 965ade7..8a6ebd0 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -963,7 +963,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 
 static int queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct saa7134_dmaqueue *dmaq = q->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 41c0158..3849083 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -853,7 +853,7 @@ int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
 int saa7134_ts_queue_setup(struct vb2_queue *q,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[]);
+			   unsigned int sizes[], struct device *alloc_devs[]);
 int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
 void saa7134_ts_stop_streaming(struct vb2_queue *vq);
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index f48ef33..8b1cde5 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -664,7 +664,7 @@ static int solo_ring_thread(void *data)
 static int solo_enc_queue_setup(struct vb2_queue *q,
 				unsigned int *num_buffers,
 				unsigned int *num_planes, unsigned int sizes[],
-				void *alloc_ctxs[])
+				struct device *alloc_devs[])
 {
 	sizes[0] = FRAME_BUF_SIZE;
 	*num_planes = 1;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 56affad..5a66176 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -315,7 +315,7 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 
 static int solo_queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 7f201c3..963e0dd 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -265,7 +265,7 @@ static void vip_active_buf_next(struct sta2x11_vip *vip)
 /* Videobuf2 Operations */
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index c675f9a..5e82128 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -378,7 +378,7 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
 
 static int tw68_queue_setup(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct tw68_dev *dev = vb2_get_drv_priv(q);
 	unsigned tot_bufs = q->num_buffers + *num_buffers;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index d22b09d..b33b9e3 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1901,14 +1901,14 @@ static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
- * @alloc_ctxs: ptr to allocation context
+ * @alloc_devs: ptr to allocation context
  *
  * This callback function is called when reqbuf() is called to adjust
  * the buffer count and buffer size
  */
 static int vpfe_queue_setup(struct vb2_queue *vq,
 			    unsigned int *nbuffers, unsigned int *nplanes,
-			    unsigned int sizes[], void *alloc_ctxs[])
+			    unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
 	unsigned size = vpfe->fmt.fmt.pix.sizeimage;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 1e244287..8eb0339 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -201,7 +201,7 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 
 static int bcap_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 3d57c35..3e9b7c8 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1139,7 +1139,7 @@ static void set_default_params(struct coda_ctx *ctx)
  */
 static int coda_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
 	struct coda_q_data *q_data;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 2a4c291..0b1709e 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -230,7 +230,7 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 static int
 vpbe_buffer_queue_setup(struct vb2_queue *vq,
 			unsigned int *nbuffers, unsigned int *nplanes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_devs[])
 
 {
 	/* Get the file handle object and layer object */
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d5afab0..5104cc0 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -107,14 +107,14 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
- * @alloc_ctxs: ptr to allocation context
+ * @alloc_devs: ptr to allocation context
  *
  * This callback function is called when reqbuf() is called to adjust
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5d77884..75b2723 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -102,14 +102,14 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
- * @alloc_ctxs: ptr to allocation context
+ * @alloc_devs: ptr to allocation context
  *
  * This callback function is called when reqbuf() is called to adjust
  * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 5c48329..7ad7b9d 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -327,7 +327,6 @@ struct gsc_driverdata {
  * @irq_queue:	interrupt handler waitqueue
  * @m2m:	memory-to-memory V4L2 device information
  * @state:	flags used to synchronize m2m and capture mode operation
- * @alloc_ctx:	videobuf2 memory allocator context
  * @vdev:	video device for G-Scaler instance
  */
 struct gsc_dev {
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 622709c..ec6494c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -213,7 +213,7 @@ put_device:
 
 static int gsc_m2m_queue_setup(struct vb2_queue *vq,
 			unsigned int *num_buffers, unsigned int *num_planes,
-			unsigned int sizes[], void *allocators[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
 	struct gsc_frame *frame;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 512b254..fdec499 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -340,7 +340,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *num_buffers, unsigned int *num_planes,
-		       unsigned int sizes[], void *allocators[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct fimc_ctx *ctx = vq->drv_priv;
 	struct fimc_frame *frame = &ctx->d_frame;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index abc3389..400ce0c 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -40,7 +40,7 @@
 
 static int isp_video_capture_queue_setup(struct vb2_queue *vq,
 			unsigned int *num_buffers, unsigned int *num_planes,
-			unsigned int sizes[], void *allocators[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct fimc_isp *isp = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format_mplane *vid_fmt = &isp->video_capture.pixfmt;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index b2d3f98..26ede15 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -357,7 +357,7 @@ static void stop_streaming(struct vb2_queue *q)
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *num_buffers, unsigned int *num_planes,
-		       unsigned int sizes[], void *allocators[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct fimc_lite *fimc = vq->drv_priv;
 	struct flite_frame *frame = &fimc->out_frame;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 365f06e..94fda34 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -178,7 +178,7 @@ static void fimc_job_abort(void *priv)
 
 static int fimc_queue_setup(struct vb2_queue *vq,
 			    unsigned int *num_buffers, unsigned int *num_planes,
-			    unsigned int sizes[], void *allocators[])
+			    unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
 	struct fimc_frame *f;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 15110ea..0fcb5c78 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -798,7 +798,7 @@ struct vb2_dc_conf {
 
 static int deinterlace_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vq);
 	struct deinterlace_q_data *q_data;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 8a1f12d..9171174 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1051,7 +1051,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
 static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		unsigned int *nbufs,
 		unsigned int *num_planes, unsigned int sizes[],
-		void *alloc_ctxs[])
+		struct device *alloc_devs[])
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 88b3d98..c639406 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -689,7 +689,7 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
  */
 static int emmaprp_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vq);
 	struct emmaprp_q_data *q_data;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 486b875..7d9f359 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -331,7 +331,7 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
 
 static int isp_video_queue_setup(struct vb2_queue *queue,
 				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], void *alloc_ctxs[])
+				 unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct isp_video_fh *vfh = vb2_get_drv_priv(queue);
 	struct isp_video *video = vfh->video;
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index d81c410..16782ce 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1014,7 +1014,7 @@ error_free:
  */
 static int jpu_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
 	struct jpu_q_data *q_data;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 5eb5df1..0413a86 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -437,7 +437,7 @@ static void stop_streaming(struct vb2_queue *vq)
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *num_buffers, unsigned int *num_planes,
-		       unsigned int sizes[], void *allocators[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
 	struct camif_frame *frame = &vp->out_frame;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 485eb7b..cfca740 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -103,7 +103,7 @@ static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
 
 static int g2d_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct g2d_ctx *ctx = vb2_get_drv_priv(vq);
 	struct g2d_frame *f = get_frame(ctx, vq->type);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index b481307..654f374 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2436,7 +2436,7 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
 
 static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
 	struct s5p_jpeg_q_data *q_data = NULL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 7e7c11c..e9f59ac 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -890,7 +890,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			unsigned int *buf_count,
 			unsigned int *plane_count, unsigned int psize[],
-			void *allocators[])
+			struct device *alloc_devs[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -931,14 +931,14 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev))
-			allocators[0] = &ctx->dev->mem_dev_l;
+			alloc_devs[0] = ctx->dev->mem_dev_l;
 		else
-			allocators[0] = &ctx->dev->mem_dev_r;
-		allocators[1] = &ctx->dev->mem_dev_l;
+			alloc_devs[0] = ctx->dev->mem_dev_r;
+		alloc_devs[1] = ctx->dev->mem_dev_l;
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
 		psize[0] = ctx->dec_src_buf_size;
-		allocators[0] = &ctx->dev->mem_dev_l;
+		alloc_devs[0] = ctx->dev->mem_dev_l;
 	} else {
 		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 0314c78..7819bf9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1817,7 +1817,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			unsigned int *buf_count, unsigned int *plane_count,
-			unsigned int psize[], void *allocators[])
+			unsigned int psize[], struct device *alloc_devs[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -1837,7 +1837,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->enc_dst_buf_size;
-		allocators[0] = &ctx->dev->mem_dev_l;
+		alloc_devs[0] = ctx->dev->mem_dev_l;
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->src_fmt)
 			*plane_count = ctx->src_fmt->num_planes;
@@ -1853,11 +1853,11 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev)) {
-			allocators[0] = &ctx->dev->mem_dev_l;
-			allocators[1] = &ctx->dev->mem_dev_l;
+			alloc_devs[0] = ctx->dev->mem_dev_l;
+			alloc_devs[1] = ctx->dev->mem_dev_l;
 		} else {
-			allocators[0] = &ctx->dev->mem_dev_r;
-			allocators[1] = &ctx->dev->mem_dev_r;
+			alloc_devs[0] = ctx->dev->mem_dev_r;
+			alloc_devs[1] = ctx->dev->mem_dev_r;
 		}
 	} else {
 		mfc_err("invalid queue type: %d\n", vq->type);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 95c6e99..8a7e6c8 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -871,7 +871,7 @@ static const struct v4l2_file_operations mxr_fops = {
 
 static int queue_setup(struct vb2_queue *vq,
 	unsigned int *nbuffers, unsigned int *nplanes, unsigned int sizes[],
-	void *alloc_ctxs[])
+	struct device *alloc_devs[])
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
 	const struct mxr_format *fmt = layer->fmt;
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index afd21c9..15a562a 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -865,7 +865,7 @@ static const struct v4l2_ioctl_ops sh_veu_ioctl_ops = {
 
 static int sh_veu_queue_setup(struct vb2_queue *vq,
 			      unsigned int *nbuffers, unsigned int *nplanes,
-			      unsigned int sizes[], void *alloc_ctxs[])
+			      unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vq);
 	struct sh_veu_vfmt *vfmt = sh_veu_get_vfmt(veu, vq->type);
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 59830a4..e1f39b4 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -244,7 +244,7 @@ static void sh_vou_stream_config(struct sh_vou_device *vou_dev)
 /* Locking: caller holds fop_lock mutex */
 static int sh_vou_queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
 	struct v4l2_pix_format *pix = &vou_dev->pix;
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 899b93a..30211f6 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -303,7 +303,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
    ------------------------------------------------------------------*/
 static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index dadc5b3..9c13752 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -533,7 +533,7 @@ struct rcar_vin_cam {
 static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
 				   unsigned int *count,
 				   unsigned int *num_planes,
-				   unsigned int sizes[], void *alloc_ctxs[])
+				   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 8f87fbe..02b519d 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -210,7 +210,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index b3e8b5a..3b1ac68 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -439,7 +439,7 @@ static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
 
 static int bdisp_queue_setup(struct vb2_queue *vq,
 			     unsigned int *nb_buf, unsigned int *nb_planes,
-			     unsigned int sizes[], void *alloc_ctxs[])
+			     unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
 	struct bdisp_frame *frame = ctx_get_frame(ctx, vq->type);
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 51ebf32..e967fcf 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1225,7 +1225,7 @@ static int cal_enum_frameintervals(struct file *file, void *priv,
  */
 static int cal_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cal_ctx *ctx = vb2_get_drv_priv(vq);
 	unsigned size = ctx->v_fmt.fmt.pix.sizeimage;
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 3fefd8a..55a1458 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1796,7 +1796,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
  */
 static int vpe_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	int i;
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vq);
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index c4b5fab..6b17015 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -711,7 +711,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 
 static int vim2m_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vq);
 	struct vim2m_q_data *q_data;
@@ -731,11 +731,6 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = size;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
-
 	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
 
 	return 0;
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 3d1604c..2dcdff1 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -215,7 +215,7 @@ static int vivid_thread_sdr_cap(void *data)
 
 static int sdr_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_devs[])
 {
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = SDR_CAP_SAMPLES_PER_BUF * 2;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index cda45a5..d66ef95 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -137,7 +137,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
 
 static int vbi_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_devs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 3c5a469..d298919 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -29,7 +29,7 @@
 
 static int vbi_out_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_devs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	bool is_60hz = dev->std_out & V4L2_STD_525_60;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index b84f081..6647ddc 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -97,7 +97,7 @@ static const struct v4l2_discrete_probe webcam_probe = {
 
 static int vid_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_devs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	unsigned buffers = tpg_g_buffers(&dev->tpg);
@@ -144,11 +144,6 @@ static int vid_cap_queue_setup(struct vb2_queue *vq,
 
 	*nplanes = buffers;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
-
 	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
 	for (p = 0; p < buffers; p++)
 		dprintk(dev, 1, "%s: size[%u]=%u\n", __func__, p, sizes[p]);
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 64e4d66..6190d4d 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -33,7 +33,7 @@
 
 static int vid_out_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_devs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	const struct vivid_fmt *vfmt = dev->fmt_out;
@@ -86,11 +86,6 @@ static int vid_out_queue_setup(struct vb2_queue *vq,
 
 	*nplanes = planes;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
-
 	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
 	for (p = 0; p < planes; p++)
 		dprintk(dev, 1, "%s: size[%u]=%u\n", __func__, p, sizes[p]);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 2504bae..424a541 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -519,8 +519,8 @@ static void vsp1_video_pipeline_put(struct vsp1_pipeline *pipe)
 
 static int
 vsp1_video_queue_setup(struct vb2_queue *vq,
-		     unsigned int *nbuffers, unsigned int *nplanes,
-		     unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	const struct v4l2_pix_format_mplane *format = &video->rwpf->format;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 3838e11..7ae1a13 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -318,7 +318,7 @@ static void xvip_dma_complete(void *param)
 static int
 xvip_dma_queue_setup(struct vb2_queue *vq,
 		     unsigned int *nbuffers, unsigned int *nplanes,
-		     unsigned int sizes[], void *alloc_ctxs[])
+		     unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct xvip_dma *dma = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 87c1293..d807d58 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -488,7 +488,7 @@ static void airspy_disconnect(struct usb_interface *intf)
 /* Videobuf2 operations */
 static int airspy_queue_setup(struct vb2_queue *vq,
 		unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int *nplanes, unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index b4efc10..e0930ce 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -32,7 +32,7 @@
 
 static int vbi_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long size = dev->vbi_width * dev->vbi_height * 2;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 32d7db9..99cae87 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -702,7 +702,7 @@ int au0828_v4l2_device_register(struct usb_interface *interface,
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long size = dev->height * dev->bytesperline;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index fe94c92..836c6b5 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -33,7 +33,7 @@
 
 static int vbi_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 44834b2..7968695 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1013,7 +1013,7 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 358c1c1..7d4ca5d 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -370,7 +370,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 static int go7007_queue_setup(struct vb2_queue *q,
 		unsigned int *num_buffers, unsigned int *num_planes,
-		unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int sizes[], struct device *alloc_devs[])
 {
 	sizes[0] = GO7007_BUF_SIZE;
 	*num_planes = 1;
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 9e700ca..b1e229a 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -760,7 +760,7 @@ static void hackrf_return_all_buffers(struct vb2_queue *vq,
 
 static int hackrf_queue_setup(struct vb2_queue *vq,
 		unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int *nplanes, unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 2d33033..e7f167d 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -618,7 +618,7 @@ static int msi2500_querycap(struct file *file, void *fh,
 static int msi2500_queue_setup(struct vb2_queue *vq,
 			       unsigned int *nbuffers,
 			       unsigned int *nplanes, unsigned int sizes[],
-			       void *alloc_ctxs[])
+			       struct device *alloc_devs[])
 {
 	struct msi2500_dev *dev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 18aed5d..dd43652 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -573,7 +573,7 @@ static void pwc_video_release(struct v4l2_device *v)
 
 static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 	int size;
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 9acdaa3..43ba71a 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -662,7 +662,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct s2255_vc *vc = vb2_get_drv_priv(vq);
 	if (*nbuffers < S2255_MIN_BUFS)
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77131fd..82574c5 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -666,7 +666,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
  */
 static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct stk1160 *dev = vb2_get_drv_priv(vq);
 	unsigned long size;
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index f6cfad4..7e28204 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -608,7 +608,7 @@ static struct v4l2_file_operations usbtv_fops = {
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
 	unsigned int *nbuffers,
-	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+	unsigned int *nplanes, unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
 	unsigned size = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 5439472..773fefb 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -71,7 +71,7 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
 
 static int uvc_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 88b5e48..76dc600 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -207,8 +207,8 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
 		mem_priv = call_ptr_memop(vb, alloc,
-				q->alloc_ctx[plane] ? : &q->dev,
-				size, dma_dir, q->gfp_flags);
+				q->alloc_devs[plane] ? : q->dev,
+				q->dma_attrs, size, dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
@@ -738,7 +738,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 */
 	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
 	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
-	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 	q->memory = memory;
 
 	/*
@@ -746,7 +746,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	 * Driver also sets the size and allocator context for each plane.
 	 */
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
-		       plane_sizes, q->alloc_ctx);
+		       plane_sizes, q->alloc_devs);
 	if (ret)
 		return ret;
 
@@ -779,7 +779,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		num_planes = 0;
 
 		ret = call_qop(q, queue_setup, q, &num_buffers,
-			       &num_planes, plane_sizes, q->alloc_ctx);
+			       &num_planes, plane_sizes, q->alloc_devs);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -845,7 +845,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	}
 
 	if (!q->num_buffers) {
-		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 		q->memory = memory;
 		q->waiting_for_buffers = !q->is_output;
 	}
@@ -862,7 +862,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	 * buffer and their sizes are acceptable
 	 */
 	ret = call_qop(q, queue_setup, q, &num_buffers,
-		       &num_planes, plane_sizes, q->alloc_ctx);
+		       &num_planes, plane_sizes, q->alloc_devs);
 	if (ret)
 		return ret;
 
@@ -885,7 +885,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		 * queue driver has set up
 		 */
 		ret = call_qop(q, queue_setup, q, &num_buffers,
-			       &num_planes, plane_sizes, q->alloc_ctx);
+			       &num_planes, plane_sizes, q->alloc_devs);
 
 		if (!ret && allocated_buffers < num_buffers)
 			ret = -ENOMEM;
@@ -1133,7 +1133,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, get_userptr,
-				q->alloc_ctx[plane] ? : &q->dev,
+				q->alloc_devs[plane] ? : q->dev,
 				planes[plane].m.userptr,
 				planes[plane].length, dma_dir);
 		if (IS_ERR_OR_NULL(mem_priv)) {
@@ -1258,7 +1258,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf,
-				q->alloc_ctx[plane] ? : &q->dev,
+				q->alloc_devs[plane] ? : q->dev,
 				dbuf, planes[plane].length, dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed to attach dmabuf\n");
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 5361197..461ae55 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -21,11 +21,6 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-memops.h>
 
-struct vb2_dc_conf {
-	struct device		*dev;
-	struct dma_attrs	attrs;
-};
-
 struct vb2_dc_buf {
 	struct device			*dev;
 	void				*vaddr;
@@ -140,18 +135,18 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
-			  enum dma_data_direction dma_dir, gfp_t gfp_flags)
+static void *vb2_dc_alloc(struct device *dev, const struct dma_attrs *attrs,
+			  unsigned long size, enum dma_data_direction dma_dir,
+			  gfp_t gfp_flags)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
-	struct device *dev = conf->dev;
 	struct vb2_dc_buf *buf;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->attrs = conf->attrs;
+	if (attrs)
+		buf->attrs = *attrs;
 	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
 					GFP_KERNEL | gfp_flags, &buf->attrs);
 	if (!buf->cookie) {
@@ -478,10 +473,9 @@ static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn
 }
 #endif
 
-static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
+static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
 	struct frame_vector *vec;
 	unsigned long offset;
@@ -509,7 +503,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	buf->dma_dir = dma_dir;
 
 	offset = vaddr & ~PAGE_MASK;
@@ -676,10 +670,9 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
 	struct dma_buf_attachment *dba;
 
@@ -690,7 +683,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
 	dba = dma_buf_attach(dbuf, buf->dev);
 	if (IS_ERR(dba)) {
@@ -729,30 +722,6 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
-void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
-				    struct dma_attrs *attrs)
-{
-	struct vb2_dc_conf *conf;
-
-	conf = kzalloc(sizeof *conf, GFP_KERNEL);
-	if (!conf)
-		return ERR_PTR(-ENOMEM);
-
-	conf->dev = dev;
-	if (attrs)
-		conf->attrs = *attrs;
-
-	return conf;
-}
-EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx_attrs);
-
-void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
-{
-	if (!IS_ERR_OR_NULL(alloc_ctx))
-		kfree(alloc_ctx);
-}
-EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
-
 MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 9985c89..a39db8a 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -30,10 +30,6 @@ module_param(debug, int, 0644);
 			printk(KERN_DEBUG "vb2-dma-sg: " fmt, ## arg);	\
 	} while (0)
 
-struct vb2_dma_sg_conf {
-	struct device		*dev;
-};
-
 struct vb2_dma_sg_buf {
 	struct device			*dev;
 	void				*vaddr;
@@ -99,10 +95,10 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
-			      enum dma_data_direction dma_dir, gfp_t gfp_flags)
+static void *vb2_dma_sg_alloc(struct device *dev, const struct dma_attrs *dma_attrs,
+			      unsigned long size, enum dma_data_direction dma_dir,
+			      gfp_t gfp_flags)
 {
-	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	struct sg_table *sgt;
 	int ret;
@@ -111,7 +107,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
-	if (WARN_ON(alloc_ctx == NULL))
+	if (WARN_ON(dev == NULL))
 		return NULL;
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -140,7 +136,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 		goto fail_table_alloc;
 
 	/* Prevent the device from being released while the buffer is used */
-	buf->dev = get_device(conf->dev);
+	buf->dev = get_device(dev);
 
 	sgt = &buf->sg_table;
 	/*
@@ -226,11 +222,10 @@ static void vb2_dma_sg_finish(void *buf_priv)
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
 }
 
-static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
+static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 				    unsigned long size,
 				    enum dma_data_direction dma_dir)
 {
-	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	struct sg_table *sgt;
 	DEFINE_DMA_ATTRS(attrs);
@@ -242,7 +237,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		return NULL;
 
 	buf->vaddr = NULL;
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	buf->dma_dir = dma_dir;
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
@@ -616,10 +611,9 @@ static void vb2_dma_sg_detach_dmabuf(void *mem_priv)
 	kfree(buf);
 }
 
-static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+static void *vb2_dma_sg_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
-	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	struct dma_buf_attachment *dba;
 
@@ -630,7 +624,7 @@ static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
 	dba = dma_buf_attach(dbuf, buf->dev);
 	if (IS_ERR(dba)) {
@@ -672,27 +666,6 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
 
-void *vb2_dma_sg_init_ctx(struct device *dev)
-{
-	struct vb2_dma_sg_conf *conf;
-
-	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	if (!conf)
-		return ERR_PTR(-ENOMEM);
-
-	conf->dev = dev;
-
-	return conf;
-}
-EXPORT_SYMBOL_GPL(vb2_dma_sg_init_ctx);
-
-void vb2_dma_sg_cleanup_ctx(void *alloc_ctx)
-{
-	if (!IS_ERR_OR_NULL(alloc_ctx))
-		kfree(alloc_ctx);
-}
-EXPORT_SYMBOL_GPL(vb2_dma_sg_cleanup_ctx);
-
 MODULE_DESCRIPTION("dma scatter/gather memory handling routines for videobuf2");
 MODULE_AUTHOR("Andrzej Pietrasiewicz");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 1c30274..7e8a07e 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -33,8 +33,9 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size,
-			       enum dma_data_direction dma_dir, gfp_t gfp_flags)
+static void *vb2_vmalloc_alloc(struct device *dev, const struct dma_attrs *attrs,
+			       unsigned long size, enum dma_data_direction dma_dir,
+			       gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 
@@ -69,7 +70,7 @@ static void vb2_vmalloc_put(void *buf_priv)
 	}
 }
 
-static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
+static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
 				     unsigned long size,
 				     enum dma_data_direction dma_dir)
 {
@@ -403,7 +404,7 @@ static void vb2_vmalloc_detach_dmabuf(void *mem_priv)
 	kfree(buf);
 }
 
-static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+static void *vb2_vmalloc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
 	struct vb2_vmalloc_buf *buf;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 77e66e7..3319fb8 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1091,7 +1091,7 @@ vpfe_g_dv_timings(struct file *file, void *fh,
  * @nbuffers: ptr to number of buffers requested by application
  * @nplanes:: contains number of distinct video planes needed to hold a frame
  * @sizes[]: contains the size (in bytes) of each plane.
- * @alloc_ctxs: ptr to allocation context
+ * @alloc_devs: ptr to allocation context
  *
  * This callback function is called when reqbuf() is called to adjust
  * the buffer nbuffers and buffer size
@@ -1099,7 +1099,7 @@ vpfe_g_dv_timings(struct file *file, void *fh,
 static int
 vpfe_buffer_queue_setup(struct vb2_queue *vq,
 			unsigned int *nbuffers, unsigned int *nplanes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpfe_video_device *video = fh->video;
diff --git a/drivers/staging/media/mx2/mx2_camera.c b/drivers/staging/media/mx2/mx2_camera.c
index b5d0e60..3829372 100644
--- a/drivers/staging/media/mx2/mx2_camera.c
+++ b/drivers/staging/media/mx2/mx2_camera.c
@@ -469,7 +469,7 @@ static void mx2_camera_clock_stop(struct soc_camera_host *ici)
  */
 static int mx2_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 
diff --git a/drivers/staging/media/mx3/mx3_camera.c b/drivers/staging/media/mx3/mx3_camera.c
index 9f5343c..9758d9c 100644
--- a/drivers/staging/media/mx3/mx3_camera.c
+++ b/drivers/staging/media/mx3/mx3_camera.c
@@ -185,7 +185,7 @@ static void mx3_cam_dma_done(void *arg)
  */
 static int mx3_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 3c077e3..90b7ff5 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -298,7 +298,7 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
 				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], void *alloc_ctxs[])
+				 unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
 	struct iss_video *video = vfh->video;
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 912694f..6377e9f 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -43,7 +43,7 @@
 
 static int uvc_queue_setup(struct vb2_queue *vq,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_video *video = container_of(queue, struct uvc_video, queue);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 0f8b97b..a3a17e9 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -27,7 +27,6 @@ enum vb2_memory {
 	VB2_MEMORY_DMABUF	= 4,
 };
 
-struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
 
@@ -57,7 +56,7 @@ struct vb2_threadio_data;
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
  *		 be used.
  * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
- *		   used for DMABUF memory types; alloc_ctx is the alloc context
+ *		   used for DMABUF memory types; dev is the alloc device
  *		   dbuf is the shared dma_buf; returns NULL on failure;
  *		   allocator private per-buffer structure on success;
  *		   this needs to be used for further accesses to the buffer.
@@ -93,13 +92,13 @@ struct vb2_threadio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size,
-				  enum dma_data_direction dma_dir,
+	void		*(*alloc)(struct device *dev, const struct dma_attrs *attrs,
+				  unsigned long size, enum dma_data_direction dma_dir,
 				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
-	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
+	void		*(*get_userptr)(struct device *dev, unsigned long vaddr,
 					unsigned long size,
 					enum dma_data_direction dma_dir);
 	void		(*put_userptr)(void *buf_priv);
@@ -107,7 +106,7 @@ struct vb2_mem_ops {
 	void		(*prepare)(void *buf_priv);
 	void		(*finish)(void *buf_priv);
 
-	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
+	void		*(*attach_dmabuf)(struct device *dev, struct dma_buf *dbuf,
 					  unsigned long size,
 					  enum dma_data_direction dma_dir);
 	void		(*detach_dmabuf)(void *buf_priv);
@@ -282,7 +281,7 @@ struct vb2_buffer {
  *			in *num_buffers, the required number of planes per
  *			buffer in *num_planes, the size of each plane should be
  *			set in the sizes[] array and optional per-plane
- *			allocator specific context in the alloc_ctxs[] array.
+ *			allocator specific device in the alloc_devs[] array.
  *			When called from VIDIOC_REQBUFS, *num_planes == 0, the
  *			driver has to use the currently configured format to
  *			determine the plane sizes and *num_buffers is the total
@@ -356,7 +355,7 @@ struct vb2_buffer {
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[]);
+			   unsigned int sizes[], struct device *alloc_devs[]);
 
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
@@ -398,7 +397,8 @@ struct vb2_buf_ops {
  *		the V4L2_BUF_TYPE_* in include/uapi/linux/videodev2.h
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @dev:	device to use for the default allocation context if the driver
- *		doesn't fill in the @alloc_ctx array.
+ *		doesn't fill in the @alloc_devs array.
+ * @dma_attrs:	DMA attributes to use for the DMA. May be NULL.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -442,7 +442,7 @@ struct vb2_buf_ops {
  * @done_list:	list of buffers ready to be dequeued to userspace
  * @done_lock:	lock to protect done_list list
  * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
- * @alloc_ctx:	memory type/allocator-specific contexts for each plane
+ * @alloc_devs:	memory type/allocator-specific per-plane device
  * @streaming:	current streaming state
  * @start_streaming_called: start_streaming() was called successfully and we
  *		started streaming.
@@ -463,6 +463,7 @@ struct vb2_queue {
 	unsigned int			type;
 	unsigned int			io_modes;
 	struct device			*dev;
+	const struct dma_attrs		*dma_attrs;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
@@ -494,7 +495,7 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	void				*alloc_ctx[VB2_MAX_PLANES];
+	struct device			*alloc_devs[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 2087c9a..6df8790 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -26,16 +26,6 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 	return *addr;
 }
 
-void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
-				    struct dma_attrs *attrs);
-
-static inline void *vb2_dma_contig_init_ctx(struct device *dev)
-{
-	return vb2_dma_contig_init_ctx_attrs(dev, NULL);
-}
-
-void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
-
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
 
 #endif
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 8d1083f..52afa0e 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -21,9 +21,6 @@ static inline struct sg_table *vb2_dma_sg_plane_desc(
 	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
 }
 
-void *vb2_dma_sg_init_ctx(struct device *dev);
-void vb2_dma_sg_cleanup_ctx(void *alloc_ctx);
-
 extern const struct vb2_mem_ops vb2_dma_sg_memops;
 
 #endif
-- 
2.8.0.rc3


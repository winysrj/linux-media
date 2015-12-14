Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55888 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbbLNOgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 09:36:11 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] vb2: Stop allocating 'alloc_ctx', just set the device
 instead
Message-ID: <566ED3D4.9050803@xs4all.nl>
Date: Mon, 14 Dec 2015 15:36:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Before I post this as the 'final' patch and CC all the driver developers that
are affected, I'd like to do an RFC post first. I always hated the alloc context
for obfuscating what is really going on, but let's see what others think).


Instead of allocating a struct that contains just a single device pointer,
just pass that device pointer around. This avoids having to check for
memory allocation errors and is much easier to understand since it makes
explicit what was hidden in an opaque handle before.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c      | 16 +++------
 drivers/input/touchscreen/sur40.c                  | 12 ++-----
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |  9 +----
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c           | 11 ++----
 drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  2 +-
 drivers/media/pci/cx25821/cx25821-core.c           | 11 ++----
 drivers/media/pci/cx25821/cx25821-video.c          |  2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 | 11 ++----
 drivers/media/pci/cx88/cx88-vbi.c                  |  2 +-
 drivers/media/pci/cx88/cx88-video.c                | 11 ++----
 drivers/media/pci/dt3155/dt3155.c                  | 14 ++------
 drivers/media/pci/dt3155/dt3155.h                  |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  2 +-
 drivers/media/pci/saa7134/saa7134-core.c           | 19 ++++------
 drivers/media/pci/saa7134/saa7134-ts.c             |  2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
 drivers/media/pci/saa7134/saa7134.h                |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     | 10 ++----
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         | 10 ++----
 drivers/media/pci/solo6x10/solo6x10.h              |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            | 17 +++------
 drivers/media/pci/tw68/tw68-core.c                 | 15 +++-----
 drivers/media/pci/tw68/tw68-video.c                |  2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        | 10 ++----
 drivers/media/platform/am437x/am437x-vpfe.h        |  2 +-
 drivers/media/platform/blackfin/bfin_capture.c     | 15 +++-----
 drivers/media/platform/coda/coda-common.c          | 14 ++------
 drivers/media/platform/coda/coda.h                 |  2 +-
 drivers/media/platform/davinci/vpbe_display.c      | 12 ++-----
 drivers/media/platform/davinci/vpif_capture.c      | 11 ++----
 drivers/media/platform/davinci/vpif_capture.h      |  2 +-
 drivers/media/platform/davinci/vpif_display.c      | 11 ++----
 drivers/media/platform/davinci/vpif_display.h      |  2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |  9 +----
 drivers/media/platform/exynos-gsc/gsc-core.h       |  2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |  2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      | 10 +-----
 drivers/media/platform/exynos4-is/fimc-core.h      |  4 +--
 drivers/media/platform/exynos4-is/fimc-is.c        | 11 ++----
 drivers/media/platform/exynos4-is/fimc-is.h        |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      | 12 ++-----
 drivers/media/platform/exynos4-is/fimc-lite.h      |  2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
 drivers/media/platform/m2m-deinterlace.c           | 14 ++------
 drivers/media/platform/marvell-ccic/mcam-core.c    | 23 ++----------
 drivers/media/platform/marvell-ccic/mcam-core.h    |  4 +--
 drivers/media/platform/mx2_emmaprp.c               | 16 +++------
 drivers/media/platform/omap3isp/ispvideo.c         | 11 ++----
 drivers/media/platform/rcar_jpu.c                  | 15 ++------
 drivers/media/platform/s3c-camif/camif-capture.c   |  2 +-
 drivers/media/platform/s3c-camif/camif-core.c      |  8 +----
 drivers/media/platform/s3c-camif/camif-core.h      |  2 +-
 drivers/media/platform/s5p-g2d/g2d.c               | 13 ++-----
 drivers/media/platform/s5p-g2d/g2d.h               |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 17 +++------
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 20 ++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        | 16 ++-------
 drivers/media/platform/sh_veu.c                    | 13 ++-----
 drivers/media/platform/sh_vou.c                    | 17 +++------
 drivers/media/platform/soc_camera/atmel-isi.c      | 13 ++-----
 drivers/media/platform/soc_camera/mx2_camera.c     | 14 ++------
 drivers/media/platform/soc_camera/mx3_camera.c     | 16 +++------
 drivers/media/platform/soc_camera/rcar_vin.c       | 12 ++-----
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 15 +++-----
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 14 ++------
 drivers/media/platform/sti/bdisp/bdisp.h           |  2 +-
 drivers/media/platform/ti-vpe/vpe.c                | 17 +++------
 drivers/media/platform/vim2m.c                     |  2 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 10 ++----
 drivers/media/platform/xilinx/xilinx-dma.c         | 11 ++----
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
 drivers/media/v4l2-core/videobuf2-dma-contig.c     | 39 +++-----------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c         | 42 ++++------------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |  6 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 10 ++----
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  9 ++---
 drivers/staging/media/omap4iss/iss_video.h         |  2 +-
 drivers/usb/gadget/function/uvc_queue.c            |  2 +-
 include/media/davinci/vpbe_display.h               |  2 +-
 include/media/videobuf2-core.h                     | 11 +++---
 include/media/videobuf2-dma-contig.h               |  3 --
 include/media/videobuf2-dma-sg.h                   |  3 --
 113 files changed, 211 insertions(+), 624 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 1c8b102..205a36c 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -73,7 +73,7 @@ struct skeleton {
 	unsigned input;
 
 	struct vb2_queue queue;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 
 	spinlock_t qlock;
 	struct list_head buf_list;
@@ -165,7 +165,7 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
  */
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct skeleton *skel = vb2_get_drv_priv(vq);
@@ -854,12 +854,7 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto free_hdl;
 
-	skel->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(skel->alloc_ctx)) {
-		dev_err(&pdev->dev, "Can't allocate buffer context");
-		ret = PTR_ERR(skel->alloc_ctx);
-		goto free_hdl;
-	}
+	skel->alloc_ctx = &pdev->dev;
 	INIT_LIST_HEAD(&skel->buf_list);
 	spin_lock_init(&skel->qlock);
 
@@ -887,13 +882,11 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		goto free_ctx;
+		goto free_hdl;
 
 	dev_info(&pdev->dev, "V4L2 PCI Skeleton Driver loaded\n");
 	return 0;
 
-free_ctx:
-	vb2_dma_contig_cleanup_ctx(skel->alloc_ctx);
 free_hdl:
 	v4l2_ctrl_handler_free(&skel->ctrl_handler);
 	v4l2_device_unregister(&skel->v4l2_dev);
@@ -909,7 +902,6 @@ static void skeleton_remove(struct pci_dev *pdev)
 
 	video_unregister_device(&skel->vdev);
 	v4l2_ctrl_handler_free(&skel->ctrl_handler);
-	vb2_dma_contig_cleanup_ctx(skel->alloc_ctx);
 	v4l2_device_unregister(&skel->v4l2_dev);
 	pci_disable_device(skel->pdev);
 }
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index d214f22..f33c8ca 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -151,7 +151,7 @@ struct sur40_state {
 	struct mutex lock;
 
 	struct vb2_queue queue;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	struct list_head buf_list;
 	spinlock_t qlock;
 	int sequence;
@@ -579,12 +579,7 @@ static int sur40_probe(struct usb_interface *interface,
 	if (error)
 		goto err_unreg_v4l2;
 
-	sur40->alloc_ctx = vb2_dma_sg_init_ctx(sur40->dev);
-	if (IS_ERR(sur40->alloc_ctx)) {
-		dev_err(sur40->dev, "Can't allocate buffer context");
-		error = PTR_ERR(sur40->alloc_ctx);
-		goto err_unreg_v4l2;
-	}
+	sur40->alloc_ctx = sur40->dev;
 
 	sur40->vdev = sur40_video_device;
 	sur40->vdev.v4l2_dev = &sur40->v4l2;
@@ -626,7 +621,6 @@ static void sur40_disconnect(struct usb_interface *interface)
 
 	video_unregister_device(&sur40->vdev);
 	v4l2_device_unregister(&sur40->v4l2);
-	vb2_dma_sg_cleanup_ctx(sur40->alloc_ctx);
 
 	input_unregister_polled_device(sur40->input);
 	input_free_polled_device(sur40->input);
@@ -646,7 +640,7 @@ static void sur40_disconnect(struct usb_interface *interface)
  */
 static int sur40_queue_setup(struct vb2_queue *q, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct sur40_state *sur40 = vb2_get_drv_priv(q);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index dcd8d94..cb23d16 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -491,7 +491,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 /* Videobuf2 operations */
 static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 		const void *parg, unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int *nplanes, unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 	struct platform_device *pdev = dev->pdev;
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 8d6f04f..2ed1489 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -691,17 +691,12 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 	cobalt->pci_dev = pci_dev;
 	cobalt->instance = i;
 
-	cobalt->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(cobalt->alloc_ctx)) {
-		kfree(cobalt);
-		return -ENOMEM;
-	}
+	cobalt->alloc_ctx = &pci_dev->dev;
 
 	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
 	if (retval) {
 		pr_err("cobalt: v4l2_device_register of card %d failed\n",
 				cobalt->instance);
-		vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
 		kfree(cobalt);
 		return retval;
 	}
@@ -782,7 +777,6 @@ err:
 	cobalt_err("error %d on initialization\n", retval);
 
 	v4l2_device_unregister(&cobalt->v4l2_dev);
-	vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
 	kfree(cobalt);
 	return retval;
 }
@@ -818,7 +812,6 @@ static void cobalt_remove(struct pci_dev *pci_dev)
 	cobalt_info("removed cobalt card\n");
 
 	v4l2_device_unregister(v4l2_dev);
-	vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
 	kfree(cobalt);
 }
 
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 8cc78c5..16d4769 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -45,7 +45,7 @@ static const struct v4l2_dv_timings cea1080p60 = V4L2_DV_BT_CEA_1920X1080P60;
 
 static int cobalt_queue_setup(struct vb2_queue *q, const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct cobalt_stream *s = q->drv_priv;
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 2fe3708..4fe7403 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1140,7 +1140,7 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx23885_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index e8f8472..e92f5fc 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1995,14 +1995,10 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	err = pci_set_dma_mask(pci_dev, 0xffffffff);
 	if (err) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		goto fail_context;
+		goto fail_ctrl;
 	}
 
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_context;
-	}
+	dev->alloc_ctx = &pci_dev->dev;
 	err = request_irq(pci_dev->irq, cx23885_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
@@ -2031,8 +2027,6 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	return 0;
 
 fail_irq:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
-fail_context:
 	cx23885_dev_unregister(dev);
 fail_ctrl:
 	v4l2_ctrl_handler_free(hdl);
@@ -2058,7 +2052,6 @@ static void cx23885_finidev(struct pci_dev *pci_dev)
 	pci_disable_device(pci_dev);
 
 	cx23885_dev_unregister(dev);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index c4307ad..0068db2 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -94,7 +94,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx23885_tsport *port = q->drv_priv;
 
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index cf3cb13..b068d71 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -123,7 +123,7 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx23885_dev *dev = q->drv_priv;
 	unsigned lines = VBI_PAL_LINE_COUNT;
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 63f302e0..16021b6 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -317,7 +317,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx23885_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 0042803..400069e 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1301,15 +1301,11 @@ static int cx25821_initdev(struct pci_dev *pci_dev,
 
 		goto fail_unregister_device;
 	}
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_unregister_pci;
-	}
+	dev->alloc_ctx = &pci_dev->dev;
 
 	err = cx25821_dev_setup(dev);
 	if (err)
-		goto fail_free_ctx;
+		goto fail_unregister_pci;
 
 	/* print pci info */
 	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
@@ -1340,8 +1336,6 @@ fail_irq:
 	pr_info("cx25821_initdev() can't get IRQ !\n");
 	cx25821_dev_unregister(dev);
 
-fail_free_ctx:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 fail_unregister_pci:
 	pci_disable_device(pci_dev);
 fail_unregister_device:
@@ -1365,7 +1359,6 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 		free_irq(pci_dev->irq, dev);
 
 	cx25821_dev_unregister(dev);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 26e3e29..8ce8514 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -143,7 +143,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 
 static int cx25821_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct cx25821_channel *chan = q->drv_priv;
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 27ffb24..52225e4 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -639,7 +639,7 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx8802_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index f048350..412ae65 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -84,7 +84,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx8802_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index f34c229..7e11589 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -726,11 +726,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		goto fail_core;
 	dev->pci = pci_dev;
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_dev;
-	}
+	dev->alloc_ctx = &pci_dev->dev;
 	dev->core = core;
 
 	/* Maintain a reference so cx88-video can query the 8802 device. */
@@ -738,7 +734,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
 	err = cx8802_init_common(dev);
 	if (err != 0)
-		goto fail_free;
+		goto fail_dev;
 
 	INIT_LIST_HEAD(&dev->drvlist);
 	mutex_lock(&cx8802_mutex);
@@ -749,8 +745,6 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	request_modules(dev);
 	return 0;
 
- fail_free:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
  fail_dev:
 	kfree(dev);
  fail_core:
@@ -798,7 +792,6 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 	/* common */
 	cx8802_fini_common(dev);
 	cx88_core_put(dev->core,dev->pci);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 007a5ee..2f536f3e 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -109,7 +109,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 5996d06..0903c72ee 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -431,7 +431,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
 	struct cx88_core *core = dev->core;
@@ -1319,12 +1319,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
 		goto fail_core;
 	}
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_core;
-	}
-
+	dev->alloc_ctx = &pci_dev->dev;
 
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
@@ -1530,7 +1525,6 @@ fail_unreg:
 	free_irq(pci_dev->irq, dev);
 	mutex_unlock(&core->lock);
 fail_core:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	core->v4ldev = NULL;
 	cx88_core_put(core,dev->pci);
 fail_free:
@@ -1564,7 +1558,6 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 
 	/* free memory */
 	cx88_core_put(core,dev->pci);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index d84abde..a0d2346 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -133,7 +133,7 @@ static int wait_i2c_reg(void __iomem *addr)
 static int
 dt3155_queue_setup(struct vb2_queue *vq, const void *parg,
 		unsigned int *nbuffers, unsigned int *num_planes,
-		unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int sizes[], struct device *alloc_ctxs[])
 
 {
 	const struct v4l2_format *fmt = parg;
@@ -549,17 +549,12 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = vb2_queue_init(&pd->vidq);
 	if (err < 0)
 		goto err_v4l2_dev_unreg;
-	pd->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pd->alloc_ctx)) {
-		dev_err(&pdev->dev, "Can't allocate buffer context");
-		err = PTR_ERR(pd->alloc_ctx);
-		goto err_v4l2_dev_unreg;
-	}
+	pd->alloc_ctx = &pdev->dev;
 	spin_lock_init(&pd->lock);
 	pd->config = ACQ_MODE_EVEN;
 	err = pci_enable_device(pdev);
 	if (err)
-		goto err_free_ctx;
+		goto err_v4l2_dev_unreg;
 	err = pci_request_region(pdev, 0, pci_name(pdev));
 	if (err)
 		goto err_pci_disable;
@@ -589,8 +584,6 @@ err_free_reg:
 	pci_release_region(pdev, 0);
 err_pci_disable:
 	pci_disable_device(pdev);
-err_free_ctx:
-	vb2_dma_contig_cleanup_ctx(pd->alloc_ctx);
 err_v4l2_dev_unreg:
 	v4l2_device_unregister(&pd->v4l2_dev);
 	return err;
@@ -609,7 +602,6 @@ static void dt3155_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, pd->regs);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	vb2_dma_contig_cleanup_ctx(pd->alloc_ctx);
 }
 
 static const struct pci_device_id pci_ids[] = {
diff --git a/drivers/media/pci/dt3155/dt3155.h b/drivers/media/pci/dt3155/dt3155.h
index b3531e0..c5b3919 100644
--- a/drivers/media/pci/dt3155/dt3155.h
+++ b/drivers/media/pci/dt3155/dt3155.h
@@ -181,7 +181,7 @@ struct dt3155_priv {
 	struct video_device vdev;
 	struct pci_dev *pdev;
 	struct vb2_queue vidq;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	struct vb2_v4l2_buffer *curr_buf;
 	struct mutex mux;
 	struct list_head dmaq;
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 3fdbd81..a50ec43 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -281,7 +281,7 @@ static int netup_unidvb_queue_setup(struct vb2_queue *vq,
 				    unsigned int *nbuffers,
 				    unsigned int *nplanes,
 				    unsigned int sizes[],
-				    void *alloc_ctxs[])
+				    struct device *alloc_ctxs[])
 {
 	struct netup_dma *dma = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index f720cea..22498e2 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1004,18 +1004,14 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	saa7134_board_init1(dev);
 	saa7134_hwinit1(dev);
 
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail3;
-	}
+	dev->alloc_ctx = &pci_dev->dev;
 	/* get irq */
 	err = request_irq(pci_dev->irq, saa7134_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
-		goto fail4;
+		goto fail3;
 	}
 
 	/* wait a bit, register i2c bus */
@@ -1073,7 +1069,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_info("%s: can't register video device\n",
 		       dev->name);
-		goto fail5;
+		goto fail4;
 	}
 	pr_info("%s: registered device %s [v4l2]\n",
 	       dev->name, video_device_node_name(dev->video_dev));
@@ -1086,7 +1082,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
 	if (err < 0)
-		goto fail5;
+		goto fail4;
 	pr_info("%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
@@ -1097,7 +1093,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[dev->nr]);
 		if (err < 0)
-			goto fail5;
+			goto fail4;
 		pr_info("%s: registered device %s\n",
 		       dev->name, video_device_node_name(dev->radio_dev));
 	}
@@ -1111,12 +1107,10 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	request_submodules(dev);
 	return 0;
 
- fail5:
+ fail4:
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
- fail4:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
  fail3:
 	saa7134_hwfini(dev);
 	iounmap(dev->lmmio);
@@ -1183,7 +1177,6 @@ static void saa7134_finidev(struct pci_dev *pci_dev)
 
 	/* release resources */
 	free_irq(pci_dev->irq, dev);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	iounmap(dev->lmmio);
 	release_mem_region(pci_resource_start(pci_dev,0),
 			   pci_resource_len(pci_dev,0));
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 7fb5ee7..610ff1c 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
 int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct saa7134_dmaqueue *dmaq = q->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 6271b0e..f653a05 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -140,7 +140,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct saa7134_dmaqueue *dmaq = q->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4d3a7fb..4664a29 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -906,7 +906,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 
 static int queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct saa7134_dmaqueue *dmaq = q->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 7cc7582..d7034b0 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -822,7 +822,7 @@ int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
 int saa7134_ts_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[]);
+			   unsigned int sizes[], struct device *alloc_ctxs[]);
 int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count);
 void saa7134_ts_stop_streaming(struct vb2_queue *vq);
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 4432fd6..712c1ef6 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -666,7 +666,7 @@ static int solo_enc_queue_setup(struct vb2_queue *q,
 				const void *parg,
 				unsigned int *num_buffers,
 				unsigned int *num_planes, unsigned int sizes[],
-				void *alloc_ctxs[])
+				struct device *alloc_ctxs[])
 {
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
 
@@ -1241,11 +1241,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 		return ERR_PTR(-ENOMEM);
 
 	hdl = &solo_enc->hdl;
-	solo_enc->alloc_ctx = vb2_dma_sg_init_ctx(&solo_dev->pdev->dev);
-	if (IS_ERR(solo_enc->alloc_ctx)) {
-		ret = PTR_ERR(solo_enc->alloc_ctx);
-		goto hdl_free;
-	}
+	solo_enc->alloc_ctx = &solo_dev->pdev->dev;
 	v4l2_ctrl_handler_init(hdl, 10);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
@@ -1349,7 +1345,6 @@ pci_free:
 			solo_enc->desc_items, solo_enc->desc_dma);
 hdl_free:
 	v4l2_ctrl_handler_free(hdl);
-	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 	return ERR_PTR(ret);
 }
@@ -1364,7 +1359,6 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 			solo_enc->desc_items, solo_enc->desc_dma);
 	video_unregister_device(solo_enc->vfd);
 	v4l2_ctrl_handler_free(&solo_enc->hdl);
-	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 }
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index f7ce493..1f33276 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -315,7 +315,7 @@ static void solo_stop_thread(struct solo_dev *solo_dev)
 
 static int solo_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
@@ -685,11 +685,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 	if (ret < 0)
 		goto fail;
 
-	solo_dev->alloc_ctx = vb2_dma_contig_init_ctx(&solo_dev->pdev->dev);
-	if (IS_ERR(solo_dev->alloc_ctx)) {
-		dev_err(&solo_dev->pdev->dev, "Can't allocate buffer context");
-		return PTR_ERR(solo_dev->alloc_ctx);
-	}
+	solo_dev->alloc_ctx = &solo_dev->pdev->dev;
 
 	/* Cycle all the channels and clear */
 	for (i = 0; i < solo_dev->nr_chans; i++) {
@@ -718,7 +714,6 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 
 fail:
 	video_device_release(solo_dev->vfd);
-	vb2_dma_contig_cleanup_ctx(solo_dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&solo_dev->disp_hdl);
 	solo_dev->vfd = NULL;
 	return ret;
@@ -730,7 +725,6 @@ void solo_v4l2_exit(struct solo_dev *solo_dev)
 		return;
 
 	video_unregister_device(solo_dev->vfd);
-	vb2_dma_contig_cleanup_ctx(solo_dev->alloc_ctx);
 	v4l2_ctrl_handler_free(&solo_dev->disp_hdl);
 	solo_dev->vfd = NULL;
 }
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 4ab6586..68bb6fa 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -269,7 +269,7 @@ struct solo_dev {
 
 	/* Buffer handling */
 	struct vb2_queue	vidq;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 	u32			sequence;
 	struct task_struct      *kthread;
 	struct mutex		lock;
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 6367b45..bf14a6a 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -141,7 +141,7 @@ struct sta2x11_vip {
 	int disabled;
 	spinlock_t slock;
 
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	struct vb2_queue vb_vidq;
 	struct list_head buffer_list;
 	unsigned int sequence;
@@ -267,7 +267,7 @@ static void vip_active_buf_next(struct sta2x11_vip *vip)
 /* Videobuf2 Operations */
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
 
@@ -876,18 +876,10 @@ static int sta2x11_vip_init_buffer(struct sta2x11_vip *vip)
 	spin_lock_init(&vip->lock);
 
 
-	vip->alloc_ctx = vb2_dma_contig_init_ctx(&vip->pdev->dev);
-	if (IS_ERR(vip->alloc_ctx)) {
-		v4l2_err(&vip->v4l2_dev, "Can't allocate buffer context");
-		return PTR_ERR(vip->alloc_ctx);
-	}
-
+	vip->alloc_ctx = &vip->pdev->dev;
 	return 0;
 }
-static void sta2x11_vip_release_buffer(struct sta2x11_vip *vip)
-{
-	vb2_dma_contig_cleanup_ctx(vip->alloc_ctx);
-}
+
 static int sta2x11_vip_init_controls(struct sta2x11_vip *vip)
 {
 	/*
@@ -1128,7 +1120,6 @@ vrelease:
 	video_unregister_device(&vip->video_dev);
 	free_irq(pdev->irq, vip);
 release_buf:
-	sta2x11_vip_release_buffer(vip);
 	pci_disable_msi(pdev);
 unmap:
 	vb2_queue_release(&vip->vb_vidq);
diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 4e77618..680d006 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -305,11 +305,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 	/* Then do any initialisation wanted before interrupts are on */
 	tw68_hw_init1(dev);
 
-	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		err = PTR_ERR(dev->alloc_ctx);
-		goto fail3;
-	}
+	dev->alloc_ctx = &pci_dev->dev;
 
 	/* get irq */
 	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw68_irq,
@@ -317,7 +313,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
-		goto fail4;
+		goto fail3;
 	}
 
 	/*
@@ -331,7 +327,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_err("%s: can't register video device\n",
 		       dev->name);
-		goto fail5;
+		goto fail4;
 	}
 	tw_setl(TW68_INTMASK, dev->pci_irqmask);
 
@@ -340,10 +336,8 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	return 0;
 
-fail5:
-	video_unregister_device(&dev->vdev);
 fail4:
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
+	video_unregister_device(&dev->vdev);
 fail3:
 	iounmap(dev->lmmio);
 fail2:
@@ -367,7 +361,6 @@ static void tw68_finidev(struct pci_dev *pci_dev)
 	/* unregister */
 	video_unregister_device(&dev->vdev);
 	v4l2_ctrl_handler_free(&dev->hdl);
-	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 
 	/* release resources */
 	iounmap(dev->lmmio);
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 46642ef..f3e822d 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -378,7 +378,7 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
 
 static int tw68_queue_setup(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct tw68_dev *dev = vb2_get_drv_priv(q);
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index f0480d6..101017c 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1910,7 +1910,7 @@ static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
 static int vpfe_queue_setup(struct vb2_queue *vq,
 			    const void *parg,
 			    unsigned int *nbuffers, unsigned int *nplanes,
-			    unsigned int sizes[], void *alloc_ctxs[])
+			    unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
@@ -2363,12 +2363,7 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
 		goto probe_out;
 
 	/* Initialize videobuf2 queue as per the buffer type */
-	vpfe->alloc_ctx = vb2_dma_contig_init_ctx(vpfe->pdev);
-	if (IS_ERR(vpfe->alloc_ctx)) {
-		vpfe_err(vpfe, "Failed to get the context\n");
-		err = PTR_ERR(vpfe->alloc_ctx);
-		goto probe_out;
-	}
+	vpfe->alloc_ctx = vpfe->pdev;
 
 	q = &vpfe->buffer_queue;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -2384,7 +2379,6 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
 	err = vb2_queue_init(q);
 	if (err) {
 		vpfe_err(vpfe, "vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(vpfe->alloc_ctx);
 		goto probe_out;
 	}
 
diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
index 777bf97..ff896cc 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.h
+++ b/drivers/media/platform/am437x/am437x-vpfe.h
@@ -265,7 +265,7 @@ struct vpfe_device {
 	/* Buffer queue used in video-buf */
 	struct vb2_queue buffer_queue;
 	/* Allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	/* Queue of filled frames */
 	struct list_head dma_queue;
 	/* IRQ lock for DMA queue */
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 7764b9c..1d58b90 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -92,7 +92,7 @@ struct bcap_device {
 	/* buffer queue used in videobuf2 */
 	struct vb2_queue buffer_queue;
 	/* allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	/* queue of filled frames */
 	struct list_head dma_queue;
 	/* used in videobuf2 callback */
@@ -204,7 +204,7 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 static int bcap_queue_setup(struct vb2_queue *vq,
 				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
@@ -822,11 +822,7 @@ static int bcap_probe(struct platform_device *pdev)
 	}
 	bcap_dev->ppi->priv = bcap_dev;
 
-	bcap_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(bcap_dev->alloc_ctx)) {
-		ret = PTR_ERR(bcap_dev->alloc_ctx);
-		goto err_free_ppi;
-	}
+	bcap_dev->alloc_ctx = &pdev->dev;
 
 	vfd = &bcap_dev->video_dev;
 	/* initialize field of video device */
@@ -841,7 +837,7 @@ static int bcap_probe(struct platform_device *pdev)
 	if (ret) {
 		v4l2_err(pdev->dev.driver,
 				"Unable to register v4l2 device\n");
-		goto err_cleanup_ctx;
+		goto err_free_ppi;
 	}
 	v4l2_info(&bcap_dev->v4l2_dev, "v4l2 device registered\n");
 
@@ -969,8 +965,6 @@ err_free_handler:
 	v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
 err_unreg_v4l2:
 	v4l2_device_unregister(&bcap_dev->v4l2_dev);
-err_cleanup_ctx:
-	vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
 err_free_ppi:
 	ppi_delete_instance(bcap_dev->ppi);
 err_free_dev:
@@ -988,7 +982,6 @@ static int bcap_remove(struct platform_device *pdev)
 	video_unregister_device(&bcap_dev->video_dev);
 	v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
 	v4l2_device_unregister(v4l2_dev);
-	vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
 	ppi_delete_instance(bcap_dev->ppi);
 	kfree(bcap_dev);
 	return 0;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f821627..18aa7ab 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1133,7 +1133,7 @@ static void set_default_params(struct coda_ctx *ctx)
  */
 static int coda_queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
 	struct coda_q_data *q_data;
@@ -1982,16 +1982,12 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	if (ret < 0)
 		goto put_pm;
 
-	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
-		goto put_pm;
-	}
+	dev->alloc_ctx = &pdev->dev;
 
 	dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
 	if (IS_ERR(dev->m2m_dev)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
-		goto rel_ctx;
+		goto put_pm;
 	}
 
 	for (i = 0; i < dev->devtype->num_vdevs; i++) {
@@ -2014,8 +2010,6 @@ rel_vfd:
 	while (--i >= 0)
 		video_unregister_device(&dev->vfd[i]);
 	v4l2_m2m_release(dev->m2m_dev);
-rel_ctx:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 put_pm:
 	pm_runtime_put_sync(&pdev->dev);
 }
@@ -2267,8 +2261,6 @@ static int coda_remove(struct platform_device *pdev)
 	if (dev->m2m_dev)
 		v4l2_m2m_release(dev->m2m_dev);
 	pm_runtime_disable(&pdev->dev);
-	if (dev->alloc_ctx)
-		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	destroy_workqueue(dev->workqueue);
 	if (dev->iram.vaddr)
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 96532b0..089420f 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -91,7 +91,7 @@ struct coda_dev {
 	struct mutex		coda_mutex;
 	struct workqueue_struct	*workqueue;
 	struct v4l2_m2m_dev	*m2m_dev;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 	struct list_head	instances;
 	unsigned long		instance_mask;
 	struct dentry		*debugfs_root;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6d91422..22a4886 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -230,7 +230,7 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 static int
 vpbe_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *nbuffers, unsigned int *nplanes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_ctxs[])
 
 {
 	const struct v4l2_format *fmt = parg;
@@ -1458,13 +1458,7 @@ static int vpbe_display_probe(struct platform_device *pdev)
 			goto probe_out;
 		}
 
-		disp_dev->dev[i]->alloc_ctx =
-			vb2_dma_contig_init_ctx(disp_dev->vpbe_dev->pdev);
-		if (IS_ERR(disp_dev->dev[i]->alloc_ctx)) {
-			v4l2_err(v4l2_dev, "Failed to get the context\n");
-			err = PTR_ERR(disp_dev->dev[i]->alloc_ctx);
-			goto probe_out;
-		}
+		disp_dev->dev[i]->alloc_ctx = disp_dev->vpbe_dev->pdev;
 
 		INIT_LIST_HEAD(&disp_dev->dev[i]->dma_queue);
 
@@ -1483,7 +1477,6 @@ probe_out:
 	for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
 		/* Unregister video device */
 		if (disp_dev->dev[k] != NULL) {
-			vb2_dma_contig_cleanup_ctx(disp_dev->dev[k]->alloc_ctx);
 			video_unregister_device(&disp_dev->dev[k]->video_dev);
 			kfree(disp_dev->dev[k]);
 		}
@@ -1511,7 +1504,6 @@ static int vpbe_display_remove(struct platform_device *pdev)
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the layer object */
 		vpbe_display_layer = disp_dev->dev[i];
-		vb2_dma_contig_cleanup_ctx(vpbe_display_layer->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(&vpbe_display_layer->video_dev);
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index c1e573b..e5a9d57 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -116,7 +116,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
@@ -1379,12 +1379,7 @@ static int vpif_probe_complete(void)
 			goto probe_out;
 		}
 
-		common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-		if (IS_ERR(common->alloc_ctx)) {
-			vpif_err("Failed to get the context\n");
-			err = PTR_ERR(common->alloc_ctx);
-			goto probe_out;
-		}
+		common->alloc_ctx = vpif_dev;
 
 		INIT_LIST_HEAD(&common->dma_queue);
 
@@ -1413,7 +1408,6 @@ probe_out:
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[k];
 		common = &ch->common[k];
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 	}
@@ -1547,7 +1541,6 @@ static int vpif_remove(struct platform_device *device)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 		kfree(vpif_obj.dev[i]);
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 4a76009..a213f5a 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -66,7 +66,7 @@ struct common_obj {
 	/* Buffer queue used in video-buf */
 	struct vb2_queue buffer_queue;
 	/* allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	/* Queue of filled frames */
 	struct list_head dma_queue;
 	/* Used in video-buf */
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index fd27803..02913c7 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -111,7 +111,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
@@ -1196,12 +1196,7 @@ static int vpif_probe_complete(void)
 			goto probe_out;
 		}
 
-		common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-		if (IS_ERR(common->alloc_ctx)) {
-			vpif_err("Failed to get the context\n");
-			err = PTR_ERR(common->alloc_ctx);
-			goto probe_out;
-		}
+		common->alloc_ctx = vpif_dev;
 
 		INIT_LIST_HEAD(&common->dma_queue);
 
@@ -1232,7 +1227,6 @@ probe_out:
 	for (k = 0; k < j; k++) {
 		ch = vpif_obj.dev[k];
 		common = &ch->common[k];
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		video_unregister_device(&ch->video_dev);
 	}
 	return err;
@@ -1354,7 +1348,6 @@ static int vpif_remove(struct platform_device *device)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 		kfree(vpif_obj.dev[i]);
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index e7a1723..6987f4e 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -75,7 +75,7 @@ struct common_obj {
 	struct vb2_queue buffer_queue;		/* Buffer queue used in
 						 * video-buf */
 	/* allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 
 	struct list_head dma_queue;		/* Queue of filled frames */
 	spinlock_t irqlock;			/* Used in video-buf */
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9b9e423..677f023 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1140,18 +1140,12 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_m2m;
 
 	/* Initialize continious memory allocator */
-	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(gsc->alloc_ctx)) {
-		ret = PTR_ERR(gsc->alloc_ctx);
-		goto err_pm;
-	}
+	gsc->alloc_ctx = dev;
 
 	dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
 
 	pm_runtime_put(dev);
 	return 0;
-err_pm:
-	pm_runtime_put(dev);
 err_m2m:
 	gsc_unregister_m2m_device(gsc);
 err_v4l2:
@@ -1168,7 +1162,6 @@ static int gsc_remove(struct platform_device *pdev)
 	gsc_unregister_m2m_device(gsc);
 	v4l2_device_unregister(&gsc->v4l2_dev);
 
-	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	pm_runtime_disable(&pdev->dev);
 	gsc_clk_put(gsc);
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index e93a233..874dd8c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -342,7 +342,7 @@ struct gsc_dev {
 	struct gsc_m2m_device		m2m;
 	struct exynos_platform_gscaler	*pdata;
 	unsigned long			state;
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 	struct video_device		vdev;
 	struct v4l2_device		v4l2_dev;
 };
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d82e717..3e02b88 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -214,7 +214,7 @@ put_device:
 static int gsc_m2m_queue_setup(struct vb2_queue *vq,
 			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
-			unsigned int sizes[], void *allocators[])
+			unsigned int sizes[], struct device *allocators[])
 {
 	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
 	struct gsc_frame *frame;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 99e5732..c5992e2 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -340,7 +340,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *num_buffers, unsigned int *num_planes,
-		       unsigned int sizes[], void *allocators[])
+		       unsigned int sizes[], struct device *allocators[])
 {
 	const struct v4l2_format *pfmt = parg;
 	const struct v4l2_pix_format_mplane *pixm = NULL;
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index cef2a7f..b891b98 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1019,18 +1019,11 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize contiguous memory allocator */
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(fimc->alloc_ctx)) {
-		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_gclk;
-	}
+	fimc->alloc_ctx = dev;
 
 	dev_dbg(dev, "FIMC.%d registered successfully\n", fimc->id);
 	return 0;
 
-err_gclk:
-	if (!pm_runtime_enabled(dev))
-		clk_disable(fimc->clock[CLK_GATE]);
 err_sd:
 	fimc_unregister_capture_subdev(fimc);
 err_sclk:
@@ -1123,7 +1116,6 @@ static int fimc_remove(struct platform_device *pdev)
 	pm_runtime_set_suspended(&pdev->dev);
 
 	fimc_unregister_capture_subdev(fimc);
-	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 6b74354..c4f55f7 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -307,7 +307,7 @@ struct fimc_m2m_device {
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 	struct v4l2_subdev		subdev;
 	struct exynos_video_entity	ve;
 	struct media_pad		vd_pad;
@@ -436,7 +436,7 @@ struct fimc_dev {
 	struct fimc_m2m_device		m2m;
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 };
 
 /**
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 49658ca..334c700 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -841,18 +841,14 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm;
 
-	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(is->alloc_ctx)) {
-		ret = PTR_ERR(is->alloc_ctx);
-		goto err_pm;
-	}
+	is->alloc_ctx = dev;
 	/*
 	 * Register FIMC-IS V4L2 subdevs to this driver. The video nodes
 	 * will be created within the subdev's registered() callback.
 	 */
 	ret = fimc_is_register_subdevs(is);
 	if (ret < 0)
-		goto err_vb;
+		goto err_pm;
 
 	ret = fimc_is_debugfs_create(is);
 	if (ret < 0)
@@ -871,8 +867,6 @@ err_dfs:
 	fimc_is_debugfs_remove(is);
 err_sd:
 	fimc_is_unregister_subdevs(is);
-err_vb:
-	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 err_pm:
 	if (!pm_runtime_enabled(dev))
 		fimc_is_runtime_suspend(dev);
@@ -933,7 +927,6 @@ static int fimc_is_remove(struct platform_device *pdev)
 		fimc_is_runtime_suspend(dev);
 	free_irq(is->irq, is);
 	fimc_is_unregister_subdevs(is);
-	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 	fimc_is_put_clocks(is);
 	fimc_is_debugfs_remove(is);
 	release_firmware(is->fw.f_w);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 386eb49..edb1e74 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -256,7 +256,7 @@ struct fimc_is {
 	struct fimc_is_sensor		sensor[FIMC_IS_SENSORS_NUM];
 	struct fimc_is_setfile		setfile;
 
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 	struct v4l2_ctrl_handler	ctrl_handler;
 
 	struct mutex			lock;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index f88a369..5511849 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -41,7 +41,7 @@
 static int isp_video_capture_queue_setup(struct vb2_queue *vq,
 			const void *parg,
 			unsigned int *num_buffers, unsigned int *num_planes,
-			unsigned int sizes[], void *allocators[])
+			unsigned int sizes[], struct device *allocators[])
 {
 	const struct v4l2_format *pfmt = parg;
 	struct fimc_isp *isp = vb2_get_drv_priv(vq);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index e0686b5..3496454 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -161,7 +161,7 @@ struct fimc_is_video {
  */
 struct fimc_isp {
 	struct platform_device		*pdev;
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 	struct v4l2_subdev		subdev;
 	struct media_pad		subdev_pads[FIMC_ISP_SD_PADS_NUM];
 	struct v4l2_mbus_framefmt	src_fmt;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 6f76afd..bf12aed 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -357,7 +357,7 @@ static void stop_streaming(struct vb2_queue *q)
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *num_buffers, unsigned int *num_planes,
-		       unsigned int sizes[], void *allocators[])
+		       unsigned int sizes[], struct device *allocators[])
 {
 	const struct v4l2_format *pfmt = parg;
 	const struct v4l2_pix_format_mplane *pixm = NULL;
@@ -1564,11 +1564,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 			goto err_sd;
 	}
 
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(fimc->alloc_ctx)) {
-		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_clk_dis;
-	}
+	fimc->alloc_ctx = dev;
 
 	fimc_lite_set_default_config(fimc);
 
@@ -1576,9 +1572,6 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		fimc->index);
 	return 0;
 
-err_clk_dis:
-	if (!pm_runtime_enabled(dev))
-		clk_disable(fimc->clock);
 err_sd:
 	fimc_lite_unregister_capture_subdev(fimc);
 err_clk_put:
@@ -1664,7 +1657,6 @@ static int fimc_lite_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	fimc_lite_unregister_capture_subdev(fimc);
-	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 	fimc_lite_clk_put(fimc);
 
 	dev_info(dev, "Driver unloaded\n");
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 11690d5..394924a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -148,7 +148,7 @@ struct fimc_lite {
 	struct exynos_video_entity ve;
 	struct v4l2_device	*v4l2_dev;
 	struct v4l2_fh		fh;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 	struct v4l2_subdev	subdev;
 	struct media_pad	vd_pad;
 	struct media_pad	subdev_pads[FLITE_SD_PADS_NUM];
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 4d1d64a4..060b72f 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -178,7 +178,7 @@ static void fimc_job_abort(void *priv)
 
 static int fimc_queue_setup(struct vb2_queue *vq, const void *parg,
 			    unsigned int *num_buffers, unsigned int *num_planes,
-			    unsigned int sizes[], void *allocators[])
+			    unsigned int sizes[], struct device *allocators[])
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
 	struct fimc_frame *f;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 29973f9..2168a0d 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -136,7 +136,7 @@ struct deinterlace_dev {
 	struct dma_chan		*dma_chan;
 
 	struct v4l2_m2m_dev	*m2m_dev;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 };
 
 struct deinterlace_ctx {
@@ -800,7 +800,7 @@ struct vb2_dc_conf {
 static int deinterlace_queue_setup(struct vb2_queue *vq,
 				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vq);
 	struct deinterlace_q_data *q_data;
@@ -1047,12 +1047,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcdev);
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
-		ret = PTR_ERR(pcdev->alloc_ctx);
-		goto err_ctx;
-	}
+	pcdev->alloc_ctx = &pdev->dev;
 
 	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(pcdev->m2m_dev)) {
@@ -1065,8 +1060,6 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 err_m2m:
 	video_unregister_device(&pcdev->vfd);
-err_ctx:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 rel_dma:
@@ -1083,7 +1076,6 @@ static int deinterlace_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	video_unregister_device(&pcdev->vfd);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	dma_release_channel(pcdev->dma_chan);
 
 	return 0;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 4f2ec88..efbe4df 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1051,7 +1051,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
 static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		const void *parg, unsigned int *nbufs,
 		unsigned int *num_planes, unsigned int sizes[],
-		void *alloc_ctxs[])
+		struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
@@ -1278,9 +1278,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->mem_ops = &vb2_dma_contig_memops;
 		cam->dma_setup = mcam_ctlr_dma_contig;
 		cam->frame_complete = mcam_dma_contig_done;
-		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
-		if (IS_ERR(cam->vb_alloc_ctx))
-			return PTR_ERR(cam->vb_alloc_ctx);
+		cam->vb_alloc_ctx = cam->dev;
 #endif
 		break;
 	case B_DMA_sg:
@@ -1289,9 +1287,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->mem_ops = &vb2_dma_sg_memops;
 		cam->dma_setup = mcam_ctlr_dma_sg;
 		cam->frame_complete = mcam_dma_sg_done;
-		cam->vb_alloc_ctx_sg = vb2_dma_sg_init_ctx(cam->dev);
-		if (IS_ERR(cam->vb_alloc_ctx_sg))
-			return PTR_ERR(cam->vb_alloc_ctx_sg);
+		cam->vb_alloc_ctx_sg = cam->dev;
 #endif
 		break;
 	case B_vmalloc:
@@ -1308,18 +1304,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	return vb2_queue_init(vq);
 }
 
-static void mcam_cleanup_vb2(struct mcam_camera *cam)
-{
-#ifdef MCAM_MODE_DMA_CONTIG
-	if (cam->buffer_mode == B_DMA_contig)
-		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
-#endif
-#ifdef MCAM_MODE_DMA_SG
-	if (cam->buffer_mode == B_DMA_sg)
-		vb2_dma_sg_cleanup_ctx(cam->vb_alloc_ctx_sg);
-#endif
-}
-
 
 /* ---------------------------------------------------------------------- */
 /*
@@ -1874,7 +1858,6 @@ void mccic_shutdown(struct mcam_camera *cam)
 		cam_warn(cam, "Removing a device with users!\n");
 		mcam_ctlr_power_down(cam);
 	}
-	mcam_cleanup_vb2(cam);
 	if (cam->buffer_mode == B_vmalloc)
 		mcam_free_dma_bufs(cam);
 	video_unregister_device(&cam->vdev);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 35cd9e5..9448c53 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -176,8 +176,8 @@ struct mcam_camera {
 
 	/* DMA buffers - DMA modes */
 	struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
-	struct vb2_alloc_ctx *vb_alloc_ctx;
-	struct vb2_alloc_ctx *vb_alloc_ctx_sg;
+	struct device *vb_alloc_ctx;
+	struct device *vb_alloc_ctx_sg;
 
 	/* Mode-specific ops, set at open time */
 	void (*dma_setup)(struct mcam_camera *cam);
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 03a1b60..f0a45cd 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -211,7 +211,7 @@ struct emmaprp_dev {
 	struct clk		*clk_emma_ahb, *clk_emma_ipg;
 
 	struct v4l2_m2m_dev	*m2m_dev;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 };
 
 struct emmaprp_ctx {
@@ -691,7 +691,7 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
 static int emmaprp_queue_setup(struct vb2_queue *vq,
 				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vq);
 	struct emmaprp_q_data *q_data;
@@ -949,18 +949,13 @@ static int emmaprp_probe(struct platform_device *pdev)
 	if (ret)
 		goto rel_vdev;
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
-		ret = PTR_ERR(pcdev->alloc_ctx);
-		goto rel_vdev;
-	}
+	pcdev->alloc_ctx = &pdev->dev;
 
 	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(pcdev->m2m_dev)) {
 		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(pcdev->m2m_dev);
-		goto rel_ctx;
+		goto rel_vdev;
 	}
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
@@ -974,8 +969,6 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 rel_m2m:
 	v4l2_m2m_release(pcdev->m2m_dev);
-rel_ctx:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
@@ -994,7 +987,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 
 	video_unregister_device(pcdev->vfd);
 	v4l2_m2m_release(pcdev->m2m_dev);
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 	mutex_destroy(&pcdev->dev_mutex);
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index f4f5916..48c872f 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -322,7 +322,7 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
 static int isp_video_queue_setup(struct vb2_queue *queue,
 				 const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], void *alloc_ctxs[])
+				 unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct isp_video_fh *vfh = vb2_get_drv_priv(queue);
 	struct isp_video *video = vfh->video;
@@ -1364,15 +1364,11 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 		return -EINVAL;
 	}
 
-	video->alloc_ctx = vb2_dma_contig_init_ctx(video->isp->dev);
-	if (IS_ERR(video->alloc_ctx))
-		return PTR_ERR(video->alloc_ctx);
+	video->alloc_ctx = video->isp->dev;
 
 	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
-	if (ret < 0) {
-		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
+	if (ret < 0)
 		return ret;
-	}
 
 	mutex_init(&video->mutex);
 	atomic_set(&video->active, 0);
@@ -1401,7 +1397,6 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 
 void omap3isp_video_cleanup(struct isp_video *video)
 {
-	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	media_entity_cleanup(&video->video.entity);
 	mutex_destroy(&video->queue_lock);
 	mutex_destroy(&video->stream_lock);
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 86d2a3d..3f85f5d 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1017,7 +1017,7 @@ error_free:
 static int jpu_queue_setup(struct vb2_queue *vq,
 			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
@@ -1670,12 +1670,7 @@ static int jpu_probe(struct platform_device *pdev)
 		goto device_register_rollback;
 	}
 
-	jpu->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(jpu->alloc_ctx)) {
-		v4l2_err(&jpu->v4l2_dev, "Failed to init memory allocator\n");
-		ret = PTR_ERR(jpu->alloc_ctx);
-		goto m2m_init_rollback;
-	}
+	jpu->alloc_ctx = &pdev->dev;
 
 	/* fill in qantization and Huffman tables for encoder */
 	for (i = 0; i < JPU_MAX_QUALITY; i++)
@@ -1693,7 +1688,7 @@ static int jpu_probe(struct platform_device *pdev)
 	ret = video_register_device(&jpu->vfd_encoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&jpu->v4l2_dev, "Failed to register video device\n");
-		goto vb2_allocator_rollback;
+		goto m2m_init_rollback;
 	}
 
 	video_set_drvdata(&jpu->vfd_encoder, jpu);
@@ -1726,9 +1721,6 @@ static int jpu_probe(struct platform_device *pdev)
 enc_vdev_register_rollback:
 	video_unregister_device(&jpu->vfd_encoder);
 
-vb2_allocator_rollback:
-	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
-
 m2m_init_rollback:
 	v4l2_m2m_release(jpu->m2m_dev);
 
@@ -1744,7 +1736,6 @@ static int jpu_remove(struct platform_device *pdev)
 
 	video_unregister_device(&jpu->vfd_decoder);
 	video_unregister_device(&jpu->vfd_encoder);
-	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
 	v4l2_m2m_release(jpu->m2m_dev);
 	v4l2_device_unregister(&jpu->v4l2_dev);
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 537b858..e3fc13e 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -437,7 +437,7 @@ static void stop_streaming(struct vb2_queue *vq)
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *num_buffers, unsigned int *num_planes,
-		       unsigned int sizes[], void *allocators[])
+		       unsigned int sizes[], struct device *allocators[])
 {
 	const struct v4l2_format *pfmt = parg;
 	const struct v4l2_pix_format *pix = NULL;
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 1ba9bb0..827ccc7 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -477,11 +477,7 @@ static int s3c_camif_probe(struct platform_device *pdev)
 		goto err_pm;
 
 	/* Initialize contiguous memory allocator */
-	camif->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(camif->alloc_ctx)) {
-		ret = PTR_ERR(camif->alloc_ctx);
-		goto err_alloc;
-	}
+	camif->alloc_ctx = dev;
 
 	ret = camif_media_dev_register(camif);
 	if (ret < 0)
@@ -520,8 +516,6 @@ err_sens:
 	media_device_unregister(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 err_mdev:
-	vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
-err_alloc:
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
 err_pm:
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index 57cbc3d..1c0c38a 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -291,7 +291,7 @@ struct camif_dev {
 	u8				colorfx_cr;
 
 	struct camif_vp			vp[CAMIF_VP_NUM];
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 
 	const struct s3c_camif_variant	*variant;
 	struct device			*dev;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e1936d9..f37a8a6 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -103,7 +103,7 @@ static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
 
 static int g2d_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct g2d_ctx *ctx = vb2_get_drv_priv(vq);
 	struct g2d_frame *f = get_frame(ctx, vq->type);
@@ -681,15 +681,11 @@ static int g2d_probe(struct platform_device *pdev)
 		goto put_clk_gate;
 	}
 
-	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		ret = PTR_ERR(dev->alloc_ctx);
-		goto unprep_clk_gate;
-	}
+	dev->alloc_ctx = &pdev->dev;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		goto alloc_ctx_cleanup;
+		goto unprep_clk_gate;
 	vfd = video_device_alloc();
 	if (!vfd) {
 		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
@@ -738,8 +734,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_v4l2_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
-alloc_ctx_cleanup:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 unprep_clk_gate:
 	clk_unprepare(dev->gate);
 put_clk_gate:
@@ -760,7 +754,6 @@ static int g2d_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->m2m_dev);
 	video_unregister_device(dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	clk_unprepare(dev->gate);
 	clk_put(dev->gate);
 	clk_unprepare(dev->clk);
diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
index b0e52ab..0194b51 100644
--- a/drivers/media/platform/s5p-g2d/g2d.h
+++ b/drivers/media/platform/s5p-g2d/g2d.h
@@ -25,7 +25,7 @@ struct g2d_dev {
 	struct mutex		mutex;
 	spinlock_t		ctrl_lock;
 	atomic_t		num_inst;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 	void __iomem		*regs;
 	struct clk		*clk;
 	struct clk		*gate;
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 4a608cb..5e791a1 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2432,7 +2432,7 @@ static struct v4l2_m2m_ops exynos4_jpeg_m2m_ops = {
 static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
 			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
 	struct s5p_jpeg_q_data *q_data = NULL;
@@ -2839,19 +2839,14 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		goto device_register_rollback;
 	}
 
-	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(jpeg->alloc_ctx)) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
-		ret = PTR_ERR(jpeg->alloc_ctx);
-		goto m2m_init_rollback;
-	}
+	jpeg->alloc_ctx = &pdev->dev;
 
 	/* JPEG encoder /dev/videoX node */
 	jpeg->vfd_encoder = video_device_alloc();
 	if (!jpeg->vfd_encoder) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
 		ret = -ENOMEM;
-		goto vb2_allocator_rollback;
+		goto m2m_init_rollback;
 	}
 	snprintf(jpeg->vfd_encoder->name, sizeof(jpeg->vfd_encoder->name),
 				"%s-enc", S5P_JPEG_M2M_NAME);
@@ -2867,7 +2862,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	if (ret) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
 		video_device_release(jpeg->vfd_encoder);
-		goto vb2_allocator_rollback;
+		goto m2m_init_rollback;
 	}
 
 	video_set_drvdata(jpeg->vfd_encoder, jpeg);
@@ -2916,9 +2911,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 enc_vdev_register_rollback:
 	video_unregister_device(jpeg->vfd_encoder);
 
-vb2_allocator_rollback:
-	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
-
 m2m_init_rollback:
 	v4l2_m2m_release(jpeg->m2m_dev);
 
@@ -2937,7 +2929,6 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 
 	video_unregister_device(jpeg->vfd_decoder);
 	video_unregister_device(jpeg->vfd_encoder);
-	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3ffe2ec..4ce55e8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1143,22 +1143,14 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
-	if (IS_ERR(dev->alloc_ctx[0])) {
-		ret = PTR_ERR(dev->alloc_ctx[0]);
-		goto err_res;
-	}
-	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
-	if (IS_ERR(dev->alloc_ctx[1])) {
-		ret = PTR_ERR(dev->alloc_ctx[1]);
-		goto err_mem_init_ctx_1;
-	}
+	dev->alloc_ctx[0] = dev->mem_dev_l;
+	dev->alloc_ctx[1] = dev->mem_dev_r;
 
 	mutex_init(&dev->mfc_mutex);
 
 	ret = s5p_mfc_alloc_firmware(dev);
 	if (ret)
-		goto err_alloc_fw;
+		goto err_res;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
@@ -1243,10 +1235,6 @@ err_dec_alloc:
 	v4l2_device_unregister(&dev->v4l2_dev);
 err_v4l2_dev_reg:
 	s5p_mfc_release_firmware(dev);
-err_alloc_fw:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
-err_mem_init_ctx_1:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 err_res:
 	s5p_mfc_final_pm(dev);
 
@@ -1270,8 +1258,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	video_unregister_device(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_release_firmware(dev);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
 	if (pdev->dev.of_node) {
 		put_device(dev->mem_dev_l);
 		put_device(dev->mem_dev_r);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 1c4998c..979ee24 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -890,7 +890,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			const void *parg, unsigned int *buf_count,
 			unsigned int *plane_count, unsigned int psize[],
-			void *allocators[])
+			struct device *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 115b7da..4521432 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1820,7 +1820,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			const void *parg,
 			unsigned int *buf_count, unsigned int *plane_count,
-			unsigned int psize[], void *allocators[])
+			unsigned int psize[], struct device *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index dc1c679..ead163b 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -80,12 +80,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 		goto fail;
 	}
 
-	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
-	if (IS_ERR(mdev->alloc_ctx)) {
-		mxr_err(mdev, "could not acquire vb2 allocator\n");
-		ret = PTR_ERR(mdev->alloc_ctx);
-		goto fail_v4l2_dev;
-	}
+	mdev->alloc_ctx = mdev->dev;
 
 	/* registering outputs */
 	mdev->output_cnt = 0;
@@ -120,7 +115,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 		mxr_err(mdev, "failed to register any output\n");
 		ret = -ENODEV;
 		/* skipping fail_output because there is nothing to free */
-		goto fail_vb2_allocator;
+		goto fail_v4l2_dev;
 	}
 
 	return 0;
@@ -131,10 +126,6 @@ fail_output:
 		kfree(mdev->output[i]);
 	memset(mdev->output, 0, sizeof(mdev->output));
 
-fail_vb2_allocator:
-	/* freeing allocator context */
-	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
-
 fail_v4l2_dev:
 	/* NOTE: automatically unregister all subdevs */
 	v4l2_device_unregister(v4l2_dev);
@@ -151,7 +142,6 @@ void mxr_release_video(struct mxr_device *mdev)
 	for (i = 0; i < mdev->output_cnt; ++i)
 		kfree(mdev->output[i]);
 
-	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
 	v4l2_device_unregister(&mdev->v4l2_dev);
 }
 
@@ -883,7 +873,7 @@ static const struct v4l2_file_operations mxr_fops = {
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 	unsigned int *nbuffers, unsigned int *nplanes, unsigned int sizes[],
-	void *alloc_ctxs[])
+	struct device *alloc_ctxs[])
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
 	const struct mxr_format *fmt = layer->fmt;
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index d6ab33e..7da3edc 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -118,7 +118,7 @@ struct sh_veu_dev {
 	struct sh_veu_file *output;
 	struct mutex fop_lock;
 	void __iomem *base;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	spinlock_t lock;
 	bool is_2h;
 	unsigned int xaction;
@@ -867,7 +867,7 @@ static const struct v4l2_ioctl_ops sh_veu_ioctl_ops = {
 static int sh_veu_queue_setup(struct vb2_queue *vq,
 			      const void *parg,
 			      unsigned int *nbuffers, unsigned int *nplanes,
-			      unsigned int sizes[], void *alloc_ctxs[])
+			      unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *f = parg;
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vq);
@@ -1161,11 +1161,7 @@ static int sh_veu_probe(struct platform_device *pdev)
 
 	vdev = &veu->vdev;
 
-	veu->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(veu->alloc_ctx)) {
-		ret = PTR_ERR(veu->alloc_ctx);
-		goto einitctx;
-	}
+	veu->alloc_ctx = &pdev->dev;
 
 	*vdev = sh_veu_videodev;
 	vdev->v4l2_dev = &veu->v4l2_dev;
@@ -1200,8 +1196,6 @@ evidreg:
 	pm_runtime_disable(&pdev->dev);
 	v4l2_m2m_release(veu->m2m_dev);
 em2minit:
-	vb2_dma_contig_cleanup_ctx(veu->alloc_ctx);
-einitctx:
 	v4l2_device_unregister(&veu->v4l2_dev);
 	return ret;
 }
@@ -1215,7 +1209,6 @@ static int sh_veu_remove(struct platform_device *pdev)
 	video_unregister_device(&veu->vdev);
 	pm_runtime_disable(&pdev->dev);
 	v4l2_m2m_release(veu->m2m_dev);
-	vb2_dma_contig_cleanup_ctx(veu->alloc_ctx);
 	v4l2_device_unregister(&veu->v4l2_dev);
 
 	return 0;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 544e2b5..b3e091e 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -86,7 +86,7 @@ struct sh_vou_device {
 	v4l2_std_id std;
 	int pix_idx;
 	struct vb2_queue queue;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	struct sh_vou_buffer *active;
 	enum sh_vou_status status;
 	unsigned sequence;
@@ -245,7 +245,7 @@ static void sh_vou_stream_config(struct sh_vou_device *vou_dev)
 /* Locking: caller holds fop_lock mutex */
 static int sh_vou_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct sh_vou_device *vou_dev = vb2_get_drv_priv(vq);
@@ -1307,14 +1307,9 @@ static int sh_vou_probe(struct platform_device *pdev)
 	q->lock = &vou_dev->fop_lock;
 	ret = vb2_queue_init(q);
 	if (ret)
-		goto einitctx;
+		goto eqinit;
 
-	vou_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(vou_dev->alloc_ctx)) {
-		dev_err(&pdev->dev, "Can't allocate buffer context");
-		ret = PTR_ERR(vou_dev->alloc_ctx);
-		goto einitctx;
-	}
+	vou_dev->alloc_ctx = &pdev->dev;
 	vdev->queue = q;
 	INIT_LIST_HEAD(&vou_dev->buf_list);
 
@@ -1349,9 +1344,8 @@ ei2cnd:
 ereset:
 	i2c_put_adapter(i2c_adap);
 ei2cgadap:
-	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
-einitctx:
 	pm_runtime_disable(&pdev->dev);
+eqinit:
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	return ret;
 }
@@ -1368,7 +1362,6 @@ static int sh_vou_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(&vou_dev->vdev);
 	i2c_put_adapter(client->adapter);
-	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f5f815d..df69242 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -72,7 +72,7 @@ struct atmel_isi {
 
 	int				sequence;
 
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 
 	/* Allocate descriptors for dma buffer use */
 	struct fbd			*p_fb_descriptors;
@@ -305,7 +305,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
    ------------------------------------------------------------------*/
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -963,7 +963,6 @@ static int atmel_isi_remove(struct platform_device *pdev)
 					struct atmel_isi, soc_host);
 
 	soc_camera_host_unregister(soc_host);
-	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
 	dma_free_coherent(&pdev->dev,
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
@@ -1067,11 +1066,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		list_add(&isi->dma_desc[i].list, &isi->dma_desc_head);
 	}
 
-	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(isi->alloc_ctx)) {
-		ret = PTR_ERR(isi->alloc_ctx);
-		goto err_alloc_ctx;
-	}
+	isi->alloc_ctx = &pdev->dev;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	isi->regs = devm_ioremap_resource(&pdev->dev, regs);
@@ -1119,8 +1114,6 @@ err_register_soc_camera_host:
 	pm_runtime_disable(&pdev->dev);
 err_req_irq:
 err_ioremap:
-	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
-err_alloc_ctx:
 	dma_free_coherent(&pdev->dev,
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 276beae..680bea5 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -266,7 +266,7 @@ struct mx2_camera_dev {
 	struct emma_prp_resize	resizing[2];
 	unsigned int		s_width, s_height;
 	u32			frame_count;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 };
 
 static struct platform_device_id mx2_camera_devtype[] = {
@@ -471,7 +471,7 @@ static void mx2_camera_clock_stop(struct soc_camera_host *ici)
 static int mx2_videobuf_setup(struct vb2_queue *vq,
 			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
@@ -1585,11 +1585,7 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		err = PTR_ERR(pcdev->alloc_ctx);
-		goto eallocctx;
-	}
+	pcdev->alloc_ctx = &pdev->dev;
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_emma;
@@ -1600,8 +1596,6 @@ static int mx2_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_emma:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-eallocctx:
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
 exit:
@@ -1616,8 +1610,6 @@ static int mx2_camera_remove(struct platform_device *pdev)
 
 	soc_camera_host_unregister(&pcdev->soc_host);
 
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 046ebf0..68785ae 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -108,7 +108,7 @@ struct mx3_camera_dev {
 	spinlock_t		lock;		/* Protects video buffer lists */
 	struct mx3_camera_buffer *active;
 	size_t			buf_total;
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 	enum v4l2_field		field;
 	int			sequence;
 
@@ -187,7 +187,7 @@ static void mx3_cam_dma_done(void *arg)
 static int mx3_videobuf_setup(struct vb2_queue *vq,
 			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
@@ -1226,9 +1226,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	soc_host->v4l2_dev.dev	= &pdev->dev;
 	soc_host->nr		= pdev->id;
 
-	mx3_cam->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(mx3_cam->alloc_ctx))
-		return PTR_ERR(mx3_cam->alloc_ctx);
+	mx3_cam->alloc_ctx = &pdev->dev;
 
 	if (pdata->asd_sizes) {
 		soc_host->asd = pdata->asd;
@@ -1237,16 +1235,12 @@ static int mx3_camera_probe(struct platform_device *pdev)
 
 	err = soc_camera_host_register(soc_host);
 	if (err)
-		goto ecamhostreg;
+		return err;
 
 	/* IDMAC interface */
 	dmaengine_get();
 
 	return 0;
-
-ecamhostreg:
-	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
-	return err;
 }
 
 static int mx3_camera_remove(struct platform_device *pdev)
@@ -1264,8 +1258,6 @@ static int mx3_camera_remove(struct platform_device *pdev)
 	if (WARN_ON(mx3_cam->idmac_channel[0]))
 		dma_release_channel(&mx3_cam->idmac_channel[0]->dma_chan);
 
-	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
-
 	dmaengine_put();
 
 	return 0;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 5d90f39..f92463df 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -483,7 +483,7 @@ struct rcar_vin_priv {
 	struct list_head		capture;
 #define MAX_BUFFER_NUM			3
 	struct vb2_v4l2_buffer		*queue_buf[MAX_BUFFER_NUM];
-	struct vb2_alloc_ctx		*alloc_ctx;
+	struct device			*alloc_ctx;
 	enum v4l2_field			field;
 	unsigned int			pdata_flags;
 	unsigned int			vb_count;
@@ -534,7 +534,7 @@ static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
 				   const void *parg,
 				   unsigned int *count,
 				   unsigned int *num_planes,
-				   unsigned int sizes[], void *alloc_ctxs[])
+				   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
@@ -1917,9 +1917,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	priv->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(priv->alloc_ctx))
-		return PTR_ERR(priv->alloc_ctx);
+	priv->alloc_ctx = &pdev->dev;
 
 	priv->ici.priv = priv;
 	priv->ici.v4l2_dev.dev = &pdev->dev;
@@ -1951,7 +1949,6 @@ static int rcar_vin_probe(struct platform_device *pdev)
 
 cleanup:
 	pm_runtime_disable(&pdev->dev);
-	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
 
 	return ret;
 }
@@ -1959,12 +1956,9 @@ cleanup:
 static int rcar_vin_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
-	struct rcar_vin_priv *priv = container_of(soc_host,
-						  struct rcar_vin_priv, ici);
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
-	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index ad21307..248b7b75d 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -113,7 +113,7 @@ struct sh_mobile_ceu_dev {
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
 	struct vb2_v4l2_buffer *active;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
 	struct completion complete;
@@ -212,7 +212,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			const void *parg,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct soc_camera_device *icd = container_of(vq,
@@ -1849,11 +1849,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
 	pcdev->ici.capabilities = SOCAM_HOST_CAP_STRIDE;
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		err = PTR_ERR(pcdev->alloc_ctx);
-		goto exit_free_clk;
-	}
+	pcdev->alloc_ctx = &pdev->dev;
 
 	if (pcdev->pdata && pcdev->pdata->asd_sizes) {
 		struct v4l2_async_subdev **asd;
@@ -1899,7 +1895,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 
 		if (!csi2_pdev) {
 			err = -ENOMEM;
-			goto exit_free_ctx;
+			goto exit_free_clk;
 		}
 
 		pcdev->csi2_pdev		= csi2_pdev;
@@ -1982,8 +1978,6 @@ exit_pdev_put:
 		pcdev->csi2_pdev->resource = NULL;
 		platform_device_put(pcdev->csi2_pdev);
 	}
-exit_free_ctx:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_free_clk:
 	pm_runtime_disable(&pdev->dev);
 exit_release_mem:
@@ -2003,7 +1997,6 @@ static int sh_mobile_ceu_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	if (csi2_pdev && csi2_pdev->dev.driver) {
 		struct module *csi2_drv = csi2_pdev->dev.driver->owner;
 		platform_device_del(csi2_pdev);
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index a0d267e..2f683aa 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -440,7 +440,7 @@ static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
 static int bdisp_queue_setup(struct vb2_queue *vq,
 			     const void *parg,
 			     unsigned int *nb_buf, unsigned int *nb_planes,
-			     unsigned int sizes[], void *allocators[])
+			     unsigned int sizes[], struct device *allocators[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
@@ -1271,8 +1271,6 @@ static int bdisp_remove(struct platform_device *pdev)
 
 	bdisp_hw_free_filters(bdisp->dev);
 
-	vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
-
 	pm_runtime_disable(&pdev->dev);
 
 	bdisp_debugfs_remove(bdisp);
@@ -1374,17 +1372,13 @@ static int bdisp_probe(struct platform_device *pdev)
 	}
 
 	/* Continuous memory allocator */
-	bdisp->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(bdisp->alloc_ctx)) {
-		ret = PTR_ERR(bdisp->alloc_ctx);
-		goto err_pm;
-	}
+	bdisp->alloc_ctx = dev;
 
 	/* Filters */
 	if (bdisp_hw_alloc_filters(bdisp->dev)) {
 		dev_err(bdisp->dev, "no memory for filters\n");
 		ret = -ENOMEM;
-		goto err_vb2_dma;
+		goto err_pm;
 	}
 
 	/* Register */
@@ -1403,8 +1397,6 @@ static int bdisp_probe(struct platform_device *pdev)
 
 err_filter:
 	bdisp_hw_free_filters(bdisp->dev);
-err_vb2_dma:
-	vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
 err_pm:
 	pm_runtime_put(dev);
 err_dbg:
diff --git a/drivers/media/platform/sti/bdisp/bdisp.h b/drivers/media/platform/sti/bdisp/bdisp.h
index 0cf9857..e8fb659 100644
--- a/drivers/media/platform/sti/bdisp/bdisp.h
+++ b/drivers/media/platform/sti/bdisp/bdisp.h
@@ -193,7 +193,7 @@ struct bdisp_dev {
 	u16                     id;
 	struct bdisp_m2m_device m2m;
 	unsigned long           state;
-	struct vb2_alloc_ctx    *alloc_ctx;
+	struct device		*alloc_ctx;
 	struct clk              *clock;
 	void __iomem            *regs;
 	wait_queue_head_t       irq_queue;
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index de24eff..b4f716f 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -362,7 +362,7 @@ struct vpe_dev {
 	void __iomem		*base;
 	struct resource		*res;
 
-	struct vb2_alloc_ctx	*alloc_ctx;
+	struct device		*alloc_ctx;
 	struct vpdma_data	*vpdma;		/* vpdma data handle */
 	struct sc_data		*sc;		/* scaler data handle */
 	struct csc_data		*csc;		/* csc data handle */
@@ -1798,7 +1798,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 static int vpe_queue_setup(struct vb2_queue *vq,
 			   const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	int i;
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vq);
@@ -2162,7 +2162,6 @@ static void vpe_fw_cb(struct platform_device *pdev)
 		vpe_runtime_put(pdev);
 		pm_runtime_disable(&pdev->dev);
 		v4l2_m2m_release(dev->m2m_dev);
-		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 		v4l2_device_unregister(&dev->v4l2_dev);
 
 		return;
@@ -2214,18 +2213,13 @@ static int vpe_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
-	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		vpe_err(dev, "Failed to alloc vb2 context\n");
-		ret = PTR_ERR(dev->alloc_ctx);
-		goto v4l2_dev_unreg;
-	}
+	dev->alloc_ctx = &pdev->dev;
 
 	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(dev->m2m_dev)) {
 		vpe_err(dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(dev->m2m_dev);
-		goto rel_ctx;
+		goto v4l2_dev_unreg;
 	}
 
 	pm_runtime_enable(&pdev->dev);
@@ -2270,8 +2264,6 @@ runtime_put:
 rel_m2m:
 	pm_runtime_disable(&pdev->dev);
 	v4l2_m2m_release(dev->m2m_dev);
-rel_ctx:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 v4l2_dev_unreg:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
@@ -2287,7 +2279,6 @@ static int vpe_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->m2m_dev);
 	video_unregister_device(&dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 
 	vpe_set_clock_enable(dev, 0);
 	vpe_runtime_put(pdev);
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e18fb9f..fcc2cea 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -712,7 +712,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 static int vim2m_queue_setup(struct vb2_queue *vq,
 				const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vq);
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 082c401..2402efb 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -215,7 +215,7 @@ static int vivid_thread_sdr_cap(void *data)
 
 static int sdr_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_ctxs[])
 {
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = SDR_CAP_SAMPLES_PER_BUF * 2;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index e903d02..64573ea 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -139,7 +139,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
 
 static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 75c5709..dc64023 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -29,7 +29,7 @@
 
 static int vbi_out_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_ctxs[])
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
 	bool is_60hz = dev->std_out & V4L2_STD_525_60;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 9cc07c6..cb18664 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -97,7 +97,7 @@ static const struct v4l2_discrete_probe webcam_probe = {
 
 static int vid_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 1f3b081..dee47c5 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -33,7 +33,7 @@
 
 static int vid_out_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
-		       unsigned sizes[], void *alloc_ctxs[])
+		       unsigned sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct vivid_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 5ce88e1..5c9adae 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -789,7 +789,7 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
 static int
 vsp1_video_queue_setup(struct vb2_queue *vq, const void *parg,
 		     unsigned int *nbuffers, unsigned int *nplanes,
-		     unsigned int sizes[], void *alloc_ctxs[])
+		     unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
@@ -1253,11 +1253,7 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
 	video_set_drvdata(&video->video, video);
 
 	/* ... and the buffers queue... */
-	video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
-	if (IS_ERR(video->alloc_ctx)) {
-		ret = PTR_ERR(video->alloc_ctx);
-		goto error;
-	}
+	video->alloc_ctx = video->vsp1->dev;
 
 	video->queue.type = video->type;
 	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
@@ -1284,7 +1280,6 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
 	return 0;
 
 error:
-	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	vsp1_video_cleanup(video);
 	return ret;
 }
@@ -1294,6 +1289,5 @@ void vsp1_video_cleanup(struct vsp1_video *video)
 	if (video_is_registered(&video->video))
 		video_unregister_device(&video->video);
 
-	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	media_entity_cleanup(&video->video.entity);
 }
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d11cc70..8dae137 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -311,7 +311,7 @@ static void xvip_dma_complete(void *param)
 static int
 xvip_dma_queue_setup(struct vb2_queue *vq, const void *parg,
 		     unsigned int *nbuffers, unsigned int *nplanes,
-		     unsigned int sizes[], void *alloc_ctxs[])
+		     unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct xvip_dma *dma = vb2_get_drv_priv(vq);
@@ -701,11 +701,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	video_set_drvdata(&dma->video, dma);
 
 	/* ... and the buffers queue... */
-	dma->alloc_ctx = vb2_dma_contig_init_ctx(dma->xdev->dev);
-	if (IS_ERR(dma->alloc_ctx)) {
-		ret = PTR_ERR(dma->alloc_ctx);
-		goto error;
-	}
+	dma->alloc_ctx = dma->xdev->dev;
 
 	/* Don't enable VB2_READ and VB2_WRITE, as using the read() and write()
 	 * V4L2 APIs would be inefficient. Testing on the command line with a
@@ -761,9 +757,6 @@ void xvip_dma_cleanup(struct xvip_dma *dma)
 	if (dma->dma)
 		dma_release_channel(dma->dma);
 
-	if (!IS_ERR_OR_NULL(dma->alloc_ctx))
-		vb2_dma_contig_cleanup_ctx(dma->alloc_ctx);
-
 	media_entity_cleanup(&dma->video.entity);
 
 	mutex_destroy(&dma->lock);
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index fcbb497..4ffcc08 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -489,7 +489,7 @@ static void airspy_disconnect(struct usb_interface *intf)
 /* Videobuf2 operations */
 static int airspy_queue_setup(struct vb2_queue *vq,
 		const void *parg, unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int *nplanes, unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 130c8b4..79002b5 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -32,7 +32,7 @@
 
 static int vbi_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 45c622e..03d9a46 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -640,7 +640,7 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index e23c285..07f82d6 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -33,7 +33,7 @@
 
 static int vbi_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct em28xx *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index bba2052..36dc1f0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -873,7 +873,7 @@ static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct em28xx *dev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index ae5038b..44056ec 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -371,7 +371,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int go7007_queue_setup(struct vb2_queue *q,
 		const void *parg,
 		unsigned int *num_buffers, unsigned int *num_planes,
-		unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	sizes[0] = GO7007_BUF_SIZE;
 	*num_planes = 1;
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e05bfec..91976de 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -751,7 +751,7 @@ static void hackrf_return_all_buffers(struct vb2_queue *vq,
 
 static int hackrf_queue_setup(struct vb2_queue *vq,
 		const void *parg, unsigned int *nbuffers,
-		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+		unsigned int *nplanes, unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index e06a21a..fadb565 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -619,7 +619,7 @@ static int msi2500_queue_setup(struct vb2_queue *vq,
 			       const void *parg,
 			       unsigned int *nbuffers,
 			       unsigned int *nplanes, unsigned int sizes[],
-			       void *alloc_ctxs[])
+			       struct device *alloc_ctxs[])
 {
 	struct msi2500_dev *dev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index b79c36f..4869a0a 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -573,7 +573,7 @@ static void pwc_video_release(struct v4l2_device *v)
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 	int size;
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index e7acb12..2d33072 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -662,7 +662,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
-		       unsigned int sizes[], void *alloc_ctxs[])
+		       unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct s2255_vc *vc = vb2_get_drv_priv(vq);
 	if (*nbuffers < S2255_MIN_BUFS)
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 9a69bb5..50eec40 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -666,7 +666,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
  */
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 				unsigned int *nbuffers, unsigned int *nplanes,
-				unsigned int sizes[], void *alloc_ctxs[])
+				unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct stk1160 *dev = vb2_get_drv_priv(vq);
 	unsigned long size;
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index e645c9d..17cd290 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -600,7 +600,7 @@ static struct v4l2_file_operations usbtv_fops = {
 
 static int usbtv_queue_setup(struct vb2_queue *vq,
 	const void *parg, unsigned int *nbuffers,
-	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+	unsigned int *nplanes, unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cfb868a..3204d61 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -71,7 +71,7 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
 
 static int uvc_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	const struct v4l2_format *fmt = parg;
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index c331272..ebff876 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -21,10 +21,6 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-memops.h>
 
-struct vb2_dc_conf {
-	struct device		*dev;
-};
-
 struct vb2_dc_buf {
 	struct device			*dev;
 	void				*vaddr;
@@ -136,11 +132,9 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
+static void *vb2_dc_alloc(struct device *dev, unsigned long size,
 			  enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
-	struct device *dev = conf->dev;
 	struct vb2_dc_buf *buf;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
@@ -470,10 +464,9 @@ static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn
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
@@ -501,7 +494,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	buf->dma_dir = dma_dir;
 
 	offset = vaddr & ~PAGE_MASK;
@@ -668,10 +661,9 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
 	struct dma_buf_attachment *dba;
 
@@ -682,7 +674,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
 	dba = dma_buf_attach(dbuf, buf->dev);
 	if (IS_ERR(dba)) {
@@ -721,27 +713,6 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
-void *vb2_dma_contig_init_ctx(struct device *dev)
-{
-	struct vb2_dc_conf *conf;
-
-	conf = kzalloc(sizeof *conf, GFP_KERNEL);
-	if (!conf)
-		return ERR_PTR(-ENOMEM);
-
-	conf->dev = dev;
-
-	return conf;
-}
-EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
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
index 9985c89..175ed7f 100644
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
@@ -99,10 +95,9 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
+static void *vb2_dma_sg_alloc(struct device *dev, unsigned long size,
 			      enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
-	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	struct sg_table *sgt;
 	int ret;
@@ -111,7 +106,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
-	if (WARN_ON(alloc_ctx == NULL))
+	if (WARN_ON(dev == NULL))
 		return NULL;
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -140,7 +135,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 		goto fail_table_alloc;
 
 	/* Prevent the device from being released while the buffer is used */
-	buf->dev = get_device(conf->dev);
+	buf->dev = get_device(dev);
 
 	sgt = &buf->sg_table;
 	/*
@@ -226,11 +221,10 @@ static void vb2_dma_sg_finish(void *buf_priv)
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
@@ -242,7 +236,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		return NULL;
 
 	buf->vaddr = NULL;
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	buf->dma_dir = dma_dir;
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
@@ -616,10 +610,9 @@ static void vb2_dma_sg_detach_dmabuf(void *mem_priv)
 	kfree(buf);
 }
 
-static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+static void *vb2_dma_sg_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
-	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	struct dma_buf_attachment *dba;
 
@@ -630,7 +623,7 @@ static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dev = conf->dev;
+	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
 	dba = dma_buf_attach(dbuf, buf->dev);
 	if (IS_ERR(dba)) {
@@ -672,27 +665,6 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
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
index 1c30274..513ab19 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -33,7 +33,7 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size,
+static void *vb2_vmalloc_alloc(struct device *alloc_ctx, unsigned long size,
 			       enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
@@ -69,7 +69,7 @@ static void vb2_vmalloc_put(void *buf_priv)
 	}
 }
 
-static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
+static void *vb2_vmalloc_get_userptr(struct device *alloc_ctx, unsigned long vaddr,
 				     unsigned long size,
 				     enum dma_data_direction dma_dir)
 {
@@ -403,7 +403,7 @@ static void vb2_vmalloc_detach_dmabuf(void *mem_priv)
 	kfree(buf);
 }
 
-static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+static void *vb2_vmalloc_attach_dmabuf(struct device *alloc_ctx, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
 	struct vb2_vmalloc_buf *buf;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 0fdff91..fbad79d 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -524,7 +524,6 @@ static int vpfe_release(struct file *file)
 		video->io_usrs = 0;
 		/* Free buffers allocated */
 		vb2_queue_release(&video->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	}
 	/* Decrement device users counter */
 	video->usrs--;
@@ -1080,7 +1079,7 @@ vpfe_g_dv_timings(struct file *file, void *fh,
 static int
 vpfe_buffer_queue_setup(struct vb2_queue *vq, const void *parg,
 			unsigned int *nbuffers, unsigned int *nplanes,
-			unsigned int sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpfe_video_device *video = fh->video;
@@ -1330,11 +1329,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	video->memory = req_buf->memory;
 
 	/* Initialize videobuf2 queue as per the buffer type */
-	video->alloc_ctx = vb2_dma_contig_init_ctx(vpfe_dev->pdev);
-	if (IS_ERR(video->alloc_ctx)) {
-		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to get the context\n");
-		return PTR_ERR(video->alloc_ctx);
-	}
+	video->alloc_ctx = vpfe_dev->pdev;
 
 	q = &video->buffer_queue;
 	q->type = req_buf->type;
@@ -1349,7 +1344,6 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	ret = vb2_queue_init(q);
 	if (ret) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(vpfe_dev->pdev);
 		return ret;
 	}
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index 673cefe..6098bb3 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -123,7 +123,7 @@ struct vpfe_video_device {
 	struct v4l2_format			fmt;
 	struct vb2_queue			buffer_queue;
 	/* allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device				*alloc_ctx;
 	/* Queue of filled frames */
 	struct list_head			dma_queue;
 	spinlock_t				irqlock;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 2a0158b..08f50ab 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -289,7 +289,7 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
 static int iss_video_queue_setup(struct vb2_queue *vq,
 				 const void *parg,
 				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], void *alloc_ctxs[])
+				 unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
 	struct iss_video *video = vfh->video;
@@ -991,12 +991,7 @@ static int iss_video_open(struct file *file)
 		goto done;
 	}
 
-	video->alloc_ctx = vb2_dma_contig_init_ctx(video->iss->dev);
-	if (IS_ERR(video->alloc_ctx)) {
-		ret = PTR_ERR(video->alloc_ctx);
-		omap4iss_put(video->iss);
-		goto done;
-	}
+	video->alloc_ctx = video->iss->dev;
 
 	q = &handle->queue;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 41532ed..e6daffc 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -170,7 +170,7 @@ struct iss_video {
 	spinlock_t qlock;		/* protects dmaqueue and error */
 	struct list_head dmaqueue;
 	enum iss_video_dmaqueue_flags dmaqueue_flags;
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 
 	const struct iss_video_operations *ops;
 };
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 51d4a17..81c141d 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -43,7 +43,7 @@
 
 static int uvc_queue_setup(struct vb2_queue *vq, const void *parg,
 			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
+			   unsigned int sizes[], struct device *alloc_ctxs[])
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_video *video = container_of(queue, struct uvc_video, queue);
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index e14a937..c87d442 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -82,7 +82,7 @@ struct vpbe_layer {
 	 */
 	struct vb2_queue buffer_queue;
 	/* allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
+	struct device *alloc_ctx;
 	/* Queue of filled frames */
 	struct list_head dma_queue;
 	/* Used in video-buf */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 647ebfe..449ea79 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -27,7 +27,6 @@ enum vb2_memory {
 	VB2_MEMORY_DMABUF	= 4,
 };
 
-struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
 
@@ -93,13 +92,13 @@ struct vb2_threadio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size,
+	void		*(*alloc)(struct device *alloc_ctx, unsigned long size,
 				  enum dma_data_direction dma_dir,
 				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
-	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
+	void		*(*get_userptr)(struct device *alloc_ctx, unsigned long vaddr,
 					unsigned long size,
 					enum dma_data_direction dma_dir);
 	void		(*put_userptr)(void *buf_priv);
@@ -107,7 +106,7 @@ struct vb2_mem_ops {
 	void		(*prepare)(void *buf_priv);
 	void		(*finish)(void *buf_priv);
 
-	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
+	void		*(*attach_dmabuf)(struct device *alloc_ctx, struct dma_buf *dbuf,
 					  unsigned long size,
 					  enum dma_data_direction dma_dir);
 	void		(*detach_dmabuf)(void *buf_priv);
@@ -346,7 +345,7 @@ struct vb2_buffer {
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, const void *parg,
 			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], void *alloc_ctxs[]);
+			   unsigned int sizes[], struct device *alloc_ctxs[]);
 
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
@@ -469,7 +468,7 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	void				*alloc_ctx[VB2_MAX_PLANES];
+	struct device			*alloc_ctx[VB2_MAX_PLANES];
 	unsigned int			plane_sizes[VB2_MAX_PLANES];
 
 	unsigned int			streaming:1;
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index c33dfa6..513fa81 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -24,9 +24,6 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 	return *addr;
 }
 
-void *vb2_dma_contig_init_ctx(struct device *dev);
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
2.6.4


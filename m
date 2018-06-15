Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35922 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965052AbeFOTIX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:08:23 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 17/17] media: Remove wait_{prepare, finish}
Date: Fri, 15 Jun 2018 16:07:37 -0300
Message-Id: <20180615190737.24139-18-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all drivers provide a proper vb2_queue lock,
and that wait_{prepare, finish} are no longer in use,
get rid of them.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 Documentation/media/kapi/v4l2-dev.rst          |  7 +++----
 drivers/input/rmi4/rmi_f54.c                   |  2 --
 drivers/input/touchscreen/atmel_mxt_ts.c       |  2 --
 drivers/input/touchscreen/sur40.c              |  2 --
 .../media/common/videobuf2/videobuf2-v4l2.c    | 14 --------------
 drivers/media/dvb-core/dvb_vb2.c               |  2 --
 drivers/media/dvb-frontends/rtl2832_sdr.c      |  2 --
 drivers/media/i2c/video-i2c.c                  |  2 --
 drivers/media/pci/cobalt/cobalt-v4l2.c         |  2 --
 drivers/media/pci/cx23885/cx23885-417.c        |  2 --
 drivers/media/pci/cx23885/cx23885-dvb.c        |  2 --
 drivers/media/pci/cx23885/cx23885-vbi.c        |  2 --
 drivers/media/pci/cx23885/cx23885-video.c      |  2 --
 drivers/media/pci/cx25821/cx25821-video.c      |  2 --
 drivers/media/pci/cx88/cx88-blackbird.c        |  2 --
 drivers/media/pci/cx88/cx88-dvb.c              |  2 --
 drivers/media/pci/cx88/cx88-vbi.c              |  2 --
 drivers/media/pci/cx88/cx88-video.c            |  2 --
 drivers/media/pci/dt3155/dt3155.c              |  2 --
 drivers/media/pci/intel/ipu3/ipu3-cio2.c       |  2 --
 drivers/media/pci/saa7134/saa7134-empress.c    |  2 --
 drivers/media/pci/saa7134/saa7134-ts.c         |  2 --
 drivers/media/pci/saa7134/saa7134-vbi.c        |  2 --
 drivers/media/pci/saa7134/saa7134-video.c      |  2 --
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c |  2 --
 drivers/media/pci/solo6x10/solo6x10-v4l2.c     |  2 --
 drivers/media/pci/sta2x11/sta2x11_vip.c        |  2 --
 drivers/media/pci/tw5864/tw5864-video.c        |  2 --
 drivers/media/pci/tw68/tw68-video.c            |  2 --
 drivers/media/pci/tw686x/tw686x-video.c        |  2 --
 drivers/media/platform/am437x/am437x-vpfe.c    |  2 --
 drivers/media/platform/atmel/atmel-isc.c       |  2 --
 drivers/media/platform/atmel/atmel-isi.c       |  2 --
 drivers/media/platform/coda/coda-common.c      |  2 --
 drivers/media/platform/davinci/vpbe_display.c  |  2 --
 drivers/media/platform/davinci/vpif_capture.c  |  2 --
 drivers/media/platform/davinci/vpif_display.c  |  2 --
 drivers/media/platform/exynos-gsc/gsc-m2m.c    |  2 --
 .../media/platform/exynos4-is/fimc-capture.c   |  2 --
 .../media/platform/exynos4-is/fimc-isp-video.c |  2 --
 drivers/media/platform/exynos4-is/fimc-lite.c  |  2 --
 drivers/media/platform/exynos4-is/fimc-m2m.c   |  2 --
 drivers/media/platform/m2m-deinterlace.c       |  2 --
 .../media/platform/marvell-ccic/mcam-core.c    |  4 ----
 .../media/platform/mtk-jpeg/mtk_jpeg_core.c    |  2 --
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c   |  2 --
 .../media/platform/mtk-vcodec/mtk_vcodec_dec.c |  2 --
 .../media/platform/mtk-vcodec/mtk_vcodec_enc.c |  2 --
 drivers/media/platform/mx2_emmaprp.c           |  2 --
 drivers/media/platform/omap3isp/ispvideo.c     |  2 --
 drivers/media/platform/pxa_camera.c            |  2 --
 .../platform/qcom/camss-8x16/camss-video.c     |  2 --
 drivers/media/platform/qcom/venus/vdec.c       |  2 --
 drivers/media/platform/qcom/venus/venc.c       |  2 --
 drivers/media/platform/rcar-vin/rcar-dma.c     |  2 --
 drivers/media/platform/rcar_drif.c             |  2 --
 drivers/media/platform/rcar_fdp1.c             |  2 --
 drivers/media/platform/rcar_jpu.c              |  2 --
 drivers/media/platform/renesas-ceu.c           |  2 --
 drivers/media/platform/rockchip/rga/rga-buf.c  |  2 --
 .../media/platform/s3c-camif/camif-capture.c   |  2 --
 drivers/media/platform/s5p-g2d/g2d.c           |  2 --
 drivers/media/platform/s5p-jpeg/jpeg-core.c    |  2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c   |  2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   |  2 --
 drivers/media/platform/sh_veu.c                |  2 --
 drivers/media/platform/sh_vou.c                |  2 --
 .../platform/soc_camera/sh_mobile_ceu_camera.c |  2 --
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c  |  2 --
 drivers/media/platform/sti/delta/delta-v4l2.c  |  4 ----
 drivers/media/platform/sti/hva/hva-v4l2.c      |  2 --
 drivers/media/platform/stm32/stm32-dcmi.c      |  2 --
 drivers/media/platform/ti-vpe/cal.c            |  2 --
 drivers/media/platform/ti-vpe/vpe.c            |  2 --
 drivers/media/platform/vim2m.c                 |  2 --
 drivers/media/platform/vimc/vimc-capture.c     |  6 ------
 drivers/media/platform/vivid/vivid-sdr-cap.c   |  2 --
 drivers/media/platform/vivid/vivid-vbi-cap.c   |  2 --
 drivers/media/platform/vivid/vivid-vbi-out.c   |  2 --
 drivers/media/platform/vivid/vivid-vid-cap.c   |  2 --
 drivers/media/platform/vivid/vivid-vid-out.c   |  2 --
 drivers/media/platform/vsp1/vsp1_histo.c       |  2 --
 drivers/media/platform/vsp1/vsp1_video.c       |  2 --
 drivers/media/platform/xilinx/xilinx-dma.c     |  2 --
 drivers/media/usb/airspy/airspy.c              |  2 --
 drivers/media/usb/au0828/au0828-vbi.c          |  2 --
 drivers/media/usb/au0828/au0828-video.c        |  2 --
 drivers/media/usb/em28xx/em28xx-vbi.c          |  2 --
 drivers/media/usb/em28xx/em28xx-video.c        |  2 --
 drivers/media/usb/go7007/go7007-v4l2.c         |  2 --
 drivers/media/usb/gspca/gspca.c                |  2 --
 drivers/media/usb/hackrf/hackrf.c              |  2 --
 drivers/media/usb/msi2500/msi2500.c            |  2 --
 drivers/media/usb/pwc/pwc-if.c                 |  2 --
 drivers/media/usb/s2255/s2255drv.c             |  2 --
 drivers/media/usb/stk1160/stk1160-v4l.c        |  2 --
 drivers/media/usb/usbtv/usbtv-video.c          |  2 --
 drivers/media/usb/uvc/uvc_queue.c              |  4 ----
 .../staging/media/davinci_vpfe/vpfe_video.c    |  2 --
 drivers/staging/media/imx/imx-media-capture.c  |  2 --
 .../bcm2835-camera/bcm2835-camera.c            |  2 --
 drivers/usb/gadget/function/uvc_queue.c        |  2 --
 include/media/videobuf2-v4l2.h                 | 18 ------------------
 samples/v4l/v4l2-pci-skeleton.c                |  7 -------
 104 files changed, 3 insertions(+), 253 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index eb03ccc41c41..ec25531308d3 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -163,10 +163,9 @@ waits in the code, then you should do the same to allow other
 processes to access the device node while the first process is waiting for
 something.
 
-In the case of :ref:`videobuf2 <vb2_framework>` you will need to implement the
-``wait_prepare()`` and ``wait_finish()`` callbacks to unlock/lock if applicable.
-If you use the ``queue->lock`` pointer, then you can use the helper functions
-:c:func:`vb2_ops_wait_prepare` and :c:func:`vb2_ops_wait_finish`.
+In the case of :ref:`videobuf2 <vb2_framework>` you are required to define a
+``queue->lock`` mutex, which is used to protect all the queue-specific
+ioctls.
 
 The implementation of a hotplug disconnect should also take the lock from
 :c:type:`video_device` before calling v4l2_device_disconnect. If you are also
diff --git a/drivers/input/rmi4/rmi_f54.c b/drivers/input/rmi4/rmi_f54.c
index 98a935efec8e..3f88e9f4610f 100644
--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -355,8 +355,6 @@ static void rmi_f54_buffer_queue(struct vb2_buffer *vb)
 static const struct vb2_ops rmi_f54_queue_ops = {
 	.queue_setup            = rmi_f54_queue_setup,
 	.buf_queue              = rmi_f54_buffer_queue,
-	.wait_prepare           = vb2_ops_wait_prepare,
-	.wait_finish            = vb2_ops_wait_finish,
 };
 
 static const struct vb2_queue rmi_f54_queue = {
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 54fe190fd4bc..499664ff754f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2368,8 +2368,6 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
 static const struct vb2_ops mxt_queue_ops = {
 	.queue_setup		= mxt_queue_setup,
 	.buf_queue		= mxt_buffer_queue,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static const struct vb2_queue mxt_queue = {
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 894843a7ec7b..8b22b742fff2 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -1102,8 +1102,6 @@ static const struct vb2_ops sur40_queue_ops = {
 	.buf_queue		= sur40_buffer_queue,
 	.start_streaming	= sur40_start_streaming,
 	.stop_streaming		= sur40_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static const struct vb2_queue sur40_queue = {
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 7d2172468f72..d0d87483e5c3 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -934,20 +934,6 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
 #endif
 
-/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
-
-void vb2_ops_wait_prepare(struct vb2_queue *vq)
-{
-	mutex_unlock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
-
-void vb2_ops_wait_finish(struct vb2_queue *vq)
-{
-	mutex_lock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
-
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index cd3ea44f0ae9..b2bb238459c9 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -113,8 +113,6 @@ static const struct vb2_ops dvb_vb2_qops = {
 	.buf_queue		= _buffer_queue,
 	.start_streaming	= _start_streaming,
 	.stop_streaming		= _stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static void _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index c6e78d870ccd..b1836c7f3581 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -962,8 +962,6 @@ static const struct vb2_ops rtl2832_sdr_vb2_ops = {
 	.buf_queue              = rtl2832_sdr_buf_queue,
 	.start_streaming        = rtl2832_sdr_start_streaming,
 	.stop_streaming         = rtl2832_sdr_stop_streaming,
-	.wait_prepare           = vb2_ops_wait_prepare,
-	.wait_finish            = vb2_ops_wait_finish,
 };
 
 static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 0b347cc19aa5..a6fb7cc9219c 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -269,8 +269,6 @@ static struct vb2_ops video_i2c_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int video_i2c_querycap(struct file *file, void  *priv,
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index e2a4c705d353..9415ae2ee694 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -428,8 +428,6 @@ static const struct vb2_ops cobalt_qops = {
 	.buf_queue = cobalt_buf_queue,
 	.start_streaming = cobalt_start_streaming,
 	.stop_streaming = cobalt_stop_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 /* V4L2 ioctls */
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a71f3c7569ce..84fff69e6df3 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1219,8 +1219,6 @@ static const struct vb2_ops cx23885_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = cx23885_start_streaming,
 	.stop_streaming = cx23885_stop_streaming,
 };
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 7d52173073d6..e8f4c4150a0b 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -180,8 +180,6 @@ static const struct vb2_ops dvb_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = cx23885_start_streaming,
 	.stop_streaming = cx23885_stop_streaming,
 };
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 70f9f13bded3..cb766f042cb9 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -259,8 +259,6 @@ const struct vb2_ops cx23885_vbi_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = cx23885_start_streaming,
 	.stop_streaming = cx23885_stop_streaming,
 };
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index f8a3deadc77a..4401ed1c81c4 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -525,8 +525,6 @@ static const struct vb2_ops cx23885_video_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = cx23885_start_streaming,
 	.stop_streaming = cx23885_stop_streaming,
 };
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index dbaf42ec26cd..0256043487d8 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -308,8 +308,6 @@ static const struct vb2_ops cx25821_video_qops = {
 	.buf_prepare  = cx25821_buffer_prepare,
 	.buf_finish = cx25821_buffer_finish,
 	.buf_queue    = cx25821_buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = cx25821_start_streaming,
 	.stop_streaming = cx25821_stop_streaming,
 };
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 7a4876cf9f08..0ccffecd0b51 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -789,8 +789,6 @@ static const struct vb2_ops blackbird_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
 };
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index ccfde28d4af2..b27587d119b6 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -160,8 +160,6 @@ static const struct vb2_ops dvb_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
 };
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 58489ea0c1da..635fb719fa99 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -228,8 +228,6 @@ const struct vb2_ops cx8800_vbi_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
 };
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 7b113bad70d2..a6acbeeb69c8 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -581,8 +581,6 @@ static const struct vb2_ops cx8800_video_qops = {
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
 	.buf_queue    = buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
 };
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 1775c36891ae..cf2666d754b2 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -235,8 +235,6 @@ static void dt3155_buf_queue(struct vb2_buffer *vb)
 
 static const struct vb2_ops q_ops = {
 	.queue_setup = dt3155_queue_setup,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.buf_prepare = dt3155_buf_prepare,
 	.start_streaming = dt3155_start_streaming,
 	.stop_streaming = dt3155_stop_streaming,
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 29027159eced..3fc3cbf2e2af 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1055,8 +1055,6 @@ static const struct vb2_ops cio2_vb2_ops = {
 	.queue_setup = cio2_vb2_queue_setup,
 	.start_streaming = cio2_vb2_start_streaming,
 	.stop_streaming = cio2_vb2_stop_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 /**************** V4L2 interface ****************/
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66acfd35ffc6..f01096a22b59 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -86,8 +86,6 @@ static const struct vb2_ops saa7134_empress_qops = {
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
 	.buf_queue	= saa7134_vb2_buffer_queue,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
 };
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2be703617e29..bcf66d1b8ba0 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -175,8 +175,6 @@ struct vb2_ops saa7134_ts_qops = {
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
 	.buf_queue	= saa7134_vb2_buffer_queue,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 	.stop_streaming = saa7134_ts_stop_streaming,
 };
 EXPORT_SYMBOL_GPL(saa7134_ts_qops);
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 57bea543c39b..f8e17370265b 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -170,8 +170,6 @@ const struct vb2_ops saa7134_vbi_qops = {
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
 	.buf_queue	= saa7134_vb2_buffer_queue,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 	.start_streaming = saa7134_vb2_start_streaming,
 	.stop_streaming = saa7134_vb2_stop_streaming,
 };
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 1a50ec9d084f..57da6a1d5b4c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1055,8 +1055,6 @@ static const struct vb2_ops vb2_qops = {
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
 	.buf_queue	= saa7134_vb2_buffer_queue,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 	.start_streaming = saa7134_vb2_start_streaming,
 	.stop_streaming = saa7134_vb2_stop_streaming,
 };
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 25f9f2ebff1d..e7f01d29092b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -765,8 +765,6 @@ static const struct vb2_ops solo_enc_video_qops = {
 	.buf_finish	= solo_enc_buf_finish,
 	.start_streaming = solo_enc_start_streaming,
 	.stop_streaming = solo_enc_stop_streaming,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 };
 
 static int solo_enc_querycap(struct file *file, void  *priv,
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 99ffd1ed4a73..7c172d793b1b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -374,8 +374,6 @@ static const struct vb2_ops solo_video_qops = {
 	.buf_queue	= solo_buf_queue,
 	.start_streaming = solo_start_streaming,
 	.stop_streaming = solo_stop_streaming,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 };
 
 static int solo_querycap(struct file *file, void  *priv,
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index da2b2a2292d0..c5ddff6f6458 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -386,8 +386,6 @@ static const struct vb2_ops vip_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index ff2b7da90c08..49de5db67783 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -479,8 +479,6 @@ static const struct vb2_ops tw5864_video_qops = {
 	.buf_queue = tw5864_buf_queue,
 	.start_streaming = tw5864_start_streaming,
 	.stop_streaming = tw5864_stop_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 static int tw5864_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8c1f4a049764..2841604d0514 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -540,8 +540,6 @@ static const struct vb2_ops tw68_video_qops = {
 	.buf_finish	= tw68_buf_finish,
 	.start_streaming = tw68_start_streaming,
 	.stop_streaming = tw68_stop_streaming,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 };
 
 /* ------------------------------------------------------------------ */
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 0ea8dd44026c..ed5730ab1d72 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -583,8 +583,6 @@ static const struct vb2_ops tw686x_video_qops = {
 	.buf_prepare		= tw686x_buf_prepare,
 	.start_streaming	= tw686x_start_streaming,
 	.stop_streaming		= tw686x_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int tw686x_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 58ebc2220d0e..a3926348baea 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2230,8 +2230,6 @@ static long vpfe_ioctl_default(struct file *file, void *priv,
 }
 
 static const struct vb2_ops vpfe_video_qops = {
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.queue_setup		= vpfe_queue_setup,
 	.buf_prepare		= vpfe_buffer_prepare,
 	.buf_queue		= vpfe_buffer_queue,
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d89e14524d42..be5aec085de0 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1225,8 +1225,6 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
 
 static const struct vb2_ops isc_vb2_ops = {
 	.queue_setup		= isc_queue_setup,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.buf_prepare		= isc_buffer_prepare,
 	.start_streaming	= isc_start_streaming,
 	.stop_streaming		= isc_stop_streaming,
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e5be21a31640..a6febaf7634b 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -527,8 +527,6 @@ static const struct vb2_ops isi_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int isi_g_fmt_vid_cap(struct file *file, void *priv,
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c7631e117dd3..08f618cc4cbe 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1664,8 +1664,6 @@ static const struct vb2_ops coda_qops = {
 	.buf_queue		= coda_buf_queue,
 	.start_streaming	= coda_start_streaming,
 	.stop_streaming		= coda_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index b0eb3d899eb4..974d735e5bb2 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -360,8 +360,6 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 
 static const struct vb2_ops video_qops = {
 	.queue_setup = vpbe_buffer_queue_setup,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.buf_prepare = vpbe_buffer_prepare,
 	.start_streaming = vpbe_start_streaming,
 	.stop_streaming = vpbe_stop_streaming,
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 9364cdf62f54..e29e39de036b 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -318,8 +318,6 @@ static const struct vb2_ops video_qops = {
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
 	.buf_queue		= vpif_buffer_queue,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /**
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 7be636237acf..2aa32d31922e 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -292,8 +292,6 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 
 static const struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
 	.stop_streaming		= vpif_stop_streaming,
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index e9ff27949a91..673fb3710abd 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -282,8 +282,6 @@ static const struct vb2_ops gsc_m2m_qops = {
 	.queue_setup	 = gsc_m2m_queue_setup,
 	.buf_prepare	 = gsc_m2m_buf_prepare,
 	.buf_queue	 = gsc_m2m_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = gsc_m2m_stop_streaming,
 	.start_streaming = gsc_m2m_start_streaming,
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index a3cdac188190..8b0aa1eca9cb 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -457,8 +457,6 @@ static const struct vb2_ops fimc_capture_qops = {
 	.queue_setup		= queue_setup,
 	.buf_prepare		= buffer_prepare,
 	.buf_queue		= buffer_queue,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 55ba696b8cf4..570c29d7f1a2 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -258,8 +258,6 @@ static const struct vb2_ops isp_video_capture_qops = {
 	.queue_setup	 = isp_video_capture_queue_setup,
 	.buf_prepare	 = isp_video_capture_buffer_prepare,
 	.buf_queue	 = isp_video_capture_buffer_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = isp_video_capture_start_streaming,
 	.stop_streaming	 = isp_video_capture_stop_streaming,
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 70d5f5586a5d..b00f36e93118 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -450,8 +450,6 @@ static const struct vb2_ops fimc_lite_qops = {
 	.queue_setup	 = queue_setup,
 	.buf_prepare	 = buffer_prepare,
 	.buf_queue	 = buffer_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming	 = stop_streaming,
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index a19f8b164a47..cc0289be3e18 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -223,8 +223,6 @@ static const struct vb2_ops fimc_qops = {
 	.queue_setup	 = fimc_queue_setup,
 	.buf_prepare	 = fimc_buf_prepare,
 	.buf_queue	 = fimc_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = stop_streaming,
 	.start_streaming = start_streaming,
 };
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 94dd8ec0f265..c264e4c92980 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -856,8 +856,6 @@ static const struct vb2_ops deinterlace_qops = {
 	.queue_setup	 = deinterlace_queue_setup,
 	.buf_prepare	 = deinterlace_buf_prepare,
 	.buf_queue	 = deinterlace_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index dfdbd4354b74..5932e417d0c9 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1178,8 +1178,6 @@ static const struct vb2_ops mcam_vb2_ops = {
 	.buf_queue		= mcam_vb_buf_queue,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 
@@ -1242,8 +1240,6 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 	.buf_cleanup		= mcam_vb_sg_buf_cleanup,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 #endif /* MCAM_MODE_DMA_SG */
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 328e8f650d9b..948a02ef88f4 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -760,8 +760,6 @@ static const struct vb2_ops mtk_jpeg_qops = {
 	.queue_setup        = mtk_jpeg_queue_setup,
 	.buf_prepare        = mtk_jpeg_buf_prepare,
 	.buf_queue          = mtk_jpeg_buf_queue,
-	.wait_prepare       = vb2_ops_wait_prepare,
-	.wait_finish        = vb2_ops_wait_finish,
 	.start_streaming    = mtk_jpeg_start_streaming,
 	.stop_streaming     = mtk_jpeg_stop_streaming,
 };
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index c2e2f5f1ebf1..4bee830b1071 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -613,8 +613,6 @@ static const struct vb2_ops mtk_mdp_m2m_qops = {
 	.buf_queue	 = mtk_mdp_m2m_buf_queue,
 	.stop_streaming	 = mtk_mdp_m2m_stop_streaming,
 	.start_streaming = mtk_mdp_m2m_start_streaming,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int mtk_mdp_m2m_querycap(struct file *file, void *fh,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 86f0a7134365..c7e709dff7dd 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1439,8 +1439,6 @@ static const struct vb2_ops mtk_vdec_vb2_ops = {
 	.queue_setup	= vb2ops_vdec_queue_setup,
 	.buf_prepare	= vb2ops_vdec_buf_prepare,
 	.buf_queue	= vb2ops_vdec_buf_queue,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 	.buf_init	= vb2ops_vdec_buf_init,
 	.buf_finish	= vb2ops_vdec_buf_finish,
 	.start_streaming	= vb2ops_vdec_start_streaming,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 1b1a28abbf1f..fe1b908161cd 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -927,8 +927,6 @@ static const struct vb2_ops mtk_venc_vb2_ops = {
 	.queue_setup		= vb2ops_venc_queue_setup,
 	.buf_prepare		= vb2ops_venc_buf_prepare,
 	.buf_queue		= vb2ops_venc_buf_queue,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= vb2ops_venc_start_streaming,
 	.stop_streaming		= vb2ops_venc_stop_streaming,
 };
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 7f9b356e7cc7..ce029cfdfe52 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -747,8 +747,6 @@ static const struct vb2_ops emmaprp_qops = {
 	.queue_setup	 = emmaprp_queue_setup,
 	.buf_prepare	 = emmaprp_buf_prepare,
 	.buf_queue	 = emmaprp_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index f835aeb9ddc5..5f13b6b465fc 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -496,8 +496,6 @@ static const struct vb2_ops isp_video_queue_ops = {
 	.buf_prepare = isp_video_buffer_prepare,
 	.buf_queue = isp_video_buffer_queue,
 	.start_streaming = isp_video_start_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 /*
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 4d5a26b4cdda..4ee02c2afdea 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1570,8 +1570,6 @@ static const struct vb2_ops pxac_vb2_ops = {
 	.buf_cleanup		= pxac_vb2_cleanup,
 	.start_streaming	= pxac_vb2_start_streaming,
 	.stop_streaming		= pxac_vb2_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.c b/drivers/media/platform/qcom/camss-8x16/camss-video.c
index ffaa2849e0c1..4b40fa7b10bd 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.c
@@ -417,8 +417,6 @@ static void video_stop_streaming(struct vb2_queue *q)
 
 static const struct vb2_ops msm_video_vb2_q_ops = {
 	.queue_setup     = video_queue_setup,
-	.wait_prepare    = vb2_ops_wait_prepare,
-	.wait_finish     = vb2_ops_wait_finish,
 	.buf_init        = video_buf_init,
 	.buf_prepare     = video_buf_prepare,
 	.buf_queue       = video_buf_queue,
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 41d14df46f5d..be1bd9b44138 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -783,8 +783,6 @@ static const struct vb2_ops vdec_vb2_ops = {
 	.start_streaming = vdec_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 016af21abf5d..2084d3055160 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -976,8 +976,6 @@ static const struct vb2_ops venc_vb2_ops = {
 	.start_streaming = venc_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ac07f99e3516..d7d23620158d 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1219,8 +1219,6 @@ static const struct vb2_ops rvin_qops = {
 	.buf_queue		= rvin_buffer_queue,
 	.start_streaming	= rvin_start_streaming,
 	.stop_streaming		= rvin_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 void rvin_dma_unregister(struct rvin_dev *vin)
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index dc7e280c91b4..fb719613a171 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -865,8 +865,6 @@ static const struct vb2_ops rcar_drif_vb2_ops = {
 	.buf_queue              = rcar_drif_buf_queue,
 	.start_streaming        = rcar_drif_start_streaming,
 	.stop_streaming         = rcar_drif_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int rcar_drif_querycap(struct file *file, void *fh,
diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index b13dec3081e5..d2585e6b6364 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2038,8 +2038,6 @@ static const struct vb2_ops fdp1_qops = {
 	.buf_queue	 = fdp1_buf_queue,
 	.start_streaming = fdp1_start_streaming,
 	.stop_streaming  = fdp1_stop_streaming,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 8b44a849ab41..2ff194f70ed1 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1190,8 +1190,6 @@ static const struct vb2_ops jpu_qops = {
 	.buf_finish		= jpu_buf_finish,
 	.start_streaming	= jpu_start_streaming,
 	.stop_streaming		= jpu_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int jpu_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index fe4fe944592d..bf6bbeaceca6 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -753,8 +753,6 @@ static const struct vb2_ops ceu_vb2_ops = {
 	.queue_setup		= ceu_vb2_setup,
 	.buf_queue		= ceu_vb2_queue,
 	.buf_prepare		= ceu_vb2_prepare,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= ceu_start_streaming,
 	.stop_streaming		= ceu_stop_streaming,
 };
diff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-buf.c
index fa1ba98c96dc..09b4c877021d 100644
--- a/drivers/media/platform/rockchip/rga/rga-buf.c
+++ b/drivers/media/platform/rockchip/rga/rga-buf.c
@@ -108,8 +108,6 @@ const struct vb2_ops rga_qops = {
 	.queue_setup = rga_queue_setup,
 	.buf_prepare = rga_buf_prepare,
 	.buf_queue = rga_buf_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = rga_buf_start_streaming,
 	.stop_streaming = rga_buf_stop_streaming,
 };
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 9ab8e7ee2e1e..ec767a650a59 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -526,8 +526,6 @@ static const struct vb2_ops s3c_camif_qops = {
 	.queue_setup	 = queue_setup,
 	.buf_prepare	 = buffer_prepare,
 	.buf_queue	 = buffer_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming	 = stop_streaming,
 };
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index ce4280730835..66aa8cf1d048 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -142,8 +142,6 @@ static const struct vb2_ops g2d_qops = {
 	.queue_setup	= g2d_queue_setup,
 	.buf_prepare	= g2d_buf_prepare,
 	.buf_queue	= g2d_buf_queue,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 79b63da27f53..69f85dc09366 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2644,8 +2644,6 @@ static const struct vb2_ops s5p_jpeg_qops = {
 	.queue_setup		= s5p_jpeg_queue_setup,
 	.buf_prepare		= s5p_jpeg_buf_prepare,
 	.buf_queue		= s5p_jpeg_buf_queue,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= s5p_jpeg_start_streaming,
 	.stop_streaming		= s5p_jpeg_stop_streaming,
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 6a3cc4f86c5d..e872b71bb52d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1099,8 +1099,6 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 
 static struct vb2_ops s5p_mfc_dec_qops = {
 	.queue_setup		= s5p_mfc_queue_setup,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.buf_init		= s5p_mfc_buf_init,
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 570f391f2cfd..0b4dae3cc87d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -2606,8 +2606,6 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 
 static struct vb2_ops s5p_mfc_enc_qops = {
 	.queue_setup		= s5p_mfc_queue_setup,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 	.buf_init		= s5p_mfc_buf_init,
 	.buf_prepare		= s5p_mfc_buf_prepare,
 	.start_streaming	= s5p_mfc_start_streaming,
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 1a0cde017fdf..3dd550523033 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -925,8 +925,6 @@ static const struct vb2_ops sh_veu_qops = {
 	.queue_setup	 = sh_veu_queue_setup,
 	.buf_prepare	 = sh_veu_buf_prepare,
 	.buf_queue	 = sh_veu_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 4dccf29e9d78..9da2c121a03a 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -369,8 +369,6 @@ static const struct vb2_ops sh_vou_qops = {
 	.buf_queue		= sh_vou_buf_queue,
 	.start_streaming	= sh_vou_start_streaming,
 	.stop_streaming		= sh_vou_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /* Video IOCTLs */
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 242342fd7ede..ec7db9cfefaa 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -475,8 +475,6 @@ static const struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 	.buf_queue	= sh_mobile_ceu_videobuf_queue,
 	.buf_cleanup	= sh_mobile_ceu_videobuf_release,
 	.buf_init	= sh_mobile_ceu_videobuf_init,
-	.wait_prepare	= vb2_ops_wait_prepare,
-	.wait_finish	= vb2_ops_wait_finish,
 	.stop_streaming	= sh_mobile_ceu_stop_streaming,
 };
 
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 66b64096f5de..6e3bdae5ed2f 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -531,8 +531,6 @@ static const struct vb2_ops bdisp_qops = {
 	.queue_setup     = bdisp_queue_setup,
 	.buf_prepare     = bdisp_buf_prepare,
 	.buf_queue       = bdisp_buf_queue,
-	.wait_prepare    = vb2_ops_wait_prepare,
-	.wait_finish     = vb2_ops_wait_finish,
 	.stop_streaming  = bdisp_stop_streaming,
 	.start_streaming = bdisp_start_streaming,
 };
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 232d508c5b66..a2686aef3296 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -1578,8 +1578,6 @@ static const struct vb2_ops delta_vb2_au_ops = {
 	.queue_setup = delta_vb2_au_queue_setup,
 	.buf_prepare = delta_vb2_au_prepare,
 	.buf_queue = delta_vb2_au_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = delta_vb2_au_start_streaming,
 	.stop_streaming = delta_vb2_au_stop_streaming,
 };
@@ -1589,8 +1587,6 @@ static const struct vb2_ops delta_vb2_frame_ops = {
 	.buf_prepare = delta_vb2_frame_prepare,
 	.buf_finish = delta_vb2_frame_finish,
 	.buf_queue = delta_vb2_frame_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.stop_streaming = delta_vb2_frame_stop_streaming,
 };
 
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 15080cb00fa7..69e1514a8c34 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -1114,8 +1114,6 @@ static const struct vb2_ops hva_qops = {
 	.buf_queue		= hva_buf_queue,
 	.start_streaming	= hva_start_streaming,
 	.stop_streaming		= hva_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 2e1933d872ee..f9909d7a8704 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -767,8 +767,6 @@ static const struct vb2_ops dcmi_video_qops = {
 	.buf_queue		= dcmi_buf_queue,
 	.start_streaming	= dcmi_start_streaming,
 	.stop_streaming		= dcmi_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int dcmi_g_fmt_vid_cap(struct file *file, void *priv,
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index d1febe5baa6d..13656060fcdb 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1379,8 +1379,6 @@ static const struct vb2_ops cal_video_qops = {
 	.buf_queue		= cal_buffer_queue,
 	.start_streaming	= cal_start_streaming,
 	.stop_streaming		= cal_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static const struct v4l2_file_operations cal_fops = {
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index e395aa85c8ad..abe12bbe1f90 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2198,8 +2198,6 @@ static const struct vb2_ops vpe_qops = {
 	.queue_setup	 = vpe_queue_setup,
 	.buf_prepare	 = vpe_buf_prepare,
 	.buf_queue	 = vpe_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = vpe_start_streaming,
 	.stop_streaming  = vpe_stop_streaming,
 };
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e62db4..e64489c8106c 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -821,8 +821,6 @@ static const struct vb2_ops vim2m_qops = {
 	.buf_queue	 = vim2m_buf_queue,
 	.start_streaming = vim2m_start_streaming,
 	.stop_streaming  = vim2m_stop_streaming,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 88a1e5670c72..cd889c50b248 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -328,12 +328,6 @@ static const struct vb2_ops vimc_cap_qops = {
 	.buf_queue		= vimc_cap_buf_queue,
 	.queue_setup		= vimc_cap_queue_setup,
 	.buf_prepare		= vimc_cap_buffer_prepare,
-	/*
-	 * Since q->lock is set we can use the standard
-	 * vb2_ops_wait_prepare/finish helper functions.
-	 */
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static const struct media_entity_operations vimc_cap_mops = {
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index cfb7cb4d37a8..053a3e036b33 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -309,8 +309,6 @@ const struct vb2_ops vivid_sdr_cap_qops = {
 	.buf_queue		= sdr_cap_buf_queue,
 	.start_streaming	= sdr_cap_start_streaming,
 	.stop_streaming		= sdr_cap_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 int vivid_sdr_enum_freq_bands(struct file *file, void *fh,
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 92a852955173..d1d04e7316e6 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -226,8 +226,6 @@ const struct vb2_ops vivid_vbi_cap_qops = {
 	.buf_queue		= vbi_cap_buf_queue,
 	.start_streaming	= vbi_cap_start_streaming,
 	.stop_streaming		= vbi_cap_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 69486c130a7e..98b5a966faff 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -121,8 +121,6 @@ const struct vb2_ops vivid_vbi_out_qops = {
 	.buf_queue		= vbi_out_buf_queue,
 	.start_streaming	= vbi_out_start_streaming,
 	.stop_streaming		= vbi_out_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 int vidioc_g_fmt_vbi_out(struct file *file, void *priv,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1599159f2574..2dba4bcad5c8 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -264,8 +264,6 @@ const struct vb2_ops vivid_vid_cap_qops = {
 	.buf_queue		= vid_cap_buf_queue,
 	.start_streaming	= vid_cap_start_streaming,
 	.stop_streaming		= vid_cap_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 51fec66d8d45..f7c6112fb89c 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -185,8 +185,6 @@ const struct vb2_ops vivid_vid_out_qops = {
 	.buf_queue		= vid_out_buf_queue,
 	.start_streaming	= vid_out_start_streaming,
 	.stop_streaming		= vid_out_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index 5e15c8ff88d9..7a9c574c6c4a 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -159,8 +159,6 @@ static const struct vb2_ops histo_video_queue_qops = {
 	.queue_setup = histo_queue_setup,
 	.buf_prepare = histo_buffer_prepare,
 	.buf_queue = histo_buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = histo_start_streaming,
 	.stop_streaming = histo_stop_streaming,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 81d47a09d7bc..85903e46c1ab 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -949,8 +949,6 @@ static const struct vb2_ops vsp1_video_queue_qops = {
 	.queue_setup = vsp1_video_queue_setup,
 	.buf_prepare = vsp1_video_buffer_prepare,
 	.buf_queue = vsp1_video_buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = vsp1_video_start_streaming,
 	.stop_streaming = vsp1_video_stop_streaming,
 };
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d041f94be832..1666412d9ff8 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -478,8 +478,6 @@ static const struct vb2_ops xvip_dma_queue_qops = {
 	.queue_setup = xvip_dma_queue_setup,
 	.buf_prepare = xvip_dma_buffer_prepare,
 	.buf_queue = xvip_dma_buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = xvip_dma_start_streaming,
 	.stop_streaming = xvip_dma_stop_streaming,
 };
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index e70c9e2f3798..97f01db5dcbb 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -610,8 +610,6 @@ static const struct vb2_ops airspy_vb2_ops = {
 	.buf_queue              = airspy_buf_queue,
 	.start_streaming        = airspy_start_streaming,
 	.stop_streaming         = airspy_stop_streaming,
-	.wait_prepare           = vb2_ops_wait_prepare,
-	.wait_finish            = vb2_ops_wait_finish,
 };
 
 static int airspy_querycap(struct file *file, void *fh,
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 9dd6bdb7304f..e09fcbcea290 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -85,6 +85,4 @@ const struct vb2_ops au0828_vbi_qops = {
 	.buf_queue       = vbi_buffer_queue,
 	.start_streaming = au0828_start_analog_streaming,
 	.stop_streaming  = au0828_stop_vbi_streaming,
-	.wait_prepare    = vb2_ops_wait_prepare,
-	.wait_finish     = vb2_ops_wait_finish,
 };
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 964cd7bcdd2c..f4469efaaa63 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -921,8 +921,6 @@ static const struct vb2_ops au0828_video_qops = {
 	.buf_queue       = buffer_queue,
 	.start_streaming = au0828_start_analog_streaming,
 	.stop_streaming  = au0828_stop_streaming,
-	.wait_prepare    = vb2_ops_wait_prepare,
-	.wait_finish     = vb2_ops_wait_finish,
 };
 
 /* ------------------------------------------------------------------
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 63c48361d3f2..847ae9627bd0 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -94,6 +94,4 @@ const struct vb2_ops em28xx_vbi_qops = {
 	.buf_queue      = vbi_buffer_queue,
 	.start_streaming = em28xx_start_analog_streaming,
 	.stop_streaming = em28xx_stop_vbi_streaming,
-	.wait_prepare   = vb2_ops_wait_prepare,
-	.wait_finish    = vb2_ops_wait_finish,
 };
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 68571bf36d28..9b588daaf646 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1244,8 +1244,6 @@ static const struct vb2_ops em28xx_video_qops = {
 	.buf_queue      = buffer_queue,
 	.start_streaming = em28xx_start_analog_streaming,
 	.stop_streaming = em28xx_stop_streaming,
-	.wait_prepare   = vb2_ops_wait_prepare,
-	.wait_finish    = vb2_ops_wait_finish,
 };
 
 static int em28xx_vb2_setup(struct em28xx *dev)
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index c55c82f70e54..21d32838f54e 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -484,8 +484,6 @@ static const struct vb2_ops go7007_video_qops = {
 	.buf_finish     = go7007_buf_finish,
 	.start_streaming = go7007_start_streaming,
 	.stop_streaming = go7007_stop_streaming,
-	.wait_prepare   = vb2_ops_wait_prepare,
-	.wait_finish    = vb2_ops_wait_finish,
 };
 
 static int vidioc_g_parm(struct file *filp, void *priv,
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 57aa521e16b1..f823dba94580 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1385,8 +1385,6 @@ static const struct vb2_ops gspca_qops = {
 	.buf_queue		= gspca_buffer_queue,
 	.start_streaming	= gspca_start_streaming,
 	.stop_streaming		= gspca_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static const struct v4l2_file_operations dev_fops = {
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 6d692fb3e8dd..1125da75f4dc 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -896,8 +896,6 @@ static const struct vb2_ops hackrf_vb2_ops = {
 	.buf_queue              = hackrf_buf_queue,
 	.start_streaming        = hackrf_start_streaming,
 	.stop_streaming         = hackrf_stop_streaming,
-	.wait_prepare           = vb2_ops_wait_prepare,
-	.wait_finish            = vb2_ops_wait_finish,
 };
 
 static int hackrf_querycap(struct file *file, void *fh,
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 65ef755adfdc..9bf2e6dad624 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -902,8 +902,6 @@ static const struct vb2_ops msi2500_vb2_ops = {
 	.buf_queue              = msi2500_buf_queue,
 	.start_streaming        = msi2500_start_streaming,
 	.stop_streaming         = msi2500_stop_streaming,
-	.wait_prepare           = vb2_ops_wait_prepare,
-	.wait_finish            = vb2_ops_wait_finish,
 };
 
 static int msi2500_enum_fmt_sdr_cap(struct file *file, void *priv,
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 54b036d39c5b..6d9be76a3380 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -717,8 +717,6 @@ static const struct vb2_ops pwc_vb_queue_ops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /***************************************************************************/
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 82927eb334c4..52f5ef3fb431 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -720,8 +720,6 @@ static const struct vb2_ops s2255_video_qops = {
 	.buf_queue = buffer_queue,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 static int vidioc_querycap(struct file *file, void *priv,
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 504e413edcd2..eb010c88205e 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -747,8 +747,6 @@ static const struct vb2_ops stk1160_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static const struct video_device v4l_template = {
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index ce79df643c7e..c2f8e50228ac 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -781,8 +781,6 @@ static const struct vb2_ops usbtv_vb2_ops = {
 	.buf_queue = usbtv_buf_queue,
 	.start_streaming = usbtv_start_streaming,
 	.stop_streaming = usbtv_stop_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index fecccb5e7628..c6a14f7af4e2 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -203,8 +203,6 @@ static const struct vb2_ops uvc_queue_qops = {
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
 	.buf_finish = uvc_buffer_finish,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = uvc_start_streaming,
 	.stop_streaming = uvc_stop_streaming,
 };
@@ -213,8 +211,6 @@ static const struct vb2_ops uvc_meta_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 	.stop_streaming = uvc_stop_streaming,
 };
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 1269a983455e..3b470e40988f 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1312,8 +1312,6 @@ static const struct vb2_ops video_qops = {
 	.stop_streaming		= vpfe_stop_streaming,
 	.buf_cleanup		= vpfe_buf_cleanup,
 	.buf_queue		= vpfe_buffer_queue,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 4e3fdf8aeef5..d66a1f4236b3 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -503,8 +503,6 @@ static const struct vb2_ops capture_qops = {
 	.buf_init        = capture_buf_init,
 	.buf_prepare	 = capture_buf_prepare,
 	.buf_queue	 = capture_buf_queue,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = capture_start_streaming,
 	.stop_streaming  = capture_stop_streaming,
 };
diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index 6dd0c838db05..b549ff154b03 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -636,8 +636,6 @@ static const struct vb2_ops bm2835_mmal_video_qops = {
 	.buf_queue = buffer_queue,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 /* ------------------------------------------------------------------
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 9e33d5206d54..f1090107d0ec 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -106,8 +106,6 @@ static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
-	.wait_prepare = vb2_ops_wait_prepare,
-	.wait_finish = vb2_ops_wait_finish,
 };
 
 int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 3d5e2d739f05..cf83b01dc44e 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -273,22 +273,4 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 #endif
 
-/**
- * vb2_ops_wait_prepare - helper function to lock a struct &vb2_queue
- *
- * @vq: pointer to &struct vb2_queue
- *
- * ..note:: only use if vq->lock is non-NULL.
- */
-void vb2_ops_wait_prepare(struct vb2_queue *vq);
-
-/**
- * vb2_ops_wait_finish - helper function to unlock a struct &vb2_queue
- *
- * @vq: pointer to &struct vb2_queue
- *
- * ..note:: only use if vq->lock is non-NULL.
- */
-void vb2_ops_wait_finish(struct vb2_queue *vq);
-
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
diff --git a/samples/v4l/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
index f520e3aef9c6..74f9c817c8bd 100644
--- a/samples/v4l/v4l2-pci-skeleton.c
+++ b/samples/v4l/v4l2-pci-skeleton.c
@@ -277,19 +277,12 @@ static void stop_streaming(struct vb2_queue *vq)
 	return_all_buffers(skel, VB2_BUF_STATE_ERROR);
 }
 
-/*
- * The vb2 queue ops. Note that since q->lock is set we can use the standard
- * vb2_ops_wait_prepare/finish helper functions. If q->lock would be NULL,
- * then this driver would have to provide these ops.
- */
 static const struct vb2_ops skel_qops = {
 	.queue_setup		= queue_setup,
 	.buf_prepare		= buffer_prepare,
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
-- 
2.17.1

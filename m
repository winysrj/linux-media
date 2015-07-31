Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47033 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbbGaIox (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 04:44:53 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSC027EFGAG6T20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Jul 2015 17:44:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH v2 5/5] media: videobuf2: Modify prefix for VB2 functions
Date: Fri, 31 Jul 2015 17:44:37 +0900
Message-id: <1438332277-6542-6-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace prefix "vb2_" with "vb2_v4l2" for v4l2-specific functions.
And then, replace prefix "vb2_core_" with "vb2_" for vb2-core functions.
It can be done automatically with just running this shell script.

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
replace "function_name_before" "function_name_after" "directory"

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |    6 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    4 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |    4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    8 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    4 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    4 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    8 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    6 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    4 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |    4 +-
 drivers/media/pci/cx88/cx88-video.c                |    8 +-
 drivers/media/pci/dt3155/dt3155.c                  |    6 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    6 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    4 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    4 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   12 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   12 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   12 +-
 drivers/media/pci/tw68/tw68-video.c                |    6 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   10 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    8 +-
 drivers/media/platform/coda/coda-bit.c             |   12 +-
 drivers/media/platform/coda/coda-common.c          |    8 +-
 drivers/media/platform/coda/coda-jpeg.c            |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |   10 +-
 drivers/media/platform/davinci/vpif_capture.c      |   10 +-
 drivers/media/platform/davinci/vpif_display.c      |   10 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    6 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   10 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    8 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    6 +-
 drivers/media/platform/m2m-deinterlace.c           |   10 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    4 +-
 drivers/media/platform/mx2_emmaprp.c               |   10 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   22 +--
 drivers/media/platform/s3c-camif/camif-capture.c   |   30 ++--
 drivers/media/platform/s5p-g2d/g2d.c               |    6 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   18 +--
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   18 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   42 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   62 ++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    6 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   20 +--
 drivers/media/platform/sh_veu.c                    |   14 +-
 drivers/media/platform/sh_vou.c                    |    8 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   10 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   16 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   16 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   12 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   18 +--
 drivers/media/platform/soc_camera/soc_camera.c     |   22 +--
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    8 +-
 drivers/media/platform/ti-vpe/vpe.c                |   10 +-
 drivers/media/platform/vim2m.c                     |   12 +-
 drivers/media/platform/vivid/vivid-core.c          |   10 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    8 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   10 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    8 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    6 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   10 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |    4 +-
 drivers/media/usb/airspy/airspy.c                  |    4 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    8 +-
 drivers/media/usb/au0828/au0828-video.c            |   16 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    8 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   12 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |    4 +-
 drivers/media/usb/msi2500/msi2500.c                |    4 +-
 drivers/media/usb/pwc/pwc-if.c                     |    2 +-
 drivers/media/usb/pwc/pwc-uncompress.c             |    4 +-
 drivers/media/usb/s2255/s2255drv.c                 |   10 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    4 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   10 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   32 ++--
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   22 +--
 drivers/media/v4l2-core/videobuf2-core.c           |   74 ++++-----
 drivers/media/v4l2-core/videobuf2-dvb.c            |    2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  168 ++++++++++----------
 drivers/usb/gadget/function/uvc_queue.c            |   28 ++--
 include/media/videobuf2-core.h                     |   22 +--
 include/media/videobuf2-v4l2.h                     |   42 ++---
 93 files changed, 594 insertions(+), 594 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index d7ea662..1739808 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -672,13 +672,13 @@ static int sur40_buffer_prepare(struct vb2_buffer *vb)
 	struct sur40_state *sur40 = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size = sur40_video_format.sizeimage;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dev_err(&sur40->usbdev->dev, "buffer too small (%lu < %lu)\n",
-			 vb2_plane_size(vb, 0), size);
+			 vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 8d36149..51103cb 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -307,7 +307,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = rtl2832_sdr_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
+		vb2_v4l2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
@@ -1419,7 +1419,7 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 	dev->vb_queue.ops = &rtl2832_sdr_vb2_ops;
 	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&dev->vb_queue);
+	ret = vb2_v4l2_queue_init(&dev->vb_queue);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not initialize vb2 queue\n");
 		goto err_kfree;
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
index f0bdf10..7a40ab6 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
@@ -212,7 +212,7 @@ static int alsa_fnc(struct vb2_buffer *vb, void *priv)
 	cobalt_alsa_announce_pcm_data(s->alsa,
 			vb2_plane_vaddr(vb, 0),
 			8 * 4,
-			vb2_get_plane_payload(vb, 0) / (8 * 4));
+			vb2_v4l2_get_plane_payload(vb, 0) / (8 * 4));
 	return 0;
 }
 
@@ -421,7 +421,7 @@ static int alsa_pb_fnc(struct vb2_buffer *vb, void *priv)
 		cobalt_alsa_pb_pcm_data(s->alsa,
 				vb2_plane_vaddr(vb, 0),
 				8 * 4,
-				vb2_get_plane_payload(vb, 0) / (8 * 4));
+				vb2_v4l2_get_plane_payload(vb, 0) / (8 * 4));
 	return 0;
 }
 
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 9756fd3..bca32e2 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -81,9 +81,9 @@ static int cobalt_buf_init(struct vb2_buffer *vb)
 	int ret;
 
 	size = s->stride * s->height;
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		cobalt_info("data will not fit into plane (%lu < %u)\n",
-					vb2_plane_size(vb, 0), size);
+					vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 
@@ -114,7 +114,7 @@ static int cobalt_buf_prepare(struct vb2_buffer *vb)
 {
 	struct cobalt_stream *s = vb->vb2_queue->drv_priv;
 
-	vb2_set_plane_payload(vb, 0, s->stride * s->height);
+	vb2_v4l2_set_plane_payload(vb, 0, s->stride * s->height);
 	vb->v4l2_buf.field = V4L2_FIELD_NONE;
 	return 0;
 }
@@ -1229,7 +1229,7 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	vdev->queue = q;
 
 	video_set_drvdata(vdev, s);
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (!s->is_audio && ret == 0)
 		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	else if (!s->is_dummy)
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 88a3afb..eecacf6 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1554,7 +1554,7 @@ int cx23885_417_register(struct cx23885_dev *dev)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err < 0)
 		return err;
 	video_set_drvdata(dev->v4l_device, dev);
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index bbea734..0767d5f 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1456,9 +1456,9 @@ int cx23885_buf_prepare(struct cx23885_buffer *buf, struct cx23885_tsport *port)
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
 
 	dprintk(1, "%s: %p\n", __func__, buf);
-	if (vb2_plane_size(&buf->vb.vb2_buf, 0) < size)
+	if (vb2_v4l2_plane_size(&buf->vb.vb2_buf, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+	vb2_v4l2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	cx23885_risc_databuffer(dev->pci, &buf->risc,
 				sgt->sgl,
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index c4307ad..440a247 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2395,7 +2395,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->lock = &dev->lock;
 
-		err = vb2_queue_init(q);
+		err = vb2_v4l2_queue_init(q);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index d1fd585..19b91cc 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -148,9 +148,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	if (dev->tvnorm & V4L2_STD_525_60)
 		lines = VBI_NTSC_LINE_COUNT;
 
-	if (vb2_plane_size(vb, 0) < lines * VBI_LINE_LENGTH * 2)
+	if (vb2_v4l2_plane_size(vb, 0) < lines * VBI_LINE_LENGTH * 2)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, lines * VBI_LINE_LENGTH * 2);
+	vb2_v4l2_set_plane_payload(vb, 0, lines * VBI_LINE_LENGTH * 2);
 
 	cx23885_risc_vbibuffer(dev->pci, &buf->risc,
 			 sgt->sgl,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index d7c6729..c427cf8 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -339,9 +339,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	buf->bpl = (dev->width * dev->fmt->depth) >> 3;
 
-	if (vb2_plane_size(vb, 0) < dev->height * buf->bpl)
+	if (vb2_v4l2_plane_size(vb, 0) < dev->height * buf->bpl)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, dev->height * buf->bpl);
+	vb2_v4l2_set_plane_payload(vb, 0, dev->height * buf->bpl);
 
 	switch (dev->field) {
 	case V4L2_FIELD_TOP:
@@ -1230,7 +1230,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err < 0)
 		goto fail_unreg;
 
@@ -1246,7 +1246,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err < 0)
 		goto fail_unreg;
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 5e672f2..3e72b05 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -175,9 +175,9 @@ static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 	else
 		buf->bpl = (chan->fmt->depth >> 3) * chan->width;
 
-	if (vb2_plane_size(vb, 0) < chan->height * buf->bpl)
+	if (vb2_v4l2_plane_size(vb, 0) < chan->height * buf->bpl)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, chan->height * buf->bpl);
+	vb2_v4l2_set_plane_payload(vb, 0, chan->height * buf->bpl);
 	buf->vb.v4l2_buf.field = chan->field;
 
 	if (chan->pixel_formats == PIXEL_FRMT_411) {
@@ -761,7 +761,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		q->lock = &dev->lock;
 
 		if (!is_output) {
-			err = vb2_queue_init(q);
+			err = vb2_v4l2_queue_init(q);
 			if (err < 0)
 				goto fail_unreg;
 		}
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 8b88913..3a06065 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1184,7 +1184,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &core->lock;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err < 0)
 		goto fail_core;
 
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index f048350..9c4f275 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1793,7 +1793,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->lock = &core->lock;
 
-		err = vb2_queue_init(q);
+		err = vb2_v4l2_queue_init(q);
 		if (err < 0)
 			goto fail_probe;
 
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index a315cd6..91de60d 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -229,9 +229,9 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 	struct cx88_riscmem *risc = &buf->risc;
 	int rc;
 
-	if (vb2_plane_size(&buf->vb.vb2_buf, 0) < size)
+	if (vb2_v4l2_plane_size(&buf->vb.vb2_buf, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+	vb2_v4l2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	rc = cx88_risc_databuffer(dev->pci, risc, sgt->sgl,
 			     dev->ts_packet_size, dev->ts_packet_count, 0);
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 2bdfbb9..629df46 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -137,9 +137,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	else
 		lines = VBI_LINE_PAL_COUNT;
 	size = lines * VBI_LINE_LENGTH * 2;
-	if (vb2_plane_size(vb, 0) < size)
+	if (vb2_v4l2_plane_size(vb, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
 			 0, VBI_LINE_LENGTH * lines,
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 4af3808..5a72a1c 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -452,9 +452,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	buf->bpl = core->width * dev->fmt->depth >> 3;
 
-	if (vb2_plane_size(vb, 0) < core->height * buf->bpl)
+	if (vb2_v4l2_plane_size(vb, 0) < core->height * buf->bpl)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, core->height * buf->bpl);
+	vb2_v4l2_set_plane_payload(vb, 0, core->height * buf->bpl);
 
 	switch (core->field) {
 	case V4L2_FIELD_TOP:
@@ -1446,7 +1446,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &core->lock;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err < 0)
 		goto fail_unreg;
 
@@ -1462,7 +1462,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &core->lock;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err < 0)
 		goto fail_unreg;
 
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 0aa45d0..1dc69e5 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -155,7 +155,7 @@ static int dt3155_buf_prepare(struct vb2_buffer *vb)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
 
-	vb2_set_plane_payload(vb, 0, pd->width * pd->height);
+	vb2_v4l2_set_plane_payload(vb, 0, pd->width * pd->height);
 	return 0;
 }
 
@@ -547,7 +547,7 @@ static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd->vidq.gfp_flags = GFP_DMA32;
 	pd->vidq.lock = &pd->mux; /* for locking v4l2_file_operations */
 	pd->vdev.queue = &pd->vidq;
-	err = vb2_queue_init(&pd->vidq);
+	err = vb2_v4l2_queue_init(&pd->vidq);
 	if (err < 0)
 		goto err_v4l2_dev_unreg;
 	pd->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
@@ -605,7 +605,7 @@ static void dt3155_remove(struct pci_dev *pdev)
 
 	video_unregister_device(&pd->vdev);
 	free_irq(pd->pdev->irq, pd);
-	vb2_queue_release(&pd->vidq);
+	vb2_v4l2_queue_release(&pd->vidq);
 	v4l2_device_unregister(&pd->v4l2_dev);
 	pci_iounmap(pdev, pd->regs);
 	pci_release_region(pdev, 0);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 7d76e59..c695e47 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -216,7 +216,7 @@ int saa7134_buffer_count(unsigned int size, unsigned int count)
 
 int saa7134_buffer_startpage(struct saa7134_buf *buf)
 {
-	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2.vb2_buf, 0)) * buf->vb2.v4l2_buf.index;
+	return saa7134_buffer_pages(vb2_v4l2_plane_size(&buf->vb2.vb2_buf, 0)) * buf->vb2.v4l2_buf.index;
 }
 
 unsigned long saa7134_buffer_base(struct saa7134_buf *buf)
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 101ba87..37be45b 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1238,7 +1238,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret) {
 		vb2_dvb_dealloc_frontends(&dev->frontends);
 		return ret;
@@ -1901,7 +1901,7 @@ static int dvb_init(struct saa7134_dev *dev)
 
 detach_frontend:
 	vb2_dvb_dealloc_frontends(&dev->frontends);
-	vb2_queue_release(&fe0->dvb.dvbq);
+	vb2_v4l2_queue_release(&fe0->dvb.dvbq);
 	return -EINVAL;
 }
 
@@ -1942,7 +1942,7 @@ static int dvb_fini(struct saa7134_dev *dev)
 		}
 	}
 	vb2_dvb_unregister_bus(&dev->frontends);
-	vb2_queue_release(&fe0->dvb.dvbq);
+	vb2_v4l2_queue_release(&fe0->dvb.dvbq);
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 56b932c..2085218 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -294,7 +294,7 @@ static int empress_init(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err)
 		return err;
 	dev->empress_dev->queue = q;
@@ -324,7 +324,7 @@ static int empress_fini(struct saa7134_dev *dev)
 		return 0;
 	flush_work(&dev->empress_workqueue);
 	video_unregister_device(dev->empress_dev);
-	vb2_queue_release(&dev->empress_vbq);
+	vb2_v4l2_queue_release(&dev->empress_vbq);
 	v4l2_ctrl_handler_free(&dev->empress_ctrl_handler);
 	dev->empress_dev = NULL;
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index b19a00f..55ca3e1 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -105,10 +105,10 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb)
 	lines = dev->ts.nr_packets;
 
 	size = lines * llength;
-	if (vb2_plane_size(vb, 0) < size)
+	if (vb2_v4l2_plane_size(vb, 0) < size)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 	vbuf->v4l2_buf.field = dev->field;
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index c3cdb89..2903e83 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -129,10 +129,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	size = dev->vbi_hlen * dev->vbi_vlen * 2;
-	if (vb2_plane_size(vb, 0) < size)
+	if (vb2_v4l2_plane_size(vb, 0) < size)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 7ea9411..20821a7 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -894,10 +894,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
-	if (vb2_plane_size(vb, 0) < size)
+	if (vb2_v4l2_plane_size(vb, 0) < size)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 	vbuf->v4l2_buf.field = dev->field;
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
@@ -2099,7 +2099,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret)
 		return ret;
 	saa7134_pgtable_alloc(dev->pci, &dev->video_q.pt);
@@ -2117,7 +2117,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret)
 		return ret;
 	saa7134_pgtable_alloc(dev->pci, &dev->vbi_q.pt);
@@ -2128,9 +2128,9 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 void saa7134_video_fini(struct saa7134_dev *dev)
 {
 	/* free stuff */
-	vb2_queue_release(&dev->video_vbq);
+	vb2_v4l2_queue_release(&dev->video_vbq);
 	saa7134_pgtable_free(dev->pci, &dev->video_q.pt);
-	vb2_queue_release(&dev->vbi_vbq);
+	vb2_v4l2_queue_release(&dev->vbi_vbq);
 	saa7134_pgtable_free(dev->pci, &dev->vbi_q.pt);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	if (card_has_radio(dev))
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 19dc488..06874a5 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -464,11 +464,11 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 
 	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 
-	if (vb2_plane_size(&vb->vb2_buf, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
+	if (vb2_v4l2_plane_size(&vb->vb2_buf, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
 		return -EIO;
 
 	frame_size = ALIGN(vop_jpeg_size(vh) + solo_enc->jpeg_len, DMA_ALIGN);
-	vb2_set_plane_payload(&vb->vb2_buf, 0,
+	vb2_v4l2_set_plane_payload(&vb->vb2_buf, 0,
 			      vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
 	return solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
@@ -485,7 +485,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	int frame_off, frame_size;
 	int skip = 0;
 
-	if (vb2_plane_size(&vb->vb2_buf, 0) < vop_mpeg_size(vh))
+	if (vb2_v4l2_plane_size(&vb->vb2_buf, 0) < vop_mpeg_size(vh))
 		return -EIO;
 
 	/* If this is a key frame, add extra header */
@@ -494,11 +494,11 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	if (!vop_type(vh)) {
 		skip = solo_enc->vop_len;
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
-		vb2_set_plane_payload(&vb->vb2_buf, 0,
+		vb2_v4l2_set_plane_payload(&vb->vb2_buf, 0,
 				      vop_mpeg_size(vh) + solo_enc->vop_len);
 	} else {
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
-		vb2_set_plane_payload(&vb->vb2_buf, 0, vop_mpeg_size(vh));
+		vb2_v4l2_set_plane_payload(&vb->vb2_buf, 0, vop_mpeg_size(vh));
 	}
 
 	/* Now get the actual mpeg payload */
@@ -1298,7 +1298,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	solo_enc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	solo_enc->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
 	solo_enc->vidq.lock = &solo_enc->lock;
-	ret = vb2_queue_init(&solo_enc->vidq);
+	ret = vb2_v4l2_queue_init(&solo_enc->vidq);
 	if (ret)
 		goto hdl_free;
 	solo_update_mode(solo_enc);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 628d019..cbef85b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -220,7 +220,7 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 
 finish_buf:
 	if (!error) {
-		vb2_set_plane_payload(&vb->vb2_buf, 0,
+		vb2_v4l2_set_plane_payload(&vb->vb2_buf, 0,
 				      solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
 		vb->v4l2_buf.sequence = solo_dev->sequence++;
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
@@ -680,7 +680,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 	solo_dev->vidq.gfp_flags = __GFP_DMA32;
 	solo_dev->vidq.buf_struct_size = sizeof(struct solo_vb2_buf);
 	solo_dev->vidq.lock = &solo_dev->lock;
-	ret = vb2_queue_init(&solo_dev->vidq);
+	ret = vb2_v4l2_queue_init(&solo_dev->vidq);
 	if (ret < 0)
 		goto fail;
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index a4dc2d5..b4fa408 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -303,13 +303,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	unsigned long size;
 
 	size = vip->format.sizeimage;
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		v4l2_err(&vip->v4l2_dev, "buffer too small (%lu < %lu)\n",
-			 vb2_plane_size(vb, 0), size);
+			 vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -870,7 +870,7 @@ static int sta2x11_vip_init_buffer(struct sta2x11_vip *vip)
 	vip->vb_vidq.ops = &vip_video_qops;
 	vip->vb_vidq.mem_ops = &vb2_dma_contig_memops;
 	vip->vb_vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	err = vb2_queue_init(&vip->vb_vidq);
+	err = vb2_v4l2_queue_init(&vip->vb_vidq);
 	if (err)
 		return err;
 	INIT_LIST_HEAD(&vip->buffer_list);
@@ -1132,7 +1132,7 @@ release_buf:
 	sta2x11_vip_release_buffer(vip);
 	pci_disable_msi(pdev);
 unmap:
-	vb2_queue_release(&vip->vb_vidq);
+	vb2_v4l2_queue_release(&vip->vb_vidq);
 	pci_iounmap(pdev, vip->iomem);
 release:
 	pci_release_regions(pdev);
@@ -1175,7 +1175,7 @@ static void sta2x11_vip_remove_one(struct pci_dev *pdev)
 	video_unregister_device(&vip->video_dev);
 	free_irq(pdev->irq, vip);
 	pci_disable_msi(pdev);
-	vb2_queue_release(&vip->vb_vidq);
+	vb2_v4l2_queue_release(&vip->vb_vidq);
 	pci_iounmap(pdev, vip->iomem);
 	pci_release_regions(pdev);
 
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 82dbc9a..7d6995f 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -467,9 +467,9 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 	unsigned size, bpl;
 
 	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
-	if (vb2_plane_size(vb, 0) < size)
+	if (vb2_v4l2_plane_size(vb, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	bpl = (dev->width * dev->fmt->depth) >> 3;
 	switch (dev->field) {
@@ -983,7 +983,7 @@ int tw68_video_init2(struct tw68_dev *dev, int video_nr)
 	dev->vidq.buf_struct_size = sizeof(struct tw68_buf);
 	dev->vidq.lock = &dev->lock;
 	dev->vidq.min_buffers_needed = 2;
-	ret = vb2_queue_init(&dev->vidq);
+	ret = vb2_v4l2_queue_init(&dev->vidq);
 	if (ret)
 		return ret;
 	dev->vdev = tw68_video_template;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 794408b..64ab941 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1937,7 +1937,7 @@ static int vpfe_queue_setup(struct vb2_queue *vq,
  * vpfe_buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
  *
- * This is the callback function for buffer prepare when vb2_qbuf()
+ * This is the callback function for buffer prepare when vb2_v4l2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
@@ -1946,9 +1946,9 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
 
-	vb2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
 
-	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+	if (vb2_v4l2_get_plane_payload(vb, 0) > vb2_v4l2_plane_size(vb, 0))
 		return -EINVAL;
 
 	vbuf->v4l2_buf.field = vpfe->fmt.fmt.pix.field;
@@ -2381,9 +2381,9 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
 	q->lock = &vpfe->lock;
 	q->min_buffers_needed = 1;
 
-	err = vb2_queue_init(q);
+	err = vb2_v4l2_queue_init(q);
 	if (err) {
-		vpfe_err(vpfe, "vb2_queue_init() failed\n");
+		vpfe_err(vpfe, "vb2_v4l2_queue_init() failed\n");
 		vb2_dma_contig_cleanup_ctx(vpfe->alloc_ctx);
 		goto probe_out;
 	}
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 1c87afe..543cf93 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -227,12 +227,12 @@ static int bcap_buffer_prepare(struct vb2_buffer *vb)
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size = bcap_dev->fmt.sizeimage;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		v4l2_err(&bcap_dev->v4l2_dev, "buffer too small (%lu < %lu)\n",
-				vb2_plane_size(vb, 0), size);
+				vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 	vbuf->v4l2_buf.field = bcap_dev->fmt.field;
 
 	return 0;
@@ -861,7 +861,7 @@ static int bcap_probe(struct platform_device *pdev)
 	q->lock = &bcap_dev->mutex;
 	q->min_buffers_needed = 1;
 
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret)
 		goto err_free_handler;
 
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 1b5e9ae..af69cd0 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -181,7 +181,7 @@ static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
 static int coda_bitstream_queue(struct coda_ctx *ctx,
 				struct vb2_v4l2_buffer *src_buf)
 {
-	u32 src_size = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
+	u32 src_size = vb2_v4l2_get_plane_payload(&src_buf->vb2_buf, 0);
 	u32 n;
 
 	n = kfifo_in(&ctx->bitstream_fifo,
@@ -201,7 +201,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 	int ret;
 
 	if (coda_get_bitstream_payload(ctx) +
-	    vb2_get_plane_payload(&src_buf->vb2_buf, 0) + 512 >= ctx->bitstream.size)
+	    vb2_v4l2_get_plane_payload(&src_buf->vb2_buf, 0) + 512 >= ctx->bitstream.size)
 		return false;
 
 	if (vb2_plane_vaddr(&src_buf->vb2_buf, 0) == NULL) {
@@ -490,7 +490,7 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 
 	coda_write(dev, vb2_dma_contig_plane_dma_addr(&buf->vb2_buf, 0),
 		   CODA_CMD_ENC_HEADER_BB_START);
-	bufsize = vb2_plane_size(&buf->vb2_buf, 0);
+	bufsize = vb2_v4l2_plane_size(&buf->vb2_buf, 0);
 	if (dev->devtype->product == CODA_960)
 		bufsize /= 1024;
 	coda_write(dev, bufsize, CODA_CMD_ENC_HEADER_BB_SIZE);
@@ -1333,10 +1333,10 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 
 	/* Calculate bytesused field */
 	if (dst_buf->v4l2_buf.sequence == 0) {
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+		vb2_v4l2_set_plane_payload(&dst_buf->vb2_buf, 0,
 				      wr_ptr - start_ptr + ctx->vpu_header_size[0] + ctx->vpu_header_size[1] + ctx->vpu_header_size[2]);
 	} else {
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+		vb2_v4l2_set_plane_payload(&dst_buf->vb2_buf, 0,
 				      wr_ptr - start_ptr);
 	}
 
@@ -2045,7 +2045,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			payload = width * height * 2;
 			break;
 		}
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
+		vb2_v4l2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
 
 		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[display_idx] ?
 				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 10c4a9e..a27c8d5 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1161,10 +1161,10 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 
-	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+	if (vb2_v4l2_plane_size(vb, 0) < q_data->sizeimage) {
 		v4l2_warn(&ctx->dev->v4l2_dev,
 			  "%s data will not fit into plane (%lu < %lu)\n",
-			  __func__, vb2_plane_size(vb, 0),
+			  __func__, vb2_v4l2_plane_size(vb, 0),
 			  (long)q_data->sizeimage);
 		return -EINVAL;
 	}
@@ -1190,7 +1190,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		 * For backwards compatibility, queuing an empty buffer marks
 		 * the stream end
 		 */
-		if (vb2_get_plane_payload(vb, 0) == 0)
+		if (vb2_v4l2_get_plane_payload(vb, 0) == 0)
 			coda_bit_stream_end_flag(ctx);
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
@@ -1601,7 +1601,7 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
 	 */
 	vq->allow_zero_bytesused = 1;
 
-	return vb2_queue_init(vq);
+	return vb2_v4l2_queue_init(vq);
 }
 
 int coda_encoder_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 0d09ffd..350f2ca 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -183,7 +183,7 @@ bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb)
 	void *vaddr = vb2_plane_vaddr(&vb->vb2_buf, 0);
 	u16 soi = be16_to_cpup((__be16 *)vaddr);
 	u16 eoi = be16_to_cpup((__be16 *)(vaddr +
-					  vb2_get_plane_payload(&vb->vb2_buf, 0) - 2));
+					  vb2_v4l2_get_plane_payload(&vb->vb2_buf, 0) - 2));
 
 	return soi == SOI_MARKER && eoi == EOI_MARKER;
 }
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index c0703aa..b5012ab 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -196,7 +196,7 @@ static irqreturn_t venc_isr(int irq, void *arg)
 
 /*
  * vpbe_buffer_prepare()
- * This is the callback function called from vb2_qbuf() function
+ * This is the callback function called from vb2_v4l2_qbuf() function
  * the buffer is prepared and user space virtual address is converted into
  * physical address
  */
@@ -210,8 +210,8 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 				"vpbe_buffer_prepare\n");
 
-	vb2_set_plane_payload(vb, 0, layer->pix_fmt.sizeimage);
-	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+	vb2_v4l2_set_plane_payload(vb, 0, layer->pix_fmt.sizeimage);
+	if (vb2_v4l2_get_plane_payload(vb, 0) > vb2_v4l2_plane_size(vb, 0))
 		return -EINVAL;
 
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
@@ -1448,9 +1448,9 @@ static int vpbe_display_probe(struct platform_device *pdev)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 1;
 		q->lock = &disp_dev->dev[i]->opslock;
-		err = vb2_queue_init(q);
+		err = vb2_v4l2_queue_init(q);
 		if (err) {
-			v4l2_err(v4l2_dev, "vb2_queue_init() failed\n");
+			v4l2_err(v4l2_dev, "vb2_v4l2_queue_init() failed\n");
 			goto probe_out;
 		}
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b583ff1..f76e1f5 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -66,7 +66,7 @@ static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb)
  * vpif_buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
  *
- * This is the callback function for buffer prepare when vb2_qbuf()
+ * This is the callback function for buffer prepare when vb2_v4l2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
@@ -82,8 +82,8 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
-	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+	vb2_v4l2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_v4l2_get_plane_payload(vb, 0) > vb2_v4l2_plane_size(vb, 0))
 		return -EINVAL;
 
 	vbuf->v4l2_buf.field = common->fmt.fmt.pix.field;
@@ -1373,9 +1373,9 @@ static int vpif_probe_complete(void)
 		q->min_buffers_needed = 1;
 		q->lock = &common->lock;
 
-		err = vb2_queue_init(q);
+		err = vb2_v4l2_queue_init(q);
 		if (err) {
-			vpif_err("vpif_capture: vb2_queue_init() failed\n");
+			vpif_err("vpif_capture: vb2_v4l2_queue_init() failed\n");
 			goto probe_out;
 		}
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index f7963bd..c5e18d7 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -62,7 +62,7 @@ static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb
  * vpif_buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
  *
- * This is the callback function for buffer prepare when vb2_qbuf()
+ * This is the callback function for buffer prepare when vb2_v4l2_qbuf()
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
@@ -73,8 +73,8 @@ static int vpif_buffer_prepare(struct vb2_v4l2_buffer *vb)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	vb2_set_plane_payload(&vb->vb2_buf, 0, common->fmt.fmt.pix.sizeimage);
-	if (vb2_get_plane_payload(&vb->vb2_buf, 0) > vb2_plane_size(&vb->vb2_buf, 0))
+	vb2_v4l2_set_plane_payload(&vb->vb2_buf, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_v4l2_get_plane_payload(&vb->vb2_buf, 0) > vb2_v4l2_plane_size(&vb->vb2_buf, 0))
 		return -EINVAL;
 
 	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
@@ -1189,9 +1189,9 @@ static int vpif_probe_complete(void)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 1;
 		q->lock = &common->lock;
-		err = vb2_queue_init(q);
+		err = vb2_v4l2_queue_init(q);
 		if (err) {
-			vpif_err("vpif_display: vb2_queue_init() failed\n");
+			vpif_err("vpif_display: vb2_v4l2_queue_init() failed\n");
 			goto probe_out;
 		}
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 95df3a9..a1f691a 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -246,7 +246,7 @@ static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
 
 	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
 		for (i = 0; i < frame->fmt->num_planes; i++)
-			vb2_set_plane_payload(vb, i, frame->payload[i]);
+			vb2_v4l2_set_plane_payload(vb, i, frame->payload[i]);
 	}
 
 	return 0;
@@ -592,7 +592,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->gsc_dev->lock;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -606,7 +606,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->gsc_dev->lock;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 static int gsc_m2m_open(struct file *file)
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 01bb3d7..dbe4b9b 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -398,13 +398,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	for (i = 0; i < ctx->d_frame.fmt->memplanes; i++) {
 		unsigned long size = ctx->d_frame.payload[i];
 
-		if (vb2_plane_size(vb, i) < size) {
+		if (vb2_v4l2_plane_size(vb, i) < size) {
 			v4l2_err(&ctx->fimc_dev->vid_cap.ve.vdev,
 				 "User buffer too small (%ld < %ld)\n",
-				 vb2_plane_size(vb, i), size);
+				 vb2_v4l2_plane_size(vb, i), size);
 			return -EINVAL;
 		}
-		vb2_set_plane_payload(vb, i, size);
+		vb2_v4l2_set_plane_payload(vb, i, size);
 	}
 
 	return 0;
@@ -1475,7 +1475,7 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 		if (!list_empty(&fimc->vid_cap.active_buf_q)) {
 			buf = list_entry(fimc->vid_cap.active_buf_q.next,
 					 struct fimc_vid_buffer, list);
-			vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+			vb2_v4l2_set_plane_payload(&buf->vb.vb2_buf, 0,
 					      *((u32 *)arg));
 		}
 		fimc_capture_irq_handler(fimc, 1);
@@ -1789,7 +1789,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &fimc->lock;
 
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret)
 		goto err_free_ctx;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 2383724..95338e8 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -170,13 +170,13 @@ static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
 	for (i = 0; i < video->format->memplanes; i++) {
 		unsigned long size = video->pixfmt.plane_fmt[i].sizeimage;
 
-		if (vb2_plane_size(vb, i) < size) {
+		if (vb2_v4l2_plane_size(vb, i) < size) {
 			v4l2_err(&video->ve.vdev,
 				 "User buffer too small (%ld < %ld)\n",
-				 vb2_plane_size(vb, i), size);
+				 vb2_v4l2_plane_size(vb, i), size);
 			return -EINVAL;
 		}
-		vb2_set_plane_payload(vb, i, size);
+		vb2_v4l2_set_plane_payload(vb, i, size);
 	}
 
 	/* Check if we get one of the already known buffers. */
@@ -602,7 +602,7 @@ int fimc_isp_video_device_register(struct fimc_isp *isp,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &isp->video_lock;
 
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index e9aaee7..f217947 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -410,13 +410,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	for (i = 0; i < fimc->out_frame.fmt->memplanes; i++) {
 		unsigned long size = fimc->payload[i];
 
-		if (vb2_plane_size(vb, i) < size) {
+		if (vb2_v4l2_plane_size(vb, i) < size) {
 			v4l2_err(&fimc->ve.vdev,
 				 "User buffer too small (%ld < %ld)\n",
-				 vb2_plane_size(vb, i), size);
+				 vb2_v4l2_plane_size(vb, i), size);
 			return -EINVAL;
 		}
-		vb2_set_plane_payload(vb, i, size);
+		vb2_v4l2_set_plane_payload(vb, i, size);
 	}
 
 	return 0;
@@ -1320,7 +1320,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &fimc->lock;
 
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 06d6436..21696a3 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -213,7 +213,7 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 		return PTR_ERR(frame);
 
 	for (i = 0; i < frame->fmt->memplanes; i++)
-		vb2_set_plane_payload(vb, i, frame->payload[i]);
+		vb2_v4l2_set_plane_payload(vb, i, frame->payload[i]);
 
 	return 0;
 }
@@ -564,7 +564,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->fimc_dev->lock;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -577,7 +577,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->fimc_dev->lock;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 static int fimc_m2m_set_default_format(struct fimc_ctx *ctx)
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index e67f9d2..e2e4348 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -836,13 +836,13 @@ static int deinterlace_buf_prepare(struct vb2_buffer *vb)
 
 	q_data = get_q_data(vb->vb2_queue->type);
 
-	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+	if (vb2_v4l2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
-			__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
+			__func__, vb2_v4l2_plane_size(vb, 0), (long)q_data->sizeimage);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, q_data->sizeimage);
 
 	return 0;
 }
@@ -880,7 +880,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_SRC].sizeimage = (640 * 480 * 3) / 2;
 	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_SEQ_TB;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -897,7 +897,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
 	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 /*
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index b3735a7..277d91c 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -227,7 +227,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
 	vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
 	v4l2_get_timestamp(&vbuf->v4l2_buf.timestamp);
-	vb2_set_plane_payload(&vbuf->vb2_buf, 0, cam->pix_format.sizeimage);
+	vb2_v4l2_set_plane_payload(&vbuf->vb2_buf, 0, cam->pix_format.sizeimage);
 	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 }
 
@@ -1305,7 +1305,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #endif
 		break;
 	}
-	return vb2_queue_init(vq);
+	return vb2_v4l2_queue_init(vq);
 }
 
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 269e1bc..832d1cb 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -726,15 +726,15 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 
-	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+	if (vb2_v4l2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane"
 				  "(%lu < %lu)\n", __func__,
-				  vb2_plane_size(vb, 0),
+				  vb2_v4l2_plane_size(vb, 0),
 				  (long)q_data->sizeimage);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, q_data->sizeimage);
 
 	return 0;
 }
@@ -767,7 +767,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -779,7 +779,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 /*
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 65f57a2..3526e8e 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -363,7 +363,7 @@ static int isp_video_buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, vfh->format.fmt.pix.sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, vfh->format.fmt.pix.sizeimage);
 	buffer->dma = addr;
 
 	return 0;
@@ -826,7 +826,7 @@ isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_reqbufs(&vfh->queue, rb);
+	ret = vb2_v4l2_reqbufs(&vfh->queue, rb);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -840,7 +840,7 @@ isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_querybuf(&vfh->queue, b);
+	ret = vb2_v4l2_querybuf(&vfh->queue, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -854,7 +854,7 @@ isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_qbuf(&vfh->queue, b);
+	ret = vb2_v4l2_qbuf(&vfh->queue, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -868,7 +868,7 @@ isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
+	ret = vb2_v4l2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -1071,7 +1071,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->field = vfh->format.fmt.pix.field;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_streamon(&vfh->queue, type);
+	ret = vb2_v4l2_streamon(&vfh->queue, type);
 	mutex_unlock(&video->queue_lock);
 	if (ret < 0)
 		goto err_check_format;
@@ -1096,7 +1096,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 err_set_stream:
 	mutex_lock(&video->queue_lock);
-	vb2_streamoff(&vfh->queue, type);
+	vb2_v4l2_streamoff(&vfh->queue, type);
 	mutex_unlock(&video->queue_lock);
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
@@ -1157,7 +1157,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap3isp_video_cancel_stream(video);
 
 	mutex_lock(&video->queue_lock);
-	vb2_streamoff(&vfh->queue, type);
+	vb2_v4l2_streamoff(&vfh->queue, type);
 	mutex_unlock(&video->queue_lock);
 	video->queue = NULL;
 	video->error = false;
@@ -1260,7 +1260,7 @@ static int isp_video_open(struct file *file)
 	queue->buf_struct_size = sizeof(struct isp_buffer);
 	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
-	ret = vb2_queue_init(&handle->queue);
+	ret = vb2_v4l2_queue_init(&handle->queue);
 	if (ret < 0) {
 		omap3isp_put(video->isp);
 		goto done;
@@ -1292,7 +1292,7 @@ static int isp_video_release(struct file *file)
 	isp_video_streamoff(file, vfh, video->type);
 
 	mutex_lock(&video->queue_lock);
-	vb2_queue_release(&handle->queue);
+	vb2_v4l2_queue_release(&handle->queue);
 	mutex_unlock(&video->queue_lock);
 
 	omap3isp_pipeline_pm_use(&video->video.entity, 0);
@@ -1314,7 +1314,7 @@ static unsigned int isp_video_poll(struct file *file, poll_table *wait)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = vb2_poll(&vfh->queue, file, wait);
+	ret = vb2_v4l2_poll(&vfh->queue, file, wait);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 8f4e9f4..20754a0 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -486,12 +486,12 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	if (vp->out_fmt == NULL)
 		return -EINVAL;
 
-	if (vb2_plane_size(vb, 0) < vp->payload) {
+	if (vb2_v4l2_plane_size(vb, 0) < vp->payload) {
 		v4l2_err(&vp->vdev, "buffer too small: %lu, required: %u\n",
-			 vb2_plane_size(vb, 0), vp->payload);
+			 vb2_v4l2_plane_size(vb, 0), vp->payload);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, vp->payload);
+	vb2_v4l2_set_plane_payload(vb, 0, vp->payload);
 
 	return 0;
 }
@@ -597,7 +597,7 @@ static int s3c_camif_close(struct file *file)
 
 	if (vp->owner == file->private_data) {
 		camif_stop_capture(vp);
-		vb2_queue_release(&vp->vb_queue);
+		vb2_v4l2_queue_release(&vp->vb_queue);
 		vp->owner = NULL;
 	}
 
@@ -621,7 +621,7 @@ static unsigned int s3c_camif_poll(struct file *file,
 	if (vp->owner && vp->owner != file->private_data)
 		ret = -EBUSY;
 	else
-		ret = vb2_poll(&vp->vb_queue, file, wait);
+		ret = vb2_v4l2_poll(&vp->vb_queue, file, wait);
 
 	mutex_unlock(&camif->lock);
 	return ret;
@@ -886,7 +886,7 @@ static int s3c_camif_streamon(struct file *file, void *priv,
 		return ret;
 	}
 
-	return vb2_streamon(&vp->vb_queue, type);
+	return vb2_v4l2_streamon(&vp->vb_queue, type);
 }
 
 static int s3c_camif_streamoff(struct file *file, void *priv,
@@ -904,7 +904,7 @@ static int s3c_camif_streamoff(struct file *file, void *priv,
 	if (vp->owner && vp->owner != priv)
 		return -EBUSY;
 
-	ret = vb2_streamoff(&vp->vb_queue, type);
+	ret = vb2_v4l2_streamoff(&vp->vb_queue, type);
 	if (ret == 0)
 		media_entity_pipeline_stop(&camif->sensor.sd->entity);
 	return ret;
@@ -927,13 +927,13 @@ static int s3c_camif_reqbufs(struct file *file, void *priv,
 	else
 		vp->owner = NULL;
 
-	ret = vb2_reqbufs(&vp->vb_queue, rb);
+	ret = vb2_v4l2_reqbufs(&vp->vb_queue, rb);
 	if (ret < 0)
 		return ret;
 
 	if (rb->count && rb->count < CAMIF_REQ_BUFS_MIN) {
 		rb->count = 0;
-		vb2_reqbufs(&vp->vb_queue, rb);
+		vb2_v4l2_reqbufs(&vp->vb_queue, rb);
 		ret = -ENOMEM;
 	}
 
@@ -948,7 +948,7 @@ static int s3c_camif_querybuf(struct file *file, void *priv,
 			      struct v4l2_buffer *buf)
 {
 	struct camif_vp *vp = video_drvdata(file);
-	return vb2_querybuf(&vp->vb_queue, buf);
+	return vb2_v4l2_querybuf(&vp->vb_queue, buf);
 }
 
 static int s3c_camif_qbuf(struct file *file, void *priv,
@@ -961,7 +961,7 @@ static int s3c_camif_qbuf(struct file *file, void *priv,
 	if (vp->owner && vp->owner != priv)
 		return -EBUSY;
 
-	return vb2_qbuf(&vp->vb_queue, buf);
+	return vb2_v4l2_qbuf(&vp->vb_queue, buf);
 }
 
 static int s3c_camif_dqbuf(struct file *file, void *priv,
@@ -974,7 +974,7 @@ static int s3c_camif_dqbuf(struct file *file, void *priv,
 	if (vp->owner && vp->owner != priv)
 		return -EBUSY;
 
-	return vb2_dqbuf(&vp->vb_queue, buf, file->f_flags & O_NONBLOCK);
+	return vb2_v4l2_dqbuf(&vp->vb_queue, buf, file->f_flags & O_NONBLOCK);
 }
 
 static int s3c_camif_create_bufs(struct file *file, void *priv,
@@ -987,7 +987,7 @@ static int s3c_camif_create_bufs(struct file *file, void *priv,
 		return -EBUSY;
 
 	create->count = max_t(u32, 1, create->count);
-	ret = vb2_create_bufs(&vp->vb_queue, create);
+	ret = vb2_v4l2_create_bufs(&vp->vb_queue, create);
 
 	if (!ret && vp->owner == NULL)
 		vp->owner = priv;
@@ -999,7 +999,7 @@ static int s3c_camif_prepare_buf(struct file *file, void *priv,
 				 struct v4l2_buffer *b)
 {
 	struct camif_vp *vp = video_drvdata(file);
-	return vb2_prepare_buf(&vp->vb_queue, b);
+	return vb2_v4l2_prepare_buf(&vp->vb_queue, b);
 }
 
 static int s3c_camif_g_selection(struct file *file, void *priv,
@@ -1157,7 +1157,7 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &vp->camif->lock;
 
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret)
 		goto err_vd_rel;
 
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 9fade63..e50df5b 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -128,7 +128,7 @@ static int g2d_buf_prepare(struct vb2_buffer *vb)
 
 	if (IS_ERR(f))
 		return PTR_ERR(f);
-	vb2_set_plane_payload(vb, 0, f->size);
+	vb2_v4l2_set_plane_payload(vb, 0, f->size);
 	return 0;
 }
 
@@ -161,7 +161,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->mutex;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -174,7 +174,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->mutex;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 8fd178d..a9fccf5 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2157,14 +2157,14 @@ static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	BUG_ON(q_data == NULL);
 
-	if (vb2_plane_size(vb, 0) < q_data->size) {
+	if (vb2_v4l2_plane_size(vb, 0) < q_data->size) {
 		pr_err("%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0),
+				__func__, vb2_v4l2_plane_size(vb, 0),
 				(long)q_data->size);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, q_data->size);
+	vb2_v4l2_set_plane_payload(vb, 0, q_data->size);
 
 	return 0;
 }
@@ -2180,7 +2180,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
 		     (unsigned long)vb2_plane_vaddr(vb, 0),
 		     min((unsigned long)ctx->out_q.size,
-			 vb2_get_plane_payload(vb, 0)), ctx);
+			 vb2_v4l2_get_plane_payload(vb, 0)), ctx);
 		if (!ctx->hdr_parsed) {
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			return;
@@ -2240,7 +2240,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->jpeg->lock;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -2253,7 +2253,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->jpeg->lock;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 /*
@@ -2308,7 +2308,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
+		vb2_v4l2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
@@ -2365,7 +2365,7 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	if (jpeg->irq_ret == OK_ENC_OR_DEC) {
 		if (curr_ctx->mode == S5P_JPEG_ENCODE) {
 			payload_size = exynos4_jpeg_get_stream_size(jpeg->regs);
-			vb2_set_plane_payload(&dst_vb->vb2_buf, 0,
+			vb2_v4l2_set_plane_payload(&dst_vb->vb2_buf, 0,
 					      payload_size);
 		}
 		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
@@ -2435,7 +2435,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
+		vb2_v4l2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 5baa069..125ad21 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -200,8 +200,8 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 				     struct s5p_mfc_buf, list);
 		mfc_debug(2, "Cleaning up buffer: %d\n",
 					  dst_buf->b->v4l2_buf.index);
-		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0, 0);
-		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1, 0);
+		vb2_v4l2_set_plane_payload(&dst_buf->b->vb2_buf, 0, 0);
+		vb2_v4l2_set_plane_payload(&dst_buf->b->vb2_buf, 1, 0);
 		list_del(&dst_buf->list);
 		ctx->dst_queue_cnt--;
 		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
@@ -308,9 +308,9 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			else
 				dst_buf->b->v4l2_buf.field =
 							V4L2_FIELD_INTERLACED;
-			vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0,
+			vb2_v4l2_set_plane_payload(&dst_buf->b->vb2_buf, 0,
 					      ctx->luma_size);
-			vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1,
+			vb2_v4l2_set_plane_payload(&dst_buf->b->vb2_buf, 1,
 					      ctx->chroma_size);
 			clear_bit(dst_buf->b->v4l2_buf.index,
 							&ctx->dec_dst_flag);
@@ -596,7 +596,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 									list);
 		list_del(&mb_entry->list);
 		ctx->dst_queue_cnt--;
-		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, 0);
+		vb2_v4l2_set_plane_payload(&mb_entry->b->vb2_buf, 0, 0);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock(&dev->irqlock);
@@ -828,7 +828,7 @@ static int s5p_mfc_open(struct file *file)
 	}
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret) {
 		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
 		goto err_queue_init;
@@ -858,7 +858,7 @@ static int s5p_mfc_open(struct file *file)
 	q->allow_zero_bytesused = 1;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret) {
 		mfc_err("Failed to initialize videobuf2 queue(output)\n");
 		goto err_queue_init;
@@ -903,8 +903,8 @@ static int s5p_mfc_release(struct file *file)
 	mfc_debug_enter();
 	mutex_lock(&dev->mfc_mutex);
 	s5p_mfc_clock_on();
-	vb2_queue_release(&ctx->vq_src);
-	vb2_queue_release(&ctx->vq_dst);
+	vb2_v4l2_queue_release(&ctx->vq_src);
+	vb2_v4l2_queue_release(&ctx->vq_dst);
 	/* Mark context as idle */
 	clear_work_bit_irqsave(ctx);
 	/* If instance was initialised and not yet freed,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 1de804d..66ec058 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -471,7 +471,7 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 
 	if (reqbufs->count == 0) {
 		mfc_debug(2, "Freeing buffers\n");
-		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		ret = vb2_v4l2_reqbufs(&ctx->vq_src, reqbufs);
 		if (ret)
 			goto out;
 		s5p_mfc_close_mfc_inst(dev, ctx);
@@ -488,14 +488,14 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 
 		mfc_debug(2, "Allocating %d buffers for OUTPUT queue\n",
 				reqbufs->count);
-		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		ret = vb2_v4l2_reqbufs(&ctx->vq_src, reqbufs);
 		if (ret)
 			goto out;
 
 		ret = s5p_mfc_open_mfc_inst(dev, ctx);
 		if (ret) {
 			reqbufs->count = 0;
-			vb2_reqbufs(&ctx->vq_src, reqbufs);
+			vb2_v4l2_reqbufs(&ctx->vq_src, reqbufs);
 			goto out;
 		}
 
@@ -520,7 +520,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 
 	if (reqbufs->count == 0) {
 		mfc_debug(2, "Freeing buffers\n");
-		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		ret = vb2_v4l2_reqbufs(&ctx->vq_dst, reqbufs);
 		if (ret)
 			goto out;
 		s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers, ctx);
@@ -529,7 +529,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		WARN_ON(ctx->dst_bufs_cnt != 0);
 		mfc_debug(2, "Allocating %d buffers for CAPTURE queue\n",
 				reqbufs->count);
-		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		ret = vb2_v4l2_reqbufs(&ctx->vq_dst, reqbufs);
 		if (ret)
 			goto out;
 
@@ -540,7 +540,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		if (ret) {
 			mfc_err("Failed to allocate decoding buffers\n");
 			reqbufs->count = 0;
-			vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			vb2_v4l2_reqbufs(&ctx->vq_dst, reqbufs);
 			ret = -ENOMEM;
 			ctx->capture_state = QUEUE_FREE;
 			goto out;
@@ -602,10 +602,10 @@ static int vidioc_querybuf(struct file *file, void *priv,
 	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
 	if (ctx->state == MFCINST_GOT_INST &&
 			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		ret = vb2_querybuf(&ctx->vq_src, buf);
+		ret = vb2_v4l2_querybuf(&ctx->vq_src, buf);
 	} else if (ctx->state == MFCINST_RUNNING &&
 			buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		ret = vb2_v4l2_querybuf(&ctx->vq_dst, buf);
 		for (i = 0; i < buf->length; i++)
 			buf->m.planes[i].m.mem_offset += DST_QUEUE_OFF_BASE;
 	} else {
@@ -626,9 +626,9 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		return -EIO;
 	}
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_qbuf(&ctx->vq_src, buf);
+		return vb2_v4l2_qbuf(&ctx->vq_src, buf);
 	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_qbuf(&ctx->vq_dst, buf);
+		return vb2_v4l2_qbuf(&ctx->vq_dst, buf);
 	return -EINVAL;
 }
 
@@ -646,9 +646,9 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		return -EIO;
 	}
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+		ret = vb2_v4l2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
 	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+		ret = vb2_v4l2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
 		if (ret == 0 && ctx->state == MFCINST_FINISHED &&
 				list_empty(&ctx->vq_dst.done_list))
 			v4l2_event_queue_fh(&ctx->fh, &ev);
@@ -665,9 +665,9 @@ static int vidioc_expbuf(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
 	if (eb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_expbuf(&ctx->vq_src, eb);
+		return vb2_v4l2_expbuf(&ctx->vq_src, eb);
 	if (eb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_expbuf(&ctx->vq_dst, eb);
+		return vb2_v4l2_expbuf(&ctx->vq_dst, eb);
 	return -EINVAL;
 }
 
@@ -680,9 +680,9 @@ static int vidioc_streamon(struct file *file, void *priv,
 
 	mfc_debug_enter();
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		ret = vb2_streamon(&ctx->vq_src, type);
+		ret = vb2_v4l2_streamon(&ctx->vq_src, type);
 	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		ret = vb2_streamon(&ctx->vq_dst, type);
+		ret = vb2_v4l2_streamon(&ctx->vq_dst, type);
 	mfc_debug_leave();
 	return ret;
 }
@@ -694,9 +694,9 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_streamoff(&ctx->vq_src, type);
+		return vb2_v4l2_streamoff(&ctx->vq_src, type);
 	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_streamoff(&ctx->vq_dst, type);
+		return vb2_v4l2_streamoff(&ctx->vq_dst, type);
 	return -EINVAL;
 }
 
@@ -960,8 +960,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 				return -EINVAL;
 			}
 		}
-		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
-			vb2_plane_size(vb, 1) < ctx->chroma_size) {
+		if (vb2_v4l2_plane_size(vb, 0) < ctx->luma_size ||
+			vb2_v4l2_plane_size(vb, 1) < ctx->chroma_size) {
 			mfc_err("Plane buffer (CAPTURE) is too small\n");
 			return -EINVAL;
 		}
@@ -978,7 +978,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 			mfc_err("Plane memory not allocated\n");
 			return -EINVAL;
 		}
-		if (vb2_plane_size(vb, 0) < ctx->dec_src_buf_size) {
+		if (vb2_v4l2_plane_size(vb, 0) < ctx->dec_src_buf_size) {
 			mfc_err("Plane buffer (OUTPUT) is too small\n");
 			return -EINVAL;
 		}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 3b4b556..dad34cd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -774,7 +774,7 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
-	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_v4l2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -796,7 +796,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 					struct s5p_mfc_buf, list);
 			list_del(&dst_mb->list);
 			ctx->dst_queue_cnt--;
-			vb2_set_plane_payload(&dst_mb->b->vb2_buf, 0,
+			vb2_v4l2_set_plane_payload(&dst_mb->b->vb2_buf, 0,
 					      s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev));
 			vb2_buffer_done(&dst_mb->b->vb2_buf,
 					VB2_BUF_STATE_DONE);
@@ -840,7 +840,7 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
-	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_v4l2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -925,7 +925,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_BFRAME;
 			break;
 		}
-		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
+		vb2_v4l2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -1148,7 +1148,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		return -EINVAL;
 	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		if (reqbufs->count == 0) {
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			ret = vb2_v4l2_reqbufs(&ctx->vq_dst, reqbufs);
 			ctx->capture_state = QUEUE_FREE;
 			return ret;
 		}
@@ -1157,9 +1157,9 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 							ctx->capture_state);
 			return -EINVAL;
 		}
-		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		ret = vb2_v4l2_reqbufs(&ctx->vq_dst, reqbufs);
 		if (ret != 0) {
-			mfc_err("error in vb2_reqbufs() for E(D)\n");
+			mfc_err("error in vb2_v4l2_reqbufs() for E(D)\n");
 			return ret;
 		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
@@ -1169,13 +1169,13 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		if (ret) {
 			mfc_err("Failed to allocate encoding buffers\n");
 			reqbufs->count = 0;
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			ret = vb2_v4l2_reqbufs(&ctx->vq_dst, reqbufs);
 			return -ENOMEM;
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (reqbufs->count == 0) {
 			mfc_debug(2, "Freeing buffers\n");
-			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+			ret = vb2_v4l2_reqbufs(&ctx->vq_src, reqbufs);
 			s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers,
 					ctx);
 			ctx->output_state = QUEUE_FREE;
@@ -1199,9 +1199,9 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			}
 		}
 
-		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		ret = vb2_v4l2_reqbufs(&ctx->vq_src, reqbufs);
 		if (ret != 0) {
-			mfc_err("error in vb2_reqbufs() for E(S)\n");
+			mfc_err("error in vb2_v4l2_reqbufs() for E(S)\n");
 			return ret;
 		}
 		ctx->output_state = QUEUE_BUFS_REQUESTED;
@@ -1227,16 +1227,16 @@ static int vidioc_querybuf(struct file *file, void *priv,
 			mfc_err("invalid context state: %d\n", ctx->state);
 			return -EINVAL;
 		}
-		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		ret = vb2_v4l2_querybuf(&ctx->vq_dst, buf);
 		if (ret != 0) {
-			mfc_err("error in vb2_querybuf() for E(D)\n");
+			mfc_err("error in vb2_v4l2_querybuf() for E(D)\n");
 			return ret;
 		}
 		buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
 	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		ret = vb2_querybuf(&ctx->vq_src, buf);
+		ret = vb2_v4l2_querybuf(&ctx->vq_src, buf);
 		if (ret != 0) {
-			mfc_err("error in vb2_querybuf() for E(S)\n");
+			mfc_err("error in vb2_v4l2_querybuf() for E(S)\n");
 			return ret;
 		}
 	} else {
@@ -1260,9 +1260,9 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 			mfc_err("Call on QBUF after EOS command\n");
 			return -EIO;
 		}
-		return vb2_qbuf(&ctx->vq_src, buf);
+		return vb2_v4l2_qbuf(&ctx->vq_src, buf);
 	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		return vb2_qbuf(&ctx->vq_dst, buf);
+		return vb2_v4l2_qbuf(&ctx->vq_dst, buf);
 	}
 	return -EINVAL;
 }
@@ -1281,9 +1281,9 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		return -EIO;
 	}
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+		ret = vb2_v4l2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
 	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+		ret = vb2_v4l2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
 		if (ret == 0 && ctx->state == MFCINST_FINISHED
 					&& list_empty(&ctx->vq_dst.done_list))
 			v4l2_event_queue_fh(&ctx->fh, &ev);
@@ -1301,9 +1301,9 @@ static int vidioc_expbuf(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
 	if (eb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_expbuf(&ctx->vq_src, eb);
+		return vb2_v4l2_expbuf(&ctx->vq_src, eb);
 	if (eb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_expbuf(&ctx->vq_dst, eb);
+		return vb2_v4l2_expbuf(&ctx->vq_dst, eb);
 	return -EINVAL;
 }
 
@@ -1314,9 +1314,9 @@ static int vidioc_streamon(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_streamon(&ctx->vq_src, type);
+		return vb2_v4l2_streamon(&ctx->vq_src, type);
 	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_streamon(&ctx->vq_dst, type);
+		return vb2_v4l2_streamon(&ctx->vq_dst, type);
 	return -EINVAL;
 }
 
@@ -1327,9 +1327,9 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_streamoff(&ctx->vq_src, type);
+		return vb2_v4l2_streamoff(&ctx->vq_src, type);
 	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_streamoff(&ctx->vq_dst, type);
+		return vb2_v4l2_streamoff(&ctx->vq_dst, type);
 	return -EINVAL;
 }
 
@@ -1916,8 +1916,8 @@ static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
 		if (ret < 0)
 			return ret;
 		mfc_debug(2, "plane size: %ld, dst size: %zu\n",
-			vb2_plane_size(vb, 0), ctx->enc_dst_buf_size);
-		if (vb2_plane_size(vb, 0) < ctx->enc_dst_buf_size) {
+			vb2_v4l2_plane_size(vb, 0), ctx->enc_dst_buf_size);
+		if (vb2_v4l2_plane_size(vb, 0) < ctx->enc_dst_buf_size) {
 			mfc_err("plane size is too small for capture\n");
 			return -EINVAL;
 		}
@@ -1926,11 +1926,11 @@ static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
 		if (ret < 0)
 			return ret;
 		mfc_debug(2, "plane size: %ld, luma size: %d\n",
-			vb2_plane_size(vb, 0), ctx->luma_size);
+			vb2_v4l2_plane_size(vb, 0), ctx->luma_size);
 		mfc_debug(2, "plane size: %ld, chroma size: %d\n",
-			vb2_plane_size(vb, 1), ctx->chroma_size);
-		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
-		    vb2_plane_size(vb, 1) < ctx->chroma_size) {
+			vb2_v4l2_plane_size(vb, 1), ctx->chroma_size);
+		if (vb2_v4l2_plane_size(vb, 0) < ctx->luma_size ||
+		    vb2_v4l2_plane_size(vb, 1) < ctx->chroma_size) {
 			mfc_err("plane size is too small for output\n");
 			return -EINVAL;
 		}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 13aff41..aa0cee4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1266,7 +1266,7 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
-	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_v4l2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1308,7 +1308,7 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
-	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_v4l2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1477,7 +1477,7 @@ static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
 		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
-			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+			vb2_v4l2_set_plane_payload(&b->b->vb2_buf, i, 0);
 		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 5c7f35a..3be8f16 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1615,7 +1615,7 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
-	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_v4l2_plane_size(&dst_mb->b->vb2_buf, 0);
 
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 
@@ -1658,7 +1658,7 @@ static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
-	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_v4l2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1835,7 +1835,7 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
 		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
-			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+			vb2_v4l2_set_plane_payload(&b->b->vb2_buf, i, 0);
 		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index dc1c679..54f330f 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -691,7 +691,7 @@ static int mxr_reqbufs(struct file *file, void *priv,
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	return vb2_reqbufs(&layer->vb_queue, p);
+	return vb2_v4l2_reqbufs(&layer->vb_queue, p);
 }
 
 static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
@@ -699,7 +699,7 @@ static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	return vb2_querybuf(&layer->vb_queue, p);
+	return vb2_v4l2_querybuf(&layer->vb_queue, p);
 }
 
 static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
@@ -707,7 +707,7 @@ static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d(%d)\n", __func__, __LINE__, p->index);
-	return vb2_qbuf(&layer->vb_queue, p);
+	return vb2_v4l2_qbuf(&layer->vb_queue, p);
 }
 
 static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
@@ -715,7 +715,7 @@ static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
+	return vb2_v4l2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
 }
 
 static int mxr_expbuf(struct file *file, void *priv,
@@ -724,7 +724,7 @@ static int mxr_expbuf(struct file *file, void *priv,
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	return vb2_expbuf(&layer->vb_queue, eb);
+	return vb2_v4l2_expbuf(&layer->vb_queue, eb);
 }
 
 static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
@@ -732,7 +732,7 @@ static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	return vb2_streamon(&layer->vb_queue, i);
+	return vb2_v4l2_streamon(&layer->vb_queue, i);
 }
 
 static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
@@ -740,7 +740,7 @@ static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct mxr_layer *layer = video_drvdata(file);
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
-	return vb2_streamoff(&layer->vb_queue, i);
+	return vb2_v4l2_streamoff(&layer->vb_queue, i);
 }
 
 static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
@@ -804,7 +804,7 @@ static int mxr_video_open(struct file *file)
 		goto fail_fh_open;
 	}
 
-	ret = vb2_queue_init(&layer->vb_queue);
+	ret = vb2_v4l2_queue_init(&layer->vb_queue);
 	if (ret != 0) {
 		mxr_err(mdev, "failed to initialize vb2 queue\n");
 		goto fail_power;
@@ -838,7 +838,7 @@ mxr_video_poll(struct file *file, struct poll_table_struct *wait)
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
 
 	mutex_lock(&layer->mutex);
-	res = vb2_poll(&layer->vb_queue, file, wait);
+	res = vb2_v4l2_poll(&layer->vb_queue, file, wait);
 	mutex_unlock(&layer->mutex);
 	return res;
 }
@@ -864,7 +864,7 @@ static int mxr_video_release(struct file *file)
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
 	mutex_lock(&layer->mutex);
 	if (v4l2_fh_is_singular_file(file)) {
-		vb2_queue_release(&layer->vb_queue);
+		vb2_v4l2_queue_release(&layer->vb_queue);
 		mxr_power_put(layer->mdev);
 	}
 	v4l2_fh_release(file);
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 1affcae..08960f9 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -918,13 +918,13 @@ static int sh_veu_buf_prepare(struct vb2_buffer *vb)
 	sizeimage = vfmt->bytesperline * vfmt->frame.height *
 		vfmt->fmt->depth / vfmt->fmt->ydepth;
 
-	if (vb2_plane_size(vb, 0) < sizeimage) {
+	if (vb2_v4l2_plane_size(vb, 0) < sizeimage) {
 		dev_dbg(veu->dev, "%s data will not fit into plane (%lu < %u)\n",
-			__func__, vb2_plane_size(vb, 0), sizeimage);
+			__func__, vb2_v4l2_plane_size(vb, 0), sizeimage);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, sizeimage);
 
 	return 0;
 }
@@ -961,7 +961,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->lock = &veu->fop_lock;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret < 0)
 		return ret;
 
@@ -974,7 +974,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->lock = &veu->fop_lock;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 		/* ========== File operations ========== */
@@ -1009,12 +1009,12 @@ static int sh_veu_release(struct file *file)
 
 	if (veu_file == veu->capture) {
 		veu->capture = NULL;
-		vb2_queue_release(v4l2_m2m_get_vq(veu->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE));
+		vb2_v4l2_queue_release(v4l2_m2m_get_vq(veu->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE));
 	}
 
 	if (veu_file == veu->output) {
 		veu->output = NULL;
-		vb2_queue_release(v4l2_m2m_get_vq(veu->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT));
+		vb2_v4l2_queue_release(v4l2_m2m_get_vq(veu->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT));
 	}
 
 	if (!veu->output && !veu->capture && veu->m2m_ctx) {
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index fe5c8ab..d80f4c4 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -268,14 +268,14 @@ static int sh_vou_buf_prepare(struct vb2_buffer *vb)
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		/* User buffer too small */
 		dev_warn(vou_dev->v4l2_dev.dev, "buffer too small (%lu < %u)\n",
-			 vb2_plane_size(vb, 0), size);
+			 vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 	return 0;
 }
 
@@ -1300,7 +1300,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->min_buffers_needed = 2;
 	q->lock = &vou_dev->fop_lock;
-	ret = vb2_queue_init(q);
+	ret = vb2_v4l2_queue_init(q);
 	if (ret)
 		goto einitctx;
 
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 7268a2f..4107c48 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -288,13 +288,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	size = icd->sizeimage;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0), size);
+				__func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	if (!buf->p_dma_desc) {
 		if (list_empty(&isi->dma_desc_head)) {
@@ -481,7 +481,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &ici->host_lock;
 
-	return vb2_queue_init(q);
+	return vb2_v4l2_queue_init(q);
 }
 
 static int isi_camera_set_fmt(struct soc_camera_device *icd,
@@ -745,7 +745,7 @@ static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	return vb2_v4l2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int isi_camera_querycap(struct soc_camera_host *ici,
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 57e8ad0..b425129 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -505,7 +505,7 @@ static int mx2_videobuf_prepare(struct vb2_buffer *vb)
 	int ret = 0;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+		vb, vb2_plane_vaddr(vb, 0), vb2_v4l2_get_plane_payload(vb, 0));
 
 #ifdef DEBUG
 	/*
@@ -513,12 +513,12 @@ static int mx2_videobuf_prepare(struct vb2_buffer *vb)
 	 * the buffer with something
 	 */
 	memset((void *)vb2_plane_vaddr(vb, 0),
-	       0xaa, vb2_get_plane_payload(vb, 0));
+	       0xaa, vb2_v4l2_get_plane_payload(vb, 0));
 #endif
 
-	vb2_set_plane_payload(vb, 0, icd->sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, icd->sizeimage);
 	if (vb2_plane_vaddr(vb, 0) &&
-	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+	    vb2_v4l2_get_plane_payload(vb, 0) > vb2_v4l2_plane_size(vb, 0)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -540,7 +540,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	unsigned long flags;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+		vb, vb2_plane_vaddr(vb, 0), vb2_v4l2_get_plane_payload(vb, 0));
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
@@ -794,7 +794,7 @@ static int mx2_camera_init_videobuf(struct vb2_queue *q,
 	q->buf_struct_size = sizeof(struct mx2_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
-	return vb2_queue_init(q);
+	return vb2_v4l2_queue_init(q);
 }
 
 #define MX2_BUS_FLAGS	(V4L2_MBUS_MASTER | \
@@ -1281,7 +1281,7 @@ static unsigned int mx2_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	return vb2_v4l2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
@@ -1346,7 +1346,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 #endif
 		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
 				vb2_plane_vaddr(&vb->vb2_buf, 0),
-				vb2_get_plane_payload(&vb->vb2_buf, 0));
+				vb2_v4l2_get_plane_payload(&vb->vb2_buf, 0));
 
 		list_del_init(&buf->internal.queue);
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index fa8849f..d2d14d8 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -272,9 +272,9 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 
 	new_size = icd->sizeimage;
 
-	if (vb2_plane_size(vb, 0) < new_size) {
+	if (vb2_v4l2_plane_size(vb, 0) < new_size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %zu)\n",
-			vb->v4l2_buf.index, vb2_plane_size(vb, 0), new_size);
+			vb->v4l2_buf.index, vb2_v4l2_plane_size(vb, 0), new_size);
 		goto error;
 	}
 
@@ -296,7 +296,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 		txd = buf->txd;
 	}
 
-	vb2_set_plane_payload(vb, 0, new_size);
+	vb2_v4l2_set_plane_payload(vb, 0, new_size);
 
 	/* This is the configuration of one sg-element */
 	video->out_pixel_fmt = fourcc_to_ipu_pix(host_fmt->fourcc);
@@ -325,7 +325,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 #ifdef DEBUG
 	/* helps to see what DMA actually has written */
 	if (vb2_plane_vaddr(vb, 0))
-		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
+		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_v4l2_get_plane_payload(vb, 0));
 #endif
 
 	spin_lock_irq(&mx3_cam->lock);
@@ -387,7 +387,7 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
 
-	mx3_cam->buf_total -= vb2_plane_size(vb, 0);
+	mx3_cam->buf_total -= vb2_v4l2_plane_size(vb, 0);
 }
 
 static int mx3_videobuf_init(struct vb2_buffer *vb)
@@ -403,7 +403,7 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 		INIT_LIST_HEAD(&buf->queue);
 		sg_init_table(&buf->sg, 1);
 
-		mx3_cam->buf_total += vb2_plane_size(vb, 0);
+		mx3_cam->buf_total += vb2_v4l2_plane_size(vb, 0);
 	}
 
 	return 0;
@@ -457,7 +457,7 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &ici->host_lock;
 
-	return vb2_queue_init(q);
+	return vb2_v4l2_queue_init(q);
 }
 
 /* First part of ipu_csi_init_interface() */
@@ -978,7 +978,7 @@ static unsigned int mx3_camera_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	return vb2_v4l2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int mx3_camera_querycap(struct soc_camera_host *ici,
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index c529d10..b81c649 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -769,16 +769,16 @@ static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 
 	size = icd->sizeimage;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
-			vbuf->v4l2_buf.index, vb2_plane_size(vb, 0), size);
+			vbuf->v4l2_buf.index, vb2_v4l2_plane_size(vb, 0), size);
 		goto error;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+		vb, vb2_plane_vaddr(vb, 0), vb2_v4l2_get_plane_payload(vb, 0));
 
 	spin_lock_irq(&priv->lock);
 
@@ -1776,7 +1776,7 @@ static unsigned int rcar_vin_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	return vb2_v4l2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int rcar_vin_querycap(struct soc_camera_host *ici,
@@ -1803,7 +1803,7 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
 	vq->timestamp_flags  = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vq->lock = &ici->host_lock;
 
-	return vb2_queue_init(vq);
+	return vb2_v4l2_queue_init(vq);
 }
 
 static struct soc_camera_host_ops rcar_vin_host_ops = {
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 7335b79..f94cd5d 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -390,16 +390,16 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 
 	size = icd->sizeimage;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
-			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
+			vb->v4l2_buf.index, vb2_v4l2_plane_size(vb, 0), size);
 		goto error;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+		vb, vb2_plane_vaddr(vb, 0), vb2_v4l2_get_plane_payload(vb, 0));
 
 #ifdef DEBUG
 	/*
@@ -407,7 +407,7 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 	 * the buffer with something
 	 */
 	if (vb2_plane_vaddr(vb, 0))
-		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
+		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_v4l2_get_plane_payload(vb, 0));
 #endif
 
 	spin_lock_irq(&pcdev->lock);
@@ -453,7 +453,7 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	if (buf->queue.next)
 		list_del_init(&buf->queue);
 
-	pcdev->buf_total -= PAGE_ALIGN(vb2_plane_size(vb, 0));
+	pcdev->buf_total -= PAGE_ALIGN(vb2_v4l2_plane_size(vb, 0));
 	dev_dbg(icd->parent, "%s() %zu bytes buffers\n", __func__,
 		pcdev->buf_total);
 
@@ -466,7 +466,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
-	pcdev->buf_total += PAGE_ALIGN(vb2_plane_size(vb, 0));
+	pcdev->buf_total += PAGE_ALIGN(vb2_v4l2_plane_size(vb, 0));
 	dev_dbg(icd->parent, "%s() %zu bytes buffers\n", __func__,
 		pcdev->buf_total);
 
@@ -1663,7 +1663,7 @@ static unsigned int sh_mobile_ceu_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	return vb2_v4l2_poll(&icd->vb2_vidq, file, pt);
 }
 
 static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
@@ -1690,7 +1690,7 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &ici->host_lock;
 
-	return vb2_queue_init(q);
+	return vb2_v4l2_queue_init(q);
 }
 
 static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4595590..19ebc61 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -378,7 +378,7 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 
 		ret = ici->ops->reqbufs(icd, p);
 	} else {
-		ret = vb2_reqbufs(&icd->vb2_vidq, p);
+		ret = vb2_v4l2_reqbufs(&icd->vb2_vidq, p);
 	}
 
 	if (!ret && !icd->streamer)
@@ -398,7 +398,7 @@ static int soc_camera_querybuf(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		return videobuf_querybuf(&icd->vb_vidq, p);
 	else
-		return vb2_querybuf(&icd->vb2_vidq, p);
+		return vb2_v4l2_querybuf(&icd->vb2_vidq, p);
 }
 
 static int soc_camera_qbuf(struct file *file, void *priv,
@@ -415,7 +415,7 @@ static int soc_camera_qbuf(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		return videobuf_qbuf(&icd->vb_vidq, p);
 	else
-		return vb2_qbuf(&icd->vb2_vidq, p);
+		return vb2_v4l2_qbuf(&icd->vb2_vidq, p);
 }
 
 static int soc_camera_dqbuf(struct file *file, void *priv,
@@ -432,7 +432,7 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		return videobuf_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
 	else
-		return vb2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
+		return vb2_v4l2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
 static int soc_camera_create_bufs(struct file *file, void *priv,
@@ -445,7 +445,7 @@ static int soc_camera_create_bufs(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		return -EINVAL;
 	else
-		return vb2_create_bufs(&icd->vb2_vidq, create);
+		return vb2_v4l2_create_bufs(&icd->vb2_vidq, create);
 }
 
 static int soc_camera_prepare_buf(struct file *file, void *priv,
@@ -458,7 +458,7 @@ static int soc_camera_prepare_buf(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		return -EINVAL;
 	else
-		return vb2_prepare_buf(&icd->vb2_vidq, b);
+		return vb2_v4l2_prepare_buf(&icd->vb2_vidq, b);
 }
 
 static int soc_camera_expbuf(struct file *file, void *priv,
@@ -474,7 +474,7 @@ static int soc_camera_expbuf(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		return -EINVAL;
 	else
-		return vb2_expbuf(&icd->vb2_vidq, p);
+		return vb2_v4l2_expbuf(&icd->vb2_vidq, p);
 }
 
 /* Always entered with .host_lock held */
@@ -786,7 +786,7 @@ static int soc_camera_close(struct file *file)
 		pm_runtime_disable(&icd->vdev->dev);
 
 		if (ici->ops->init_videobuf2)
-			vb2_queue_release(&icd->vb2_vidq);
+			vb2_v4l2_queue_release(&icd->vb2_vidq);
 		__soc_camera_power_off(icd);
 
 		soc_camera_remove_device(icd);
@@ -812,7 +812,7 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 	dev_dbg(icd->pdev, "read called, buf %p\n", buf);
 
 	if (ici->ops->init_videobuf2 && icd->vb2_vidq.io_modes & VB2_READ)
-		return vb2_read(&icd->vb2_vidq, buf, count, ppos,
+		return vb2_v4l2_read(&icd->vb2_vidq, buf, count, ppos,
 				file->f_flags & O_NONBLOCK);
 
 	dev_err(icd->pdev, "camera device read not implemented\n");
@@ -978,7 +978,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		ret = videobuf_streamon(&icd->vb_vidq);
 	else
-		ret = vb2_streamon(&icd->vb2_vidq, i);
+		ret = vb2_v4l2_streamon(&icd->vb2_vidq, i);
 
 	if (!ret)
 		v4l2_subdev_call(sd, video, s_stream, 1);
@@ -1008,7 +1008,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	if (ici->ops->init_videobuf)
 		videobuf_streamoff(&icd->vb_vidq);
 	else
-		vb2_streamoff(&icd->vb2_vidq, i);
+		vb2_v4l2_streamoff(&icd->vb2_vidq, i);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index df61355..193904a 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -476,7 +476,7 @@ static int bdisp_buf_prepare(struct vb2_buffer *vb)
 	}
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		vb2_set_plane_payload(vb, 0, frame->sizeimage);
+		vb2_v4l2_set_plane_payload(vb, 0, frame->sizeimage);
 
 	return 0;
 }
@@ -486,7 +486,7 @@ static void bdisp_buf_queue(struct vb2_buffer *vb)
 	struct bdisp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	/* return to V4L2 any 0-size buffer so it can be dequeued by user */
-	if (!vb2_get_plane_payload(vb, 0)) {
+	if (!vb2_v4l2_get_plane_payload(vb, 0)) {
 		dev_dbg(ctx->bdisp_dev->dev, "0 data buffer, skip it\n");
 		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 		return;
@@ -554,7 +554,7 @@ static int queue_init(void *priv,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->bdisp_dev->lock;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -568,7 +568,7 @@ static int queue_init(void *priv,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->bdisp_dev->lock;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 static int bdisp_open(struct file *file)
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 6934a95..58c2ed3 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1845,17 +1845,17 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 	}
 
 	for (i = 0; i < num_planes; i++) {
-		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
+		if (vb2_v4l2_plane_size(vb, i) < q_data->sizeimage[i]) {
 			vpe_err(ctx->dev,
 				"data will not fit into plane (%lu < %lu)\n",
-				vb2_plane_size(vb, i),
+				vb2_v4l2_plane_size(vb, i),
 				(long) q_data->sizeimage[i]);
 			return -EINVAL;
 		}
 	}
 
 	for (i = 0; i < num_planes; i++)
-		vb2_set_plane_payload(vb, i, q_data->sizeimage[i]);
+		vb2_v4l2_set_plane_payload(vb, i, q_data->sizeimage[i]);
 
 	return 0;
 }
@@ -1910,7 +1910,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &dev->dev_mutex;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -1924,7 +1924,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &dev->dev_mutex;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 static const struct v4l2_ctrl_config vpe_bufs_per_job = {
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 7664319..1d3cc3d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -221,7 +221,7 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
-	if (vb2_plane_size(&in_vb->vb2_buf, 0) > vb2_plane_size(&out_vb->vb2_buf, 0)) {
+	if (vb2_v4l2_plane_size(&in_vb->vb2_buf, 0) > vb2_v4l2_plane_size(&out_vb->vb2_buf, 0)) {
 		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
 		return -EINVAL;
 	}
@@ -763,13 +763,13 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 		}
 	}
 
-	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+	if (vb2_v4l2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
+				__func__, vb2_v4l2_plane_size(vb, 0), (long)q_data->sizeimage);
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+	vb2_v4l2_set_plane_payload(vb, 0, q_data->sizeimage);
 
 	return 0;
 }
@@ -834,7 +834,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
 
-	ret = vb2_queue_init(src_vq);
+	ret = vb2_v4l2_queue_init(src_vq);
 	if (ret)
 		return ret;
 
@@ -847,7 +847,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->dev_mutex;
 
-	return vb2_queue_init(dst_vq);
+	return vb2_v4l2_queue_init(dst_vq);
 }
 
 static const struct v4l2_ctrl_config vim2m_ctrl_trans_time_msec = {
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index a047b47..3811593 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1040,7 +1040,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 
-		ret = vb2_queue_init(q);
+		ret = vb2_v4l2_queue_init(q);
 		if (ret)
 			goto unreg_dev;
 	}
@@ -1059,7 +1059,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 
-		ret = vb2_queue_init(q);
+		ret = vb2_v4l2_queue_init(q);
 		if (ret)
 			goto unreg_dev;
 	}
@@ -1078,7 +1078,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 
-		ret = vb2_queue_init(q);
+		ret = vb2_v4l2_queue_init(q);
 		if (ret)
 			goto unreg_dev;
 	}
@@ -1097,7 +1097,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 
-		ret = vb2_queue_init(q);
+		ret = vb2_v4l2_queue_init(q);
 		if (ret)
 			goto unreg_dev;
 	}
@@ -1115,7 +1115,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 8;
 		q->lock = &dev->mutex;
 
-		ret = vb2_queue_init(q);
+		ret = vb2_v4l2_queue_init(q);
 		if (ret)
 			goto unreg_dev;
 	}
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index cf7f56c..fdcf7d2 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -235,12 +235,12 @@ static int sdr_cap_buf_prepare(struct vb2_buffer *vb)
 		dev->buf_prepare_error = false;
 		return -EINVAL;
 	}
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dprintk(dev, 1, "%s data will not fit into plane (%lu < %u)\n",
-				__func__, vb2_plane_size(vb, 0), size);
+				__func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -495,7 +495,7 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	u8 *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned long i;
-	unsigned long plane_size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+	unsigned long plane_size = vb2_v4l2_plane_size(&buf->vb.vb2_buf, 0);
 	s32 src_phase_step;
 	s32 mod_phase_step;
 	s32 fixp_i;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 26837e4..7a3b694 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -103,7 +103,7 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
 
-	memset(vbuf, 0x10, vb2_plane_size(&buf->vb.vb2_buf, 0));
+	memset(vbuf, 0x10, vb2_v4l2_plane_size(&buf->vb.vb2_buf, 0));
 
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
@@ -124,7 +124,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 
 	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
 
-	memset(vbuf, 0, vb2_plane_size(&buf->vb.vb2_buf, 0));
+	memset(vbuf, 0, vb2_v4l2_plane_size(&buf->vb.vb2_buf, 0));
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
 		unsigned i;
 
@@ -176,12 +176,12 @@ static int vbi_cap_buf_prepare(struct vb2_buffer *vb)
 		dev->buf_prepare_error = false;
 		return -EINVAL;
 	}
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dprintk(dev, 1, "%s data will not fit into plane (%lu < %u)\n",
-				__func__, vb2_plane_size(vb, 0), size);
+				__func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index a51fc70..86580ea 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -67,12 +67,12 @@ static int vbi_out_buf_prepare(struct vb2_buffer *vb)
 		dev->buf_prepare_error = false;
 		return -EINVAL;
 	}
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dprintk(dev, 1, "%s data will not fit into plane (%lu < %u)\n",
-				__func__, vb2_plane_size(vb, 0), size);
+				__func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -223,7 +223,7 @@ void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *bu
 {
 	struct v4l2_sliced_vbi_data *vbi = vb2_plane_vaddr(&buf->vb.vb2_buf,
 							   0);
-	unsigned elems = vb2_get_plane_payload(&buf->vb.vb2_buf, 0) / sizeof(*vbi);
+	unsigned elems = vb2_v4l2_get_plane_payload(&buf->vb.vb2_buf, 0) / sizeof(*vbi);
 
 	dev->vbi_out_have_cc[0] = false;
 	dev->vbi_out_have_cc[1] = false;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 3ffa410..bc876f8 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -193,13 +193,13 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		size = tpg_g_line_width(&dev->tpg, p) * dev->fmt_cap_rect.height +
 			dev->fmt_cap->data_offset[p];
 
-		if (vb2_plane_size(vb, p) < size) {
+		if (vb2_v4l2_plane_size(vb, p) < size) {
 			dprintk(dev, 1, "%s data will not fit into plane %u (%lu < %lu)\n",
-					__func__, p, vb2_plane_size(vb, p), size);
+					__func__, p, vb2_v4l2_plane_size(vb, p), size);
 			return -EINVAL;
 		}
 
-		vb2_set_plane_payload(vb, p, size);
+		vb2_v4l2_set_plane_payload(vb, p, size);
 		vbuf->v4l2_planes[p].data_offset = dev->fmt_cap->data_offset[p];
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 9d3055c..72fc616 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -142,9 +142,9 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 		size = dev->bytesperline_out[p] * dev->fmt_out_rect.height +
 			vbuf->v4l2_planes[p].data_offset;
 
-		if (vb2_get_plane_payload(vb, p) < size) {
+		if (vb2_v4l2_get_plane_payload(vb, p) < size) {
 			dprintk(dev, 1, "%s the payload is too small for plane %u (%lu < %lu)\n",
-					__func__, p, vb2_get_plane_payload(vb, p), size);
+					__func__, p, vb2_v4l2_get_plane_payload(vb, p), size);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index ee47aaf..0ec2218 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -613,7 +613,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	done->buf.v4l2_buf.sequence = video->sequence++;
 	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
 	for (i = 0; i < done->buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf.vb2_buf, i,
+		vb2_v4l2_set_plane_payload(&done->buf.vb2_buf, i,
 				      done->length[i]);
 	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
@@ -833,7 +833,7 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 
 	for (i = 0; i < vb->num_planes; ++i) {
 		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
-		buf->length[i] = vb2_plane_size(vb, i);
+		buf->length[i] = vb2_v4l2_plane_size(vb, i);
 
 		if (buf->length[i] < format->plane_fmt[i].sizeimage)
 			return -EINVAL;
@@ -1098,7 +1098,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		goto err_stop;
 
 	/* Start the queue. */
-	ret = vb2_streamon(&video->queue, type);
+	ret = vb2_v4l2_streamon(&video->queue, type);
 	if (ret < 0)
 		goto err_cleanup;
 
@@ -1164,7 +1164,7 @@ static int vsp1_video_release(struct file *file)
 
 	mutex_lock(&video->lock);
 	if (video->queue.owner == vfh) {
-		vb2_queue_release(&video->queue);
+		vb2_v4l2_queue_release(&video->queue);
 		video->queue.owner = NULL;
 	}
 	mutex_unlock(&video->lock);
@@ -1268,7 +1268,7 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
 	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	ret = vb2_queue_init(&video->queue);
+	ret = vb2_v4l2_queue_init(&video->queue);
 	if (ret < 0) {
 		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
 		goto error;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d9dcd4b..57045d3 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -304,7 +304,7 @@ static void xvip_dma_complete(void *param)
 	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
 	buf->buf.v4l2_buf.sequence = dma->sequence++;
 	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
-	vb2_set_plane_payload(&buf->buf, 0, dma->format.sizeimage);
+	vb2_v4l2_set_plane_payload(&buf->buf, 0, dma->format.sizeimage);
 	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
 }
 
@@ -720,7 +720,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	dma->queue.mem_ops = &vb2_dma_contig_memops;
 	dma->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
 				   | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
-	ret = vb2_queue_init(&dma->queue);
+	ret = vb2_v4l2_queue_init(&dma->queue);
 	if (ret < 0) {
 		dev_err(dma->xdev->dev, "failed to initialize VB2 queue\n");
 		goto error;
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 826687b..852da7c 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -313,7 +313,7 @@ static void airspy_urb_complete(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = airspy_convert_stream(s, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
+		vb2_v4l2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = s->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
@@ -1024,7 +1024,7 @@ static int airspy_probe(struct usb_interface *intf,
 	s->vb_queue.ops = &airspy_vb2_ops;
 	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&s->vb_queue);
+	ret = vb2_v4l2_queue_init(&s->vb_queue);
 	if (ret) {
 		dev_err(s->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index c207c03..2e15ddd 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -57,12 +57,12 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 
 	size = dev->vbi_width * dev->vbi_height * 2;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		pr_err("%s data will not fit into plane (%lu < %lu)\n",
-			__func__, vb2_plane_size(vb, 0), size);
+			__func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -77,7 +77,7 @@ vbi_buffer_queue(struct vb2_buffer *vb)
 	unsigned long flags = 0;
 
 	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
+	buf->length = vb2_v4l2_plane_size(vb, 0);
 
 	spin_lock_irqsave(&dev->slock, flags);
 	list_add_tail(&buf->list, &vbiq->active);
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index c73c627..36c694f 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -666,12 +666,12 @@ buffer_prepare(struct vb2_buffer *vb)
 
 	buf->length = dev->height * dev->bytesperline;
 
-	if (vb2_plane_size(vb, 0) < buf->length) {
+	if (vb2_v4l2_plane_size(vb, 0) < buf->length) {
 		pr_err("%s data will not fit into plane (%lu < %lu)\n",
-			__func__, vb2_plane_size(vb, 0), buf->length);
+			__func__, vb2_v4l2_plane_size(vb, 0), buf->length);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, buf->length);
+	vb2_v4l2_set_plane_payload(vb, 0, buf->length);
 	return 0;
 }
 
@@ -687,7 +687,7 @@ buffer_queue(struct vb2_buffer *vb)
 	unsigned long flags = 0;
 
 	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
+	buf->length = vb2_v4l2_plane_size(vb, 0);
 
 	spin_lock_irqsave(&dev->slock, flags);
 	list_add_tail(&buf->list, &vidq->active);
@@ -1717,7 +1717,7 @@ static int au0828_vb2_setup(struct au0828_dev *dev)
 	q->ops = &au0828_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
-	rc = vb2_queue_init(q);
+	rc = vb2_v4l2_queue_init(q);
 	if (rc < 0)
 		return rc;
 
@@ -1731,7 +1731,7 @@ static int au0828_vb2_setup(struct au0828_dev *dev)
 	q->ops = &au0828_vbi_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
-	rc = vb2_queue_init(q);
+	rc = vb2_v4l2_queue_init(q);
 	if (rc < 0)
 		return rc;
 
@@ -1861,8 +1861,8 @@ int au0828_analog_register(struct au0828_dev *dev,
 err_reg_vbi_dev:
 	video_unregister_device(&dev->vdev);
 err_reg_vdev:
-	vb2_queue_release(&dev->vb_vidq);
-	vb2_queue_release(&dev->vb_vbiq);
+	vb2_v4l2_queue_release(&dev->vb_vidq);
+	vb2_v4l2_queue_release(&dev->vb_vbiq);
 	return ret;
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 4007b44..6076f8f 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -68,12 +68,12 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 
 	size = v4l2->vbi_width * v4l2->vbi_height * 2;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		printk(KERN_INFO "%s data will not fit into plane (%lu < %lu)\n",
-		       __func__, vb2_plane_size(vb, 0), size);
+		       __func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -88,7 +88,7 @@ vbi_buffer_queue(struct vb2_buffer *vb)
 	unsigned long flags = 0;
 
 	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
+	buf->length = vb2_v4l2_plane_size(vb, 0);
 
 	spin_lock_irqsave(&dev->slock, flags);
 	list_add_tail(&buf->list, &vbiq->active);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b34ff421..20b84eb 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -911,12 +911,12 @@ buffer_prepare(struct vb2_buffer *vb)
 
 	size = (v4l2->width * v4l2->height * v4l2->format->depth + 7) >> 3;
 
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		em28xx_videodbg("%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0), size);
+				__func__, vb2_v4l2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -1054,7 +1054,7 @@ buffer_queue(struct vb2_buffer *vb)
 
 	em28xx_videodbg("%s\n", __func__);
 	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
+	buf->length = vb2_v4l2_plane_size(vb, 0);
 
 	spin_lock_irqsave(&dev->slock, flags);
 	list_add_tail(&buf->list, &vidq->active);
@@ -1087,7 +1087,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	q->ops = &em28xx_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
-	rc = vb2_queue_init(q);
+	rc = vb2_v4l2_queue_init(q);
 	if (rc < 0)
 		return rc;
 
@@ -1101,7 +1101,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	q->ops = &em28xx_vbi_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
-	rc = vb2_queue_init(q);
+	rc = vb2_v4l2_queue_init(q);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 8183a1d..7bb18da 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -1118,7 +1118,7 @@ int go7007_v4l2_init(struct go7007 *go)
 	go->vidq.buf_struct_size = sizeof(struct go7007_buffer);
 	go->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	go->vidq.lock = &go->queue_lock;
-	rv = vb2_queue_init(&go->vidq);
+	rv = vb2_v4l2_queue_init(&go->vidq);
 	if (rv)
 		return rv;
 	*vdev = go7007_template;
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index c07b44f..f55a374 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -290,7 +290,7 @@ static void hackrf_urb_complete(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = hackrf_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
+		vb2_v4l2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
@@ -1058,7 +1058,7 @@ static int hackrf_probe(struct usb_interface *intf,
 	dev->vb_queue.ops = &hackrf_vb2_ops;
 	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&dev->vb_queue);
+	ret = vb2_v4l2_queue_init(&dev->vb_queue);
 	if (ret) {
 		dev_err(dev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index af4dd23..69b6066 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -433,7 +433,7 @@ static void msi2500_isoc_handler(struct urb *urb)
 		/* fill framebuffer */
 		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		flen = msi2500_convert_stream(dev, ptr, iso_buf, flen);
-		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, flen);
+		vb2_v4l2_set_plane_payload(&fbuf->vb.vb2_buf, 0, flen);
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
@@ -1222,7 +1222,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	dev->vb_queue.ops = &msi2500_vb2_ops;
 	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	ret = vb2_queue_init(&dev->vb_queue);
+	ret = vb2_v4l2_queue_init(&dev->vb_queue);
 	if (ret) {
 		dev_err(dev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 79e4ca2..17d5d33 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1011,7 +1011,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->vb_queue.ops = &pwc_vb_queue_ops;
 	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	pdev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	rc = vb2_queue_init(&pdev->vb_queue);
+	rc = vb2_v4l2_queue_init(&pdev->vb_queue);
 	if (rc < 0) {
 		PWC_ERROR("Oops, could not initialize vb2 queue.\n");
 		goto err_free_mem;
diff --git a/drivers/media/usb/pwc/pwc-uncompress.c b/drivers/media/usb/pwc/pwc-uncompress.c
index 58b5518..425b508 100644
--- a/drivers/media/usb/pwc/pwc-uncompress.c
+++ b/drivers/media/usb/pwc/pwc-uncompress.c
@@ -55,12 +55,12 @@ int pwc_decompress(struct pwc_device *pdev, struct pwc_frame_buf *fbuf)
 			 * determine this using the type of the webcam */
 		memcpy(raw_frame->cmd, pdev->cmd_buf, 4);
 		memcpy(raw_frame+1, yuv, pdev->frame_size);
-		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
+		vb2_v4l2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
 				      pdev->frame_size + sizeof(struct pwc_raw_frame));
 		return 0;
 	}
 
-	vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
+	vb2_v4l2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
 			      pdev->width * pdev->height * 3 / 2);
 
 	if (pdev->vbandlength == 0) {
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 0d909a4..5bda74f 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -636,7 +636,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 			break;
 		case V4L2_PIX_FMT_JPEG:
 		case V4L2_PIX_FMT_MJPEG:
-			vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+			vb2_v4l2_set_plane_payload(&buf->vb.vb2_buf, 0,
 					      jpgsize);
 			memcpy(vbuf, tmpbuf, jpgsize);
 			break;
@@ -692,12 +692,12 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	size = w * h * (vc->fmt->depth >> 3);
-	if (vb2_plane_size(vb, 0) < size) {
+	if (vb2_v4l2_plane_size(vb, 0) < size) {
 		dprintk(vc->dev, 4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, size);
+	vb2_v4l2_set_plane_payload(vb, 0, size);
 	return 0;
 }
 
@@ -1664,10 +1664,10 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->ops = &s2255_video_qops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-		ret = vb2_queue_init(q);
+		ret = vb2_v4l2_queue_init(q);
 		if (ret != 0) {
 			dev_err(&dev->udev->dev,
-				"%s vb2_queue_init 0x%x\n", __func__, ret);
+				"%s vb2_v4l2_queue_init 0x%x\n", __func__, ret);
 			break;
 		}
 		/* register video devices */
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a7daa08..abcd14b 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -709,7 +709,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	} else {
 
 		buf->mem = vb2_plane_vaddr(vb, 0);
-		buf->length = vb2_plane_size(vb, 0);
+		buf->length = vb2_v4l2_plane_size(vb, 0);
 		buf->bytesused = 0;
 		buf->pos = 0;
 
@@ -801,7 +801,7 @@ int stk1160_vb2_setup(struct stk1160 *dev)
 	q->mem_ops = &vb2_vmalloc_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
-	rc = vb2_queue_init(q);
+	rc = vb2_v4l2_queue_init(q);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index ff1f327..fc705b6 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -101,7 +101,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	buf->vb.v4l2_buf.bytesused = buf->bytesused;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
-	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->bytesused);
+	vb2_v4l2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 	dev->isoc_ctl.buf = NULL;
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3e17802..1f75dcc 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -314,7 +314,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 	/* Last chunk in a frame, signalling an end */
 	if (odd && chunk_no == usbtv->n_chunks-1) {
-		int size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+		int size = vb2_v4l2_plane_size(&buf->vb.vb2_buf, 0);
 		enum vb2_buffer_state state = usbtv->chunks_done ==
 						usbtv->n_chunks ?
 						VB2_BUF_STATE_DONE :
@@ -323,7 +323,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 		buf->vb.v4l2_buf.sequence = usbtv->sequence++;
 		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-		vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+		vb2_v4l2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
 	}
@@ -664,7 +664,7 @@ static void usbtv_release(struct v4l2_device *v4l2_dev)
 	struct usbtv *usbtv = container_of(v4l2_dev, struct usbtv, v4l2_dev);
 
 	v4l2_device_unregister(&usbtv->v4l2_dev);
-	vb2_queue_release(&usbtv->vb2q);
+	vb2_v4l2_queue_release(&usbtv->vb2q);
 	kfree(usbtv);
 }
 
@@ -688,7 +688,7 @@ int usbtv_video_init(struct usbtv *usbtv)
 	usbtv->vb2q.mem_ops = &vb2_vmalloc_memops;
 	usbtv->vb2q.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	usbtv->vb2q.lock = &usbtv->vb2q_lock;
-	ret = vb2_queue_init(&usbtv->vb2q);
+	ret = vb2_v4l2_queue_init(&usbtv->vb2q);
 	if (ret < 0) {
 		dev_warn(usbtv->dev, "Could not initialize videobuf2 queue\n");
 		return ret;
@@ -723,7 +723,7 @@ int usbtv_video_init(struct usbtv *usbtv)
 vdev_fail:
 	v4l2_device_unregister(&usbtv->v4l2_dev);
 v4l2_fail:
-	vb2_queue_release(&usbtv->vb2q);
+	vb2_v4l2_queue_release(&usbtv->vb2q);
 
 	return ret;
 }
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 2905123..ed96374 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -95,7 +95,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
 	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+	    vb2_v4l2_get_plane_payload(vb, 0) > vb2_v4l2_plane_size(vb, 0)) {
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
 		return -EINVAL;
 	}
@@ -106,11 +106,11 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	buf->state = UVC_BUF_STATE_QUEUED;
 	buf->error = 0;
 	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
+	buf->length = vb2_v4l2_plane_size(vb, 0);
 	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
-		buf->bytesused = vb2_get_plane_payload(vb, 0);
+		buf->bytesused = vb2_v4l2_get_plane_payload(vb, 0);
 
 	return 0;
 }
@@ -205,7 +205,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
 		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
 	queue->queue.lock = &queue->mutex;
-	ret = vb2_queue_init(&queue->queue);
+	ret = vb2_v4l2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
 
@@ -220,7 +220,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 void uvc_queue_release(struct uvc_video_queue *queue)
 {
 	mutex_lock(&queue->mutex);
-	vb2_queue_release(&queue->queue);
+	vb2_v4l2_queue_release(&queue->queue);
 	mutex_unlock(&queue->mutex);
 }
 
@@ -234,7 +234,7 @@ int uvc_request_buffers(struct uvc_video_queue *queue,
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_reqbufs(&queue->queue, rb);
+	ret = vb2_v4l2_reqbufs(&queue->queue, rb);
 	mutex_unlock(&queue->mutex);
 
 	return ret ? ret : rb->count;
@@ -245,7 +245,7 @@ int uvc_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_querybuf(&queue->queue, buf);
+	ret = vb2_v4l2_querybuf(&queue->queue, buf);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -257,7 +257,7 @@ int uvc_create_buffers(struct uvc_video_queue *queue,
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_create_bufs(&queue->queue, cb);
+	ret = vb2_v4l2_create_bufs(&queue->queue, cb);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -268,7 +268,7 @@ int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_qbuf(&queue->queue, buf);
+	ret = vb2_v4l2_qbuf(&queue->queue, buf);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -280,7 +280,7 @@ int uvc_export_buffer(struct uvc_video_queue *queue,
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_expbuf(&queue->queue, exp);
+	ret = vb2_v4l2_expbuf(&queue->queue, exp);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -292,7 +292,7 @@ int uvc_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_dqbuf(&queue->queue, buf, nonblocking);
+	ret = vb2_v4l2_dqbuf(&queue->queue, buf, nonblocking);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -303,7 +303,7 @@ int uvc_queue_streamon(struct uvc_video_queue *queue, enum v4l2_buf_type type)
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_streamon(&queue->queue, type);
+	ret = vb2_v4l2_streamon(&queue->queue, type);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -314,7 +314,7 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type)
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_streamoff(&queue->queue, type);
+	ret = vb2_v4l2_streamoff(&queue->queue, type);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -339,7 +339,7 @@ unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
 	unsigned int ret;
 
 	mutex_lock(&queue->mutex);
-	ret = vb2_poll(&queue->queue, file, wait);
+	ret = vb2_v4l2_poll(&queue->queue, file, wait);
 	mutex_unlock(&queue->mutex);
 
 	return ret;
@@ -402,7 +402,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		buf->error = 0;
 		buf->state = UVC_BUF_STATE_QUEUED;
 		buf->bytesused = 0;
-		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+		vb2_v4l2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
 		return buf;
 	}
 
@@ -416,7 +416,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
-	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
+	vb2_v4l2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 8ea5de6..9e7434d 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -360,7 +360,7 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
-	ret = vb2_reqbufs(vq, reqbufs);
+	ret = vb2_v4l2_reqbufs(vq, reqbufs);
 	/* If count == 0, then the owner has released all buffers and he
 	   is no longer owner of the queue. Otherwise we have an owner. */
 	if (ret == 0)
@@ -383,7 +383,7 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	unsigned int i;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_querybuf(vq, buf);
+	ret = vb2_v4l2_querybuf(vq, buf);
 
 	/* Adjust MMAP memory offsets for the CAPTURE queue */
 	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
@@ -411,7 +411,7 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_qbuf(vq, buf);
+	ret = vb2_v4l2_qbuf(vq, buf);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
@@ -429,7 +429,7 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	return vb2_v4l2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -444,7 +444,7 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_prepare_buf(vq, buf);
+	ret = vb2_v4l2_prepare_buf(vq, buf);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
@@ -462,7 +462,7 @@ int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, create->format.type);
-	return vb2_create_bufs(vq, create);
+	return vb2_v4l2_create_bufs(vq, create);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_create_bufs);
 
@@ -476,7 +476,7 @@ int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, eb->type);
-	return vb2_expbuf(vq, eb);
+	return vb2_v4l2_expbuf(vq, eb);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_expbuf);
 /**
@@ -489,7 +489,7 @@ int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, type);
-	ret = vb2_streamon(vq, type);
+	ret = vb2_v4l2_streamon(vq, type);
 	if (!ret)
 		v4l2_m2m_try_schedule(m2m_ctx);
 
@@ -512,7 +512,7 @@ int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	v4l2_m2m_cancel_job(m2m_ctx);
 
 	q_ctx = get_queue_ctx(m2m_ctx, type);
-	ret = vb2_streamoff(&q_ctx->q, type);
+	ret = vb2_v4l2_streamoff(&q_ctx->q, type);
 	if (ret)
 		return ret;
 
@@ -761,8 +761,8 @@ void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 	/* wait until the current context is dequeued from job_queue */
 	v4l2_m2m_cancel_job(m2m_ctx);
 
-	vb2_queue_release(&m2m_ctx->cap_q_ctx.q);
-	vb2_queue_release(&m2m_ctx->out_q_ctx.q);
+	vb2_v4l2_queue_release(&m2m_ctx->cap_q_ctx.q);
+	vb2_v4l2_queue_release(&m2m_ctx->out_q_ctx.q);
 
 	kfree(m2m_ctx);
 }
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7888338..38632ea 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -432,7 +432,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
 }
 
 /**
- * vb2_core_querybuf() - query video buffer information
+ * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
  * @type:	enum vb2_buf_type; buffer type (type == *_MPLANE for
  *		multiplanar buffers);
@@ -447,7 +447,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
  * The return values from this function are intended to be directly returned
  * from vidioc_querybuf handler in driver.
  */
-int vb2_core_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
+int vb2_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
 		unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
@@ -469,7 +469,7 @@ int vb2_core_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vb2_core_querybuf);
+EXPORT_SYMBOL_GPL(vb2_querybuf);
 
 /**
  * __verify_userptr_ops() - verify that all memory operations required for
@@ -562,7 +562,7 @@ int __verify_memory_type(struct vb2_queue *q,
 EXPORT_SYMBOL_GPL(__verify_memory_type);
 
 /**
- * vb2_core_reqbufs() - Initiate streaming
+ * vb2_reqbufs() - Initiate streaming
  * @q:		videobuf2 queue
  * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
  *
@@ -578,13 +578,13 @@ EXPORT_SYMBOL_GPL(__verify_memory_type);
  *    memory handling/allocation routines provided during queue initialization
  *
  * If req->count is 0, all the memory will be freed instead.
- * If the queue has been allocated previously (by a previous vb2_reqbufs) call
+ * If the queue has been allocated previously (by a previous vb2_v4l2_reqbufs) call
  * and the queue is not busy, memory will be reallocated.
  *
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
@@ -699,10 +699,10 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
+EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
- * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
+ * vb2_create_bufs() - Allocate buffers and any required auxiliary structs
  * @q:		videobuf2 queue
  * @create:	creation parameters, passed from userspace to vidioc_create_bufs
  *		handler in driver
@@ -716,7 +716,7 @@ EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
  * The return values from this function are intended to be directly returned
  * from vidioc_create_bufs handler in driver.
  */
-int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, void *parg)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
@@ -797,7 +797,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
+EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
@@ -979,7 +979,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
 }
 
 /**
- * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_prepare_buf
  *		handler in driver
@@ -993,7 +993,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
  * The return values from this function are intended to be directly returned
  * from vidioc_prepare_buf handler in driver.
  */
-int vb2_core_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
 		enum vb2_buf_type type, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
@@ -1025,7 +1025,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
+EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
 /**
  * vb2_start_streaming() - Attempt to start streaming.
@@ -1090,7 +1090,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_qbuf(struct vb2_queue *q, enum vb2_memory memory,
 		enum vb2_buf_type type, unsigned int index, void *pb)
 {
 	int ret = vb2_queue_or_prepare_buf(q, memory, type, index, pb, "qbuf");
@@ -1161,7 +1161,7 @@ int vb2_core_qbuf(struct vb2_queue *q, enum vb2_memory memory,
 	VB2_DEBUG(1, "qbuf of buffer %d succeeded\n", vb2_index(vb));
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_qbuf);
+EXPORT_SYMBOL_GPL(vb2_qbuf);
 
 /**
  * __vb2_wait_for_done_vb() - wait for a buffer to become available
@@ -1299,9 +1299,9 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
 EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 
 /**
- * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
+ * __vb2_v4l2_dqbuf() - bring back the buffer to the DEQUEUED state
  */
-static void __vb2_dqbuf(struct vb2_buffer *vb)
+static void __vb2_v4l2_dqbuf(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int i;
@@ -1322,7 +1322,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 		}
 }
 
-int vb2_core_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb,
+int vb2_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb,
 		bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
@@ -1361,14 +1361,14 @@ int vb2_core_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb,
 	if (!VB2_TYPE_IS_OUTPUT(q->vb2_type) && call_bufop(q, is_last, vb))
 		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
-	__vb2_dqbuf(vb);
+	__vb2_v4l2_dqbuf(vb);
 
 	VB2_DEBUG(1, "dqbuf of buffer %d, with state %d\n",
 			vb2_index(vb), vb->state);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
+EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 /**
  * __vb2_queue_cancel() - cancel and stop (pause) streaming
@@ -1423,9 +1423,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * Make sure to call buf_finish for any queued buffers. Normally
 	 * that's done in dqbuf, but that's not going to happen when we
 	 * cancel the whole queue. Note: this code belongs here, not in
-	 * __vb2_dqbuf() since in vb2_internal_dqbuf() there is a critical
+	 * __vb2_v4l2_dqbuf() since in vb2_internal_dqbuf() there is a critical
 	 * call to __fill_v4l2_buffer() after buf_finish(). That order can't
-	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
+	 * be changed, so we can't move the buf_finish() to __vb2_v4l2_dqbuf().
 	 */
 	for (i = 0; i < q->num_buffers; ++i) {
 		struct vb2_buffer *vb = q->bufs[i];
@@ -1434,11 +1434,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 			vb->state = VB2_BUF_STATE_PREPARED;
 			call_void_vb_qop(vb, buf_finish, vb);
 		}
-		__vb2_dqbuf(vb);
+		__vb2_v4l2_dqbuf(vb);
 	}
 }
 
-int vb2_core_streamon(struct vb2_queue *q, enum vb2_buf_type type)
+int vb2_streamon(struct vb2_queue *q, enum vb2_buf_type type)
 {
 	int ret;
 
@@ -1480,7 +1480,7 @@ int vb2_core_streamon(struct vb2_queue *q, enum vb2_buf_type type)
 	VB2_DEBUG(3, "successful\n");
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_streamon);
+EXPORT_SYMBOL_GPL(vb2_streamon);
 
 /**
  * vb2_queue_error() - signal a fatal error on the queue
@@ -1491,7 +1491,7 @@ EXPORT_SYMBOL_GPL(vb2_core_streamon);
  * buffers will return -EIO.
  *
  * The error flag will be cleared when cancelling the queue, either from
- * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
+ * vb2_v4l2_streamoff or vb2_v4l2_queue_release. Drivers should thus not call this
  * function before starting the stream, otherwise the error flag will remain set
  * until the queue is released when closing the device node.
  */
@@ -1503,7 +1503,7 @@ void vb2_queue_error(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_error);
 
-int vb2_core_streamoff(struct vb2_queue *q, enum vb2_buf_type type)
+int vb2_streamoff(struct vb2_queue *q, enum vb2_buf_type type)
 {
 	if (type != q->vb2_type) {
 		VB2_DEBUG(1, "invalid stream type\n");
@@ -1526,7 +1526,7 @@ int vb2_core_streamoff(struct vb2_queue *q, enum vb2_buf_type type)
 	VB2_DEBUG(3, "successful\n");
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_streamoff);
+EXPORT_SYMBOL_GPL(vb2_streamoff);
 
 /**
  * __find_plane_by_offset() - find plane associated with the given offset off
@@ -1558,7 +1558,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 }
 
 /**
- * vb2_core_expbuf() - Export a buffer as a file descriptor
+ * vb2_expbuf() - Export a buffer as a file descriptor
  * @q:		videobuf2 queue
  * @eb:		export buffer structure passed from userspace to vidioc_expbuf
  *		handler in driver
@@ -1566,7 +1566,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
  * The return values from this function are intended to be directly returned
  * from vidioc_expbuf handler in driver.
  */
-int vb2_core_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int index,
+int vb2_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int index,
 		unsigned int plane, unsigned int flags)
 {
 	struct vb2_buffer *vb = NULL;
@@ -1632,7 +1632,7 @@ int vb2_core_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int in
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vb2_core_expbuf);
+EXPORT_SYMBOL_GPL(vb2_expbuf);
 
 /**
  * vb2_mmap() - map video buffers into application address space
@@ -1755,7 +1755,7 @@ EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
 
 /**
- * vb2_core_queue_init() - initialize a videobuf2 queue
+ * vb2_queue_init() - initialize a videobuf2 queue
  * @q:		videobuf2 queue; this structure should be allocated in driver
  *
  * The vb2_queue structure should be allocated by the driver. The driver is
@@ -1765,7 +1765,7 @@ EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
  * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
  * for more information.
  */
-int vb2_core_queue_init(struct vb2_queue *q)
+int vb2_queue_init(struct vb2_queue *q)
 {
 	/*
 	 * Sanity check
@@ -1788,24 +1788,24 @@ int vb2_core_queue_init(struct vb2_queue *q)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_core_queue_init);
+EXPORT_SYMBOL_GPL(vb2_queue_init);
 
 /**
- * vb2_core_queue_release() - stop streaming, release the queue and free memory
+ * vb2_queue_release() - stop streaming, release the queue and free memory
  * @q:		videobuf2 queue
  *
  * This function stops streaming and performs necessary clean ups, including
  * freeing video buffer memory. The driver is responsible for freeing
  * the vb2_queue structure itself.
  */
-void vb2_core_queue_release(struct vb2_queue *q)
+void vb2_queue_release(struct vb2_queue *q)
 {
 	__vb2_queue_cancel(q);
 	mutex_lock(&q->mmap_lock);
 	__vb2_queue_free(q, q->num_buffers);
 	mutex_unlock(&q->mmap_lock);
 }
-EXPORT_SYMBOL_GPL(vb2_core_queue_release);
+EXPORT_SYMBOL_GPL(vb2_queue_release);
 
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
diff --git a/drivers/media/v4l2-core/videobuf2-dvb.c b/drivers/media/v4l2-core/videobuf2-dvb.c
index d092698..9c18843 100644
--- a/drivers/media/v4l2-core/videobuf2-dvb.c
+++ b/drivers/media/v4l2-core/videobuf2-dvb.c
@@ -32,7 +32,7 @@ static int dvb_fnc(struct vb2_buffer *vb, void *priv)
 	struct vb2_dvb *dvb = priv;
 
 	dvb_dmx_swfilter(&dvb->demux, vb2_plane_vaddr(vb, 0),
-				      vb2_get_plane_payload(vb, 0));
+				      vb2_v4l2_get_plane_payload(vb, 0));
 	return 0;
 }
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 22dd19c..939d554 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -795,7 +795,7 @@ const struct vb2_trace_ops vb2_v4l2_trace_ops = {
 };
 
 /**
- * vb2_querybuf() - query video buffer information
+ * vb2_v4l2_querybuf() - query video buffer information
  * @q:		videobuf queue
  * @b:		buffer struct passed from userspace to vidioc_querybuf handler
  *		in driver
@@ -807,35 +807,35 @@ const struct vb2_trace_ops vb2_v4l2_trace_ops = {
  * The return values from this function are intended to be directly returned
  * from vidioc_querybuf handler in driver.
  */
-int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_v4l2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	return vb2_core_querybuf(q, to_vb2_buf_type(b->type), b->index, b);
+	return vb2_querybuf(q, to_vb2_buf_type(b->type), b->index, b);
 }
-EXPORT_SYMBOL(vb2_querybuf);
+EXPORT_SYMBOL(vb2_v4l2_querybuf);
 
 /**
- * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
+ * vb2_v4l2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
  * type values.
  * @q:		videobuf2 queue
  * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
  */
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+int vb2_v4l2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	int ret = __verify_memory_type(q, to_vb2_memory(req->memory),
 			to_vb2_buf_type(req->type));
 	q->memory = req->memory;
-	return ret ? ret : vb2_core_reqbufs(q, to_vb2_memory(req->memory), &req->count);
+	return ret ? ret : vb2_reqbufs(q, to_vb2_memory(req->memory), &req->count);
 }
-EXPORT_SYMBOL_GPL(vb2_reqbufs);
+EXPORT_SYMBOL_GPL(vb2_v4l2_reqbufs);
 
 /**
- * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
+ * vb2_v4l2_create_bufs() - Wrapper for __create_bufs() that also verifies the
  * memory and type values.
  * @q:		videobuf2 queue
  * @create:	creation parameters, passed from userspace to vidioc_create_bufs
  *		handler in driver
  */
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb)
+int vb2_v4l2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb)
 {
 	int ret = __verify_memory_type(q, to_vb2_memory(cb->memory),
 			to_vb2_buf_type(cb->format.type));
@@ -844,12 +844,12 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb)
 	if (cb->count == 0)
 		return ret != -EBUSY ? ret : 0;
 	q->memory = cb->memory;
-	return ret ? ret : vb2_core_create_bufs(q, to_vb2_memory(cb->memory), &cb->count, &cb->format);
+	return ret ? ret : vb2_create_bufs(q, to_vb2_memory(cb->memory), &cb->count, &cb->format);
 }
-EXPORT_SYMBOL_GPL(vb2_create_bufs);
+EXPORT_SYMBOL_GPL(vb2_v4l2_create_bufs);
 
 /**
- * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
+ * vb2_v4l2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_prepare_buf
  *		handler in driver
@@ -863,14 +863,14 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
  * The return values from this function are intended to be directly returned
  * from vidioc_prepare_buf handler in driver.
  */
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_v4l2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	return vb2_core_prepare_buf(q, to_vb2_memory(b->memory), to_vb2_buf_type(b->type), b->index, b);
+	return vb2_prepare_buf(q, to_vb2_memory(b->memory), to_vb2_buf_type(b->type), b->index, b);
 }
-EXPORT_SYMBOL_GPL(vb2_prepare_buf);
+EXPORT_SYMBOL_GPL(vb2_v4l2_prepare_buf);
 
 /**
- * vb2_qbuf() - Queue a buffer from userspace
+ * vb2_v4l2_qbuf() - Queue a buffer from userspace
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_qbuf handler
  *		in driver
@@ -886,19 +886,19 @@ EXPORT_SYMBOL_GPL(vb2_prepare_buf);
  * The return values from this function are intended to be directly returned
  * from vidioc_qbuf handler in driver.
  */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_v4l2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
 	if (vb2_fileio_is_active(q)) {
 		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
 
-	return vb2_core_qbuf(q, to_vb2_memory(b->memory), to_vb2_buf_type(b->type), b->index, b);
+	return vb2_qbuf(q, to_vb2_memory(b->memory), to_vb2_buf_type(b->type), b->index, b);
 }
-EXPORT_SYMBOL_GPL(vb2_qbuf);
+EXPORT_SYMBOL_GPL(vb2_v4l2_qbuf);
 
 /**
- * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * vb2_v4l2_dqbuf() - Dequeue a buffer to the userspace
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
  *		in driver
@@ -918,18 +918,18 @@ EXPORT_SYMBOL_GPL(vb2_qbuf);
  * The return values from this function are intended to be directly returned
  * from vidioc_dqbuf handler in driver.
  */
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+int vb2_v4l2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	if (vb2_fileio_is_active(q)) {
 		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_core_dqbuf(q, to_vb2_buf_type(b->type), b, nonblocking);
+	return vb2_dqbuf(q, to_vb2_buf_type(b->type), b, nonblocking);
 }
-EXPORT_SYMBOL_GPL(vb2_dqbuf);
+EXPORT_SYMBOL_GPL(vb2_v4l2_dqbuf);
 
 /**
- * vb2_expbuf() - Export a buffer as a file descriptor
+ * vb2_v4l2_expbuf() - Export a buffer as a file descriptor
  * @q:		videobuf2 queue
  * @eb:		export buffer structure passed from userspace to vidioc_expbuf
  *		handler in driver
@@ -937,16 +937,16 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
  * The return values from this function are intended to be directly returned
  * from vidioc_expbuf handler in driver.
  */
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
+int vb2_v4l2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
-	eb->fd = vb2_core_expbuf(q, to_vb2_buf_type(eb->type), eb->index, eb->plane, eb->flags);
+	eb->fd = vb2_expbuf(q, to_vb2_buf_type(eb->type), eb->index, eb->plane, eb->flags);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_expbuf);
+EXPORT_SYMBOL_GPL(vb2_v4l2_expbuf);
 
 /**
- * vb2_streamon - start streaming
+ * vb2_v4l2_streamon - start streaming
  * @q:		videobuf2 queue
  * @type:	type argument passed from userspace to vidioc_streamon handler
  *
@@ -958,19 +958,19 @@ EXPORT_SYMBOL_GPL(vb2_expbuf);
  * The return values from this function are intended to be directly returned
  * from vidioc_streamon handler in the driver.
  */
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+int vb2_v4l2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
 		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
 
-	return vb2_core_streamon(q, to_vb2_buf_type(type));
+	return vb2_streamon(q, to_vb2_buf_type(type));
 }
-EXPORT_SYMBOL_GPL(vb2_streamon);
+EXPORT_SYMBOL_GPL(vb2_v4l2_streamon);
 
 /**
- * vb2_streamoff - stop streaming
+ * vb2_v4l2_streamoff - stop streaming
  * @q:		videobuf2 queue
  * @type:	type argument passed from userspace to vidioc_streamoff handler
  *
@@ -984,21 +984,21 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
  * The return values from this function are intended to be directly returned
  * from vidioc_streamoff handler in the driver
  */
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+int vb2_v4l2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	if (vb2_fileio_is_active(q)) {
 		VB2_DEBUG(1, "file io in progress\n");
 		return -EBUSY;
 	}
-	return vb2_core_streamoff(q, to_vb2_buf_type(type));
+	return vb2_streamoff(q, to_vb2_buf_type(type));
 }
-EXPORT_SYMBOL_GPL(vb2_streamoff);
+EXPORT_SYMBOL_GPL(vb2_v4l2_streamoff);
 
 static int __vb2_init_fileio(struct vb2_queue *q, int read);
 static int __vb2_cleanup_fileio(struct vb2_queue *q);
 
 /**
- * vb2_poll() - implements poll userspace operation
+ * vb2_v4l2_poll() - implements poll userspace operation
  * @q:		videobuf2 queue
  * @file:	file argument passed to the poll file operation handler
  * @wait:	wait argument passed to the poll file operation handler
@@ -1010,13 +1010,13 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
  * will be reported as available for writing.
  *
- * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
+ * If the driver uses struct v4l2_fh, then vb2_v4l2_poll() will also check for any
  * pending events.
  *
  * The return values from this function are intended to be directly returned
  * from poll handler in driver.
  */
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
+unsigned int vb2_v4l2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
 	struct video_device *vfd = video_devdata(file);
 	unsigned long req_events = poll_requested_events(wait);
@@ -1107,10 +1107,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 	return res;
 }
-EXPORT_SYMBOL_GPL(vb2_poll);
+EXPORT_SYMBOL_GPL(vb2_v4l2_poll);
 
 /**
- * vb2_queue_init() - initialize a videobuf2 queue
+ * vb2_v4l2_queue_init() - initialize a videobuf2 queue
  * @q:		videobuf2 queue; this structure should be allocated in driver
  *
  * The vb2_queue structure should be allocated by the driver. The driver is
@@ -1120,7 +1120,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
-int vb2_queue_init(struct vb2_queue *q)
+int vb2_v4l2_queue_init(struct vb2_queue *q)
 {
 	/*
 	 * Sanity check
@@ -1144,24 +1144,24 @@ int vb2_queue_init(struct vb2_queue *q)
 	q->trace_ops = &vb2_v4l2_trace_ops;
 	q->vb2_type = to_vb2_buf_type(q->type);
 
-	return vb2_core_queue_init(q);
+	return vb2_queue_init(q);
 }
-EXPORT_SYMBOL_GPL(vb2_queue_init);
+EXPORT_SYMBOL_GPL(vb2_v4l2_queue_init);
 
 /**
- * vb2_queue_release() - stop streaming, release the queue and free memory
+ * vb2_v4l2_queue_release() - stop streaming, release the queue and free memory
  * @q:		videobuf2 queue
  *
  * This function stops streaming and performs necessary clean ups, including
  * freeing video buffer memory. The driver is responsible for freeing
  * the vb2_queue structure itself.
  */
-void vb2_queue_release(struct vb2_queue *q)
+void vb2_v4l2_queue_release(struct vb2_queue *q)
 {
 	__vb2_cleanup_fileio(q);
-	vb2_core_queue_release(q);
+	vb2_queue_release(q);
 }
-EXPORT_SYMBOL_GPL(vb2_queue_release);
+EXPORT_SYMBOL_GPL(vb2_v4l2_queue_release);
 
 /**
  * struct vb2_fileio_buf - buffer context used by file io emulator
@@ -1268,7 +1268,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	fileio->req.memory = q->memory = V4L2_MEMORY_MMAP;
 	fileio->req.type = q->type;
 	q->fileio = fileio;
-	ret = vb2_core_reqbufs(q, to_vb2_memory(fileio->req.memory), &fileio->req.count);
+	ret = vb2_reqbufs(q, to_vb2_memory(fileio->req.memory), &fileio->req.count);
 	if (ret)
 		goto err_kfree;
 
@@ -1290,7 +1290,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			ret = -EINVAL;
 			goto err_reqbufs;
 		}
-		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
+		fileio->bufs[i].size = vb2_v4l2_plane_size(q->bufs[i], 0);
 	}
 
 	/*
@@ -1314,7 +1314,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 			}
 			b->memory = q->memory;
 			b->index = i;
-			ret = vb2_core_qbuf(q, q->vb2_memory, q->vb2_type, i, b);
+			ret = vb2_qbuf(q, q->vb2_memory, q->vb2_type, i, b);
 			if (ret)
 				goto err_reqbufs;
 			fileio->bufs[i].queued = 1;
@@ -1330,7 +1330,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Start streaming.
 	 */
-	ret = vb2_core_streamon(q, q->vb2_type);
+	ret = vb2_streamon(q, q->vb2_type);
 	if (ret)
 		goto err_reqbufs;
 
@@ -1338,7 +1338,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 
 err_reqbufs:
 	fileio->req.count = 0;
-	vb2_core_reqbufs(q, to_vb2_memory(fileio->req.memory), &fileio->req.count);
+	vb2_reqbufs(q, to_vb2_memory(fileio->req.memory), &fileio->req.count);
 
 err_kfree:
 	q->fileio = NULL;
@@ -1355,10 +1355,10 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
 	struct vb2_fileio_data *fileio = q->fileio;
 
 	if (fileio) {
-		vb2_core_streamoff(q, q->vb2_type);
+		vb2_streamoff(q, q->vb2_type);
 		q->fileio = NULL;
 		fileio->req.count = 0;
-		vb2_reqbufs(q, &fileio->req);
+		vb2_v4l2_reqbufs(q, &fileio->req);
 		kfree(fileio);
 		VB2_DEBUG(3, "file io emulator closed\n");
 	}
@@ -1414,7 +1414,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	index = fileio->cur_index;
 	if (index >= q->num_buffers) {
 		/*
-		 * Call vb2_dqbuf to get buffer back.
+		 * Call vb2_v4l2_dqbuf to get buffer back.
 		 */
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
@@ -1424,8 +1424,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			fileio->b.m.planes = &fileio->p;
 			fileio->b.length = 1;
 		}
-		ret = vb2_core_dqbuf(q, q->vb2_type, &fileio->b, nonblock);
-		VB2_DEBUG(5, "vb2_dqbuf result: %d\n", ret);
+		ret = vb2_dqbuf(q, q->vb2_type, &fileio->b, nonblock);
+		VB2_DEBUG(5, "vb2_v4l2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
 		fileio->dq_count += 1;
@@ -1438,8 +1438,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 */
 		buf->pos = 0;
 		buf->queued = 0;
-		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
-				 : vb2_plane_size(q->bufs[index], 0);
+		buf->size = read ? vb2_v4l2_get_plane_payload(q->bufs[index], 0)
+				 : vb2_v4l2_plane_size(q->bufs[index], 0);
 		/* Compensate for data_offset on read in the multiplanar case. */
 		if (is_multiplanar && read &&
 		    fileio->b.m.planes[0].data_offset < buf->size) {
@@ -1491,7 +1491,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		}
 
 		/*
-		 * Call vb2_qbuf and give buffer to the driver.
+		 * Call vb2_v4l2_qbuf and give buffer to the driver.
 		 */
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
@@ -1506,7 +1506,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		}
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_core_qbuf(q, q->vb2_memory, q->vb2_type, index,
+		ret = vb2_qbuf(q, q->vb2_memory, q->vb2_type, index,
 				&fileio->b);
 		VB2_DEBUG(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
@@ -1517,7 +1517,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 */
 		buf->pos = 0;
 		buf->queued = 1;
-		buf->size = vb2_plane_size(q->bufs[index], 0);
+		buf->size = vb2_v4l2_plane_size(q->bufs[index], 0);
 		fileio->q_count += 1;
 		/*
 		 * If we are queuing up buffers for the first time, then
@@ -1543,20 +1543,20 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	return ret;
 }
 
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+size_t vb2_v4l2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblocking)
 {
 	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
 }
-EXPORT_SYMBOL_GPL(vb2_read);
+EXPORT_SYMBOL_GPL(vb2_v4l2_read);
 
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+size_t vb2_v4l2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblocking)
 {
 	return __vb2_perform_fileio(q, (char __user *) data, count,
 							ppos, nonblocking, 0);
 }
-EXPORT_SYMBOL_GPL(vb2_write);
+EXPORT_SYMBOL_GPL(vb2_v4l2_write);
 
 struct vb2_threadio_data {
 	struct task_struct *thread;
@@ -1588,7 +1588,7 @@ static int vb2_thread(void *data)
 		struct vb2_buffer *vb;
 
 		/*
-		 * Call vb2_dqbuf to get buffer back.
+		 * Call vb2_v4l2_dqbuf to get buffer back.
 		 */
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
@@ -1599,9 +1599,9 @@ static int vb2_thread(void *data)
 		} else {
 			call_void_qop(q, wait_finish, q);
 			if (!threadio->stop)
-				ret = vb2_core_dqbuf(q, q->vb2_type, &fileio->b, 0);
+				ret = vb2_dqbuf(q, q->vb2_type, &fileio->b, 0);
 			call_void_qop(q, wait_prepare, q);
-			VB2_DEBUG(5, "file io: vb2_dqbuf result: %d\n", ret);
+			VB2_DEBUG(5, "file io: vb2_v4l2_dqbuf result: %d\n", ret);
 		}
 		if (ret || threadio->stop)
 			break;
@@ -1615,7 +1615,7 @@ static int vb2_thread(void *data)
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
 		if (!threadio->stop)
-			ret = vb2_core_qbuf(q, q->vb2_memory,
+			ret = vb2_qbuf(q, q->vb2_memory,
 				q->vb2_type, fileio->b.index, &fileio->b);
 		call_void_qop(q, wait_prepare, q);
 		if (ret || threadio->stop)
@@ -1722,7 +1722,7 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
 	vdev->queue->memory = p->memory;
-	res = vb2_core_reqbufs(vdev->queue, to_vb2_memory(p->memory), &p->count);
+	res = vb2_reqbufs(vdev->queue, to_vb2_memory(p->memory), &p->count);
 	/* If count == 0, then the owner has released all buffers and he
 	   is no longer owner of the queue. Otherwise we have a new owner. */
 	if (res == 0)
@@ -1748,7 +1748,7 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
 	vdev->queue->memory = p->memory;
-	res = vb2_core_create_bufs(vdev->queue, to_vb2_memory(p->memory),
+	res = vb2_create_bufs(vdev->queue, to_vb2_memory(p->memory),
 			&p->count, &p->format);
 	if (res == 0)
 		vdev->queue->owner = file->private_data;
@@ -1763,7 +1763,7 @@ int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_core_prepare_buf(vdev->queue, to_vb2_memory(p->memory),
+	return vb2_prepare_buf(vdev->queue, to_vb2_memory(p->memory),
 			to_vb2_buf_type(p->type), p->index, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
@@ -1773,7 +1773,7 @@ int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	struct video_device *vdev = video_devdata(file);
 
 	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
-	return vb2_querybuf(vdev->queue, p);
+	return vb2_v4l2_querybuf(vdev->queue, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
 
@@ -1783,7 +1783,7 @@ int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_qbuf(vdev->queue, p);
+	return vb2_v4l2_qbuf(vdev->queue, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
 
@@ -1793,7 +1793,7 @@ int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
+	return vb2_v4l2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
 
@@ -1803,7 +1803,7 @@ int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_streamon(vdev->queue, to_vb2_buf_type(type));
+	return vb2_v4l2_streamon(vdev->queue, to_vb2_buf_type(type));
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
 
@@ -1813,7 +1813,7 @@ int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_streamoff(vdev->queue, to_vb2_buf_type(type));
+	return vb2_v4l2_streamoff(vdev->queue, to_vb2_buf_type(type));
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
 
@@ -1823,7 +1823,7 @@ int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
 
 	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	return vb2_expbuf(vdev->queue, p);
+	return vb2_v4l2_expbuf(vdev->queue, p);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
 
@@ -1844,7 +1844,7 @@ int _vb2_fop_release(struct file *file, struct mutex *lock)
 	if (lock)
 		mutex_lock(lock);
 	if (file->private_data == vdev->queue->owner) {
-		vb2_queue_release(vdev->queue);
+		vb2_v4l2_queue_release(vdev->queue);
 		vdev->queue->owner = NULL;
 	}
 	if (lock)
@@ -1875,7 +1875,7 @@ ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 		return -ERESTARTSYS;
 	if (vb2_queue_is_busy(vdev, file))
 		goto exit;
-	err = vb2_write(vdev->queue, buf, count, ppos,
+	err = vb2_v4l2_write(vdev->queue, buf, count, ppos,
 		       file->f_flags & O_NONBLOCK);
 	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
@@ -1899,7 +1899,7 @@ ssize_t vb2_fop_read(struct file *file, char __user *buf,
 		return -ERESTARTSYS;
 	if (vb2_queue_is_busy(vdev, file))
 		goto exit;
-	err = vb2_read(vdev->queue, buf, count, ppos,
+	err = vb2_v4l2_read(vdev->queue, buf, count, ppos,
 		       file->f_flags & O_NONBLOCK);
 	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
@@ -1929,7 +1929,7 @@ unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
 
 	fileio = q->fileio;
 
-	res = vb2_poll(vdev->queue, file, wait);
+	res = vb2_v4l2_poll(vdev->queue, file, wait);
 
 	/* If fileio was started, then we have a new queue owner. */
 	if (!fileio && q->fileio)
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 264d76f..5b690c5 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -65,7 +65,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
 	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+	    vb2_v4l2_get_plane_payload(vb, 0) > vb2_v4l2_plane_size(vb, 0)) {
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
 		return -EINVAL;
 	}
@@ -75,11 +75,11 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 
 	buf->state = UVC_BUF_STATE_QUEUED;
 	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
+	buf->length = vb2_v4l2_plane_size(vb, 0);
 	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
-		buf->bytesused = vb2_get_plane_payload(vb, 0);
+		buf->bytesused = vb2_v4l2_get_plane_payload(vb, 0);
 
 	return 0;
 }
@@ -128,7 +128,7 @@ int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
 				     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
-	ret = vb2_queue_init(&queue->queue);
+	ret = vb2_v4l2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
 
@@ -144,7 +144,7 @@ int uvcg_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
  */
 void uvcg_free_buffers(struct uvc_video_queue *queue)
 {
-	vb2_queue_release(&queue->queue);
+	vb2_v4l2_queue_release(&queue->queue);
 }
 
 /*
@@ -155,14 +155,14 @@ int uvcg_alloc_buffers(struct uvc_video_queue *queue,
 {
 	int ret;
 
-	ret = vb2_reqbufs(&queue->queue, rb);
+	ret = vb2_v4l2_reqbufs(&queue->queue, rb);
 
 	return ret ? ret : rb->count;
 }
 
 int uvcg_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 {
-	return vb2_querybuf(&queue->queue, buf);
+	return vb2_v4l2_querybuf(&queue->queue, buf);
 }
 
 int uvcg_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
@@ -170,7 +170,7 @@ int uvcg_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	unsigned long flags;
 	int ret;
 
-	ret = vb2_qbuf(&queue->queue, buf);
+	ret = vb2_v4l2_qbuf(&queue->queue, buf);
 	if (ret < 0)
 		return ret;
 
@@ -188,7 +188,7 @@ int uvcg_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 int uvcg_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 			int nonblocking)
 {
-	return vb2_dqbuf(&queue->queue, buf, nonblocking);
+	return vb2_v4l2_dqbuf(&queue->queue, buf, nonblocking);
 }
 
 /*
@@ -200,7 +200,7 @@ int uvcg_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 unsigned int uvcg_queue_poll(struct uvc_video_queue *queue, struct file *file,
 			     poll_table *wait)
 {
-	return vb2_poll(&queue->queue, file, wait);
+	return vb2_v4l2_poll(&queue->queue, file, wait);
 }
 
 int uvcg_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
@@ -280,14 +280,14 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 	int ret = 0;
 
 	if (enable) {
-		ret = vb2_streamon(&queue->queue, queue->queue.type);
+		ret = vb2_v4l2_streamon(&queue->queue, queue->queue.type);
 		if (ret < 0)
 			return ret;
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
 	} else {
-		ret = vb2_streamoff(&queue->queue, queue->queue.type);
+		ret = vb2_v4l2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
 			return ret;
 
@@ -316,7 +316,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
 	     buf->length != buf->bytesused) {
 		buf->state = UVC_BUF_STATE_QUEUED;
-		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+		vb2_v4l2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
 		return buf;
 	}
 
@@ -331,7 +331,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 	buf->buf.v4l2_buf.sequence = queue->sequence++;
 	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
 
-	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
+	vb2_v4l2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 871fcc6..97cfa8a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -674,27 +674,27 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
 void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
-int vb2_core_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
+int vb2_querybuf(struct vb2_queue *q, enum vb2_buf_type type,
 		unsigned int index, void *pb);
-int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory, unsigned int *count);
-int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_reqbufs(struct vb2_queue *q, enum vb2_memory memory, unsigned int *count);
+int vb2_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count, void *parg);
-int vb2_core_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
+int vb2_prepare_buf(struct vb2_queue *q, enum vb2_memory memory,
 		enum vb2_buf_type type, unsigned int index, void *pb);
 
-int __must_check vb2_core_queue_init(struct vb2_queue *q);
+int __must_check vb2_queue_init(struct vb2_queue *q);
 
-void vb2_core_queue_release(struct vb2_queue *q);
+void vb2_queue_release(struct vb2_queue *q);
 void vb2_queue_error(struct vb2_queue *q);
 
-int vb2_core_qbuf(struct vb2_queue *q, enum vb2_memory memory, enum vb2_buf_type type,
+int vb2_qbuf(struct vb2_queue *q, enum vb2_memory memory, enum vb2_buf_type type,
 		unsigned int index, void *pb);
-int vb2_core_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb, bool nonblock);
-int vb2_core_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int index,
+int vb2_dqbuf(struct vb2_queue *q, enum vb2_buf_type type, void *pb, bool nonblock);
+int vb2_expbuf(struct vb2_queue *q, enum vb2_buf_type type, unsigned int index,
 		unsigned int plane, unsigned int flags);
 
-int vb2_core_streamon(struct vb2_queue *q, enum vb2_buf_type type);
-int vb2_core_streamoff(struct vb2_queue *q, enum vb2_buf_type type);
+int vb2_streamon(struct vb2_queue *q, enum vb2_buf_type type);
+int vb2_streamoff(struct vb2_queue *q, enum vb2_buf_type type);
 
 int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
 #ifndef CONFIG_MMU
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 7460d0b..65adb2d 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -28,7 +28,7 @@
  *			(such as bytesused); NOTE that even for single-planar
  *			types, the v4l2_planes[0] struct should be used
  *			instead of v4l2_buf for filling bytesused - drivers
- *			should use the vb2_set_plane_payload() function for that
+ *			should use the vb2_v4l2_set_plane_payload() function for that
  */
 struct vb2_v4l2_buffer {
 	struct vb2_buffer	vb2_buf;
@@ -43,25 +43,25 @@ struct vb2_v4l2_buffer {
 #define to_vb2_v4l2_buffer(vb) \
 	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
 
-int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
+int vb2_v4l2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_v4l2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb);
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_v4l2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *cb);
+int vb2_v4l2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
-int __must_check vb2_queue_init(struct vb2_queue *q);
-void vb2_queue_release(struct vb2_queue *q);
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblock);
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
+int __must_check vb2_v4l2_queue_init(struct vb2_queue *q);
+void vb2_v4l2_queue_release(struct vb2_queue *q);
+int vb2_v4l2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_v4l2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblock);
+int vb2_v4l2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
+int vb2_v4l2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
+int vb2_v4l2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
 
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+unsigned int vb2_v4l2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
+size_t vb2_v4l2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+size_t vb2_v4l2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 /**
  * vb2_thread_fnc - callback function for use with vb2_thread
@@ -94,12 +94,12 @@ int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
 int vb2_thread_stop(struct vb2_queue *q);
 
 /**
- * vb2_set_plane_payload() - set bytesused for the plane plane_no
+ * vb2_v4l2_set_plane_payload() - set bytesused for the plane plane_no
  * @vb:		buffer for which plane payload should be set
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
  */
-static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
+static inline void vb2_v4l2_set_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -109,12 +109,12 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 }
 
 /**
- * vb2_get_plane_payload() - get bytesused for the plane plane_no
+ * vb2_v4l2_get_plane_payload() - get bytesused for the plane plane_no
  * @vb:		buffer for which plane payload should be set
  * @plane_no:	plane number for which payload should be set
  * @size:	payload in bytes
  */
-static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
+static inline unsigned long vb2_v4l2_get_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -125,12 +125,12 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 }
 
 /**
- * vb2_plane_size() - return plane size in bytes
+ * vb2_v4l2_plane_size() - return plane size in bytes
  * @vb:		buffer for which plane size should be returned
  * @plane_no:	plane number for which size should be returned
  */
 static inline unsigned long
-vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
+vb2_v4l2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
-- 
1.7.9.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36416 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbFHNfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 09:35:42 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NPM02V17OF9FJ20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Jun 2015 22:35:33 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH 3/3] make vb2-core part with not v4l2-specific elements
Date: Mon, 08 Jun 2015 22:35:35 +0900
Message-id: <1433770535-21143-4-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is temporary work to divide the vb2-core into two part, real vb2-core and
v4l2-specific part.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c      |    4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    6 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    4 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    4 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    4 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    4 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |    2 +-
 drivers/media/pci/cx88/cx88-video.c                |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    4 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    4 +-
 drivers/media/pci/tw68/tw68-video.c                |    4 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   12 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    6 +-
 drivers/media/platform/davinci/vpbe_display.c      |   14 +-
 drivers/media/platform/davinci/vpif_capture.c      |   12 +-
 drivers/media/platform/davinci/vpif_display.c      |   14 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    6 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    6 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    6 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    6 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    4 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    4 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    8 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    4 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |    8 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |    8 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    6 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |    4 +-
 drivers/media/usb/airspy/airspy.c                  |    8 +-
 drivers/media/usb/au0828/au0828-video.c            |   12 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   10 +-
 drivers/media/usb/go7007/go7007-driver.c           |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |    6 +-
 drivers/media/usb/msi2500/msi2500.c                |    6 +-
 drivers/media/usb/pwc/pwc-if.c                     |   10 +-
 drivers/media/usb/s2255/s2255drv.c                 |    4 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    6 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    4 +-
 drivers/media/usb/uvc/uvc_queue.c                  |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 1930 ++++++++-
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 4429 ++++++--------------
 include/media/v4l2-mem2mem.h                       |    2 +-
 include/media/videobuf2-core.h                     |  226 +-
 include/media/videobuf2-dma-sg.h                   |    4 +-
 include/media/videobuf2-v4l2.h                     |  121 +-
 69 files changed, 3683 insertions(+), 3351 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index b1142c2..e5f4c42 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -149,7 +149,7 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
 			else if (skel->field == V4L2_FIELD_TOP)
 				skel->field = V4L2_FIELD_BOTTOM;
 		}
-		vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&new_buf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 #endif
 	return IRQ_HANDLED;
@@ -234,7 +234,7 @@ static void return_all_buffers(struct skeleton *skel,
 
 	spin_lock_irqsave(&skel->qlock, flags);
 	list_for_each_entry_safe(buf, node, &skel->buf_list, list) {
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2, state);
 		list_del(&buf->list);
 	}
 	spin_unlock_irqrestore(&skel->qlock, flags);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 2353b63..b24ccac 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -305,7 +305,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&fbuf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -459,7 +459,7 @@ static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				struct rtl2832_sdr_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -521,7 +521,7 @@ static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!dev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 4e74f71..67329e4 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1204,7 +1204,7 @@ static int cx23885_start_streaming(struct vb2_queue *q, unsigned int count)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 	return ret;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 1ad4994..3dd63d4 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -432,7 +432,7 @@ static void cx23885_wakeup(struct cx23885_tsport *port,
 	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
 		count, q->count);
 	list_del(&buf->queue);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 }
 
 int cx23885_sram_channel_setup(struct cx23885_dev *dev,
@@ -1529,7 +1529,7 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason)
 		buf = list_entry(q->active.next, struct cx23885_buffer,
 				 queue);
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		dprintk(1, "[%p/%d] %s - dma=0x%08lx\n",
 			buf, buf->vb.v4l2_buf.index, reason, (unsigned long)buf->risc.dma);
 	}
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index ba0360b..08c2b0e 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -248,7 +248,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 79983f9..bee4946 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -109,7 +109,7 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
 			count, q->count);
 	list_del(&buf->queue);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 }
 
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
@@ -495,7 +495,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 12894be..2854ad1 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -133,7 +133,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 			v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 			buf->vb.v4l2_buf.sequence = dmaq->count++;
 			list_del(&buf->queue);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 		}
 		spin_unlock(&dev->slock);
 		handled++;
@@ -304,7 +304,7 @@ static void cx25821_stop_streaming(struct vb2_queue *q)
 			struct cx25821_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 5bfdaaf..da006ff 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -724,7 +724,7 @@ fail:
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 	return err;
@@ -752,7 +752,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index c38d5a1..fb47821 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -520,7 +520,7 @@ void cx88_wakeup(struct cx88_core *core,
 			 struct cx88_buffer, list);
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 	list_del(&buf->list);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 }
 
 void cx88_shutdown(struct cx88_core *core)
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index a13de6f..886a0c4 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -152,7 +152,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index a369b08..561d81e 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -288,7 +288,7 @@ static void do_cancel_buffers(struct cx8802_dev *dev)
 	while (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx88_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index ca23fae..a6d2db0 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -220,7 +220,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index f0c486e..6eb0490 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -567,7 +567,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index a349e96..cdee1a6 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -303,7 +303,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 	/* finish current buffer */
 	v4l2_get_timestamp(&q->curr->vb2.v4l2_buf.timestamp);
 	q->curr->vb2.v4l2_buf.sequence = q->seq_nr++;
-	vb2_buffer_done(&q->curr->vb2, state);
+	vb2_buffer_done(&q->curr->vb2.vb2, state);
 	q->curr = NULL;
 }
 
@@ -368,7 +368,7 @@ void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q)
 	if (!list_empty(&q->queue)) {
 		list_for_each_safe(pos, n, &q->queue) {
 			 tmp = list_entry(pos, struct saa7134_buf, entry);
-			 vb2_buffer_done(&tmp->vb2, VB2_BUF_STATE_ERROR);
+			 vb2_buffer_done(&tmp->vb2.vb2, VB2_BUF_STATE_ERROR);
 			 list_del(pos);
 			 tmp = NULL;
 		}
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index dbab598..0bcd4f3 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -148,10 +148,10 @@ int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 		list_for_each_entry_safe(buf, tmp, &dmaq->queue, entry) {
 			list_del(&buf->entry);
-			vb2_buffer_done(&buf->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb2.vb2, VB2_BUF_STATE_QUEUED);
 		}
 		if (dmaq->curr) {
-			vb2_buffer_done(&dmaq->curr->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&dmaq->curr->vb2.vb2, VB2_BUF_STATE_QUEUED);
 			dmaq->curr = NULL;
 		}
 		return -EBUSY;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 208f313..4d53dc2 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -951,10 +951,10 @@ int saa7134_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 		list_for_each_entry_safe(buf, tmp, &dmaq->queue, entry) {
 			list_del(&buf->entry);
-			vb2_buffer_done(&buf->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb2.vb2, VB2_BUF_STATE_QUEUED);
 		}
 		if (dmaq->curr) {
-			vb2_buffer_done(&dmaq->curr->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&dmaq->curr->vb2.vb2, VB2_BUF_STATE_QUEUED);
 			dmaq->curr = NULL;
 		}
 		return -EBUSY;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 0b71219..d5ebdf6 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -546,7 +546,7 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 		}
 	}
 
-	vb2_buffer_done(vb, ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2, ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 	return ret;
 }
@@ -735,7 +735,7 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 				struct solo_vb2_buf, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 }
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 129b53f..525f01a 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -226,7 +226,7 @@ finish_buf:
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	}
 
-	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 }
 
 static void solo_thread_try(struct solo_dev *solo_dev)
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 674e9fd..8d9971a 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -374,7 +374,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	spin_lock(&vip->lock);
 	list_for_each_entry_safe(vip_buf, node, &vip->buffer_list, list) {
-		vb2_buffer_done(&vip_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vip_buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		list_del(&vip_buf->list);
 	}
 	spin_unlock(&vip->lock);
@@ -819,7 +819,7 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 		/* Remove the active buffer from the list */
 		do_gettimeofday(&vip->active->vb.v4l2_buf.timestamp);
 		vip->active->vb.v4l2_buf.sequence = vip->sequence++;
-		vb2_buffer_done(&vip->active->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vip->active->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index f94bd23..15cbf60 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -532,7 +532,7 @@ static void tw68_stop_streaming(struct vb2_queue *q)
 			container_of(dev->active.next, struct tw68_buf, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 }
 
@@ -1019,7 +1019,7 @@ void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
 		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 		buf->vb.v4l2_buf.field = dev->field;
 		buf->vb.v4l2_buf.sequence = dev->seqnr++;
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 		status &= ~(TW68_DMAPI);
 		if (0 == status)
 			return;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 75f6d3f..feaae29 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1272,7 +1272,7 @@ static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
 	v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
 	vpfe->cur_frm->vb.v4l2_buf.field = vpfe->fmt.fmt.pix.field;
 	vpfe->cur_frm->vb.v4l2_buf.sequence = vpfe->sequence++;
-	vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vpfe->cur_frm->vb.vb2, VB2_BUF_STATE_DONE);
 	vpfe->cur_frm = vpfe->next_frm;
 }
 
@@ -2025,7 +2025,7 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &vpfe->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -2057,13 +2057,13 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
 	if (vpfe->cur_frm == vpfe->next_frm) {
-		vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vpfe->cur_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	} else {
 		if (vpfe->cur_frm != NULL)
-			vb2_buffer_done(&vpfe->cur_frm->vb,
+			vb2_buffer_done(&vpfe->cur_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 		if (vpfe->next_frm != NULL)
-			vb2_buffer_done(&vpfe->next_frm->vb,
+			vb2_buffer_done(&vpfe->next_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -2071,7 +2071,7 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 		vpfe->next_frm = list_entry(vpfe->dma_queue.next,
 						struct vpfe_cap_buffer, list);
 		list_del(&vpfe->next_frm->list);
-		vb2_buffer_done(&vpfe->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vpfe->next_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
 }
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index d742b51..eb17142 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -439,7 +439,7 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
 		list_del_init(&bcap_dev->cur_frm->list);
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 }
 
@@ -518,10 +518,10 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	if (!list_empty(&bcap_dev->dma_queue)) {
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		if (ppi->err) {
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_ERROR);
 			ppi->err = false;
 		} else {
-			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_DONE);
 		}
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 				struct bcap_buffer, list);
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 418a140..f810820 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -80,7 +80,7 @@ static void vpbe_isr_even_field(struct vpbe_display *disp_obj,
 		timevalue.tv_sec;
 	layer->cur_frm->vb.v4l2_buf.timestamp.tv_usec =
 		timevalue.tv_nsec / NSEC_PER_USEC;
-	vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&layer->cur_frm->vb.vb2, VB2_BUF_STATE_DONE);
 	/* Make cur_frm pointing to next_frm */
 	layer->cur_frm = layer->next_frm;
 }
@@ -307,10 +307,10 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0) {
 		struct vpbe_disp_buffer *buf, *tmp;
 
-		vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&layer->cur_frm->vb.vb2, VB2_BUF_STATE_QUEUED);
 		list_for_each_entry_safe(buf, tmp, &layer->dma_queue, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 
 		return ret;
@@ -340,13 +340,13 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&disp->dma_queue_lock, flags);
 	if (layer->cur_frm == layer->next_frm) {
-		vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->cur_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	} else {
 		if (layer->cur_frm != NULL)
-			vb2_buffer_done(&layer->cur_frm->vb,
+			vb2_buffer_done(&layer->cur_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 		if (layer->next_frm != NULL)
-			vb2_buffer_done(&layer->next_frm->vb,
+			vb2_buffer_done(&layer->next_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -354,7 +354,7 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 		layer->next_frm = list_entry(layer->dma_queue.next,
 						struct vpbe_disp_buffer, list);
 		list_del(&layer->next_frm->list);
-		vb2_buffer_done(&layer->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->next_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
 }
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index e4912c0..dbe9f97 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -245,7 +245,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -288,13 +288,13 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
-		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->cur_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	} else {
 		if (common->cur_frm != NULL)
-			vb2_buffer_done(&common->cur_frm->vb,
+			vb2_buffer_done(&common->cur_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 		if (common->next_frm != NULL)
-			vb2_buffer_done(&common->next_frm->vb,
+			vb2_buffer_done(&common->next_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -302,7 +302,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_cap_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -328,7 +328,7 @@ static struct vb2_ops video_qops = {
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
 	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&common->cur_frm->vb,
+	vb2_buffer_done(&common->cur_frm->vb.vb2,
 					    VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 97cb223..0229e2a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -231,7 +231,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -266,13 +266,13 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
-		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->cur_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	} else {
 		if (common->cur_frm != NULL)
-			vb2_buffer_done(&common->cur_frm->vb,
+			vb2_buffer_done(&common->cur_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 		if (common->next_frm != NULL)
-			vb2_buffer_done(&common->next_frm->vb,
+			vb2_buffer_done(&common->next_frm->vb.vb2,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -280,7 +280,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_disp_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -328,7 +328,7 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* Copy frame display time */
 		v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
 		/* Change status of the cur_frm */
-		vb2_buffer_done(&common->cur_frm->vb,
+		vb2_buffer_done(&common->cur_frm->vb.vb2,
 					    VB2_BUF_STATE_DONE);
 		/* Make cur_frm pointing to next_frm */
 		common->cur_frm = common->next_frm;
@@ -384,7 +384,7 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 				 * done and unlock semaphore on it */
 				v4l2_get_timestamp(&common->cur_frm->vb.
 						   v4l2_buf.timestamp);
-				vb2_buffer_done(&common->cur_frm->vb,
+				vb2_buffer_done(&common->cur_frm->vb.vb2,
 					    VB2_BUF_STATE_DONE);
 				/* Make cur_frm pointing to next_frm */
 				common->cur_frm = common->next_frm;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 40db7ac..775d33a 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -103,7 +103,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	/* Release unused buffers */
 	while (!suspend && !list_empty(&cap->pending_buf_q)) {
 		buf = fimc_pending_queue_pop(cap);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&cap->active_buf_q)) {
@@ -111,7 +111,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 		if (suspend)
 			fimc_pending_queue_add(cap, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	fimc_hw_reset(fimc);
@@ -202,7 +202,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
 
-		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&v_buf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 
 	if (!list_empty(&cap->pending_buf_q)) {
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 833a238..2443ec0 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -256,7 +256,7 @@ void fimc_isp_video_irq_handler(struct fimc_is *is)
 	vb = &video->buffers[buf_index]->vb;
 
 	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_DONE);
 
 	video->buf_mask &= ~BIT(buf_index);
 	fimc_is_hw_set_isp_buf_mask(is, video->buf_mask);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index ec8bbf1..8d5bdc9 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -200,7 +200,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 	/* Release unused buffers */
 	while (!suspend && !list_empty(&fimc->pending_buf_q)) {
 		buf = fimc_lite_pending_queue_pop(fimc);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&fimc->active_buf_q)) {
@@ -208,7 +208,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 		if (suspend)
 			fimc_lite_pending_queue_add(fimc, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -300,7 +300,7 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
-		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbuf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 50b23af..e7aea8a 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -238,7 +238,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
 	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
 	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
-	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vbuf->vb2, VB2_BUF_STATE_DONE);
 }
 
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 5d390e7..861e790 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -394,7 +394,7 @@ static void isp_video_buffer_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (unlikely(video->error)) {
-		vb2_buffer_done(&buffer->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->vb.vb2, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->irqlock, flags);
 		return;
 	}
@@ -496,7 +496,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		state = VB2_BUF_STATE_DONE;
 	}
 
-	vb2_buffer_done(&buf->vb, state);
+	vb2_buffer_done(&buf->vb.vb2, state);
 
 	spin_lock_irqsave(&video->irqlock, flags);
 
@@ -552,7 +552,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 		buf = list_first_entry(&video->dmaqueue,
 				       struct isp_buffer, irqlist);
 		list_del(&buf->irqlist);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	video->error = true;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index a1f982f..def396f 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -164,12 +164,12 @@ static int camif_reinitialize(struct camif_vp *vp)
 	/* Release unused buffers */
 	while (!list_empty(&vp->pending_buf_q)) {
 		buf = camif_pending_queue_pop(vp);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	while (!list_empty(&vp->active_buf_q)) {
 		buf = camif_active_queue_pop(vp);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&camif->slock, flags);
@@ -346,7 +346,7 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 			tv->tv_sec = ts.tv_sec;
 			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
-			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&vbuf->vb.vb2, VB2_BUF_STATE_DONE);
 
 			/* Set up an empty buffer at the DMA engine */
 			vbuf = camif_pending_queue_pop(vp);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 93f3e13..8ac79a2 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2183,7 +2183,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		     min((unsigned long)ctx->out_q.size,
 			 vb2_get_plane_payload(cb, 0)), ctx);
 		if (!ctx->hdr_parsed) {
-			vb2_buffer_done(cb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			return;
 		}
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 5600dcd..fc00580 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -213,7 +213,7 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
 
 		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
-		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&dst_buf->b->vb2, VB2_BUF_STATE_DONE);
 	}
 }
 
@@ -312,7 +312,7 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			clear_bit(dst_buf->b->v4l2_buf.index,
 							&ctx->dec_dst_flag);
 
-			vb2_buffer_done(dst_buf->b,
+			vb2_buffer_done(&dst_buf->b->vb2,
 				err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 			break;
@@ -406,9 +406,9 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 			list_del(&src_buf->list);
 			ctx->src_queue_cnt--;
 			if (s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) > 0)
-				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_ERROR);
+				vb2_buffer_done(&src_buf->b->vb2, VB2_BUF_STATE_ERROR);
 			else
-				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+				vb2_buffer_done(&src_buf->b->vb2, VB2_BUF_STATE_DONE);
 		}
 	}
 leave_handle_frame:
@@ -550,7 +550,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 					     struct s5p_mfc_buf, list);
 				list_del(&src_buf->list);
 				ctx->src_queue_cnt--;
-				vb2_buffer_done(src_buf->b,
+				vb2_buffer_done(&src_buf->b->vb2,
 						VB2_BUF_STATE_DONE);
 			}
 			spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -592,7 +592,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 		list_del(&mb_entry->list);
 		ctx->dst_queue_cnt--;
 		vb2_set_plane_payload(mb_entry->b, 0, 0);
-		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&mb_entry->b->vb2, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock(&dev->irqlock);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 062a087..2a1e7fc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -799,7 +799,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 			vb2_set_plane_payload(dst_mb->b, 0,
 				s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size,
 						dev));
-			vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&dst_mb->b->vb2, VB2_BUF_STATE_DONE);
 		}
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
@@ -875,7 +875,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 						(enc_c_addr == mb_c_addr)) {
 				list_del(&mb_entry->list);
 				ctx->src_queue_cnt--;
-				vb2_buffer_done(mb_entry->b,
+				vb2_buffer_done(&mb_entry->b->vb2,
 							VB2_BUF_STATE_DONE);
 				break;
 			}
@@ -887,7 +887,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 						(enc_c_addr == mb_c_addr)) {
 				list_del(&mb_entry->list);
 				ctx->ref_queue_cnt--;
-				vb2_buffer_done(mb_entry->b,
+				vb2_buffer_done(&mb_entry->b->vb2,
 							VB2_BUF_STATE_DONE);
 				break;
 			}
@@ -922,7 +922,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			break;
 		}
 		vb2_set_plane_payload(mb_entry->b, 0, strm_size);
-		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&mb_entry->b->vb2, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
@@ -2009,7 +2009,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	struct s5p_mfc_buf *mfc_buf;
 
 	if (ctx->state == MFCINST_ERROR) {
-		vb2_buffer_done(cb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		cleanup_ref_queue(ctx);
 		return;
 	}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index c64ff34..e36b6c5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1478,7 +1478,7 @@ static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
 		for (i = 0; i < b->b->vb2.num_planes; i++)
 			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&b->b->vb2, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 75e875f..a68dd3a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1836,7 +1836,7 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
 		for (i = 0; i < b->b->vb2.num_planes; i++)
 			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&b->b->vb2, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
 }
diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index b713403..72d367c 100644
--- a/drivers/media/platform/s5p-tv/mixer_reg.c
+++ b/drivers/media/platform/s5p-tv/mixer_reg.c
@@ -279,7 +279,7 @@ static void mxr_irq_layer_handle(struct mxr_layer *layer)
 	layer->ops.buffer_set(layer, layer->update_buf);
 
 	if (done && done != layer->shadow_buf)
-		vb2_buffer_done(&done->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&done->vb.vb2, VB2_BUF_STATE_DONE);
 
 done:
 	spin_unlock(&layer->enq_slock);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 47309f0..ab30d46 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -964,11 +964,11 @@ static void mxr_watchdog(unsigned long arg)
 	if (layer->update_buf == layer->shadow_buf)
 		layer->update_buf = NULL;
 	if (layer->update_buf) {
-		vb2_buffer_done(&layer->update_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->update_buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		layer->update_buf = NULL;
 	}
 	if (layer->shadow_buf) {
-		vb2_buffer_done(&layer->shadow_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->shadow_buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		layer->shadow_buf = NULL;
 	}
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
@@ -992,7 +992,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* set all buffer to be done */
 	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index b3e9315..9c592e3 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -159,7 +159,7 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		list_del_init(&buf->list);
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = isi->sequence++;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&isi->video_buffer_list)) {
@@ -425,7 +425,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
 		list_del_init(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irq(&isi->lock);
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 45e956a..2cfd4d1 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1340,9 +1340,9 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = pcdev->frame_count;
 		if (err)
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_ERROR);
 		else
-			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_DONE);
 	}
 
 	pcdev->frame_count++;
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index e431b7c..cd7ba2a 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -158,7 +158,7 @@ static void mx3_cam_dma_done(void *arg)
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.field = mx3_cam->field;
 		vb->v4l2_buf.sequence = mx3_cam->sequence++;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&mx3_cam->capture)) {
@@ -428,7 +428,7 @@ static void mx3_stop_streaming(struct vb2_queue *q)
 
 	list_for_each_entry_safe(buf, tmp, &mx3_cam->capture, queue) {
 		list_del_init(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 1f84155..24ef71a 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -841,7 +841,7 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
 		if (priv->queue_buf[i]) {
-			vb2_buffer_done(priv->queue_buf[i],
+			vb2_buffer_done(&priv->queue_buf[i]->vb2,
 					VB2_BUF_STATE_ERROR);
 			priv->queue_buf[i] = NULL;
 		}
@@ -849,7 +849,7 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 
 	list_for_each_safe(buf_head, tmp, &priv->capture) {
 		vb2_buffer_done(&list_entry(buf_head,
-					struct rcar_vin_buffer, list)->vb,
+					struct rcar_vin_buffer, list)->vb.vb2,
 				VB2_BUF_STATE_ERROR);
 		list_del_init(buf_head);
 	}
@@ -897,7 +897,7 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
 		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
 		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
-		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&priv->queue_buf[slot]->vb2, VB2_BUF_STATE_DONE);
 		priv->queue_buf[slot] = NULL;
 
 		if (priv->state != STOPPING)
@@ -968,7 +968,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 		vb = priv->queue_buf[i];
 		if (vb) {
 			list_del_init(to_buf_list(vb));
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&vb->vb2, VB2_BUF_STATE_ERROR);
 		}
 	}
 	spin_unlock_irq(&priv->lock);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 5713920..14a22da 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -533,7 +533,7 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		vb->v4l2_buf.field = pcdev->field;
 		vb->v4l2_buf.sequence = pcdev->sequence++;
 	}
-	vb2_buffer_done(vb, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 out:
 	spin_unlock(&pcdev->lock);
@@ -638,7 +638,7 @@ static void sh_mobile_ceu_clock_stop(struct soc_camera_host *ici)
 	spin_lock_irq(&pcdev->lock);
 	if (pcdev->active) {
 		list_del_init(&to_ceu_vb(pcdev->active)->queue);
-		vb2_buffer_done(pcdev->active, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pcdev->active->vb2, VB2_BUF_STATE_ERROR);
 		pcdev->active = NULL;
 	}
 	spin_unlock_irq(&pcdev->lock);
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 39a67cf..0fbd564 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -677,7 +677,7 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 				dev->fb_cap.fmt.pixelformat == dev->fmt_cap->fourcc)
 			vivid_overlay(dev, vid_cap_buf);
 
-		vb2_buffer_done(&vid_cap_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&vid_cap_buf->vb.vb2, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
 				vid_cap_buf->vb.v4l2_buf.index);
@@ -688,7 +688,7 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 			vivid_sliced_vbi_cap_process(dev, vbi_cap_buf);
 		else
 			vivid_raw_vbi_cap_process(dev, vbi_cap_buf);
-		vb2_buffer_done(&vbi_cap_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&vbi_cap_buf->vb.vb2, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_cap %d done\n",
 				vbi_cap_buf->vb.v4l2_buf.index);
@@ -855,7 +855,7 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_cap buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
@@ -868,7 +868,7 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_cap buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index d9f36cc..551d306 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -97,7 +97,7 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		}
 		v4l2_get_timestamp(&vid_out_buf->vb.v4l2_buf.timestamp);
 		vid_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vid_out_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&vid_out_buf->vb.vb2, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_out buffer %d done\n",
 			vid_out_buf->vb.v4l2_buf.index);
@@ -110,7 +110,7 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		vbi_out_buf->vb.v4l2_buf.sequence = dev->vbi_out_seq_count;
 		v4l2_get_timestamp(&vbi_out_buf->vb.v4l2_buf.timestamp);
 		vbi_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vbi_out_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&vbi_out_buf->vb.vb2, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_out buffer %d done\n",
 			vbi_out_buf->vb.v4l2_buf.index);
@@ -274,7 +274,7 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_out buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
@@ -287,7 +287,7 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_out buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index f17dc18..e7f9c7b 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -98,7 +98,7 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
 		v4l2_get_timestamp(&sdr_cap_buf->vb.v4l2_buf.timestamp);
 		sdr_cap_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&sdr_cap_buf->vb, dev->dqbuf_error ?
+		vb2_buffer_done(&sdr_cap_buf->vb.vb2, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dev->dqbuf_error = false;
 	}
@@ -264,7 +264,7 @@ static int sdr_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->sdr_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
@@ -283,7 +283,7 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(dev->sdr_cap_active.next, struct vivid_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	/* shutdown control thread */
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 5758beb..3f63dff 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -217,7 +217,7 @@ static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 181fea0..582c0b4 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -109,7 +109,7 @@ static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 8427b16..4708d48 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -269,7 +269,7 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 5427ded..8b97ef9 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -190,7 +190,7 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 0983ea6..2abcc20 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -602,7 +602,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
 	for (i = 0; i < done->buf.vb2.num_planes; ++i)
 		vb2_set_plane_payload(&done->buf, i, done->length[i]);
-	vb2_buffer_done(&done->buf, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&done->buf.vb2, VB2_BUF_STATE_DONE);
 
 	return next;
 }
@@ -875,7 +875,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
 	list_for_each_entry(buffer, &video->irqqueue, queue)
-		vb2_buffer_done(&buffer->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->buf.vb2, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 637a75e..c18424b 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -316,7 +316,7 @@ static void airspy_urb_complete(struct urb *urb)
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = s->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&fbuf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -459,7 +459,7 @@ static void airspy_cleanup_queued_bufs(struct airspy *s)
 		buf = list_entry(s->queued_bufs.next,
 				struct airspy_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 }
@@ -513,7 +513,7 @@ static void airspy_buf_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!s->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -572,7 +572,7 @@ err_clear_bit:
 
 		list_for_each_entry_safe(buf, tmp, &s->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 2a25401..6e03417 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -308,7 +308,7 @@ static inline void buffer_filled(struct au0828_dev *dev,
 	buf->vb.v4l2_buf.sequence = dev->frame_count++;
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 }
 
 static inline void vbi_buffer_filled(struct au0828_dev *dev,
@@ -321,7 +321,7 @@ static inline void vbi_buffer_filled(struct au0828_dev *dev,
 	buf->vb.v4l2_buf.sequence = dev->vbi_frame_count++;
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -837,14 +837,14 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->isoc_ctl.buf != NULL) {
-		vb2_buffer_done(&dev->isoc_ctl.buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->isoc_ctl.buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		dev->isoc_ctl.buf = NULL;
 	}
 	while (!list_empty(&vidq->active)) {
 		struct au0828_buffer *buf;
 
 		buf = list_entry(vidq->active.next, struct au0828_buffer, list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		list_del(&buf->list);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -864,7 +864,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->isoc_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb,
+		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb.vb2,
 				VB2_BUF_STATE_ERROR);
 		dev->isoc_ctl.vbi_buf = NULL;
 	}
@@ -873,7 +873,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct au0828_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 50f7859..39d765f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -440,7 +440,7 @@ static inline void finish_buffer(struct em28xx *dev,
 		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -999,7 +999,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vid_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vid_buf = NULL;
 	}
 	while (!list_empty(&vidq->active)) {
@@ -1007,7 +1007,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1030,7 +1030,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vbi_buf = NULL;
 	}
 	while (!list_empty(&vbiq->active)) {
@@ -1038,7 +1038,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 95cffb7..2c9f056 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -475,7 +475,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 		vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
 	go->active_buf = vb;
 	spin_unlock(&go->spinlock);
-	vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb_tmp->vb.vb2, VB2_BUF_STATE_DONE);
 	return vb;
 }
 
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 46fc79d..5a173a8 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -293,7 +293,7 @@ static void hackrf_urb_complete(struct urb *urb)
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&fbuf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -437,7 +437,7 @@ static void hackrf_cleanup_queued_bufs(struct hackrf_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				struct hackrf_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -540,7 +540,7 @@ err:
 
 		list_for_each_entry_safe(buf, tmp, &dev->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 14777b5..771eb08e 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -435,7 +435,7 @@ static void msi2500_isoc_handler(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
 		flen = msi2500_convert_stream(s, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&fbuf->vb.vb2, VB2_BUF_STATE_DONE);
 	}
 
 handler_end:
@@ -569,7 +569,7 @@ static void msi2500_cleanup_queued_bufs(struct msi2500_state *s)
 		buf = list_entry(s->queued_bufs.next, struct msi2500_frame_buf,
 				 list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 }
@@ -639,7 +639,7 @@ static void msi2500_buf_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!s->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 87fc603..1f1c558 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -242,7 +242,7 @@ static void pwc_frame_complete(struct pwc_device *pdev)
 		} else {
 			fbuf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
 			fbuf->vb.v4l2_buf.sequence = pdev->vframe_count;
-			vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&fbuf->vb.vb2, VB2_BUF_STATE_DONE);
 			pdev->fill_buf = NULL;
 			pdev->vsync = 0;
 		}
@@ -287,7 +287,7 @@ static void pwc_isoc_handler(struct urb *urb)
 		{
 			PWC_ERROR("Too many ISOC errors, bailing out.\n");
 			if (pdev->fill_buf) {
-				vb2_buffer_done(&pdev->fill_buf->vb,
+				vb2_buffer_done(&pdev->fill_buf->vb.vb2,
 						VB2_BUF_STATE_ERROR);
 				pdev->fill_buf = NULL;
 			}
@@ -520,7 +520,7 @@ static void pwc_cleanup_queued_bufs(struct pwc_device *pdev,
 		buf = list_entry(pdev->queued_bufs.next, struct pwc_frame_buf,
 				 list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2, state);
 	}
 	spin_unlock_irqrestore(&pdev->queued_bufs_lock, flags);
 }
@@ -650,7 +650,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!pdev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -699,7 +699,7 @@ static void stop_streaming(struct vb2_queue *vq)
 
 	pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_ERROR);
 	if (pdev->fill_buf)
-		vb2_buffer_done(&pdev->fill_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pdev->fill_buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	mutex_unlock(&pdev->v4l2_lock);
 }
 
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 0bebb53..ebb408c 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -580,7 +580,7 @@ static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 
 	s2255_fillbuff(vc, buf, jpgsize);
 	/* tell v4l buffer was filled */
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "%s: [buf] [%p]\n", __func__, buf);
 }
 
@@ -1118,7 +1118,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	spin_lock_irqsave(&vc->qlock, flags);
 	list_for_each_entry_safe(buf, node, &vc->buf_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		dprintk(vc->dev, 2, "[%p/%d] done\n",
 			buf, buf->vb.v4l2_buf.index);
 	}
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index b865ca6..bdb0690 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -552,7 +552,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		 * If the device is disconnected return the buffer to userspace
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 	} else {
 
 		buf->mem = vb2_plane_vaddr(cb, 0);
@@ -565,7 +565,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		 * the buffer to userspace directly.
 		 */
 		if (buf->length < dev->width * dev->height * 2)
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		else
 			list_add_tail(&buf->list, &dev->avail_bufs);
 
@@ -617,7 +617,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = list_first_entry(&dev->avail_bufs,
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		stk1160_info("buffer [%p/%d] aborted\n",
 				buf, buf->vb.v4l2_buf.index);
 	}
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 39f1aae..af7975b 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -104,7 +104,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->vb, 0, buf->bytesused);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_DONE);
 
 	dev->isoc_ctl.buf = NULL;
 }
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 82d1dc0..ac9a34f 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -324,7 +324,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 		buf->vb.v4l2_buf.sequence = usbtv->sequence++;
 		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 		vb2_set_plane_payload(&buf->vb, 0, size);
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2, state);
 		list_del(&buf->list);
 	}
 
@@ -422,7 +422,7 @@ static void usbtv_stop(struct usbtv *usbtv)
 	while (!list_empty(&usbtv->bufs)) {
 		struct usbtv_buf *buf = list_first_entry(&usbtv->bufs,
 						struct usbtv_buf, list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2, VB2_BUF_STATE_ERROR);
 		list_del(&buf->list);
 	}
 	spin_unlock_irqrestore(&usbtv->buflock, flags);
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index faa0105..a366fe1 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -60,7 +60,7 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
 							  queue);
 		list_del(&buf->queue);
 		buf->state = state;
-		vb2_buffer_done(&buf->buf, vb2_state);
+		vb2_buffer_done(&buf->buf.vb2, vb2_state);
 	}
 }
 
@@ -130,7 +130,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->buf.vb2, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&queue->irqlock, flags);
@@ -416,7 +416,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 
 	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
 	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->buf.vb2, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5f75937..222aa65 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -28,8 +28,1936 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-common.h>
-#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-core.h>
 
+static int vb2_debug;
+module_param(vb2_debug, int, 0644);
+
+int get_vb2_debug(void)
+{
+	return vb2_debug;
+}
+
+#define dprintk(level, fmt, arg...)					      \
+	do {								      \
+		if (get_vb2_debug() >= level)					      \
+			pr_info("vb2: %s: " fmt, __func__, ## arg); \
+	} while (0)
+
+#define call_priv_op(q, op, args...)				\
+({ \
+	int ret = 0;									\
+	if((q) && (q)->priv_ops && (q)->priv_ops->op)	\
+		ret = (q)->priv_ops->op(args);			\
+	ret;										\
+})
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
+	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, call_priv_op(vb->vb2_queue, get_buffer_index, vb), #op,	\
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
+	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
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
+	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
+		(vb)->vb2_queue, call_priv_op(vb->vb2_queue, get_buffer_index, vb), #op,	\
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
+
+void __vb2_queue_cancel(struct vb2_queue *q);
+
+/**
+ * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
+ */
+static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	enum dma_data_direction dma_dir =
+		MEDIA_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
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
+		call_priv_op(q, set_plane_length, vb, plane, q->plane_sizes[plane]);
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
+		dprintk(3, "freed plane %d of buffer %d\n", plane,
+			call_priv_op(vb->vb2_queue, get_buffer_index, vb));
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
+			call_priv_op(q, set_plane_length, vb, plane, q->plane_sizes[plane]);
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
+static int __vb2_queue_alloc(struct vb2_queue *q, enum media_memory memory,
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
+			dprintk(1, "memory alloc for buffer struct failed\n");
+			break;
+		}
+
+		vb->state = VB2_BUF_STATE_DEQUEUED;
+		vb->vb2_queue = q;
+		vb->num_planes = num_planes;
+		call_priv_op(q, init_priv_buffer, vb, q, buffer, memory, num_planes);
+
+		/* Allocate video buffer memory for the MMAP type */
+		if (memory == MEDIA_MEMORY_MMAP) {
+			ret = __vb2_buf_mem_alloc(vb);
+			if (ret) {
+				dprintk(1, "failed allocating memory for "
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
+				dprintk(1, "buffer %d %p initialization"
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
+	if (memory == MEDIA_MEMORY_MMAP)
+		call_priv_op(q, setup_offsets, q, buffer);
+
+	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
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
+		if (q->memory == MEDIA_MEMORY_MMAP)
+			__vb2_buf_mem_free(vb);
+		else if (q->memory == MEDIA_MEMORY_DMABUF)
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
+int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
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
+			dprintk(1, "preparing buffers, cannot free\n");
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
+		if (unbalanced || vb2_debug) {
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
+		if (unbalanced || vb2_debug) {
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
+ * @type:	enum media_buf_type; buffer type (type == *_MPLANE for
+ *		multiplanar buffers);
+ * @index:	id number of the buffer
+ * @pb:		private buffer struct passed from userspace to vidioc_querybuf handler
+ *		in driver
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
+		dprintk(1, "wrong buffer type\n");
+		return -EINVAL;
+	}
+
+	if (index >= q->num_buffers) {
+		dprintk(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+	vb = q->bufs[index];
+	ret = call_priv_op(q, verify_planes_array, vb, pb);
+	if (!ret)
+		ret = call_priv_op(q, fill_priv_buffer, vb, pb);
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
+		enum media_memory memory, enum media_buf_type type)
+{
+	if (memory != MEDIA_MEMORY_MMAP && memory != MEDIA_MEMORY_USERPTR &&
+	    memory != MEDIA_MEMORY_DMABUF) {
+		dprintk(1, "unsupported memory type\n");
+		return -EINVAL;
+	}
+
+	if (type != q->type) {
+		dprintk(1, "requested type is incorrect\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Make sure all the required memory ops for given memory type
+	 * are available.
+	 */
+	if (memory == MEDIA_MEMORY_MMAP && __verify_mmap_ops(q)) {
+		dprintk(1, "MMAP for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (memory == MEDIA_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+		dprintk(1, "USERPTR for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (memory == MEDIA_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+		dprintk(1, "DMABUF for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Place the busy tests at the end: -EBUSY can be ignored when
+	 * create_bufs is called with count == 0, but count == 0 should still
+	 * do the memory and type validation.
+	 */
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+/**
+ * __reqbufs() - Initiate streaming
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
+int __reqbufs(struct vb2_queue *q, unsigned int count,
+		unsigned int type, unsigned int memory)
+{
+	unsigned int num_buffers, allocated_buffers, num_planes = 0;
+	int ret;
+
+	if (q->streaming) {
+		dprintk(1, "streaming active\n");
+		return -EBUSY;
+	}
+
+	if (count == 0 || q->num_buffers != 0 || q->memory != memory) {
+		/*
+		 * We already have buffers allocated, so first check if they
+		 * are not in use and can be freed.
+		 */
+		mutex_lock(&q->mmap_lock);
+		if (q->memory == MEDIA_MEMORY_MMAP && __buffers_in_use(q)) {
+			mutex_unlock(&q->mmap_lock);
+			dprintk(1, "memory in use, cannot free\n");
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
+		if (count == 0)
+			return 0;
+	}
+
+	/*
+	 * Make sure the requested values and current defaults are sane.
+	 */
+	num_buffers = min_t(unsigned int, count, MEDIA_MAX_FRAME);
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
+		dprintk(1, "memory allocation failed\n");
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
+	q->waiting_for_buffers = !MEDIA_TYPE_IS_OUTPUT(q->type);
+
+	/*
+	 * Return the number of successfully allocated buffers
+	 * to the userspace.
+	 */
+	return allocated_buffers;
+}
+
+/**
+ * vb2_core_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
+ * type values.
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
+ */
+int vb2_core_reqbufs(struct vb2_queue *q, unsigned int count, 
+		unsigned int type, unsigned int memory)
+{
+	int ret = __verify_memory_type(q, memory, type);
+	return ret ? ret : __reqbufs(q, count, type, memory);
+}
+
+/**
+ * __create_bufs() - Allocate buffers and any required auxiliary structs
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
+int __create_bufs(struct vb2_queue *q,  unsigned int count,
+		unsigned int type, unsigned int memory, void *format)
+{
+	unsigned int num_planes = 0, num_buffers, allocated_buffers;
+	int ret;
+
+	if (q->num_buffers == MEDIA_MAX_FRAME) {
+		dprintk(1, "maximum number of buffers already allocated\n");
+		return -ENOBUFS;
+	}
+
+	if (!q->num_buffers) {
+		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
+		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+		q->memory = memory;
+		q->waiting_for_buffers = !MEDIA_TYPE_IS_OUTPUT(q->type);
+	}
+
+	num_buffers = min(count, MEDIA_MAX_FRAME - q->num_buffers);
+
+	/*
+	 * Ask the driver, whether the requested number of buffers, planes per
+	 * buffer and their sizes are acceptable
+	 */
+	ret = call_qop(q, queue_setup, q, format, &num_buffers,
+		       &num_planes, q->plane_sizes, q->alloc_ctx);
+	if (ret)
+		return ret;
+
+	/* Finally, allocate buffers and video memory */
+	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
+				num_planes);
+	if (allocated_buffers == 0) {
+		dprintk(1, "memory allocation failed\n");
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
+		ret = call_qop(q, queue_setup, q, format, &num_buffers,
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
+	return allocated_buffers;
+}
+
+/**
+ * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
+ * memory and type values.
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
+ */
+int vb2_core_create_bufs(struct vb2_queue *q, unsigned int count,
+		unsigned int type, unsigned int memory, void *format)
+{
+	int ret = __verify_memory_type(q, memory, type);
+	if (count == 0)
+		return ret != -EBUSY ? ret : 0;
+	return ret ? ret : __create_bufs(q, count, type, memory, format);
+}
+
+/**
+ * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
+ * @vb:		vb2_buffer returned from the driver
+ * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
+ *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
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
+	dprintk(4, "done processing on buffer %d, state: %d\n",
+			call_priv_op(q, get_buffer_index, vb), state);
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
+	if (state == VB2_BUF_STATE_QUEUED)
+		return;
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
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
+
+	call_void_vb_qop(vb, buf_queue, vb);
+}
+
+static int __buf_prepare(struct vb2_buffer *vb, void *pb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	int ret;
+
+	ret = call_priv_op(q, verify_length, vb, pb);
+	if (ret < 0) {
+		dprintk(1, "plane parameters verification failed: %d\n", ret);
+		return ret;
+	}
+	if (call_priv_op(q, is_alternate, pb) && MEDIA_TYPE_IS_OUTPUT(q->type)) {
+		/*
+		 * If the format's field is ALTERNATE, then the buffer's field
+		 * should be either TOP or BOTTOM, not ALTERNATE since that
+		 * makes no sense. The driver has to know whether the
+		 * buffer represents a top or a bottom field in order to
+		 * program any DMA correctly. Using ALTERNATE is wrong, since
+		 * that just says that it is either a top or a bottom field,
+		 * but not which of the two it is.
+		 */
+		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
+		return -EINVAL;
+	}
+
+	if (q->error) {
+		dprintk(1, "fatal error occurred on queue\n");
+		return -EIO;
+	}
+
+	vb->state = VB2_BUF_STATE_PREPARING;
+	call_priv_op(q, init_timestamp, vb);
+
+	switch (q->memory) {
+	case V4L2_MEMORY_MMAP:
+		ret = call_priv_op(q, qbuf_mmap, vb, pb);
+		break;
+	case V4L2_MEMORY_USERPTR:
+		down_read(&current->mm->mmap_sem);
+		ret = call_priv_op(q, qbuf_userptr, vb, pb);
+		up_read(&current->mm->mmap_sem);
+		break;
+	case V4L2_MEMORY_DMABUF:
+		ret = call_priv_op(q, qbuf_dmabuf, vb, pb);
+		break;
+	default:
+		WARN(1, "Invalid queue type\n");
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		dprintk(1, "buffer preparation failed: %d\n", ret);
+	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
+
+	return ret;
+}
+
+static int vb2_queue_or_prepare_buf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *pb, const char *opname)
+{
+	int ret;
+
+	if (type != q->type) {
+		dprintk(1, "%s: invalid buffer type\n", opname);
+		return -EINVAL;
+	}
+
+	if (index >= q->num_buffers) {
+		dprintk(1, "%s: buffer index out of range\n", opname);
+		return -EINVAL;
+	}
+
+	if (q->bufs[index] == NULL) {
+		/* Should never happen */
+		dprintk(1, "%s: buffer is NULL\n", opname);
+		return -EINVAL;
+	}
+
+	if (memory != q->memory) {
+		dprintk(1, "%s: invalid memory type\n", opname);
+		return -EINVAL;
+	}
+
+	ret = call_priv_op(q, verify_planes_array, q->bufs[index], pb);
+	return ret;
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
+int vb2_core_prepare_buf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *pb)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	ret = vb2_queue_or_prepare_buf(q, type, index, memory, pb, "prepare_buf");
+	if (ret)
+		return ret;
+
+	vb = q->bufs[index];
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "invalid buffer state %d\n",
+			vb->state);
+		return -EINVAL;
+	}
+
+	ret = __buf_prepare(vb, pb);
+	if (!ret) {
+		/* Fill buffer information for the userspace */
+		call_priv_op(q, fill_priv_buffer, vb, pb);
+
+		dprintk(1, "prepare of buffer %d succeeded\n",
+				call_priv_op(q, get_buffer_index, vb));
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
+	dprintk(1, "driver refused to start streaming\n");
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
+int vb2_internal_qbuf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *pb)
+{
+	int ret = vb2_queue_or_prepare_buf(q, type, index, memory, pb, "qbuf");
+	struct vb2_buffer *vb;
+
+	if (ret)
+		return ret;
+
+	vb = q->bufs[index];
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_DEQUEUED:
+		ret = __buf_prepare(vb, pb);
+		if (ret)
+			return ret;
+		break;
+	case VB2_BUF_STATE_PREPARED:
+		break;
+	case VB2_BUF_STATE_PREPARING:
+		dprintk(1, "buffer still being prepared\n");
+		return -EINVAL;
+	default:
+		dprintk(1, "invalid buffer state %d\n", vb->state);
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
+	if (MEDIA_TYPE_IS_OUTPUT(q->type)) {
+		/*
+		 * For output buffers copy the timestamp if needed,
+		 * and the timecode field and flag if needed.
+		 */
+		call_priv_op(q, set_timestamp, vb, pb);
+	}
+
+	/*
+	 * If already streaming, give the buffer to driver for processing.
+	 * If not, the buffer will be given to driver on next streamon.
+	 */
+	if (q->start_streaming_called)
+		__enqueue_in_driver(vb);
+
+	/* Fill buffer information for the userspace */
+	call_priv_op(q, fill_priv_buffer, vb, pb);
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
+	dprintk(1, "qbuf of buffer %d succeeded\n", call_priv_op(q, get_buffer_index, vb));
+	return 0;
+}
+
+/**
+ * vb2_core_qbuf() - Queue a buffer from userspace
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
+int vb2_core_qbuf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *pb)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+
+	return vb2_internal_qbuf(q, type, index, memory, pb);
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
+			dprintk(1, "streaming off, will not wait for buffers\n");
+			return -EINVAL;
+		}
+
+		if (q->error) {
+			dprintk(1, "Queue in error state, will not wait for buffers\n");
+			return -EIO;
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
+			dprintk(1, "nonblocking and no buffers to dequeue, "
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
+		dprintk(3, "will sleep waiting for buffers\n");
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
+			dprintk(1, "sleep was interrupted\n");
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
+	call_priv_op(q, verify_planes_array, *vb, pb);
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
+		dprintk(1, "streaming off, will not wait for buffers\n");
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
+	if (q->memory == MEDIA_MEMORY_DMABUF)
+		for (i = 0; i < vb->num_planes; ++i) {
+			if (!vb->planes[i].dbuf_mapped)
+				continue;
+			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
+			vb->planes[i].dbuf_mapped = 0;
+		}
+}
+
+int vb2_internal_dqbuf(struct vb2_queue *q, enum media_buf_type type, void *pb,
+		bool nonblocking)
+{
+	struct vb2_buffer *vb = NULL;
+	int ret;
+
+	if (type != q->type) {
+		dprintk(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+	ret = __vb2_get_done_vb(q, &vb, pb, nonblocking);
+	if (ret < 0)
+		return ret;
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_DONE:
+		dprintk(3, "returning done buffer\n");
+		break;
+	case VB2_BUF_STATE_ERROR:
+		dprintk(3, "returning done buffer with errors\n");
+		break;
+	default:
+		dprintk(1, "invalid buffer state\n");
+		return -EINVAL;
+	}
+
+	call_void_vb_qop(vb, buf_finish, vb);
+
+	/* Fill buffer information for the userspace */
+	call_priv_op(q, fill_priv_buffer, vb, pb);
+	/* Remove from videobuf queue */
+	list_del(&vb->queued_entry);
+	q->queued_count--;
+	/* go back to dequeued state */
+	__vb2_dqbuf(vb);
+
+	dprintk(1, "dqbuf of buffer %d, with state %d\n",
+			call_priv_op(q, get_buffer_index, vb), vb->state);
+
+	return 0;
+}
+
+/**
+ * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
+ *		in driver
+ * @nonblocking: if true, this call will not sleep waiting for a buffer if no
+ *		 buffers ready for dequeuing are present. Normally the driver
+ *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *
+ * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_finish callback in the driver (if provided), in which
+ *    driver can perform any additional operations that may be required before
+ *    returning the buffer to userspace, such as cache sync,
+ * 3) the buffer struct members are filled with relevant information for
+ *    the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_dqbuf handler in driver.
+ */
+int vb2_core_dqbuf(struct vb2_queue *q, enum media_buf_type type, void *pb,
+		bool nonblocking)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_internal_dqbuf(q, type, pb, nonblocking);
+}
+
+/**
+ * __vb2_queue_cancel() - cancel and stop (pause) streaming
+ *
+ * Removes all queued buffers from driver's queue and all buffers queued by
+ * userspace from videobuf's queue. Returns to state after reqbufs.
+ */
+void __vb2_queue_cancel(struct vb2_queue *q)
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
+int vb2_internal_streamon(struct vb2_queue *q, enum media_buf_type type)
+{
+	int ret;
+
+	if (type != q->type) {
+		dprintk(1, "invalid stream type\n");
+		return -EINVAL;
+	}
+
+	if (q->streaming) {
+		dprintk(3, "already streaming\n");
+		return 0;
+	}
+
+	if (!q->num_buffers) {
+		dprintk(1, "no buffers have been allocated\n");
+		return -EINVAL;
+	}
+
+	if (q->num_buffers < q->min_buffers_needed) {
+		dprintk(1, "need at least %u allocated buffers\n",
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
+	dprintk(3, "successful\n");
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
+/**
+ * vb2_core_streamon - start streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamon handler
+ *
+ * Should be called from vidioc_streamon handler of a driver.
+ * This function:
+ * 1) verifies current state
+ * 2) passes any previously queued buffers to the driver and starts streaming
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamon handler in the driver.
+ */
+int vb2_core_streamon(struct vb2_queue *q, enum media_buf_type type)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_internal_streamon(q, type);
+}
+
+int vb2_internal_streamoff(struct vb2_queue *q, enum media_buf_type type)
+{
+	if (type != q->type) {
+		dprintk(1, "invalid stream type\n");
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
+	q->waiting_for_buffers = !MEDIA_TYPE_IS_OUTPUT(q->type);
+
+	dprintk(3, "successful\n");
+	return 0;
+}
+
+/**
+ * vb2_streamoff - stop streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamoff handler
+ *
+ * Should be called from vidioc_streamoff handler of a driver.
+ * This function:
+ * 1) verifies current state,
+ * 2) stop streaming and dequeues any queued buffers, including those previously
+ *    passed to the driver (after waiting for the driver to finish).
+ *
+ * This call can be used for pausing playback.
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamoff handler in the driver
+ */
+int vb2_core_streamoff(struct vb2_queue *q, enum media_buf_type type)
+{
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "file io in progress\n");
+		return -EBUSY;
+	}
+	return vb2_internal_streamoff(q, type);
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
+	if (q->memory != MEDIA_MEMORY_MMAP) {
+		dprintk(1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (!q->mem_ops->get_dmabuf) {
+		dprintk(1, "queue does not support DMA buffer exporting\n");
+		return -EINVAL;
+	}
+
+	if (flags & ~(O_CLOEXEC | O_ACCMODE)) {
+		dprintk(1, "queue does support only O_CLOEXEC and access mode flags\n");
+		return -EINVAL;
+	}
+
+	if (type != q->type) {
+		dprintk(1, "invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	if (index >= q->num_buffers) {
+		dprintk(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+
+	vb = q->bufs[index];
+
+	if (plane >= vb->num_planes) {
+		dprintk(1, "buffer plane out of range\n");
+		return -EINVAL;
+	}
+
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "expbuf: file io in progress\n");
+		return -EBUSY;
+	}
+
+	vb_plane = &vb->planes[plane];
+
+	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, flags & O_ACCMODE);
+	if (IS_ERR_OR_NULL(dbuf)) {
+		dprintk(1, "failed to export buffer %d, plane %d\n", index, plane);
+		return -EINVAL;
+	}
+
+	ret = dma_buf_fd(dbuf, flags & ~O_ACCMODE);
+	if (ret < 0) {
+		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
+			index, plane, ret);
+		dma_buf_put(dbuf);
+		return ret;
+	}
+
+	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
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
+	if (q->memory != MEDIA_MEMORY_MMAP) {
+		dprintk(1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Check memory area access mode.
+	 */
+	if (!(vma->vm_flags & VM_SHARED)) {
+		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
+		return -EINVAL;
+	}
+	if (MEDIA_TYPE_IS_OUTPUT(q->type)) {
+		if (!(vma->vm_flags & VM_WRITE)) {
+			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
+			return -EINVAL;
+		}
+	} else {
+		if (!(vma->vm_flags & VM_READ)) {
+			dprintk(1, "invalid vma flags, VM_READ needed\n");
+			return -EINVAL;
+		}
+	}
+	if (vb2_fileio_is_active(q)) {
+		dprintk(1, "mmap: file io in progress\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Find the plane corresponding to the offset passed by userspace.
+	 */
+	ret = call_priv_op(q, find_plane_by_offset, q, off, &buffer, &plane);
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
+	length = call_priv_op(q, get_plane_length, vb, plane);
+	length = PAGE_ALIGN(length);
+	if (length < (vma->vm_end - vma->vm_start)) {
+		dprintk(1,
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
+	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
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
+	if (q->memory != MEDIA_MEMORY_MMAP) {
+		dprintk(1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Find the plane corresponding to the offset passed by userspace.
+	 */
+	ret = call_priv_op(q, find_plane_by_offset, q, off, &buffer, &plane);
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
 
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index fe07a2b..62fb5ae 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -30,113 +30,12 @@
 #include <media/v4l2-common.h>
 #include <media/videobuf2-v4l2.h>
 
-static int debug;
-module_param(debug, int, 0644);
-
-#define dprintk(level, fmt, arg...)					      \
-	do {								      \
-		if (debug >= level)					      \
-			pr_info("vb2: %s: " fmt, __func__, ## arg); \
+#define dprintk(level, fmt, arg...)						\
+	do {												\
+		if (get_vb2_debug() >= level)					\
+		pr_info("vb2: %s: " fmt, __func__, ## arg);		\
 	} while (0)
 
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
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
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
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
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
 
 #define call_memop(vb, op, args...)					\
 	((vb)->vb2_queue->mem_ops->op ?					\
@@ -170,7 +69,6 @@ module_param(debug, int, 0644);
 			(vb)->vb2_queue->ops->op(args);			\
 	} while (0)
 
-#endif
 
 /* Flags that are set by the vb2 core */
 #define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
@@ -181,3398 +79,1799 @@ module_param(debug, int, 0644);
 #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
 				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
 
-static void __vb2_queue_cancel(struct vb2_queue *q);
-
 /**
- * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
+ * vb2_querybuf() - Wrapper for vb2_core_querybuf()
  */
-static int __vb2_buf_mem_alloc(struct vb2_v4l2_buffer *cb)
+int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *pb)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	struct vb2_queue *q = vb->vb2_queue;
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
-
-		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, dma_dir, q->gfp_flags);
-		if (IS_ERR_OR_NULL(mem_priv))
-			goto free;
-
-		/* Associate allocator private data with this plane */
-		vb->planes[plane].mem_priv = mem_priv;
-		cb->v4l2_planes[plane].length = q->plane_sizes[plane];
-	}
-
-	return 0;
-free:
-	/* Free already allocated memory if one of the allocations failed */
-	for (; plane > 0; --plane) {
-		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
-		vb->planes[plane - 1].mem_priv = NULL;
-	}
-
-	return -ENOMEM;
+	int ret = vb2_core_querybuf(q, pb->type, pb->index, (void *)pb);
+	return ret;
 }
+EXPORT_SYMBOL(vb2_querybuf);
 
 /**
- * __vb2_buf_mem_free() - free memory of the given buffer
+ * vb2_reqbufs() - Wrapper for vb2_core_reqbufs()
  */
-static void __vb2_buf_mem_free(struct vb2_v4l2_buffer *cb)
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	unsigned int plane;
+	int ret = vb2_core_reqbufs(q, req->count, req->type, req->memory);
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		call_void_memop(vb, put, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
-		dprintk(3, "freed plane %d of buffer %d\n", plane,
-			cb->v4l2_buf.index);
+	if(ret>0)
+	{
+		req->count = ret;
+		return 0;
 	}
+	else req->count = 0;
+
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
- * __vb2_buf_userptr_put() - release userspace memory associated with
- * a USERPTR buffer
+ * vb2_create_bufs() - Wrapper for vb2_core_create_bufs()
  */
-static void __vb2_buf_userptr_put(struct vb2_v4l2_buffer *cb)
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	unsigned int plane;
+	int ret;
 
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
+	create->index = q->num_buffers;
+	ret = vb2_core_create_bufs(q, create->count, create->format.type,
+			create->memory, (void *)&create->format);
+	if(ret>0)
+	{
+		create->count = ret;
+		return 0;
 	}
+	else create->count = 0;
+
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
- * __vb2_plane_dmabuf_put() - release memory associated with
- * a DMABUF shared plane
+ * vb2_prepare_buf() - Wrapper for vb2_core_prepare_buf()
  */
-static void __vb2_plane_dmabuf_put(struct vb2_v4l2_buffer *cb, struct vb2_plane *p)
+int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	if (!p->mem_priv)
-		return;
-
-	if (p->dbuf_mapped)
-		call_void_memop(vb, unmap_dmabuf, p->mem_priv);
-
-	call_void_memop(vb, detach_dmabuf, p->mem_priv);
-	dma_buf_put(p->dbuf);
-	memset(p, 0, sizeof(*p));
+	int ret = vb2_core_prepare_buf(q, b->type, b->index, b->memory, (void *)b);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
 /**
- * __vb2_buf_dmabuf_put() - release memory associated with
- * a DMABUF shared buffer
+ * vb2_qbuf() - Wrapper for vb2_core_qbuf()
  */
-static void __vb2_buf_dmabuf_put(struct vb2_v4l2_buffer *cb)
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	unsigned int plane;
-
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		__vb2_plane_dmabuf_put(cb, &vb->planes[plane]);
+	int ret = vb2_core_qbuf(q, b->type, b->index, b->memory, (void *)b);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_qbuf);
 
 /**
- * __setup_lengths() - setup initial lengths for every plane in
- * every buffer on the queue
+ * vb2_dqbuf() - Wrapper for vb2_core_dqbuf()
  */
-static void __setup_lengths(struct vb2_queue *q, unsigned int n)
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
-	unsigned int buffer, plane;
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-
-	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-
-		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-		for (plane = 0; plane < vb->num_planes; ++plane)
-			cb->v4l2_planes[plane].length = q->plane_sizes[plane];
-	}
+	int ret = vb2_core_dqbuf(q, b->type, (void *)b, nonblocking);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 /**
- * __setup_offsets() - setup unique offsets ("cookies") for every plane in
- * every buffer on the queue
+ * vb2_streamon - Wrapper for vb2_core_streamon()
  */
-static void __setup_offsets(struct vb2_queue *q, unsigned int n)
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	unsigned int buffer, plane;
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-	unsigned long off;
-
-	if (q->num_buffers) {
-		struct v4l2_plane *p;
-		vb = q->bufs[q->num_buffers - 1];
-		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-		p = &cb->v4l2_planes[vb->num_planes - 1];
-		off = PAGE_ALIGN(p->m.mem_offset + p->length);
-	} else {
-		off = 0;
-	}
-
-	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-
-		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			cb->v4l2_planes[plane].m.mem_offset = off;
-
-			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
-					buffer, plane, off);
-
-			off += cb->v4l2_planes[plane].length;
-			off = PAGE_ALIGN(off);
-		}
-	}
+	return vb2_core_streamon(q, type);
 }
+EXPORT_SYMBOL_GPL(vb2_streamon);
 
 /**
- * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
- * video buffer memory for all buffers/planes on the queue and initializes the
- * queue
- *
- * Returns the number of buffers successfully allocated.
+ * vb2_streamoff - Wrapper for vb2_streamoff()
  */
-static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
-			     unsigned int num_buffers, unsigned int num_planes)
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	unsigned int buffer;
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-	int ret;
-
-	for (buffer = 0; buffer < num_buffers; ++buffer) {
-		/* Allocate videobuf buffer structures */
-		cb = kzalloc(q->buf_struct_size, GFP_KERNEL);
-		if (!cb) {
-			dprintk(1, "memory alloc for buffer struct failed\n");
-			break;
-		}
-
-		vb = &cb->vb2;
-		/* Length stores number of planes for multiplanar buffers */
-		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
-			cb->v4l2_buf.length = num_planes;
-
-		vb->state = VB2_BUF_STATE_DEQUEUED;
-		vb->vb2_queue = q;
-		vb->num_planes = num_planes;
-		cb->v4l2_buf.index = q->num_buffers + buffer;
-		cb->v4l2_buf.type = q->type;
-		cb->v4l2_buf.memory = memory;
-
-		/* Allocate video buffer memory for the MMAP type */
-		if (memory == V4L2_MEMORY_MMAP) {
-			ret = __vb2_buf_mem_alloc(cb);
-			if (ret) {
-				dprintk(1, "failed allocating memory for "
-						"buffer %d\n", buffer);
-				kfree(cb);
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
-				__vb2_buf_mem_free(cb);
-				kfree(cb);
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
-
-	return buffer;
+	return vb2_core_streamoff(q, type);
 }
+EXPORT_SYMBOL_GPL(vb2_streamoff);
 
 /**
- * __vb2_free_mem() - release all video buffer memory for a given queue
+ * vb2_expbuf() - Wrapper for vb2_core_expbuf()
  */
-static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
 {
-	unsigned int buffer;
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	int ret = vb2_core_expbuf(q, eb->type, eb->index, eb->plane, eb->flags);
 
-		/* Free MMAP buffers or release USERPTR buffers */
-		if (q->memory == V4L2_MEMORY_MMAP)
-			__vb2_buf_mem_free(cb);
-		else if (q->memory == V4L2_MEMORY_DMABUF)
-			__vb2_buf_dmabuf_put(cb);
-		else
-			__vb2_buf_userptr_put(cb);
+	if(ret>0)
+	{
+		eb->fd = ret;
+		return 0;
 	}
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_expbuf);
+
+static int __vb2_init_fileio(struct vb2_queue *q, int read);
+static int __vb2_cleanup_fileio(struct vb2_queue *q);
 
 /**
- * __vb2_queue_free() - free buffers at the end of the queue - video memory and
- * related information, if no buffers are left return the queue to an
- * uninitialized state. Might be called even if the queue has already been freed.
+ * vb2_poll() - implements poll userspace operation
+ * @q:		videobuf2 queue
+ * @file:	file argument passed to the poll file operation handler
+ * @wait:	wait argument passed to the poll file operation handler
+ *
+ * This function implements poll file operation handler for a driver.
+ * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
+ * be informed that the file descriptor of a video device is available for
+ * reading.
+ * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
+ * will be reported as available for writing.
+ *
+ * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
+ * pending events.
+ *
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
  */
-static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
-	unsigned int buffer;
-	struct vb2_buffer *vb;
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
-		vb = q->bufs[buffer];
-
-		if (vb == NULL)
-			continue;
-		if (vb->state == VB2_BUF_STATE_PREPARING) {
-			dprintk(1, "preparing buffers, cannot free\n");
-			return -EAGAIN;
-		}
-	}
+	struct video_device *vfd = video_devdata(file);
+	unsigned long req_events = poll_requested_events(wait);
+	struct vb2_buffer *vb = NULL;
+	unsigned int res = 0;
+	unsigned long flags;
 
-	/* Call driver-provided cleanup function for each buffer, if provided */
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		vb = q->bufs[buffer];
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
 
-		if (vb && vb->planes[0].mem_priv)
-			call_void_vb_qop(vb, buf_cleanup, vb);
+		if (v4l2_event_pending(fh))
+			res = POLLPRI;
+		else if (req_events & POLLPRI)
+			poll_wait(file, &fh->wait, wait);
 	}
 
-	/* Release video buffer memory */
-	__vb2_free_mem(q, buffers);
+	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
+		return res;
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
-	 * Check that all the calls were balances during the life-time of this
-	 * queue. If not (or if the debug level is 1 or up), then dump the
-	 * counters to the kernel log.
+	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
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
+	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM))) {
+			if (__vb2_init_fileio(q, 1))
+				return res | POLLERR;
 		}
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
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM))) {
+			if (__vb2_init_fileio(q, 0))
+				return res | POLLERR;
+			/*
+			 * Write to OUTPUT queue can be done immediately.
+			 */
+			return res | POLLOUT | POLLWRNORM;
 		}
 	}
-#endif
-
-	/* Free videobuf buffers */
-	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
-	     ++buffer) {
-		kfree(q->bufs[buffer]);
-		q->bufs[buffer] = NULL;
-	}
 
-	q->num_buffers -= buffers;
-	if (!q->num_buffers) {
-		q->memory = 0;
-		INIT_LIST_HEAD(&q->queued_list);
-	}
-	return 0;
-}
+	/*
+	 * There is nothing to wait for if the queue isn't streaming, or if the
+	 * error flag is set.
+	 */
+	if (!vb2_is_streaming(q) || q->error)
+		return res | POLLERR;
+	/*
+	 * For compatibility with vb1: if QBUF hasn't been called yet, then
+	 * return POLLERR as well. This only affects capture queues, output
+	 * queues will always initialize waiting_for_buffers to false.
+	 */
+	if (q->waiting_for_buffers)
+		return res | POLLERR;
 
-/**
- * __verify_planes_array() - verify that the planes array passed in struct
- * v4l2_buffer from userspace can be safely used
- */
-static int __verify_planes_array(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb = &cb->vb2;
+	/*
+	 * For output streams you can write as long as there are fewer buffers
+	 * queued than there are buffers available.
+	 */
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
+		return res | POLLOUT | POLLWRNORM;
 
-	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
-		return 0;
+	if (list_empty(&q->done_list))
+		poll_wait(file, &q->done_wq, wait);
 
-	/* Is memory for copying plane information present? */
-	if (NULL == b->m.planes) {
-		dprintk(1, "multi-planar buffer passed but "
-			   "planes array not provided\n");
-		return -EINVAL;
-	}
+	/*
+	 * Take first buffer available for dequeuing.
+	 */
+	spin_lock_irqsave(&q->done_lock, flags);
+	if (!list_empty(&q->done_list))
+		vb = list_first_entry(&q->done_list, struct vb2_buffer,
+					done_entry);
+	spin_unlock_irqrestore(&q->done_lock, flags);
 
-	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
-		dprintk(1, "incorrect planes array length, "
-			   "expected %d, got %d\n", vb->num_planes, b->length);
-		return -EINVAL;
+	if (vb && (vb->state == VB2_BUF_STATE_DONE
+			|| vb->state == VB2_BUF_STATE_ERROR)) {
+		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
+				res | POLLOUT | POLLWRNORM :
+				res | POLLIN | POLLRDNORM;
 	}
-
-	return 0;
+	return res;
 }
+EXPORT_SYMBOL_GPL(vb2_poll);
 
+const struct vb2_priv_ops vb2_v4l2_operations;
 /**
- * __verify_length() - Verify that the bytesused value for each plane fits in
- * the plane length and that the data offset doesn't exceed the bytesused value.
+ * vb2_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ *
+ * The vb2_queue structure should be allocated by the driver. The driver is
+ * responsible of clearing it's content and setting initial values for some
+ * required entries before calling this function.
+ * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
+ * to the struct vb2_queue description in include/media/videobuf2-core.h
+ * for more information.
  */
-static int __verify_length(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
+int vb2_queue_init(struct vb2_queue *q)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	unsigned int length;
-	unsigned int bytesused;
-	unsigned int plane;
+	/*
+	 * Sanity check
+	 */
+	if (WARN_ON(!q)			  ||
+	    WARN_ON(!q->ops)		  ||
+	    WARN_ON(!q->mem_ops)	  ||
+	    WARN_ON(!q->type)		  ||
+	    WARN_ON(!q->io_modes)	  ||
+	    WARN_ON(!q->ops->queue_setup) ||
+	    WARN_ON(!q->ops->buf_queue)   ||
+	    WARN_ON(q->timestamp_flags &
+		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
+		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
+		return -EINVAL;
 
-	if (!V4L2_TYPE_IS_OUTPUT(b->type))
-		return 0;
+	/* Warn that the driver should choose an appropriate timestamp type */
+	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			length = (b->memory == V4L2_MEMORY_USERPTR ||
-				  b->memory == V4L2_MEMORY_DMABUF)
-			       ? b->m.planes[plane].length
-			       : cb->v4l2_planes[plane].length;
-			bytesused = b->m.planes[plane].bytesused
-				  ? b->m.planes[plane].bytesused : length;
+	INIT_LIST_HEAD(&q->queued_list);
+	INIT_LIST_HEAD(&q->done_list);
+	spin_lock_init(&q->done_lock);
+	mutex_init(&q->mmap_lock);
+	init_waitqueue_head(&q->done_wq);
 
-			if (b->m.planes[plane].bytesused > length)
-				return -EINVAL;
 
-			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >= bytesused)
-				return -EINVAL;
-		}
-	} else {
-		length = (b->memory == V4L2_MEMORY_USERPTR)
-		       ? b->length : cb->v4l2_planes[0].length;
-		bytesused = b->bytesused ? b->bytesused : length;
+	q->priv_ops = &vb2_v4l2_operations;
 
-		if (b->bytesused > length)
-			return -EINVAL;
-	}
+	if (q->buf_struct_size == 0)
+		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_queue_init);
 
 /**
- * __buffer_in_use() - return true if the buffer is in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
+ * vb2_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
  */
-static bool __buffer_in_use(struct vb2_queue *q, struct vb2_v4l2_buffer *cb)
+void vb2_queue_release(struct vb2_queue *q)
 {
-	struct vb2_buffer *vb = &cb->vb2;
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
+	__vb2_cleanup_fileio(q);
+	__vb2_queue_cancel(q);
+	mutex_lock(&q->mmap_lock);
+	__vb2_queue_free(q, q->num_buffers);
+	mutex_unlock(&q->mmap_lock);
 }
+EXPORT_SYMBOL_GPL(vb2_queue_release);
 
 /**
- * __buffers_in_use() - return true if any buffers on the queue are in use and
- * the queue cannot be freed (by the means of REQBUFS(0)) call
+ * struct vb2_fileio_buf - buffer context used by file io emulator
+ *
+ * vb2 provides a compatibility layer and emulator of file io (read and
+ * write) calls on top of streaming API. This structure is used for
+ * tracking context related to the buffers.
  */
-static bool __buffers_in_use(struct vb2_queue *q)
-{
-	struct vb2_v4l2_buffer *cb;
-	unsigned int buffer;
+struct vb2_fileio_buf {
+	void *vaddr;
+	unsigned int size;
+	unsigned int pos;
+	unsigned int queued:1;
+};
 
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		cb = container_of(q->bufs[buffer], struct vb2_v4l2_buffer, vb2);
-		if (__buffer_in_use(q, cb))
-			return true;
-	}
-	return false;
-}
+/**
+ * struct vb2_fileio_data - queue context used by file io emulator
+ *
+ * @cur_index:	the index of the buffer currently being read from or
+ *		written to. If equal to q->num_buffers then a new buffer
+ *		must be dequeued.
+ * @initial_index: in the read() case all buffers are queued up immediately
+ *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
+ *		buffers. However, in the write() case no buffers are initially
+ *		queued, instead whenever a buffer is full it is queued up by
+ *		__vb2_perform_fileio(). Only once all available buffers have
+ *		been queued up will __vb2_perform_fileio() start to dequeue
+ *		buffers. This means that initially __vb2_perform_fileio()
+ *		needs to know what buffer index to use when it is queuing up
+ *		the buffers for the first time. That initial index is stored
+ *		in this field. Once it is equal to q->num_buffers all
+ *		available buffers have been queued and __vb2_perform_fileio()
+ *		should start the normal dequeue/queue cycle.
+ *
+ * vb2 provides a compatibility layer and emulator of file io (read and
+ * write) calls on top of streaming API. For proper operation it required
+ * this structure to save the driver state between each call of the read
+ * or write function.
+ */
+struct vb2_fileio_data {
+	struct v4l2_requestbuffers req;
+	struct v4l2_plane p;
+	struct v4l2_buffer b;
+	struct vb2_fileio_buf bufs[MEDIA_MAX_FRAME];
+	unsigned int cur_index;
+	unsigned int initial_index;
+	unsigned int q_count;
+	unsigned int dq_count;
+	unsigned int flags;
+};
 
 /**
- * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
- * returned to userspace
+ * __vb2_init_fileio() - initialize file io emulator
+ * @q:		videobuf2 queue
+ * @read:	mode selector (1 means read, 0 means write)
  */
-static void __fill_v4l2_buffer(struct vb2_v4l2_buffer *cb, struct v4l2_buffer *b)
+static int __vb2_init_fileio(struct vb2_queue *q, int read)
 {
-	struct vb2_buffer *vb = &cb->vb2;
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_fileio_data *fileio;
+	int i, ret;
+	unsigned int count = 0;
 
-	/* Copy back data such as timestamp, flags, etc. */
-	memcpy(b, &cb->v4l2_buf, offsetof(struct v4l2_buffer, m));
-	b->reserved2 = cb->v4l2_buf.reserved2;
-	b->reserved = cb->v4l2_buf.reserved;
+	/*
+	 * Sanity check
+	 */
+	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
+		    (!read && !(q->io_modes & VB2_WRITE))))
+		return -EINVAL;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
-		/*
-		 * Fill in plane-related data if userspace provided an array
-		 * for it. The caller has already verified memory and size.
-		 */
-		b->length = vb->num_planes;
-		memcpy(b->m.planes, cb->v4l2_planes,
-			b->length * sizeof(struct v4l2_plane));
-	} else {
-		/*
-		 * We use length and offset in v4l2_planes array even for
-		 * single-planar buffers, but userspace does not.
-		 */
-		b->length = cb->v4l2_planes[0].length;
-		b->bytesused = cb->v4l2_planes[0].bytesused;
-		if (q->memory == V4L2_MEMORY_MMAP)
-			b->m.offset = cb->v4l2_planes[0].m.mem_offset;
-		else if (q->memory == V4L2_MEMORY_USERPTR)
-			b->m.userptr = cb->v4l2_planes[0].m.userptr;
-		else if (q->memory == V4L2_MEMORY_DMABUF)
-			b->m.fd = cb->v4l2_planes[0].m.fd;
-	}
+	/*
+	 * Check if device supports mapping buffers to kernel virtual space.
+	 */
+	if (!q->mem_ops->vaddr)
+		return -EBUSY;
 
 	/*
-	 * Clear any buffer state related flags.
+	 * Check if streaming api has not been already activated.
 	 */
-	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
-	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
-	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
-		/*
-		 * For non-COPY timestamps, drop timestamp source bits
-		 * and obtain the timestamp source from the queue.
-		 */
-		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	}
+	if (q->streaming || q->num_buffers > 0)
+		return -EBUSY;
 
-	switch (vb->state) {
-	case VB2_BUF_STATE_QUEUED:
-	case VB2_BUF_STATE_ACTIVE:
-		b->flags |= V4L2_BUF_FLAG_QUEUED;
-		break;
-	case VB2_BUF_STATE_ERROR:
-		b->flags |= V4L2_BUF_FLAG_ERROR;
-		/* fall through */
-	case VB2_BUF_STATE_DONE:
-		b->flags |= V4L2_BUF_FLAG_DONE;
-		break;
-	case VB2_BUF_STATE_PREPARED:
-		b->flags |= V4L2_BUF_FLAG_PREPARED;
-		break;
-	case VB2_BUF_STATE_PREPARING:
-	case VB2_BUF_STATE_DEQUEUED:
-		/* nothing */
-		break;
-	}
+	/*
+	 * Start with count 1, driver can increase it in queue_setup()
+	 */
+	count = 1;
 
-	if (__buffer_in_use(q, cb))
-		b->flags |= V4L2_BUF_FLAG_MAPPED;
-}
+	dprintk(3, "setting up file io: mode %s, count %d, flags %08x\n",
+		(read) ? "read" : "write", count, q->io_flags);
 
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
-	struct vb2_v4l2_buffer *cb;
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
-	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-	ret = __verify_planes_array(cb, b);
-	if (!ret)
-		__fill_v4l2_buffer(cb, b);
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
-
-	return 0;
-}
-
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
+	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
+	if (fileio == NULL)
+		return -ENOMEM;
 
-	if (type != q->type) {
-		dprintk(1, "requested type is incorrect\n");
-		return -EINVAL;
-	}
+	fileio->flags = q->io_flags;
 
 	/*
-	 * Make sure all the required memory ops for given memory type
-	 * are available.
+	 * Request buffers and use MMAP type to force driver
+	 * to allocate buffers by itself.
 	 */
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
+	fileio->req.count = count;
+	fileio->req.memory = MEDIA_MEMORY_MMAP;
+	fileio->req.type = q->type;
+	q->fileio = fileio;
+	ret = vb2_core_reqbufs(q, count, q->type, MEDIA_MEMORY_MMAP);
+	if (ret)
+		goto err_kfree;
 
 	/*
-	 * Place the busy tests at the end: -EBUSY can be ignored when
-	 * create_bufs is called with count == 0, but count == 0 should still
-	 * do the memory and type validation.
+	 * Check if plane_count is correct
+	 * (multiplane buffers are not supported).
 	 */
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
- * 4) allocates internal buffer structures (struct vb2_v4l2_buffer), according to
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
+	if (q->bufs[0]->num_planes != 1) {
+		ret = -EBUSY;
+		goto err_reqbufs;
 	}
 
 	/*
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
+	 * Get kernel address of each buffer.
 	 */
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
+	for (i = 0; i < q->num_buffers; i++) {
+		struct vb2_v4l2_buffer *cb = container_of(q->bufs[i], struct vb2_v4l2_buffer, vb2);
+		fileio->bufs[i].vaddr = vb2_plane_vaddr(cb, 0);
+		if (fileio->bufs[i].vaddr == NULL) {
+			ret = -EINVAL;
+			goto err_reqbufs;
+		}
+		fileio->bufs[i].size = vb2_plane_size(cb, 0);
 	}
 
 	/*
-	 * There is no point in continuing if we can't allocate the minimum
-	 * number of buffers needed by this vb2_queue.
-	 */
-	if (allocated_buffers < q->min_buffers_needed)
-		ret = -ENOMEM;
-
-	/*
-	 * Check if driver can handle the allocated number of buffers.
+	 * Read mode requires pre queuing of all buffers.
 	 */
-	if (!ret && allocated_buffers < num_buffers) {
-		num_buffers = allocated_buffers;
-
-		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
-			       &num_planes, q->plane_sizes, q->alloc_ctx);
-
-		if (!ret && allocated_buffers < num_buffers)
-			ret = -ENOMEM;
+	if (read) {
+		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
 
 		/*
-		 * Either the driver has accepted a smaller number of buffers,
-		 * or .queue_setup() returned an error
+		 * Queue all buffers.
 		 */
-	}
-
-	mutex_lock(&q->mmap_lock);
-	q->num_buffers = allocated_buffers;
+		for (i = 0; i < q->num_buffers; i++) {
+			struct v4l2_buffer *b = &fileio->b;
 
-	if (ret < 0) {
+			memset(b, 0, sizeof(*b));
+			b->type = q->type;
+			if (is_multiplanar) {
+				memset(&fileio->p, 0, sizeof(fileio->p));
+				b->m.planes = &fileio->p;
+				b->length = 1;
+			}
+			b->memory = q->memory;
+			b->index = i;
+			ret = vb2_internal_qbuf(q, q->type, i, q->memory, b);
+			if (ret)
+				goto err_reqbufs;
+			fileio->bufs[i].queued = 1;
+		}
 		/*
-		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * All buffers have been queued, so mark that by setting
+		 * initial_index to q->num_buffers
 		 */
-		__vb2_queue_free(q, allocated_buffers);
-		mutex_unlock(&q->mmap_lock);
-		return ret;
+		fileio->initial_index = q->num_buffers;
+		fileio->cur_index = q->num_buffers;
 	}
-	mutex_unlock(&q->mmap_lock);
 
 	/*
-	 * Return the number of successfully allocated buffers
-	 * to the userspace.
+	 * Start streaming.
 	 */
-	req->count = allocated_buffers;
-	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
+	ret = vb2_internal_streamon(q, q->type);
+	if (ret)
+		goto err_reqbufs;
 
-	return 0;
+	return ret;
+
+err_reqbufs:
+	vb2_core_reqbufs(q, 0, q->type, MEDIA_MEMORY_MMAP);
+
+err_kfree:
+	q->fileio = NULL;
+	kfree(fileio);
+	return ret;
 }
 
 /**
- * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
- * type values.
+ * __vb2_cleanup_fileio() - free resourced used by file io emulator
  * @q:		videobuf2 queue
- * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
  */
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+static int __vb2_cleanup_fileio(struct vb2_queue *q)
 {
-	int ret = __verify_memory_type(q, req->memory, req->type);
+	struct vb2_fileio_data *fileio = q->fileio;
 
-	return ret ? ret : __reqbufs(q, req);
+	if (fileio) {
+		vb2_internal_streamoff(q, q->type);
+		q->fileio = NULL;
+		fileio->req.count = 0;
+		vb2_reqbufs(q, &fileio->req);
+		kfree(fileio);
+		dprintk(3, "file io emulator closed\n");
+	}
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
- * __create_bufs() - Allocate buffers and any required auxiliary structs
+ * __vb2_perform_fileio() - perform a single file io (read or write) operation
  * @q:		videobuf2 queue
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
+ * @data:	pointed to target userspace buffer
+ * @count:	number of bytes to read or write
+ * @ppos:	file handle position tracking pointer
+ * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
+ * @read:	access mode selector (1 means read, 0 means write)
  */
-static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblock, int read)
 {
-	unsigned int num_planes = 0, num_buffers, allocated_buffers;
-	int ret;
+	struct vb2_fileio_data *fileio;
+	struct vb2_fileio_buf *buf;
+	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+	struct vb2_v4l2_buffer *cb;
 
-	if (q->num_buffers == VIDEO_MAX_FRAME) {
-		dprintk(1, "maximum number of buffers already allocated\n");
-		return -ENOBUFS;
-	}
+	/*
+	 * When using write() to write data to an output video node the vb2 core
+	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
+	 * else is able to provide this information with the write() operation.
+	 */
+	bool set_timestamp = !read &&
+		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	int ret, index;
 
-	if (!q->num_buffers) {
-		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
-		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
-		q->memory = create->memory;
-		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
-	}
+	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
+		read ? "read" : "write", (long)*ppos, count,
+		nonblock ? "non" : "");
 
-	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
+	if (!data)
+		return -EINVAL;
 
 	/*
-	 * Ask the driver, whether the requested number of buffers, planes per
-	 * buffer and their sizes are acceptable
+	 * Initialize emulator on first call.
 	 */
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
+	if (!vb2_fileio_is_active(q)) {
+		ret = __vb2_init_fileio(q, read);
+		dprintk(3, "vb2_init_fileio result: %d\n", ret);
+		if (ret)
+			return ret;
 	}
+	fileio = q->fileio;
 
 	/*
-	 * Check if driver can handle the so far allocated number of buffers.
+	 * Check if we need to dequeue the buffer.
 	 */
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
+	index = fileio->cur_index;
+	if (index >= q->num_buffers) {
 		/*
-		 * Either the driver has accepted a smaller number of buffers,
-		 * or .queue_setup() returned an error
+		 * Call vb2_dqbuf to get buffer back.
 		 */
-	}
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		if (is_multiplanar) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
+		ret = vb2_internal_dqbuf(q, q->type, &fileio->b, nonblock);
+		dprintk(5, "vb2_dqbuf result: %d\n", ret);
+		if (ret)
+			return ret;
+		fileio->dq_count += 1;
 
-	mutex_lock(&q->mmap_lock);
-	q->num_buffers += allocated_buffers;
+		fileio->cur_index = index = fileio->b.index;
+		buf = &fileio->bufs[index];
 
-	if (ret < 0) {
 		/*
-		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * Get number of bytes filled by the driver
 		 */
-		__vb2_queue_free(q, allocated_buffers);
-		mutex_unlock(&q->mmap_lock);
-		return -ENOMEM;
+		buf->pos = 0;
+		buf->queued = 0;
+		cb = container_of(q->bufs[index], struct vb2_v4l2_buffer, vb2);
+		buf->size = read ? vb2_get_plane_payload(cb, 0)
+				 : vb2_plane_size(cb, 0);
+		/* Compensate for data_offset on read in the multiplanar case. */
+		if (is_multiplanar && read &&
+		    fileio->b.m.planes[0].data_offset < buf->size) {
+			buf->pos = fileio->b.m.planes[0].data_offset;
+			buf->size -= buf->pos;
+		}
+	} else {
+		buf = &fileio->bufs[index];
 	}
-	mutex_unlock(&q->mmap_lock);
 
 	/*
-	 * Return the number of successfully allocated buffers
-	 * to the userspace.
+	 * Limit count on last few bytes of the buffer.
 	 */
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
- * @vb:		vb2_v4l2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the address is to be returned
- *
- * This function returns a kernel virtual address of a given plane if
- * such a mapping exist, NULL otherwise.
- */
-void *vb2_plane_vaddr(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
-{
-	struct vb2_buffer *vb = &cb->vb2;
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
- * @vb:		vb2_v4l2_buffer to which the plane in question belongs to
- * @plane_no:	plane number for which the cookie is to be returned
- *
- * This function returns an allocator specific cookie for a given plane if
- * available, NULL otherwise. The allocator should provide some simple static
- * inline function, which would convert this cookie to the allocator specific
- * type that can be used directly by the driver to access the buffer. This can
- * be for example physical address, pointer to scatter list or IOMMU mapping.
- */
-void *vb2_plane_cookie(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
-{
-	struct vb2_buffer *vb = &cb->vb2;
-	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
-		return NULL;
-
-	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
-}
-EXPORT_SYMBOL_GPL(vb2_plane_cookie);
-
-/**
- * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
- * @vb:		vb2_v4l2_buffer returned from the driver
- * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
- *		or VB2_BUF_STATE_ERROR if the operation finished with an error.
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
-void vb2_buffer_done(struct vb2_v4l2_buffer *cb, enum vb2_buffer_state state)
-{
-	struct vb2_buffer *vb = &cb->vb2;
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
-			cb->v4l2_buf.index, state);
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
-	if (state == VB2_BUF_STATE_QUEUED)
-		return;
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
-/**
- * __fill_vb2_buffer() - fill a vb2_v4l2_buffer with information provided in a
- * v4l2_buffer by the userspace. The caller has already verified that struct
- * v4l2_buffer has a valid number of planes.
- */
-static void __fill_vb2_buffer(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b,
-				struct v4l2_plane *v4l2_planes)
-{
-	struct vb2_buffer *vb = &cb->vb2;
-	unsigned int plane;
-
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		if (b->memory == V4L2_MEMORY_USERPTR) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				v4l2_planes[plane].m.userptr =
-					b->m.planes[plane].m.userptr;
-				v4l2_planes[plane].length =
-					b->m.planes[plane].length;
-			}
-		}
-		if (b->memory == V4L2_MEMORY_DMABUF) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				v4l2_planes[plane].m.fd =
-					b->m.planes[plane].m.fd;
-				v4l2_planes[plane].length =
-					b->m.planes[plane].length;
-			}
-		}
-
-		/* Fill in driver-provided information for OUTPUT types */
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-			/*
-			 * Will have to go up to b->length when API starts
-			 * accepting variable number of planes.
-			 *
-			 * If bytesused == 0 for the output buffer, then fall
-			 * back to the full buffer size. In that case
-			 * userspace clearly never bothered to set it and
-			 * it's a safe assumption that they really meant to
-			 * use the full plane sizes.
-			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				struct v4l2_plane *pdst = &v4l2_planes[plane];
-				struct v4l2_plane *psrc = &b->m.planes[plane];
-
-				pdst->bytesused = psrc->bytesused ?
-					psrc->bytesused : pdst->length;
-				pdst->data_offset = psrc->data_offset;
-			}
-		}
-	} else {
-		/*
-		 * Single-planar buffers do not use planes array,
-		 * so fill in relevant v4l2_buffer struct fields instead.
-		 * In videobuf we use our internal V4l2_planes struct for
-		 * single-planar buffers as well, for simplicity.
-		 *
-		 * If bytesused == 0 for the output buffer, then fall back
-		 * to the full buffer size as that's a sensible default.
-		 */
-		if (b->memory == V4L2_MEMORY_USERPTR) {
-			v4l2_planes[0].m.userptr = b->m.userptr;
-			v4l2_planes[0].length = b->length;
-		}
-
-		if (b->memory == V4L2_MEMORY_DMABUF) {
-			v4l2_planes[0].m.fd = b->m.fd;
-			v4l2_planes[0].length = b->length;
-		}
-
-		if (V4L2_TYPE_IS_OUTPUT(b->type))
-			v4l2_planes[0].bytesused = b->bytesused ?
-				b->bytesused : v4l2_planes[0].length;
-		else
-			v4l2_planes[0].bytesused = 0;
-
-	}
-
-	/* Zero flags that the vb2 core handles */
-	cb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
-	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
-	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
-		/*
-		 * Non-COPY timestamps and non-OUTPUT queues will get
-		 * their timestamp and timestamp source flags from the
-		 * queue.
-		 */
-		cb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	}
-
-	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-		/*
-		 * For output buffers mask out the timecode flag:
-		 * this will be handled later in vb2_internal_qbuf().
-		 * The 'field' is valid metadata for this output buffer
-		 * and so that needs to be copied here.
-		 */
-		cb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
-		cb->v4l2_buf.field = b->field;
-	} else {
-		/* Zero any output buffer flags as this is a capture buffer */
-		cb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
-	}
-}
-
-/**
- * __qbuf_mmap() - handle qbuf of an MMAP buffer
- */
-static int __qbuf_mmap(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb = &cb->vb2;
-	__fill_vb2_buffer(cb, b, cb->v4l2_planes);
-	return call_vb_qop(vb, buf_prepare, vb);
-}
-
-/**
- * __qbuf_userptr() - handle qbuf of a USERPTR buffer
- */
-static int __qbuf_userptr(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb = &cb->vb2;
-	struct v4l2_plane planes[VIDEO_MAX_PLANES];
-	struct vb2_queue *q = vb->vb2_queue;
-	void *mem_priv;
-	unsigned int plane;
-	int ret;
-	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	bool reacquired = vb->planes[0].mem_priv == NULL;
-
-	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
-	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(cb, b, planes);
-
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		/* Skip the plane if already verified */
-		if (cb->v4l2_planes[plane].m.userptr &&
-		    cb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
-		    && cb->v4l2_planes[plane].length == planes[plane].length)
-			continue;
-
-		dprintk(3, "userspace address for plane %d changed, "
-				"reacquiring memory\n", plane);
-
-		/* Check if the provided plane buffer is large enough */
-		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "provided buffer size %u is less than "
-						"setup size %u for plane %d\n",
-						planes[plane].length,
-						q->plane_sizes[plane], plane);
-			ret = -EINVAL;
-			goto err;
-		}
-
-		/* Release previously acquired memory if present */
-		if (vb->planes[plane].mem_priv) {
-			if (!reacquired) {
-				reacquired = true;
-				call_void_vb_qop(vb, buf_cleanup, vb);
-			}
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		}
-
-		vb->planes[plane].mem_priv = NULL;
-		memset(&cb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
-
-		/* Acquire each plane's memory */
-		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
-				      planes[plane].m.userptr,
-				      planes[plane].length, dma_dir);
-		if (IS_ERR_OR_NULL(mem_priv)) {
-			dprintk(1, "failed acquiring userspace "
-						"memory for plane %d\n", plane);
-			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
-			goto err;
-		}
-		vb->planes[plane].mem_priv = mem_priv;
-	}
-
-	/*
-	 * Now that everything is in order, copy relevant information
-	 * provided by userspace.
-	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		cb->v4l2_planes[plane] = planes[plane];
-
-	if (reacquired) {
-		/*
-		 * One or more planes changed, so we must call buf_init to do
-		 * the driver-specific initialization on the newly acquired
-		 * buffer, if provided.
-		 */
-		ret = call_vb_qop(vb, buf_init, vb);
-		if (ret) {
-			dprintk(1, "buffer initialization failed\n");
-			goto err;
-		}
-	}
-
-	ret = call_vb_qop(vb, buf_prepare, vb);
-	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
-		call_void_vb_qop(vb, buf_cleanup, vb);
-		goto err;
-	}
-
-	return 0;
-err:
-	/* In case of errors, release planes that were already acquired */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		if (vb->planes[plane].mem_priv)
-			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
-		vb->planes[plane].mem_priv = NULL;
-		cb->v4l2_planes[plane].m.userptr = 0;
-		cb->v4l2_planes[plane].length = 0;
-	}
-
-	return ret;
-}
-
-/**
- * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
- */
-static int __qbuf_dmabuf(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb = &cb->vb2;
-	struct v4l2_plane planes[VIDEO_MAX_PLANES];
-	struct vb2_queue *q = vb->vb2_queue;
-	void *mem_priv;
-	unsigned int plane;
-	int ret;
-	enum dma_data_direction dma_dir =
-		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-	bool reacquired = vb->planes[0].mem_priv == NULL;
-
-	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
-	/* Copy relevant information provided by the userspace */
-	__fill_vb2_buffer(cb, b, planes);
-
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
-
-		if (IS_ERR_OR_NULL(dbuf)) {
-			dprintk(1, "invalid dmabuf fd for plane %d\n",
-				plane);
-			ret = -EINVAL;
-			goto err;
-		}
-
-		/* use DMABUF size if length is not provided */
-		if (planes[plane].length == 0)
-			planes[plane].length = dbuf->size;
-
-		if (planes[plane].length < q->plane_sizes[plane]) {
-			dprintk(1, "invalid dmabuf length for plane %d\n",
-				plane);
-			ret = -EINVAL;
-			goto err;
-		}
-
-		/* Skip the plane if already verified */
-		if (dbuf == vb->planes[plane].dbuf &&
-		    cb->v4l2_planes[plane].length == planes[plane].length) {
-			dma_buf_put(dbuf);
-			continue;
-		}
-
-		dprintk(1, "buffer for plane %d changed\n", plane);
-
-		if (!reacquired) {
-			reacquired = true;
-			call_void_vb_qop(vb, buf_cleanup, vb);
-		}
-
-		/* Release previously acquired memory if present */
-		__vb2_plane_dmabuf_put(cb, &vb->planes[plane]);
-		memset(&cb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
-
-		/* Acquire each plane's memory */
-		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
-			dbuf, planes[plane].length, dma_dir);
-		if (IS_ERR(mem_priv)) {
-			dprintk(1, "failed to attach dmabuf\n");
-			ret = PTR_ERR(mem_priv);
-			dma_buf_put(dbuf);
-			goto err;
-		}
-
-		vb->planes[plane].dbuf = dbuf;
-		vb->planes[plane].mem_priv = mem_priv;
-	}
-
-	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
-	 * really we want to do this just before the DMA, not while queueing
-	 * the buffer(s)..
-	 */
-	for (plane = 0; plane < vb->num_planes; ++plane) {
-		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
-		if (ret) {
-			dprintk(1, "failed to map dmabuf for plane %d\n",
-				plane);
-			goto err;
-		}
-		vb->planes[plane].dbuf_mapped = 1;
-	}
-
-	/*
-	 * Now that everything is in order, copy relevant information
-	 * provided by userspace.
-	 */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		cb->v4l2_planes[plane] = planes[plane];
-
-	if (reacquired) {
-		/*
-		 * Call driver-specific initialization on the newly acquired buffer,
-		 * if provided.
-		 */
-		ret = call_vb_qop(vb, buf_init, vb);
-		if (ret) {
-			dprintk(1, "buffer initialization failed\n");
-			goto err;
-		}
+	if (buf->pos + count > buf->size) {
+		count = buf->size - buf->pos;
+		dprintk(5, "reducing read count: %zd\n", count);
 	}
 
-	ret = call_vb_qop(vb, buf_prepare, vb);
+	/*
+	 * Transfer data to userspace.
+	 */
+	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
+		count, index, buf->pos);
+	if (read)
+		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
+	else
+		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
 	if (ret) {
-		dprintk(1, "buffer preparation failed\n");
-		call_void_vb_qop(vb, buf_cleanup, vb);
-		goto err;
-	}
-
-	return 0;
-err:
-	/* In case of errors, release planes that were already acquired */
-	__vb2_buf_dmabuf_put(cb);
-
-	return ret;
-}
-
-/**
- * __enqueue_in_driver() - enqueue a vb2_v4l2_buffer in driver for processing
- */
-static void __enqueue_in_driver(struct vb2_buffer *vb)
-{
-	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int plane;
-
-	vb->state = VB2_BUF_STATE_ACTIVE;
-	atomic_inc(&q->owned_by_drv_count);
-
-	/* sync buffers */
-	for (plane = 0; plane < vb->num_planes; ++plane)
-		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
-
-	call_void_vb_qop(vb, buf_queue, vb);
-}
-
-static int __buf_prepare(struct vb2_v4l2_buffer *cb, const struct v4l2_buffer *b)
-{
-	struct vb2_buffer *vb = &cb->vb2;
-	struct vb2_queue *q = vb->vb2_queue;
-	int ret;
-
-	ret = __verify_length(cb, b);
-	if (ret < 0) {
-		dprintk(1, "plane parameters verification failed: %d\n", ret);
-		return ret;
-	}
-	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
-		/*
-		 * If the format's field is ALTERNATE, then the buffer's field
-		 * should be either TOP or BOTTOM, not ALTERNATE since that
-		 * makes no sense. The driver has to know whether the
-		 * buffer represents a top or a bottom field in order to
-		 * program any DMA correctly. Using ALTERNATE is wrong, since
-		 * that just says that it is either a top or a bottom field,
-		 * but not which of the two it is.
-		 */
-		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
-		return -EINVAL;
-	}
-
-	if (q->error) {
-		dprintk(1, "fatal error occurred on queue\n");
-		return -EIO;
-	}
-
-	vb->state = VB2_BUF_STATE_PREPARING;
-	cb->v4l2_buf.timestamp.tv_sec = 0;
-	cb->v4l2_buf.timestamp.tv_usec = 0;
-	cb->v4l2_buf.sequence = 0;
-
-	switch (q->memory) {
-	case V4L2_MEMORY_MMAP:
-		ret = __qbuf_mmap(cb, b);
-		break;
-	case V4L2_MEMORY_USERPTR:
-		down_read(&current->mm->mmap_sem);
-		ret = __qbuf_userptr(cb, b);
-		up_read(&current->mm->mmap_sem);
-		break;
-	case V4L2_MEMORY_DMABUF:
-		ret = __qbuf_dmabuf(cb, b);
-		break;
-	default:
-		WARN(1, "Invalid queue type\n");
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		dprintk(1, "buffer preparation failed: %d\n", ret);
-	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
-
-	return ret;
-}
-
-static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
-				    const char *opname)
-{
-	struct vb2_v4l2_buffer *cb;
-
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
-	cb = container_of(q->bufs[b->index], struct vb2_v4l2_buffer, vb2);
-
-	return __verify_planes_array(cb, b);
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
-	struct vb2_v4l2_buffer *cb;
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
-	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "invalid buffer state %d\n",
-			vb->state);
-		return -EINVAL;
-	}
-
-	ret = __buf_prepare(cb, b);
-	if (!ret) {
-		/* Fill buffer information for the userspace */
-		__fill_v4l2_buffer(cb, b);
-
-		dprintk(1, "prepare of buffer %d succeeded\n", cb->v4l2_buf.index);
+		dprintk(3, "error copying data\n");
+		return -EFAULT;
 	}
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
-{
-	struct vb2_buffer *vb;
-	struct vb2_v4l2_buffer *cb;
-	int ret;
 
 	/*
-	 * If any buffers were queued before streamon,
-	 * we can now pass them to driver for processing.
+	 * Update counters.
 	 */
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
+	buf->pos += count;
+	*ppos += count;
 
-	dprintk(1, "driver refused to start streaming\n");
 	/*
-	 * If you see this warning, then the driver isn't cleaning up properly
-	 * after a failed start_streaming(). See the start_streaming()
-	 * documentation in videobuf2-core.h for more information how buffers
-	 * should be returned to vb2 in start_streaming().
+	 * Queue next buffer if required.
 	 */
-	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
-		unsigned i;
-
+	if (buf->pos == buf->size ||
+	   (!read && (fileio->flags & VB2_FILEIO_WRITE_IMMEDIATELY))) {
 		/*
-		 * Forcefully reclaim buffers if the driver did not
-		 * correctly return them to vb2.
+		 * Check if this is the last buffer to read.
 		 */
-		for (i = 0; i < q->num_buffers; ++i) {
-			vb = q->bufs[i];
-			cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-			if (vb->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(cb, VB2_BUF_STATE_QUEUED);
+		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
+		    fileio->dq_count == 1) {
+			dprintk(3, "read limit reached\n");
+			return __vb2_cleanup_fileio(q);
 		}
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
-}
-
-static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-
-	if (ret)
-		return ret;
-
-	vb = q->bufs[b->index];
-	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-
-	switch (vb->state) {
-	case VB2_BUF_STATE_DEQUEUED:
-		ret = __buf_prepare(cb, b);
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
 
-	/*
-	 * Add to the queued buffers list, a buffer will stay on it until
-	 * dequeued in dqbuf.
-	 */
-	list_add_tail(&vb->queued_entry, &q->queued_list);
-	q->queued_count++;
-	q->waiting_for_buffers = false;
-	vb->state = VB2_BUF_STATE_QUEUED;
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		/*
-		 * For output buffers copy the timestamp if needed,
-		 * and the timecode field and flag if needed.
+		 * Call vb2_qbuf and give buffer to the driver.
 		 */
-		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			cb->v4l2_buf.timestamp = b->timestamp;
-		cb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
-		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			cb->v4l2_buf.timecode = b->timecode;
-	}
-
-	/*
-	 * If already streaming, give the buffer to driver for processing.
-	 * If not, the buffer will be given to driver on next streamon.
-	 */
-	if (q->start_streaming_called)
-		__enqueue_in_driver(vb);
-
-	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(cb, b);
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
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		fileio->b.index = index;
+		fileio->b.bytesused = buf->pos;
+		if (is_multiplanar) {
+			memset(&fileio->p, 0, sizeof(fileio->p));
+			fileio->p.bytesused = buf->pos;
+			fileio->b.m.planes = &fileio->p;
+			fileio->b.length = 1;
+		}
+		if (set_timestamp)
+			v4l2_get_timestamp(&fileio->b.timestamp);
+		ret = vb2_internal_qbuf(q, q->type, index, q->memory, &fileio->b);
+		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
 			return ret;
-	}
-
-	dprintk(1, "qbuf of buffer %d succeeded\n", cb->v4l2_buf.index);
-	return 0;
-}
-
-/**
- * vb2_qbuf() - Queue a buffer from userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_qbuf handler
- *		in driver
- *
- * Should be called from vidioc_qbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
- *    which driver-specific buffer initialization can be performed,
- * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
- *    callback for processing.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_qbuf handler in driver.
- */
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
-{
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-
-	return vb2_internal_qbuf(q, b);
-}
-EXPORT_SYMBOL_GPL(vb2_qbuf);
-
-/**
- * __vb2_wait_for_done_vb() - wait for a buffer to become available
- * for dequeuing
- *
- * Will sleep if required for nonblocking == false.
- */
-static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
-{
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
 
 		/*
-		 * We are streaming and blocking, wait for another buffer to
-		 * become ready or for streamoff. Driver's lock is released to
-		 * allow streamoff or qbuf to be called while waiting.
+		 * Buffer has been queued, update the status
 		 */
-		call_void_qop(q, wait_prepare, q);
-
+		buf->pos = 0;
+		buf->queued = 1;
+		cb = container_of(q->bufs[index], struct vb2_v4l2_buffer, vb2);
+		buf->size = vb2_plane_size(cb, 0);
+		fileio->q_count += 1;
 		/*
-		 * All locks have been released, it is safe to sleep now.
+		 * If we are queuing up buffers for the first time, then
+		 * increase initial_index by one.
 		 */
-		dprintk(3, "will sleep waiting for buffers\n");
-		ret = wait_event_interruptible(q->done_wq,
-				!list_empty(&q->done_list) || !q->streaming ||
-				q->error);
-
+		if (fileio->initial_index < q->num_buffers)
+			fileio->initial_index++;
 		/*
-		 * We need to reevaluate both conditions again after reacquiring
-		 * the locks or return an error if one occurred.
+		 * The next buffer to use is either a buffer that's going to be
+		 * queued for the first time (initial_index < q->num_buffers)
+		 * or it is equal to q->num_buffers, meaning that the next
+		 * time we need to dequeue a buffer since we've now queued up
+		 * all the 'first time' buffers.
 		 */
-		call_void_qop(q, wait_finish, q);
-		if (ret) {
-			dprintk(1, "sleep was interrupted\n");
-			return ret;
-		}
+		fileio->cur_index = fileio->initial_index;
 	}
-	return 0;
-}
-
-/**
- * __vb2_get_done_vb() - get a buffer ready for dequeuing
- *
- * Will sleep if required for nonblocking == false.
- */
-static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_v4l2_buffer **cb,
-				struct v4l2_buffer *b, int nonblocking)
-{
-	unsigned long flags;
-	int ret;
-	struct vb2_buffer *vb = NULL;
-
-	/*
-	 * Wait for at least one buffer to become available on the done_list.
-	 */
-	ret = __vb2_wait_for_done_vb(q, nonblocking);
-	if (ret)
-		return ret;
 
 	/*
-	 * Driver's lock has been held since we last verified that done_list
-	 * is not empty, so no need for another list_empty(done_list) check.
-	 */
-	spin_lock_irqsave(&q->done_lock, flags);
-	vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
-	*cb = container_of(vb, struct vb2_v4l2_buffer, vb2); 
-	/*
-	 * Only remove the buffer from done_list if v4l2_buffer can handle all
-	 * the planes.
+	 * Return proper number of bytes processed.
 	 */
-	ret = __verify_planes_array(*cb, b);
-	if (!ret)
-		list_del(&vb->done_entry);
-	spin_unlock_irqrestore(&q->done_lock, flags);
-
+	if (ret == 0)
+		ret = count;
 	return ret;
 }
 
-/**
- * vb2_wait_for_all_buffers() - wait until all buffers are given back to vb2
- * @q:		videobuf2 queue
- *
- * This function will wait until all buffers that have been given to the driver
- * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
- * wait_prepare, wait_finish pair. It is intended to be called with all locks
- * taken, for example from stop_streaming() callback.
- */
-int vb2_wait_for_all_buffers(struct vb2_queue *q)
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblocking)
 {
-	if (!q->streaming) {
-		dprintk(1, "streaming off, will not wait for buffers\n");
-		return -EINVAL;
-	}
-
-	if (q->start_streaming_called)
-		wait_event(q->done_wq, !atomic_read(&q->owned_by_drv_count));
-	return 0;
+	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
 }
-EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
+EXPORT_SYMBOL_GPL(vb2_read);
 
-/**
- * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
- */
-static void __vb2_dqbuf(struct vb2_v4l2_buffer *cb)
+size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		loff_t *ppos, int nonblocking)
 {
-	struct vb2_buffer *vb = &cb->vb2;
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
+	return __vb2_perform_fileio(q, (char __user *) data, count,
+							ppos, nonblocking, 0);
 }
+EXPORT_SYMBOL_GPL(vb2_write);
+
+struct vb2_threadio_data {
+	struct task_struct *thread;
+	vb2_thread_fnc fnc;
+	void *priv;
+	bool stop;
+};
 
-static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+static int vb2_thread(void *data)
 {
-	struct vb2_v4l2_buffer *cb = NULL;
-	struct vb2_buffer *vb = NULL;
-	int ret;
+	struct vb2_queue *q = data;
+	struct vb2_threadio_data *threadio = q->threadio;
+	struct vb2_fileio_data *fileio = q->fileio;
+	bool set_timestamp = false;
+	int prequeue = 0;
+	int index = 0;
+	int ret = 0;
 
-	if (b->type != q->type) {
-		dprintk(1, "invalid buffer type\n");
-		return -EINVAL;
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		prequeue = q->num_buffers;
+		set_timestamp =
+			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+			V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	}
-	ret = __vb2_get_done_vb(q, &cb, b, nonblocking);
-	if (ret < 0)
-		return ret;
 
-	vb = &cb->vb2;
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
-	}
+	set_freezable();
 
-	call_void_vb_qop(vb, buf_finish, vb);
+	for (;;) {
+		struct vb2_buffer *vb;
 
-	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(cb, b);
-	/* Remove from videobuf queue */
-	list_del(&vb->queued_entry);
-	q->queued_count--;
-	/* go back to dequeued state */
-	__vb2_dqbuf(cb);
+		/*
+		 * Call vb2_dqbuf to get buffer back.
+		 */
+		memset(&fileio->b, 0, sizeof(fileio->b));
+		fileio->b.type = q->type;
+		fileio->b.memory = q->memory;
+		if (prequeue) {
+			fileio->b.index = index++;
+			prequeue--;
+		} else {
+			call_void_qop(q, wait_finish, q);
+			if (!threadio->stop)
+				ret = vb2_internal_dqbuf(q, q->type, &fileio->b, 0);
+			call_void_qop(q, wait_prepare, q);
+			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+		}
+		if (ret || threadio->stop)
+			break;
+		try_to_freeze();
 
-	dprintk(1, "dqbuf of buffer %d, with state %d\n",
-			cb->v4l2_buf.index, vb->state);
+		vb = q->bufs[fileio->b.index];
+		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
+			if (threadio->fnc(vb, threadio->priv))
+				break;
+		call_void_qop(q, wait_finish, q);
+		if (set_timestamp)
+			v4l2_get_timestamp(&fileio->b.timestamp);
+		if (!threadio->stop)
+			ret = vb2_internal_qbuf(q, q->type, fileio->b.index, fileio->b.memory, &fileio->b);
+		call_void_qop(q, wait_prepare, q);
+		if (ret || threadio->stop)
+			break;
+	}
 
+	/* Hmm, linux becomes *very* unhappy without this ... */
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
 	return 0;
 }
 
-/**
- * vb2_dqbuf() - Dequeue a buffer to the userspace
- * @q:		videobuf2 queue
- * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
- *		in driver
- * @nonblocking: if true, this call will not sleep waiting for a buffer if no
- *		 buffers ready for dequeuing are present. Normally the driver
- *		 would be passing (file->f_flags & O_NONBLOCK) here
- *
- * Should be called from vidioc_dqbuf ioctl handler of a driver.
- * This function:
- * 1) verifies the passed buffer,
- * 2) calls buf_finish callback in the driver (if provided), in which
- *    driver can perform any additional operations that may be required before
- *    returning the buffer to userspace, such as cache sync,
- * 3) the buffer struct members are filled with relevant information for
- *    the userspace.
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_dqbuf handler in driver.
+/*
+ * This function should not be used for anything else but the videobuf2-dvb
+ * support. If you think you have another good use-case for this, then please
+ * contact the linux-media mailinglist first.
  */
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
+		     const char *thread_name)
 {
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
-		return -EBUSY;
-	}
-	return vb2_internal_dqbuf(q, b, nonblocking);
-}
-EXPORT_SYMBOL_GPL(vb2_dqbuf);
+	struct vb2_threadio_data *threadio;
+	int ret = 0;
 
-/**
- * __vb2_queue_cancel() - cancel and stop (pause) streaming
- *
- * Removes all queued buffers from driver's queue and all buffers queued by
- * userspace from videobuf's queue. Returns to state after reqbufs.
- */
-static void __vb2_queue_cancel(struct vb2_queue *q)
-{
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-	unsigned int i;
+	if (q->threadio)
+		return -EBUSY;
+	if (vb2_is_busy(q))
+		return -EBUSY;
+	if (WARN_ON(q->fileio))
+		return -EBUSY;
 
-	/*
-	 * Tell driver to stop all transactions and release all queued
-	 * buffers.
-	 */
-	if (q->start_streaming_called)
-		call_void_qop(q, stop_streaming, q);
+	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
+	if (threadio == NULL)
+		return -ENOMEM;
+	threadio->fnc = fnc;
+	threadio->priv = priv;
 
-	/*
-	 * If you see this warning, then the driver isn't cleaning up properly
-	 * in stop_streaming(). See the stop_streaming() documentation in
-	 * videobuf2-core.h for more information how buffers should be returned
-	 * to vb2 in stop_streaming().
-	 */
-	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
-		for (i = 0; i < q->num_buffers; ++i)
-		{
-			vb = q->bufs[i];
-			cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-			if (vb->state == VB2_BUF_STATE_ACTIVE)
-				vb2_buffer_done(cb, VB2_BUF_STATE_ERROR);
-		}
-		/* Must be zero now */
-		WARN_ON(atomic_read(&q->owned_by_drv_count));
+	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
+	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
+	if (ret)
+		goto nomem;
+	q->threadio = threadio;
+	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
+	if (IS_ERR(threadio->thread)) {
+		ret = PTR_ERR(threadio->thread);
+		threadio->thread = NULL;
+		goto nothread;
 	}
+	return 0;
 
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
-		struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-
-		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-			vb->state = VB2_BUF_STATE_PREPARED;
-			call_void_vb_qop(vb, buf_finish, vb);
-		}
-		__vb2_dqbuf(cb);
-	}
+nothread:
+	__vb2_cleanup_fileio(q);
+nomem:
+	kfree(threadio);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_thread_start);
 
-static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+int vb2_thread_stop(struct vb2_queue *q)
 {
-	int ret;
-
-	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
-		return -EINVAL;
-	}
+	struct vb2_threadio_data *threadio = q->threadio;
+	int err;
 
-	if (q->streaming) {
-		dprintk(3, "already streaming\n");
+	if (threadio == NULL)
 		return 0;
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
+	threadio->stop = true;
+	/* Wake up all pending sleeps in the thread */
+	vb2_queue_error(q);
+	err = kthread_stop(threadio->thread);
+	__vb2_cleanup_fileio(q);
+	threadio->thread = NULL;
+	kfree(threadio);
+	q->threadio = NULL;
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_thread_stop);
 
-	q->streaming = 1;
+/*
+ * The following functions are not part of the vb2 core API, but are helper
+ * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
+ * and struct vb2_ops.
+ * They contain boilerplate code that most if not all drivers have to do
+ * and so they simplify the driver code.
+ */
 
-	dprintk(3, "successful\n");
-	return 0;
+/* The queue is busy if there is a owner and you are not that owner. */
+static bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
+{
+	return vdev->queue->owner && vdev->queue->owner != file->private_data;
 }
 
-/**
- * vb2_queue_error() - signal a fatal error on the queue
- * @q:		videobuf2 queue
- *
- * Flag that a fatal unrecoverable error has occurred and wake up all processes
- * waiting on the queue. Polling will now set POLLERR and queuing and dequeuing
- * buffers will return -EIO.
- *
- * The error flag will be cleared when cancelling the queue, either from
- * vb2_streamoff or vb2_queue_release. Drivers should thus not call this
- * function before starting the stream, otherwise the error flag will remain set
- * until the queue is released when closing the device node.
- */
-void vb2_queue_error(struct vb2_queue *q)
+/* vb2 ioctl helpers */
+
+int vb2_ioctl_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
 {
-	q->error = 1;
+	struct video_device *vdev = video_devdata(file);
+	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
 
-	wake_up_all(&q->done_wq);
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	res = __reqbufs(vdev->queue, p->count, p->type, p->memory);
+	/* If count == 0, then the owner has released all buffers and he
+	   is no longer owner of the queue. Otherwise we have a new owner. */
+	if (res == 0)
+		vdev->queue->owner = p->count ? file->private_data : NULL;
+	return res;
 }
-EXPORT_SYMBOL_GPL(vb2_queue_error);
+EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
 
-/**
- * vb2_streamon - start streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamon handler
- *
- * Should be called from vidioc_streamon handler of a driver.
- * This function:
- * 1) verifies current state
- * 2) passes any previously queued buffers to the driver and starts streaming
- *
- * The return values from this function are intended to be directly returned
- * from vidioc_streamon handler in the driver.
- */
-int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+int vb2_ioctl_create_bufs(struct file *file, void *priv,
+			  struct v4l2_create_buffers *p)
 {
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+	struct video_device *vdev = video_devdata(file);
+	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
+
+	p->index = vdev->queue->num_buffers;
+	/* If count == 0, then just check if memory and type are valid.
+	   Any -EBUSY result from __verify_memory_type can be mapped to 0. */
+	if (p->count == 0)
+		return res != -EBUSY ? res : 0;
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	}
-	return vb2_internal_streamon(q, type);
+	res = __create_bufs(vdev->queue, p->count, p->format.type, p->memory, &p->format);
+	if (res == 0)
+		vdev->queue->owner = file->private_data;
+	return res;
 }
-EXPORT_SYMBOL_GPL(vb2_streamon);
+EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
 
-static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+int vb2_ioctl_prepare_buf(struct file *file, void *priv,
+			  struct v4l2_buffer *p)
 {
-	if (type != q->type) {
-		dprintk(1, "invalid stream type\n");
-		return -EINVAL;
-	}
-
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
-
-	dprintk(3, "successful\n");
-	return 0;
-}
+	struct video_device *vdev = video_devdata(file);
 
-/**
- * vb2_streamoff - stop streaming
- * @q:		videobuf2 queue
- * @type:	type argument passed from userspace to vidioc_streamoff handler
- *
- * Should be called from vidioc_streamoff handler of a driver.
- * This function:
- * 1) verifies current state,
- * 2) stop streaming and dequeues any queued buffers, including those previously
- *    passed to the driver (after waiting for the driver to finish).
- *
- * This call can be used for pausing playback.
- * The return values from this function are intended to be directly returned
- * from vidioc_streamoff handler in the driver
- */
-int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
-{
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "file io in progress\n");
+	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	}
-	return vb2_internal_streamoff(q, type);
+	return vb2_prepare_buf(vdev->queue, p);
 }
-EXPORT_SYMBOL_GPL(vb2_streamoff);
+EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
 
-/**
- * __find_plane_by_offset() - find plane associated with the given offset off
- */
-static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
-			unsigned int *_buffer, unsigned int *_plane)
+int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-	unsigned int buffer, plane;
-
-	/*
-	 * Go over all buffers and their planes, comparing the given offset
-	 * with an offset assigned to each plane. If a match is found,
-	 * return its buffer and plane numbers.
-	 */
-	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
-		vb = q->bufs[buffer];
-		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			if (cb->v4l2_planes[plane].m.mem_offset == off) {
-				*_buffer = buffer;
-				*_plane = plane;
-				return 0;
-			}
-		}
-	}
+	struct video_device *vdev = video_devdata(file);
 
-	return -EINVAL;
+	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
+	return vb2_querybuf(vdev->queue, p);
 }
+EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
 
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
+int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
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
+	struct video_device *vdev = video_devdata(file);
 
-	vb = q->bufs[eb->index];
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_qbuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
 
-	if (eb->plane >= vb->num_planes) {
-		dprintk(1, "buffer plane out of range\n");
-		return -EINVAL;
-	}
+int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
 
-	if (vb2_fileio_is_active(q)) {
-		dprintk(1, "expbuf: file io in progress\n");
+	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	}
-
-	vb_plane = &vb->planes[eb->plane];
+	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
 
-	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
-	if (IS_ERR_OR_NULL(dbuf)) {
-		dprintk(1, "failed to export buffer %d, plane %d\n",
-			eb->index, eb->plane);
-		return -EINVAL;
-	}
+int vb2_ioctl_streamon(struct file *file, void *priv, unsigned int type)
+{
+	struct video_device *vdev = video_devdata(file);
 
-	ret = dma_buf_fd(dbuf, eb->flags & ~O_ACCMODE);
-	if (ret < 0) {
-		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
-			eb->index, eb->plane, ret);
-		dma_buf_put(dbuf);
-		return ret;
-	}
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_streamon(vdev->queue, type);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
 
-	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
-		eb->index, eb->plane, ret);
-	eb->fd = ret;
+int vb2_ioctl_streamoff(struct file *file, void *priv, unsigned int type)
+{
+	struct video_device *vdev = video_devdata(file);
 
-	return 0;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_streamoff(vdev->queue, type);
 }
-EXPORT_SYMBOL_GPL(vb2_expbuf);
+EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
 
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
+int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
 {
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-	unsigned int buffer = 0, plane = 0;
-	int ret;
-	unsigned long length;
-
-	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
+	struct video_device *vdev = video_devdata(file);
 
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
+	if (vb2_queue_is_busy(vdev, file))
 		return -EBUSY;
-	}
-
-	/*
-	 * Find the plane corresponding to the offset passed by userspace.
-	 */
-	ret = __find_plane_by_offset(q, off, &buffer, &plane);
-	if (ret)
-		return ret;
+	return vb2_expbuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
 
-	vb = q->bufs[buffer];
-	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-	/*
-	 * MMAP requires page_aligned buffers.
-	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
-	 * so, we need to do the same here.
-	 */
-	length = PAGE_ALIGN(cb->v4l2_planes[plane].length);
-	if (length < (vma->vm_end - vma->vm_start)) {
-		dprintk(1,
-			"MMAP invalid, as it would overflow buffer length\n");
-		return -EINVAL;
-	}
+/* v4l2_file_operations helpers */
 
-	mutex_lock(&q->mmap_lock);
-	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
-	mutex_unlock(&q->mmap_lock);
-	if (ret)
-		return ret;
+int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
 
-	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
-	return 0;
+	return vb2_mmap(vdev->queue, vma);
 }
-EXPORT_SYMBOL_GPL(vb2_mmap);
+EXPORT_SYMBOL_GPL(vb2_fop_mmap);
 
-#ifndef CONFIG_MMU
-unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
-				    unsigned long addr,
-				    unsigned long len,
-				    unsigned long pgoff,
-				    unsigned long flags)
+int _vb2_fop_release(struct file *file, struct mutex *lock)
 {
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
-	unsigned long off = pgoff << PAGE_SHIFT;
-	unsigned int buffer, plane;
-	void *vaddr;
-	int ret;
+	struct video_device *vdev = video_devdata(file);
 
-	if (q->memory != V4L2_MEMORY_MMAP) {
-		dprintk(1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
+	if (lock)
+		mutex_lock(lock);
+	if (file->private_data == vdev->queue->owner) {
+		vb2_queue_release(vdev->queue);
+		vdev->queue->owner = NULL;
 	}
+	if (lock)
+		mutex_unlock(lock);
+	return v4l2_fh_release(file);
+}
+EXPORT_SYMBOL_GPL(_vb2_fop_release);
 
-	/*
-	 * Find the plane corresponding to the offset passed by userspace.
-	 */
-	ret = __find_plane_by_offset(q, off, &buffer, &plane);
-	if (ret)
-		return ret;
-
-	vb = q->bufs[buffer];
-	cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+int vb2_fop_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 
-	vaddr = vb2_plane_vaddr(cb, plane);
-	return vaddr ? (unsigned long)vaddr : -EINVAL;
+	return _vb2_fop_release(file, lock);
 }
-EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
-#endif
-
-static int __vb2_init_fileio(struct vb2_queue *q, int read);
-static int __vb2_cleanup_fileio(struct vb2_queue *q);
+EXPORT_SYMBOL_GPL(vb2_fop_release);
 
-/**
- * vb2_poll() - implements poll userspace operation
- * @q:		videobuf2 queue
- * @file:	file argument passed to the poll file operation handler
- * @wait:	wait argument passed to the poll file operation handler
- *
- * This function implements poll file operation handler for a driver.
- * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
- * be informed that the file descriptor of a video device is available for
- * reading.
- * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
- * will be reported as available for writing.
- *
- * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
- * pending events.
- *
- * The return values from this function are intended to be directly returned
- * from poll handler in driver.
- */
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
+ssize_t vb2_fop_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
 {
-	struct video_device *vfd = video_devdata(file);
-	unsigned long req_events = poll_requested_events(wait);
-	struct vb2_buffer *vb = NULL;
-	unsigned int res = 0;
-	unsigned long flags;
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+	int err = -EBUSY;
 
-	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
-		struct v4l2_fh *fh = file->private_data;
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (vb2_queue_is_busy(vdev, file))
+		goto exit;
+	err = vb2_write(vdev->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	if (vdev->queue->fileio)
+		vdev->queue->owner = file->private_data;
+exit:
+	if (lock)
+		mutex_unlock(lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_write);
 
-		if (v4l2_event_pending(fh))
-			res = POLLPRI;
-		else if (req_events & POLLPRI)
-			poll_wait(file, &fh->wait, wait);
-	}
+ssize_t vb2_fop_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+	int err = -EBUSY;
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
-		return res;
-	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
-		return res;
+	if (lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (vb2_queue_is_busy(vdev, file))
+		goto exit;
+	err = vb2_read(vdev->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	if (vdev->queue->fileio)
+		vdev->queue->owner = file->private_data;
+exit:
+	if (lock)
+		mutex_unlock(lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_read);
 
-	/*
-	 * Start file I/O emulator only if streaming API has not been used yet.
-	 */
-	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
-				(req_events & (POLLIN | POLLRDNORM))) {
-			if (__vb2_init_fileio(q, 1))
-				return res | POLLERR;
-		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
-				(req_events & (POLLOUT | POLLWRNORM))) {
-			if (__vb2_init_fileio(q, 0))
-				return res | POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
-			return res | POLLOUT | POLLWRNORM;
-		}
-	}
+unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct vb2_queue *q = vdev->queue;
+	struct mutex *lock = q->lock ? q->lock : vdev->lock;
+	unsigned res;
+	void *fileio;
 
 	/*
-	 * There is nothing to wait for if the queue isn't streaming, or if the
-	 * error flag is set.
-	 */
-	if (!vb2_is_streaming(q) || q->error)
-		return res | POLLERR;
-	/*
-	 * For compatibility with vb1: if QBUF hasn't been called yet, then
-	 * return POLLERR as well. This only affects capture queues, output
-	 * queues will always initialize waiting_for_buffers to false.
+	 * If this helper doesn't know how to lock, then you shouldn't be using
+	 * it but you should write your own.
 	 */
-	if (q->waiting_for_buffers)
-		return res | POLLERR;
+	WARN_ON(!lock);
 
-	/*
-	 * For output streams you can write as long as there are fewer buffers
-	 * queued than there are buffers available.
-	 */
-	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
-		return res | POLLOUT | POLLWRNORM;
+	if (lock && mutex_lock_interruptible(lock))
+		return POLLERR;
 
-	if (list_empty(&q->done_list))
-		poll_wait(file, &q->done_wq, wait);
+	fileio = q->fileio;
 
-	/*
-	 * Take first buffer available for dequeuing.
-	 */
-	spin_lock_irqsave(&q->done_lock, flags);
-	if (!list_empty(&q->done_list))
-		vb = list_first_entry(&q->done_list, struct vb2_buffer,
-					done_entry);
-	spin_unlock_irqrestore(&q->done_lock, flags);
+	res = vb2_poll(vdev->queue, file, wait);
 
-	if (vb && (vb->state == VB2_BUF_STATE_DONE
-			|| vb->state == VB2_BUF_STATE_ERROR)) {
-		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
-				res | POLLOUT | POLLWRNORM :
-				res | POLLIN | POLLRDNORM;
-	}
+	/* If fileio was started, then we have a new queue owner. */
+	if (!fileio && q->fileio)
+		q->owner = file->private_data;
+	if (lock)
+		mutex_unlock(lock);
 	return res;
 }
-EXPORT_SYMBOL_GPL(vb2_poll);
+EXPORT_SYMBOL_GPL(vb2_fop_poll);
 
-/**
- * vb2_queue_init() - initialize a videobuf2 queue
- * @q:		videobuf2 queue; this structure should be allocated in driver
- *
- * The vb2_queue structure should be allocated by the driver. The driver is
- * responsible of clearing it's content and setting initial values for some
- * required entries before calling this function.
- * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
- * to the struct vb2_queue description in include/media/videobuf2-v4l2.h
- * for more information.
- */
-int vb2_queue_init(struct vb2_queue *q)
+#ifndef CONFIG_MMU
+unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	/*
-	 * Sanity check
-	 */
-	if (WARN_ON(!q)			  ||
-	    WARN_ON(!q->ops)		  ||
-	    WARN_ON(!q->mem_ops)	  ||
-	    WARN_ON(!q->type)		  ||
-	    WARN_ON(!q->io_modes)	  ||
-	    WARN_ON(!q->ops->queue_setup) ||
-	    WARN_ON(!q->ops->buf_queue)   ||
-	    WARN_ON(q->timestamp_flags &
-		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
-		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
-		return -EINVAL;
-
-	/* Warn that the driver should choose an appropriate timestamp type */
-	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
+	struct video_device *vdev = video_devdata(file);
 
-	INIT_LIST_HEAD(&q->queued_list);
-	INIT_LIST_HEAD(&q->done_list);
-	spin_lock_init(&q->done_lock);
-	mutex_init(&q->mmap_lock);
-	init_waitqueue_head(&q->done_wq);
+	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
+#endif
 
-	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
+/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
 
-	return 0;
+void vb2_ops_wait_prepare(struct vb2_queue *vq)
+{
+	mutex_unlock(vq->lock);
 }
-EXPORT_SYMBOL_GPL(vb2_queue_init);
+EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
 
-/**
- * vb2_queue_release() - stop streaming, release the queue and free memory
- * @q:		videobuf2 queue
- *
- * This function stops streaming and performs necessary clean ups, including
- * freeing video buffer memory. The driver is responsible for freeing
- * the vb2_queue structure itself.
- */
-void vb2_queue_release(struct vb2_queue *q)
+void vb2_ops_wait_finish(struct vb2_queue *vq)
 {
-	__vb2_cleanup_fileio(q);
-	__vb2_queue_cancel(q);
-	mutex_lock(&q->mmap_lock);
-	__vb2_queue_free(q, q->num_buffers);
-	mutex_unlock(&q->mmap_lock);
+	mutex_lock(vq->lock);
 }
-EXPORT_SYMBOL_GPL(vb2_queue_release);
-
-/**
- * struct vb2_fileio_buf - buffer context used by file io emulator
- *
- * vb2 provides a compatibility layer and emulator of file io (read and
- * write) calls on top of streaming API. This structure is used for
- * tracking context related to the buffers.
- */
-struct vb2_fileio_buf {
-	void *vaddr;
-	unsigned int size;
-	unsigned int pos;
-	unsigned int queued:1;
-};
+EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
 
 /**
- * struct vb2_fileio_data - queue context used by file io emulator
- *
- * @cur_index:	the index of the buffer currently being read from or
- *		written to. If equal to q->num_buffers then a new buffer
- *		must be dequeued.
- * @initial_index: in the read() case all buffers are queued up immediately
- *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
- *		buffers. However, in the write() case no buffers are initially
- *		queued, instead whenever a buffer is full it is queued up by
- *		__vb2_perform_fileio(). Only once all available buffers have
- *		been queued up will __vb2_perform_fileio() start to dequeue
- *		buffers. This means that initially __vb2_perform_fileio()
- *		needs to know what buffer index to use when it is queuing up
- *		the buffers for the first time. That initial index is stored
- *		in this field. Once it is equal to q->num_buffers all
- *		available buffers have been queued and __vb2_perform_fileio()
- *		should start the normal dequeue/queue cycle.
+ * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the address is to be returned
  *
- * vb2 provides a compatibility layer and emulator of file io (read and
- * write) calls on top of streaming API. For proper operation it required
- * this structure to save the driver state between each call of the read
- * or write function.
- */
-struct vb2_fileio_data {
-	struct v4l2_requestbuffers req;
-	struct v4l2_plane p;
-	struct v4l2_buffer b;
-	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
-	unsigned int cur_index;
-	unsigned int initial_index;
-	unsigned int q_count;
-	unsigned int dq_count;
-	unsigned int flags;
-};
-
-/**
- * __vb2_init_fileio() - initialize file io emulator
- * @q:		videobuf2 queue
- * @read:	mode selector (1 means read, 0 means write)
+ * This function returns a kernel virtual address of a given plane if
+ * such a mapping exist, NULL otherwise.
  */
-static int __vb2_init_fileio(struct vb2_queue *q, int read)
+void *vb2_plane_vaddr(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
 {
-	struct vb2_fileio_data *fileio;
-	int i, ret;
-	unsigned int count = 0;
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_buffer *vb;
+	struct vb2_buffer *vb = &cb->vb2;
+	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+		return NULL;
 
-	/*
-	 * Sanity check
-	 */
-	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
-		    (!read && !(q->io_modes & VB2_WRITE))))
-		return -EINVAL;
+	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
 
-	/*
-	 * Check if device supports mapping buffers to kernel virtual space.
-	 */
-	if (!q->mem_ops->vaddr)
-		return -EBUSY;
+}
+EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
 
-	/*
-	 * Check if streaming api has not been already activated.
-	 */
-	if (q->streaming || q->num_buffers > 0)
-		return -EBUSY;
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
+void *vb2_plane_cookie(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
+{
+	struct vb2_buffer *vb = &cb->vb2;
+	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
+		return NULL;
 
-	/*
-	 * Start with count 1, driver can increase it in queue_setup()
-	 */
-	count = 1;
+	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
+}
+EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
-	dprintk(3, "setting up file io: mode %s, count %d, flags %08x\n",
-		(read) ? "read" : "write", count, q->io_flags);
+/**
+ *  Belows are private functions for v4l2
+ */
 
-	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
-	if (fileio == NULL)
-		return -ENOMEM;
+/**
+ * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
+ * v4l2_buffer by the userspace. The caller has already verified that struct
+ * v4l2_buffer has a valid number of planes.
+ */
+static int v4l2_fill_vb2_buffer(struct vb2_buffer *vb, void *pbuffer,
+		void *pplane)
+{
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pbuffer;
+	struct v4l2_plane *v4l2_planes = (struct v4l2_plane *)pplane;
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	unsigned int plane;
 
-	fileio->flags = q->io_flags;
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		if (b->memory == V4L2_MEMORY_USERPTR) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].m.userptr =
+					b->m.planes[plane].m.userptr;
+				v4l2_planes[plane].length =
+					b->m.planes[plane].length;
+			}
+		}
+		if (b->memory == V4L2_MEMORY_DMABUF) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].m.fd =
+					b->m.planes[plane].m.fd;
+				v4l2_planes[plane].length =
+					b->m.planes[plane].length;
+			}
+		}
 
-	/*
-	 * Request buffers and use MMAP type to force driver
-	 * to allocate buffers by itself.
-	 */
-	fileio->req.count = count;
-	fileio->req.memory = V4L2_MEMORY_MMAP;
-	fileio->req.type = q->type;
-	q->fileio = fileio;
-	ret = __reqbufs(q, &fileio->req);
-	if (ret)
-		goto err_kfree;
+		/* Fill in driver-provided information for OUTPUT types */
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+			/*
+			 * Will have to go up to b->length when API starts
+			 * accepting variable number of planes.
+			 *
+			 * If bytesused == 0 for the output buffer, then fall
+			 * back to the full buffer size. In that case
+			 * userspace clearly never bothered to set it and
+			 * it's a safe assumption that they really meant to
+			 * use the full plane sizes.
+			 */
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				struct v4l2_plane *pdst = &v4l2_planes[plane];
+				struct v4l2_plane *psrc = &b->m.planes[plane];
 
-	/*
-	 * Check if plane_count is correct
-	 * (multiplane buffers are not supported).
-	 */
-	vb = q->bufs[0];
-	if (vb->num_planes != 1) {
-		ret = -EBUSY;
-		goto err_reqbufs;
-	}
+				pdst->bytesused = psrc->bytesused ?
+					psrc->bytesused : pdst->length;
+				pdst->data_offset = psrc->data_offset;
+			}
+		}
+	} else {
+		/*
+		 * Single-planar buffers do not use planes array,
+		 * so fill in relevant v4l2_buffer struct fields instead.
+		 * In videobuf we use our internal V4l2_planes struct for
+		 * single-planar buffers as well, for simplicity.
+		 *
+		 * If bytesused == 0 for the output buffer, then fall back
+		 * to the full buffer size as that's a sensible default.
+		 */
+		if (b->memory == V4L2_MEMORY_USERPTR) {
+			v4l2_planes[0].m.userptr = b->m.userptr;
+			v4l2_planes[0].length = b->length;
+		}
 
-	/*
-	 * Get kernel address of each buffer.
-	 */
-	for (i = 0; i < q->num_buffers; i++) {
-		cb = container_of(q->bufs[i], struct vb2_v4l2_buffer, vb2);
-		fileio->bufs[i].vaddr = vb2_plane_vaddr(cb, 0);
-		if (fileio->bufs[i].vaddr == NULL) {
-			ret = -EINVAL;
-			goto err_reqbufs;
+		if (b->memory == V4L2_MEMORY_DMABUF) {
+			v4l2_planes[0].m.fd = b->m.fd;
+			v4l2_planes[0].length = b->length;
 		}
-		fileio->bufs[i].size = vb2_plane_size(cb, 0);
-	}
 
-	/*
-	 * Read mode requires pre queuing of all buffers.
-	 */
-	if (read) {
-		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
+		if (V4L2_TYPE_IS_OUTPUT(b->type))
+			v4l2_planes[0].bytesused = b->bytesused ?
+				b->bytesused : v4l2_planes[0].length;
+		else
+			v4l2_planes[0].bytesused = 0;
+
+	}
 
+	/* Zero flags that the vb2 core handles */
+	cb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
+	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
-		 * Queue all buffers.
+		 * Non-COPY timestamps and non-OUTPUT queues will get
+		 * their timestamp and timestamp source flags from the
+		 * queue.
 		 */
-		for (i = 0; i < q->num_buffers; i++) {
-			struct v4l2_buffer *b = &fileio->b;
+		cb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	}
 
-			memset(b, 0, sizeof(*b));
-			b->type = q->type;
-			if (is_multiplanar) {
-				memset(&fileio->p, 0, sizeof(fileio->p));
-				b->m.planes = &fileio->p;
-				b->length = 1;
-			}
-			b->memory = q->memory;
-			b->index = i;
-			ret = vb2_internal_qbuf(q, b);
-			if (ret)
-				goto err_reqbufs;
-			fileio->bufs[i].queued = 1;
-		}
+	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
-		 * All buffers have been queued, so mark that by setting
-		 * initial_index to q->num_buffers
+		 * For output buffers mask out the timecode flag:
+		 * this will be handled later in vb2_internal_qbuf().
+		 * The 'field' is valid metadata for this output buffer
+		 * and so that needs to be copied here.
 		 */
-		fileio->initial_index = q->num_buffers;
-		fileio->cur_index = q->num_buffers;
+		cb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		cb->v4l2_buf.field = b->field;
+	} else {
+		/* Zero any output buffer flags as this is a capture buffer */
+		cb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
 	}
 
-	/*
-	 * Start streaming.
-	 */
-	ret = vb2_internal_streamon(q, q->type);
-	if (ret)
-		goto err_reqbufs;
-
-	return ret;
-
-err_reqbufs:
-	fileio->req.count = 0;
-	__reqbufs(q, &fileio->req);
-
-err_kfree:
-	q->fileio = NULL;
-	kfree(fileio);
-	return ret;
+	return 0;
 }
 
 /**
- * __vb2_cleanup_fileio() - free resourced used by file io emulator
- * @q:		videobuf2 queue
+ * v4l2_qbuf_mmap() - handle qbuf of an MMAP buffer
  */
-static int __vb2_cleanup_fileio(struct vb2_queue *q)
+static int v4l2_qbuf_mmap(struct vb2_buffer *vb, void *pb)
 {
-	struct vb2_fileio_data *fileio = q->fileio;
-
-	if (fileio) {
-		vb2_internal_streamoff(q, q->type);
-		q->fileio = NULL;
-		fileio->req.count = 0;
-		vb2_reqbufs(q, &fileio->req);
-		kfree(fileio);
-		dprintk(3, "file io emulator closed\n");
-	}
-	return 0;
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	v4l2_fill_vb2_buffer(vb, b, cb->v4l2_planes);
+	return call_vb_qop(vb, buf_prepare, vb);
 }
 
 /**
- * __vb2_perform_fileio() - perform a single file io (read or write) operation
- * @q:		videobuf2 queue
- * @data:	pointed to target userspace buffer
- * @count:	number of bytes to read or write
- * @ppos:	file handle position tracking pointer
- * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
- * @read:	access mode selector (1 means read, 0 means write)
+ * v4l2_qbuf_userptr() - handle qbuf of a USERPTR buffer
  */
-static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock, int read)
+static int v4l2_qbuf_userptr(struct vb2_buffer *vb, void *pb)
 {
-	struct vb2_v4l2_buffer *cb;
-	struct vb2_fileio_data *fileio;
-	struct vb2_fileio_buf *buf;
-	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
-	/*
-	 * When using write() to write data to an output video node the vb2 core
-	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
-	 * else is able to provide this information with the write() operation.
-	 */
-	bool set_timestamp = !read &&
-		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-		V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	int ret, index;
-
-	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
-		read ? "read" : "write", (long)*ppos, count,
-		nonblock ? "non" : "");
-
-	if (!data)
-		return -EINVAL;
-
-	/*
-	 * Initialize emulator on first call.
-	 */
-	if (!vb2_fileio_is_active(q)) {
-		ret = __vb2_init_fileio(q, read);
-		dprintk(3, "vb2_init_fileio result: %d\n", ret);
-		if (ret)
-			return ret;
-	}
-	fileio = q->fileio;
-
-	/*
-	 * Check if we need to dequeue the buffer.
-	 */
-	index = fileio->cur_index;
-	if (index >= q->num_buffers) {
-		/*
-		 * Call vb2_dqbuf to get buffer back.
-		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		if (is_multiplanar) {
-			memset(&fileio->p, 0, sizeof(fileio->p));
-			fileio->b.m.planes = &fileio->p;
-			fileio->b.length = 1;
-		}
-		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
-		dprintk(5, "vb2_dqbuf result: %d\n", ret);
-		if (ret)
-			return ret;
-		fileio->dq_count += 1;
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_queue *q = vb->vb2_queue;
+	void *mem_priv;
+	unsigned int plane;
+	int ret;
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	bool reacquired = vb->planes[0].mem_priv == NULL;
 
-		fileio->cur_index = index = fileio->b.index;
-		buf = &fileio->bufs[index];
+	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
+	/* Copy relevant information provided by the userspace */
+	v4l2_fill_vb2_buffer(vb, pb, planes);
 
-		/*
-		 * Get number of bytes filled by the driver
-		 */
-		cb = container_of(q->bufs[index], struct vb2_v4l2_buffer, vb2);
-		buf->pos = 0;
-		buf->queued = 0;
-		buf->size = read ? vb2_get_plane_payload(cb, 0)
-				 : vb2_plane_size(cb, 0);
-		/* Compensate for data_offset on read in the multiplanar case. */
-		if (is_multiplanar && read &&
-		    fileio->b.m.planes[0].data_offset < buf->size) {
-			buf->pos = fileio->b.m.planes[0].data_offset;
-			buf->size -= buf->pos;
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		/* Skip the plane if already verified */
+		if (cb->v4l2_planes[plane].m.userptr &&
+		    cb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
+		    && cb->v4l2_planes[plane].length == planes[plane].length)
+			continue;
+
+		dprintk(3, "userspace address for plane %d changed, "
+				"reacquiring memory\n", plane);
+
+		/* Check if the provided plane buffer is large enough */
+		if (planes[plane].length < q->plane_sizes[plane]) {
+			dprintk(1, "provided buffer size %u is less than "
+						"setup size %u for plane %d\n",
+						planes[plane].length,
+						q->plane_sizes[plane], plane);
+			ret = -EINVAL;
+			goto err;
 		}
-	} else {
-		buf = &fileio->bufs[index];
-	}
 
-	/*
-	 * Limit count on last few bytes of the buffer.
-	 */
-	if (buf->pos + count > buf->size) {
-		count = buf->size - buf->pos;
-		dprintk(5, "reducing read count: %zd\n", count);
-	}
+		/* Release previously acquired memory if present */
+		if (vb->planes[plane].mem_priv) {
+			if (!reacquired) {
+				reacquired = true;
+				call_void_vb_qop(vb, buf_cleanup, vb);
+			}
+			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+		}
 
-	/*
-	 * Transfer data to userspace.
-	 */
-	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
-		count, index, buf->pos);
-	if (read)
-		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
-	else
-		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
-	if (ret) {
-		dprintk(3, "error copying data\n");
-		return -EFAULT;
+		vb->planes[plane].mem_priv = NULL;
+		memset(&cb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+
+		/* Acquire each plane's memory */
+		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
+				      planes[plane].m.userptr,
+				      planes[plane].length, dma_dir);
+		if (IS_ERR_OR_NULL(mem_priv)) {
+			dprintk(1, "failed acquiring userspace "
+						"memory for plane %d\n", plane);
+			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
+			goto err;
+		}
+		vb->planes[plane].mem_priv = mem_priv;
 	}
 
 	/*
-	 * Update counters.
+	 * Now that everything is in order, copy relevant information
+	 * provided by userspace.
 	 */
-	buf->pos += count;
-	*ppos += count;
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		cb->v4l2_planes[plane] = planes[plane];
 
-	/*
-	 * Queue next buffer if required.
-	 */
-	if (buf->pos == buf->size ||
-	   (!read && (fileio->flags & VB2_FILEIO_WRITE_IMMEDIATELY))) {
+	if (reacquired) {
 		/*
-		 * Check if this is the last buffer to read.
+		 * One or more planes changed, so we must call buf_init to do
+		 * the driver-specific initialization on the newly acquired
+		 * buffer, if provided.
 		 */
-		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
-		    fileio->dq_count == 1) {
-			dprintk(3, "read limit reached\n");
-			return __vb2_cleanup_fileio(q);
+		ret = call_vb_qop(vb, buf_init, vb);
+		if (ret) {
+			dprintk(1, "buffer initialization failed\n");
+			goto err;
 		}
+	}
 
-		/*
-		 * Call vb2_qbuf and give buffer to the driver.
-		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		fileio->b.index = index;
-		fileio->b.bytesused = buf->pos;
-		if (is_multiplanar) {
-			memset(&fileio->p, 0, sizeof(fileio->p));
-			fileio->p.bytesused = buf->pos;
-			fileio->b.m.planes = &fileio->p;
-			fileio->b.length = 1;
-		}
-		if (set_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
-		dprintk(5, "vb2_dbuf result: %d\n", ret);
-		if (ret)
-			return ret;
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "buffer preparation failed\n");
+		call_void_vb_qop(vb, buf_cleanup, vb);
+		goto err;
+	}
 
-		/*
-		 * Buffer has been queued, update the status
-		 */
-		cb = container_of(q->bufs[index], struct vb2_v4l2_buffer, vb2);
-		buf->pos = 0;
-		buf->queued = 1;
-		buf->size = vb2_plane_size(cb, 0);
-		fileio->q_count += 1;
-		/*
-		 * If we are queuing up buffers for the first time, then
-		 * increase initial_index by one.
-		 */
-		if (fileio->initial_index < q->num_buffers)
-			fileio->initial_index++;
-		/*
-		 * The next buffer to use is either a buffer that's going to be
-		 * queued for the first time (initial_index < q->num_buffers)
-		 * or it is equal to q->num_buffers, meaning that the next
-		 * time we need to dequeue a buffer since we've now queued up
-		 * all the 'first time' buffers.
-		 */
-		fileio->cur_index = fileio->initial_index;
+	return 0;
+err:
+	/* In case of errors, release planes that were already acquired */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		if (vb->planes[plane].mem_priv)
+			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
+		cb->v4l2_planes[plane].m.userptr = 0;
+		cb->v4l2_planes[plane].length = 0;
 	}
 
-	/*
-	 * Return proper number of bytes processed.
-	 */
-	if (ret == 0)
-		ret = count;
 	return ret;
 }
 
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblocking)
+/**
+ * v4l2_qbuf_dmabuf() - handle qbuf of a DMABUF buffer
+ */
+static int v4l2_qbuf_dmabuf(struct vb2_buffer *vb, void *pb)
 {
-	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
-}
-EXPORT_SYMBOL_GPL(vb2_read);
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_queue *q = vb->vb2_queue;
+	void *mem_priv;
+	unsigned int plane;
+	int ret;
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	bool reacquired = vb->planes[0].mem_priv == NULL;
 
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblocking)
-{
-	return __vb2_perform_fileio(q, (char __user *) data, count,
-							ppos, nonblocking, 0);
-}
-EXPORT_SYMBOL_GPL(vb2_write);
+	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
+	/* Copy relevant information provided by the userspace */
+	v4l2_fill_vb2_buffer(vb, b, planes);
 
-struct vb2_threadio_data {
-	struct task_struct *thread;
-	vb2_thread_fnc fnc;
-	void *priv;
-	bool stop;
-};
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
 
-static int vb2_thread(void *data)
-{
-	struct vb2_queue *q = data;
-	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
-	bool set_timestamp = false;
-	int prequeue = 0;
-	int index = 0;
-	int ret = 0;
+		if (IS_ERR_OR_NULL(dbuf)) {
+			dprintk(1, "invalid dmabuf fd for plane %d\n",
+				plane);
+			ret = -EINVAL;
+			goto err;
+		}
 
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
-		prequeue = q->num_buffers;
-		set_timestamp =
-			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-			V4L2_BUF_FLAG_TIMESTAMP_COPY;
+		/* use DMABUF size if length is not provided */
+		if (planes[plane].length == 0)
+			planes[plane].length = dbuf->size;
+
+		if (planes[plane].length < q->plane_sizes[plane]) {
+			dprintk(1, "invalid dmabuf length for plane %d\n",
+				plane);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		/* Skip the plane if already verified */
+		if (dbuf == vb->planes[plane].dbuf &&
+		    cb->v4l2_planes[plane].length == planes[plane].length) {
+			dma_buf_put(dbuf);
+			continue;
+		}
+
+		dprintk(1, "buffer for plane %d changed\n", plane);
+
+		if (!reacquired) {
+			reacquired = true;
+			call_void_vb_qop(vb, buf_cleanup, vb);
+		}
+
+		/* Release previously acquired memory if present */
+		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
+		memset(&cb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+
+		/* Acquire each plane's memory */
+		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
+			dbuf, planes[plane].length, dma_dir);
+		if (IS_ERR(mem_priv)) {
+			dprintk(1, "failed to attach dmabuf\n");
+			ret = PTR_ERR(mem_priv);
+			dma_buf_put(dbuf);
+			goto err;
+		}
+
+		vb->planes[plane].dbuf = dbuf;
+		vb->planes[plane].mem_priv = mem_priv;
 	}
 
-	set_freezable();
+	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
+	 * really we want to do this just before the DMA, not while queueing
+	 * the buffer(s)..
+	 */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
+		if (ret) {
+			dprintk(1, "failed to map dmabuf for plane %d\n",
+				plane);
+			goto err;
+		}
+		vb->planes[plane].dbuf_mapped = 1;
+	}
 
-	for (;;) {
-		struct vb2_v4l2_buffer *cb;
-		struct vb2_buffer *vb;
+	/*
+	 * Now that everything is in order, copy relevant information
+	 * provided by userspace.
+	 */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		cb->v4l2_planes[plane] = planes[plane];
 
+	if (reacquired) {
 		/*
-		 * Call vb2_dqbuf to get buffer back.
+		 * Call driver-specific initialization on the newly acquired buffer,
+		 * if provided.
 		 */
-		memset(&fileio->b, 0, sizeof(fileio->b));
-		fileio->b.type = q->type;
-		fileio->b.memory = q->memory;
-		if (prequeue) {
-			fileio->b.index = index++;
-			prequeue--;
-		} else {
-			call_void_qop(q, wait_finish, q);
-			if (!threadio->stop)
-				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
-			call_void_qop(q, wait_prepare, q);
-			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
+		ret = call_vb_qop(vb, buf_init, vb);
+		if (ret) {
+			dprintk(1, "buffer initialization failed\n");
+			goto err;
 		}
-		if (ret || threadio->stop)
-			break;
-		try_to_freeze();
-
-		vb = q->bufs[fileio->b.index];
-		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
-		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
-			if (threadio->fnc(cb, threadio->priv))
-				break;
-		call_void_qop(q, wait_finish, q);
-		if (set_timestamp)
-			v4l2_get_timestamp(&fileio->b.timestamp);
-		if (!threadio->stop)
-			ret = vb2_internal_qbuf(q, &fileio->b);
-		call_void_qop(q, wait_prepare, q);
-		if (ret || threadio->stop)
-			break;
 	}
 
-	/* Hmm, linux becomes *very* unhappy without this ... */
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
+	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "buffer preparation failed\n");
+		call_void_vb_qop(vb, buf_cleanup, vb);
+		goto err;
 	}
-	return 0;
-}
-
-/*
- * This function should not be used for anything else but the videobuf2-dvb
- * support. If you think you have another good use-case for this, then please
- * contact the linux-media mailinglist first.
- */
-int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
-		     const char *thread_name)
-{
-	struct vb2_threadio_data *threadio;
-	int ret = 0;
 
-	if (q->threadio)
-		return -EBUSY;
-	if (vb2_is_busy(q))
-		return -EBUSY;
-	if (WARN_ON(q->fileio))
-		return -EBUSY;
-
-	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
-	if (threadio == NULL)
-		return -ENOMEM;
-	threadio->fnc = fnc;
-	threadio->priv = priv;
-
-	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
-	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
-	if (ret)
-		goto nomem;
-	q->threadio = threadio;
-	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
-	if (IS_ERR(threadio->thread)) {
-		ret = PTR_ERR(threadio->thread);
-		threadio->thread = NULL;
-		goto nothread;
-	}
 	return 0;
+err:
+	/* In case of errors, release planes that were already acquired */
+	__vb2_buf_dmabuf_put(vb);
 
-nothread:
-	__vb2_cleanup_fileio(q);
-nomem:
-	kfree(threadio);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vb2_thread_start);
 
-int vb2_thread_stop(struct vb2_queue *q)
+static int v4l2_is_alternate(void *pb)
 {
-	struct vb2_threadio_data *threadio = q->threadio;
-	int err;
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
 
-	if (threadio == NULL)
-		return 0;
-	threadio->stop = true;
-	/* Wake up all pending sleeps in the thread */
-	vb2_queue_error(q);
-	err = kthread_stop(threadio->thread);
-	__vb2_cleanup_fileio(q);
-	threadio->thread = NULL;
-	kfree(threadio);
-	q->threadio = NULL;
-	return err;
+	return (b->field == V4L2_FIELD_ALTERNATE);
 }
-EXPORT_SYMBOL_GPL(vb2_thread_stop);
-
-/*
- * The following functions are not part of the vb2 core API, but are helper
- * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
- * and struct vb2_ops.
- * They contain boilerplate code that most if not all drivers have to do
- * and so they simplify the driver code.
- */
 
-/* The queue is busy if there is a owner and you are not that owner. */
-static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
+static int v4l2_init_timestamp(struct vb2_buffer *vb)
 {
-	return vdev->queue->owner && vdev->queue->owner != file->private_data;
-}
-
-/* vb2 ioctl helpers */
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
 
-int vb2_ioctl_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p)
-{
-	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
+	cb->v4l2_buf.timestamp.tv_sec = 0;
+	cb->v4l2_buf.timestamp.tv_usec = 0;
+	cb->v4l2_buf.sequence = 0;
 
-	if (res)
-		return res;
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	res = __reqbufs(vdev->queue, p);
-	/* If count == 0, then the owner has released all buffers and he
-	   is no longer owner of the queue. Otherwise we have a new owner. */
-	if (res == 0)
-		vdev->queue->owner = p->count ? file->private_data : NULL;
-	return res;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
 
-int vb2_ioctl_create_bufs(struct file *file, void *priv,
-			  struct v4l2_create_buffers *p)
+static int v4l2_set_timestamp(struct vb2_buffer *vb, void *pb)
 {
-	struct video_device *vdev = video_devdata(file);
-	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_queue *q = vb->vb2_queue;
 
-	p->index = vdev->queue->num_buffers;
-	/* If count == 0, then just check if memory and type are valid.
-	   Any -EBUSY result from __verify_memory_type can be mapped to 0. */
-	if (p->count == 0)
-		return res != -EBUSY ? res : 0;
-	if (res)
-		return res;
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	res = __create_bufs(vdev->queue, p);
-	if (res == 0)
-		vdev->queue->owner = file->private_data;
-	return res;
+	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+			V4L2_BUF_FLAG_TIMESTAMP_COPY)
+		cb->v4l2_buf.timestamp = b->timestamp;
+	cb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+		cb->v4l2_buf.timecode = b->timecode;
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
 
-int vb2_ioctl_prepare_buf(struct file *file, void *priv,
-			  struct v4l2_buffer *p)
+static int v4l2_poll_wait(struct file *file, unsigned long req_events, poll_table *wait)
 {
-	struct video_device *vdev = video_devdata(file);
+	struct video_device *vfd = video_devdata(file);
+	int ret = 0;
 
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_prepare_buf(vdev->queue, p);
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
+
+		if (v4l2_event_pending(fh))
+			ret = POLLPRI;
+		else if (req_events & POLLPRI)
+			poll_wait(file, &fh->wait, wait);
+	}
+	return ret;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
 
-int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+static int v4l2_get_buffer_index(struct vb2_buffer *vb)
 {
-	struct video_device *vdev = video_devdata(file);
-
-	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
-	return vb2_querybuf(vdev->queue, p);
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	return (int)cb->v4l2_buf.index;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
 
-int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+static int v4l2_set_plane_length(struct vb2_buffer *vb, int plane, unsigned int val)
 {
-	struct video_device *vdev = video_devdata(file);
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	cb->v4l2_planes[plane].length = val;
+	return 0;
+}
 
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_qbuf(vdev->queue, p);
+static int v4l2_get_plane_length(struct vb2_buffer *vb, int plane)
+{
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	return cb->v4l2_planes[plane].length;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
 
-int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+static int v4l2_init_buffer(struct vb2_buffer *vb, struct vb2_queue *q,
+		unsigned int buffer, unsigned int memory, unsigned int planes)
 {
-	struct video_device *vdev = video_devdata(file);
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
 
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
+	cb->v4l2_buf.index = q->num_buffers + buffer;
+	cb->v4l2_buf.type = q->type;
+	cb->v4l2_buf.memory = memory;
+
+	/* Length stores number of planes for multiplanar buffers */
+	if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
+		cb->v4l2_buf.length = planes;
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
 
-int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+/**
+ * v4l2_setup_offsets() - setup unique offsets ("cookies") for every plane in
+ * every buffer on the queue
+ */
+static int v4l2_setup_offsets(struct vb2_queue *q, unsigned int n)
 {
-	struct video_device *vdev = video_devdata(file);
+	unsigned int buffer, plane;
+	struct vb2_v4l2_buffer *cb;
+	struct vb2_buffer *vb;
+	unsigned long off;
 
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_streamon(vdev->queue, i);
+	if (q->num_buffers) {
+		struct v4l2_plane *p;
+		vb = q->bufs[q->num_buffers - 1];
+		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+		p = &cb->v4l2_planes[vb->num_planes - 1];
+		off = PAGE_ALIGN(p->m.mem_offset + p->length);
+	} else {
+		off = 0;
+	}
+
+	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			cb->v4l2_planes[plane].m.mem_offset = off;
+
+			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
+					buffer, plane, off);
+
+			off += cb->v4l2_planes[plane].length;
+			off = PAGE_ALIGN(off);
+		}
+	}
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
 
-int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+/**
+ * v4l2_verify_planes_array() - verify that the planes array passed in struct
+ * v4l2_buffer from userspace can be safely used
+ */
+static int v4l2_verify_planes_array(struct vb2_buffer *vb, void *pb)
 {
-	struct video_device *vdev = video_devdata(file);
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
+		return 0;
 
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_streamoff(vdev->queue, i);
-}
-EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
+	/* Is memory for copying plane information present? */
+	if (NULL == b->m.planes) {
+		dprintk(1, "multi-planar buffer passed but "
+			   "planes array not provided\n");
+		return -EINVAL;
+	}
 
-int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
-{
-	struct video_device *vdev = video_devdata(file);
+	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
+		dprintk(1, "incorrect planes array length, "
+			   "expected %d, got %d\n", vb->num_planes, b->length);
+		return -EINVAL;
+	}
 
-	if (vb2_queue_is_busy(vdev, file))
-		return -EBUSY;
-	return vb2_expbuf(vdev->queue, p);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
-
-/* v4l2_file_operations helpers */
 
-int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
+/**
+ * v4l2_verify_length() - Verify that the bytesused value for each plane fits in
+ * the plane length and that the data offset doesn't exceed the bytesused value.
+ */
+static int v4l2_verify_length(struct vb2_buffer *vb, void *pb)
 {
-	struct video_device *vdev = video_devdata(file);
-
-	return vb2_mmap(vdev->queue, vma);
-}
-EXPORT_SYMBOL_GPL(vb2_fop_mmap);
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+	unsigned int length;
+	unsigned int bytesused;
+	unsigned int plane;
 
-int _vb2_fop_release(struct file *file, struct mutex *lock)
-{
-	struct video_device *vdev = video_devdata(file);
+	if (!V4L2_TYPE_IS_OUTPUT(b->type))
+		return 0;
 
-	if (lock)
-		mutex_lock(lock);
-	if (file->private_data == vdev->queue->owner) {
-		vb2_queue_release(vdev->queue);
-		vdev->queue->owner = NULL;
-	}
-	if (lock)
-		mutex_unlock(lock);
-	return v4l2_fh_release(file);
-}
-EXPORT_SYMBOL_GPL(_vb2_fop_release);
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			length = (b->memory == V4L2_MEMORY_USERPTR ||
+				  b->memory == V4L2_MEMORY_DMABUF)
+			       ? b->m.planes[plane].length
+			       : cb->v4l2_planes[plane].length;
+			bytesused = b->m.planes[plane].bytesused
+				  ? b->m.planes[plane].bytesused : length;
 
-int vb2_fop_release(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
+			if (b->m.planes[plane].bytesused > length)
+				return -EINVAL;
 
-	return _vb2_fop_release(file, lock);
-}
-EXPORT_SYMBOL_GPL(vb2_fop_release);
+			if (b->m.planes[plane].data_offset > 0 &&
+			    b->m.planes[plane].data_offset >= bytesused)
+				return -EINVAL;
+		}
+	} else {
+		length = (b->memory == V4L2_MEMORY_USERPTR)
+		       ? b->length : cb->v4l2_planes[0].length;
+		bytesused = b->bytesused ? b->bytesused : length;
 
-ssize_t vb2_fop_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-	int err = -EBUSY;
+		if (b->bytesused > length)
+			return -EINVAL;
+	}
 
-	if (lock && mutex_lock_interruptible(lock))
-		return -ERESTARTSYS;
-	if (vb2_queue_is_busy(vdev, file))
-		goto exit;
-	err = vb2_write(vdev->queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
-	if (vdev->queue->fileio)
-		vdev->queue->owner = file->private_data;
-exit:
-	if (lock)
-		mutex_unlock(lock);
-	return err;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_fop_write);
 
-ssize_t vb2_fop_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
+/**
+ * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
+ * returned to userspace
+ */
+static int v4l2_fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-	int err = -EBUSY;
+	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
+	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
 
-	if (lock && mutex_lock_interruptible(lock))
-		return -ERESTARTSYS;
-	if (vb2_queue_is_busy(vdev, file))
-		goto exit;
-	err = vb2_read(vdev->queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
-	if (vdev->queue->fileio)
-		vdev->queue->owner = file->private_data;
-exit:
-	if (lock)
-		mutex_unlock(lock);
-	return err;
-}
-EXPORT_SYMBOL_GPL(vb2_fop_read);
+	/* Copy back data such as timestamp, flags, etc. */
+	memcpy(b, &cb->v4l2_buf, offsetof(struct v4l2_buffer, m));
+	b->reserved2 = cb->v4l2_buf.reserved2;
+	b->reserved = cb->v4l2_buf.reserved;
 
-unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
-{
-	struct video_device *vdev = video_devdata(file);
-	struct vb2_queue *q = vdev->queue;
-	struct mutex *lock = q->lock ? q->lock : vdev->lock;
-	unsigned res;
-	void *fileio;
+	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+		/*
+		 * Fill in plane-related data if userspace provided an array
+		 * for it. The caller has already verified memory and size.
+		 */
+		b->length = vb->num_planes;
+		memcpy(b->m.planes, cb->v4l2_planes,
+			b->length * sizeof(struct v4l2_plane));
+	} else {
+		/*
+		 * We use length and offset in v4l2_planes array even for
+		 * single-planar buffers, but userspace does not.
+		 */
+		b->length = cb->v4l2_planes[0].length;
+		b->bytesused = cb->v4l2_planes[0].bytesused;
+		if (q->memory == V4L2_MEMORY_MMAP)
+			b->m.offset = cb->v4l2_planes[0].m.mem_offset;
+		else if (q->memory == V4L2_MEMORY_USERPTR)
+			b->m.userptr = cb->v4l2_planes[0].m.userptr;
+		else if (q->memory == V4L2_MEMORY_DMABUF)
+			b->m.fd = cb->v4l2_planes[0].m.fd;
+	}
 
 	/*
-	 * If this helper doesn't know how to lock, then you shouldn't be using
-	 * it but you should write your own.
+	 * Clear any buffer state related flags.
 	 */
-	WARN_ON(!lock);
-
-	if (lock && mutex_lock_interruptible(lock))
-		return POLLERR;
+	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
+	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
+	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+		/*
+		 * For non-COPY timestamps, drop timestamp source bits
+		 * and obtain the timestamp source from the queue.
+		 */
+		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	}
 
-	fileio = q->fileio;
+	switch (vb->state) {
+	case VB2_BUF_STATE_QUEUED:
+	case VB2_BUF_STATE_ACTIVE:
+		b->flags |= V4L2_BUF_FLAG_QUEUED;
+		break;
+	case VB2_BUF_STATE_ERROR:
+		b->flags |= V4L2_BUF_FLAG_ERROR;
+		/* fall through */
+	case VB2_BUF_STATE_DONE:
+		b->flags |= V4L2_BUF_FLAG_DONE;
+		break;
+	case VB2_BUF_STATE_PREPARED:
+		b->flags |= V4L2_BUF_FLAG_PREPARED;
+		break;
+	case VB2_BUF_STATE_PREPARING:
+	case VB2_BUF_STATE_DEQUEUED:
+		/* nothing */
+		break;
+	}
 
-	res = vb2_poll(vdev->queue, file, wait);
+	if (__buffer_in_use(q, vb))
+		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
-	/* If fileio was started, then we have a new queue owner. */
-	if (!fileio && q->fileio)
-		q->owner = file->private_data;
-	if (lock)
-		mutex_unlock(lock);
-	return res;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(vb2_fop_poll);
 
-#ifndef CONFIG_MMU
-unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+/**
+ * v4l2_find_plane_by_offset() - find plane associated with the given offset off
+ */
+static int v4l2_find_plane_by_offset(struct vb2_queue *q, unsigned long off,
+			unsigned int *_buffer, unsigned int *_plane)
 {
-	struct video_device *vdev = video_devdata(file);
-
-	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
-}
-EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
-#endif
+	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *cb;
+	unsigned int buffer, plane;
 
-/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
+	/*
+	 * Go over all buffers and their planes, comparing the given offset
+	 * with an offset assigned to each plane. If a match is found,
+	 * return its buffer and plane numbers.
+	 */
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		vb = q->bufs[buffer];
+		cb = container_of(vb, struct vb2_v4l2_buffer, vb2);
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			if (cb->v4l2_planes[plane].m.mem_offset == off) {
+				*_buffer = buffer;
+				*_plane = plane;
+				return 0;
+			}
+		}
+	}
 
-void vb2_ops_wait_prepare(struct vb2_queue *vq)
-{
-	mutex_unlock(vq->lock);
+	return -EINVAL;
 }
-EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
 
-void vb2_ops_wait_finish(struct vb2_queue *vq)
-{
-	mutex_lock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
+const struct vb2_priv_ops vb2_v4l2_operations = {
+	.get_buffer_index = v4l2_get_buffer_index,
+	.set_plane_length = v4l2_set_plane_length,
+	.get_plane_length = v4l2_get_plane_length,
+	.init_priv_buffer = v4l2_init_buffer,
+	.setup_offsets = v4l2_setup_offsets,
+	.verify_planes_array = v4l2_verify_planes_array,
+	.verify_length = v4l2_verify_length,
+	.fill_priv_buffer = v4l2_fill_v4l2_buffer,
+	.fill_vb2_buffer = v4l2_fill_vb2_buffer,
+	.qbuf_mmap = v4l2_qbuf_mmap,
+	.qbuf_userptr = v4l2_qbuf_userptr,
+	.qbuf_dmabuf = v4l2_qbuf_dmabuf,
+	.is_alternate = v4l2_is_alternate,
+	.init_timestamp = v4l2_init_timestamp,
+	.set_timestamp = v4l2_set_timestamp,
+	.find_plane_by_offset = v4l2_find_plane_by_offset,
+	.poll_wait = v4l2_poll_wait,
+};
+EXPORT_SYMBOL_GPL(vb2_v4l2_operations);
 
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 225c2a6..f4f2e07 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -103,7 +103,7 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 static inline void
 v4l2_m2m_buf_done(struct vb2_v4l2_buffer *buf, enum vb2_buffer_state state)
 {
-	vb2_buffer_done(buf, state);
+	vb2_buffer_done(&buf->vb2, state);
 }
 
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 24c229d..5e379a4 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -18,6 +18,48 @@
 #include <linux/videodev2.h>
 #include <linux/dma-buf.h>
 
+// redefine enum values and macro function common-used
+#define MEDIA_MAX_FRAME		(VIDEO_MAX_FRAME) //32
+#define MEDIA_MAX_PLANES    (VIDEO_MAX_PLANES) //8
+
+enum media_memory {
+	MEDIA_MEMORY_MMAP		= V4L2_MEMORY_MMAP,
+	MEDIA_MEMORY_USERPTR	= V4L2_MEMORY_USERPTR,
+	MEDIA_MEMORY_OVERLAY	= V4L2_MEMORY_OVERLAY,
+	MEDIA_MEMORY_DMABUF		= V4L2_MEMORY_DMABUF,
+};
+
+enum media_buf_type {
+	MEDIA_BUF_TYPE_VIDEO_CAPTURE		= V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	MEDIA_BUF_TYPE_VIDEO_OUTPUT			= V4L2_BUF_TYPE_VIDEO_OUTPUT,
+	MEDIA_BUF_TYPE_VIDEO_OVERLAY		= V4L2_BUF_TYPE_VIDEO_OVERLAY,
+	MEDIA_BUF_TYPE_VBI_CAPTURE			= V4L2_BUF_TYPE_VBI_CAPTURE,
+	MEDIA_BUF_TYPE_VBI_OUTPUT			= V4L2_BUF_TYPE_VBI_OUTPUT,
+	MEDIA_BUF_TYPE_SLICED_VBI_CAPTURE	= V4L2_BUF_TYPE_SLICED_VBI_CAPTURE,
+	MEDIA_BUF_TYPE_SLICED_VBI_OUTPUT	= V4L2_BUF_TYPE_SLICED_VBI_OUTPUT,
+#if 1
+	/* Experimental */
+	MEDIA_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	= V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY,
+#endif
+	MEDIA_BUF_TYPE_VIDEO_CAPTURE_MPLANE	= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	MEDIA_BUF_TYPE_VIDEO_OUTPUT_MPLANE	= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
+	MEDIA_BUF_TYPE_SDR_CAPTURE			= V4L2_BUF_TYPE_SDR_CAPTURE,
+	/* Deprecated, do not use */
+	MEDIA_BUF_TYPE_PRIVATE				= 0x80,
+	MEDIA_BUF_TYPE_DVB_CAPTURE			= 0x81,
+	MEDIA_BUF_TYPE_DVB_OUTPUT			= 0x82,
+};
+
+#define MEDIA_TYPE_IS_MULTIPLANAR(type)		\
+		(V4L2_TYPE_IS_MULTIPLANAR(type))
+
+#define MEDIA_TYPE_IS_OUTPUT(type)			\
+		(V4L2_TYPE_IS_OUTPUT(type) || (type) == MEDIA_BUF_TYPE_DVB_OUTPUT)
+
+#define MEDIA_TYPE_IS_DVB(type)			\
+		((type) == MEDIA_BUF_TYPE_DVB_CAPTURE	\
+		|| (type) == MEDIA_BUF_TYPE_DVB_OUTPUT)
+
 struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
@@ -192,7 +234,7 @@ struct vb2_buffer {
 	struct list_head	queued_entry;
 	struct list_head	done_entry;
 
-	struct vb2_plane	planes[VIDEO_MAX_PLANES];
+	struct vb2_plane	planes[MEDIA_MAX_PLANES];
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
@@ -324,6 +366,29 @@ struct vb2_ops {
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
 
+struct vb2_priv_ops {
+	int (*get_buffer_index)(struct vb2_buffer *vb);
+	int (*set_plane_length)(struct vb2_buffer *vb, int plane, unsigned int val);
+	int (*get_plane_length)(struct vb2_buffer *vb, int plane);
+	int (*init_priv_buffer)(struct vb2_buffer *vb, struct vb2_queue *q,
+		unsigned int buffer, unsigned int memory, unsigned int planes);
+	int (*setup_offsets)(struct vb2_queue *q, unsigned int n);
+	int (*verify_planes_array)(struct vb2_buffer *vb, void *pb);
+	int (*verify_length)(struct vb2_buffer *vb, void *pb);
+	int (*fill_priv_buffer)(struct vb2_buffer *vb, void *pb);
+	int (*fill_vb2_buffer)(struct vb2_buffer *vb, void *pbuffer, void *pplane);
+	int (*qbuf_mmap)(struct vb2_buffer *vb, void *pb);
+	int (*qbuf_userptr)(struct vb2_buffer *vb, void *pb);
+	int (*qbuf_dmabuf)(struct vb2_buffer *vb, void *pb);
+	int (*is_alternate)(void *pb);
+	int (*init_timestamp)(struct vb2_buffer *vb);
+	int (*set_timestamp)(struct vb2_buffer *vb, void *pb);
+	int (*find_plane_by_offset)(struct vb2_queue *q, unsigned long off,
+			unsigned int *_buffer, unsigned int *_plane);
+	int (*poll_wait)(struct file *file, unsigned long req_events, poll_table *wait);
+	int (*get_buf_siz)(void);
+};
+
 /**
  * struct vb2_queue - a videobuf queue
  *
@@ -331,7 +396,7 @@ struct vb2_ops {
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @io_flags:	additional io flags (see vb2_fileio_flags enum)
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
- *		driver can set this to a mutex to let the v4l2 core serialize
+ *		driver can set this to a mutex to let the core serialize
  *		the queuing ioctls. If the driver wants to handle locking
  *		itself, then this should be set to NULL. This lock is not used
  *		by the videobuf2 core API.
@@ -385,6 +450,8 @@ struct vb2_queue {
 
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
+	const struct vb2_priv_ops    *priv_ops;
+	
 	void				*drv_priv;
 	unsigned int			buf_struct_size;
 	u32				timestamp_flags;
@@ -394,7 +461,7 @@ struct vb2_queue {
 /* private: internal use only */
 	struct mutex			mmap_lock;
 	unsigned int			memory;
-	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	struct vb2_buffer		*bufs[MEDIA_MAX_FRAME];
 	unsigned int			num_buffers;
 
 	struct list_head		queued_list;
@@ -405,8 +472,8 @@ struct vb2_queue {
 	spinlock_t			done_lock;
 	wait_queue_head_t		done_wq;
 
-	void				*alloc_ctx[VIDEO_MAX_PLANES];
-	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
+	void				*alloc_ctx[MEDIA_MAX_PLANES];
+	unsigned int			plane_sizes[MEDIA_MAX_PLANES];
 
 	unsigned int			streaming:1;
 	unsigned int			start_streaming_called:1;
@@ -428,4 +495,153 @@ struct vb2_queue {
 	u32				cnt_stop_streaming;
 #endif
 };
+
+int get_vb2_debug(void);
+
+void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+void vb2_discard_done(struct vb2_queue *q);
+
+int vb2_wait_for_all_buffers(struct vb2_queue *q);
+
+int vb2_core_querybuf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, void *ab);
+int vb2_core_reqbufs(struct vb2_queue *q, unsigned int count, 
+		unsigned int type, unsigned int memory);
+
+int vb2_core_create_bufs(struct vb2_queue *q, unsigned int count,
+		unsigned int type, unsigned int memory, void *format);
+int vb2_core_prepare_buf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *ab);
+
+int __must_check vb2_queue_init(struct vb2_queue *q);
+
+void vb2_queue_release(struct vb2_queue *q);
+void vb2_queue_error(struct vb2_queue *q);
+
+int vb2_core_qbuf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *ab);
+int vb2_core_expbuf(struct vb2_queue *q, unsigned int type, unsigned int index,
+		unsigned int plane, unsigned int flags);
+int vb2_core_dqbuf(struct vb2_queue *q, enum media_buf_type type, void *ab, bool nonblocking);
+
+int vb2_core_streamon(struct vb2_queue *q, enum media_buf_type type);
+int vb2_core_streamoff(struct vb2_queue *q, enum media_buf_type type);
+
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
+int vb2_internal_dqbuf(struct vb2_queue *q, enum media_buf_type type, void *pb,
+		bool nonblocking);
+int vb2_internal_qbuf(struct vb2_queue *q, enum media_buf_type type,
+		unsigned int index, unsigned int memory, void *pb);
+int vb2_internal_streamoff(struct vb2_queue *q, enum media_buf_type type);
+int vb2_internal_streamon(struct vb2_queue *q, enum media_buf_type type);
+
+#ifndef CONFIG_MMU
+unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
+				    unsigned long addr,
+				    unsigned long len,
+				    unsigned long pgoff,
+				    unsigned long flags);
+#endif
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
+size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		loff_t *ppos, int nonblock);
+size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		loff_t *ppos, int nonblock);
+/**
+ * vb2_thread_fnc - callback function for use with vb2_thread
+ *
+ * This is called whenever a buffer is dequeued in the thread.
+ */
+typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
+
+/**
+ * vb2_thread_start() - start a thread for the given queue.
+ * @q:		videobuf queue
+ * @fnc:	callback function
+ * @priv:	priv pointer passed to the callback function
+ * @thread_name:the name of the thread. This will be prefixed with "vb2-".
+ *
+ * This starts a thread that will queue and dequeue until an error occurs
+ * or @vb2_thread_stop is called.
+ *
+ * This function should not be used for anything else but the videobuf2-dvb
+ * support. If you think you have another good use-case for this, then please
+ * contact the linux-media mailinglist first.
+ */
+int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
+		     const char *thread_name);
+
+/**
+ * vb2_thread_stop() - stop the thread for the given queue.
+ * @q:		videobuf queue
+ */
+int vb2_thread_stop(struct vb2_queue *q);
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
+bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
+int __verify_memory_type(struct vb2_queue *q,
+		enum media_memory memory, enum media_buf_type type);
+void __vb2_queue_cancel(struct vb2_queue *q);
+int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers);
+int __reqbufs(struct vb2_queue *q, unsigned int count,
+		unsigned int type, unsigned int memory);
+int __create_bufs(struct vb2_queue *q,  unsigned int count,
+		unsigned int type, unsigned int memory, void *format);
+void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p);
+void __vb2_buf_dmabuf_put(struct vb2_buffer *vb);
+
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 36f7ea3..e054baa 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -16,9 +16,9 @@
 #include <media/videobuf2-v4l2.h>
 
 static inline struct sg_table *vb2_dma_sg_plane_desc(
-		struct vb2_v4l2_buffer *vb, unsigned int plane_no)
+		struct vb2_v4l2_buffer *cb, unsigned int plane_no)
 {
-	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
+	return (struct sg_table *)vb2_plane_cookie(cb, plane_no);
 }
 
 void *vb2_dma_sg_init_ctx(struct device *dev);
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index cd2b6b9..17136f3 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -42,117 +42,15 @@ struct vb2_v4l2_buffer {
 
 void *vb2_plane_vaddr(struct vb2_v4l2_buffer *cb, unsigned int plane_no);
 void *vb2_plane_cookie(struct vb2_v4l2_buffer *cb, unsigned int plane_no);
-
-void vb2_buffer_done(struct vb2_v4l2_buffer *cb, enum vb2_buffer_state state);
-void vb2_discard_done(struct vb2_queue *q);
-int vb2_wait_for_all_buffers(struct vb2_queue *q);
-
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
-
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
-
-int __must_check vb2_queue_init(struct vb2_queue *q);
-
-void vb2_queue_release(struct vb2_queue *q);
-void vb2_queue_error(struct vb2_queue *q);
-
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
-int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
-
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
-
-int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
-#ifndef CONFIG_MMU
-unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
-				    unsigned long addr,
-				    unsigned long len,
-				    unsigned long pgoff,
-				    unsigned long flags);
-#endif
-unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
-/**
- * vb2_thread_fnc - callback function for use with vb2_thread
- *
- * This is called whenever a buffer is dequeued in the thread.
- */
-typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *cb, void *priv);
-
-/**
- * vb2_thread_start() - start a thread for the given queue.
- * @q:		videobuf queue
- * @fnc:	callback function
- * @priv:	priv pointer passed to the callback function
- * @thread_name:the name of the thread. This will be prefixed with "vb2-".
- *
- * This starts a thread that will queue and dequeue until an error occurs
- * or @vb2_thread_stop is called.
- *
- * This function should not be used for anything else but the videobuf2-dvb
- * support. If you think you have another good use-case for this, then please
- * contact the linux-media mailinglist first.
- */
-int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
-		     const char *thread_name);
-
-/**
- * vb2_thread_stop() - stop the thread for the given queue.
- * @q:		videobuf queue
- */
-int vb2_thread_stop(struct vb2_queue *q);
-
-/**
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
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 
 /**
  * vb2_set_plane_payload() - set bytesused for the plane plane_no
@@ -194,15 +92,6 @@ vb2_plane_size(struct vb2_v4l2_buffer *cb, unsigned int plane_no)
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
 /*
  * The following functions are not part of the vb2 core API, but are simple
  * helper functions that you can use in your struct v4l2_file_operations,
@@ -222,13 +111,12 @@ int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
 int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
 int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
-int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
-int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_ioctl_streamon(struct file *file, void *priv, unsigned int type);
+int vb2_ioctl_streamoff(struct file *file, void *priv, unsigned int type);
 int vb2_ioctl_expbuf(struct file *file, void *priv,
 	struct v4l2_exportbuffer *p);
 
-/* struct v4l2_file_operations helpers */
-
+/* struct file_operations helpers */
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
 int vb2_fop_release(struct file *file);
 int _vb2_fop_release(struct file *file, struct mutex *lock);
@@ -247,4 +135,5 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 void vb2_ops_wait_prepare(struct vb2_queue *vq);
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
+
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
1.7.9.5


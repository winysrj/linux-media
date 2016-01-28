Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:42006 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965264AbcA1JLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:11:14 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 12/12] TW686x: return VB2_BUF_STATE_ERROR frames on timeout/errors
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:11:13 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3d1smcbm6.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index d09a4b0..bb77c1b 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -551,7 +551,7 @@ static int video_thread(void *arg)
 		for (ch = 0; ch < max_channels(dev); ch++) {
 			struct tw686x_video_channel *vc;
 			unsigned long flags;
-			u32 request, n;
+			u32 request, n, stat = VB2_BUF_STATE_DONE;
 
 			vc = &dev->video_channels[ch];
 			if (!(dev->video_active & (1 << ch)))
@@ -581,28 +581,29 @@ static int video_thread(void *arg)
 				reg_write(dev, DMA_CMD, reg & ~(1 << ch));
 				reg_write(dev, DMA_CMD, reg);
 				spin_unlock_irqrestore(&dev->irq_lock, flags);
-			} else {
-				/* handle video stream */
-				mutex_lock(&vc->vb_mutex);
-				spin_lock(&vc->qlock);
-				n = !!(reg_read(dev, PB_STATUS) & (1 << ch));
-				if (vc->curr_bufs[n]) {
-					struct vb2_v4l2_buffer *vb;
-
-					vb = &vc->curr_bufs[n]->vb;
-					v4l2_get_timestamp(&vb->timestamp);
-					vb->field = vc->field;
-					if (V4L2_FIELD_HAS_BOTH(vc->field))
-						vb->sequence = vc->seq++;
-					else
-						vb->sequence = (vc->seq++) / 2;
-					vb2_set_plane_payload(&vb->vb2_buf, 0, vc->width * vc->height * vc->format->depth / 8);
-					vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
-				}
-				setup_descs(vc, n);
-				spin_unlock(&vc->qlock);
-				mutex_unlock(&vc->vb_mutex);
+				stat = VB2_BUF_STATE_ERROR;
+			}
+
+			/* handle video stream */
+			mutex_lock(&vc->vb_mutex);
+			spin_lock(&vc->qlock);
+			n = !!(reg_read(dev, PB_STATUS) & (1 << ch));
+			if (vc->curr_bufs[n]) {
+				struct vb2_v4l2_buffer *vb;
+
+				vb = &vc->curr_bufs[n]->vb;
+				v4l2_get_timestamp(&vb->timestamp);
+				vb->field = vc->field;
+				if (V4L2_FIELD_HAS_BOTH(vc->field))
+					vb->sequence = vc->seq++;
+				else
+					vb->sequence = (vc->seq++) / 2;
+				vb2_set_plane_payload(&vb->vb2_buf, 0, vc->width * vc->height * vc->format->depth / 8);
+				vb2_buffer_done(&vb->vb2_buf, stat);
 			}
+			setup_descs(vc, n);
+			spin_unlock(&vc->qlock);
+			mutex_unlock(&vc->vb_mutex);
 		}
 		try_to_freeze();
 	}

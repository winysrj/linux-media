Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41912 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966118AbcA1JIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:08:21 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 9/12] TW686x: switch to vb2_v4l2_buffer
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:08:19 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3powmcbr0.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 21efa30..12cc108 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -84,8 +84,7 @@ static const struct tw686x_format *format_by_fourcc(unsigned fourcc)
 
 /* video queue operations */
 
-static int tw686x_queue_setup(struct vb2_queue *vq,
-			      const struct v4l2_format *v4l_fmt,
+static int tw686x_queue_setup(struct vb2_queue *vq, const void *arg,
 			      unsigned int *nbuffers, unsigned int *nplanes,
 			      unsigned int sizes[], void *alloc_ctxs[])
 {
@@ -103,9 +102,10 @@ static int tw686x_queue_setup(struct vb2_queue *vq,
 static void tw686x_buf_queue(struct vb2_buffer *vb)
 {
 	struct tw686x_video_channel *vc = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct tw686x_vb2_buf *buf;
 
-	buf = container_of(vb, struct tw686x_vb2_buf, vb);
+	buf = container_of(vbuf, struct tw686x_vb2_buf, vb);
 
 	spin_lock(&vc->qlock);
 	list_add_tail(&buf->list, &vc->vidq_queued);
@@ -128,13 +128,13 @@ loop:
 		list_del(&buf->list);
 
 		buf_len = vc->width * vc->height * vc->format->depth / 8;
-		if (vb2_plane_size(&buf->vb, 0) < buf_len) {
+		if (vb2_plane_size(&buf->vb.vb2_buf, 0) < buf_len) {
 			pr_err("Video buffer size too small\n");
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			goto loop; /* try another */
 		}
 
-		vbuf = vb2_dma_sg_plane_desc(&buf->vb, 0);
+		vbuf = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
 		for_each_sg(vbuf->sgl, sg, vbuf->nents, i) {
 			dma_addr_t phys = sg_dma_address(sg);
 			unsigned len = sg_dma_len(sg);
@@ -145,7 +145,7 @@ loop:
 				entry_len = min(entry_len, buf_len);
 				if (count == MAX_SG_DESC_COUNT) {
 					pr_err("Video buffer size too fragmented\n");
-					vb2_buffer_done(&buf->vb,
+					vb2_buffer_done(&buf->vb.vb2_buf,
 							VB2_BUF_STATE_ERROR);
 					goto loop;
 				}
@@ -167,7 +167,7 @@ loop:
 			descs[count++].flags_length = 0; /* unavailable */
 		}
 
-		buf->vb.state = VB2_BUF_STATE_ACTIVE;
+		buf->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
 		vc->curr_bufs[n] = buf;
 		return;
 	}
@@ -265,12 +265,12 @@ static void tw686x_stop_streaming(struct vb2_queue *vq)
 		buf = list_entry(vc->vidq_queued.next, struct tw686x_vb2_buf,
 				 list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	for (n = 0; n < 2; n++)
 		if (vc->curr_bufs[n])
-			vb2_buffer_done(&vc->curr_bufs[n]->vb,
+			vb2_buffer_done(&vc->curr_bufs[n]->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 
 	spin_unlock(&vc->qlock);
@@ -581,13 +581,13 @@ static int video_thread(void *arg)
 				spin_lock(&vc->qlock);
 				n = !!(reg_read(dev, PB_STATUS) & (1 << ch));
 				if (vc->curr_bufs[n]) {
-					struct vb2_buffer *vb;
+					struct vb2_v4l2_buffer *vb;
 
 					vb = &vc->curr_bufs[n]->vb;
-					v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-					vb->v4l2_buf.field = vc->field;
-					vb2_set_plane_payload(vb, 0, vc->width * vc->height * vc->format->depth / 8);
-					vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+					v4l2_get_timestamp(&vb->timestamp);
+					vb->field = vc->field;
+					vb2_set_plane_payload(&vb->vb2_buf, 0, vc->width * vc->height * vc->format->depth / 8);
+					vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 				}
 				setup_descs(vc, n);
 				spin_unlock(&vc->qlock);
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index 8b9d313..a7f1d18 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -44,7 +44,7 @@ struct vdma_desc {
 };
 
 struct tw686x_vb2_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41975 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbcA1JKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:10:34 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 11/12] TW686x: Track frame sequence numbers
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:10:32 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3h9hycbnb.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index cfc15e7..d09a4b0 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -280,6 +280,7 @@ static int tw686x_start_streaming(struct vb2_queue *vq, unsigned int count)
 	spin_unlock(&vc->qlock);
 
 	dev->video_active |= 1 << vc->ch;
+	vc->seq = 0;
 	dma_ch_mask = reg_read(dev, DMA_CHANNEL_ENABLE) | (1 << vc->ch);
 	reg_write(dev, DMA_CHANNEL_ENABLE, dma_ch_mask);
 	reg_write(dev, DMA_CMD, (1 << 31) | dma_ch_mask);
@@ -591,6 +592,10 @@ static int video_thread(void *arg)
 					vb = &vc->curr_bufs[n]->vb;
 					v4l2_get_timestamp(&vb->timestamp);
 					vb->field = vc->field;
+					if (V4L2_FIELD_HAS_BOTH(vc->field))
+						vb->sequence = vc->seq++;
+					else
+						vb->sequence = (vc->seq++) / 2;
 					vb2_set_plane_payload(&vb->vb2_buf, 0, vc->width * vc->height * vc->format->depth / 8);
 					vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 				}
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index a7f1d18..540b0ad 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -66,6 +66,7 @@ struct tw686x_video_channel {
 	v4l2_std_id video_standard;
 	unsigned width, height;
 	enum v4l2_field field; /* supported TOP, BOTTOM, SEQ_TB and SEQ_BT */
+	unsigned seq;	       /* video field or frame counter */
 	unsigned ch;
 };
 

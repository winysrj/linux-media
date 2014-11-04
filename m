Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway06.websitewelcome.com ([67.18.21.22]:45038 "EHLO
	gateway06.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbaKDU4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Nov 2014 15:56:22 -0500
Received: from cm2.websitewelcome.com (unknown [192.185.178.13])
	by gateway06.websitewelcome.com (Postfix) with ESMTP id 7AA6F24F20C07
	for <linux-media@vger.kernel.org>; Tue,  4 Nov 2014 14:34:29 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: Dean Anderson <linux-dev@sensoray.com>
Subject: [PATCH] [media] s2255drv: fix spinlock issue
Date: Tue,  4 Nov 2014 12:34:03 -0800
Message-Id: <1415133243-9929-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

qlock spinlock controls access to buf_list and sequence.
qlock spinlock should not be locked during a copy to video buffers, an
operation that may sleep.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index ccc0009..24c4413 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -558,27 +558,31 @@ static void s2255_fwchunk_complete(struct urb *urb)
 
 }
 
-static int s2255_got_frame(struct s2255_vc *vc, int jpgsize)
+static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 {
 	struct s2255_buffer *buf;
 	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
 	unsigned long flags = 0;
-	int rc = 0;
+
 	spin_lock_irqsave(&vc->qlock, flags);
 	if (list_empty(&vc->buf_list)) {
 		dprintk(dev, 1, "No active queue to serve\n");
-		rc = -1;
-		goto unlock;
+		spin_unlock_irqrestore(&vc->qlock, flags);
+		return;
 	}
 	buf = list_entry(vc->buf_list.next,
 			 struct s2255_buffer, list);
 	list_del(&buf->list);
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.v4l2_buf.field = vc->field;
+	buf->vb.v4l2_buf.sequence = vc->frame_count;
+	spin_unlock_irqrestore(&vc->qlock, flags);
+
 	s2255_fillbuff(vc, buf, jpgsize);
+	/* tell v4l buffer was filled */
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "%s: [buf] [%p]\n", __func__, buf);
-unlock:
-	spin_unlock_irqrestore(&vc->qlock, flags);
-	return rc;
+	return;
 }
 
 static const struct s2255_fmt *format_by_fourcc(int fourcc)
@@ -649,11 +653,6 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 	}
 	dprintk(dev, 2, "s2255fill at : Buffer 0x%08lx size= %d\n",
 		(unsigned long)vbuf, pos);
-	/* tell v4l buffer was filled */
-	buf->vb.v4l2_buf.field = vc->field;
-	buf->vb.v4l2_buf.sequence = vc->frame_count;
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 }
 
 
-- 
1.9.1


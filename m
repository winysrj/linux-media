Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4114 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaBJLJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/5] vivi: fix sequence counting
Date: Mon, 10 Feb 2014 12:08:45 +0100
Message-Id: <1392030527-32661-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
References: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The sequence counting was not reset to 0 between each streaming run,
and it was increased only every other frame. This is incorrect behavior:
the confusion is with FIELD_ALTERNATE systems where each field is transmitted
separately and only when both fields have been received is the frame
sequence number increased.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 2d4e73b..eb09fe6 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -254,7 +254,7 @@ struct vivi_dev {
 	struct v4l2_fract          timeperframe;
 	unsigned int               width, height;
 	struct vb2_queue	   vb_vidq;
-	unsigned int		   field_count;
+	unsigned int		   seq_count;
 
 	u8			   bars[9][3];
 	u8			   line[MAX_WIDTH * 8] __attribute__((__aligned__(4)));
@@ -675,8 +675,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	dev->mv_count += 2;
 
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	dev->field_count++;
-	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
+	buf->vb.v4l2_buf.sequence = dev->seq_count++;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 }
 
@@ -901,7 +900,9 @@ static void buffer_queue(struct vb2_buffer *vb)
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+
 	dprintk(dev, 1, "%s\n", __func__);
+	dev->seq_count = 0;
 	return vivi_start_generating(dev);
 }
 
-- 
1.8.5.2


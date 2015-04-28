Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030966AbbD1XEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:41 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/13] go7007: don't use vb before test if it is not NULL
Date: Tue, 28 Apr 2015 20:04:23 -0300
Message-Id: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/usb/go7007/go7007-driver.c:452 frame_boundary() warn: variable dereferenced before check 'vb' (see line 449)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 95cffb771a62..0ab81ec8897a 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -446,7 +446,7 @@ static void go7007_motion_regions(struct go7007 *go, struct go7007_buffer *vb)
  */
 static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buffer *vb)
 {
-	u32 *bytesused = &vb->vb.v4l2_planes[0].bytesused;
+	u32 *bytesused;
 	struct go7007_buffer *vb_tmp = NULL;
 
 	if (vb == NULL) {
@@ -458,6 +458,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 		go->next_seq++;
 		return vb;
 	}
+	bytesused = &vb->vb.v4l2_planes[0].bytesused;
 
 	vb->vb.v4l2_buf.sequence = go->next_seq++;
 	if (vb->modet_active && *bytesused + 216 < GO7007_BUF_SIZE)
-- 
2.1.0


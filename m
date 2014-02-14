Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2702 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBNKls (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 05:41:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 10/11] vivi: correctly cleanup after a start_streaming failure.
Date: Fri, 14 Feb 2014 11:41:11 +0100
Message-Id: <1392374472-18393-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl>
References: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If start_streaming fails then any queued buffers must be given back
to the vb2 core.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 2d4e73b..6085e2f 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -901,8 +901,19 @@ static void buffer_queue(struct vb2_buffer *vb)
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+	int err;
+
 	dprintk(dev, 1, "%s\n", __func__);
-	return vivi_start_generating(dev);
+	err = vivi_start_generating(dev);
+	if (err) {
+		struct vivi_buffer *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dev->vidq.active, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+	return err;
 }
 
 /* abort streaming and wait for last buffer */
-- 
1.8.4.rc3


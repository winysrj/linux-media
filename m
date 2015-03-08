Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46112 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbbCHOlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:08 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 04/17] media: blackfin: bfin_capture: set vb2 buffer field
Date: Sun,  8 Mar 2015 14:40:40 +0000
Message-Id: <1425825653-14768-5-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

set the vb2 buffer field in buf_prepare() callback,
alongside drop local variable buf as we already have
a pointer to vb2 buffer.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 332f8c9..a588129 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -305,16 +305,16 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
-	unsigned long size;
+	unsigned long size = bcap_dev->fmt.sizeimage;
 
-	size = bcap_dev->fmt.sizeimage;
 	if (vb2_plane_size(vb, 0) < size) {
 		v4l2_err(&bcap_dev->v4l2_dev, "buffer too small (%lu < %lu)\n",
 				vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
+
+	vb->v4l2_buf.field = bcap_dev->fmt.field;
 
 	return 0;
 }
-- 
2.1.0


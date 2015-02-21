Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37017 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbBUSkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:33 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 04/15] media: blackfin: bfin_capture: improve buf_prepare() callback
Date: Sat, 21 Feb 2015 18:39:50 +0000
Message-Id: <1424544001-19045-5-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch improves the buf_prepare() callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 332f8c9..8f62a84 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -305,16 +305,12 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
-	unsigned long size;
 
-	size = bcap_dev->fmt.sizeimage;
-	if (vb2_plane_size(vb, 0) < size) {
-		v4l2_err(&bcap_dev->v4l2_dev, "buffer too small (%lu < %lu)\n",
-				vb2_plane_size(vb, 0), size);
+	vb2_set_plane_payload(vb, 0, bcap_dev->fmt.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
-	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+
+	vb->v4l2_buf.field = bcap_dev->fmt.field;
 
 	return 0;
 }
-- 
2.1.0


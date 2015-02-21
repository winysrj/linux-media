Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43041 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbBUSk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:29 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 01/15] media: blackfin: bfin_capture: drop buf_init() callback
Date: Sat, 21 Feb 2015 18:39:47 +0000
Message-Id: <1424544001-19045-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops the buf_init() callback as init
of buf list is not required.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8f66986..c6d8b95 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -302,14 +302,6 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int bcap_buffer_init(struct vb2_buffer *vb)
-{
-	struct bcap_buffer *buf = to_bcap_vb(vb);
-
-	INIT_LIST_HEAD(&buf->list);
-	return 0;
-}
-
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
@@ -441,7 +433,6 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops bcap_video_qops = {
 	.queue_setup            = bcap_queue_setup,
-	.buf_init               = bcap_buffer_init,
 	.buf_prepare            = bcap_buffer_prepare,
 	.buf_cleanup            = bcap_buffer_cleanup,
 	.buf_queue              = bcap_buffer_queue,
-- 
2.1.0


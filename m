Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:35522 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbBUSkn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:43 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 09/15] media: blackfin: bfin_capture: make sure all buffers are returned on stop_streaming() callback
Date: Sat, 21 Feb 2015 18:39:55 +0000
Message-Id: <1424544001-19045-10-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

In start_streaming() callback the buffer is removed from the
dma_queue list and assigned to cur_frm, this patch makes sure
that is returned to vb2 core with VB2_BUF_STATE_ERROR flag.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 012c271..3311d59 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -370,6 +370,9 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 				"stream off failed in subdev\n");
 
 	/* release all active buffers */
+	if (bcap_dev->cur_frm)
+		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+
 	while (!list_empty(&bcap_dev->dma_queue)) {
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
-- 
2.1.0


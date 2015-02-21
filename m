Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59489 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbbBUSkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:55 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 15/15] media: blackfin: bfin_capture: set v4l2 buffer sequence
Date: Sat, 21 Feb 2015 18:40:01 +0000
Message-Id: <1424544001-19045-16-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support to set the v4l2 buffer sequence.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 1fc4dbb1..46a8cd3 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -103,6 +103,8 @@ struct bcap_device {
 	struct completion comp;
 	/* prepare to stop */
 	bool stop;
+	/* vb2 buffer sequence counter */
+	unsigned sequence;
 };
 
 static const struct bcap_format bcap_formats[] = {
@@ -329,6 +331,8 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		goto err;
 	}
 
+	bcap_dev->sequence = 0;
+
 	reinit_completion(&bcap_dev->comp);
 	bcap_dev->stop = false;
 
@@ -407,6 +411,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			ppi->err = false;
 		} else {
+			vb->v4l2_buf.sequence = bcap_dev->sequence++;
 			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 		}
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
-- 
2.1.0


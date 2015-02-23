Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42759 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbbBWPUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:20 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 02/12] [media] coda: fix double call to debugfs_remove
Date: Mon, 23 Feb 2015 16:20:03 +0100
Message-Id: <1424704813-20792-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

In coda_free_aux_buf() call debugfs_remove only if buffer entry
is valid (and therfore dentry is valid), double protect by
invalidating dentry value.

Fixes erroneous prematurely dealloc of debugfs caused by
incorrect reference count incrementing.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c81af1b..37bbd57 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1215,8 +1215,9 @@ void coda_free_aux_buf(struct coda_dev *dev,
 				  buf->vaddr, buf->paddr);
 		buf->vaddr = NULL;
 		buf->size = 0;
+		debugfs_remove(buf->dentry);
+		buf->dentry = NULL;
 	}
-	debugfs_remove(buf->dentry);
 }
 
 static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
-- 
2.1.4


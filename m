Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/21] [media] coda: remove context debugfs entry last
Date: Fri, 23 Jan 2015 17:51:17 +0100
Message-Id: <1422031895-7740-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not remove the per-context debugfs directory before the
per-buffer debugfs entries contained therein.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 1cc4e90..9a0ee11 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1693,8 +1693,6 @@ static int coda_release(struct file *file)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
 		 ctx);
 
-	debugfs_remove_recursive(ctx->debugfs_entry);
-
 	if (ctx->inst_type == CODA_INST_DECODER)
 		coda_bit_stream_end_flag(ctx);
 
@@ -1728,6 +1726,7 @@ static int coda_release(struct file *file)
 	clear_bit(ctx->idx, &dev->instance_mask);
 	if (ctx->ops->release)
 		ctx->ops->release(ctx);
+	debugfs_remove_recursive(ctx->debugfs_entry);
 	kfree(ctx);
 
 	return 0;
-- 
2.1.4


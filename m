Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60114 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbbCXRbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:31:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 01/11] [media] coda: check kasprintf return value in coda_open
Date: Tue, 24 Mar 2015 18:30:47 +0100
Message-Id: <1427218257-1507-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
References: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

kasprintf might fail if free memory is low.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6f32e6d..c81af1b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1621,6 +1621,11 @@ static int coda_open(struct file *file)
 	set_bit(idx, &dev->instance_mask);
 
 	name = kasprintf(GFP_KERNEL, "context%d", idx);
+	if (!name) {
+		ret = -ENOMEM;
+		goto err_coda_name_init;
+	}
+
 	ctx->debugfs_entry = debugfs_create_dir(name, dev->debugfs_root);
 	kfree(name);
 
@@ -1735,6 +1740,7 @@ err_pm_get:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
+err_coda_name_init:
 err_coda_max:
 	kfree(ctx);
 	return ret;
-- 
2.1.4


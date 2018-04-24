Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51876 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbeDXNGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:06:35 -0400
From: Colin King <colin.king@canonical.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] media: ispstat: don't dereference user_cfg before a null check
Date: Tue, 24 Apr 2018 14:06:18 +0100
Message-Id: <20180424130618.18211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The pointer user_cfg (a copy of new_conf) is dereference before
new_conf is null checked, hence we may have a null pointer dereference
on user_cfg when assigning buf_size from user_cfg->buf_size. Ensure
this does not occur by moving the assignment of buf_size after the
null check.

Detected by CoverityScan, CID#1468386 ("Dereference before null check")

Fixes: 68e342b3068c ("[media] omap3isp: Statistics")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 0b31f6c5791f..38cb1b2cc672 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -523,7 +523,7 @@ int omap3isp_stat_config(struct ispstat *stat, void *new_conf)
 	int ret;
 	unsigned long irqflags;
 	struct ispstat_generic_config *user_cfg = new_conf;
-	u32 buf_size = user_cfg->buf_size;
+	u32 buf_size;
 
 	if (!new_conf) {
 		dev_dbg(stat->isp->dev, "%s: configuration is NULL\n",
@@ -532,6 +532,7 @@ int omap3isp_stat_config(struct ispstat *stat, void *new_conf)
 	}
 
 	mutex_lock(&stat->ioctl_lock);
+	buf_size = user_cfg->buf_size;
 
 	dev_dbg(stat->isp->dev,
 		"%s: configuring module with buffer size=0x%08lx\n",
-- 
2.17.0

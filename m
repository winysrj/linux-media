Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.198.13]:38559 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757252AbeDXMvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:51:32 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 06ABC400DA7A8
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 07:51:32 -0500 (CDT)
Date: Tue, 24 Apr 2018 07:51:28 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] omap3isp: ispstat: fix potential NULL pointer dereference
Message-ID: <20180424125128.GA625@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

new_conf is indirectly dereferenced before it is null checked, hence
there is a potential null pointer dereference.

Fix this by moving the pointer dereference after new_conf has been
properly null checked.

Addresses-Coverity-ID: 1468386 ("Dereference before null check")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 0b31f6c..549c7ab 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -522,8 +522,8 @@ int omap3isp_stat_config(struct ispstat *stat, void *new_conf)
 {
 	int ret;
 	unsigned long irqflags;
-	struct ispstat_generic_config *user_cfg = new_conf;
-	u32 buf_size = user_cfg->buf_size;
+	struct ispstat_generic_config *user_cfg;
+	u32 buf_size;
 
 	if (!new_conf) {
 		dev_dbg(stat->isp->dev, "%s: configuration is NULL\n",
@@ -531,6 +531,9 @@ int omap3isp_stat_config(struct ispstat *stat, void *new_conf)
 		return -EINVAL;
 	}
 
+	user_cfg = new_conf;
+	buf_size = user_cfg->buf_size;
+
 	mutex_lock(&stat->ioctl_lock);
 
 	dev_dbg(stat->isp->dev,
-- 
2.7.4

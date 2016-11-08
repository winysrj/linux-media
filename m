Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:57071 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbcKHGCm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 01:02:42 -0500
From: Ravikant Bijendra Sharma <ravikant.s2@samsung.com>
To: Russell King <rmk+kernel@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Ravikant Bijendra Sharma <ravikant.s2@samsung.com>,
        shailesh pandey <p.shailesh@samsung.com>,
        vidushi.koul@samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/armada: Fix NULL pointer comparison warning
Date: Tue, 08 Nov 2016 11:30:09 +0530
Message-id: <1478584809-4423-1-git-send-email-ravikant.s2@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ravikant B Sharma <ravikant.s2@samsung.com>

Replace direct comparisons to NULL i.e.
'x == NULL' with '!x'. As per coding standard.

Signed-off-by: Ravikant B Sharma <ravikant.s2@samsung.com>
---
 drivers/gpu/drm/armada/armada_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/armada/armada_debugfs.c b/drivers/gpu/drm/armada/armada_debugfs.c
index d4f7ab0..90222e6 100644
--- a/drivers/gpu/drm/armada/armada_debugfs.c
+++ b/drivers/gpu/drm/armada/armada_debugfs.c
@@ -113,7 +113,7 @@ static int drm_add_fake_info_node(struct drm_minor *minor, struct dentry *ent,
 	struct drm_info_node *node;
 
 	node = kmalloc(sizeof(struct drm_info_node), GFP_KERNEL);
-	if (node == NULL) {
+	if (!node) {
 		debugfs_remove(ent);
 		return -ENOMEM;
 	}
-- 
1.7.9.5


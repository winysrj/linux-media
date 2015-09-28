Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34053 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbbI1VlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2015 17:41:15 -0400
Received: by qkfq186 with SMTP id q186so73924474qkf.1
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2015 14:41:14 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] vivid: Fix iteration in driver removal path
Date: Mon, 28 Sep 2015 18:36:51 -0300
Message-Id: <1443476211-20212-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the diver is removed and all the resources are deallocated,
we should be iterating through the created devices only.

Currently, the iteration ends when vivid_devs[i] is NULL. Since
the array contains VIVID_MAX_DEVS elements, it will oops if
n_devs=VIVID_MAX_DEVS because in that case, no element is NULL.

Fixes: c88a96b023d8 ('[media] vivid: add core driver code')
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/platform/vivid/vivid-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index a047b4716741..0f5e9143cc7e 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1341,8 +1341,11 @@ static int vivid_remove(struct platform_device *pdev)
 	struct vivid_dev *dev;
 	unsigned i;
 
-	for (i = 0; vivid_devs[i]; i++) {
+
+	for (i = 0; i < n_devs; i++) {
 		dev = vivid_devs[i];
+		if (!dev)
+			continue;
 
 		if (dev->has_vid_cap) {
 			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
-- 
2.5.2


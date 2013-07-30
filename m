Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:59559 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3G3M73 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 08:59:29 -0400
Received: by mail-la0-f49.google.com with SMTP id ev20so1751983lab.22
        for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 05:59:28 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2_compliance: -EINVAL is expected when ret is not 0
Date: Tue, 30 Jul 2013 14:59:23 +0200
Message-Id: <1375189163-32510-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise the driver can never return a register

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 utils/v4l2-compliance/v4l2-test-debug.cpp |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-compliance/v4l2-test-debug.cpp b/utils/v4l2-compliance/v4l2-test-debug.cpp
index 90c5b90..fa42d2c 100644
--- a/utils/v4l2-compliance/v4l2-test-debug.cpp
+++ b/utils/v4l2-compliance/v4l2-test-debug.cpp
@@ -49,7 +49,7 @@ int testRegister(struct node *node)
 		return ret;
 	// Not allowed to call VIDIOC_DBG_G_REGISTER unless root
 	fail_on_test(uid && ret != EPERM);
-	fail_on_test(uid == 0 && ret != EINVAL);
+	fail_on_test(uid == 0 && ret && ret != EINVAL);
 	fail_on_test(uid == 0 && !ret && reg.size == 0);
 	chip.match.type = V4L2_CHIP_MATCH_BRIDGE;
 	chip.match.addr = 0;
-- 
1.7.10.4


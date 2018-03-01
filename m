Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:45898 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965096AbeCAI5d (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 03:57:33 -0500
Received: by mail-pl0-f65.google.com with SMTP id v9-v6so3268212plp.12
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2018 00:57:33 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH v4l-utils] v4l2-compliance/v4l2-test-formats: fix typo
Date: Thu,  1 Mar 2018 17:57:10 +0900
Message-Id: <20180301085710.862-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using planar formats, we want to check pix_mp, not pix.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 utils/v4l2-compliance/v4l2-test-formats.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index a336afdd..e9170688 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -452,7 +452,7 @@ static int testFormatsType(struct node *node, int ret,  unsigned type, struct v4
 		if (!node->is_m2m)
 			fail_on_test(testColorspace(pix_mp.pixelformat, pix_mp.colorspace, 
                                             pix_mp.ycbcr_enc, pix_mp.quantization));
-		fail_on_test(pix.field == V4L2_FIELD_ANY);
+		fail_on_test(pix_mp.field == V4L2_FIELD_ANY);
 		ret = check_0(pix_mp.reserved, sizeof(pix_mp.reserved));
 		if (ret)
 			return fail("pix_mp.reserved not zeroed\n");
-- 
2.16.2.395.g2e18187dfd-goog

Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50937 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732891AbeKOBPZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:15:25 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v4l-utils] v4l2-compliance: limit acceptable width/height to 65536 in VIDIOC_SUBDEV_G/S_FMT test
Date: Wed, 14 Nov 2018 16:11:45 +0100
Message-Id: <20181114151145.2642-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fail if the driver returns unrealistically large frame sizes.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 utils/v4l2-compliance/v4l2-test-subdevs.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-subdevs.cpp b/utils/v4l2-compliance/v4l2-test-subdevs.cpp
index 031fd6e78c56..29987b310448 100644
--- a/utils/v4l2-compliance/v4l2-test-subdevs.cpp
+++ b/utils/v4l2-compliance/v4l2-test-subdevs.cpp
@@ -308,8 +308,8 @@ int testSubDevFrameInterval(struct node *node, unsigned pad)
 static int checkMBusFrameFmt(struct node *node, struct v4l2_mbus_framefmt &fmt)
 {
 	fail_on_test(check_0(fmt.reserved, sizeof(fmt.reserved)));
-	fail_on_test(fmt.width == 0 || fmt.width == ~0U);
-	fail_on_test(fmt.height == 0 || fmt.height == ~0U);
+	fail_on_test(fmt.width == 0 || fmt.width > 65536);
+	fail_on_test(fmt.height == 0 || fmt.height > 65536);
 	fail_on_test(fmt.code == 0 || fmt.code == ~0U);
 	fail_on_test(fmt.field == ~0U);
 	if (!node->is_passthrough_subdev) {
-- 
2.19.1

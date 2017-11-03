Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:60546 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751676AbdKCNgM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 09:36:12 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] [media] v4l2-ctrls: Don't validate BITMASK twice
Date: Fri,  3 Nov 2017 15:35:39 +0200
Message-Id: <20171103133539.35305-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to repeat what check_range() does for us, i.e. BITMASK
validation in v4l2_ctrl_new().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c230bd5c6558..cbb2ef43945f 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2013,10 +2013,6 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, err);
 		return NULL;
 	}
-	if (type == V4L2_CTRL_TYPE_BITMASK && ((def & ~max) || min || step)) {
-		handler_set_err(hdl, -ERANGE);
-		return NULL;
-	}
 	if (is_array &&
 	    (type == V4L2_CTRL_TYPE_BUTTON ||
 	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
-- 
2.14.2

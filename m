Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57144
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750841AbdHKAQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 20:16:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] media: v4l2-ctrls.h: better document the arguments for v4l2_ctrl_fill
Date: Thu, 10 Aug 2017 21:16:50 -0300
Message-Id: <f6ac7366e711649241bb77aff997d6815d6c063e.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1502409182.git.mchehab@s-opensource.com>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
 <cover.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1502409182.git.mchehab@s-opensource.com>
References: <cover.1502409182.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The arguments for this function are pointers. Make it clear at
its documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ctrls.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2d2aed56922f..6ba30acf06aa 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -339,18 +339,18 @@ struct v4l2_ctrl_config {
 /**
  * v4l2_ctrl_fill - Fill in the control fields based on the control ID.
  *
- * @id: ID of the control
- * @name: name of the control
- * @type: type of the control
- * @min: minimum value for the control
- * @max: maximum value for the control
- * @step: control step
- * @def: default value for the control
- * @flags: flags to be used on the control
+ * @id: pointer for storing the ID of the control
+ * @name: pointer for storing the name of the control
+ * @type: pointer for storing the type of the control
+ * @min: pointer for storing the minimum value for the control
+ * @max: pointer for storing the maximum value for the control
+ * @step: pointer for storing the control step
+ * @def: pointer for storing the default value for the control
+ * @flags: pointer for storing the flags to be used on the control
  *
  * This works for all standard V4L2 controls.
  * For non-standard controls it will only fill in the given arguments
- * and @name will be %NULL.
+ * and @name content will be filled with %NULL.
  *
  * This function will overwrite the contents of @name, @type and @flags.
  * The contents of @min, @max, @step and @def may be modified depending on
-- 
2.13.3

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34249
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750803AbdHLJ5L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 05:57:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3] media: v4l2-ctrls.h: better document the arguments for v4l2_ctrl_fill
Date: Sat, 12 Aug 2017 06:57:05 -0300
Message-Id: <635a48ae11055d0dbc5a844dcc8cf45a94802ee9.1502531611.git.mchehab@s-opensource.com>
In-Reply-To: <95c8445c-b06a-d571-248a-cbd3de41aa73@xs4all.nl>
References: <95c8445c-b06a-d571-248a-cbd3de41aa73@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The arguments for this function are pointers. Make it clear at
its documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Hans,

Feel free to pick this patch on your tree, if you're ok with it. Your approach for
using v4l_queryctl() sounds better,  as it covers private controls too.
So I'm not submitting the other patches that used to be in this series. Yet,
I think it doesn't hurt to make the documentation clearer about the
pointers.

 include/media/v4l2-ctrls.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 2d2aed56922f..dacfe54057f8 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -340,17 +340,17 @@ struct v4l2_ctrl_config {
  * v4l2_ctrl_fill - Fill in the control fields based on the control ID.
  *
  * @id: ID of the control
- * @name: name of the control
- * @type: type of the control
- * @min: minimum value for the control
- * @max: maximum value for the control
- * @step: control step
- * @def: default value for the control
- * @flags: flags to be used on the control
+ * @name: pointer to be filled with a string with the name of the control
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
+ * and @name content will be set to %NULL.
  *
  * This function will overwrite the contents of @name, @type and @flags.
  * The contents of @min, @max, @step and @def may be modified depending on
-- 
2.13.3

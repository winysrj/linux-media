Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57159
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751691AbdHKAQ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 20:16:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 2/3] media: v4l2-ctrls: prepare the function to be used by compat32 code
Date: Thu, 10 Aug 2017 21:16:51 -0300
Message-Id: <0cd8fe16afcefce04053b3c31e53798c07ec6726.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1502409182.git.mchehab@s-opensource.com>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
 <cover.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1502409182.git.mchehab@s-opensource.com>
References: <cover.1502409182.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, both v4l2_ctrl_fill() and compat32 code need to know
the type of the control. As new controls are added, this cause
troubles at compat32, as it won't be able to discover what
functions are pointers or not.

Change v4l2_ctrl_fill() function for it to be called with just
one argument: the control type. This way, the compat32 code can
use it internally.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 31 +++++++++++++++++++++++++++++--
 include/media/v4l2-ctrls.h           |  2 ++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index dd1db678718c..c512b7539077 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -939,8 +939,10 @@ EXPORT_SYMBOL(v4l2_ctrl_get_name);
 void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags)
 {
-	*name = v4l2_ctrl_get_name(id);
-	*flags = 0;
+	if (name) {
+		*name = v4l2_ctrl_get_name(id);
+		*flags = 0;
+	}
 
 	switch (id) {
 	case V4L2_CID_AUDIO_MUTE:
@@ -996,11 +998,15 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_RX_TRAFFIC_PROGRAM:
 	case V4L2_CID_RDS_RX_MUSIC_SPEECH:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
+		if (!name)
+			break;
 		*min = 0;
 		*max = *step = 1;
 		break;
 	case V4L2_CID_ROTATE:
 		*type = V4L2_CTRL_TYPE_INTEGER;
+		if (!name)
+			break;
 		*flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
 		break;
 	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
@@ -1015,6 +1021,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_AUTO_FOCUS_START:
 	case V4L2_CID_AUTO_FOCUS_STOP:
 		*type = V4L2_CTRL_TYPE_BUTTON;
+		if (!name)
+			break;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
 			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
 		*min = *max = *step = *def = 0;
@@ -1099,12 +1107,16 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RF_TUNER_CLASS:
 	case V4L2_CID_DETECT_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
+		if (!name)
+			break;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
 		*min = *max = *step = *def = 0;
 		break;
 	case V4L2_CID_BG_COLOR:
 		*type = V4L2_CTRL_TYPE_INTEGER;
+		if (!name)
+			break;
 		*step = 1;
 		*min = 0;
 		/* Max is calculated as RGB888 that is 2^24 */
@@ -1123,10 +1135,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
 		*type = V4L2_CTRL_TYPE_INTEGER;
+		if (!name)
+			break;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:
 		*type = V4L2_CTRL_TYPE_INTEGER64;
+		if (!name)
+			break;
 		*flags |= V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY;
 		*min = *def = 0;
 		*max = 0x1ffffffffLL;
@@ -1134,6 +1150,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:
 		*type = V4L2_CTRL_TYPE_INTEGER64;
+		if (!name)
+			break;
+
 		*flags |= V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY;
 		*min = *def = 0;
 		*max = 0x7fffffffffffffffLL;
@@ -1141,6 +1160,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_PIXEL_RATE:
 		*type = V4L2_CTRL_TYPE_INTEGER64;
+		if (!name)
+			break;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	case V4L2_CID_DETECT_MD_REGION_GRID:
@@ -1156,6 +1177,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
 	}
+
+	if (!name)
+		return;
+
+	/* Update flags for some controls */
+
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
 	case V4L2_CID_MPEG_AUDIO_MODE:
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 6ba30acf06aa..e22dea218a4c 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -352,6 +352,8 @@ struct v4l2_ctrl_config {
  * For non-standard controls it will only fill in the given arguments
  * and @name content will be filled with %NULL.
  *
+ * if @name is NULL, only the @type will be filled.
+ *
  * This function will overwrite the contents of @name, @type and @flags.
  * The contents of @min, @max, @step and @def may be modified depending on
  * the type.
-- 
2.13.3

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42200 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbbIMQmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 12:42:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/6] vivid: use ARRAY_SIZE to calculate max control value
Date: Sun, 13 Sep 2015 18:41:27 +0200
Message-Id: <1442162492-46238-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
References: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The max value of various menu controls is hardcoded, and it is easy to forget
to update it after adding a new menu item.

So use ARRAY_SIZE instead to calculate this value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 339c8b7..3d8e161 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -548,7 +548,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_osd_mode = {
 	.id = VIVID_CID_OSD_TEXT_MODE,
 	.name = "OSD Text Mode",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 2,
+	.max = ARRAY_SIZE(vivid_ctrl_osd_mode_strings) - 2,
 	.qmenu = vivid_ctrl_osd_mode_strings,
 };
 
@@ -640,7 +640,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_tstamp_src = {
 	.id = VIVID_CID_TSTAMP_SRC,
 	.name = "Timestamp Source",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 1,
+	.max = ARRAY_SIZE(vivid_ctrl_tstamp_src_strings) - 2,
 	.qmenu = vivid_ctrl_tstamp_src_strings,
 };
 
@@ -712,7 +712,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_colorspace = {
 	.id = VIVID_CID_COLORSPACE,
 	.name = "Colorspace",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 7,
+	.max = ARRAY_SIZE(vivid_ctrl_colorspace_strings) - 2,
 	.def = 2,
 	.qmenu = vivid_ctrl_colorspace_strings,
 };
@@ -732,7 +732,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_xfer_func = {
 	.id = VIVID_CID_XFER_FUNC,
 	.name = "Transfer Function",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 5,
+	.max = ARRAY_SIZE(vivid_ctrl_xfer_func_strings) - 2,
 	.qmenu = vivid_ctrl_xfer_func_strings,
 };
 
@@ -754,7 +754,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_ycbcr_enc = {
 	.id = VIVID_CID_YCBCR_ENC,
 	.name = "Y'CbCr Encoding",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 8,
+	.max = ARRAY_SIZE(vivid_ctrl_ycbcr_enc_strings) - 2,
 	.qmenu = vivid_ctrl_ycbcr_enc_strings,
 };
 
@@ -770,7 +770,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_quantization = {
 	.id = VIVID_CID_QUANTIZATION,
 	.name = "Quantization",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 2,
+	.max = ARRAY_SIZE(vivid_ctrl_quantization_strings) - 2,
 	.qmenu = vivid_ctrl_quantization_strings,
 };
 
@@ -1088,7 +1088,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_std_signal_mode = {
 	.id = VIVID_CID_STD_SIGNAL_MODE,
 	.name = "Standard Signal Mode",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.max = 5,
+	.max = ARRAY_SIZE(vivid_ctrl_std_signal_mode_strings) - 2,
 	.menu_skip_mask = 1 << 3,
 	.qmenu = vivid_ctrl_std_signal_mode_strings,
 };
-- 
2.1.4


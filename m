Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53646 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbaKFMHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Nov 2014 07:07:06 -0500
Received: from [10.54.92.107] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id E5AA62A009D
	for <linux-media@vger.kernel.org>; Thu,  6 Nov 2014 13:07:00 +0100 (CET)
Message-ID: <545B6456.2080607@xs4all.nl>
Date: Thu, 06 Nov 2014 13:06:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: add test array controls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add array controls to test support for such controls. There is one
array with just one element, one 8x16 matrix control and one 4 dimensional
2x3x4x5 control.

This makes it possible to experiment with such controls without requiring
hard-to-get hardware.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index d5cbf00..d584773 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -40,6 +40,9 @@
 #define VIVID_CID_STRING		(VIVID_CID_CUSTOM_BASE + 5)
 #define VIVID_CID_BITMASK		(VIVID_CID_CUSTOM_BASE + 6)
 #define VIVID_CID_INTMENU		(VIVID_CID_CUSTOM_BASE + 7)
+#define VIVID_CID_U32_ARRAY		(VIVID_CID_CUSTOM_BASE + 8)
+#define VIVID_CID_U16_MATRIX		(VIVID_CID_CUSTOM_BASE + 9)
+#define VIVID_CID_U8_4D_ARRAY		(VIVID_CID_CUSTOM_BASE + 10)
 
 #define VIVID_CID_VIVID_BASE		(0x00f00000 | 0xf000)
 #define VIVID_CID_VIVID_CLASS		(0x00f00000 | 1)
@@ -163,6 +166,42 @@ static const struct v4l2_ctrl_config vivid_ctrl_int64 = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vivid_ctrl_u32_array = {
+	.ops = &vivid_user_gen_ctrl_ops,
+	.id = VIVID_CID_U32_ARRAY,
+	.name = "U32 1 Element Array",
+	.type = V4L2_CTRL_TYPE_U32,
+	.def = 0x18,
+	.min = 0x10,
+	.max = 0x20000,
+	.step = 1,
+	.dims = { 1 },
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_u16_matrix = {
+	.ops = &vivid_user_gen_ctrl_ops,
+	.id = VIVID_CID_U16_MATRIX,
+	.name = "U16 8x16 Matrix",
+	.type = V4L2_CTRL_TYPE_U16,
+	.def = 0x18,
+	.min = 0x10,
+	.max = 0x2000,
+	.step = 1,
+	.dims = { 8, 16 },
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_u8_4d_array = {
+	.ops = &vivid_user_gen_ctrl_ops,
+	.id = VIVID_CID_U8_4D_ARRAY,
+	.name = "U8 2x3x4x5 Array",
+	.type = V4L2_CTRL_TYPE_U8,
+	.def = 0x18,
+	.min = 0x10,
+	.max = 0x20,
+	.step = 1,
+	.dims = { 2, 3, 4, 5 },
+};
+
 static const char * const vivid_ctrl_menu_strings[] = {
 	"Menu Item 0 (Skipped)",
 	"Menu Item 1",
@@ -1222,6 +1261,9 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	dev->string = v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_string, NULL);
 	dev->bitmask = v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_bitmask, NULL);
 	dev->int_menu = v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_int_menu, NULL);
+	v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_u32_array, NULL);
+	v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_u16_matrix, NULL);
+	v4l2_ctrl_new_custom(hdl_user_gen, &vivid_ctrl_u8_4d_array, NULL);
 
 	if (dev->has_vid_cap) {
 		/* Image Processing Controls */

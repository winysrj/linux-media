Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:48150 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502Ab2AKV1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:12 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 03/23] vivi: Add an integer menu test control
Date: Wed, 11 Jan 2012 23:26:40 +0200
Message-Id: <1326317220-15339-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an integer menu test control for the vivi driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/vivi.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7d754fb..aab375b 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -177,6 +177,7 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *menu;
 	struct v4l2_ctrl	   *string;
 	struct v4l2_ctrl	   *bitmask;
+	struct v4l2_ctrl	   *int_menu;
 
 	spinlock_t                 slock;
 	struct mutex		   mutex;
@@ -503,6 +504,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->boolean->cur.val,
 			dev->menu->qmenu[dev->menu->cur.val],
 			dev->string->cur.string);
+	snprintf(str, sizeof(str), " integer_menu %lld, value %d ",
+			dev->int_menu->qmenu_int[dev->int_menu->cur.val],
+			dev->int_menu->cur.val);
+	gen_text(dev, vbuf, line++ * 16, 16, str);
 	mutex_unlock(&dev->ctrl_handler.lock);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	if (dev->button_pressed) {
@@ -1183,6 +1188,22 @@ static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
 	.step = 0,
 };
 
+static const s64 vivi_ctrl_int_menu_values[] = {
+	1, 1, 2, 3, 5, 8, 13, 21, 42,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_int_menu = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 7,
+	.name = "Integer menu",
+	.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+	.min = 1,
+	.max = 8,
+	.def = 4,
+	.menu_skip_mask = 0x02,
+	.qmenu_int = vivi_ctrl_int_menu_values,
+};
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.open           = v4l2_fh_open,
@@ -1293,6 +1314,7 @@ static int __init vivi_create_instance(int inst)
 	dev->menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_menu, NULL);
 	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
 	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
+	dev->int_menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int_menu, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
 		goto unreg_dev;
-- 
1.7.2.5


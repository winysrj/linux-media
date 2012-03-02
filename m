Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:53290 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab2CBRcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:53 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 03/34] vivi: Add an integer menu test control
Date: Fri,  2 Mar 2012 19:30:11 +0200
Message-Id: <1330709442-16654-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an integer menu test control for the vivi driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/vivi.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 5e8b071..d75a1e4 100644
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
@@ -1165,6 +1170,22 @@ static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
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
@@ -1275,6 +1296,7 @@ static int __init vivi_create_instance(int inst)
 	dev->menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_menu, NULL);
 	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
 	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
+	dev->int_menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int_menu, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
 		goto unreg_dev;
-- 
1.7.2.5


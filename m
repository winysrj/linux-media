Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:37355 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1K3Rjw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:39:52 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, snjw23@gmail.com,
	hverkuil@xs4all.nl
Subject: [RFC/PATCH v2 3/3] vivi: Add an integer menu test control
Date: Wed, 30 Nov 2011 19:35:58 +0200
Message-Id: <1322674558-7963-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111130173821.GH29805@valkosipuli.localdomain>
References: <20111130173821.GH29805@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an integer menu test control for the vivi driver.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/vivi.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7d754fb..763ec23 100644
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
+	snprintf(str, sizeof(str), " integer_menu %s, value %lld ",
+			dev->int_menu->qmenu[dev->int_menu->cur.val],
+			dev->int64->cur.val64);
+	gen_text(dev, vbuf, line++ * 16, 16, str);
 	mutex_unlock(&dev->ctrl_handler.lock);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	if (dev->button_pressed) {
@@ -1183,6 +1188,22 @@ static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
 	.step = 0,
 };
 
+static const s64 * const vivi_ctrl_int_menu_values[] = {
+	1, 1, 2, 3, 5, 8, 13, 21, 42,
+};
+
+static const struct v4l2_ctrl_config vivi_ctrl_string = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIDI_CID_CUSTOM_BASE + 7
+	.name = "Integer menu",
+	.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+	.min = 1,
+	.max = 8,
+	.def = 4,
+	.menu_skip_mask = 0x02,
+	.qmenu_int = &vivi_ctrl_int_menu_values,
+};
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.open           = v4l2_fh_open,
-- 
1.7.2.5


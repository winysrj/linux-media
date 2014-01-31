Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1485 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaAaJ45 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 04:56:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/32] v4l2-ctrls: use pr_info/cont instead of printk.
Date: Fri, 31 Jan 2014 10:56:01 +0100
Message-Id: <1391162190-8620-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
References: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Codingstyle fix.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 72ffe76..df8ed0a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2045,45 +2045,45 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 	if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
 		return;
 
-	printk(KERN_INFO "%s%s%s: ", prefix, colon, ctrl->name);
+	pr_info("%s%s%s: ", prefix, colon, ctrl->name);
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
-		printk(KERN_CONT "%d", ctrl->cur.val);
+		pr_cont("%d", ctrl->cur.val);
 		break;
 	case V4L2_CTRL_TYPE_BOOLEAN:
-		printk(KERN_CONT "%s", ctrl->cur.val ? "true" : "false");
+		pr_cont("%s", ctrl->cur.val ? "true" : "false");
 		break;
 	case V4L2_CTRL_TYPE_MENU:
-		printk(KERN_CONT "%s", ctrl->qmenu[ctrl->cur.val]);
+		pr_cont("%s", ctrl->qmenu[ctrl->cur.val]);
 		break;
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
-		printk(KERN_CONT "%lld", ctrl->qmenu_int[ctrl->cur.val]);
+		pr_cont("%lld", ctrl->qmenu_int[ctrl->cur.val]);
 		break;
 	case V4L2_CTRL_TYPE_BITMASK:
-		printk(KERN_CONT "0x%08x", ctrl->cur.val);
+		pr_cont("0x%08x", ctrl->cur.val);
 		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
-		printk(KERN_CONT "%lld", ctrl->cur.val64);
+		pr_cont("%lld", ctrl->cur.val64);
 		break;
 	case V4L2_CTRL_TYPE_STRING:
-		printk(KERN_CONT "%s", ctrl->cur.string);
+		pr_cont("%s", ctrl->cur.string);
 		break;
 	default:
-		printk(KERN_CONT "unknown type %d", ctrl->type);
+		pr_cont("unknown type %d", ctrl->type);
 		break;
 	}
 	if (ctrl->flags & (V4L2_CTRL_FLAG_INACTIVE |
 			   V4L2_CTRL_FLAG_GRABBED |
 			   V4L2_CTRL_FLAG_VOLATILE)) {
 		if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
-			printk(KERN_CONT " inactive");
+			pr_cont(" inactive");
 		if (ctrl->flags & V4L2_CTRL_FLAG_GRABBED)
-			printk(KERN_CONT " grabbed");
+			pr_cont(" grabbed");
 		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE)
-			printk(KERN_CONT " volatile");
+			pr_cont(" volatile");
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 /* Log all controls owned by the handler */
-- 
1.8.5.2


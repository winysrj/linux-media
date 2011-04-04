Return-path: <mchehab@pedra>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3368 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1DDLwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:18 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrZ001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:17 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdI009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 2/9] vivi: add bitmask test control.
Date: Mon,  4 Apr 2011 13:51:47 +0200
Message-Id: <3d7992def0e68d07efaa40bce0ac4f3969058b0b.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..21d8f6a 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -174,6 +174,7 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *int64;
 	struct v4l2_ctrl	   *menu;
 	struct v4l2_ctrl	   *string;
+	struct v4l2_ctrl	   *bitmask;
 
 	spinlock_t                 slock;
 	struct mutex		   mutex;
@@ -488,9 +489,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " volume %3d ", dev->volume->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	snprintf(str, sizeof(str), " int32 %d, int64 %lld ",
+	snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
 			dev->int32->cur.val,
-			dev->int64->cur.val64);
+			dev->int64->cur.val64,
+			dev->bitmask->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
 			dev->boolean->cur.val,
@@ -1117,6 +1119,17 @@ static const struct v4l2_ctrl_config vivi_ctrl_string = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vivi_ctrl_bitmask = {
+	.ops = &vivi_ctrl_ops,
+	.id = VIVI_CID_CUSTOM_BASE + 6,
+	.name = "Bitmask",
+	.type = V4L2_CTRL_TYPE_BITMASK,
+	.def = 0x80002000,
+	.min = 0,
+	.max = 0x80402010,
+	.step = 0,
+};
+
 static const struct v4l2_file_operations vivi_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
@@ -1219,6 +1232,7 @@ static int __init vivi_create_instance(int inst)
 	dev->boolean = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_boolean, NULL);
 	dev->menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_menu, NULL);
 	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
+	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
 	if (hdl->error) {
 		ret = hdl->error;
 		goto unreg_dev;
-- 
1.7.1


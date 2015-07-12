Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34767 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbGLXIW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 19:08:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] vb2: Fix compilation breakage when !CONFIG_BUG
Date: Mon, 13 Jul 2015 02:08:34 +0300
Message-Id: <1436742514-16396-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 77a3c6fd90c9 ("[media] vb2: Don't WARN when v4l2_buffer.bytesused
is 0 for multiplanar buffers") uses the __WARN() macro which isn't
defined when CONFIG_BUG isn't set. This introduces a compilation
breakage. Fix it by using WARN_ON() instead.

The commit was also broken in that it merged v1 of the patch while a new
v2 version had been submitted, reviewed and acked. Fix it by
incorporating the changes from v1 to v2.

Fixes: 77a3c6fd90c9 ("[media] vb2: Don't WARN when v4l2_buffer.bytesused is 0 for multiplanar buffers")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Mauro,

Commit 77a3c6fd90c9 was merged in v4.2-rc1, so this is a v4.2 regression. The
commit was also marked with a Fixes: line for commit f61bf13b6a07, which was
merged in v4.1-rc1. It might thus get backported to the v4.1 stable series, in
which case this fix needs to be backported as well. I'll let you sort this out.

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 93b315459098..db11d853b060 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1244,19 +1244,19 @@ EXPORT_SYMBOL_GPL(vb2_discard_done);
 
 static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 {
-	static bool __check_once __read_mostly;
+	static bool check_once;
 
-	if (__check_once)
+	if (check_once)
 		return;
 
-	__check_once = true;
-	__WARN();
+	check_once = true;
+	WARN_ON(1);
 
-	pr_warn_once("use of bytesused == 0 is deprecated and will be removed in the future,\n");
+	pr_warn("use of bytesused == 0 is deprecated and will be removed in the future,\n");
 	if (vb->vb2_queue->allow_zero_bytesused)
-		pr_warn_once("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
+		pr_warn("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
 	else
-		pr_warn_once("use the actual size instead.\n");
+		pr_warn("use the actual size instead.\n");
 }
 
 /**
-- 
Regards,

Laurent Pinchart


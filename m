Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34896 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbbDUM7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 08:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/15] videodev2.h: add request to v4l2_ext_controls
Date: Tue, 21 Apr 2015 14:58:45 +0200
Message-Id: <1429621138-17213-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The ctrl_class is fairly pointless when used with drivers that use the control
framework: you can just fill in 0 and it will just work fine. There are still
some old unconverted drivers that do not support 0 and instead want the control
class there. The idea being that all controls in the list all belong to that
class. This was done to simplify drivers in the absence of the control framework.

When using the control framework the framework itself is smart enough to allow
controls of any class to be included in the control list.

Since request IDs are in the range 1..65535 (or so, in any case a relatively
small non-zero positive integer) it makes sense to effectively rename ctrl_class
to request. Set it to 0 and you get the normal behavior (you change the current
control value), set it to a request ID and you get/set the control for
that request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 7 +++++--
 include/uapi/linux/videodev2.h       | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 119121f..74af586 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -563,8 +563,11 @@ static void v4l_print_ext_controls(const void *arg, bool write_only)
 	const struct v4l2_ext_controls *p = arg;
 	int i;
 
-	pr_cont("class=0x%x, count=%d, error_idx=%d",
-			p->ctrl_class, p->count, p->error_idx);
+	if (V4L2_CTRL_ID2CLASS(p->ctrl_class))
+		pr_cont("class=0x%x, ", p->ctrl_class);
+	else
+		pr_cont("request=%u, ", p->request);
+	pr_cont("count=%d, error_idx=%d", p->count, p->error_idx);
 	for (i = 0; i < p->count; i++) {
 		if (!p->controls[i].size)
 			pr_cont(", id/val=0x%x/0x%x",
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2269152..388e376 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1382,7 +1382,10 @@ struct v4l2_ext_control {
 } __attribute__ ((packed));
 
 struct v4l2_ext_controls {
-	__u32 ctrl_class;
+	union {
+		__u32 ctrl_class;
+		__u32 request;
+	};
 	__u32 count;
 	__u32 error_idx;
 	__u32 reserved[2];
-- 
2.1.4


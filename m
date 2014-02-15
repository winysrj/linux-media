Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1310 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBOMEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 07:04:15 -0500
Message-ID: <52FF579A.30400@xs4all.nl>
Date: Sat, 15 Feb 2014 13:03:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [REVIEWv2 PATCH 37/34] v4l2-ctrls: set elem_size for all types handled
 by std_type_ops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes sense to have elem_size prefilled for types that the control
framework knows about.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 23febc4..bc30c50 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1821,12 +1821,25 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		rows = 1;
 	is_matrix = cols > 1 || rows > 1;
 
-	if (type == V4L2_CTRL_TYPE_INTEGER64)
+	/* Prefill elem_size for all types handled by std_type_ops */
+	switch (type) {
+	case V4L2_CTRL_TYPE_INTEGER64:
 		elem_size = sizeof(s64);
-	else if (type == V4L2_CTRL_TYPE_STRING)
+		break;
+	case V4L2_CTRL_TYPE_STRING:
 		elem_size = max + 1;
-	else if (type < V4L2_CTRL_COMPLEX_TYPES)
-		elem_size = sizeof(s32);
+		break;
+	case V4L2_CTRL_TYPE_U8:
+		elem_size = sizeof(u8);
+		break;
+	case V4L2_CTRL_TYPE_U16:
+		elem_size = sizeof(u16);
+		break;
+	default:
+		if (type < V4L2_CTRL_COMPLEX_TYPES)
+			elem_size = sizeof(s32);
+		break;
+	}
 	tot_ctrl_size = elem_size * cols * rows;
 
 	/* Sanity checks */
-- 
1.8.5.2


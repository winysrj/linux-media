Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52172 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752803AbdDJT1U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 13/15] v4l2-ctrls.c: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for ROTATE
Date: Mon, 10 Apr 2017 21:26:49 +0200
Message-Id: <20170410192651.18486-14-hverkuil@xs4all.nl>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The rotate control will modify the layout by definition. Always
set this flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b4b364f68695..ec42872d11cf 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -997,6 +997,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*min = 0;
 		*max = *step = 1;
 		break;
+	case V4L2_CID_ROTATE:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*flags |= V4L2_CTRL_FLAG_MODIFY_LAYOUT;
+		break;
 	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
 		*type = V4L2_CTRL_TYPE_INTEGER;
-- 
2.11.0

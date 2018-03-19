Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61162 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932708AbeCSOaN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 10:30:13 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, smitha.t@samsung.com, a.hajda@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-mfc: Amend initial min, max values of HEVC hierarchical
 coding QP controls
Date: Mon, 19 Mar 2018 15:29:58 +0100
Message-id: <20180319142958.21569-1-s.nawrocki@samsung.com>
References: <CGME20180319143010epcas2p25aa33888e29cc229adf272369b6e684b@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Valid range for those controls is specified in documentation as [0, 51],
so initialize the controls to such range rather than [INT_MIN, INT_MAX].

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 810dabe2f1b9..7382b41f4f6d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -856,56 +856,56 @@ static struct mfc_control controls[] = {
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
 	{
 		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP,
 		.type = V4L2_CTRL_TYPE_INTEGER,
-		.minimum = INT_MIN,
-		.maximum = INT_MAX,
+		.minimum = 0,
+		.maximum = 51,
 		.step = 1,
 		.default_value = 0,
 	},
-- 
2.14.2

Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37996 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZJPKUn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 06:20:43 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GAK4o9030493
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 05:20:06 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/4] V4L2: Added CID's V4L2_CID_ROTATE/BG_COLOR
Date: Fri, 16 Oct 2009 15:50:03 +0530
Message-Id: <1255688403-6334-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/v4l2-common.c |    9 +++++++++
 include/linux/videodev2.h         |    4 +++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index f5a93ae..35a0107 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -431,6 +431,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
 	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
 	case V4L2_CID_COLORFX:			return "Color Effects";
+	case V4L2_CID_ROTATE:			return "Rotate";
+	case V4L2_CID_BG_COLOR:			return "Background color";
 
 	/* MPEG controls */
 	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
@@ -587,6 +589,13 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		min = max = step = def = 0;
 		break;
+	case V4L2_CID_BG_COLOR:
+		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
+		step = 1;
+		min = 0;
+		/* Max is calculated as RGB888 that is 2^12*/
+		max = 0xFFFFFF;
+		break;
 	default:
 		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b6fe1de..d77db6f 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -912,8 +912,10 @@ enum v4l2_colorfx {
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
 
+#define V4L2_CID_ROTATE				(V4L2_CID_BASE+34)
+#define V4L2_CID_BG_COLOR			(V4L2_CID_BASE+35)
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+34)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+36)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.6.2.4


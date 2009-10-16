Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbZJPKVJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 06:21:09 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GAKUKR003927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 05:20:32 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 3/4] V4L2: Add Capability and Flag field for Croma Key
Date: Fri, 16 Oct 2009 15:50:29 +0530
Message-Id: <1255688429-6376-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 include/linux/videodev2.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index d77db6f..adff8d9 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -563,6 +563,7 @@ struct v4l2_framebuffer {
 #define V4L2_FBUF_CAP_LOCAL_ALPHA	0x0010
 #define V4L2_FBUF_CAP_GLOBAL_ALPHA	0x0020
 #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA	0x0040
+#define V4L2_FBUF_CAP_SRC_CHROMAKEY	0x0080
 /*  Flags for the 'flags' field. */
 #define V4L2_FBUF_FLAG_PRIMARY		0x0001
 #define V4L2_FBUF_FLAG_OVERLAY		0x0002
@@ -570,6 +571,7 @@ struct v4l2_framebuffer {
 #define V4L2_FBUF_FLAG_LOCAL_ALPHA	0x0008
 #define V4L2_FBUF_FLAG_GLOBAL_ALPHA	0x0010
 #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA	0x0020
+#define V4L2_FBUF_FLAG_SRC_CHROMAKEY	0x0040
 
 struct v4l2_clip {
 	struct v4l2_rect        c;
-- 
1.6.2.4


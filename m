Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:40329 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdHUHzw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:55:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH v3 1/2] Add metadata output definitions from metadata output patches
Date: Mon, 21 Aug 2017 10:55:23 +0300
Message-Id: <20170821075524.21048-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170821075524.21048-1-sakari.ailus@linux.intel.com>
References: <20170821075524.21048-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/linux/videodev2.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 49fe06c97..4db47dba4 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -142,6 +142,7 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
 	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
 	V4L2_BUF_TYPE_META_CAPTURE         = 13,
+	V4L2_BUF_TYPE_META_OUTPUT	   = 14,
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
@@ -453,6 +454,7 @@ struct v4l2_capability {
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
+#define V4L2_CAP_META_OUTPUT		0x08000000  /* Is a metadata output device */
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
-- 
2.11.0

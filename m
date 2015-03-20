Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
 Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 2/5] media: New flag V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
Date: Fri, 20 Mar 2015 14:45:43 +0100
Message-id: <1426859143-3515-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Create a new flag that represent controls which its value needs to be
passed to the driver even if it has not changed.

They typically represent actions, like triggering a flash or clearing an
error flag. So writing to such a control means some action is executed.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v2: By Hans Verkuil <hverkuil@xs4all.nl>
Reword commit message

 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..1e33e10 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1456,6 +1456,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
 #define V4L2_CTRL_FLAG_VOLATILE		0x0080
 #define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
+#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
 
 /*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
-- 
2.1.4

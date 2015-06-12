Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v3 03/19] videodev2.h: Fix typo in comment
Date: Fri, 12 Jun 2015 18:46:22 +0200
Message-id: <1434127598-11719-4-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Referenced file has moved

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 include/uapi/linux/videodev2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b9468a3b833e..b059237f0214 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2272,7 +2272,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_G_DEF_EXT_CTRLS	_IOWR('V', 104, struct v4l2_ext_controls)
 
 /* Reminder: when adding new ioctls please add support for them to
-   drivers/media/video/v4l2-compat-ioctl32.c as well! */
+   drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
 
 #define BASE_VIDIOC_PRIVATE	192		/* 192-255 are private */
 
-- 
2.1.4

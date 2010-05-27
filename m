Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab0E0HIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 03:08:37 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4R78bHN005345
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 27 May 2010 03:08:37 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] move v4l1 ioctls from kernel to libv4l1: VIDIOCSCHAN move VIDIOCSCHAN to libv4l1 Signed-off-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
Date: Thu, 27 May 2010 12:36:33 +0530
Message-Id: <1274943993-28246-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@redhat.com>

---
 lib/libv4l1/libv4l1.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index f64025a..4a65222 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -702,7 +702,35 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 		struct video_channel *chan = arg;
 		if ((devices[index].flags & V4L1_SUPPORTS_ENUMINPUT) &&
 				(devices[index].flags & V4L1_SUPPORTS_ENUMSTD)) {
-			result = SYS_IOCTL(fd, request, arg);
+
+			v4l2_std_id sid = 0;
+			struct v4l2_input input2;
+
+			result = SYS_IOCTL(fd, VIDIOC_ENUMINPUT, &input2);
+			if (result < 0)
+				break;
+
+			switch (chan->norm) {
+			case VIDEO_MODE_PAL:
+				sid = V4L2_STD_PAL;
+				break;
+			case VIDEO_MODE_NTSC:
+				sid = V4L2_STD_NTSC;
+				break;
+			case VIDEO_MODE_SECAM:
+				sid = V4L2_STD_SECAM;
+				break;
+			case VIDEO_MODE_AUTO:
+				sid = V4L2_STD_ALL;
+				break;
+			}
+			
+			if (0 != sid) {
+				result = SYS_IOCTLdrv(fd, VIDIOC_S_STD, &sid);
+				if (result < 0)
+					break;
+			}
+			
 			break;
 		}
 		/* In case of no ENUMSTD support, ignore the norm member of the
-- 
1.6.6.1


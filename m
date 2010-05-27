Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0E0GrD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 02:47:03 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4R6l2B0001697
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 27 May 2010 02:47:02 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: move v4l1 ioctls from kernel to libv4l1: VIDIOCSCHAN move VIDIOCSCHAN to libv4l1 Signed-off-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
Date: Thu, 27 May 2010 12:14:49 +0530
Message-Id: <1274942689-27584-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@redhat.com>

---
 lib/libv4l1/libv4l1.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index f64025a..077d57c 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -702,7 +702,44 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 		struct video_channel *chan = arg;
 		if ((devices[index].flags & V4L1_SUPPORTS_ENUMINPUT) &&
 				(devices[index].flags & V4L1_SUPPORTS_ENUMSTD)) {
-			result = SYS_IOCTL(fd, request, arg);
+
+			v4l2_std_id sid;
+
+			input2.index = chan->channel;
+			result = SYS_IOCTL(fd, VIDIOC_ENUMINPUT, &input2);
+			if (result < 0)
+				break;
+
+			chan->channel = input2.index;
+			memcpy(chan->name, input2.name,
+				min(sizeof(chan->name), sizeof(input2.name)));
+
+			chan->name[sizeof(chan->name) - 1] = 0;
+			chan->tuners =
+				(input2.type == V4L2_INPUT_TYPE_TUNER) ? 1 : 0;
+
+			chan->flags = (chan->tuners) ? VIDEO_VC_TUNER : 0;
+			switch (input2.type) {
+			case V4L2_INPUT_TYPE_TUNER:
+				chan->type = VIDEO_TYPE_TV;
+				break;
+			default:
+			case V4L2_INPUT_TYPE_CAMERA:
+				chan->type = VIDEO_TYPE_CAMERA;
+				break;
+			}
+			chan->norm = 0;
+			if (SYS_IOCTL(fd, VIDIOC_G_STD, &sid) == 0) {
+				if (sid & V4L2_STD_PAL)
+					chan->norm = VIDEO_MODE_PAL;
+				if (sid & V4L2_STD_NTSC)
+					chan->norm = VIDEO_MODE_NTSC;
+				if (sid & V4L2_STD_SECAM)
+					chan->norm = VIDEO_MODE_SECAM;
+				if (sid == V4L2_STD_ALL)
+					chan->norm = VIDEO_MODE_AUTO;
+			}
+
 			break;
 		}
 		/* In case of no ENUMSTD support, ignore the norm member of the
-- 
1.6.6.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab0FDGvk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 02:51:40 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o546pdS8017770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 02:51:39 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: move VIDIOCGTUNER and VIDIOCSTUNER to libv4l1
Date: Fri,  4 Jun 2010 12:19:40 +0530
Message-Id: <1275634180-21406-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@redhat.com>

move VIDIOCGTUNER and VIDIOCSTUNER to libv4l1

Signed-of-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 lib/libv4l1/libv4l1.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index 75b823c..081ed0a 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -881,6 +881,64 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 		break;
 	}
 
+	case VIDIOCSTUNER: {
+		struct video_tuner *tun = arg;
+		struct v4l2_tuner t = { 0, };
+
+		t.index = tun->tuner;
+		result = v4l2_ioctl(fd, VIDIOC_S_TUNER, &t);
+
+		break;
+	}
+
+	case VIDIOCGTUNER: {
+		int i;
+		struct video_tuner *tun = arg;
+		struct v4l2_tuner tun2 = { 0, };
+		struct v4l2_standard std2 = { 0, };
+		v4l2_std_id sid;
+
+		result = v4l2_ioctl(fd, VIDIOC_G_TUNER, &tun2);
+		if (result < 0)
+			break;
+
+		memcpy(tun->name, tun2.name,
+			min(sizeof(tun->name), sizeof(tun2.name)));
+		tun->name[sizeof(tun->name) - 1] = 0;
+		tun->rangelow = tun2.rangelow;
+		tun->rangehigh = tun2.rangehigh;
+		tun->flags = 0;
+		tun->mode = VIDEO_MODE_AUTO;
+
+		for (i = 0; i < 64; i++) {
+			std2.index = i;
+			if (0 != v4l2_ioctl(fd, VIDIOC_ENUMSTD, &std2))
+				break;
+			if (std2.id & V4L2_STD_PAL)
+				tun->flags |= VIDEO_TUNER_PAL;
+			if (std2.id & V4L2_STD_NTSC)
+				tun->flags |= VIDEO_TUNER_NTSC;
+			if (std2.id & V4L2_STD_SECAM)
+				tun->flags |= VIDEO_TUNER_SECAM;
+		}
+
+		if (v4l2_ioctl(fd, VIDIOC_G_STD, &sid) == 0) {
+			if (sid & V4L2_STD_PAL)
+				tun->mode = VIDEO_MODE_PAL;
+			if (sid & V4L2_STD_NTSC)
+				tun->mode = VIDEO_MODE_NTSC;
+			if (sid & V4L2_STD_SECAM)
+				tun->mode = VIDEO_MODE_SECAM;
+		}
+		if (tun2.capability & V4L2_TUNER_CAP_LOW)
+			tun->flags |= VIDEO_TUNER_LOW;
+		if (tun2.rxsubchans & V4L2_TUNER_SUB_STEREO)
+			tun->flags |= VIDEO_TUNER_STEREO_ON;
+		tun->signal = tun2.signal;
+
+		break;
+	}
+
 	default:
 		/* Pass through libv4l2 for applications which are using v4l2 through
 		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
-- 
1.6.6.1


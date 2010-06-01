Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0FAJjX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 05:39:23 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o519dNGM020747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 05:39:23 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: Move VIDIOCSFBUF into libv4l1
Date: Tue,  1 Jun 2010 15:07:21 +0530
Message-Id: <1275385041-4782-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@fedora-12.(none)>

Move VIDIOCSFBUF into libv4l1 and correct a missing
break with the last commit

Signed-Off-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 lib/libv4l1/libv4l1.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index ac3c2d9..877508c 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -847,6 +847,38 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 				(buffer->width * buffer->depth + 7) & 7;
 			buffer->bytesperline >>= 3;
 		}
+		break;
+	}
+
+	case VIDIOCSFBUF: {
+		struct video_buffer *buffer = arg;
+		struct v4l2_framebuffer fbuf = { 0, };
+
+		fbuf.base = buffer->base;
+		fbuf.fmt.height = buffer->height;
+		fbuf.fmt.width = buffer->width;
+
+		switch (buffer->depth) {
+		case 8:
+			fbuf.fmt.pixelformat = V4L2_PIX_FMT_RGB332;
+			break;
+		case 15:
+			fbuf.fmt.pixelformat = V4L2_PIX_FMT_RGB555;
+			break;
+		case 16:
+			fbuf.fmt.pixelformat = V4L2_PIX_FMT_RGB565;
+			break;
+		case 24:
+			fbuf.fmt.pixelformat = V4L2_PIX_FMT_BGR24;
+			break;
+		case 32:
+			fbuf.fmt.pixelformat = V4L2_PIX_FMT_BGR32;
+			break;
+		}
+
+		fbuf.fmt.bytesperline = buffer->bytesperline;
+		result = v4l2_ioctl(fd, VIDIOC_G_FBUF, buffer);
+		break;
 	}
 
 	default:
-- 
1.6.6.1


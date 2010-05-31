Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab0EaIFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 04:05:32 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4V85Vi3030303
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 31 May 2010 04:05:32 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: Move VIDIOCGFBUF into libv4l1
Date: Mon, 31 May 2010 13:33:28 +0530
Message-Id: <1275293008-3261-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@fedora-12.(none)>

Move VIDIOCGFBUF into libv4l1

Signed-off-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 lib/libv4l1/libv4l1.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index e13feba..5b2dc29 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -804,6 +804,51 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 		break;
 	}
 
+	case VIDIOCGFBUF: {
+		struct video_buffer *buffer = arg;
+		struct v4l2_framebuffer fbuf = { 0, };
+
+		result = v4l2_ioctl(fd, VIDIOC_G_FBUF, buffer);
+		if (result < 0)
+			break;
+
+		buffer->base = fbuf.base;
+		buffer->height = fbuf.fmt.height;
+		buffer->width = fbuf.fmt.width;
+
+		switch (fbuf.fmt.pixelformat) {
+		case V4L2_PIX_FMT_RGB332:
+			buffer->depth = 8;
+			break;
+		case V4L2_PIX_FMT_RGB555:
+			buffer->depth = 15;
+			break;
+		case V4L2_PIX_FMT_RGB565:
+			buffer->depth = 16;
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			buffer->depth = 24;
+			break;
+		case V4L2_PIX_FMT_BGR32:
+			buffer->depth = 32;
+			break;
+		default:
+			buffer->depth = 0;
+		}
+
+		if (fbuf.fmt.bytesperline) {
+			buffer->bytesperline = fbuf.fmt.bytesperline;
+			if (!buffer->depth && buffer->width)
+				buffer->depth = ((fbuf.fmt.bytesperline<<3)
+						+ (buffer->width-1))
+						/ buffer->width;
+			} else {
+				buffer->bytesperline =
+					(buffer->width * buffer->depth + 7) & 7;
+				buffer->bytesperline >>= 3;
+			}
+	}
+
 	default:
 		/* Pass through libv4l2 for applications which are using v4l2 through
 		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
-- 
1.6.6.1


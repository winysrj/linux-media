Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab0FDHmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 03:42:15 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o547gEqj006455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 03:42:14 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: move VIDIOCCAPTURE to libv4l1
Date: Fri,  4 Jun 2010 13:10:14 +0530
Message-Id: <1275637214-22089-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@redhat.com>

move VIDIOCCAPTURE to libv4l1

Signed-of-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 lib/libv4l1/libv4l1.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index 579f13b..2981c40 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -967,6 +967,22 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 
 		break;
 	}
+
+	case VIDIOCCAPTURE: {
+		int *on = arg;
+		enum v4l2_buf_type captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+		if (0 == *on) {
+		/* dirty hack time.  But v4l1 has no STREAMOFF
+		* equivalent in the API, and this one at
+		* least comes close ... */
+			v4l2_ioctl(fd, VIDIOC_STREAMOFF, &captype);
+		}
+
+		result = v4l2_ioctl(fd, VIDIOC_OVERLAY, on);
+
+		break;
+	}
 	default:
 		/* Pass through libv4l2 for applications which are using v4l2 through
 		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
-- 
1.6.6.1


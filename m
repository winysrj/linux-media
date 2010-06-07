Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0FGKZJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 06:25:09 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o57AP9co017626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jun 2010 06:25:09 -0400
From: huzaifas@redhat.com
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] libv4l1: move VIDIOCGVBIFMT and VIDIOCSVBIFMT into libv4l1
Date: Mon,  7 Jun 2010 15:53:11 +0530
Message-Id: <1275906191-26135-1-git-send-email-huzaifas@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huzaifa Sidhpurwala <huzaifas@redhat.com>

move VIDIOCGVBIFMT and VIDIOCSVBIFMT into libv4l1

Signed-of-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 lib/libv4l1/libv4l1.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index 263d564..6d6caa6 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -1143,6 +1143,71 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 
 	}
 
+	case VIDIOCSVBIFMT: {
+		struct vbi_format *fmt = arg;
+		struct v4l2_format fmt2;
+
+		if (VIDEO_PALETTE_RAW != fmt->sample_format) {
+			result = -EINVAL;
+			break;
+		}
+
+		fmt2.type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		fmt2.fmt.vbi.samples_per_line = fmt->samples_per_line;
+		fmt2.fmt.vbi.sampling_rate    = fmt->sampling_rate;
+		fmt2.fmt.vbi.sample_format    = V4L2_PIX_FMT_GREY;
+		fmt2.fmt.vbi.start[0]         = fmt->start[0];
+		fmt2.fmt.vbi.count[0]         = fmt->count[0];
+		fmt2.fmt.vbi.start[1]         = fmt->start[1];
+		fmt2.fmt.vbi.count[1]         = fmt->count[1];
+		fmt2.fmt.vbi.flags            = fmt->flags;
+
+		result  = v4l2_ioctl(fd, VIDIOC_TRY_FMT, fmt2);
+		if (result < 0)
+			break;
+
+		if (fmt2.fmt.vbi.samples_per_line != fmt->samples_per_line ||
+		fmt2.fmt.vbi.sampling_rate    != fmt->sampling_rate    ||
+		fmt2.fmt.vbi.sample_format    != V4L2_PIX_FMT_GREY     ||
+		fmt2.fmt.vbi.start[0]         != fmt->start[0]         ||
+		fmt2.fmt.vbi.count[0]         != fmt->count[0]         ||
+		fmt2.fmt.vbi.start[1]         != fmt->start[1]         ||
+		fmt2.fmt.vbi.count[1]         != fmt->count[1]         ||
+		fmt2.fmt.vbi.flags            != fmt->flags) {
+			result = -EINVAL;
+			break;
+		}
+		result = v4l2_ioctl(fd, VIDIOC_S_FMT, fmt2);
+
+	}
+
+	case VIDIOCGVBIFMT: {
+		struct vbi_format *fmt = arg;
+		struct v4l2_format fmt2 = { 0, };
+
+		fmt2.type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		result = v4l2_ioctl(fd, VIDIOC_G_FMT, &fmt2);
+
+		if (result < 0)
+			break;
+
+		if (fmt2.fmt.vbi.sample_format != V4L2_PIX_FMT_GREY) {
+			result = -EINVAL;
+			break;
+		}
+
+		fmt->samples_per_line = fmt2.fmt.vbi.samples_per_line;
+		fmt->sampling_rate    = fmt2.fmt.vbi.sampling_rate;
+		fmt->sample_format    = VIDEO_PALETTE_RAW;
+		fmt->start[0]         = fmt2.fmt.vbi.start[0];
+		fmt->count[0]         = fmt2.fmt.vbi.count[0];
+		fmt->start[1]         = fmt2.fmt.vbi.start[1];
+		fmt->count[1]         = fmt2.fmt.vbi.count[1];
+		fmt->flags            = fmt2.fmt.vbi.flags & 0x03;
+
+		break;
+	}
+
 	default:
 		/* Pass through libv4l2 for applications which are using v4l2 through
 		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
-- 
1.6.6.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:61804 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2FGPUe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 11:20:34 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-70.cisco.com [10.54.92.70])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id q57FKWqn021026
	for <linux-media@vger.kernel.org>; Thu, 7 Jun 2012 15:20:32 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.5] Fix regression in ioctl numbering
Date: Thu, 7 Jun 2012 17:20:31 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206071720.31436.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yuck. The VIDIOC_(TRY_)DECODER_CMD ioctls already had ioctl numbers 96 and 97,
and after merging the timings API I forgot to continue numbering from 98. So
now we have two ioctls with number 96 and two with 97.

With the new table-driver ioctl handling in v4l2-ioctl.c it is essential that
each ioctl has its own unique number, so let's fix this quickly for 3.5.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 370d111..2039c5d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2640,9 +2640,9 @@ struct v4l2_create_buffers {
 
 /* Experimental, these three ioctls may change over the next couple of kernel
    versions. */
-#define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 96, struct v4l2_enum_dv_timings)
-#define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 97, struct v4l2_dv_timings)
-#define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 98, struct v4l2_dv_timings_cap)
+#define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 98, struct v4l2_enum_dv_timings)
+#define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 99, struct v4l2_dv_timings)
+#define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 100, struct v4l2_dv_timings_cap)
 
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */

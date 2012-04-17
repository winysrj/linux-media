Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3163 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2DQOhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 10:37:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] Fix QUERYMENU regression
Date: Tue, 17 Apr 2012 14:41:58 +0200
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171441.58423.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

This patch fixes a regression in VIDIOC_QUERYMENU introduced when the
__s64 value field was added to the union. On a 64-bit system this will
change the size of this v4l2_querymenu structure from 44 to 48 bytes,
thus breaking the ABI. By adding the packed attribute it is working again.

Tested on both 64 and 32 bit systems.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index e69cacc..5a09ac3 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1176,7 +1176,7 @@ struct v4l2_querymenu {
 		__s64	value;
 	};
 	__u32		reserved;
-};
+} __attribute__ ((packed));
 
 /*  Control flags  */
 #define V4L2_CTRL_FLAG_DISABLED		0x0001

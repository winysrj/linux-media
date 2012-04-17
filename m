Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2085 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2DQNmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 09:42:40 -0400
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: [PATCH] Fix QUERYMENU regression
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 17 Apr 2012 15:36:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171536.15071.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(resent as my first attempt didn't reach the mailinglist for some reason)

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

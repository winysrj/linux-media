Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52591 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934258Ab1KCRBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 13:01:47 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LU300AQKGMWDN@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU300JNHGMW2N@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Nov 2011 17:01:44 +0000 (GMT)
Date: Thu, 03 Nov 2011 18:01:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 1/3] v4l: Add new g_framesamples subdev video operation
In-reply-to: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320339694-9027-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320339694-9027-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

g_framesamples() callback can be used for negotiating the maximum amount of
compressed data transmitted over the video bus. It allows the host drivers
to query the amount of the frame data which corresponds to required memory
buffer that needs to be allocated, before the actual transmission begins.

This is helpful in any case where the frame data size is not obvious from
frame width, height and media bus pixel format.

To obtain the final memory buffer size the host drivers should multiply
the value returned in 'count' by the number of bytes per media bus sample.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-subdev.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 257da1a..e46779d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -273,6 +273,10 @@ struct v4l2_subdev_audio_ops {
    s_mbus_config: set a certain mediabus configuration. This operation is added
 	for compatibility with soc-camera drivers and should not be used by new
 	software.
+
+   g_mbus_framesamples: get maximum number of media bus frame samples. This is
+	used to negotiate maximum memory buffer size for a compressed image
+	frame of given pixel format.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -320,6 +324,8 @@ struct v4l2_subdev_video_ops {
 			     struct v4l2_mbus_config *cfg);
 	int (*s_mbus_config)(struct v4l2_subdev *sd,
 			     const struct v4l2_mbus_config *cfg);
+	int (*g_mbus_framesamples)(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *fmt, unsigned int *count);
 };
 
 /*
-- 
1.7.7.1


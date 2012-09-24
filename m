Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:21456 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2IXN1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 09:27:08 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAU00A1TW10TH31@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 22:27:06 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAU0004CW0WP230@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 22:27:06 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
Date: Mon, 24 Sep 2012 15:26:53 +0200
Message-id: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s_rx_buffer callback allows the host to set buffer for non-image
(meta) data at a subdev. This callback can be implemented by an image
sensor or a MIPI-CSI receiver, allowing the host to retrieve the frame
embedded data from a subdev.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-subdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 22ab09e..28067ed 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -274,6 +274,10 @@ struct v4l2_subdev_audio_ops {
    s_mbus_config: set a certain mediabus configuration. This operation is added
 	for compatibility with soc-camera drivers and should not be used by new
 	software.
+
+   s_rx_buffer: set a host allocated memory buffer for the subdev. The subdev
+	can adjust @size to a lower value and must not write more data to the
+	buffer starting at @data than the original value of @size.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -327,6 +331,8 @@ struct v4l2_subdev_video_ops {
 			     struct v4l2_mbus_config *cfg);
 	int (*s_mbus_config)(struct v4l2_subdev *sd,
 			     const struct v4l2_mbus_config *cfg);
+	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
+			   unsigned int *size);
 };

 /*
--
1.7.11.3


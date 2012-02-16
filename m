Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31505 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BPSYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZI007W10G4XR80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI00FAL0G3MA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:56 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 3/6] V4L: Add g_embedded_data subdev callback
In-reply-to: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329416639-19454-4-git-send-email-s.nawrocki@samsung.com>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_embedded_data callback allows the host to retrieve frame embedded
(meta) data from a certain subdev. This callback can be implemented by
an image sensor or a MIPI-CSI receiver, allowing to read embedded frame
data from a subdev or just query it for the data size.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-subdev.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index f0f3358..be74061 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -274,6 +274,14 @@ struct v4l2_subdev_audio_ops {
    s_mbus_config: set a certain mediabus configuration. This operation is added
 	for compatibility with soc-camera drivers and should not be used by new
 	software.
+
+   g_embedded_data: retrieve the frame embedded data (frame header or footer).
+	After a full frame has been transmitted the host can query a subdev
+	for frame meta data using this operation. Metadata size is returned
+	in @size, and the actual metadata in memory pointed by @data. When
+	@buf is NULL the subdev will return only the metadata size. The
+	subdevs can adjust @size to a lower value but must not write more
+	data than the @size's original value.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -321,6 +329,8 @@ struct v4l2_subdev_video_ops {
 			     struct v4l2_mbus_config *cfg);
 	int (*s_mbus_config)(struct v4l2_subdev *sd,
 			     const struct v4l2_mbus_config *cfg);
+	int (*g_embedded_data)(struct v4l2_subdev *sd, unsigned int *size,
+			       void **buf);
 };
 
 /*
-- 
1.7.9


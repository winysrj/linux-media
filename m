Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49585 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbbCIPu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:50:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 29/29] vivid: add the new planar and monochrome formats
Date: Mon,  9 Mar 2015 16:44:51 +0100
Message-Id: <1425915891-1017-30-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Everything is in place to support these formats, so add them to
the list.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 114 +++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 0f93fea..7cb4aa0 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -51,7 +51,7 @@ struct vivid_fmt vivid_formats[] = {
 		.is_yuv   = true,
 		.planes   = 1,
 		.buffers = 1,
-		.data_offset = { PLANE0_DATA_OFFSET, 0 },
+		.data_offset = { PLANE0_DATA_OFFSET },
 	},
 	{
 		.name     = "4:2:2, packed, UYVY",
@@ -81,6 +81,78 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.name     = "YUV 4:2:2 triplanar",
+		.fourcc   = V4L2_PIX_FMT_YUV422P,
+		.vdownsampling = { 1, 1, 1 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 1,
+	},
+	{
+		.name     = "YUV 4:2:0 triplanar",
+		.fourcc   = V4L2_PIX_FMT_YUV420,
+		.vdownsampling = { 1, 2, 2 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 1,
+	},
+	{
+		.name     = "YVU 4:2:0 triplanar",
+		.fourcc   = V4L2_PIX_FMT_YVU420,
+		.vdownsampling = { 1, 2, 2 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 1,
+	},
+	{
+		.name     = "YUV 4:2:0 biplanar",
+		.fourcc   = V4L2_PIX_FMT_NV12,
+		.vdownsampling = { 1, 2 },
+		.bit_depth = { 8, 8 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 1,
+	},
+	{
+		.name     = "YVU 4:2:0 biplanar",
+		.fourcc   = V4L2_PIX_FMT_NV21,
+		.vdownsampling = { 1, 2 },
+		.bit_depth = { 8, 8 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 1,
+	},
+	{
+		.name     = "YUV 4:2:2 biplanar",
+		.fourcc   = V4L2_PIX_FMT_NV16,
+		.vdownsampling = { 1, 1 },
+		.bit_depth = { 8, 8 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 1,
+	},
+	{
+		.name     = "YVU 4:2:2 biplanar",
+		.fourcc   = V4L2_PIX_FMT_NV61,
+		.vdownsampling = { 1, 1 },
+		.bit_depth = { 8, 8 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 1,
+	},
+	{
+		.name     = "Monochrome",
+		.fourcc   = V4L2_PIX_FMT_GREY,
+		.vdownsampling = { 1 },
+		.bit_depth = { 8 },
+		.is_yuv   = true,
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
 		.vdownsampling = { 1 },
@@ -221,10 +293,46 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 2,
 		.data_offset = { 0, PLANE0_DATA_OFFSET },
 	},
+	{
+		.name     = "4:2:0, triplanar, YUV",
+		.fourcc   = V4L2_PIX_FMT_YUV420M,
+		.vdownsampling = { 1, 2, 2 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 3,
+	},
+	{
+		.name     = "4:2:0, triplanar, YVU",
+		.fourcc   = V4L2_PIX_FMT_YVU420M,
+		.vdownsampling = { 1, 2, 2 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 3,
+	},
+	{
+		.name     = "4:2:0, biplanar, YUV",
+		.fourcc   = V4L2_PIX_FMT_NV12M,
+		.vdownsampling = { 1, 2 },
+		.bit_depth = { 8, 8 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 2,
+	},
+	{
+		.name     = "4:2:0, biplanar, YVU",
+		.fourcc   = V4L2_PIX_FMT_NV21M,
+		.vdownsampling = { 1, 2 },
+		.bit_depth = { 8, 8 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 2,
+	},
 };
 
-/* There are 2 multiplanar formats in the list */
-#define VIVID_MPLANAR_FORMATS 2
+/* There are 6 multiplanar formats in the list */
+#define VIVID_MPLANAR_FORMATS 6
 
 const struct vivid_fmt *vivid_get_format(struct vivid_dev *dev, u32 pixelformat)
 {
-- 
2.1.4


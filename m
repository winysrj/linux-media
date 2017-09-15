Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:41927 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751115AbdIOOvu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 10:51:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 2/2] vivid: add support for Y10 and Y12
Date: Fri, 15 Sep 2017 16:51:45 +0200
Message-Id: <20170915145145.44097-2-hverkuil@xs4all.nl>
In-Reply-To: <20170915145145.44097-1-hverkuil@xs4all.nl>
References: <20170915145145.44097-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Add support for 10 and 12 bit luma formats.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index f0f423c7ca41..a651527d80db 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -188,6 +188,22 @@ struct vivid_fmt vivid_formats[] = {
 		.planes   = 1,
 		.buffers = 1,
 	},
+	{
+		.fourcc   = V4L2_PIX_FMT_Y10,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.color_enc = TGP_COLOR_ENC_LUMA,
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_Y12,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.color_enc = TGP_COLOR_ENC_LUMA,
+		.planes   = 1,
+		.buffers = 1,
+	},
 	{
 		.fourcc   = V4L2_PIX_FMT_Y16,
 		.vdownsampling = { 1 },
-- 
2.14.1

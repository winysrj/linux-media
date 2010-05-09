Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2528 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0EINzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 09:55:47 -0400
Message-Id: <fd7b8109f9b34c40670cc8a3072e4917bb409eb3.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273413060.git.hverkuil@xs4all.nl>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 15:57:18 +0200
Subject: [PATCH 5/6] [RFC] tvp514x: remove obsolete fmt_list
To: linux-media@vger.kernel.org
Cc: hvaibhav@ti.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp514x.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 4e22621..1c3417b 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -198,21 +198,6 @@ static struct tvp514x_reg tvp514x_reg_list_default[] = {
 };
 
 /**
- * List of image formats supported by TVP5146/47 decoder
- * Currently we are using 8 bit mode only, but can be
- * extended to 10/20 bit mode.
- */
-static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
-	{
-	 .index = 0,
-	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-	 .flags = 0,
-	 .description = "8-bit UYVY 4:2:2 Format",
-	 .pixelformat = V4L2_PIX_FMT_UYVY,
-	},
-};
-
-/**
  * Supported standards -
  *
  * Currently supports two standards only, need to add support for rest of the
-- 
1.6.4.2


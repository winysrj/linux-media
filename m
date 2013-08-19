Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2233 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3HSOoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 14/20] v4l2-dv-timings: fill in type field
Date: Mon, 19 Aug 2013 16:44:23 +0200
Message-Id: <1376923469-30694-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The detect_cvt/gtf functions didn't fill in the type field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 1a9d393..c2f5af7 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -408,6 +408,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		h_fp = h_blank - hsync - h_bp;
 	}
 
+	fmt->type = V4L2_DV_BT_656_1120;
 	fmt->bt.polarities = polarities;
 	fmt->bt.width = image_width;
 	fmt->bt.height = image_height;
@@ -527,6 +528,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
 
 	h_fp = h_blank / 2 - hsync;
 
+	fmt->type = V4L2_DV_BT_656_1120;
 	fmt->bt.polarities = polarities;
 	fmt->bt.width = image_width;
 	fmt->bt.height = image_height;
-- 
1.8.3.2


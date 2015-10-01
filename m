Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33603 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbbJAMFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 08:05:11 -0400
Received: by wiclk2 with SMTP id lk2so29857750wic.0
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 05:05:10 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	mchehab@osg.samsung.com
Cc: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 1/2] V4L2: platform: rcar_jpu: remove redundant code
Date: Thu,  1 Oct 2015 15:03:31 +0300
Message-Id: <1443701012-20730-2-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1443701012-20730-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1443701012-20730-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove redundant code. Following code line do what we want.

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 drivers/media/platform/rcar_jpu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 2973f07..039bbbc 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1555,9 +1555,6 @@ static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
 		dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
 		if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
 			dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
-		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-		dst_buf->v4l2_buf.flags |= src_buf->v4l2_buf.flags &
-					V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 		dst_buf->v4l2_buf.flags = src_buf->v4l2_buf.flags &
 			(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_KEYFRAME |
 			 V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME |
-- 
2.5.1


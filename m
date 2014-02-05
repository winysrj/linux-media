Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaBEQlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 18/47] ad9389b: Remove deprecated video-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:09 +0100
Message-Id: <1391618558-5580-19-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/ad9389b.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 44c037d..4cdff9e 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -670,8 +670,6 @@ static const struct v4l2_subdev_video_ops ad9389b_video_ops = {
 	.s_stream = ad9389b_s_stream,
 	.s_dv_timings = ad9389b_s_dv_timings,
 	.g_dv_timings = ad9389b_g_dv_timings,
-	.enum_dv_timings = ad9389b_enum_dv_timings,
-	.dv_timings_cap = ad9389b_dv_timings_cap,
 };
 
 /* ------------------------------ PAD OPS ------------------------------ */
-- 
1.8.3.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaBEQl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 23/47] ths8200: Remove deprecated video-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:14 +0100
Message-Id: <1391618558-5580-24-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/ths8200.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index e17e5155..0f1e952 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -432,8 +432,6 @@ static const struct v4l2_subdev_video_ops ths8200_video_ops = {
 	.s_stream = ths8200_s_stream,
 	.s_dv_timings = ths8200_s_dv_timings,
 	.g_dv_timings = ths8200_g_dv_timings,
-	.enum_dv_timings = ths8200_enum_dv_timings,
-	.dv_timings_cap = ths8200_dv_timings_cap,
 };
 
 static const struct v4l2_subdev_pad_ops ths8200_pad_ops = {
-- 
1.8.3.2


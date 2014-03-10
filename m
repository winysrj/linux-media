Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaCJXOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 23/48] ths8200: Remove deprecated video-level DV timings operations
Date: Tue, 11 Mar 2014 00:15:34 +0100
Message-Id: <1394493359-14115-24-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ths8200.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index c4ec8b2..656d889 100644
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


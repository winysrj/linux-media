Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36967 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2KMNqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 08:46:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/2] omap_vout: Use the output overlay ioctl operations
Date: Tue, 13 Nov 2012 14:47:39 +0100
Message-Id: <1352814459-8215-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap_vout device implements the output overlay API, use the
corresponding ioctl operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap/omap_vout.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index dea33b5..971f0c2 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1845,9 +1845,9 @@ static const struct v4l2_ioctl_ops vout_ioctl_ops = {
 	.vidioc_s_fbuf				= vidioc_s_fbuf,
 	.vidioc_g_fbuf				= vidioc_g_fbuf,
 	.vidioc_s_ctrl       			= vidioc_s_ctrl,
-	.vidioc_try_fmt_vid_overlay 		= vidioc_try_fmt_vid_overlay,
-	.vidioc_s_fmt_vid_overlay		= vidioc_s_fmt_vid_overlay,
-	.vidioc_g_fmt_vid_overlay		= vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_out_overlay		= vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_out_overlay		= vidioc_s_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_out_overlay		= vidioc_g_fmt_vid_overlay,
 	.vidioc_cropcap				= vidioc_cropcap,
 	.vidioc_g_crop				= vidioc_g_crop,
 	.vidioc_s_crop				= vidioc_s_crop,
-- 
1.7.8.6


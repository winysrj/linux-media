Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbcCXX2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:18 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 28/51] v4l: vsp1: Add race condition FIXME comment
Date: Fri, 25 Mar 2016 01:27:24 +0200
Message-Id: <1458862067-19525-29-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 7cb270f57f62..102977ae1daa 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -813,6 +813,9 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 *
 	 * Use the VSP1 pipeline object embedded in the first video object that
 	 * starts streaming.
+	 *
+	 * FIXME: This is racy, the ioctl is only protected by the video node
+	 * lock.
 	 */
 	pipe = video->video.entity.pipe
 	     ? to_vsp1_pipeline(&video->video.entity) : &video->pipe;
-- 
2.7.3


Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39799 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbbFSNjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 09:39:19 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Fix plane stride and size checks
Date: Fri, 19 Jun 2015 16:39:59 +0300
Message-Id: <1434721199-3843-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The checks need to be performed on up to two planes, as the third plane,
if present, must have the same stride and size as the second plane.

The code incorrectly performs the checks on at least two planes instead
of at most two planes, fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c1b5a09b8331..60aa99faaa7f 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -245,7 +245,7 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	 * the datasheet, strides not aligned to a multiple of 128 bytes result
 	 * in image corruption.
 	 */
-	for (i = 0; i < max(info->planes, 2U); ++i) {
+	for (i = 0; i < min(info->planes, 2U); ++i) {
 		unsigned int hsub = i > 0 ? info->hsub : 1;
 		unsigned int vsub = i > 0 ? info->vsub : 1;
 		unsigned int align = 128;
-- 
Regards,

Laurent Pinchart

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in

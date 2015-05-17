Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36650 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbEQRTC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 13:19:02 -0400
From: Alex Dowad <alexinbeijing@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...),
	devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Clarify expression which uses both multiplication and pointer dereference
Date: Sun, 17 May 2015 19:18:42 +0200
Message-Id: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a checkpatch style error in vpfe_buffer_queue_setup.

Signed-off-by: Alex Dowad <alexinbeijing@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 06d48d5..04a687c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1095,7 +1095,7 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	size = video->fmt.fmt.pix.sizeimage;
 
 	if (vpfe_dev->video_limit) {
-		while (size * *nbuffers > vpfe_dev->video_limit)
+		while (size * (*nbuffers) > vpfe_dev->video_limit)
 			(*nbuffers)--;
 	}
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {
-- 
2.0.0.GIT


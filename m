Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40999 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2FOIwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 04:52:05 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5N00F0SHYLHHJ0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jun 2012 17:52:02 +0900 (KST)
Received: from localhost.localdomain ([106.116.37.195])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5N0005DHYH0Z80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jun 2012 17:52:02 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com, ch.naveen@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: Fix setting controls
Date: Fri, 15 Jun 2012 10:51:42 +0200
Message-id: <1339750302-12309-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed s_ctrl function when setting the following controls:
- V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER
- V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index e1ebc76..eaab13e 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -639,13 +639,13 @@ static int s5p_mfc_dec_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY:
-		ctx->loop_filter_mpeg4 = ctrl->val;
+		ctx->display_delay = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE:
 		ctx->display_delay_enable = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
-		ctx->display_delay = ctrl->val;
+		ctx->loop_filter_mpeg4 = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
 		ctx->slice_interface = ctrl->val;
-- 
1.7.0.4


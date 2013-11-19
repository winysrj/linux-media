Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55610 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KSO1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:27:52 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00M2MLI2NH40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:27:51 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 08/16] s5p-jpeg: Synchronize cached controls with V4L2 core
Date: Tue, 19 Nov 2013 15:27:00 +0100
Message-id: <1384871228-6648-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds proper initialization of the in-driver
cached state of JPEG controls with V4L2 core.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 650c4d3..b82e3fa 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -890,6 +890,9 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 	if (ctx->mode == S5P_JPEG_DECODE)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
 			V4L2_CTRL_FLAG_READ_ONLY;
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+
 	return 0;
 }
 
-- 
1.7.9.5


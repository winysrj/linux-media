Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45389 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3BULxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 06:53:48 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIK001TAJPMX1I0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 20:53:46 +0900 (KST)
Received: from shaik-linux.sisodomain.com ([107.108.207.106])
 by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MIK00DQ4JNSPK40@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 20:53:46 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] [media] fimc-lite: Initialize 'step' field in fimc_lite_ctrl
 structure
Date: Thu, 21 Feb 2013 17:24:18 +0530
Message-id: <1361447658-20793-2-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1361447658-20793-1-git-send-email-shaik.ameer@samsung.com>
References: <1361447658-20793-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_new() uses check_range() for control range checking.
This function expects 'step' value for V4L2_CTRL_TYPE_BOOLEAN type control.
If 'step' value doesn't match to '1', it returns -ERANGE error.

This patch adds the default .step value to 1.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index bfc4206..bbc35de 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1408,6 +1408,7 @@ static const struct v4l2_ctrl_config fimc_lite_ctrl = {
 	.id	= V4L2_CTRL_CLASS_USER | 0x1001,
 	.type	= V4L2_CTRL_TYPE_BOOLEAN,
 	.name	= "Test Pattern 640x480",
+	.step	= 1,
 };
 
 static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
-- 
1.7.9.5


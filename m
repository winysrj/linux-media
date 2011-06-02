Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50172 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1FBNuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 09:50:05 -0400
Date: Thu, 02 Jun 2011 15:49:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/7] s5p-fimc: Fix possible memory leak during capture devnode
 registration
In-reply-to: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.comi
Message-id: <1307022590-982-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add missing kfree on the error path.

Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index d142b40..7e66455 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -903,6 +903,7 @@ err_vd_reg:
 err_v4l2_reg:
 	v4l2_device_unregister(v4l2_dev);
 err_info:
+	kfree(ctx);
 	dev_err(&fimc->pdev->dev, "failed to install\n");
 	return ret;
 }
-- 
1.7.5.2


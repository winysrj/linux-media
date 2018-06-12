Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:39271 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbeFLKLO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:11:14 -0400
Received: by mail-lf0-f66.google.com with SMTP id t134-v6so35118149lff.6
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 03:11:14 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/6] [media] vim2m: Remove surplus name initialization
Date: Tue, 12 Jun 2018 13:11:01 +0300
Message-Id: <20180612101106.16346-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name is already initialized by assignment from vim2m_videodev.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 drivers/media/platform/vim2m.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e62db4..1393aa806462 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1020,7 +1020,6 @@ static int vim2m_probe(struct platform_device *pdev)
 	}
 
 	video_set_drvdata(vfd, dev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", vim2m_videodev.name);
 	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
 
-- 
2.17.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:40484 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753970AbeFLKLQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:11:16 -0400
Received: by mail-lf0-f65.google.com with SMTP id q11-v6so35105670lfc.7
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 03:11:15 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: linux-media@vger.kernel.org
Cc: Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/6] [media] ti-vpe: Remove surplus name initialization
Date: Tue, 12 Jun 2018 13:11:02 +0300
Message-Id: <20180612101106.16346-2-scileont@gmail.com>
In-Reply-To: <20180612101106.16346-1-scileont@gmail.com>
References: <20180612101106.16346-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name is already initialized by assignment from vpe_videodev.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index e395aa85c8ad..de968295ca7d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2485,7 +2485,6 @@ static void vpe_fw_cb(struct platform_device *pdev)
 	}
 
 	video_set_drvdata(vfd, dev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", vpe_videodev.name);
 	dev_info(dev->v4l2_dev.dev, "Device registered as /dev/video%d\n",
 		vfd->num);
 }
-- 
2.17.1

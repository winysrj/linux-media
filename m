Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45574 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754196AbeFLKLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:11:20 -0400
Received: by mail-lf0-f68.google.com with SMTP id n3-v6so35109927lfe.12
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 03:11:19 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5/6] [media] m2m-deinterlace: Remove surplus name initialization
Date: Tue, 12 Jun 2018 13:11:05 +0300
Message-Id: <20180612101106.16346-5-scileont@gmail.com>
In-Reply-To: <20180612101106.16346-1-scileont@gmail.com>
References: <20180612101106.16346-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name is already initialized by assignment from deinterlace_videodev.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 drivers/media/platform/m2m-deinterlace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1e4195144f39..3008892eb8dd 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1040,7 +1040,6 @@ static int deinterlace_probe(struct platform_device *pdev)
 	}
 
 	video_set_drvdata(vfd, pcdev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", deinterlace_videodev.name);
 	v4l2_info(&pcdev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
 			" Device registered as /dev/video%d\n", vfd->num);
 
-- 
2.17.1

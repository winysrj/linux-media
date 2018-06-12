Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43269 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754191AbeFLKLS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:11:18 -0400
Received: by mail-lf0-f68.google.com with SMTP id n15-v6so35094421lfn.10
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 03:11:18 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/6] [media] mx2: Remove surplus name initialization
Date: Tue, 12 Jun 2018 13:11:04 +0300
Message-Id: <20180612101106.16346-4-scileont@gmail.com>
In-Reply-To: <20180612101106.16346-1-scileont@gmail.com>
References: <20180612101106.16346-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name is already initialized by assignment from emmaprp_videodev.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 drivers/media/platform/mx2_emmaprp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 5a8eff60e95f..2e64729134b2 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -934,7 +934,6 @@ static int emmaprp_probe(struct platform_device *pdev)
 	vfd->v4l2_dev = &pcdev->v4l2_dev;
 
 	video_set_drvdata(vfd, pcdev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", emmaprp_videodev.name);
 	pcdev->vfd = vfd;
 	v4l2_info(&pcdev->v4l2_dev, EMMAPRP_MODULE_NAME
 		  " Device registered as /dev/video%d\n", vfd->num);
-- 
2.17.1

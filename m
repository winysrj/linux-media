Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34502 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbeFLKLV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:11:21 -0400
Received: by mail-lf0-f67.google.com with SMTP id o9-v6so35118514lfk.1
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 03:11:21 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6/6] [media] rga: Remove surplus name initialization
Date: Tue, 12 Jun 2018 13:11:06 +0300
Message-Id: <20180612101106.16346-6-scileont@gmail.com>
In-Reply-To: <20180612101106.16346-1-scileont@gmail.com>
References: <20180612101106.16346-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name is already initialized by assignment from rga_videodev.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 drivers/media/platform/rockchip/rga/rga.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index d508a8ba6f89..e8dffca669a1 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -882,7 +882,6 @@ static int rga_probe(struct platform_device *pdev)
 	vfd->v4l2_dev = &rga->v4l2_dev;
 
 	video_set_drvdata(vfd, rga);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", rga_videodev.name);
 	rga->vfd = vfd;
 
 	platform_set_drvdata(pdev, rga);
-- 
2.17.1

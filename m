Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34486 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753206AbeFLKLR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 06:11:17 -0400
Received: by mail-lf0-f68.google.com with SMTP id o9-v6so35118194lfk.1
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 03:11:17 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/6] [media] s5p-g2d: Remove surplus name initialization
Date: Tue, 12 Jun 2018 13:11:03 +0300
Message-Id: <20180612101106.16346-3-scileont@gmail.com>
In-Reply-To: <20180612101106.16346-1-scileont@gmail.com>
References: <20180612101106.16346-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name is already initialized by assignment from g2d_videodev.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 drivers/media/platform/s5p-g2d/g2d.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 66aa8cf1d048..3735c204e9ac 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -702,7 +702,6 @@ static int g2d_probe(struct platform_device *pdev)
 		goto rel_vdev;
 	}
 	video_set_drvdata(vfd, dev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", g2d_videodev.name);
 	dev->vfd = vfd;
 	v4l2_info(&dev->v4l2_dev, "device registered as /dev/video%d\n",
 								vfd->num);
-- 
2.17.1

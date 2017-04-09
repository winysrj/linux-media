Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35098 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752462AbdDIBfI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:35:08 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] [media] fsl-viu: use setup_timer
Date: Sun,  9 Apr 2017 09:34:04 +0800
Message-Id: <918f608faa071c2ff1b77d2642369555b03cb61c.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/platform/fsl-viu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index ae8c6b3..97e164b 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1466,9 +1466,8 @@ static int viu_of_probe(struct platform_device *op)
 	viu_dev->decoder = v4l2_i2c_new_subdev(&viu_dev->v4l2_dev, ad,
 			"saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
 
-	viu_dev->vidq.timeout.function = viu_vid_timeout;
-	viu_dev->vidq.timeout.data     = (unsigned long)viu_dev;
-	init_timer(&viu_dev->vidq.timeout);
+	setup_timer(&viu_dev->vidq.timeout, viu_vid_timeout,
+		    (unsigned long)viu_dev);
 	viu_dev->std = V4L2_STD_NTSC_M;
 	viu_dev->first = 1;
 
-- 
2.9.3

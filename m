Return-path: <mchehab@pedra>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:32336 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756827Ab0J0Npm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:45:42 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH] cafe_ccic: fix subdev configuration
Message-Id: <20101027134532.3E0DF9D401B@zog.reactivated.net>
Date: Wed, 27 Oct 2010 14:45:32 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

For some reason, commit 1aafeb30104a is missing one change that was
included in the email submission.

The sensor configuration must be passed down to the ov7670 subdev.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/cafe_ccic.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 8a07906..21f6f06 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2065,8 +2065,9 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		sensor_cfg.clock_speed = 45;
 
 	cam->sensor_addr = 0x42;
-	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, &cam->i2c_adapter,
-			NULL, "ov7670", cam->sensor_addr, NULL);
+	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
+			"ov7670", "ov7670", 0, &sensor_cfg, cam->sensor_addr,
+			NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
-- 
1.7.2.3


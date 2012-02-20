Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58877 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2BTSLQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 13:11:16 -0500
Received: by yhoo21 with SMTP id o21so2685292yho.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 10:11:16 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
Date: Mon, 20 Feb 2012 16:11:07 -0200
Message-Id: <1329761467-14417-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align mx3_camera driver with the other soc camera driver implementations
by allocating the camera object via kzalloc.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx3_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 7452277..cccd574 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1159,7 +1159,7 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 		goto egetres;
 	}
 
-	mx3_cam = vzalloc(sizeof(*mx3_cam));
+	mx3_cam = kzalloc(sizeof(*mx3_cam), GFP_KERNEL);
 	if (!mx3_cam) {
 		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
 		err = -ENOMEM;
-- 
1.7.1


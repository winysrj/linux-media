Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56304 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167Ab2BONdd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 08:33:33 -0500
Received: by mail-yw0-f46.google.com with SMTP id o21so610315yho.19
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2012 05:33:32 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, mchehab@infradead.org,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/3] media: video: mx2_camera.c: Provide error message if clk_get fails
Date: Wed, 15 Feb 2012 11:33:20 -0200
Message-Id: <1329312801-20501-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1329312801-20501-1-git-send-email-festevam@gmail.com>
References: <1329312801-20501-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide error message if clk_get fails.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx2_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 5888e33..689cb42 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1550,6 +1550,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk_csi)) {
+		dev_err(&pdev->dev, "Could not get csi clock\n");
 		err = PTR_ERR(pcdev->clk_csi);
 		goto exit_kfree;
 	}
-- 
1.7.1


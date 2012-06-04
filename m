Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34041 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756738Ab2FDJn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 05:43:26 -0400
From: Albert Wang <twang13@marvell.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH] [media] soc-camera: Correct icl platform data assignment
Date: Mon,  4 Jun 2012 17:43:20 +0800
Message-Id: <1338803000-26019-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch corrects icl platform data assignment

    from:
        icl->board_info->platform_data = icl;
    to:
        icl->board_info->platform_data = icd;

during init i2c device board info

Change-Id: Ia40a5ce96adbc5a1c3f3a90028e87a6fdbabc881
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/video/soc_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0421bf9..cb8b8c7 100755
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -991,7 +991,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 		goto ei2cga;
 	}
 
-	icl->board_info->platform_data = icl;
+	icl->board_info->platform_data = icd;
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
 				icl->board_info, NULL);
-- 
1.7.0.4


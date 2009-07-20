Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44122 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZGTIxw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 04:53:52 -0400
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH] v4l: DaVinci: DM646x: Update the structure name as per header file changes
Date: Mon, 20 Jul 2009 04:03:10 -0400
Message-Id: <1248076990-19143-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the platform header file, the subdev_info structure name has been changed 
to vpif_subdev_info. Update this change in the driver too.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to v4l-dvb repository.

 drivers/media/video/davinci/vpif_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 9ab2c09..5819bb8 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1424,7 +1424,7 @@ vpif_init_free_channel_objects:
  */
 static __init int vpif_probe(struct platform_device *pdev)
 {
-	const struct subdev_info *subdevdata;
+	const struct vpif_subdev_info *subdevdata;
 	int i, j = 0, k, q, m, err = 0;
 	struct i2c_adapter *i2c_adap;
 	struct vpif_config *config;
-- 
1.5.6


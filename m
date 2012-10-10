Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51529 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597Ab2JJSfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:35:16 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: mchehab@redhat.com
Cc: srinivas.kandagatla@st.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de, g.liakhovetski@gmx.de
Subject: [PATCH 3.6.0- 4/5] media/soc_camera: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:34:00 +0100
Message-Id: <1349894040-8127-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 3be9294..d4bfe29 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1585,19 +1585,7 @@ static struct platform_driver __refdata soc_camera_pdrv = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init soc_camera_init(void)
-{
-	return platform_driver_register(&soc_camera_pdrv);
-}
-
-static void __exit soc_camera_exit(void)
-{
-	platform_driver_unregister(&soc_camera_pdrv);
-}
-
-module_init(soc_camera_init);
-module_exit(soc_camera_exit);
+module_platform_driver(soc_camera_pdrv);
 
 MODULE_DESCRIPTION("Image capture bus driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
-- 
1.7.0.4


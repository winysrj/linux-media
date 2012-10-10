Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:36423 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936Ab2JJSfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:35:02 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: mchehab@redhat.com
Cc: srinivas.kandagatla@st.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de, g.liakhovetski@gmx.de
Subject: [PATCH 3.6.0- 2/5] media/m2m: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:33:46 +0100
Message-Id: <1349894026-8052-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/platform/m2m-deinterlace.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 45164c4..fcdbb27 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1108,17 +1108,5 @@ static struct platform_driver deinterlace_pdrv = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static void __exit deinterlace_exit(void)
-{
-	platform_driver_unregister(&deinterlace_pdrv);
-}
-
-static int __init deinterlace_init(void)
-{
-	return platform_driver_register(&deinterlace_pdrv);
-}
-
-module_init(deinterlace_init);
-module_exit(deinterlace_exit);
+module_platform_driver(deinterlace_pdrv);
 
-- 
1.7.0.4


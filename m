Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:40565 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab2JJSfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:35:08 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: mchehab@redhat.com
Cc: srinivas.kandagatla@st.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de, g.liakhovetski@gmx.de
Subject: [PATCH 3.6.0- 3/5] media/mx2_emmaprp: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:33:52 +0100
Message-Id: <1349894032-8085-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/platform/mx2_emmaprp.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 8f22ce5..c45a9f5 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -1013,16 +1013,4 @@ static struct platform_driver emmaprp_pdrv = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static void __exit emmaprp_exit(void)
-{
-	platform_driver_unregister(&emmaprp_pdrv);
-}
-
-static int __init emmaprp_init(void)
-{
-	return platform_driver_register(&emmaprp_pdrv);
-}
-
-module_init(emmaprp_init);
-module_exit(emmaprp_exit);
+module_platform_driver(emmaprp_pdrv);
-- 
1.7.0.4


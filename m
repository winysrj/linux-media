Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:43662 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637Ab2JJSez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:34:55 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: mchehab@redhat.com
Cc: srinivas.kandagatla@st.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de, g.liakhovetski@gmx.de
Subject: [PATCH 3.6.0- 1/5] media/bfin: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:33:38 +0100
Message-Id: <1349894018-8017-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/platform/blackfin/bfin_capture.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index cb2eb26..ec476ef 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -1050,19 +1050,7 @@ static struct platform_driver bcap_driver = {
 	.probe = bcap_probe,
 	.remove = __devexit_p(bcap_remove),
 };
-
-static __init int bcap_init(void)
-{
-	return platform_driver_register(&bcap_driver);
-}
-
-static __exit void bcap_exit(void)
-{
-	platform_driver_unregister(&bcap_driver);
-}
-
-module_init(bcap_init);
-module_exit(bcap_exit);
+module_platform_driver(bcap_driver);
 
 MODULE_DESCRIPTION("Analog Devices blackfin video capture driver");
 MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
-- 
1.7.0.4


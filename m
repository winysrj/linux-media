Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:35203 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597Ab2JJSfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:35:23 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: mchehab@redhat.com
Cc: srinivas.kandagatla@st.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de, g.liakhovetski@gmx.de
Subject: [PATCH 3.6.0- 5/5] media/ir_rx51: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:34:07 +0100
Message-Id: <1349894047-8159-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/rc/ir-rx51.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 546199e..8cfe316 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -480,18 +480,7 @@ struct platform_driver lirc_rx51_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init lirc_rx51_init(void)
-{
-	return platform_driver_register(&lirc_rx51_platform_driver);
-}
-module_init(lirc_rx51_init);
-
-static void __exit lirc_rx51_exit(void)
-{
-	platform_driver_unregister(&lirc_rx51_platform_driver);
-}
-module_exit(lirc_rx51_exit);
+module_platform_driver(lirc_rx51_platform_driver);
 
 MODULE_DESCRIPTION("LIRC TX driver for Nokia RX51");
 MODULE_AUTHOR("Nokia Corporation");
-- 
1.7.0.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:49745 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab2HVTuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 15:50:44 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 6/8] ir-rx51: Replace module_{init,exit} macros with module_platform_driver
Date: Wed, 22 Aug 2012 22:50:39 +0300
Message-Id: <1345665041-15211-7-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No reason to avoid using the existing helpers.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/ir-rx51.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 46628c0..7eed541 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -495,17 +495,7 @@ struct platform_driver lirc_rx51_platform_driver = {
 	},
 };
 
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
1.7.12


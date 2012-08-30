Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:47175 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2H3Ryf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 13:54:35 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCHv3 9/9] ir-rx51: Add missing quote mark in Kconfig text
Date: Thu, 30 Aug 2012 20:54:31 +0300
Message-Id: <1346349271-28073-10-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This trivial fix cures the following warning message:

drivers/media/rc/Kconfig:275:warning: multi-line strings not supported

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 4a68014..1300655 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -272,7 +272,7 @@ config IR_IGUANA
 	   be called iguanair.
 
 config IR_RX51
-	tristate "Nokia N900 IR transmitter diode
+	tristate "Nokia N900 IR transmitter diode"
 	depends on OMAP_DM_TIMER && LIRC
 	---help---
 	   Say Y or M here if you want to enable support for the IR
-- 
1.7.12


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:59022 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab2HXPJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 11:09:50 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCHv2 1/8] ir-rx51: Adjust dependencies
Date: Fri, 24 Aug 2012 18:09:39 +0300
Message-Id: <1345820986-4597-2-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1345820986-4597-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1345820986-4597-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although this kind of IR diode circuitry is known to exist only in
N900 hardware, nothing prevents making similar circuitry on any OMAP
based board. The MACH_NOKIA_RX51 dependency is thus not something we
want to be there.

Also, this should depend on LIRC as it is a LIRC driver.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index ffef8b4..093982b 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -273,7 +273,7 @@ config IR_IGUANA
 
 config IR_RX51
 	tristate "Nokia N900 IR transmitter diode
-	depends on MACH_NOKIA_RX51 && OMAP_DM_TIMER
+	depends on OMAP_DM_TIMER && LIRC
 	---help---
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
-- 
1.7.12


Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37039 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdJIIqw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 04:46:52 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH] media: rc: ir-spi needs OF
Date: Mon,  9 Oct 2017 09:46:50 +0100
Message-Id: <20171009084650.31129-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without device tree, there is no way to use this driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index bde3c271fb88..afb3456d4e20 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -286,6 +286,7 @@ config IR_REDRAT3
 config IR_SPI
 	tristate "SPI connected IR LED"
 	depends on SPI && LIRC
+	depends on OF || COMPILE_TEST
 	---help---
 	  Say Y if you want to use an IR LED connected through SPI bus.
 
-- 
2.13.6

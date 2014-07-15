Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbaGOBJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/18] Kconfig: sub-driver auto-select SPI bus
Date: Tue, 15 Jul 2014 04:09:13 +0300
Message-Id: <1405386561-30450-10-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mirics MSi001 and MSi2500 drivers uses SPI bus. Due to that we need
auto-select it too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3c89fcb..f60bad4 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -182,6 +182,7 @@ config MEDIA_SUBDRV_AUTOSELECT
 	depends on HAS_IOMEM
 	select I2C
 	select I2C_MUX
+	select SPI
 	default y
 	help
 	  By default, a media driver auto-selects all possible ancillary
-- 
1.9.3


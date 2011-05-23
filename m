Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23095 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab1EWAip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 20:38:45 -0400
Date: Sun, 22 May 2011 17:34:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Pelagicore AB <info@pelagicore.com>, mchehab@infradead.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] media: fix kconfig dependency warning for
 VIDEO_TIMBERDALE
Message-Id: <20110522173412.21948fba.randy.dunlap@oracle.com>
In-Reply-To: <20110520165507.cba539d5.sfr@canb.auug.org.au>
References: <20110520165507.cba539d5.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig unmet dependency warning:

warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && (MFD_TIMBERDALE || HAS_IOMEM))

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pelagicore AB <info@pelagicore.com>
---
 drivers/media/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110520.orig/drivers/media/video/Kconfig
+++ linux-next-20110520/drivers/media/video/Kconfig
@@ -683,7 +683,7 @@ config VIDEO_HEXIUM_GEMINI
 
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
-	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_V4L2 && I2C && DMADEVICES
 	select DMA_ENGINE
 	select TIMB_DMA
 	select VIDEO_ADV7180

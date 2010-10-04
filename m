Return-path: <mchehab@pedra>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48303 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab0JDBSZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Oct 2010 21:18:25 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 Oct 2010 02:18:11 +0100
Message-ID: <1286155091.3916.194.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] vivi: Don't depend on FONTS
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

CONFIG_FONTS has nothing to do with whether find_font() is defined.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f6e4d04..7528d50 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -539,7 +539,7 @@ config VIDEO_VIU
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
-	depends on (FRAMEBUFFER_CONSOLE || STI_CONSOLE) && FONTS
+	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
 	select FONT_8x16
 	select VIDEOBUF_VMALLOC
 	default n
-- 
1.7.1



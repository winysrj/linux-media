Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:51705 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaERXYT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 May 2014 19:24:19 -0400
Received: by mail-yk0-f172.google.com with SMTP id 79so3932041ykr.3
        for <linux-media@vger.kernel.org>; Sun, 18 May 2014 16:24:18 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH] solo6x10: Kconfig: Add supported card list to the SOLO6X10 knob
Date: Sun, 18 May 2014 20:23:47 -0300
Message-Id: <1400455427-10780-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 drivers/staging/media/solo6x10/Kconfig | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index 9a4296c..6a1906f 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -1,5 +1,5 @@
 config SOLO6X10
-	tristate "Softlogic 6x10 MPEG codec cards"
+	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
 	select FONT_SUPPORT
 	select FONT_8x16
@@ -8,5 +8,11 @@ config SOLO6X10
 	select SND_PCM
 	select FONT_8x16
 	---help---
-	  This driver supports the Softlogic based MPEG-4 and h.264 codec
-	  cards.
+	  This driver supports the Bluecherry H.264 and MPEG-4 hardware
+	  compression capture cards and other Softlogic-based ones.
+
+	  Following cards have been tested:
+	  * Bluecherry BC-H16480A (PCIe, 16 port, H.264)
+	  * Bluecherry BC-H04120A (PCIe, 4 port, H.264)
+	  * Bluecherry BC-H04120A-MPCI (Mini-PCI, 4 port, H.264)
+	  * Bluecherry BC-04120A (PCIe, 4 port, MPEG-4)
-- 
1.9.1


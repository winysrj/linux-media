Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57376 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab2ADDmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 22:42:22 -0500
Received: by ggdk6 with SMTP id k6so10130340ggd.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 19:42:21 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: media: radio: Fix dependencies for RADIO_WL128X
Date: Wed,  4 Jan 2012 01:42:04 -0200
Message-Id: <1325648524-24665-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build warning:

warning: (RADIO_WL128X) selects TI_ST which has unmet direct dependencies (MISC_DEVICES && NET && GPIOLIB)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/radio/wl128x/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index 749f67b..86b2857 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -5,7 +5,7 @@ menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
 	depends on VIDEO_V4L2 && RFKILL
-	select TI_ST
+	select TI_ST if NET && GPIOLIB
 	help
 	Choose Y here if you have this FM radio chip.
 
-- 
1.7.1


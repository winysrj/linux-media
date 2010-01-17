Return-path: <linux-media-owner@vger.kernel.org>
Received: from av9-1-sn2.hy.skanova.net ([81.228.8.179]:49090 "EHLO
	av9-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0AQPlj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 10:41:39 -0500
Date: Sun, 17 Jan 2010 16:06:48 +0100
From: Oskar =?iso-8859-1?Q?Ander=F6?= <oskar.andero@cobwebtech.se>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fixed tm6000 broken build
Message-ID: <20100117150648.GA31251@andero.no-ip.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Just bought a HVR-900H (0x2040, 0x6600). This patch fixes the broken build
of the tm6000 driver. It was tested with kernel 2.6.30.
However, the kernel panics when I try to access the device. I will try
to get the time to analyze it further.

Regards,
 Oskar Anderö

Signed-off-by: Oskar Anderö <oskar.andero@cobwebtech.se>
---
diff -r 3a4be7d7dabd linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun Jan 03 17:04:42 2010 +0000
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Wed Jan 13 20:54:09 2010 +0100
@@ -33,7 +33,6 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 #include "tuner-xc2028.h"
-#include "tuner-xc5000.h"
 
 #define TM6000_BOARD_UNKNOWN			0
 #define TM5600_BOARD_GENERIC			1
@@ -45,6 +44,8 @@
 #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
 #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
 #define TM6010_BOARD_HAUPPAUGE_900H		9
+#define TM6010_BOARD_BEHOLD_WANDER		10
+#define TM6010_BOARD_BEHOLD_VOYAGER		11
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };

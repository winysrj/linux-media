Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56369 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab3EHV5V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 17:57:21 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MQKkE-1UzST535EC-00Tl6z for
 <linux-media@vger.kernel.org>; Wed, 08 May 2013 23:57:19 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH 2/2] stb0899: remove commented value from IQ_SWAP_ON/OFF usages
Date: Wed,  8 May 2013 23:54:57 +0200
Message-Id: <1368050097-6079-2-git-send-email-rnissl@gmx.de>
In-Reply-To: <1368050097-6079-1-git-send-email-rnissl@gmx.de>
References: <1368050097-6079-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the enum values have changed recently, the comments are void.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/pci/mantis/mantis_vp1041.c | 2 +-
 drivers/media/pci/ttpci/budget-av.c      | 2 +-
 drivers/media/pci/ttpci/budget-ci.c      | 2 +-
 drivers/media/usb/dvb-usb/az6027.c       | 2 +-
 drivers/media/usb/dvb-usb/pctv452e.c     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_vp1041.c b/drivers/media/pci/mantis/mantis_vp1041.c
index 07aa887..07a2074 100644
--- a/drivers/media/pci/mantis/mantis_vp1041.c
+++ b/drivers/media/pci/mantis/mantis_vp1041.c
@@ -273,7 +273,7 @@ struct stb0899_config vp1041_stb0899_config = {
 	.demod_address 		= 0x68, /*  0xd0 >> 1 */
 
 	.xtal_freq		= 27000000,
-	.inversion		= IQ_SWAP_ON, /* 1 */
+	.inversion		= IQ_SWAP_ON,
 
 	.lo_clk			= 76500000,
 	.hi_clk			= 99000000,
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 1f8b1bb..0ba3875 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -1128,7 +1128,7 @@ static struct stb0899_config knc1_dvbs2_config = {
 //	.ts_pfbit_toggle	= STB0899_MPEG_NORMAL,	/* DirecTV, MPEG toggling seq	*/
 
 	.xtal_freq		= 27000000,
-	.inversion		= IQ_SWAP_OFF, /* 1 */
+	.inversion		= IQ_SWAP_OFF,
 
 	.lo_clk			= 76500000,
 	.hi_clk			= 90000000,
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 98e5241..0acf920 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -1280,7 +1280,7 @@ static struct stb0899_config tt3200_config = {
 	.demod_address 		= 0x68,
 
 	.xtal_freq		= 27000000,
-	.inversion		= IQ_SWAP_ON, /* 1 */
+	.inversion		= IQ_SWAP_ON,
 
 	.lo_clk			= 76500000,
 	.hi_clk			= 99000000,
diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index 91e0119..ea2d5ee 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -264,7 +264,7 @@ struct stb0899_config az6027_stb0899_config = {
 	.demod_address 		= 0xd0, /* 0x68, 0xd0 >> 1 */
 
 	.xtal_freq		= 27000000,
-	.inversion		= IQ_SWAP_ON, /* 1 */
+	.inversion		= IQ_SWAP_ON,
 
 	.lo_clk			= 76500000,
 	.hi_clk			= 99000000,
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index d1ddfa1..449a996 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -828,7 +828,7 @@ static struct stb0899_config stb0899_config = {
 	.block_sync_mode = STB0899_SYNC_FORCED, /* ? */
 
 	.xtal_freq       = 27000000,	 /* Assume Hz ? */
-	.inversion       = IQ_SWAP_ON,       /* ? */
+	.inversion       = IQ_SWAP_ON,
 
 	.lo_clk	  = 76500000,
 	.hi_clk	  = 99000000,
-- 
1.8.1.4


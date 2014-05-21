Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 7/8] xc5000: Don't use whitespace before tabs
Date: Wed, 21 May 2014 15:20:01 -0300
Message-Id: <1400696402-1805-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARNING: please, no space before tabs
+#define XC_PRODUCT_ID_FW_LOADED ^I0x1388$

WARNING: please, no space before tabs
+#define DK_SECAM_A2LDK3 ^I13$

WARNING: please, no space before tabs
+#define DK_SECAM_A2MONO ^I14$

WARNING: please, no space before tabs
+#define FM_RADIO_INPUT2 ^I21$

WARNING: please, no space before tabs
+#define FM_RADIO_INPUT1 ^I22$

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index da4c29ed48bd..8df92619883f 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -77,7 +77,7 @@ struct xc5000_priv {
 
 /* Product id */
 #define XC_PRODUCT_ID_FW_NOT_LOADED	0x2000
-#define XC_PRODUCT_ID_FW_LOADED 	0x1388
+#define XC_PRODUCT_ID_FW_LOADED	0x1388
 
 /* Registers */
 #define XREG_INIT         0x00
@@ -164,16 +164,16 @@ struct XC_TV_STANDARD {
 #define DK_PAL_NICAM		10
 #define DK_PAL_MONO		11
 #define DK_SECAM_A2DK1		12
-#define DK_SECAM_A2LDK3 	13
-#define DK_SECAM_A2MONO 	14
+#define DK_SECAM_A2LDK3		13
+#define DK_SECAM_A2MONO		14
 #define L_SECAM_NICAM		15
 #define LC_SECAM_NICAM		16
 #define DTV6			17
 #define DTV8			18
 #define DTV7_8			19
 #define DTV7			20
-#define FM_RADIO_INPUT2 	21
-#define FM_RADIO_INPUT1 	22
+#define FM_RADIO_INPUT2		21
+#define FM_RADIO_INPUT1		22
 #define FM_RADIO_INPUT1_MONO	23
 
 static struct XC_TV_STANDARD xc5000_standard[MAX_TV_STANDARD] = {
-- 
1.9.0


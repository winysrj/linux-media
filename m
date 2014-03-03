Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaCCLLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 06:11:33 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 23/79] [media] drx-j: a few more CodingStyle fixups
Date: Mon,  3 Mar 2014 07:06:17 -0300
Message-Id: <1393841233-24840-24-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some whitespace cleanups.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index af894b9f5b0d..1b55bb5c8df2 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -99,7 +99,7 @@ DEFINES
 /*=== MACROS =================================================================*/
 /*============================================================================*/
 
-#define DRX_ISPOWERDOWNMODE(mode) (( mode == DRX_POWER_MODE_9) || \
+#define DRX_ISPOWERDOWNMODE(mode) ((mode == DRX_POWER_MODE_9) || \
 				       (mode == DRX_POWER_MODE_10) || \
 				       (mode == DRX_POWER_MODE_11) || \
 				       (mode == DRX_POWER_MODE_12) || \
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 14a87caa6842..bb67edeb5121 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -570,7 +570,7 @@ DEFINES
 /*=== STANDARD RELATED MACROS ================================================*/
 /*============================================================================*/
 
-#define DRXJ_ISATVSTD(std) (( std == DRX_STANDARD_PAL_SECAM_BG) || \
+#define DRXJ_ISATVSTD(std) ((std == DRX_STANDARD_PAL_SECAM_BG) || \
 			       (std == DRX_STANDARD_PAL_SECAM_DK) || \
 			       (std == DRX_STANDARD_PAL_SECAM_I) || \
 			       (std == DRX_STANDARD_PAL_SECAM_L) || \
@@ -578,7 +578,7 @@ DEFINES
 			       (std == DRX_STANDARD_NTSC) || \
 			       (std == DRX_STANDARD_FM))
 
-#define DRXJ_ISQAMSTD(std) (( std == DRX_STANDARD_ITU_A) || \
+#define DRXJ_ISQAMSTD(std) ((std == DRX_STANDARD_ITU_A) || \
 			       (std == DRX_STANDARD_ITU_B) || \
 			       (std == DRX_STANDARD_ITU_C) || \
 			       (std == DRX_STANDARD_ITU_D))
-- 
1.8.5.3


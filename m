Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46233 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 09/16] [media] dvb-core/dvb_ca_en50221.c: Removed unused symbol
Date: Sun, 16 Jul 2017 02:43:10 +0200
Message-Id: <1500165797-16987-10-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

- The STATUSREG_TXERR definition is not used and it has style
  problems, too.  Removing it seems to solve both issues.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index ce22bdb..6547f6e 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -76,8 +76,6 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 #define STATUSREG_WE     2	/* write error */
 #define STATUSREG_FR  0x40	/* module free */
 #define STATUSREG_DA  0x80	/* data available */
-#define STATUSREG_TXERR (STATUSREG_RE|STATUSREG_WE)	/* general transfer error */
-
 
 #define DVB_CA_SLOTSTATE_NONE           0
 #define DVB_CA_SLOTSTATE_UNINITIALISED  1
-- 
2.7.4

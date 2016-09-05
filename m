Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55037 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933086AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH v2 11/12] [media] tda18271: use prefix on all printk messages
Date: Mon,  5 Sep 2016 07:32:39 -0300
Message-Id: <a45df59548c13f3a3d3d9fd95b6e88434dc114ef.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some messages have a hardcoded prefix; others not. Use the
pr_fmt() to ensure that all messages will use the same prefix.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/tda18271-fe.c   | 11 ++++++-----
 drivers/media/tuners/tda18271-priv.h |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index f8620741bb5f..2d50e8b1dce1 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -18,11 +18,12 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/delay.h>
-#include <linux/videodev2.h>
 #include "tda18271-priv.h"
 #include "tda8290.h"
 
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+
 int tda18271_debug;
 module_param_named(debug, tda18271_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level "
@@ -646,7 +647,7 @@ static int tda18271_calc_rf_filter_curve(struct dvb_frontend *fe)
 	unsigned int i;
 	int ret;
 
-	tda_info("tda18271: performing RF tracking filter calibration\n");
+	tda_info("performing RF tracking filter calibration\n");
 
 	/* wait for die temperature stabilization */
 	msleep(200);
@@ -692,12 +693,12 @@ static int tda18271c2_rf_cal_init(struct dvb_frontend *fe)
 	if (tda_fail(ret))
 		goto fail;
 
-	tda_info("tda18271: RF tracking filter calibration complete\n");
+	tda_info("RF tracking filter calibration complete\n");
 
 	priv->cal_initialized = true;
 	goto end;
 fail:
-	tda_info("tda18271: RF tracking filter calibration failed!\n");
+	tda_info("RF tracking filter calibration failed!\n");
 end:
 	return ret;
 }
diff --git a/drivers/media/tuners/tda18271-priv.h b/drivers/media/tuners/tda18271-priv.h
index cc80f544af34..0bcc735a0427 100644
--- a/drivers/media/tuners/tda18271-priv.h
+++ b/drivers/media/tuners/tda18271-priv.h
@@ -21,6 +21,8 @@
 #ifndef __TDA18271_PRIV_H__
 #define __TDA18271_PRIV_H__
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
-- 
2.7.4



Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:53948 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753486AbaIVSAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 14:00:05 -0400
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave07.hostedemail.com (Postfix) with ESMTP id C77F211A262
	for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 17:50:48 +0000 (UTC)
Message-ID: <1411408235.2952.52.camel@joe-AO725>
Subject: [PATCH] [media] tda18271-common: Convert _tda_printk to return void
From: Joe Perches <joe@perches.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Sep 2014 10:50:35 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No caller or macro uses the return value so make it void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/media/tuners/tda18271-common.c | 19 ++++++++-----------
 drivers/media/tuners/tda18271-priv.h   |  4 ++--
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index 18c77af..86e5e31 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -714,12 +714,11 @@ fail:
 	return ret;
 }
 
-int _tda_printk(struct tda18271_priv *state, const char *level,
-		const char *func, const char *fmt, ...)
+void _tda_printk(struct tda18271_priv *state, const char *level,
+		 const char *func, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int rtn;
 
 	va_start(args, fmt);
 
@@ -727,15 +726,13 @@ int _tda_printk(struct tda18271_priv *state, const char *level,
 	vaf.va = &args;
 
 	if (state)
-		rtn = printk("%s%s: [%d-%04x|%c] %pV",
-			     level, func, i2c_adapter_id(state->i2c_props.adap),
-			     state->i2c_props.addr,
-			     (state->role == TDA18271_MASTER) ? 'M' : 'S',
-			     &vaf);
+		printk("%s%s: [%d-%04x|%c] %pV",
+		       level, func, i2c_adapter_id(state->i2c_props.adap),
+		       state->i2c_props.addr,
+		       (state->role == TDA18271_MASTER) ? 'M' : 'S',
+		       &vaf);
 	else
-		rtn = printk("%s%s: %pV", level, func, &vaf);
+		printk("%s%s: %pV", level, func, &vaf);
 
 	va_end(args);
-
-	return rtn;
 }
diff --git a/drivers/media/tuners/tda18271-priv.h b/drivers/media/tuners/tda18271-priv.h
index 454c152..b36a7b7 100644
--- a/drivers/media/tuners/tda18271-priv.h
+++ b/drivers/media/tuners/tda18271-priv.h
@@ -139,8 +139,8 @@ extern int tda18271_debug;
 #define DBG_CAL  16
 
 __attribute__((format(printf, 4, 5)))
-int _tda_printk(struct tda18271_priv *state, const char *level,
-		const char *func, const char *fmt, ...);
+void _tda_printk(struct tda18271_priv *state, const char *level,
+		 const char *func, const char *fmt, ...);
 
 #define tda_printk(st, lvl, fmt, arg...)			\
 	_tda_printk(st, lvl, __func__, fmt, ##arg)



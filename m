Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38710 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 20/41] it913x: include tuner IDs from af9033.h
Date: Sun, 10 Mar 2013 04:03:12 +0200
Message-Id: <1362881013-5271-20-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c      | 24 ++++++++++++------------
 drivers/media/tuners/it913x_priv.h | 10 +---------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 6ae9d5a..1cb9709 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -156,22 +156,22 @@ static int it913x_init(struct dvb_frontend *fe)
 
 	/* LNA Scripts */
 	switch (state->tuner_type) {
-	case IT9135_51:
+	case AF9033_TUNER_IT9135_51:
 		set_lna = it9135_51;
 		break;
-	case IT9135_52:
+	case AF9033_TUNER_IT9135_52:
 		set_lna = it9135_52;
 		break;
-	case IT9135_60:
+	case AF9033_TUNER_IT9135_60:
 		set_lna = it9135_60;
 		break;
-	case IT9135_61:
+	case AF9033_TUNER_IT9135_61:
 		set_lna = it9135_61;
 		break;
-	case IT9135_62:
+	case AF9033_TUNER_IT9135_62:
 		set_lna = it9135_62;
 		break;
-	case IT9135_38:
+	case AF9033_TUNER_IT9135_38:
 	default:
 		set_lna = it9135_38;
 	}
@@ -444,14 +444,14 @@ struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 	state->i2c_addr = i2c_addr;
 
 	switch (config) {
-	case IT9135_38:
-	case IT9135_51:
-	case IT9135_52:
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
 		state->chip_ver = 0x01;
 		break;
-	case IT9135_60:
-	case IT9135_61:
-	case IT9135_62:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
 		state->chip_ver = 0x02;
 		break;
 	default:
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index 315ff6c..1491bf8 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -24,15 +24,7 @@
 #define IT913X_PRIV_H
 
 #include "it913x.h"
-
-/* Build in tuner types */
-#define IT9137 0x38
-#define IT9135_38 0x38
-#define IT9135_51 0x51
-#define IT9135_52 0x52
-#define IT9135_60 0x60
-#define IT9135_61 0x61
-#define IT9135_62 0x62
+#include "af9033.h"
 
 #define PRO_LINK		0x0
 #define PRO_DMOD		0x1
-- 
1.7.11.7


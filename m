Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39240 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab2ILC1m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:42 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/8] rtl2832: remove redundant function declaration
Date: Wed, 12 Sep 2012 05:27:05 +0300
Message-Id: <1347416831-1413-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 5da0cc4..270fd1e 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -58,10 +58,6 @@ extern struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c
 );
-
-extern struct i2c_adapter *rtl2832_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-);
 #else
 static inline struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *config,
-- 
1.7.11.4


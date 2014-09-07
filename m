Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49865 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaIGCAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 22:00:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 2/8] tda18212: prepare for I2C client conversion
Date: Sun,  7 Sep 2014 04:59:54 +0300
Message-Id: <1410055200-32170-2-git-send-email-crope@iki.fi>
In-Reply-To: <1410055200-32170-1-git-send-email-crope@iki.fi>
References: <1410055200-32170-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need carry pointer to frontend via config struct
(I2C platform_data ptr) when I2C model is used. Add that pointer
first in order to keep build unbreakable during conversion.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18212.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
index c36b49e..265559a 100644
--- a/drivers/media/tuners/tda18212.h
+++ b/drivers/media/tuners/tda18212.h
@@ -37,6 +37,11 @@ struct tda18212_config {
 	u16 if_dvbc;
 	u16 if_atsc_vsb;
 	u16 if_atsc_qam;
+
+	/*
+	 * pointer to DVB frontend
+	 */
+	struct dvb_frontend *fe;
 };
 
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18212)
-- 
http://palosaari.fi/


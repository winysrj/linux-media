Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58438 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3J3FlS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 01:41:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] rtl2832: add new tuner R828D
Date: Wed, 30 Oct 2013 07:40:34 +0200
Message-Id: <1383111636-19743-2-git-send-email-crope@iki.fi>
In-Reply-To: <1383111636-19743-1-git-send-email-crope@iki.fi>
References: <1383111636-19743-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use R820T config for R828D too as those are about same tuner.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 1 +
 drivers/media/dvb-frontends/rtl2832.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index facb848..a95dfe0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -489,6 +489,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		init = rtl2832_tuner_init_e4000;
 		break;
 	case RTL2832_TUNER_R820T:
+	case RTL2832_TUNER_R828D:
 		len = ARRAY_SIZE(rtl2832_tuner_init_r820t);
 		init = rtl2832_tuner_init_r820t;
 		break;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 91b2dcf..2cfbb6a 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -53,6 +53,7 @@ struct rtl2832_config {
 #define RTL2832_TUNER_E4000     0x27
 #define RTL2832_TUNER_FC0013    0x29
 #define RTL2832_TUNER_R820T	0x2a
+#define RTL2832_TUNER_R828D	0x2b
 	u8 tuner;
 };
 
-- 
1.8.3.1


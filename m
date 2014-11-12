Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48020 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbaKLEX2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/8] rtl28xxu: remove unused SDR attach logic
Date: Wed, 12 Nov 2014 06:23:09 +0200
Message-Id: <1415766190-24482-8-git-send-email-crope@iki.fi>
In-Reply-To: <1415766190-24482-1-git-send-email-crope@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That logic was duplicated from rtl2832_sdr.h in order to avoid hard
dependency for staging directory. rtl2832_sdr is moved to media, so
we could remove that code now.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 47360d3..eadde72 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,6 +24,7 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
+#include "rtl2832_sdr.h"
 #include "mn88472.h"
 #include "mn88473.h"
 
@@ -37,25 +38,6 @@
 #include "tua9001.h"
 #include "r820t.h"
 
-/*
- * RTL2832_SDR module is in staging. That logic is added in order to avoid any
- * hard dependency to drivers/staging/ directory as we want compile mainline
- * driver even whole staging directory is missing.
- */
-#include <media/v4l2-subdev.h>
-
-#if IS_ENABLED(CONFIG_DVB_RTL2832_SDR)
-struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
-	struct v4l2_subdev *sd);
-#else
-static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
-	struct v4l2_subdev *sd)
-{
-	return NULL;
-}
-#endif
 
 #ifdef CONFIG_MEDIA_ATTACH
 #define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
-- 
http://palosaari.fi/


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50217 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3L3NhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 08:37:03 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so5108992eak.11
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 05:37:01 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] xc2028: disable device power-down because power state handling is broken
Date: Mon, 30 Dec 2013 14:37:58 +0100
Message-Id: <1388410678-12641-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

xc2028 power state handling is broken.
I2C read/write operations fail when the device is powered down at that moment,
which causes the get_rf_strength and get_rf_strength callbacks (and probably
others, too) to fail.
I don't know how to fix this properly, so disable the device power-down until
anyone comes up with a better solution.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/tuners/tuner-xc2028.c |    4 +++-
 1 Datei geändert, 3 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 4be5cf8..cb3dc5e 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1291,16 +1291,18 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 		dump_stack();
 	}
 
+	/* FIXME: device power-up/-down handling is broken */
+/*
 	mutex_lock(&priv->lock);
 
 	if (priv->firm_version < 0x0202)
 		rc = send_seq(priv, {0x00, XREG_POWER_DOWN, 0x00, 0x00});
 	else
 		rc = send_seq(priv, {0x80, XREG_POWER_DOWN, 0x00, 0x00});
-
 	priv->state = XC2028_SLEEP;
 
 	mutex_unlock(&priv->lock);
+*/
 
 	return rc;
 }
-- 
1.7.10.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42321 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933988AbaKLELg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/11] mn88472: correct attach symbol name
Date: Wed, 12 Nov 2014 06:11:08 +0200
Message-Id: <1415765477-23153-3-git-send-email-crope@iki.fi>
In-Reply-To: <1415765477-23153-1-git-send-email-crope@iki.fi>
References: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wrong symbol name causes demod attach failure.

Reported-by: Benjamin Larsson <benjamin@southpole.se>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.h b/drivers/media/dvb-frontends/mn88472.h
index 29aa485..c817bfb 100644
--- a/drivers/media/dvb-frontends/mn88472.h
+++ b/drivers/media/dvb-frontends/mn88472.h
@@ -28,12 +28,12 @@ struct mn88472_c_config {
 };
 
 #if IS_ENABLED(CONFIG_DVB_MN88472)
-extern struct dvb_frontend *mn88472_c_attach(
+extern struct dvb_frontend *mn88472_attach_c(
 	const struct mn88472_c_config *cfg,
 	struct i2c_adapter *i2c
 );
 #else
-static inline struct dvb_frontend *mn88472_c_attach(
+static inline struct dvb_frontend *mn88472_attach_c(
 	const struct mn88472_c_config *cfg,
 	struct i2c_adapter *i2c
 )
-- 
http://palosaari.fi/


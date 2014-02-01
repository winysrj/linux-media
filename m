Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37610 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaBAUog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 15:44:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Robert Schlabbach <Robert.Schlabbach@gmx.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] m88ds3103: remove dead code
Date: Sat,  1 Feb 2014 22:44:15 +0200
Message-Id: <1391287458-11939-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity CID 1166050: Dead default in switch (DEADCODE)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index b8a7897..e261bf9 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -711,9 +711,6 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 		case 1:
 			c->inversion = INVERSION_ON;
 			break;
-		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid inversion\n",
-					__func__);
 		}
 
 		switch ((buf[1] >> 5) & 0x07) {
@@ -793,9 +790,6 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 		case 1:
 			c->pilot = PILOT_ON;
 			break;
-		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid pilot\n",
-					__func__);
 		}
 
 		switch ((buf[0] >> 6) & 0x07) {
@@ -823,9 +817,6 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 		case 1:
 			c->inversion = INVERSION_ON;
 			break;
-		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid inversion\n",
-					__func__);
 		}
 
 		switch ((buf[2] >> 0) & 0x03) {
-- 
1.8.5.3


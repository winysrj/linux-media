Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41062 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab2IVQwk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 12:52:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 1/5] fc2580: small improvements for chip id check
Date: Sat, 22 Sep 2012 19:51:36 +0300
Message-Id: <1348332700-10267-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* better readability
* make checkpatch.pl happy
* few bytes smaller binary footprint

Cc: Oliver Schinagl <oliver@schinagl.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 51bc39c..7db32ec 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -498,7 +498,11 @@ struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
 
 	dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
 
-	if ((chip_id != 0x56) && (chip_id != 0x5a)) {
+	switch (chip_id) {
+	case 0x56:
+	case 0x5a:
+		break;
+	default:
 		goto err;
 	}
 
-- 
1.7.11.4


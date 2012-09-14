Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:47999 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab2INJ1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 05:27:42 -0400
From: =?UTF-8?q?R=C3=A9mi=20Cardona?= <remi.cardona@smartjog.com>
To: linux-media@vger.kernel.org
Cc: liplianin@me.by
Subject: [PATCH 3/6] [media] ds3000: properly report register read errors
Date: Fri, 14 Sep 2012 11:27:23 +0200
Message-Id: <1347614846-19046-4-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This brings both ds3000_readreg() and ds3000_tuner_readreg() in line
with ds3000_writereg() and ds3000_tuner_writereg() respectively.

Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
---
 drivers/media/dvb/frontends/ds3000.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 474f26e..6752222 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -340,7 +340,7 @@ static int ds3000_readreg(struct ds3000_state *state, u8 reg)
 
 	if (ret != 2) {
 		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
-		return ret;
+		return -EREMOTEIO;
 	}
 
 	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
@@ -367,12 +367,15 @@ static int ds3000_tuner_readreg(struct ds3000_state *state, u8 reg)
 		}
 	};
 
-	ds3000_writereg(state, 0x03, 0x12);
-	ret = i2c_transfer(state->i2c, msg, 2);
+	ret = ds3000_writereg(state, 0x03, 0x12);
+	if (ret < 0) {
+		return -EREMOTEIO;
+	}
 
+	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
 		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
-		return ret;
+		return -EREMOTEIO;
 	}
 
 	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
-- 
1.7.10.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIXXiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:38:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] [media] dvb-frontends: use %zu instead of %zd
Date: Wed, 24 Sep 2014 20:37:42 -0300
Message-Id: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

size_t is unsigned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 998d15031461..638c7aa0fb7e 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -639,7 +639,7 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 		err("could not load firmware (%s): %d",BCM3510_DEFAULT_FIRMWARE,ret);
 		return ret;
 	}
-	deb_info("got firmware: %zd\n",fw->size);
+	deb_info("got firmware: %zu\n", fw->size);
 
 	b = fw->data;
 	for (i = 0; i < fw->size;) {
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index a74ac0ddb833..2163490c1e6b 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -103,7 +103,7 @@ static int mt312_write(struct mt312_state *state, const enum mt312_reg_addr reg,
 
 	if (1 + count > sizeof(buf)) {
 		printk(KERN_WARNING
-		       "mt312: write: len=%zd is too big!\n", count);
+		       "mt312: write: len=%zu is too big!\n", count);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index 10cfc0579168..873ea1da844b 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -111,7 +111,7 @@ static int or51211_load_firmware (struct dvb_frontend* fe,
 	u8 tudata[585];
 	int i;
 
-	dprintk("Firmware is %zd bytes\n",fw->size);
+	dprintk("Firmware is %zu bytes\n", fw->size);
 
 	/* Get eprom data */
 	tudata[0] = 17;
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index 91b6b2e9b792..ee09ec26c553 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -111,7 +111,7 @@ static int zl10039_write(struct zl10039_state *state,
 
 	if (1 + count > sizeof(buf)) {
 		printk(KERN_WARNING
-		       "%s: i2c wr reg=%04x: len=%zd is too big!\n",
+		       "%s: i2c wr reg=%04x: len=%zu is too big!\n",
 		       KBUILD_MODNAME, reg, count);
 		return -EINVAL;
 	}
-- 
1.9.3


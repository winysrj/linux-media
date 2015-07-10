Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61460 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbbGJGT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:19:56 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/7] [media] dvb-frontends: Drop owner assignment from
 i2c_driver
Date: Fri, 10 Jul 2015 15:19:42 +0900
Message-id: <1436509188-23320-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1436509188-23320-1-git-send-email-k.kozlowski@samsung.com>
References: <1436509188-23320-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_driver does not need to set an owner because i2c_register_driver()
will set it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

The coccinelle script which generated the patch was sent here:
http://www.spinics.net/lists/kernel/msg2029903.html
---
 drivers/media/dvb-frontends/a8293.c          | 1 -
 drivers/media/dvb-frontends/af9033.c         | 1 -
 drivers/media/dvb-frontends/au8522_decoder.c | 1 -
 drivers/media/dvb-frontends/m88ds3103.c      | 1 -
 drivers/media/dvb-frontends/rtl2830.c        | 1 -
 drivers/media/dvb-frontends/rtl2832.c        | 1 -
 drivers/media/dvb-frontends/si2168.c         | 1 -
 drivers/media/dvb-frontends/sp2.c            | 1 -
 drivers/media/dvb-frontends/tda10071.c       | 1 -
 drivers/media/dvb-frontends/ts2020.c         | 1 -
 10 files changed, 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
index 97ecbe01034c..df3c9758a903 100644
--- a/drivers/media/dvb-frontends/a8293.c
+++ b/drivers/media/dvb-frontends/a8293.c
@@ -234,7 +234,6 @@ MODULE_DEVICE_TABLE(i2c, a8293_id_table);
 
 static struct i2c_driver a8293_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "a8293",
 		.suppress_bind_attrs = true,
 	},
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 59018afaa95f..bc35206a0821 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1387,7 +1387,6 @@ MODULE_DEVICE_TABLE(i2c, af9033_id_table);
 
 static struct i2c_driver af9033_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "af9033",
 	},
 	.probe		= af9033_probe,
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 33aa9410b624..28d7dc2fee34 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -820,7 +820,6 @@ MODULE_DEVICE_TABLE(i2c, au8522_id);
 
 static struct i2c_driver au8522_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "au8522",
 	},
 	.probe		= au8522_probe,
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e9b2d2b69b1d..ff31e7a01ca9 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1495,7 +1495,6 @@ MODULE_DEVICE_TABLE(i2c, m88ds3103_id_table);
 
 static struct i2c_driver m88ds3103_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "m88ds3103",
 		.suppress_bind_attrs = true,
 	},
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 3d01f4f22aca..b792f305cf15 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -915,7 +915,6 @@ MODULE_DEVICE_TABLE(i2c, rtl2830_id_table);
 
 static struct i2c_driver rtl2830_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "rtl2830",
 	},
 	.probe		= rtl2830_probe,
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 822ea4b7a7ff..78b87b260d74 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1319,7 +1319,6 @@ MODULE_DEVICE_TABLE(i2c, rtl2832_id_table);
 
 static struct i2c_driver rtl2832_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "rtl2832",
 	},
 	.probe		= rtl2832_probe,
diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 25e238c370e5..81788c5a44d8 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -757,7 +757,6 @@ MODULE_DEVICE_TABLE(i2c, si2168_id_table);
 
 static struct i2c_driver si2168_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "si2168",
 	},
 	.probe		= si2168_probe,
diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
index 8fd42767e263..43d47dfcc7b8 100644
--- a/drivers/media/dvb-frontends/sp2.c
+++ b/drivers/media/dvb-frontends/sp2.c
@@ -426,7 +426,6 @@ MODULE_DEVICE_TABLE(i2c, sp2_id);
 
 static struct i2c_driver sp2_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "sp2",
 	},
 	.probe		= sp2_probe,
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index f6dc6307d35a..2b7d6ca69945 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1409,7 +1409,6 @@ MODULE_DEVICE_TABLE(i2c, tda10071_id_table);
 
 static struct i2c_driver tda10071_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tda10071",
 		.suppress_bind_attrs = true,
 	},
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index f61b143a0052..7979e5d6498b 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -726,7 +726,6 @@ MODULE_DEVICE_TABLE(i2c, ts2020_id_table);
 
 static struct i2c_driver ts2020_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "ts2020",
 	},
 	.probe		= ts2020_probe,
-- 
1.9.1


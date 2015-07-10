Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59573 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbGJGUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:20:04 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/7] [media] i2c: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:19:44 +0900
Message-id: <1436509188-23320-4-git-send-email-k.kozlowski@samsung.com>
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
 drivers/media/i2c/adv7170.c              | 1 -
 drivers/media/i2c/adv7175.c              | 1 -
 drivers/media/i2c/adv7180.c              | 1 -
 drivers/media/i2c/adv7343.c              | 1 -
 drivers/media/i2c/adv7511.c              | 1 -
 drivers/media/i2c/adv7604.c              | 1 -
 drivers/media/i2c/adv7842.c              | 1 -
 drivers/media/i2c/bt819.c                | 1 -
 drivers/media/i2c/bt856.c                | 1 -
 drivers/media/i2c/bt866.c                | 1 -
 drivers/media/i2c/cs5345.c               | 1 -
 drivers/media/i2c/cs53l32a.c             | 1 -
 drivers/media/i2c/cx25840/cx25840-core.c | 1 -
 drivers/media/i2c/ks0127.c               | 1 -
 drivers/media/i2c/m52790.c               | 1 -
 drivers/media/i2c/msp3400-driver.c       | 1 -
 drivers/media/i2c/mt9v011.c              | 1 -
 drivers/media/i2c/ov7640.c               | 1 -
 drivers/media/i2c/ov7670.c               | 1 -
 drivers/media/i2c/saa6588.c              | 1 -
 drivers/media/i2c/saa6752hs.c            | 1 -
 drivers/media/i2c/saa7110.c              | 1 -
 drivers/media/i2c/saa7115.c              | 1 -
 drivers/media/i2c/saa7127.c              | 1 -
 drivers/media/i2c/saa717x.c              | 1 -
 drivers/media/i2c/saa7185.c              | 1 -
 drivers/media/i2c/sony-btf-mpx.c         | 1 -
 drivers/media/i2c/tda7432.c              | 1 -
 drivers/media/i2c/tda9840.c              | 1 -
 drivers/media/i2c/tea6415c.c             | 1 -
 drivers/media/i2c/tea6420.c              | 1 -
 drivers/media/i2c/ths7303.c              | 1 -
 drivers/media/i2c/tvaudio.c              | 1 -
 drivers/media/i2c/tvp5150.c              | 1 -
 drivers/media/i2c/tw9903.c               | 1 -
 drivers/media/i2c/tw9906.c               | 1 -
 drivers/media/i2c/upd64031a.c            | 1 -
 drivers/media/i2c/upd64083.c             | 1 -
 drivers/media/i2c/vp27smpx.c             | 1 -
 drivers/media/i2c/vpx3220.c              | 1 -
 drivers/media/i2c/wm8739.c               | 1 -
 drivers/media/i2c/wm8775.c               | 1 -
 42 files changed, 42 deletions(-)

diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index f0d3f5a2da46..05f1dc6c72af 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -401,7 +401,6 @@ MODULE_DEVICE_TABLE(i2c, adv7170_id);
 
 static struct i2c_driver adv7170_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "adv7170",
 	},
 	.probe		= adv7170_probe,
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index 321834ba8f57..f554809a51e7 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -455,7 +455,6 @@ MODULE_DEVICE_TABLE(i2c, adv7175_id);
 
 static struct i2c_driver adv7175_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "adv7175",
 	},
 	.probe		= adv7175_probe,
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index a493c0b0b5fe..db4a09ac1cea 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1326,7 +1326,6 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 
 static struct i2c_driver adv7180_driver = {
 	.driver = {
-		   .owner = THIS_MODULE,
 		   .name = KBUILD_MODNAME,
 		   .pm = ADV7180_PM_OPS,
 		   },
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 7c50833e7d17..5f7a3bfcb905 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -529,7 +529,6 @@ MODULE_DEVICE_TABLE(of, adv7343_of_match);
 static struct i2c_driver adv7343_driver = {
 	.driver = {
 		.of_match_table = of_match_ptr(adv7343_of_match),
-		.owner	= THIS_MODULE,
 		.name	= "adv7343",
 	},
 	.probe		= adv7343_probe,
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 95bcd4026451..ef198cee8969 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1576,7 +1576,6 @@ MODULE_DEVICE_TABLE(i2c, adv7511_id);
 
 static struct i2c_driver adv7511_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "adv7511",
 	},
 	.probe = adv7511_probe,
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 808360fd6539..ee59f41d9951 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2985,7 +2985,6 @@ static int adv76xx_remove(struct i2c_client *client)
 
 static struct i2c_driver adv76xx_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "adv7604",
 		.of_match_table = of_match_ptr(adv76xx_of_id),
 	},
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4cf79b2422d4..124238d4cffb 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3348,7 +3348,6 @@ MODULE_DEVICE_TABLE(i2c, adv7842_id);
 
 static struct i2c_driver adv7842_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "adv7842",
 	},
 	.probe = adv7842_probe,
diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 76b334a6a56d..5b0aa2f4bad4 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -492,7 +492,6 @@ MODULE_DEVICE_TABLE(i2c, bt819_id);
 
 static struct i2c_driver bt819_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "bt819",
 	},
 	.probe		= bt819_probe,
diff --git a/drivers/media/i2c/bt856.c b/drivers/media/i2c/bt856.c
index 7fc163d0253c..48176591a80d 100644
--- a/drivers/media/i2c/bt856.c
+++ b/drivers/media/i2c/bt856.c
@@ -252,7 +252,6 @@ MODULE_DEVICE_TABLE(i2c, bt856_id);
 
 static struct i2c_driver bt856_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "bt856",
 	},
 	.probe		= bt856_probe,
diff --git a/drivers/media/i2c/bt866.c b/drivers/media/i2c/bt866.c
index a8bf10fc665d..bbec70c882a3 100644
--- a/drivers/media/i2c/bt866.c
+++ b/drivers/media/i2c/bt866.c
@@ -218,7 +218,6 @@ MODULE_DEVICE_TABLE(i2c, bt866_id);
 
 static struct i2c_driver bt866_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "bt866",
 	},
 	.probe		= bt866_probe,
diff --git a/drivers/media/i2c/cs5345.c b/drivers/media/i2c/cs5345.c
index 34b76a9e7515..92b5eaa6b0c7 100644
--- a/drivers/media/i2c/cs5345.c
+++ b/drivers/media/i2c/cs5345.c
@@ -218,7 +218,6 @@ MODULE_DEVICE_TABLE(i2c, cs5345_id);
 
 static struct i2c_driver cs5345_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "cs5345",
 	},
 	.probe		= cs5345_probe,
diff --git a/drivers/media/i2c/cs53l32a.c b/drivers/media/i2c/cs53l32a.c
index 27400c16ef9a..b7e87e38642a 100644
--- a/drivers/media/i2c/cs53l32a.c
+++ b/drivers/media/i2c/cs53l32a.c
@@ -228,7 +228,6 @@ MODULE_DEVICE_TABLE(i2c, cs53l32a_id);
 
 static struct i2c_driver cs53l32a_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "cs53l32a",
 	},
 	.probe		= cs53l32a_probe,
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index e15a789ad596..fe6eb78b6914 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5348,7 +5348,6 @@ MODULE_DEVICE_TABLE(i2c, cx25840_id);
 
 static struct i2c_driver cx25840_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "cx25840",
 	},
 	.probe		= cx25840_probe,
diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index 25b81bc58c81..77551baab068 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -708,7 +708,6 @@ MODULE_DEVICE_TABLE(i2c, ks0127_id);
 
 static struct i2c_driver ks0127_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "ks0127",
 	},
 	.probe		= ks0127_probe,
diff --git a/drivers/media/i2c/m52790.c b/drivers/media/i2c/m52790.c
index bf476358704d..77eb07eb667e 100644
--- a/drivers/media/i2c/m52790.c
+++ b/drivers/media/i2c/m52790.c
@@ -185,7 +185,6 @@ MODULE_DEVICE_TABLE(i2c, m52790_id);
 
 static struct i2c_driver m52790_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "m52790",
 	},
 	.probe		= m52790_probe,
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index dcc68ec71732..bdb94000ba5a 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -894,7 +894,6 @@ MODULE_DEVICE_TABLE(i2c, msp_id);
 
 static struct i2c_driver msp_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "msp3400",
 		.pm	= &msp3400_pm_ops,
 	},
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 57132cdba5ea..a4a5c39b599b 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -583,7 +583,6 @@ MODULE_DEVICE_TABLE(i2c, mt9v011_id);
 
 static struct i2c_driver mt9v011_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "mt9v011",
 	},
 	.probe		= mt9v011_probe,
diff --git a/drivers/media/i2c/ov7640.c b/drivers/media/i2c/ov7640.c
index faa64baf09e8..b8961df5af33 100644
--- a/drivers/media/i2c/ov7640.c
+++ b/drivers/media/i2c/ov7640.c
@@ -94,7 +94,6 @@ MODULE_DEVICE_TABLE(i2c, ov7640_id);
 
 static struct i2c_driver ov7640_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "ov7640",
 	},
 	.probe = ov7640_probe,
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 2d1e25f10973..e1b5dc84c14e 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1674,7 +1674,6 @@ MODULE_DEVICE_TABLE(i2c, ov7670_id);
 
 static struct i2c_driver ov7670_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "ov7670",
 	},
 	.probe		= ov7670_probe,
diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 2960b5a8362a..2686f01dcaef 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -520,7 +520,6 @@ MODULE_DEVICE_TABLE(i2c, saa6588_id);
 
 static struct i2c_driver saa6588_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa6588",
 	},
 	.probe		= saa6588_probe,
diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index ba3c4156644d..7202d3a3219a 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -793,7 +793,6 @@ MODULE_DEVICE_TABLE(i2c, saa6752hs_id);
 
 static struct i2c_driver saa6752hs_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa6752hs",
 	},
 	.probe		= saa6752hs_probe,
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index 99689ee57d7e..259d50d53841 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -472,7 +472,6 @@ MODULE_DEVICE_TABLE(i2c, saa7110_id);
 
 static struct i2c_driver saa7110_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa7110",
 	},
 	.probe		= saa7110_probe,
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 0eae5f4471e2..91e75222c537 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1929,7 +1929,6 @@ MODULE_DEVICE_TABLE(i2c, saa711x_id);
 
 static struct i2c_driver saa711x_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa7115",
 	},
 	.probe		= saa711x_probe,
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index 264b755bedce..a43d96da1017 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -822,7 +822,6 @@ MODULE_DEVICE_TABLE(i2c, saa7127_id);
 
 static struct i2c_driver saa7127_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa7127",
 	},
 	.probe		= saa7127_probe,
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 7d517361e419..4a6c5f475208 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -1363,7 +1363,6 @@ MODULE_DEVICE_TABLE(i2c, saa717x_id);
 
 static struct i2c_driver saa717x_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa717x",
 	},
 	.probe		= saa717x_probe,
diff --git a/drivers/media/i2c/saa7185.c b/drivers/media/i2c/saa7185.c
index f56c1c88b27d..eecad2d1edce 100644
--- a/drivers/media/i2c/saa7185.c
+++ b/drivers/media/i2c/saa7185.c
@@ -356,7 +356,6 @@ MODULE_DEVICE_TABLE(i2c, saa7185_id);
 
 static struct i2c_driver saa7185_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "saa7185",
 	},
 	.probe		= saa7185_probe,
diff --git a/drivers/media/i2c/sony-btf-mpx.c b/drivers/media/i2c/sony-btf-mpx.c
index 1da8004f5a8e..6b1a04ffad32 100644
--- a/drivers/media/i2c/sony-btf-mpx.c
+++ b/drivers/media/i2c/sony-btf-mpx.c
@@ -388,7 +388,6 @@ MODULE_DEVICE_TABLE(i2c, sony_btf_mpx_id);
 
 static struct i2c_driver sony_btf_mpx_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "sony-btf-mpx",
 	},
 	.probe = sony_btf_mpx_probe,
diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index cf93021a6500..010e4deec30a 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -416,7 +416,6 @@ MODULE_DEVICE_TABLE(i2c, tda7432_id);
 
 static struct i2c_driver tda7432_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tda7432",
 	},
 	.probe		= tda7432_probe,
diff --git a/drivers/media/i2c/tda9840.c b/drivers/media/i2c/tda9840.c
index fbdff8b24eec..f31e659588ac 100644
--- a/drivers/media/i2c/tda9840.c
+++ b/drivers/media/i2c/tda9840.c
@@ -199,7 +199,6 @@ MODULE_DEVICE_TABLE(i2c, tda9840_id);
 
 static struct i2c_driver tda9840_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tda9840",
 	},
 	.probe		= tda9840_probe,
diff --git a/drivers/media/i2c/tea6415c.c b/drivers/media/i2c/tea6415c.c
index bbe1a99fda36..084bd75bb32c 100644
--- a/drivers/media/i2c/tea6415c.c
+++ b/drivers/media/i2c/tea6415c.c
@@ -162,7 +162,6 @@ MODULE_DEVICE_TABLE(i2c, tea6415c_id);
 
 static struct i2c_driver tea6415c_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tea6415c",
 	},
 	.probe		= tea6415c_probe,
diff --git a/drivers/media/i2c/tea6420.c b/drivers/media/i2c/tea6420.c
index 30a8d75771af..b7f4e58f3624 100644
--- a/drivers/media/i2c/tea6420.c
+++ b/drivers/media/i2c/tea6420.c
@@ -144,7 +144,6 @@ MODULE_DEVICE_TABLE(i2c, tea6420_id);
 
 static struct i2c_driver tea6420_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tea6420",
 	},
 	.probe		= tea6420_probe,
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 9f7fdb6b61ca..bda3a6540a60 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -377,7 +377,6 @@ MODULE_DEVICE_TABLE(i2c, ths7303_id);
 
 static struct i2c_driver ths7303_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "ths73x3",
 	},
 	.probe		= ths7303_probe,
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 0c50e5285cf6..2a8114a676fd 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -2051,7 +2051,6 @@ MODULE_DEVICE_TABLE(i2c, tvaudio_id);
 
 static struct i2c_driver tvaudio_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tvaudio",
 	},
 	.probe		= tvaudio_probe,
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index e4fa0746f75e..522a865c5c60 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1215,7 +1215,6 @@ MODULE_DEVICE_TABLE(i2c, tvp5150_id);
 
 static struct i2c_driver tvp5150_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tvp5150",
 	},
 	.probe		= tvp5150_probe,
diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
index 12c7d211a4a4..bef79cf74364 100644
--- a/drivers/media/i2c/tw9903.c
+++ b/drivers/media/i2c/tw9903.c
@@ -266,7 +266,6 @@ MODULE_DEVICE_TABLE(i2c, tw9903_id);
 
 static struct i2c_driver tw9903_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tw9903",
 	},
 	.probe = tw9903_probe,
diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index 2672d89265ff..316a3113ef27 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -234,7 +234,6 @@ MODULE_DEVICE_TABLE(i2c, tw9906_id);
 
 static struct i2c_driver tw9906_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tw9906",
 	},
 	.probe = tw9906_probe,
diff --git a/drivers/media/i2c/upd64031a.c b/drivers/media/i2c/upd64031a.c
index d248e6a12b8e..2c0f955abc72 100644
--- a/drivers/media/i2c/upd64031a.c
+++ b/drivers/media/i2c/upd64031a.c
@@ -241,7 +241,6 @@ MODULE_DEVICE_TABLE(i2c, upd64031a_id);
 
 static struct i2c_driver upd64031a_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "upd64031a",
 	},
 	.probe		= upd64031a_probe,
diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
index 3a152ce7258a..f2057a434060 100644
--- a/drivers/media/i2c/upd64083.c
+++ b/drivers/media/i2c/upd64083.c
@@ -213,7 +213,6 @@ MODULE_DEVICE_TABLE(i2c, upd64083_id);
 
 static struct i2c_driver upd64083_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "upd64083",
 	},
 	.probe		= upd64083_probe,
diff --git a/drivers/media/i2c/vp27smpx.c b/drivers/media/i2c/vp27smpx.c
index 819ab6d12989..d6c23bdbcd4a 100644
--- a/drivers/media/i2c/vp27smpx.c
+++ b/drivers/media/i2c/vp27smpx.c
@@ -194,7 +194,6 @@ MODULE_DEVICE_TABLE(i2c, vp27smpx_id);
 
 static struct i2c_driver vp27smpx_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "vp27smpx",
 	},
 	.probe		= vp27smpx_probe,
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index 016e766e72ba..8630eaeeb1b1 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -567,7 +567,6 @@ MODULE_DEVICE_TABLE(i2c, vpx3220_id);
 
 static struct i2c_driver vpx3220_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "vpx3220",
 	},
 	.probe		= vpx3220_probe,
diff --git a/drivers/media/i2c/wm8739.c b/drivers/media/i2c/wm8739.c
index 3be73f6a40e9..f9e0d268ed6a 100644
--- a/drivers/media/i2c/wm8739.c
+++ b/drivers/media/i2c/wm8739.c
@@ -272,7 +272,6 @@ MODULE_DEVICE_TABLE(i2c, wm8739_id);
 
 static struct i2c_driver wm8739_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "wm8739",
 	},
 	.probe		= wm8739_probe,
diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
index bee7946faa7c..d33d2cd6d034 100644
--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -318,7 +318,6 @@ MODULE_DEVICE_TABLE(i2c, wm8775_id);
 
 static struct i2c_driver wm8775_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "wm8775",
 	},
 	.probe		= wm8775_probe,
-- 
1.9.1


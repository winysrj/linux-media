Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9138 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbbGJGUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:20:12 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 6/7] [media] tuners: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:19:47 +0900
Message-id: <1436509188-23320-7-git-send-email-k.kozlowski@samsung.com>
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
 drivers/media/tuners/e4000.c      | 1 -
 drivers/media/tuners/fc2580.c     | 1 -
 drivers/media/tuners/it913x.c     | 1 -
 drivers/media/tuners/m88rs6000t.c | 1 -
 drivers/media/tuners/si2157.c     | 1 -
 drivers/media/tuners/tda18212.c   | 1 -
 drivers/media/tuners/tua9001.c    | 1 -
 7 files changed, 7 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 03538f88f488..564a000f503e 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -752,7 +752,6 @@ MODULE_DEVICE_TABLE(i2c, e4000_id_table);
 
 static struct i2c_driver e4000_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "e4000",
 		.suppress_bind_attrs = true,
 	},
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 12f916e53150..f4d4665de168 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -632,7 +632,6 @@ MODULE_DEVICE_TABLE(i2c, fc2580_id_table);
 
 static struct i2c_driver fc2580_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "fc2580",
 		.suppress_bind_attrs = true,
 	},
diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index a076c87eda7a..5c96da693289 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -463,7 +463,6 @@ MODULE_DEVICE_TABLE(i2c, it913x_id_table);
 
 static struct i2c_driver it913x_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "it913x",
 	},
 	.probe		= it913x_probe,
diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
index d4c13fe6e7b3..504bfbc4027a 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -729,7 +729,6 @@ MODULE_DEVICE_TABLE(i2c, m88rs6000t_id);
 
 static struct i2c_driver m88rs6000t_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "m88rs6000t",
 	},
 	.probe		= m88rs6000t_probe,
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index a6245ef379c4..507382160e5e 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -469,7 +469,6 @@ MODULE_DEVICE_TABLE(i2c, si2157_id_table);
 
 static struct i2c_driver si2157_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "si2157",
 	},
 	.probe		= si2157_probe,
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index d93e0667b46b..7b8068354fea 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -277,7 +277,6 @@ MODULE_DEVICE_TABLE(i2c, tda18212_id);
 
 static struct i2c_driver tda18212_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tda18212",
 	},
 	.probe		= tda18212_probe,
diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index d4f6ca0c4d92..9d70378fe2d3 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -267,7 +267,6 @@ MODULE_DEVICE_TABLE(i2c, tua9001_id_table);
 
 static struct i2c_driver tua9001_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "tua9001",
 		.suppress_bind_attrs = true,
 	},
-- 
1.9.1


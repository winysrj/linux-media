Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9716 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbbGJGel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:34:41 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-iio@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] staging: media: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:34:27 +0900
Message-id: <1436510068-5284-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1436510068-5284-1-git-send-email-k.kozlowski@samsung.com>
References: <1436510068-5284-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_driver does not need to set an owner because i2c_register_driver()
will set it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

The coccinelle script which generated the patch was sent here:
http://www.spinics.net/lists/kernel/msg2029903.html
---
 drivers/staging/media/lirc/lirc_zilog.c | 1 -
 drivers/staging/media/mn88472/mn88472.c | 1 -
 drivers/staging/media/mn88473/mn88473.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 261e27d6b054..d032745081ee 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1367,7 +1367,6 @@ static const struct i2c_device_id ir_transceiver_id[] = {
 
 static struct i2c_driver driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "Zilog/Hauppauge i2c IR",
 	},
 	.probe		= ir_probe,
diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index a8d45f44765c..cf2e96bcf395 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -561,7 +561,6 @@ MODULE_DEVICE_TABLE(i2c, mn88472_id_table);
 
 static struct i2c_driver mn88472_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "mn88472",
 	},
 	.probe		= mn88472_probe,
diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index f9146a146d07..a222e99935d2 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -507,7 +507,6 @@ MODULE_DEVICE_TABLE(i2c, mn88473_id_table);
 
 static struct i2c_driver mn88473_driver = {
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "mn88473",
 	},
 	.probe		= mn88473_probe,
-- 
1.9.1


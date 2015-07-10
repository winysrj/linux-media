Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61950 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbGJGeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:34:37 -0400
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
Subject: [PATCH 1/3] staging: iio: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:34:26 +0900
Message-id: <1436510068-5284-2-git-send-email-k.kozlowski@samsung.com>
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
 drivers/staging/iio/addac/adt7316-i2c.c | 1 -
 drivers/staging/iio/light/isl29018.c    | 1 -
 drivers/staging/iio/light/isl29028.c    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/staging/iio/addac/adt7316-i2c.c b/drivers/staging/iio/addac/adt7316-i2c.c
index 75ddd4f801a3..78fe0b557280 100644
--- a/drivers/staging/iio/addac/adt7316-i2c.c
+++ b/drivers/staging/iio/addac/adt7316-i2c.c
@@ -124,7 +124,6 @@ static struct i2c_driver adt7316_driver = {
 	.driver = {
 		.name = "adt7316",
 		.pm = ADT7316_PM_OPS,
-		.owner  = THIS_MODULE,
 	},
 	.probe = adt7316_i2c_probe,
 	.id_table = adt7316_i2c_id,
diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index e646c5d24004..019ba5245c23 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -838,7 +838,6 @@ static struct i2c_driver isl29018_driver = {
 			.name = "isl29018",
 			.acpi_match_table = ACPI_PTR(isl29018_acpi_match),
 			.pm = ISL29018_PM_OPS,
-			.owner = THIS_MODULE,
 			.of_match_table = isl29018_of_match,
 		    },
 	.probe	 = isl29018_probe,
diff --git a/drivers/staging/iio/light/isl29028.c b/drivers/staging/iio/light/isl29028.c
index e5b2fdc2334b..cd6f2727aa58 100644
--- a/drivers/staging/iio/light/isl29028.c
+++ b/drivers/staging/iio/light/isl29028.c
@@ -547,7 +547,6 @@ static struct i2c_driver isl29028_driver = {
 	.class	= I2C_CLASS_HWMON,
 	.driver  = {
 		.name = "isl29028",
-		.owner = THIS_MODULE,
 		.of_match_table = isl29028_of_match,
 	},
 	.probe	 = isl29028_probe,
-- 
1.9.1


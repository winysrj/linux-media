Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60092 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbbGJGeq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:34:46 -0400
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
Subject: [PATCH 3/3] staging: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:34:28 +0900
Message-id: <1436510068-5284-4-git-send-email-k.kozlowski@samsung.com>
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
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 0f524bb7b41d..1f9ba8beb061 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -1126,7 +1126,6 @@ MODULE_DEVICE_TABLE(i2c, synaptics_rmi4_id_table);
 static struct i2c_driver synaptics_rmi4_driver = {
 	.driver = {
 		.name	=	DRIVER_NAME,
-		.owner	=	THIS_MODULE,
 		.pm	=	&synaptics_rmi4_dev_pm_ops,
 	},
 	.probe		=	synaptics_rmi4_probe,
-- 
1.9.1


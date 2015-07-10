Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9120 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbbGJGUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:20:07 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/7] [media] platform: Drop owner assignment from i2c_driver
Date: Fri, 10 Jul 2015 15:19:45 +0900
Message-id: <1436509188-23320-5-git-send-email-k.kozlowski@samsung.com>
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
 drivers/media/platform/s5p-tv/hdmiphy_drv.c | 1 -
 drivers/media/platform/s5p-tv/sii9234_drv.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index c2f2e35642f2..aae652351aa8 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -315,7 +315,6 @@ MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
 static struct i2c_driver hdmiphy_driver = {
 	.driver = {
 		.name	= "s5p-hdmiphy",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= hdmiphy_probe,
 	.remove		= hdmiphy_remove,
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index db8c17bb4aaa..8d171310af8f 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -397,7 +397,6 @@ MODULE_DEVICE_TABLE(i2c, sii9234_id);
 static struct i2c_driver sii9234_driver = {
 	.driver = {
 		.name	= "sii9234",
-		.owner	= THIS_MODULE,
 		.pm = &sii9234_pm_ops,
 	},
 	.probe		= sii9234_probe,
-- 
1.9.1


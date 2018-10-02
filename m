Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37011 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbeJBOOX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 10:14:23 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v5 4/6] [media] ad5820: Add support for of-autoload
Date: Tue,  2 Oct 2018 09:32:20 +0200
Message-Id: <20181002073222.11368-4-ricardo.ribalda@gmail.com>
In-Reply-To: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since kernel 4.16, i2c devices with DT compatible tag are modprobed
using their DT modalias.
Without this patch, if this driver is build as module it would never
be autoprobed.

There is no need to mask it with CONFIG_OF to allow ACPI loading, this
also builds find with CONFIG_OF=n.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ad5820.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 97eb05e65833..4ae4e6a776fd 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -372,12 +372,19 @@ static const struct i2c_device_id ad5820_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
 
+static const struct of_device_id ad5820_of_table[] = {
+	{ .compatible = "adi,ad5820" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ad5820_of_table);
+
 static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
 
 static struct i2c_driver ad5820_i2c_driver = {
 	.driver		= {
 		.name	= AD5820_NAME,
 		.pm	= &ad5820_pm,
+		.of_match_table = ad5820_of_table,
 	},
 	.probe		= ad5820_probe,
 	.remove		= ad5820_remove,
-- 
2.19.0

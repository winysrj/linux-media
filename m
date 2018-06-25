Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51639 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbeFYHcD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 03:32:03 -0400
From: alanx.chiang@intel.com
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com,
        andriy.shevchenko@intel.com, rajmohan.mani@intel.com,
        "alanx.chiang" <alanx.chiang@intel.com>
Subject: [RESEND PATCH v1 1/2] eeprom: at24: Add support for address-width property
Date: Mon, 25 Jun 2018 15:29:42 +0800
Message-Id: <1529911783-28576-2-git-send-email-alanx.chiang@intel.com>
In-Reply-To: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
References: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "alanx.chiang" <alanx.chiang@intel.com>

Provide a flexible way to determine the addressing bits of eeprom.
It doesn't need to add acpi or i2c ids for specific modules.

Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
Signed-off-by: Andy Yeh <andy.yeh@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/misc/eeprom/at24.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 0c125f2..a6fbdae 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -478,6 +478,22 @@ static void at24_properties_to_pdata(struct device *dev,
 	if (device_property_present(dev, "no-read-rollover"))
 		chip->flags |= AT24_FLAG_NO_RDROL;
 
+	err = device_property_read_u32(dev, "address-width", &val);
+	if (!err) {
+		switch (val) {
+		case 8:
+			chip->flags &= ~AT24_FLAG_ADDR16;
+			break;
+		case 16:
+			chip->flags |= AT24_FLAG_ADDR16;
+			break;
+		default:
+			dev_warn(dev,
+				"Bad \"address-width\" property: %u\n",
+				val);
+		}
+	}
+
 	err = device_property_read_u32(dev, "size", &val);
 	if (!err)
 		chip->byte_len = val;
-- 
2.7.4

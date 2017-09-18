Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45514 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753447AbdIRKXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 06:23:53 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: [RESEND PATCH v2 5/6] as3645a: Add colour to LED name
Date: Mon, 18 Sep 2017 13:23:48 +0300
Message-Id: <20170918102349.8935-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the colour of the LED to the LED name, as specified in
Documentation/leds/leds-class.txt.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-as3645a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index 605e0c64e974..edeb0a499f6c 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -528,7 +528,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 		strlcpy(names->flash, name, sizeof(names->flash));
 	else
 		snprintf(names->flash, sizeof(names->flash),
-			 "%s:flash", node->name);
+			 "%s:white:flash", node->name);
 
 	rval = of_property_read_u32(flash->flash_node, "flash-timeout-us",
 				    &cfg->flash_timeout_us);
@@ -572,7 +572,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 		strlcpy(names->indicator, name, sizeof(names->indicator));
 	else
 		snprintf(names->indicator, sizeof(names->indicator),
-			 "%s:indicator", node->name);
+			 "%s:red:indicator", node->name);
 
 	rval = of_property_read_u32(flash->indicator_node, "led-max-microamp",
 				    &cfg->indicator_max_ua);
-- 
2.11.0

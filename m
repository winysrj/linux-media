Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53094 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753206AbaLIAEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:49 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 03/12] smiapp-pll: include linux/device.h in smiapp-pll.c, not in smiapp-pll.h
Date: Tue,  9 Dec 2014 02:04:11 +0200
Message-Id: <1418083460-28556-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
References: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct device has a forward declaration in the header already. The header is
only needed in the .c file.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp-pll.c |    1 +
 drivers/media/i2c/smiapp-pll.h |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 2b84d09..e3348db 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -16,6 +16,7 @@
  * General Public License for more details.
  */
 
+#include <linux/device.h>
 #include <linux/gcd.h>
 #include <linux/lcm.h>
 #include <linux/module.h>
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 77f7ff2f..b98d143 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -19,8 +19,6 @@
 #ifndef SMIAPP_PLL_H
 #define SMIAPP_PLL_H
 
-#include <linux/device.h>
-
 /* CSI-2 or CCP-2 */
 #define SMIAPP_PLL_BUS_TYPE_CSI2				0x00
 #define SMIAPP_PLL_BUS_TYPE_PARALLEL				0x01
-- 
1.7.10.4


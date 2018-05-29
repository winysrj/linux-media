Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41674 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933563AbeE2MZ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 08:25:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, robh@kernel.org
Cc: devicetree@vger.kernel.org, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com
Subject: [PATCH 1/1] dw9807: Use the dongwoon,dw9807-vcm compatible string
Date: Tue, 29 May 2018 15:25:54 +0300
Message-Id: <20180529122554.3325-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original dw9807 DT bindings patch proposed the dongwoon,dw9807
compatible string. However, the device also includes an EEPROM on a
different I²C address. Indicate that this is just the VCM part of the
entire device.

The EEPROM part is compatible with the at24c64 for read-only access, with
1 kiB page size.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Rob, others,

The original bindings were missing the EEPROM bit. This change recognises
it's there, and allows adding more elaborate support for it later on if
needed.

If this change is fine, I'll squash it to the original patches that are
not yet merged:

<URL:https://patchwork.linuxtv.org/patch/49613/>
<URL:https://patchwork.linuxtv.org/patch/49614/>

Thanks.

 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 2 +-
 drivers/media/i2c/dw9807.c                                      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
index 0a1a860beaff..c4701f1eaaf6 100644
--- a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
+++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
@@ -5,5 +5,5 @@ controlling voice coil lenses.
 
 Mandatory properties:
 
-- compatible: "dongwoon,dw9807"
+- compatible: "dongwoon,dw9807-vcm"
 - reg: I2C slave address
diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
index 6ebb98717fb1..8ba3920b6e2f 100644
--- a/drivers/media/i2c/dw9807.c
+++ b/drivers/media/i2c/dw9807.c
@@ -302,7 +302,7 @@ static int  __maybe_unused dw9807_vcm_resume(struct device *dev)
 }
 
 static const struct of_device_id dw9807_of_table[] = {
-	{ .compatible = "dongwoon,dw9807" },
+	{ .compatible = "dongwoon,dw9807-vcm" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, dw9807_of_table);
-- 
2.11.0

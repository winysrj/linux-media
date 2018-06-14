Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46556 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754809AbeFNM3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 08:29:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
Subject: [PATCH v3 1/2] dt-bindings: smia: Add "rotation" property
Date: Thu, 14 Jun 2018 15:29:38 +0300
Message-Id: <20180614122939.21257-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180614122939.21257-1-sakari.ailus@linux.intel.com>
References: <20180614122939.21257-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the rotation property to list of optional properties for the smia
sensors.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
index 33f10a94c381..8ee7c7972ac7 100644
--- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -29,6 +29,9 @@ Optional properties
 - reset-gpios: XSHUTDOWN GPIO
 - flash-leds: See ../video-interfaces.txt
 - lens-focus: See ../video-interfaces.txt
+- rotation: Integer property; valid values are 0 (sensor mounted upright)
+	    and 180 (sensor mounted upside down). See
+	    ../video-interfaces.txt .
 
 
 Endpoint node mandatory properties
-- 
2.11.0

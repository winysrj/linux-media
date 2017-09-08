Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47502 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756144AbdIHNSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:18:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v9 23/24] dt: bindings: smiapp: Document lens-focus and flash properties
Date: Fri,  8 Sep 2017 16:18:21 +0300
Message-Id: <20170908131822.31020-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document optional lens-focus and flash properties for the smiapp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
index 855e1faf73e2..a052969365d9 100644
--- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -27,6 +27,8 @@ Optional properties
 - nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
   the NVM contents will not be read.
 - reset-gpios: XSHUTDOWN GPIO
+- flash-leds: One or more phandles to refer to flash LEDs
+- lens-focus: Phandle for lens focus
 
 
 Endpoint node mandatory properties
-- 
2.11.0

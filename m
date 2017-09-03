Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50498 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751649AbdICUSH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 16:18:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v7 1/1] dt: bindings: smiapp: Document lens-focus and flash properties
Date: Sun,  3 Sep 2017 23:18:05 +0300
Message-Id: <20170903201805.31998-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170903174958.27058-18-sakari.ailus@linux.intel.com>
References: <20170903174958.27058-18-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document optional lens-focus and flash properties for the smiapp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi all,

This should precede the smiapp driver change.

 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
index 855e1faf73e2..f02178eef84d 100644
--- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -27,6 +27,8 @@ Optional properties
 - nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
   the NVM contents will not be read.
 - reset-gpios: XSHUTDOWN GPIO
+- flash: One or more phandles to refer to flash LEDs
+- lens-focus: Phandle for lens focus
 
 
 Endpoint node mandatory properties
-- 
2.11.0

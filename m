Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752230AbdFNJrd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:47:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: [PATCH 3/8] dt: bindings: Add a binding for referencing EEPROM from camera sensors
Date: Wed, 14 Jun 2017 12:47:14 +0300
Message-Id: <1497433639-13101-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many camera sensor devices contain EEPROM chips that describe the
properties of a given unit --- the data is specific to a given unit can
thus is not stored e.g. in user space or the driver.

Some sensors embed the EEPROM chip and it can be accessed through the
sensor's I2C interface. This property is to be used for devices where the
EEPROM chip is accessed through a different I2C address than the sensor.

The intent is to later provide this information to the user space.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index a18d9b2..ae259924 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -76,6 +76,9 @@ Optional properties
 
 - lens-focus: A phandle to the node of the focus lens controller.
 
+- eeprom: A phandle to the node of the EEPROM describing the camera sensor
+  (i.e. device specific calibration data), in case it differs from the
+  sensor node.
 
 Optional endpoint properties
 ----------------------------
-- 
2.1.4

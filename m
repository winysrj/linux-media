Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752486AbdEEIt0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 04:49:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM from camera sensors
Date: Fri,  5 May 2017 11:48:30 +0300
Message-Id: <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
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
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 0a33240..38e3916 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -79,6 +79,9 @@ Optional properties
 
 - lens-focus: A phandle to the node of the focus lens controller.
 
+- eeprom: A phandle to the node of the EEPROM describing the camera sensor
+  (i.e. device specific calibration data), in case it differs from the
+  sensor node.
 
 Optional endpoint properties
 ----------------------------
-- 
2.7.4

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7870 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbdEBK0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 06:26:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [RFC 3/3] dt: bindings: Add a binding for referencing EEPROM from camera sensors
Date: Tue,  2 May 2017 13:25:49 +0300
Message-Id: <1493720749-31509-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many camera sensor devices contain EEPROM chips that describe the
properties of a given unit --- the data is specific to a given unit can
thus is not stored e.g. in user space or the driver.

Some sensors embed the EEPROM chip and it can be accessed through the
sensor's I²C interface. This property is to be used for devices where the
EEPROM chip is accessed through a different I²C address than the sensor.

The intent is to later provide this information to the user space.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index e52aefc..9bd2005 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -80,6 +80,9 @@ Optional properties
 - lens-focus: A phandle to the node of the lens. Only valid for device
   nodes that are related to an image sensor.
 
+- eeprom: A phandle to the node of the related EEPROM. Only valid for
+  device nodes that are related to an image sensor.
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.7.4

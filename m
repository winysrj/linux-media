Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40166 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752439AbdEEItZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 04:49:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: [RFC v2 1/3] dt: bindings: Add a binding for flash devices associated to a sensor
Date: Fri,  5 May 2017 11:48:28 +0300
Message-Id: <1493974110-26510-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera flash drivers (and LEDs) are separate from the sensor devices in
DT. In order to make an association between the two, provide the
association information to the software.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 9cd2a36..dac764b 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -67,6 +67,17 @@ are required in a relevant parent node:
 		    identifier, should be 1.
  - #size-cells    : should be zero.
 
+
+Optional properties
+-------------------
+
+- flash: An array of phandles that refer to the flash light sources
+  related to an image sensor. These could be e.g. LEDs. In case the LED
+  driver (current sink or source chip for the LED(s)) drives more than a
+  single LED, then the phandles here refer to the child nodes of the LED
+  driver describing individual LEDs.
+
+
 Optional endpoint properties
 ----------------------------
 
-- 
2.7.4

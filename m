Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:53981 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbdEBK1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 06:27:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [RFC 2/3] dt: bindings: Add lens-focus binding for image sensors
Date: Tue,  2 May 2017 13:25:48 +0300
Message-Id: <1493720749-31509-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lens-focus property contains a phandle to the lens voice coil driver
that is associated to the sensor; typically both are contained in the same
camera module.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index d6c62bc..e52aefc 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -77,6 +77,9 @@ Optional properties
   the child nodes of the LED driver describing individual LEDs. Only
   valid for device nodes that are related to an image sensor.
 
+- lens-focus: A phandle to the node of the lens. Only valid for device
+  nodes that are related to an image sensor.
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.7.4

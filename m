Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52228 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S966625AbeEYM1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 08:27:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, andy.yeh@intel.com,
        sebastian.reichel@collabora.co.uk
Subject: [PATCH v2 1/2] dt-bindings: media: Define "rotation" property for sensors
Date: Fri, 25 May 2018 15:27:25 +0300
Message-Id: <20180525122726.3409-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
References: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sensors are occasionally mounted upside down to systems such as mobile
phones or tablets. In order to use such a sensor without having to turn
every image upside down, most camera sensors support reversing the readout
order by setting both horizontal and vertical flipping.

This patch documents the "rotation" property for camera sensors, mirroring
what is defined for displays in
Documentation/devicetree/bindings/display/panel/panel.txt .

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 258b8dfddf48..52b7c7b57842 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -85,6 +85,10 @@ Optional properties
 
 - lens-focus: A phandle to the node of the focus lens controller.
 
+- rotation: The device, typically an image sensor, is not mounted upright,
+  but a number of degrees counter clockwise. Typical values are 0 and 180
+  (upside down).
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.11.0

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35802 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751253AbeEBVbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 17:31:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, andy.yeh@intel.com
Subject: [PATCH 1/2] dt-bindings: media: Add "upside-down" property to tell sensor orientation
Date: Thu,  3 May 2018 00:31:14 +0300
Message-Id: <20180502213115.24000-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
References: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera sensors are occasionally mounted upside down. In order to use such
a sensor without having to turn every image upside down separately, most
camera sensors support reversing the readout order by setting both
horizontal and vertical flipping.

This patch adds a boolean property to tell a sensor is mounted upside
down.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 258b8dfddf48..2a3e4ec4ea27 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -85,6 +85,9 @@ Optional properties
 
 - lens-focus: A phandle to the node of the focus lens controller.
 
+- upside-down: The device, typically an image sensor, is mounted upside
+  down in the system.
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.11.0

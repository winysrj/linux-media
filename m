Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752817AbdEEIt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 04:49:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: [RFC v2 2/3] dt: bindings: Add lens-focus binding for image sensors
Date: Fri,  5 May 2017 11:48:29 +0300
Message-Id: <1493974110-26510-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lens-focus property contains a phandle to the lens voice coil driver
that is associated to the sensor; typically both are contained in the same
camera module.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index dac764b..0a33240 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -77,6 +77,8 @@ Optional properties
   single LED, then the phandles here refer to the child nodes of the LED
   driver describing individual LEDs.
 
+- lens-focus: A phandle to the node of the focus lens controller.
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.7.4

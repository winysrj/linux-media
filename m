Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35795 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751795AbdIVHpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 03:45:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH v2 1/2] dt: bindings: media: Document practices for DT bindings, ports, endpoints
Date: Fri, 22 Sep 2017 10:42:13 +0300
Message-Id: <1506066134-25997-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1506066134-25997-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1506066134-25997-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Port and endpoint numbering has been omitted in DT binding documentation
for a large number of devices. Also common properties the device uses have
been missed in binding documentation. Make it explicit that these things
need to be documented.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../devicetree/bindings/media/video-interfaces.txt        | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 852041a..3c5382f 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -55,6 +55,21 @@ divided into two separate ITU-R BT.656 8-bit busses.  In such case bus-width
 and data-shift properties can be used to assign physical data lines to each
 endpoint node (logical bus).
 
+Documenting bindings for devices
+--------------------------------
+
+All required and optional bindings the device supports shall be explicitly
+documented in device DT binding documentation. This also includes port and
+endpoint numbering for the device.
+
+Port and endpoint numbering
+---------------------------
+
+Old binding documentation may have omitted explicitly specifying port and
+endpoint numbers. This often applies to devices that have a single port and a
+single endpoint in that port. In this case, the only valid port number for such
+a device is zero. The same applies for devices for which bindings do not
+document endpoint numbering: only zero is a valid endpoint.
 
 Required properties
 -------------------
-- 
2.7.4

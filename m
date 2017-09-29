Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59381 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752240AbdI2I0g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 04:26:36 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH v3 1/2] dt: bindings: media: Document practices for DT bindings, ports, endpoints
Date: Fri, 29 Sep 2017 11:23:40 +0300
Message-Id: <1506673421-6085-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1506673421-6085-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1506673421-6085-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Port and endpoint numbering has been omitted in DT binding documentation
for a large number of devices. Also common properties the device uses have
been missed in binding documentation. Make it explicit that these things
need to be documented.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 852041a..bc8f18fb 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -55,6 +55,15 @@ divided into two separate ITU-R BT.656 8-bit busses.  In such case bus-width
 and data-shift properties can be used to assign physical data lines to each
 endpoint node (logical bus).
 
+Documenting bindings for devices
+--------------------------------
+
+All required and optional bindings the device supports shall be explicitly
+documented in device DT binding documentation. This also includes port and
+endpoint nodes for the device, including unit-addresses and reg properties where
+relevant.
+
+Please also see Documentation/devicetree/bindings/graph.txt .
 
 Required properties
 -------------------
-- 
2.7.4

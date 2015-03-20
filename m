Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42158 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251AbbCTWHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 18:07:50 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v1.1 12/15] dt: bindings: Add lane-polarity property to endpoint nodes
Date: Sat, 21 Mar 2015 00:07:06 +0200
Message-Id: <1426889226-18080-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426465570-30295-13-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-13-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lane-polarity property to endpoint nodes. This essentially tells that
the order of the differential signal wires is inverted.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
since v1:

- Rename lane-polarity property as lane-polarities.

 Documentation/devicetree/bindings/media/video-interfaces.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 571b4c6..9cd2a36 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -106,6 +106,12 @@ Optional endpoint properties
 - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
   instance, this is the actual frequency of the bus, not bits per clock per
   lane value. An array of 64-bit unsigned integers.
+- lane-polarities: an array of polarities of the lanes starting from the clock
+  lane and followed by the data lanes in the same order as in data-lanes.
+  Valid values are 0 (normal) and 1 (inverted). The length of the array
+  should be the combined length of data-lanes and clock-lanes properties.
+  If the lane-polarities property is omitted, the value must be interpreted
+  as 0 (normal). This property is valid for serial busses only.
 
 
 Example
-- 
1.7.10.4


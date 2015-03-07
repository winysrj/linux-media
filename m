Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33317 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752808AbbCGVmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 12/18] dt: bindings: Add lane-polarity property to endpoint nodes
Date: Sat,  7 Mar 2015 23:41:09 +0200
Message-Id: <1425764475-27691-13-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lane-polarity property to endpoint nodes. This essentially tells that
the order of the differential signal wires is inverted.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 571b4c6..058d1e6 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -106,6 +106,11 @@ Optional endpoint properties
 - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
   instance, this is the actual frequency of the bus, not bits per clock per
   lane value. An array of 64-bit unsigned integers.
+- lane-polarity: an array of polarities of the lanes starting from the clock
+  lane and followed by the data lanes in the same order as in data-lanes.
+  Valid values are 0 (normal) and 1 (inverted). The length of the array
+  should be the combined length of data-lanes and clock-lanes properties.
+  This property is valid for serial busses only.
 
 
 Example
-- 
1.7.10.4


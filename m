Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53104 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755137AbaLIAEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:50 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 08/12] of: v4l: Document link-frequencies property in video-interfaces.txt
Date: Tue,  9 Dec 2014 02:04:16 +0200
Message-Id: <1418083460-28556-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
References: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

link-frequencies is a 64-bit unsigned integer array of allowed link
frequencies.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index ce719f8..52a14cf 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -103,6 +103,9 @@ Optional endpoint properties
   array contains only one entry.
 - clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
   clock mode.
+- link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
+  instance, this is the actual frequency of the bus, not bits per clock per
+  lane value. An array of 64-bit unsigned integers.
 
 
 Example
-- 
1.7.10.4


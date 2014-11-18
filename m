Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46543 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632AbaKRFoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:44:09 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id F395760093
	for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 07:44:06 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH v2 07/11] of: v4l: Document link-frequency property in video-interfaces.txt
Date: Tue, 18 Nov 2014 07:43:42 +0200
Message-Id: <1416289426-804-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

link-frequency is a 64-bit unsigned integer array of allowed link
frequencies.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/media/video-interfaces.txt |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index ce719f8..7d8f07f 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -103,6 +103,9 @@ Optional endpoint properties
   array contains only one entry.
 - clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
   clock mode.
+- link-frequency: Allowed data bus frequencies. For MIPI CSI-2, for
+  instance, this is the actual frequency of the bus, not bits per clock per
+  lane value. An array of 64-bit unsigned integers.
 
 
 Example
-- 
1.7.10.4


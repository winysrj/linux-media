Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34304 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752322AbdFNJrn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:47:43 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: [PATCH 1/8] dt: bindings: Add a binding for flash devices associated to a sensor
Date: Wed, 14 Jun 2017 12:47:12 +0300
Message-Id: <1497433639-13101-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera flash drivers (and LEDs) are separate from the sensor devices in
DT. In order to make an association between the two, provide the
association information to the software.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 9cd2a36..9723f7e 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -67,6 +67,14 @@ are required in a relevant parent node:
 		    identifier, should be 1.
  - #size-cells    : should be zero.
 
+
+Optional properties
+-------------------
+
+- flash: phandle referring to the flash driver chip. A flash driver may
+  have multiple flashes connected to it.
+
+
 Optional endpoint properties
 ----------------------------
 
-- 
2.1.4

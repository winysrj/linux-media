Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41976 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751964AbdGEXAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 2/8] dt: bindings: Add strobe property for CCP2
Date: Thu,  6 Jul 2017 02:00:13 +0300
Message-Id: <20170705230019.5461-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the CSI1/CCP2 property strobe. It signifies the clock or
strobe mode.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reviewed-By: Sebastian Reichel <sre@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 9aa2722b6920..852041a7480c 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -117,7 +117,8 @@ Optional endpoint properties
   should be the combined length of data-lanes and clock-lanes properties.
   If the lane-polarities property is omitted, the value must be interpreted
   as 0 (normal). This property is valid for serial busses only.
-
+- strobe: Whether the clock signal is used as clock (0) or strobe (1). Used
+  with CCP2, for instance.
 
 Example
 -------
-- 
2.11.0

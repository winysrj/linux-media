Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58017 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751671AbdFIRyG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 13:54:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 2/2] dt-bindings: media/s5p-cec.txt, media/stih-cec.txt: refer to cec.txt
Date: Fri,  9 Jun 2017 19:54:01 +0200
Message-Id: <20170609175401.40204-3-hverkuil@xs4all.nl>
In-Reply-To: <20170609175401.40204-1-hverkuil@xs4all.nl>
References: <20170609175401.40204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that there is a cec.txt with common CEC bindings, update the two
driver-specific bindings to refer to cec.txt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/media/s5p-cec.txt  | 6 ++----
 Documentation/devicetree/bindings/media/stih-cec.txt | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
index 261af4d1a791..1b1a10ba48ce 100644
--- a/Documentation/devicetree/bindings/media/s5p-cec.txt
+++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
@@ -15,13 +15,11 @@ Required properties:
   - clock-names : from common clock binding: must contain "hdmicec",
 		  corresponding to entry in the clocks property.
   - samsung,syscon-phandle - phandle to the PMU system controller
-  - hdmi-phandle - phandle to the HDMI controller
+  - hdmi-phandle - phandle to the HDMI controller, see also cec.txt.
 
 Optional:
   - needs-hpd : if present the CEC support is only available when the HPD
-    is high. Some boards only let the CEC pin through if the HPD is high, for
-    example if there is a level converter that uses the HPD to power up
-    or down.
+		is high. See cec.txt for more details.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
index 289a08b33651..8be2a040c6c6 100644
--- a/Documentation/devicetree/bindings/media/stih-cec.txt
+++ b/Documentation/devicetree/bindings/media/stih-cec.txt
@@ -9,7 +9,7 @@ Required properties:
  - pinctrl-names: Contains only one value - "default"
  - pinctrl-0: Specifies the pin control groups used for CEC hardware.
  - resets: Reference to a reset controller
- - hdmi-phandle: Phandle to the HDMI controller
+ - hdmi-phandle: Phandle to the HDMI controller, see also cec.txt.
 
 Example for STIH407:
 
-- 
2.11.0

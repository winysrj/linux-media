Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36479 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdAaVVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 16:21:48 -0500
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-amlogic@lists.infradead.org, khilman@baylibre.com,
        carlo@caione.org, mchehab@kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, narmstrong@baylibre.com,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] Documentation: devicetree: meson-ir: "linux,rc-map-name" is supported
Date: Tue, 31 Jan 2017 22:21:12 +0100
Message-Id: <20170131212112.5582-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver already parses the "linux,rc-map-name" property. Add this
information to the documentation so .dts maintainers don't have to look
it up in the source-code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/media/meson-ir.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/meson-ir.txt b/Documentation/devicetree/bindings/media/meson-ir.txt
index e7e3f3c4fc8f..efd9d29a8f10 100644
--- a/Documentation/devicetree/bindings/media/meson-ir.txt
+++ b/Documentation/devicetree/bindings/media/meson-ir.txt
@@ -8,6 +8,9 @@ Required properties:
  - reg		: physical base address and length of the device registers
  - interrupts	: a single specifier for the interrupt from the device
 
+Optional properties:
+ - linux,rc-map-name:	see rc.txt file in the same directory.
+
 Example:
 
 	ir-receiver@c8100480 {
-- 
2.11.0


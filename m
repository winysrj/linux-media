Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32867 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbcF1TTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:19:16 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, carlo@caione.org,
	khilman@baylibre.com, mchehab@kernel.org,
	devicetree@vger.kernel.org, narmstrong@baylibre.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/4] dt-bindings: media: meson-ir: Add Meson8b and GXBB compatible strings
Date: Tue, 28 Jun 2016 21:17:59 +0200
Message-Id: <20160628191802.21227-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
 <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Armstrong <narmstrong@baylibre.com>

New bindings are needed as the register layout on the newer platforms
is slightly different compared to Meson6b.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/media/meson-ir.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/meson-ir.txt b/Documentation/devicetree/bindings/media/meson-ir.txt
index 407848e..e7e3f3c 100644
--- a/Documentation/devicetree/bindings/media/meson-ir.txt
+++ b/Documentation/devicetree/bindings/media/meson-ir.txt
@@ -1,7 +1,10 @@
 * Amlogic Meson IR remote control receiver
 
 Required properties:
- - compatible	: should be "amlogic,meson6-ir"
+ - compatible	: depending on the platform this should be one of:
+		  - "amlogic,meson6-ir"
+		  - "amlogic,meson8b-ir"
+		  - "amlogic,meson-gxbb-ir"
  - reg		: physical base address and length of the device registers
  - interrupts	: a single specifier for the interrupt from the device
 
-- 
2.9.0


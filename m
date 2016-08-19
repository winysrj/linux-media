Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36336 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754388AbcHSV5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 17:57:32 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, khilman@baylibre.com, carlo@caione.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        mchehab@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 3/6] dt-bindings: media: meson-ir: Add Meson8b and GXBB compatible strings
Date: Fri, 19 Aug 2016 23:55:44 +0200
Message-Id: <20160819215547.20063-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
References: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
 <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Armstrong <narmstrong@baylibre.com>

New bindings are needed as the register layout on the newer platforms
is slightly different compared to Meson6b.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Rob Herring <robh@kernel.org>
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
2.9.3


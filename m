Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:60616 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaCULCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 07:02:42 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 5FA5077D15F
	for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 12:02:39 +0100 (CET)
Message-Id: <4bde6edb48bad767730b7f909cd61c1ec5bd5ff0.1395397665.git.moinejf@free.fr>
In-Reply-To: <cover.1395397665.git.moinejf@free.fr>
References: <cover.1395397665.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 21 Mar 2014 10:31:45 +0100
Subject: [PATCH RFC v2 5/6] drm/tilcd: dts: Remove unused slave description
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	dri-devel@lists.freedesktop.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tda998x being converted to a normal DRM encoder/connector,
there is no slave notion anymore.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/drm/tilcdc/slave.txt | 18 ------------------
 1 file changed, 18 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/drm/tilcdc/slave.txt

diff --git a/Documentation/devicetree/bindings/drm/tilcdc/slave.txt b/Documentation/devicetree/bindings/drm/tilcdc/slave.txt
deleted file mode 100644
index 3d2c524..0000000
--- a/Documentation/devicetree/bindings/drm/tilcdc/slave.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-Device-Tree bindings for tilcdc DRM encoder slave output driver
-
-Required properties:
- - compatible: value should be "ti,tilcdc,slave".
- - i2c: the phandle for the i2c device the encoder slave is connected to
-
-Recommended properties:
- - pinctrl-names, pinctrl-0: the pincontrol settings to configure
-   muxing properly for pins that connect to TFP410 device
-
-Example:
-
-	hdmi {
-		compatible = "ti,tilcdc,slave";
-		i2c = <&i2c0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
-	};
-- 
1.9.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:60491 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559AbaCULBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 07:01:54 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 836AE2C9EB
	for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 12:01:51 +0100 (CET)
Message-Id: <2ad6cd1afa7800826da991ae522ef54368fe8d78.1395397665.git.moinejf@free.fr>
In-Reply-To: <cover.1395397665.git.moinejf@free.fr>
References: <cover.1395397665.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 21 Mar 2014 10:48:43 +0100
Subject: [PATCH RFC v2 1/6] drm/i2c: tda998x: Add the required port property
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	dri-devel@lists.freedesktop.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the media video interface, the video source and sink
ports must be identified by mutual phandles.

This patch adds the 'port' property of the tda998x (sink side).

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index e3f3d65..10c5b5e 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -17,13 +17,22 @@ Optional properties:
   - video-ports: 24 bits value which defines how the video controller
 	output is wired to the TDA998x input - default: <0x230145>
 
+Required nodes:
+  - port: reference of the video source as described in media/video-interfaces
+
 Example:
 
-	tda998x: hdmi-encoder {
+	hdmi: hdmi-encoder {
 		compatible = "nxp,tda19988";
 		reg = <0x70>;
 		interrupt-parent = <&gpio0>;
 		interrupts = <27 2>;		/* falling edge */
 		pinctrl-0 = <&pmx_camera>;
 		pinctrl-names = "default";
+
+		port {
+			hdmi_0: endpoint@0 {
+				remote-endpoint = <&lcd0_0>;
+			};
+		};
 	};
-- 
1.9.1


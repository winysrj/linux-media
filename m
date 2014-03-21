Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:52334 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836AbaCULCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 07:02:14 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id DD5B0D12BD6
	for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 12:02:10 +0100 (CET)
Message-Id: <c4ed6b6a68b7445ed8625b07596c2e8e0879f809.1395397665.git.moinejf@free.fr>
In-Reply-To: <cover.1395397665.git.moinejf@free.fr>
References: <cover.1395397665.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 21 Mar 2014 10:31:45 +0100
Subject: [PATCH RFC v2 3/6] drm/tilcd: dts: Add the video output port
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	dri-devel@lists.freedesktop.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The connection between the video source and sink must follow
the media video interface.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt b/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
index fff10da..d0de848 100644
--- a/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
+++ b/Documentation/devicetree/bindings/drm/tilcdc/tilcdc.txt
@@ -18,6 +18,12 @@ Optional properties:
  - max-pixelclock: The maximum pixel clock that can be supported
    by the lcd controller in KHz.
 
+Optional nodes:
+
+ - port: reference of the video sink as described in media/video-interfaces.
+   This reference is required when the video sink is the TDA19988 HDMI
+   transmitter.
+
 Example:
 
 	fb: fb@4830e000 {
@@ -27,3 +33,11 @@ Example:
 		interrupts = <36>;
 		ti,hwmods = "lcdc";
 	};
+
+	&fb {
+		port {
+			lcd_0: endpoint@0 {
+				remote-endpoint = <&hdmi_0>;
+			};
+		};
+	};
-- 
1.9.1


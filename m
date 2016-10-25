Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35748 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbcJYXzm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 19:55:42 -0400
Received: by mail-pf0-f174.google.com with SMTP id s8so127628021pfj.2
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 16:55:42 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 4/6] ARM: dts: davinci: da850-lcdk: enable VPIF capture
Date: Tue, 25 Oct 2016 16:55:34 -0700
Message-Id: <20161025235536.7342-5-khilman@baylibre.com>
In-Reply-To: <20161025235536.7342-1-khilman@baylibre.com>
References: <20161025235536.7342-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable video capture via the on-board TVP5147 decoder hooked up to ch0
one of the VPIF capture input.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 arch/arm/boot/dts/da850-lcdk.dts | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/da850-lcdk.dts b/arch/arm/boot/dts/da850-lcdk.dts
index 7b8ab21fed6c..ef3c2aa1b619 100644
--- a/arch/arm/boot/dts/da850-lcdk.dts
+++ b/arch/arm/boot/dts/da850-lcdk.dts
@@ -138,6 +138,24 @@
 		reg = <0x18>;
 		status = "okay";
 	};
+
+	tvp5147@5d {
+		compatible = "ti,tvp5147";
+		reg = <0x5d>;
+		status = "okay";
+
+		port {
+			composite: endpoint {
+				hsync-active = <1>;
+				vsync-active = <1>;
+				pclk-sample = <0>;
+
+				/* VPIF channel 0 (lower 8-bits) */
+				remote-endpoint = <&vpif_ch0>;
+				bus-width = <8>;
+			};
+		};		
+	};
 };
 
 &mcasp0 {
@@ -219,3 +237,15 @@
 		};
 	};
 };
+
+&vpif {
+	status = "okay";
+};
+
+&vpif_capture {
+	status = "okay";
+};
+
+&vpif_ch0 {
+	remote-endpoint = <&composite>;
+};
-- 
2.9.3


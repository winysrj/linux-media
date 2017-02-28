Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:34780 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbdB1QRy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 11:17:54 -0500
Received: by mail-wr0-f181.google.com with SMTP id l37so12217851wrc.1
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 08:17:53 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 1/2] media: dt-bindings: vpif: fix whitespace errors
Date: Tue, 28 Feb 2017 17:08:53 +0100
Message-Id: <1488298134-6200-2-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1488298134-6200-1-git-send-email-bgolaszewski@baylibre.com>
References: <1488298134-6200-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The examples have been copied from the DT with whitespace errors. Fix
them.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/ti,da850-vpif.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
index 6d25d7f..9c7510b 100644
--- a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
+++ b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
@@ -30,15 +30,15 @@ I2C-connected TVP5147 decoder:
 
 		port {
 			vpif_ch0: endpoint@0 {
-				  reg = <0>;
-				  bus-width = <8>;
-				  remote-endpoint = <&composite>;
+				reg = <0>;
+				bus-width = <8>;
+				remote-endpoint = <&composite>;
 			};
 
 			vpif_ch1: endpoint@1 {
-				  reg = <1>;
-				  bus-width = <8>;
-				  data-shift = <8>;
+				reg = <1>;
+				bus-width = <8>;
+				data-shift = <8>;
 			};
 		};
 	};
-- 
2.9.3

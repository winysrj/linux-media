Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35861 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755373AbdBGQmE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 11:42:04 -0500
Received: by mail-wm0-f51.google.com with SMTP id c85so168569997wmi.1
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 08:41:53 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 02/10] ARM: dts: da850-evm: fix whitespace errors
Date: Tue,  7 Feb 2017 17:41:15 +0100
Message-Id: <1486485683-11427-3-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/boot/dts/da850-evm.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c970b6e..94938a3 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -301,14 +301,14 @@
 	/* VPIF capture port */
 	port {
 		vpif_ch0: endpoint@0 {
-			  reg = <0>;
-			  bus-width = <8>;
+			reg = <0>;
+			bus-width = <8>;
 		};
 
 		vpif_ch1: endpoint@1 {
-			  reg = <1>;
-			  bus-width = <8>;
-			  data-shift = <8>;
+			reg = <1>;
+			bus-width = <8>;
+			data-shift = <8>;
 		};
 	};
 };
-- 
2.9.3


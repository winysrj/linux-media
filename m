Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38917 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754775AbeEZOed (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 10:34:33 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] media: dt: bindings: tegra-vde: Document new optional Memory Client reset property
Date: Sat, 26 May 2018 17:33:55 +0300
Message-Id: <20180526143355.24288-1-digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recently binding of the Memory Controller has been extended, exposing
the Memory Client reset controls and hence it is now a reset controller.
Tegra video-decoder device is among the Memory Controller reset users,
document the new optional VDE HW reset property.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 .../devicetree/bindings/media/nvidia,tegra-vde.txt    | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt b/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
index 470237ed6fe5..7302e949e662 100644
--- a/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
+++ b/Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
@@ -27,9 +27,15 @@ Required properties:
   - sxe
 - clocks : Must include the following entries:
   - vde
-- resets : Must include the following entries:
+- resets : Must contain an entry for each entry in reset-names.
+- reset-names : Should include the following entries:
   - vde
 
+Optional properties:
+- resets : Must contain an entry for each entry in reset-names.
+- reset-names : Must include the following entries:
+  - mc
+
 Example:
 
 video-codec@6001a000 {
@@ -51,5 +57,6 @@ video-codec@6001a000 {
 		     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
 	interrupt-names = "sync-token", "bsev", "sxe";
 	clocks = <&tegra_car TEGRA20_CLK_VDE>;
-	resets = <&tegra_car 61>;
+	reset-names = "vde", "mc";
+	resets = <&tegra_car 61>, <&mc TEGRA20_MC_RESET_VDE>;
 };
-- 
2.17.0

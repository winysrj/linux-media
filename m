Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50228 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752847AbeCWM7X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:59:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/3] arm64: dts: meson-gx.dtsi: add cec-disable
Date: Fri, 23 Mar 2018 13:59:15 +0100
Message-Id: <20180323125915.13986-4-hverkuil@xs4all.nl>
In-Reply-To: <20180323125915.13986-1-hverkuil@xs4all.nl>
References: <20180323125915.13986-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The meson-gx boards have two CEC controllers: the DesignWare controller
and a meson-specific controller. Disable the DW controller since the
CEC line is hooked up to the meson controller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 4ee2e7951482..4e2567012335 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -544,6 +544,7 @@
 			interrupts = <GIC_SPI 57 IRQ_TYPE_EDGE_RISING>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			cec-disable;
 			status = "disabled";
 
 			/* VPU VENC Input */
-- 
2.15.1

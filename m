Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BB9C43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 18:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 369EF22373
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 18:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfAESmK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:42:10 -0500
Received: from kozue.soulik.info ([108.61.200.231]:40306 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfAESmJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2019 13:42:09 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:a00])
        by kozue.soulik.info (Postfix) with ESMTPA id 11D92101829;
        Sun,  6 Jan 2019 03:32:45 +0900 (JST)
From:   Randy Li <ayaka@soulik.info>
To:     linux-rockchip@lists.infradead.org
Cc:     Randy Li <ayaka@soulik.info>, nicolas.dufresne@collabora.com,
        myy@miouyouyou.fr, paul.kocialkowski@bootlin.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] arm64: dts: rockchip: add video codec for rk3399
Date:   Sun,  6 Jan 2019 02:31:50 +0800
Message-Id: <20190105183150.20266-5-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190105183150.20266-1-ayaka@soulik.info>
References: <20190105183150.20266-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It offers an example how a full features video codec
should be configured.

The original clocks assignment don't look good, if the clocks
lower than 300MHZ, most of decoing tasks would suffer from
timeout problem, 500MHZ is also a little high for RK3399
running in a stable state.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 .../boot/dts/rockchip/rk3399-sapphire.dtsi    | 29 ++++++++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      | 68 +++++++++++++++++--
 2 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
index 946d3589575a..c3db878bae45 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
@@ -632,6 +632,35 @@
 	dr_mode = "host";
 };
 
+&rkvdec {
+	status = "okay";
+};
+
+&rkvdec_srv {
+	status = "okay";
+};
+
+&vdec_mmu {
+	status = "okay";
+};
+
+&vdpu {
+	status = "okay";
+};
+
+&vepu {
+	status = "okay";
+};
+
+&vpu_service {
+	status = "okay";
+};
+
+&vpu_mmu {
+	status = "okay";
+
+};
+
 &vopb {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index b22b2e40422b..5fa3247e7bf0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1242,16 +1242,39 @@
 		status = "disabled";
 	};
 
-	vpu: video-codec@ff650000 {
-		compatible = "rockchip,rk3399-vpu";
-		reg = <0x0 0xff650000 0x0 0x800>;
-		interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH 0>,
-			     <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH 0>;
-		interrupt-names = "vepu", "vdpu";
+	vpu_service: vpu-srv {
+		compatible = "rockchip,mpp-service";
+		status = "disabled";
+	};
+
+	vepu: vpu-encoder@ff650000 {
+		compatible = "rockchip,vpu-encoder-v2";
+		reg = <0x0 0xff650000 0x0 0x400>;
+		interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH 0>;
+		interrupt-names = "irq_enc";
 		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
-		clock-names = "aclk", "hclk";
+		clock-names = "aclk_vcodec", "hclk_vcodec";
+		resets = <&cru SRST_H_VCODEC>, <&cru SRST_A_VCODEC>;
+		reset-names = "video_h", "video_a";
 		iommus = <&vpu_mmu>;
 		power-domains = <&power RK3399_PD_VCODEC>;
+		rockchip,srv = <&vpu_service>;
+		status = "disabled";
+	};
+
+	vdpu: vpu-decoder@ff650400 {
+		compatible = "rockchip,vpu-decoder-v2";
+		reg = <0x0 0xff650400 0x0 0x400>;
+		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH 0>;
+		interrupt-names = "irq_dec";
+		iommus = <&vpu_mmu>;
+		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
+		clock-names = "aclk_vcodec", "hclk_vcodec";
+		resets = <&cru SRST_H_VCODEC>, <&cru SRST_A_VCODEC>;
+		reset-names = "video_h", "video_a";
+		power-domains = <&power RK3399_PD_VCODEC>;
+		rockchip,srv = <&vpu_service>;
+		status = "disabled";
 	};
 
 	vpu_mmu: iommu@ff650800 {
@@ -1261,11 +1284,42 @@
 		interrupt-names = "vpu_mmu";
 		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
 		clock-names = "aclk", "iface";
+		assigned-clocks = <&cru ACLK_VCODEC_PRE>;
+		assigned-clock-parents = <&cru PLL_GPLL>;
 		#iommu-cells = <0>;
 		power-domains = <&power RK3399_PD_VCODEC>;
 		status = "disabled";
 	};
 
+	rkvdec_srv: rkvdec-srv {
+		compatible = "rockchip,mpp-service";
+		status = "disabled";
+	};
+
+	rkvdec: video-decoder@ff660000 {
+		compatible = "rockchip,video-decoder-v1";
+		reg = <0x0 0xff660000 0x0 0x400>;
+		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH 0>;
+		interrupt-names = "irq_dec";
+		clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>,
+			 <&cru SCLK_VDU_CA>, <&cru SCLK_VDU_CORE>;
+		clock-names = "aclk_vcodec", "hclk_vcodec",
+			      "clk_cabac", "clk_core";
+		assigned-clocks = <&cru ACLK_VDU_PRE>, <&cru SCLK_VDU_CA>,
+				  <&cru SCLK_VDU_CORE>;
+		assigned-clock-parents = <&cru PLL_NPLL>, <&cru PLL_NPLL>,
+					 <&cru PLL_NPLL>;
+		resets = <&cru SRST_H_VDU>, <&cru SRST_A_VDU>,
+			 <&cru SRST_VDU_CORE>, <&cru SRST_VDU_CA>,
+			 <&cru SRST_A_VDU_NOC>, <&cru SRST_H_VDU_NOC>;
+		reset-names = "video_h", "video_a", "video_core", "video_cabac",
+			      "niu_a", "niu_h";
+		power-domains = <&power RK3399_PD_VDU>;
+		rockchip,srv = <&rkvdec_srv>;
+		iommus = <&vdec_mmu>;
+		status = "disabled";
+	};
+
 	vdec_mmu: iommu@ff660480 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff660480 0x0 0x40>, <0x0 0xff6604c0 0x0 0x40>;
-- 
2.20.1


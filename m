Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09A4C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B877720835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfCGKKD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:10:03 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:39494 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfCGKKD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 05:10:03 -0500
Received: from randy.li?rock-chips.com (unknown [192.168.167.139])
        by regular1.263xmail.com (Postfix) with ESMTP id 9929A29F;
        Thu,  7 Mar 2019 18:03:33 +0800 (CST)
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ADDR-CHECKED4: 1
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from randy-pc.lan (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P17008T140071111993088S1551952999924990_;
        Thu, 07 Mar 2019 18:03:32 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <2570fe3db80530bcfee662caed67e8d4>
X-RL-SENDER: randy.li@rock-chips.com
X-SENDER: randy.li@rock-chips.com
X-LOGIN-NAME: randy.li@rock-chips.com
X-FST-TO: linux-media@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Randy Li <randy.li@rock-chips.com>
To:     linux-media@vger.kernel.org
Cc:     Randy Li <ayaka@soulik.info>, hverkuil@xs4all.nl,
        maxime.ripard@bootlin.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, jernej.skrabec@gmail.com,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        linux-rockchip@lists.infradead.org, thomas.petazzoni@bootlin.com,
        mchehab@kernel.org, ezequiel@collabora.com,
        linux-arm-kernel@lists.infradead.org, posciak@chromium.org,
        groeck@chromium.org
Subject: [PATCH v2 1/6] arm64: dts: rockchip: add power domain to iommu
Date:   Thu,  7 Mar 2019 18:03:11 +0800
Message-Id: <20190307100316.925-2-randy.li@rock-chips.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190307100316.925-1-randy.li@rock-chips.com>
References: <20190307100316.925-1-randy.li@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Randy Li <ayaka@soulik.info>

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 84f14b132e8f..117d02e21932 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -581,6 +581,7 @@
 		clocks = <&cru ACLK_H265>, <&cru PCLK_H265>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3328_PD_HEVC>;
 		status = "disabled";
 	};
 
@@ -592,6 +593,7 @@
 		clocks = <&cru ACLK_VPU>, <&cru HCLK_VPU>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3328_PD_HEVC>;
 		status = "disabled";
 	};
 
@@ -603,6 +605,7 @@
 		clocks = <&cru ACLK_VPU>, <&cru HCLK_VPU>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3328_PD_VPU>;
 		status = "disabled";
 	};
 
@@ -614,6 +617,7 @@
 		clocks = <&cru ACLK_RKVDEC>, <&cru HCLK_RKVDEC>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3328_PD_VIDEO>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index db9d948c0b03..23d061ab6fa6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1263,6 +1263,7 @@
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
 		power-domains = <&power RK3399_PD_VCODEC>;
+		status = "disabled";
 	};
 
 	vdec_mmu: iommu@ff660480 {
@@ -1273,6 +1274,7 @@
 		clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3399_PD_VDU>;
 		status = "disabled";
 	};
 
-- 
2.20.1




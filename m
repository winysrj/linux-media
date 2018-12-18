Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E76C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08169217D9
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="Daz3Z2Cb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbeLRLdj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 06:33:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36180 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbeLRLdj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 06:33:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so14566228wrp.3
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 03:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+sX38c9cSRrT/+P6z3U+yEFrwV+FCNRU4fj085KJck=;
        b=Daz3Z2CbrjYCumy+Eqh2CqsYQUlio7x77xnlCkFvlQzhYqTeyM5/3diED7Sk84EP0R
         Xv6wbnedSLBYVpo5/1MiA9XcBIh9tr/Sp/HORQlo4QlctfBPGFbbQkTXYXmrJ5pIC/C5
         /aS5XQrPFGWi5VfipfDT2KaGaaZamoZLW763A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+sX38c9cSRrT/+P6z3U+yEFrwV+FCNRU4fj085KJck=;
        b=Snpy12Z8m7TX2kuKrEPK/lMalrpnhUiY/ATtuHjtB8K7hN7OMyrfO2S1d3garC6Mup
         a0AhOeAOmJuCz4JzO8hyinfsHaSD0y6Z7AQRLqw7/Hk3XhtPedHFGQa/u4cNbN0a+wWa
         5Txo9z2wKIcKOawspiaOQrEeIId7Bvt1qVr0CJNEzqZtYGxVCgU3nhkcGJrc0gYamZhW
         k812viDecla0xlHoApd94IBNdehauFz/q2zcXheW33rhgV3vDnxue5tYaK33pyiVZNIN
         biaKI8kaZx8UKa6JQc+OaBEK6zbxp2lz9fn5I+Oy6UotsCdgHF5qlV+D9bF6/Nll5HqX
         w4Zw==
X-Gm-Message-State: AA+aEWbDNM9Up57s4vJlfOkA1PnVcZmSYCGdLhxkXPDIzb1pQZggh42S
        lT6nsTvm+08IXj98k9rSHBRUXg==
X-Google-Smtp-Source: AFSGD/WspVm6YDUKba0CozH4fVWLussP009ueuQyQktjSzku+Avc02vHsbBhCh6VwWlyWLmZc/DMNw==
X-Received: by 2002:adf:bc87:: with SMTP id g7mr13685629wrh.250.1545132817098;
        Tue, 18 Dec 2018 03:33:37 -0800 (PST)
Received: from jagan-XPS-13-9350.homenet.telecomitalia.it (host230-181-static.228-95-b.business.telecomitalia.it. [95.228.181.230])
        by smtp.gmail.com with ESMTPSA id h2sm4276184wrv.87.2018.12.18.03.33.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 03:33:36 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Cc:     Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v4 4/6] arm64: dts: allwinner: a64: Add A64 CSI controller
Date:   Tue, 18 Dec 2018 17:03:18 +0530
Message-Id: <20181218113320.4856-5-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181218113320.4856-1-jagan@amarulasolutions.com>
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add dts node details for Allwinner A64 CSI controller.

A64 CSI has similar features as like in H3, but the CSI_SCLK
need to update it to 300MHz than default clock rate.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 384c417cb7a2..89a0deb3fe6a 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -532,6 +532,12 @@
 			interrupt-controller;
 			#interrupt-cells = <3>;
 
+			csi_pins: csi-pins {
+				pins = "PE0", "PE2", "PE3", "PE4", "PE5", "PE6",
+				       "PE7", "PE8", "PE9", "PE10", "PE11";
+				function = "csi0";
+			};
+
 			i2c0_pins: i2c0_pins {
 				pins = "PH0", "PH1";
 				function = "i2c0";
@@ -899,6 +905,20 @@
 			status = "disabled";
 		};
 
+		csi: csi@1cb0000 {
+			compatible = "allwinner,sun50i-a64-csi";
+			reg = <0x01cb0000 0x1000>;
+			interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CSI>,
+				 <&ccu CLK_CSI_SCLK>,
+				 <&ccu CLK_DRAM_CSI>;
+			clock-names = "bus", "mod", "ram";
+			resets = <&ccu RST_BUS_CSI>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&csi_pins>;
+			status = "disabled";
+		};
+
 		hdmi: hdmi@1ee0000 {
 			compatible = "allwinner,sun50i-a64-dw-hdmi",
 				     "allwinner,sun8i-a83t-dw-hdmi";
-- 
2.18.0.321.gffc6fa0e3


Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF59C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0582084A
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="KuwjOwsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732783AbeLTMzQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:55:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39255 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732694AbeLTMy6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:54:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id f81so2047420wmd.4
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 04:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+sX38c9cSRrT/+P6z3U+yEFrwV+FCNRU4fj085KJck=;
        b=KuwjOwszek352TtFJBBl/n/MzUH512/y0qTe+7lojuswGP/Lv1jUTJ+XBHt+h1OjXC
         Tkidz7Ho42OTctg0z04xNW5UbNEPscNSxUV65OjfFECCb3QGy3mQM5wO+4DPkeYcvjZ4
         MqjQ9TS0onrxr8FvALPrJ5IwcnL33MRBhTXk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+sX38c9cSRrT/+P6z3U+yEFrwV+FCNRU4fj085KJck=;
        b=b/ABZlniazuBMuydK9c7C1tKTnlbEY4e6wrZ4nHAZ1uWgdLspjeuy3Eo0c2ma9Tsr4
         cF4WDpmUBQRUvRleRlomYa793nzhR918pDSbIglxRrSDezHaR5Cx7OKtwvg4UvU/ypGV
         9nlCGdT4MQqudu4Lmuh1ExgQk1gblv0QcmMwIuEhDCNbOJ2y06IGuk1lZSS59Kb3iBh8
         AK3fpcixipfpbFNQZK67xCHb/ORs3b4Y17Rkrg+ldT1Piv7foCPPfgjw0AZ/rD8PEEq9
         xVC9PtqkvrK8EngMWQvGwrUvRqHc3Cd8mW59v7ThlKQUzu0MNe8HDXkQO50AbvdHJBeT
         CmPw==
X-Gm-Message-State: AA+aEWb6uezMVhxSmhQKSr4QtMYw9IMraYCvyuncNNv0F/l39A7ByRtZ
        gL2HSmjWJyPUHB2wJPcvoGiC4w==
X-Google-Smtp-Source: AFSGD/UrUUuEeGEqMJRANi0h2sU7UVGWvEG7qvhB+ZIFZAHUbiColEvrk/bJTB3CDLaWfH2J6q5zYw==
X-Received: by 2002:a1c:864f:: with SMTP id i76mr11106358wmd.83.1545310496157;
        Thu, 20 Dec 2018 04:54:56 -0800 (PST)
Received: from localhost.localdomain (ip-163-240.sn-213-198.clouditalia.com. [213.198.163.240])
        by smtp.gmail.com with ESMTPSA id o4sm8732756wrq.66.2018.12.20.04.54.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 04:54:55 -0800 (PST)
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
Subject: [PATCH v5 4/6] arm64: dts: allwinner: a64: Add A64 CSI controller
Date:   Thu, 20 Dec 2018 18:24:36 +0530
Message-Id: <20181220125438.11700-5-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181220125438.11700-1-jagan@amarulasolutions.com>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
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


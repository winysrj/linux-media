Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD432C43444
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E84520850
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="BOT5yj4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfARQc1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 11:32:27 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44674 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbfARQc1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 11:32:27 -0500
Received: by mail-pl1-f193.google.com with SMTP id e11so6561621plt.11
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 08:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+sX38c9cSRrT/+P6z3U+yEFrwV+FCNRU4fj085KJck=;
        b=BOT5yj4SiYAdnYRezu4yjMSiTlvfURCMj4ohbXl2IXk8ffciuJuhOqNxnM5mwP/O/F
         eFs93GPSqS7yLA+UJuA3Rig58hAoh2HVBTJsq1cXCyD39afYxfsv2OChziv7DJIr/lzw
         XaSSd95lZvgpuCrTtYfL21yFm8I3WSKr4sivk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+sX38c9cSRrT/+P6z3U+yEFrwV+FCNRU4fj085KJck=;
        b=r18tdgkOh5dP2h356clwQvRVF4V9qj8jQWPH0UFieG2oKlE3DFeNOWlfzdcLS/dOt7
         jpistYPAMsGC4ZzqBx+cIwILcmjC7PKz74Le/UeLDGx01La/NhfIzy7X1hPsYjz3CqHp
         aA6aeGng8owD7s8wLP7JDw+wNNYburZDMtzZGym5RlWzSZultRd84xvVdIuUioZezk/w
         jm+UfR/YHET7Vhk2ua6RSBGnNjvT9jSRIEqmF0cf+7LSorhmLbqOrz7lz5y7BSXUuxis
         mJTUIXZa2ZUjqKsMnWnxD/e7X+0pz6tC9IUIM9LC1j5WEHWQiWdIod85eOCXa9BxFmV0
         mSNw==
X-Gm-Message-State: AJcUukcxTgA9ZKYv/9hcm02YvxjkUODneSdX2YI+iQZxuaABCaSIf5+Q
        9iB4iyksFispYz5xfPaP3CV4vA==
X-Google-Smtp-Source: ALg8bN6gUBJ+7iGXSQUxxUbdwmpgQGNe7/aliT7vjp+kpzoRLnlBQGxv5QF7w6rkQfdNmN7QooHqDQ==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr20087932pll.280.1547829146030;
        Fri, 18 Jan 2019 08:32:26 -0800 (PST)
Received: from jagan-XPS-13-9350.domain.name ([103.81.77.13])
        by smtp.gmail.com with ESMTPSA id z13sm13967086pgf.84.2019.01.18.08.32.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 08:32:25 -0800 (PST)
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
Subject: [PATCH v6 4/6] arm64: dts: allwinner: a64: Add A64 CSI controller
Date:   Fri, 18 Jan 2019 22:01:56 +0530
Message-Id: <20190118163158.21418-5-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190118163158.21418-1-jagan@amarulasolutions.com>
References: <20190118163158.21418-1-jagan@amarulasolutions.com>
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


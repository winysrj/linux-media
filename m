Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2430EC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85802082C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="DmmYfIN+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfAXSIf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:08:35 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36749 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbfAXSIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 13:08:34 -0500
Received: by mail-pl1-f195.google.com with SMTP id g9so3250186plo.3
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 10:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NEU2q7n4hfFLUiueQNI1eh+ct5ZyqUAqwbpoXVCvd3w=;
        b=DmmYfIN+j9ZEn9AycYhh+oQLaiMR+WzLL6ulCg8pbm+6zc5hWK3SnV745n8gpHX5yI
         aWXPeS9W76canA/iD6sWdIDGOidx4AoConbrLTc8kAA+Hzl+jPokuq1XeTTJqd7YQGri
         fwpq2odXSNDCmVn75UxdLTbuN3oliSA0ZYhYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEU2q7n4hfFLUiueQNI1eh+ct5ZyqUAqwbpoXVCvd3w=;
        b=mQAZTfvXK5v7Q1M+Er9PiQWlw/JoOU3JYmZXfdkCkzbisC0lMpj7TMfauGi2euP8Wc
         uss52CCZWq5E/BPpkuMlJRcHdp3DcK9qP6WUpbSG+TNHWo64Tvk7VAKF9oqTU5IQK+Qs
         P/8VeBy5s0DmiLNjKCXZZeEolIqN5NXYVtVe60YNjJ0T8l1p8CnpVHQCjTbDQVNoBs+x
         soQXsLL/jPGq2mLEkk/gURenLJ3yOcj6GtuRGI+7gEyoHRPd7OfCtTBRvwhEFj/r2qWe
         ZNC8/cboYnCSRKMwmuz6x5nYxMz1Jg4ocoYatbJHOByjxHr8Nz99MENPekDhgy/0+nB5
         UPdA==
X-Gm-Message-State: AJcUukdwMwFkheWD89pdIdIcElrQV4Va+aWWjPUR0n4hK4FKv3JDeJfu
        zlMR7p0BIbbXcscxugpXpvrVrg==
X-Google-Smtp-Source: ALg8bN5m1LCpFgDwm/rki6V7Cb60EEp+UcVRffG3MI8h8p1Nqbwy+jaBiydaG6pEp2rSv+/zh5ZrEw==
X-Received: by 2002:a17:902:e08b:: with SMTP id cb11mr7603740plb.263.1548353313969;
        Thu, 24 Jan 2019 10:08:33 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id k15sm36141551pfb.147.2019.01.24.10.08.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:08:33 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v7 3/5] arm64: dts: allwinner: a64: Add A64 CSI controller
Date:   Thu, 24 Jan 2019 23:37:34 +0530
Message-Id: <20190124180736.28408-4-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190124180736.28408-1-jagan@amarulasolutions.com>
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
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
index 839b2ae88583..62fdf850e9e5 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -558,6 +558,12 @@
 			interrupt-controller;
 			#interrupt-cells = <3>;
 
+			csi_pins: csi-pins {
+				pins = "PE0", "PE2", "PE3", "PE4", "PE5", "PE6",
+				       "PE7", "PE8", "PE9", "PE10", "PE11";
+				function = "csi";
+			};
+
 			i2c0_pins: i2c0_pins {
 				pins = "PH0", "PH1";
 				function = "i2c0";
@@ -925,6 +931,20 @@
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


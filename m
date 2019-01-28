Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0C8C282CB
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1AE207E0
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="D9kwqx0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfA1I7X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:59:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32825 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfA1I7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:59:22 -0500
Received: by mail-pf1-f194.google.com with SMTP id c123so7735596pfb.0
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 00:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l1wfLgujgeuZczNshXAScoRmDfNsjZImKyg0sqbb6WQ=;
        b=D9kwqx0+n9UCEQOF57p+dnzkz1HptMTPz1SC40cEyM3KPhhGBbl6551yP3I0ZOa23T
         SX0gem8k9Ei9bbGuZnolmLw74DFmQCj2P6P/8kjz/Ar+1n1qAELjcfHyuHb69BMt0uKz
         RcGQyiA5NVQ7FRl6UKZVxSNHlE7zj/dbbnIq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l1wfLgujgeuZczNshXAScoRmDfNsjZImKyg0sqbb6WQ=;
        b=GKjmjvMycxL+DPjceFePZwiirUDZ0aBanNpdFz7R7DCOi+6+8EKkEoT+lZikrCUGMn
         lqbkBKdOpKSFeCT3l+yM50yRiJDgQXh2vlWh9pAdCT77Wy4i2E820LKXRSfz3ZUwrD4G
         AI63vccVFWYQzjCuV9o5LiZx7k/mm8/blUkuMyEujzBq1Tc8dAIW5X0FFaEOjQ6DidGd
         pNvU0VxQlEewsfmHcpVgpE2W49RdZdLW8wNRPtVCc8vwdS+BKvT22C0fNyd848MDuabo
         Y2ESL08rIRpVE303my9xfZqCesq350ia+kbDwtWAgc3OgzB9vsSXhbmh3bwU0myIXRSr
         C5BA==
X-Gm-Message-State: AJcUukfDwL+FClLRdRHbb6LZQrrnVnNbDr3+EveQKU0U+KIi/V91+R6y
        Ay5pY/PLmimjWJkpzfXjDNR9LsDzwS8=
X-Google-Smtp-Source: ALg8bN60G3iWcaN0qeakuA7SmJvk++xY3zrbUBvaL+dEVHIt8C+6GOkIidGzubH/4MW8HhOn5IiEPQ==
X-Received: by 2002:a62:b9a:: with SMTP id 26mr21296962pfl.196.1548665961985;
        Mon, 28 Jan 2019 00:59:21 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id o189sm60746245pfg.117.2019.01.28.00.59.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 00:59:21 -0800 (PST)
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
Subject: [PATCH v8 3/5] arm64: dts: allwinner: a64: Add A64 CSI controller
Date:   Mon, 28 Jan 2019 14:28:45 +0530
Message-Id: <20190128085847.7217-4-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190128085847.7217-1-jagan@amarulasolutions.com>
References: <20190128085847.7217-1-jagan@amarulasolutions.com>
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
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
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


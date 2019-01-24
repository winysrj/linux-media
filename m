Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6965C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A12DF20855
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="Oj30xNCX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbfAXSIq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:08:46 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40534 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbfAXSIp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 13:08:45 -0500
Received: by mail-pg1-f193.google.com with SMTP id z10so2992612pgp.7
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 10:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4/D2cAWnRzrJOJe1TanX2r7wfgl9u+SIbHxZ8xAtowY=;
        b=Oj30xNCXACwjON7pD0Bgw7Au2iw7v1jMHRdbIy8hx7JhUUGjKhUIHiBQTlRwog6Z4C
         C1HAgPAPyVaU9BzW531tXzwC5Ti5lmsz47SYdloJMAFsTU+ecMUqXtTMQO81izpEjXYy
         cbUm/mbqwjj9KilvecdtOlCRc3RJ+N42M+j7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4/D2cAWnRzrJOJe1TanX2r7wfgl9u+SIbHxZ8xAtowY=;
        b=XrsGjvLFhqkZeNk399kJgTowSNMkQ+ejdFIKd05fhO49Yc1+6A/M0GtwYVbIfbWrKA
         /WaG0MryMW1MCZxxmtdkKOe7e6wI30yL4mjXs4HDKWRB+ab2UqSz+H+buOUU+mzTVpQu
         owpeOtHv7xYYzyeSfBTulyJU/ywHtblxQxdZarLHhtFPHD2M4AXoOefGsSTcNOlLt4HY
         EuZCLrX/GczdaL1tg8cCZK7JjQjH5E4jzWsLNGUVsAHe9bO9WLfWt0c2SFtZVS0+ys6W
         vKz4ywnHp7H6NXRdcDwHDrJoB+fChfa9L/2CQ6E1MIynkv58x4U7plucYnMy110An0ty
         7Isw==
X-Gm-Message-State: AJcUukf90n1Iz4iZYIVBQJkFukC0MdcjN3HahPfPr+cNqRulhpq3ifsT
        bhWF/fC+pNNP1h9vyBGTmwNMFA==
X-Google-Smtp-Source: ALg8bN6jX3zIxrphpAJdpuzJfSXAW87U5y3pOGjqqs4aZnsi2ozeVQfCI4IQpvET60uLq/1DQdj/fA==
X-Received: by 2002:a63:2054:: with SMTP id r20mr6808062pgm.328.1548353324624;
        Thu, 24 Jan 2019 10:08:44 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id k15sm36141551pfb.147.2019.01.24.10.08.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:08:43 -0800 (PST)
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
Subject: [DO NOT MERGE] [PATCH v7 5/5] arm64: dts: allwinner: bananapi-m64: Add HDF5640 camera module
Date:   Thu, 24 Jan 2019 23:37:36 +0530
Message-Id: <20190124180736.28408-6-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190124180736.28408-1-jagan@amarulasolutions.com>
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Bananapi M64 comes with an optional sensor based on the ov5640,
add support for it with below pin information.

- PE13, PE12 via i2c-gpio bitbanging
- CLK_CSI_MCLK as external clock
- PE1 as external clock pin muxing
- DLDO3 as AVDD supply
- ALDO1 as DOVDD supply
- ELDO3 as DVDD supply
- PE16 gpio for reset pin
- PE17 gpio for powerdown pin

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 .../dts/allwinner/sun50i-a64-bananapi-m64.dts | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
index 9d0afd7d50ec..c99f66271287 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
@@ -60,6 +60,41 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	i2c-csi {
+		compatible = "i2c-gpio";
+		sda-gpios = <&pio 4 13 GPIO_ACTIVE_HIGH>; /* CSI0-SDA: PE13 */
+		scl-gpios = <&pio 4 12 GPIO_ACTIVE_HIGH>; /* CSI0-SCK: PE12 */
+		i2c-gpio,delay-us = <5>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ov5640: camera@3c {
+			compatible = "ovti,ov5640";
+			reg = <0x3c>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&csi_mclk_pin>;
+			clocks = <&ccu CLK_CSI_MCLK>;
+			clock-names = "xclk";
+
+			AVDD-supply = <&reg_dldo3>;
+			DOVDD-supply = <&reg_aldo1>;
+			DVDD-supply = <&reg_eldo3>;
+			reset-gpios = <&pio 4 16 GPIO_ACTIVE_LOW>; /* CSI0-RST: PE16 */
+			powerdown-gpios = <&pio 4 17 GPIO_ACTIVE_HIGH>; /* CSI0-PWDN: PE17 */
+
+			port {
+				ov5640_ep: endpoint {
+					remote-endpoint = <&csi_ep>;
+					bus-width = <8>;
+					hsync-active = <1>; /* Active high */
+					vsync-active = <0>; /* Active low */
+					data-active = <1>;  /* Active high */
+					pclk-sample = <1>;  /* Rising */
+				};
+			};
+		};
+	};
+
 	hdmi-connector {
 		compatible = "hdmi-connector";
 		type = "a";
@@ -108,6 +143,24 @@
 	status = "okay";
 };
 
+&csi {
+	status = "okay";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		csi_ep: endpoint {
+			remote-endpoint = <&ov5640_ep>;
+			bus-width = <8>;
+			hsync-active = <1>; /* Active high */
+			vsync-active = <0>; /* Active low */
+			data-active = <1>;  /* Active high */
+			pclk-sample = <1>;  /* Rising */
+		};
+	};
+};
+
 &dai {
 	status = "okay";
 };
@@ -298,6 +351,12 @@
 	regulator-name = "vcc-wifi";
 };
 
+&reg_dldo3 {
+	regulator-min-microvolt = <2800000>;
+	regulator-max-microvolt = <2800000>;
+	regulator-name = "avdd-csi";
+};
+
 &reg_dldo4 {
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <3300000>;
@@ -315,6 +374,12 @@
 	regulator-name = "cpvdd";
 };
 
+&reg_eldo3 {
+	regulator-min-microvolt = <1500000>;
+	regulator-max-microvolt = <1500000>;
+	regulator-name = "dvdd-csi";
+};
+
 &reg_fldo1 {
 	regulator-min-microvolt = <1200000>;
 	regulator-max-microvolt = <1200000>;
-- 
2.18.0.321.gffc6fa0e3


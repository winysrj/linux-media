Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1B6C282CB
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED342087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="kgncw76Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfBDMBL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36911 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbfBDMBK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:10 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so14094775wrt.4
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ohoegLfKZSxjvRFUtoqBy2pbuyibvlUW+N0NidjtxBs=;
        b=kgncw76YRcilmegRV1s5UMGO5uULeB7qoy5HXxdyA/LKTQXP+xxDl58+vHqVQgqgJo
         uee0qlhgsPuoGWngXHEjZzQq280JEwEmvxZOzqClkTO+H0T19V6uPRPqS1v8wx0UKCRb
         YSbDjpNB1Syb5j9pa7040xESQK/3bLGOZ2WH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ohoegLfKZSxjvRFUtoqBy2pbuyibvlUW+N0NidjtxBs=;
        b=nKf6JVQnsQGKE11dQNIKVjC01Qx5r0WcyB9tdjn1HHhiL+VTmtful+Q6tYaOTsj9hb
         iHfcukYDoDhxSCWyfKHWEcOQRzM0jcyf6wroa6BL3Zi85s/8CtykWOZ3zDQVYbfBNyU8
         SsZK63rb4SGKdjKdI+AT5g4Ej4TVjggTWYozw8mdDnx03Eb+IKXft1TfgKu1a58KB2A8
         NyKoWIooZXgTT1UtrEL7XgiWZ/Vy/ABKKqFycw15HjZmuZNflx4u4337Ikk4y5POVlRI
         i8o6N18USMyFy9DR+sdZcwGTQFPxf41Lo5+XewMYzF94PGetQomDJBBdDQZYX0+Md/zH
         Y+eQ==
X-Gm-Message-State: AJcUukcaqJU0Bvy3cgddiGfg71KelfWDHgVkSMq25IU0sWSp35/oxvEx
        AipCML2hKl7rOwyPoPN5x3nzqg==
X-Google-Smtp-Source: ALg8bN7gpXISXXwvOQT0KRT9KL9CaLkW5+L/k0WQm2s2XhR5FjgqydZT/PCy10pMPC3DvfYP/KvcdA==
X-Received: by 2002:adf:c846:: with SMTP id e6mr47141839wrh.243.1549281669045;
        Mon, 04 Feb 2019 04:01:09 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:08 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 09/13] ARM: dts: imx7s-warp: add ov2680 sensor node
Date:   Mon,  4 Feb 2019 12:00:35 +0000
Message-Id: <20190204120039.1198-10-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Warp7 comes with a Omnivision OV2680 sensor, add the node here to make
complete the camera data path for this system. Add the needed regulator
to the analog voltage supply, the port and endpoints in mipi_csi node
and the pinctrl for the reset gpio.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 44 ++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index 358bcae7ebaf..58d1a89ee3e3 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -55,6 +55,14 @@
 		regulator-always-on;
 	};
 
+	reg_peri_3p15v: regulator-peri-3p15v {
+		compatible = "regulator-fixed";
+		regulator-name = "peri_3p15v_reg";
+		regulator-min-microvolt = <3150000>;
+		regulator-max-microvolt = <3150000>;
+		regulator-always-on;
+	};
+
 	sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "imx7-sgtl5000";
@@ -178,6 +186,27 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
+
+	ov2680: camera@36 {
+		compatible = "ovti,ov2680";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov2680>;
+		reg = <0x36>;
+		clocks = <&osc>;
+		clock-names = "xvclk";
+		reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
+		DOVDD-supply = <&sw2_reg>;
+		DVDD-supply = <&sw2_reg>;
+		AVDD-supply = <&reg_peri_3p15v>;
+
+		port {
+			ov2680_to_mipi: endpoint {
+				remote-endpoint = <&mipi_from_sensor>;
+				clock-lanes = <0>;
+				data-lanes = <1>;
+			};
+		};
+	};
 };
 
 &i2c3 {
@@ -319,6 +348,15 @@
 	#size-cells = <0>;
 	fsl,csis-hs-settle = <3>;
 
+	port@0 {
+		reg = <0>;
+
+		mipi_from_sensor: endpoint {
+			remote-endpoint = <&ov2680_to_mipi>;
+			data-lanes = <1>;
+		};
+	};
+
 	port@1 {
 		reg = <1>;
 
@@ -382,6 +420,12 @@
 		>;
 	};
 
+	pinctrl_ov2680: ov2660grp {
+		fsl,pins = <
+			MX7D_PAD_LPSR_GPIO1_IO03__GPIO1_IO3	0x14
+		>;
+	};
+
 	pinctrl_sai1: sai1grp {
 		fsl,pins = <
 			MX7D_PAD_SAI1_RX_DATA__SAI1_RX_DATA0	0x1f
-- 
2.20.1


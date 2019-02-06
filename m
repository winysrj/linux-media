Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48638C282C2
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C4E2083B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aBtymwPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfBFK0M (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:12 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34159 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfBFK0K (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so4861163wrn.1
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ohoegLfKZSxjvRFUtoqBy2pbuyibvlUW+N0NidjtxBs=;
        b=aBtymwPvHO1cBX2tolfLE0YU1lq0FcKYV86QVTV/0QDpX+pk6fsgw7TUM+Knye/Tp5
         EdXyXCSAOfIaQuIAn8bUVw9QTKbpgN4svtvURG1nLc/nAJdY+wBUJBAHfWYuy/VocUdU
         dvvl22EQHuH+hT0hZU/blREy2nnv705E7JOgNBDhXx2xW/YADRwTTHn568iz2/3IR7vl
         igrtKCem0LOa348jbUQQOF3BC2156gtZbx1s4qQ90Vs72V82EQPMPUiDfKLNizZpPFob
         BAjpizauQjiY5avu00iA0rRiut2ZooiJiyIjvqZM0tc/D8fzF+4y0CWzFxln43fePxnS
         NI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ohoegLfKZSxjvRFUtoqBy2pbuyibvlUW+N0NidjtxBs=;
        b=sSN4abRv2AO/7x+xmJmCfm94bFHmwrgJtvJLSTqFPK8NcBEueQYpZZOkH86/zfgNLy
         uVKweng12g68cq9XJQdodQXXKpVN9mq+Z3nrrLN7l2ODiiJ2QEiKmwZwFrw9ZzxNnhAM
         0FPdVVtjANql5CzGDa/iJrc6XnNvpt/MtnJok0+//VSqQhzdUFP6bLtUU/kNFF6Rn9HJ
         bDq1T+0rzrI2s0x1C7dkfgryenFQUi5S9mmvqlcQMTzJaY2ehRWUpMWpBrOo+qRQaSIo
         h4qeNgsZ5MP5VRDfXCGqIAkEoLnJ77WNoYvhF0+HKf28brDqytO+c7kBksj7g54MQeZ/
         YCRA==
X-Gm-Message-State: AHQUAuYnQgXI0voHfJn4Zy7Brf/i0rf5ZViw3XCknqcpelWEBw7Js3Zw
        2zpHx7c7RTDK2ZGYV1CqGAOvvQ==
X-Google-Smtp-Source: AHgI3IYri5OuwJu69sEWLenx6m5vGoo8SOoFN8bBENWHNwzlmHHBA9DU3mpx2nAfuR33s1DVAM7dAQ==
X-Received: by 2002:adf:e589:: with SMTP id l9mr6989269wrm.312.1549448768824;
        Wed, 06 Feb 2019 02:26:08 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:08 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 09/13] ARM: dts: imx7s-warp: add ov2680 sensor node
Date:   Wed,  6 Feb 2019 10:25:18 +0000
Message-Id: <20190206102522.29212-10-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
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


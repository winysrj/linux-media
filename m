Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9DCC169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85B2217F9
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZcniKgl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfBFPNo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:13:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42629 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731147AbfBFPNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 10:13:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id q18so7931473wrx.9
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 07:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rMqXeMdTsmQBRukkccJ6OzWO2HfnbotFKt0ltYd3kac=;
        b=ZcniKgl7smwgpsJ10MBUQrz1osKQ72Ilq8s/vgBRZ0AdfrUvZzunIufUSt5vtl4+Yt
         aZF4g4UHfoXEaGCxN7fjDrHNCWv19SwnKdfUYtndgG46kwGX/TKOOIbnWOjLL7v7BEJD
         eKYN3Z4tVjCGmwKfIwAArf+Sbq9E++3bmo8d7hs98lUuE/9Y7gBnNtubIGWC8hm96B6F
         u8TBb68Usetr8YZA9jQwWW/9z+RkiXwGUC75yqt3T4nDu86ewR6uKrRBt3zDvOOQRx7t
         Fcwh89es9GiNoquF2dbBPX9Ki3fk2+9VyxbuYq45PkoAvAcDGOIwsMFJ9cHGEgJNftz8
         l9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMqXeMdTsmQBRukkccJ6OzWO2HfnbotFKt0ltYd3kac=;
        b=LdSbEvMi9d0RK4zSTabZOQq0Uuf1352ubMfbyNumjZpWcSsSn0Fha20d7vvRXA+aj1
         AStKLPlV3XFGrd5MdbFKVCVARf5M+56xVL1WaeyQOaJU+3LrKhffRrgS6SXfzVIN4ORA
         1rZObve0D+IWhq3AGkqXi2Js7KR4EtdPN6CAPXN6jqV1W10z/Mz8HHDN+cWwXiTYF5qi
         0VKPkr5+KnGsbFIdQr/9l6nz6l8qNfNyueTYMPG+NVI52m2XtyBdyJmb12Mdrs5k+ATV
         EtJy69ZrCQzg48XPSgLnbUIhW3I92wze6KEvKbSHi2QK2P7vIOg6Mw/EPJiCbdeoSaf8
         WP8Q==
X-Gm-Message-State: AHQUAuaI+lGHIXiwIsa2JEvOg5zUeiBMY8h/XIql8KVr+3SovDNjNJNN
        qv16qfavN42Y7AOmcZmLKteArA==
X-Google-Smtp-Source: AHgI3IaqrItOkw6n9nyep29PoeneRSlxY7ZznT8IebS4wnxq+O5IFGUwggY1k978vMgnzBgOv3UeOw==
X-Received: by 2002:adf:8121:: with SMTP id 30mr1759283wrm.51.1549466021125;
        Wed, 06 Feb 2019 07:13:41 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f22sm11207836wmj.26.2019.02.06.07.13.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 07:13:40 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v14 03/13] media: dt-bindings: add bindings for i.MX7 media driver
Date:   Wed,  6 Feb 2019 15:13:18 +0000
Message-Id: <20190206151328.21629-4-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206151328.21629-1-rui.silva@linaro.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add bindings documentation for i.MX7 media drivers.
The imx7 MIPI CSI2 and imx7 CMOS Sensor Interface.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../devicetree/bindings/media/imx7-csi.txt    | 45 ++++++++++
 .../bindings/media/imx7-mipi-csi2.txt         | 90 +++++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt

diff --git a/Documentation/devicetree/bindings/media/imx7-csi.txt b/Documentation/devicetree/bindings/media/imx7-csi.txt
new file mode 100644
index 000000000000..3c07bc676bc3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/imx7-csi.txt
@@ -0,0 +1,45 @@
+Freescale i.MX7 CMOS Sensor Interface
+=====================================
+
+csi node
+--------
+
+This is device node for the CMOS Sensor Interface (CSI) which enables the chip
+to connect directly to external CMOS image sensors.
+
+Required properties:
+
+- compatible    : "fsl,imx7-csi";
+- reg           : base address and length of the register set for the device;
+- interrupts    : should contain CSI interrupt;
+- clocks        : list of clock specifiers, see
+        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
+- clock-names   : must contain "axi", "mclk" and "dcic" entries, matching
+                 entries in the clock property;
+
+The device node shall contain one 'port' child node with one child 'endpoint'
+node, according to the bindings defined in:
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+In the following example a remote endpoint is a video multiplexer.
+
+example:
+
+                csi: csi@30710000 {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        compatible = "fsl,imx7-csi";
+                        reg = <0x30710000 0x10000>;
+                        interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+                        clocks = <&clks IMX7D_CLK_DUMMY>,
+                                        <&clks IMX7D_CSI_MCLK_ROOT_CLK>,
+                                        <&clks IMX7D_CLK_DUMMY>;
+                        clock-names = "axi", "mclk", "dcic";
+
+                        port {
+                                csi_from_csi_mux: endpoint {
+                                        remote-endpoint = <&csi_mux_to_csi>;
+                                };
+                        };
+                };
diff --git a/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
new file mode 100644
index 000000000000..71fd74ed3ec8
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
@@ -0,0 +1,90 @@
+Freescale i.MX7 Mipi CSI2
+=========================
+
+mipi_csi2 node
+--------------
+
+This is the device node for the MIPI CSI-2 receiver core in i.MX7 SoC. It is
+compatible with previous version of Samsung D-phy.
+
+Required properties:
+
+- compatible    : "fsl,imx7-mipi-csi2";
+- reg           : base address and length of the register set for the device;
+- interrupts    : should contain MIPI CSIS interrupt;
+- clocks        : list of clock specifiers, see
+        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
+- clock-names   : must contain "pclk", "wrap" and "phy" entries, matching
+                  entries in the clock property;
+- power-domains : a phandle to the power domain, see
+          Documentation/devicetree/bindings/power/power_domain.txt for details.
+- reset-names   : should include following entry "mrst";
+- resets        : a list of phandle, should contain reset entry of
+                  reset-names;
+- phy-supply    : from the generic phy bindings, a phandle to a regulator that
+	          provides power to MIPI CSIS core;
+
+Optional properties:
+
+- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
+		    value when this property is not specified is 166 MHz;
+- fsl,csis-hs-settle : differential receiver (HS-RX) settle time;
+
+The device node should contain two 'port' child nodes with one child 'endpoint'
+node, according to the bindings defined in:
+ Documentation/devicetree/bindings/ media/video-interfaces.txt.
+ The following are properties specific to those nodes.
+
+port node
+---------
+
+- reg		  : (required) can take the values 0 or 1, where 0 shall be
+                     related to the sink port and port 1 shall be the source
+                     one;
+
+endpoint node
+-------------
+
+- data-lanes    : (required) an array specifying active physical MIPI-CSI2
+		    data input lanes and their mapping to logical lanes; this
+                    shall only be applied to port 0 (sink port), the array's
+                    content is unused only its length is meaningful,
+                    in this case the maximum length supported is 2;
+
+example:
+
+        mipi_csi: mipi-csi@30750000 {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                compatible = "fsl,imx7-mipi-csi2";
+                reg = <0x30750000 0x10000>;
+                interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&clks IMX7D_IPG_ROOT_CLK>,
+                                <&clks IMX7D_MIPI_CSI_ROOT_CLK>,
+                                <&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
+                clock-names = "pclk", "wrap", "phy";
+                clock-frequency = <166000000>;
+                power-domains = <&pgc_mipi_phy>;
+                phy-supply = <&reg_1p0d>;
+                resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
+                reset-names = "mrst";
+                fsl,csis-hs-settle = <3>;
+
+                port@0 {
+                        reg = <0>;
+
+                        mipi_from_sensor: endpoint {
+                                remote-endpoint = <&ov2680_to_mipi>;
+                                data-lanes = <1>;
+                        };
+                };
+
+                port@1 {
+                        reg = <1>;
+
+                        mipi_vc0_to_csi_mux: endpoint {
+                                remote-endpoint = <&csi_mux_from_mipi_vc0>;
+                        };
+                };
+        };
-- 
2.20.1


Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC75C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB5E2084D
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="q/1sY0um"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfAHXIk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 18:08:40 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:49002 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729428AbfAHXIj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 18:08:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=References:In-Reply-To:Message-Id:Date:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zfYdVkidy/vlT1eq7QQpcaj0nAz1fir90pEsrfjtLi4=; b=q/1sY0umo0YjcjeEG14+7j7im
        AbVSU+vydgq3I/S0AR1gK+S9S2/iMjAa0N2GntVv5lQSABvXI1uA9qJ8s2n1qLd2Z9KEaFrqvi1DC
        XF8eFT1HJVv+cairipNKUM4hqKm4HclY7V7DmJaKXOPUTgS9pnl6qdQWrKCHRymXfsq9M=;
Received: from [78.134.43.6] (port=50994 helo=melee.fritz.box)
        by hostingweb31.netsons.net with esmtpa (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1gh02Z-00FWab-JF; Tue, 08 Jan 2019 23:40:07 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-media@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [RFC 3/4] media: dt-bindings: add DS90UB954-Q1 video deserializer
Date:   Tue,  8 Jan 2019 23:39:52 +0100
Message-Id: <20190108223953.9969-4-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190108223953.9969-1-luca@lucaceresoli.net>
References: <20190108223953.9969-1-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is a first, tentative DT layout to describe a 2-input video
deserializer with I2C Address Translator and remote GPIOs.

NOTES / TODO:
 * This GPIOs representation is not realistic, it has been used only
   to test that thing work. It shall be rewritten properly.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 .../bindings/media/ti,ds90ub954-q1.txt        | 151 ++++++++++++++++++
 1 file changed, 151 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,ds90ub954-q1.txt

diff --git a/Documentation/devicetree/bindings/media/ti,ds90ub954-q1.txt b/Documentation/devicetree/bindings/media/ti,ds90ub954-q1.txt
new file mode 100644
index 000000000000..3024ef2df100
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,ds90ub954-q1.txt
@@ -0,0 +1,151 @@
+Texas Instruments DS90UB954-Q1 dual video Deserializer
+======================================================
+
+Required properties:
+
+ - compatible: must be "ti,ds90ub954-q1"
+ - reg: I2C bus address of the chip (0x30..0xdd, based on strapping options)
+ - reset-gpios: chip reset GPIO, active low (connected to PDB pin of the chip)
+ - i2c-alias-pool: list of I2C addresses that are known to be available on the
+                   "local" (SoC-to-deser) I2C bus; they will be picked at
+		   runtime and used as aliases to reach remove I2C chips
+
+
+Required subnodes:
+ - ports: A ports node with one port child node per device input and output
+          port, in accordance with the video interface bindings defined in
+          Documentation/devicetree/bindings/media/video-interfaces.txt. The
+          port nodes are numbered as follows:
+
+          Port Description
+          -----------------------------
+          0    Input from FPD-Link 3 RX port 0
+          1    Input from FPD-Link 3 RX port 1
+          2    CSI-2 output
+ - gpios: *** this is a temporary test implementation, ignore it
+ - i2c-mux: contains one child per RX port, each generates an I2C adapter
+            representing the I2C bus on the remote side
+ - rxports: contains one child per RX port, each describes one FPD-Link 3 port
+            with these fields:
+	    - reg: the RX port index
+	    - ser-i2c-alias: the alias to access the remore serializer from
+	      the local bus
+	    - bc-gpio-map: maps backchannel GPIO numbers to local GPIO inputs
+	                   with pairs <fpd_gpio_number gpio_node>
+			   (TODO change when reimplementing the gpios subnode)
+
+
+Device node example
+-------------------
+
+&i2c0 {
+	deser@3d {
+		reg = <0x3d>;
+		compatible = "ti,ds90ub954-q1";
+		reset-gpios = <&gpio1 2 0>;
+
+		i2c-alias-pool = /bits/ 16 <0x20 0x21 0x22 0x23 0x24 0x25>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				ds90ub954_fpd3_in0: endpoint {
+					remote-endpoint = <&remote_sensor_0_out>;
+				};
+			};
+
+			// TODO enable both ports (and s/1/2/g in th MIPI port below)
+			// port@1 {
+			// 	reg = <1>;
+			// 	ds90ub954_fpd3_in1: endpoint {
+			// 		remote-endpoint = <&remote_sensor_1_out>;
+			// 	};
+			// };
+
+			port@1 {
+				reg = <1>;
+				ds90ub954_mipi_out0: endpoint {
+					data-lanes = <1 2 3 4>;
+					remote-endpoint = <&csirx_0_in>;
+				};
+			};
+		};
+
+		gpios {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			// From sensor to CPU
+			gpio@0 {
+				reg = <0>;
+				output;
+				source = <0>; // RX port 0
+				function = <0>;
+			};
+
+			// CPU to sensor reset, active low
+			remote_sensor1_reset: gpio@1 {
+				reg = <1>;
+				input;
+			};
+		};
+
+		i2c-mux {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			remote_i2c0: i2c@0 {
+				reg = <0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				clock-frequency = <400000>;
+			};
+
+			remote_i2c1: i2c@1 {
+				reg = <1>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				clock-frequency = <400000>;
+			};
+		};
+
+		rxports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			rxport@0 {
+				reg = <0>;
+				ser-i2c-alias = <0x3e>;
+
+				/* Map BC GPIO numbers to local GPIO inputs */
+				bc-gpio-map = <1 &remote_sensor1_reset>;
+			};
+
+			rxport@1 {
+				reg = <1>;
+				ser-i2c-alias = <0x3f>;
+			};
+		};
+	};
+};
+
+&remote_i2c0 {
+	remote_sensor0@1a {
+		reg = <0x1a>;
+		compatible = "sony,imx274";
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reset-gpios = <&gpio1 4 0>;
+
+		port@0 {
+			reg = <0>;
+			remote_sensor_0_out: endpoint {
+				remote-endpoint = <&ds90ub954_fpd3_in0>;
+			};
+		};
+	};
+};
-- 
2.17.1


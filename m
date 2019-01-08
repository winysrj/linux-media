Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C121C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BB7121019
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihI+QQ9l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfAHOwM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36393 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id n2so1841306pgm.3;
        Tue, 08 Jan 2019 06:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SC+GsdON4IcfFuhrnmezdwcQf7UD3b3+JMzwZyO+TCo=;
        b=ihI+QQ9lsSgJygZva67JdIzSxhdMY1mqyagj5+HILFU04pjrOiAQteeAEb5x4PVitr
         7qzaKj83cU+zBpH40YwpnOHsrkX84rSXo4dRe/r9jYLCsbSLmkCLY1xEZ5v35wd0GBiD
         Efd0uRAnLg+taIGxEXMtXVuj0O+N9sw0zJlcbsHG6MOovXWwQFPZGfmWWfetLrYO0+4B
         shOqDhl7sGUBR9sTW6rW74dxKIHb7rMs3miD9nhc8Odr3y+8iToNtEiBKPCutmTLD07/
         HZRuyKW9Omrjuja25gvG+lDkEHP7Z6qTtl7oVKSMVvN5OMvKyXULOqIvZ+2SBfh+KCR4
         79Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SC+GsdON4IcfFuhrnmezdwcQf7UD3b3+JMzwZyO+TCo=;
        b=FPMN4MTZ/S9b7wg8X85P/P6Hv16BxrivFmAYC7nxcV8B7sGSlyL05pPdKQDzfUymX9
         UYxHXQPVJyhy8L5M3/YS5cU4h2yZTkKKmUrfDdPo61h6/S2RrY6ebc5kyEFqMpG7HKF8
         Qaco9D6L5R4ckTZLKF7Oze/iPwUefbjgdfuvGFLsajuP0O+tVZRsHtiUSDfRb9FC+HlS
         e5kZgmAhSJL+y867EPH9bm/FZzaGtWAl4rg54wK9E80qvfioNH/YJtKXllLlgXGSgLGS
         JFBZpLXc2INqbO1JPwGNke8UmG71AWklZR3I/ZvBtWRuWp1B6iAxNTqX4jKczKUNY1K3
         Y5kg==
X-Gm-Message-State: AJcUukfLxv9kE0SW9YCmQkHdxGlUVQl8vi6Vg23jbFfgEnLE5yOpdLyj
        wUy6lGkY8rj5sE6X+7MG9ayS8IT8
X-Google-Smtp-Source: ALg8bN5xHzQ16RVI+1GXWyEzYr65IqKyFlloNKtEvmej8Ee8N9K3oAhVN2QcMZVNQ/3R+f9txYHRnQ==
X-Received: by 2002:a65:4ccb:: with SMTP id n11mr1806356pgt.257.1546959129963;
        Tue, 08 Jan 2019 06:52:09 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:09 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 02/13] media: i2c: mt9m001: dt: add binding for mt9m001
Date:   Tue,  8 Jan 2019 23:51:39 +0900
Message-Id: <1546959110-19445-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add device tree binding documentation for the MT9M001 CMOS image sensor.

Cc: Rob Herring <robh@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Update binding doc suggested by Rob Herring.

 .../devicetree/bindings/media/i2c/mt9m001.txt      | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m001.txt b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
new file mode 100644
index 0000000..c920552
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
@@ -0,0 +1,38 @@
+MT9M001: 1/2-Inch Megapixel Digital Image Sensor
+
+The MT9M001 is an SXGA-format with a 1/2-inch CMOS active-pixel digital
+image sensor. It is programmable through I2C interface.
+
+Required Properties:
+
+- compatible: shall be "onnn,mt9m001".
+- clocks: reference to the master clock into sensor
+
+Optional Properties:
+
+- reset-gpios: GPIO handle which is connected to the reset pin of the chip.
+  Active low.
+- standby-gpios: GPIO handle which is connected to the standby pin of the chip.
+  Active high.
+
+The device node must contain one 'port' child node with one 'endpoint' child
+sub-node for its digital output video port, in accordance with the video
+interface bindings defined in:
+Documentation/devicetree/bindings/media/video-interfaces.txt
+
+Example:
+
+	&i2c1 {
+		camera-sensor@5d {
+			compatible = "onnn,mt9m001";
+			reg = <0x5d>;
+			reset-gpios = <&gpio0 0 GPIO_ACTIVE_LOW>;
+			standby-gpios = <&gpio0 1 GPIO_ACTIVE_HIGH>;
+			clocks = <&camera_clk>;
+			port {
+				mt9m001_out: endpoint {
+					remote-endpoint = <&vcap_in>;
+				};
+			};
+		};
+	};
-- 
2.7.4


Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817A2C43612
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5148F21A4B
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOF7kfgy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391038AbeLVRNO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:14 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34501 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391035AbeLVRNN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:13 -0500
Received: by mail-pg1-f196.google.com with SMTP id j10so3918605pga.1;
        Sat, 22 Dec 2018 09:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AJJRYBrX/c/RvKPNHNtMugkVkTDmhhzxZAM8CVus1mk=;
        b=KOF7kfgyPrGC3KpJTaFrzKsi1z5yGc3PbvqBZj+5dfqxT2hyEZBnsxB2+AOll69mx2
         3KoHdpP4uGCtvc0lzS6X78d2eb9Fe0lQyRh1NsukYBFZDfC3mf2X1gVYFxgu6URzoumU
         aJ8/dxyyBiNglfI+dZEVIjRunUfFsLt7MOxM8wRJ7/66RW54xAKVC17mPY7XShDaZi3w
         76eSVJKOMpaqzJ204jjIZoW7hKv2FuSfOr0KLCJthFgSXy+UhaCaNz5s45HT/H+RbDsB
         V5B4mVkogaWsPClMVhp0jQNf7fq5xmixjFp9+M/Lw5attC48HkAQl4BzLUAG9ZKCqws3
         x6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AJJRYBrX/c/RvKPNHNtMugkVkTDmhhzxZAM8CVus1mk=;
        b=tyhsxP17XYiLxFordufvucY9xsqYxKpgYdz0aqGBA5dT9uJd/bIDPFk2wYe4Mu1zwX
         61rZxBk6fUDUc8VCVHY5ZvblBb4wyTT7opMwjAUm8k0y52ldQkYD9qWJ6jiL67mA1dvg
         OKCguzsX+6tAcId3v7zElNoj8Zvq+Fq+D7TsDXBFyTZz2O8/CSPBajJCYGIOPzmCXKmi
         +9X4awVnQSDvSQfI2/zpErsOMt92oC6c2vDDtLysPegKq1nSG0CBau3ugiw+InlfIpkf
         8/ZnQgiBsKCoRB/1WKrBDWnUiTmCCHqS0AV9G7KZs1nA6tVN0CIq0x5RI1KE5Tjh69Im
         MxSA==
X-Gm-Message-State: AA+aEWZI4vY2BQOB4kg6eerbxHR5x6WlKPmRE444wLsAguQPIyPC1MPZ
        kTUxioOzwy8m+FrKlp+3UI4AU0KQnPE=
X-Google-Smtp-Source: AFSGD/XDs4V/r2YqEVFnwik1Wm0gQqGOLiMSlLgMILSTm68bwzofnR4cfNd8xsZbD+0cvvnuKvk/Cg==
X-Received: by 2002:aa7:810c:: with SMTP id b12mr7122601pfi.44.1545498790964;
        Sat, 22 Dec 2018 09:13:10 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:10 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 02/12] media: i2c: mt9m001: dt: add binding for mt9m001
Date:   Sun, 23 Dec 2018 02:12:44 +0900
Message-Id: <1545498774-11754-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add device tree binding documentation for the MT9M001 CMOS image sensor.

Cc: Rob Herring <robh@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 .../devicetree/bindings/media/i2c/mt9m001.txt      | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m001.txt b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
new file mode 100644
index 0000000..794b787
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
@@ -0,0 +1,37 @@
+MT9M001: 1/2-Inch Megapixel Digital Image Sensor
+
+The MT9M001 is an SXGA-format with a 1/2-inch CMOS active-pixel digital
+image sensor. It is programmable through a simple two-wire serial
+interface.
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
+For further reading on port node refer to
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	&i2c1 {
+		mt9m001@5d {
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


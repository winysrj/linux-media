Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F7BC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 16:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A35E20811
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 16:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="iDD4LFB7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732363AbfCZQMX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:12:23 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44928 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732237AbfCZQMW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 12:12:22 -0400
Received: by mail-lj1-f196.google.com with SMTP id h16so7176006ljg.11
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2019 09:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:organization:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bChSgXhToRyrcHoAnFOWbKcmw6ZhKZxwegO2zNkAVEA=;
        b=iDD4LFB7uoC7J9uWSH2vWju/puvUAztHl0bJVwXPvfTRFHISovy/O4lw3zCTKh+dm6
         OxAmCu7WuRTCcrSjDbXrxyJRtnaBHDfwGDbLfsU5O8vA4cjSr9/zM9DxyLJzLE2flku5
         P7bDVkSDpdB78G96G/4/A5IeDiSW/+GWdh5EFbgeHO4yFCPj57qJJx21dkh8UslJveN3
         Ba4m3r4RQUllUn/ObSj+agFGYLaM/SKpmulGJQbihb9E2rd+JpVjNn8XZ4NE7YuT9cHv
         N8jMdQfWGZX72UBvjh48XWanfEoWRDnc4L48N1dQu+xsysoZ09R66ki19iFzGvGlIyKX
         qdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:organization:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=bChSgXhToRyrcHoAnFOWbKcmw6ZhKZxwegO2zNkAVEA=;
        b=O0g+TMPocIvHTLI6VvV9q3x51mk29V21O+NpgQ99K5vAKze+Y6jNj4sKFzTTqawZlm
         AH+KC31xRnONWTH/o3EtFpHWe54rGoaBH7vyqqqjIg0HyitKPFfJCO+soZQgulbUOqV8
         KoncgZrpTJUkIVy9kUpk9ulxRBQwXgKZJHh6j8NQ/FivhDIzjzYmK1TrefdCBO60aSqn
         c3iDy94JaY8n1fRW3nrwOL7HpKMwX+mZam/eWZ4crE7u4Utg9S8hIX2qxl9OPIgz+tZH
         RYM52TXEL0zN6c9hd8+GDIB3KbLBmdc/vcKG7rEgv54lhwtCO6woQpOPd+n6dwv6gome
         Zrrg==
X-Gm-Message-State: APjAAAUnBPhSoRYoIN3n6dFh68uFg22edkplAyYJETTF9TnPZ4i5G0Md
        hvyK4SqQO7LKuppBB10HxQdaqg==
X-Google-Smtp-Source: APXvYqyz+WocA2YU3Az1ROAkS/smKaJk4eYK1cVgXzK8nKsaybTUZP+5oqR4V4Ya9hHxSGfHF2YEkw==
X-Received: by 2002:a2e:288:: with SMTP id y8mr2759361lje.62.1553616740831;
        Tue, 26 Mar 2019 09:12:20 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.80.251])
        by smtp.gmail.com with ESMTPSA id k21sm1527696ljk.21.2019.03.26.09.12.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 09:12:20 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v2] dt-bindings: media: Renesas R-Car IMR bindings
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org, Rob Herring <robh@kernel.org>
Organization: Cogent Embedded
Message-ID: <55c5fca2-3ead-17da-e42f-04bdc1fbf1bf@cogentembedded.com>
Date:   Tue, 26 Mar 2019 19:12:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The image renderer (IMR), or the distortion correction engine, is a
drawing processor with a simple instruction system capable of referencing
video capture data or data in an external memory as the 2D texture data
and performing texture mapping and drawing with respect to any shape that
is split into triangular objects.

Document  the device tree bindings for the image renderer light extended 4
(IMR-LX4) found in the R-Car gen3 SoCs...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Rob Herring <robh@kernel.org>

---
This patch is against the 'master' branch of the 'media_tree.git' repo.

This patch has been split from the large IMR driver patch (which would need
much more work), it fixes checkpatch.pl's warnings on the SoC .dtsi files
which have been already merged (the bindings didn't change since v1 of the
driver patch).

Changes in version 2:
- documented the required "power-domains" and "resets" props, adding them to
  the example as well.

 Documentation/devicetree/bindings/media/rcar_imr.txt |   31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
===================================================================
--- /dev/null
+++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
@@ -0,0 +1,31 @@
+Renesas R-Car Image Renderer (Distortion Correction Engine)
+-----------------------------------------------------------
+
+The image renderer, or the distortion correction engine, is a drawing processor
+with a simple instruction system capable of referencing video capture data or
+data in an external memory as 2D texture data and performing texture mapping
+and drawing with respect to any shape that is split into triangular objects.
+
+Required properties:
+
+- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a fallback for
+  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
+  where the examples with <soctype> are:
+  - "renesas,r8a7795-imr-lx4" for R-Car H3,
+  - "renesas,r8a7796-imr-lx4" for R-Car M3-W.
+- reg: offset and length of the register block;
+- interrupts: single interrupt specifier;
+- clocks: single clock phandle/specifier pair;
+- power-domains: power domain phandle/specifier pair;
+- resets: reset phandle/specifier pair.
+
+Example:
+
+	imr-lx4@fe860000 {
+		compatible = "renesas,r8a7795-imr-lx4", "renesas,imr-lx4";
+		reg = <0 0xfe860000 0 0x2000>;
+		interrupts = <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cpg CPG_MOD 823>;
+		power-domains = <&sysc R8A7795_PD_A3VC>;
+		resets = <&cpg 823>;
+	};

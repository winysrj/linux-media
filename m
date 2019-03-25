Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B12C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 18:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F02206DF
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 18:14:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="GgCTEx80"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfCYSOE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:14:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45197 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbfCYSOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 14:14:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id y6so8710707ljd.12
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 11:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:organization:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xbcKe6ohImMpIfOTDFLtRSbFzW1wrhJK46C3ePgnp6Q=;
        b=GgCTEx804Xzx7mJEDW7pMqOX9gdzv+DYmQZSNclUakpnunprxCTJkbcv5BRnV7bQbU
         jhnURtpVVIxRTyPbDlCf5Q+CJ74Hiilu1ubI80zzXMvxqeUfk1hWRHIU78mD1gN3uvD5
         IEsMJLGsHfEE2b1XaEHi9XepAZTZ3qB90K2Fjg4eliUriOP5PGuwHhkuUqK4g4pE8qHp
         7maT9FLDtl6x6QYLfIqTboJYunoOs64PRotT+GNt3c+612hygPFZRBU91aaASebb1Uyg
         /T1D2+CMaEaH1dHRFELQ2t7FUF6IMO520jQA6wk94xnaGQ7UR1F5lly6i8o1aNG9fnCj
         1gkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:organization:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=xbcKe6ohImMpIfOTDFLtRSbFzW1wrhJK46C3ePgnp6Q=;
        b=U6ewQfkGSDhea/m59ItwgQ1Rp56uiF6B4Cy11gO81mscSNn0o8EGF7fMXS6x8kuQyY
         fp4255XshhS9KbQwHLboVBgKi4RbXUrRGik8VxOtqcUoDobpJt3fOXKJEWSmkGib5eCd
         9G4Vq6EcwhFSz4ZV8eZgvC+05DbPIogQZvzn/Ari/UwcRD8UkLMhS1CW2SRyzDidoIJ2
         UYIt9BlERKCIwp9wuYzMydLp2Mcb5Jd6mp5vuZb491CW8/ifg8CiCJidyIDM6XJmUC2r
         DP4oj/tj2ykPQg2TcIkJEmZVxmwUxC0JT/T25SCZ8pP5jrCy3LCJpcb7fs7BTNKocGX4
         kHEw==
X-Gm-Message-State: APjAAAXR0hQm5ZcSDh79E5MFJZGLEHcsSxKVEG/7X5FxnRfC6Wqddnmh
        TLMsp4ljUc719gpyWftG0wmZF7y0PdI=
X-Google-Smtp-Source: APXvYqwe/A9RoVTuAfyd+NlPZM1oWLCyTobfsYiRT9uuE3uOKpv4W8JSg4OlAGkFSlMjWrjAzjA9XQ==
X-Received: by 2002:a2e:9d0c:: with SMTP id t12mr2804001lji.163.1553537642273;
        Mon, 25 Mar 2019 11:14:02 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.83.129])
        by smtp.gmail.com with ESMTPSA id v203sm3481145lfa.82.2019.03.25.11.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 11:14:01 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH] dt-bindings: media: Renesas R-Car IMR bindings
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org, Rob Herring <robh@kernel.org>
Organization: Cogent Embedded
Message-ID: <b2964da9-4389-b277-0e6f-df41f39326b7@cogentembedded.com>
Date:   Mon, 25 Mar 2019 21:14:00 +0300
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

Documentation/devicetree/bindings/media/rcar_imr.txt |   27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
===================================================================
--- /dev/null
+++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
@@ -0,0 +1,27 @@
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
+- clocks: single clock phandle/specifier pair.
+
+Example:
+
+	imr-lx4@fe860000 {
+		compatible = "renesas,r8a7795-imr-lx4", "renesas,imr-lx4";
+		reg = <0 0xfe860000 0 0x2000>;
+		interrupts = <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cpg CPG_MOD 823>;
+	};

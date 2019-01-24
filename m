Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3C1C282C6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0C1218AF
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="MBuene0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbfAXSIk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:08:40 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36609 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbfAXSIj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 13:08:39 -0500
Received: by mail-pg1-f193.google.com with SMTP id n2so3002295pgm.3
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 10:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOQ/q0ycl2Vhbvj/n8EVpYC4IVJK5DjscGBSfNzrl+U=;
        b=MBuene0c4uUHb8+Bp3wEZ/+UgAl0anWc87gdaXyJdhvM4FS9sjReofRVil356wMbpl
         FGat6d4s59SnIDRICsqYL5q5vXvAAbftKuj0X3zBOyfzBwcwp0KQonwmKcR5o+EaF8p4
         dpv1LmS3LhFOt+SkdBFRY56ng6FSAQLripWP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOQ/q0ycl2Vhbvj/n8EVpYC4IVJK5DjscGBSfNzrl+U=;
        b=Dve2kP0TEYSj/h6enh/VdQ2kOuceUotLU6mxfL0Ndl3rHJ/M7Rvxv26JewgVaZYd9P
         Aweoe7xoTjwjTRggivfph5LRci9TDPFvpZNfPopMSgMVsAY0JjoGYCs6KRuMorMhezA6
         ubjhOekVTQce8M/BcT8ztf3/PRjDsv/JOFT7n6T/Gd0rrYit5cSGE2KOHTVtoww0CBB7
         U2Rn6N0Uc2X/1AcpVB2twatQzRXaQER8LgEbDMVJXVXdA5TXtzbvi8c0VjBUf4XtV8rQ
         ttxg4+2f8jIR5mPDhNRt5cwTBnPtbfaHRuEyWQm8sEr9/eT0410S8iCw7RWijAxbP0+W
         5rzw==
X-Gm-Message-State: AJcUukeMjd8pP881aCD77yyiaNlQiBRMpgZPpyWqp2xgojEz04ne9d8x
        H+mhg3T8vCUnT0XfHBLLnKibfg==
X-Google-Smtp-Source: ALg8bN7CyOInddhg3QutLK5b0/l+R6UdRyH0k8FBbS2b83cE70Ch/dT/6+aBiIyPOJ3ccOjd2f/MqA==
X-Received: by 2002:a62:32c4:: with SMTP id y187mr7758031pfy.195.1548353319192;
        Thu, 24 Jan 2019 10:08:39 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id k15sm36141551pfb.147.2019.01.24.10.08.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:08:38 -0800 (PST)
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
Subject: [PATCH v7 4/5] arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
Date:   Thu, 24 Jan 2019 23:37:35 +0530
Message-Id: <20190124180736.28408-5-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190124180736.28408-1-jagan@amarulasolutions.com>
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some camera modules have the SoC feeding a master clock to the sensor
instead of having a standalone crystal. This clock signal is generated
from the clock control unit and output from the CSI MCLK function of
pin PE1.

Add a pinmux setting for it for camera sensors to reference.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 62fdf850e9e5..6e5a608f56f2 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -564,6 +564,11 @@
 				function = "csi";
 			};
 
+			csi_mclk_pin: csi-mclk {
+				pins = "PE1";
+				function = "csi";
+			};
+
 			i2c0_pins: i2c0_pins {
 				pins = "PH0", "PH1";
 				function = "i2c0";
-- 
2.18.0.321.gffc6fa0e3


Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B2CC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D753120850
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="D+3a8+d+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfARQcc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 11:32:32 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36945 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbfARQcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 11:32:31 -0500
Received: by mail-pl1-f196.google.com with SMTP id b5so6583714plr.4
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 08:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=D+3a8+d+1MT0h2pdwphXLRMdk+66om07H04tXs+3CLjVZU5A/QqhvuGH2u2cPnResn
         gR05lHVX9lO5yh4MbmYCbxoc2huvjEh9leunG39Xo7y9wF/5DU+Aa+FloS0CqVC2OhG5
         6rhGOm5aYKv+RBykV4dAm7LPJDVHQPtyIavZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=oWHyxyHp7P5KrgBA5FvlxRpEbH3l+VhyDb5i3NVR1oR5QH1HNyntFir1TADo/Sy3Uv
         Efdbjh45FkKjC2+6rSFTMrfjiWRrFasDpSkbN7/1dIKgEwmkvIPbOLWcrj35pp2awhHM
         1oK0KMKo4kNXy18hFsf6Ca0l/rGUZc3/nsGwqRc8ena6ko2fftiweNhnhuv/EoALXzVx
         geI17eFqWTDMnmZbxykr9F/oNp2uSiO3fA+8vp/dABXpsf6OmR0FUh1ZyRCIHQb1eCcE
         PEHswyN8kebLwYDBRPWSrWK/3/ghzB9p5cVluKFPrBTT943hwVkA8wJxcPjoSChu/7VW
         ZYaw==
X-Gm-Message-State: AJcUukdKtaeGyOm2wOP+psFDEsr/zyD35fH+k98panMvPFQgzt5Un9ez
        B8UGvZhAFQqdYvRcM11iSUu0Ew==
X-Google-Smtp-Source: ALg8bN6mvpQp3YAX6GkW1M5KsfZsri3zQjDYciQGsdE6EzPzxtCuG2Y1UzZFFrJWaw+8/+vUvRXvkg==
X-Received: by 2002:a17:902:3f81:: with SMTP id a1mr19680460pld.258.1547829150371;
        Fri, 18 Jan 2019 08:32:30 -0800 (PST)
Received: from jagan-XPS-13-9350.domain.name ([103.81.77.13])
        by smtp.gmail.com with ESMTPSA id z13sm13967086pgf.84.2019.01.18.08.32.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 08:32:29 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Cc:     Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v6 5/6] arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
Date:   Fri, 18 Jan 2019 22:01:57 +0530
Message-Id: <20190118163158.21418-6-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190118163158.21418-1-jagan@amarulasolutions.com>
References: <20190118163158.21418-1-jagan@amarulasolutions.com>
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
index 89a0deb3fe6a..dd5740bc3fc9 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -538,6 +538,11 @@
 				function = "csi0";
 			};
 
+			csi_mclk_pin: csi-mclk {
+				pins = "PE1";
+				function = "csi0";
+			};
+
 			i2c0_pins: i2c0_pins {
 				pins = "PH0", "PH1";
 				function = "i2c0";
-- 
2.18.0.321.gffc6fa0e3


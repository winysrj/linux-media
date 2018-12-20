Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B330BC43612
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 843C22186A
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="BQmZ72bR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732718AbeLTMzB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:55:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38155 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbeLTMy7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:54:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id m22so2066899wml.3
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 04:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=BQmZ72bR81ebRCVcxLtWVeYzKIe97gNe16bqUHQEdvrxZ9jQdgduSgzMhZnrpzNDvC
         4nLZ7zhSYguQz8KRJjM4qqfx1LBA7ljnIM+D1n9VSLPC5sOrwo92UiUC4iP9URlDtr+a
         cGKHO0/0xrOVFvYvrjVG1ONqrdH53rHjgH79I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=b5mCxCZsG6cMe03ctrYAICO92oSfVRrkqGynPEhyKbg7Q/ZMESeiW/ZJ9zY41dxH8h
         A7JAaViTxE6JoOxWf6pAu8JVk8Kzmv7slNFG2LRpBxWIPFc8kvGrjuoJumkFXsIxFNP0
         S3tBZWz3YHriEPcssiVVOvYlwL8qvH5IAHO8YUK1uSCQBy3/EN0LkDk7ak5UvjZbdR5X
         2qi25LNDGENC1Hez8i6uhZmc84nY9619r4NC75J1jbGrrub3UYyiKCXyjYoC9DUi+/AV
         bscWVNZlqd3p7lEVfRqrPB1OuzpPz40IHdYRZ4HZhKi6KX9BNqWV2Oe+A5MPkCDbe3CC
         RpJw==
X-Gm-Message-State: AA+aEWb6OAdNcCfUnbPsiXDhNOk/R43r6/Gu8n7vmVI6Pp4LWt0/hhPW
        C9fpN18WPG4vlYDqGGVyQUZ4HA==
X-Google-Smtp-Source: AFSGD/VGbWVzN9KaZCPi1PGk/1YnRjWa3GPXr7KSh29e1qnj/L28l6uVj7KIQwJJENtIrgWqp97lNg==
X-Received: by 2002:a1c:a8d2:: with SMTP id r201mr10180319wme.81.1545310497657;
        Thu, 20 Dec 2018 04:54:57 -0800 (PST)
Received: from localhost.localdomain (ip-163-240.sn-213-198.clouditalia.com. [213.198.163.240])
        by smtp.gmail.com with ESMTPSA id o4sm8732756wrq.66.2018.12.20.04.54.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 04:54:57 -0800 (PST)
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
Subject: [PATCH v5 5/6] arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
Date:   Thu, 20 Dec 2018 18:24:37 +0530
Message-Id: <20181220125438.11700-6-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181220125438.11700-1-jagan@amarulasolutions.com>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
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


Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BB8C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD78207E0
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="HjAx/yy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfA1I72 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:59:28 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46285 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfA1I72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:59:28 -0500
Received: by mail-pg1-f196.google.com with SMTP id w7so6929730pgp.13
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 00:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOQ/q0ycl2Vhbvj/n8EVpYC4IVJK5DjscGBSfNzrl+U=;
        b=HjAx/yy/syL7k3kg3Cnf0ViKI+mtZJZM73x1heLz1ROjdadKjZTw4nvJBRyfZ/GMsg
         8RqBV6XpoUxMvQZkXDKugOLWUpUaAq/Y6qqVLH8dD1ULvDqJTNDkuFdzFGmljTaDBr7L
         esIrTucW7UKms99zqrPP9C4GsALhUGGoOTat4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOQ/q0ycl2Vhbvj/n8EVpYC4IVJK5DjscGBSfNzrl+U=;
        b=Ku/qgrJOWC5UbOtFlEmu8kUJjCkzLzAb5tfxm6m9WcuwKmfGIOH41ymWVE2zi7kJK3
         jp9DxtZjciRqcJQ7ewvbsLdSV2KrDrA9nvYGXcr9WM5EIBjWus22jb5LaJcmEb1pHR6n
         2eEETgJ1ltz9dnv0RmPru79t0yxIvNWOf9fsuGRoOesgUEFc1PiIoy4+FndefkC0wSPM
         CYw7NK3jTlHtfJ44zIYuL4wGUM+vBp/QYkhhxSf1uWPTnc9dpBSVHX2XHHiaSqtHLJ7c
         iRNOC3VlvJsbD3uqirqvmmHGx3Vw3ppph710xyL7G4htxZvBEtX69I5+x8uCc+3JjE9q
         Diyw==
X-Gm-Message-State: AJcUukdeu2c/U1tXjEAnf5w5f9NAjoX/TAaMBYjfZ/7xJxhHj7yQcWGJ
        Zy+aaFgPb/x5wWKLlz+wE13H+w==
X-Google-Smtp-Source: ALg8bN5WnA8/3Gmoe64gYSZH3o3zpx1Wuy2p6tBGMQgtlL5ke5xScNqdxLBkTOUXbFArsdzOgJaWaA==
X-Received: by 2002:a65:4646:: with SMTP id k6mr18697741pgr.153.1548665967437;
        Mon, 28 Jan 2019 00:59:27 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id o189sm60746245pfg.117.2019.01.28.00.59.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 00:59:26 -0800 (PST)
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
Subject: [PATCH v8 4/5] arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
Date:   Mon, 28 Jan 2019 14:28:46 +0530
Message-Id: <20190128085847.7217-5-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190128085847.7217-1-jagan@amarulasolutions.com>
References: <20190128085847.7217-1-jagan@amarulasolutions.com>
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


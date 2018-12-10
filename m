Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49DBC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A202086D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="rmKhqxus"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75A202086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbeLJLx6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:53:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33913 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbeLJLxj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 06:53:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so10194749wrw.1
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 03:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=rmKhqxusc9306yF/sibOGPtsKZ0YVA8oWcI/en0ytdLEkML8BGTwAPRHxDWEtWADjV
         AeMPrXrMY85YM1J9PexBK5r855XxbqYQDJ77rhBZ1QOB9//dULojVOTEMo5tyS4xqEd9
         FOzq63vyhY21I+FhdGzSLcJTZgVI1nBKHtlhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=H7ZsBRcivwOpe27Bz1C0UxxrbocuVjpsilX6XC65L/GUMHGCR5Z1Z52ZkM+4ft/Rjc
         1iRX5IffCUGKppOJUNLD1koD/9WjxKjqShPq36hAhvwGhv6CSn5piw4H+dZdw/SXiPaU
         3bIflNYko6ihYNLmfOwIDweenYWhW0jOmeKq7MuX2zkJVDEcw77dZNZH7FYWKZxi8UsJ
         8D9L+GkqLXKWkhzrvxER0ZvkiNKVtvCk/FEh9dzZt132dZwDjHA9C6Du8Q21xSF65bDn
         660TadpjR8ILNPbmOYSfwnUqUky1PR05PNk+c7b7pwXCX1TO196lmD76S4n+hb5gAhhZ
         hnVQ==
X-Gm-Message-State: AA+aEWaaSzx9uikK1JscqeSbKvNJnHaMgymPSJoZSoyuSkt2jIgJtp5Z
        aD1GaZoA2BmZsz/+c+J4ly8CsA==
X-Google-Smtp-Source: AFSGD/X7XXMHhsDkTKBbBpvSsKxiSrvCFJENayMKWOvYt19DYtjdeJANN6bC0YMo0sro4IV6kHdeLg==
X-Received: by 2002:adf:b592:: with SMTP id c18mr9513454wre.89.1544442817615;
        Mon, 10 Dec 2018 03:53:37 -0800 (PST)
Received: from localhost.localdomain (ip-162-59.sn-213-198.clouditalia.com. [213.198.162.59])
        by smtp.gmail.com with ESMTPSA id b16sm7869243wrm.41.2018.12.10.03.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 03:53:36 -0800 (PST)
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
Subject: [PATCH v3 5/6] arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
Date:   Mon, 10 Dec 2018 17:22:45 +0530
Message-Id: <20181210115246.8188-6-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181210115246.8188-1-jagan@amarulasolutions.com>
References: <20181210115246.8188-1-jagan@amarulasolutions.com>
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


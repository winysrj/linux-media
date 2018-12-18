Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DC9C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 404D9217D9
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="evk9MkE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbeLRLdz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 06:33:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40470 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeLRLdk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 06:33:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id p4so15537264wrt.7
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 03:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=evk9MkE8TyA07Y2trxHkB5MkphTIMNp7fzPU4KmNVofgoTzvU3M6guf5J/r3ghOabb
         bsbrydn+HyYESB6VICMLQOXRivjDdpFwHRkLWWSuaVUZl0m5z56JzMHmow/MuxQkH17h
         ZFSuwAMoLVUvWCB1Zm0PFfMB9KbDHReDge3fI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BsYwI4MGKscqtd4fapjUVq4zzWRiadQNZwYTiXxWLI=;
        b=U8al4Q/tkIyX50OtsezMOwk0c8UbgvS5vCmfT0SeUvUaWDOBcQf9peT0aK0dWqSRlm
         /+NW1i4U/TJBTYo9U4BxV7nLP8jmlKnWwyZSY6JPhmwDyW21sw+x7zg8div6RhV1duyO
         dt7svMeq/L4/ppG4q+KXY1p1LK8Td+yqOSJ182xPQ7yP0eT8JTOju938RVjXiycIop6w
         kIl6D5QkGEM3WWdUGpmawwtAtkq9F9D06mO8NtrBtu24WjJzQCdGfLIsyqBThHPlzzzV
         ENA7FmjrNZDN8yxm1hooH6BXOMBw9n/QZk5XjgdEyaozQXn9pdFkcGftmslnWV97/KVx
         hMfg==
X-Gm-Message-State: AA+aEWY5+E6w5ceCBCTp2LB29gbXIFSNER/OWYaCgKEY7BsCzsha5EfX
        hx0rsDVU3na48Ty03CV2NneQPTxHzYA=
X-Google-Smtp-Source: AFSGD/Xpr+LydSmIzvpDYcxk6/tMQOBwwJZfFJoJaAHL0hsGw79+s0AA6+qZPMSEgv16qrky3X9W3w==
X-Received: by 2002:adf:f703:: with SMTP id r3mr14050740wrp.93.1545132819036;
        Tue, 18 Dec 2018 03:33:39 -0800 (PST)
Received: from jagan-XPS-13-9350.homenet.telecomitalia.it (host230-181-static.228-95-b.business.telecomitalia.it. [95.228.181.230])
        by smtp.gmail.com with ESMTPSA id h2sm4276184wrv.87.2018.12.18.03.33.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 03:33:38 -0800 (PST)
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
Subject: [PATCH v4 5/6] arm64: dts: allwinner: a64: Add pinmux setting for CSI MCLK on PE1
Date:   Tue, 18 Dec 2018 17:03:19 +0530
Message-Id: <20181218113320.4856-6-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181218113320.4856-1-jagan@amarulasolutions.com>
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
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


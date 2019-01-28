Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7B8C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9AA217D8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="MOsr+9/d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfA1I7L (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:59:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44634 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfA1I7L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:59:11 -0500
Received: by mail-pl1-f193.google.com with SMTP id e11so7448486plt.11
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 00:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R80ISGMVnhZRl2upLFe3I27brJHngys9Q8b/N3uhZ/M=;
        b=MOsr+9/dZrj2r3qjZ81FfEyec6T5ulVkdZiXhvyLn7o0S+uiJThV3PH//yyGSA+e52
         IcNpd4ktDhmYdArDsxD6tInv8X3YmrxCfS96jzOQFtdvOzMw5+lASERl1hnKParMz2Aj
         jIYXZhGqD5VqMv+C6r11JdRfTYTgNuYIk1UKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R80ISGMVnhZRl2upLFe3I27brJHngys9Q8b/N3uhZ/M=;
        b=ibcTuFQYFn2xUAKlhwmJcFHxClQeUKbDnRR4ljaCu9uLdEO9lie7L21bMX25JDkrIA
         ABpNZLy6oSh/rm4xBgu8o7TUN6qbC+ox1u29T0sC4KvSfvoaF3r6ryPyXY/eBbiPQmaT
         Ds3mcWXM+F9k4LWW/z/lwUdzrMzugN+YPtm01eeLlivOHy9h7mOWnEcnO4sXcFJp4xTk
         9jiGlB9u67U9j4v4muimFYyavNEkcL4Y8bEasLWCc+adDUmI6lh2U/VzZZjBongDpTBb
         zZZdOy6WwLRA9zEVNl4XBhmgtMz9hBG1K9nfVKN57AIrcWYAtqe0MTr7JEVhV5on+9Ha
         2XTQ==
X-Gm-Message-State: AJcUuke7OJ1peB9XT070ZOky49jKZAlMd+dVKg1w8ulq7aVOOS7v7hax
        AlSc/Fa8zyUgz17GEdXZKc9Kqw==
X-Google-Smtp-Source: ALg8bN4De1+KO0yStI4VWCLLvIMbH3xzhX2YVcCCkmA86K9Bl6JrLZrJpwhuY/2Jwjx4zZIqz22IbQ==
X-Received: by 2002:a17:902:2a89:: with SMTP id j9mr21296667plb.296.1548665950321;
        Mon, 28 Jan 2019 00:59:10 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id o189sm60746245pfg.117.2019.01.28.00.59.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 00:59:09 -0800 (PST)
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
Subject: [PATCH v8 1/5] dt-bindings: media: sun6i: Add A64 CSI compatible
Date:   Mon, 28 Jan 2019 14:28:43 +0530
Message-Id: <20190128085847.7217-2-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190128085847.7217-1-jagan@amarulasolutions.com>
References: <20190128085847.7217-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Allwinner A64 CSI is a single channel time-multiplexed BT.656
protocol interface.

Add separate compatible string for A64 since it require explicit
change in sun6i_csi driver to update default CSI_SCLK rate.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/media/sun6i-csi.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
index cc37cf7fd051..0dd540bb03db 100644
--- a/Documentation/devicetree/bindings/media/sun6i-csi.txt
+++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
@@ -8,6 +8,7 @@ Required properties:
     * "allwinner,sun6i-a31-csi"
     * "allwinner,sun8i-h3-csi"
     * "allwinner,sun8i-v3s-csi"
+    * "allwinner,sun50i-a64-csi"
   - reg: base address and size of the memory-mapped region.
   - interrupts: interrupt associated to this IP
   - clocks: phandles to the clocks feeding the CSI
-- 
2.18.0.321.gffc6fa0e3


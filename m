Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3BDC43444
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6D621850
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="ZapPYlIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbeLRLde (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 06:33:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36648 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeLRLdc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 06:33:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id p6so2138184wmc.1
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 03:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wXbv4EStlt/WSU+EIZH0OlN5Zo9WGSHjVKnuaGSJ7JI=;
        b=ZapPYlIqc/7JT1Q5imj9U3QTNGIiDsJ7a7DsWZJZ2Hcs2cB0R9eOq48HVil4QgptVd
         GDSlCZq2QLY9GaLyYMIYLAH6EOsHeVL39GGofN0eMRIkgNyl9nljxtCVN2Lv/8zZxJPo
         O86zYTeOSy2b8t8xwJqKC8CqGJNYYaN3MOfNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wXbv4EStlt/WSU+EIZH0OlN5Zo9WGSHjVKnuaGSJ7JI=;
        b=IGQ0T0hTprVJNCK57B/BTAa8bYK4XDnprUZT1WsGThji8LO4sgSdEeyen6wUbqmTkr
         2BeBkEU0ZYk92cgnGK9DDLLzGyisdD5MPPbvs4LRA/LJe9+Dj6s0DO9bV6sly7ymJLcO
         3HHwD4U3J+xI+YarutJ+QN5n7F6EAqIRWlNuQ/lQjoKIUts8fmmDxXUT72eCf7JOQ5xx
         JvivXjVg7KNWsf1ugJCCBa3mc4KWf92N0s3sBD106GGDu8UNC53yrVAmD3yLRB/z3czU
         o0zTBcBjpvOq+Xk9TiHAOFFm6vWIm4YVpeJo11UyW7bzOXi9l00K2dx+xjHux+YMxgL9
         zwLA==
X-Gm-Message-State: AA+aEWaTMRARuOORobFOgn6T89qEFYZyrptDPt4oiWFFeHggIH2IaWrh
        sSar8+9Oy5Yg1YtlYzuCYdC6Zg==
X-Google-Smtp-Source: AFSGD/V960KbP/mONPmXo6st8C0XoANFq//7R1NVc6rplJSC1QiHOSdr1kValqvOGzInBsDaA+2YjQ==
X-Received: by 2002:a1c:dc86:: with SMTP id t128mr3032897wmg.42.1545132810930;
        Tue, 18 Dec 2018 03:33:30 -0800 (PST)
Received: from jagan-XPS-13-9350.homenet.telecomitalia.it (host230-181-static.228-95-b.business.telecomitalia.it. [95.228.181.230])
        by smtp.gmail.com with ESMTPSA id h2sm4276184wrv.87.2018.12.18.03.33.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 03:33:30 -0800 (PST)
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
Subject: [PATCH v4 1/6] dt-bindings: media: sun6i: Add A64 CSI compatible
Date:   Tue, 18 Dec 2018 17:03:15 +0530
Message-Id: <20181218113320.4856-2-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181218113320.4856-1-jagan@amarulasolutions.com>
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
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

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
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


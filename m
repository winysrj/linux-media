Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6158AC43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9222084A
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="ijpQewih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732639AbeLTMzb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:55:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53276 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbeLTMyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:54:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so1912978wmb.3
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 04:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wXbv4EStlt/WSU+EIZH0OlN5Zo9WGSHjVKnuaGSJ7JI=;
        b=ijpQewihuTYkryQcGkcJM6bC77RlvFBJu2BOUrCOX7wpmLZtlxWifNYRR0lUzzU0ja
         KOQQVbn4G4RUt/HDMWlzZE4CHNvoYLVU1UEKBwkESj8O7wDrTmPDbEWF40S6leMErK1C
         4t/vpBTxsZdwZy4VYe/++247zoVSvvDpJGzsA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wXbv4EStlt/WSU+EIZH0OlN5Zo9WGSHjVKnuaGSJ7JI=;
        b=EO2eW2fBBByuxRrJFmjOY5WdGr7qQ2e/7zFVTUmt3wm9jmCzpoY+nj7ivbSUMeUUWF
         G/6wtYuUMEF4zUUtTV97iHKVnaamkES6i6YFGxa9RVCAORp3OmgvyBAikB/vRZpKAY0r
         4cDwLx8iUqQ+r5bkFwuI+gxxxwVwX9/wKmi1iGnnFYxnvIwMW8LOTB4qBMy0nqCu7MaZ
         bbD4rs+s/+93QW9CeHnjSu0QHrhGE4CYlqHXKHGBy1hCItO9O7azvgIfR0LaHNOapt2H
         BMzWfblp78icoDDRmOkTbUFZFD0IJAoBpQXAbtsqxxFzo9QXVSCM5DgUshW9qINwtczg
         krIA==
X-Gm-Message-State: AA+aEWamEuAhSb53+MSFzKgRMZMf5WIuPjqDRGFYWyIo95Ek2pb0iPD+
        npU5WKh2n2Z+URYy4mlx/5gCWQ==
X-Google-Smtp-Source: AFSGD/W72Nq2p29nd5Y0/GilNYZEEzruQXAnlDDDKbMN8MsvknsXNocedBbaGuyVhWtp/8Q5+Eby5g==
X-Received: by 2002:a1c:ad43:: with SMTP id w64mr11012559wme.32.1545310490011;
        Thu, 20 Dec 2018 04:54:50 -0800 (PST)
Received: from localhost.localdomain (ip-163-240.sn-213-198.clouditalia.com. [213.198.163.240])
        by smtp.gmail.com with ESMTPSA id o4sm8732756wrq.66.2018.12.20.04.54.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 04:54:49 -0800 (PST)
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
Subject: [PATCH v5 1/6] dt-bindings: media: sun6i: Add A64 CSI compatible
Date:   Thu, 20 Dec 2018 18:24:33 +0530
Message-Id: <20181220125438.11700-2-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181220125438.11700-1-jagan@amarulasolutions.com>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
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


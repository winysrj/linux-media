Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA80C5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D43520870
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="YjpI9uyv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D43520870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbeLJLxj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:53:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53599 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbeLJLxf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 06:53:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id y1so10569069wmi.3
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 03:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Bcn7Nsev8NGAHdGxA2CyTs91LsMBI3kRpXrLo25w3c=;
        b=YjpI9uyvVGMO6LS5MdUtlDjNGajW/FxA6Mjmxj1N7ULm0sxFRRnvPJwI+Da0lyCCuh
         0emA8jKtCTc3w14tUfuYj0DaorNBATkK+WEDslNItPHrlDC8DHcoery6lyYKzUgcxgDw
         72oUss0aiUtgGOdirmzlx8LGQ4/4v1CNXMjyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Bcn7Nsev8NGAHdGxA2CyTs91LsMBI3kRpXrLo25w3c=;
        b=a+5V2oTesjujoFzf3KqAHLGHInr2SI6FcYs6EJ4fGvxhkpPbLkmjfV1ZDvRSg3bH2H
         oY2q5DRPcM89KU8bu1KOap7pFfNyyG3H1RnS9rjBfsch2F+VlLtA2SdZCFBayMtZzlSM
         jG0ZwQPTix2mjGtB3k5fPJUaSjc1rKCtiO5Wx6WF6fPmi4u/ZWptWCpNR3H82/pqFfLP
         Cccy/W4H2RlS3CcxWwd9sl85UF8Y3UBAfFgNfXelnjLms/od10A9yRzQ0/sXuVET+oDo
         /GEj6TLHh2BdP/l4nn6JeGJJTPS2SvDD/waJ/icv1DEsINkfQtu6I8v3WWyV6zkUXimf
         BjBw==
X-Gm-Message-State: AA+aEWYa0aYv3uTaVB+1c6HjOarYC49DqMFbYtnWLjwtkDUAHeKreUYp
        e1FdrmlvymCwBvwmi8Va57nSUg==
X-Google-Smtp-Source: AFSGD/WneMvv8yoBR7/U/wN5Xra1d6NpoFupLgw9CXDW+dAJHlajBAGIBUqpgVAnXY/wCmr+DuSI6g==
X-Received: by 2002:a1c:ac85:: with SMTP id v127mr9183651wme.62.1544442813661;
        Mon, 10 Dec 2018 03:53:33 -0800 (PST)
Received: from localhost.localdomain (ip-162-59.sn-213-198.clouditalia.com. [213.198.162.59])
        by smtp.gmail.com with ESMTPSA id b16sm7869243wrm.41.2018.12.10.03.53.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 03:53:33 -0800 (PST)
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
Subject: [PATCH v3 3/6] media: sun6i: Set 300MHz mod clock for A64
Date:   Mon, 10 Dec 2018 17:22:43 +0530
Message-Id: <20181210115246.8188-4-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181210115246.8188-1-jagan@amarulasolutions.com>
References: <20181210115246.8188-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The default CSI_SCLK seems unable to drive the sensor to capture
the image, so update it to working clock rate 300MHz for A64.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index bbe45e893722..4b872800b244 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -822,6 +822,11 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
 		return PTR_ERR(sdev->clk_mod);
 	}
 
+	/* A64 need 300MHz mod clock to operate properly */
+	if (of_device_is_compatible(pdev->dev.of_node,
+				    "allwinner,sun50i-a64-csi"))
+		clk_set_rate_exclusive(sdev->clk_mod, 300000000);
+
 	sdev->clk_ram = devm_clk_get(&pdev->dev, "ram");
 	if (IS_ERR(sdev->clk_ram)) {
 		dev_err(&pdev->dev, "Unable to acquire dram-csi clock\n");
-- 
2.18.0.321.gffc6fa0e3


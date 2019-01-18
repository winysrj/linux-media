Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762BFC43612
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C2820850
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="V52neNJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfARQcX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 11:32:23 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46776 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbfARQcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 11:32:22 -0500
Received: by mail-pg1-f195.google.com with SMTP id w7so6269781pgp.13
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 08:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AcTNJoiSIr2UvGcIYC+6yeK1JimQepwB20Vv9L6yJsk=;
        b=V52neNJr+5s5Ws7YreKtc2b0uXnFaD/GlUykSFfQFbUBiHU1Y5clMVBSrpHzW39P4d
         r1Dkduqwp8D1wV6rlNp4bKfRDblmhN302+64PH4JhlZ2akOt82XQgeIfQ6wDBq3SG9Na
         6pB6Gm0FeqPnXFlvl9K0nySUPInlzSdgm7q88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AcTNJoiSIr2UvGcIYC+6yeK1JimQepwB20Vv9L6yJsk=;
        b=qmorKer+xZEOGrNTBqtivOgCuIj6cRpggcISZjVuWY1eQj2/9b0NbBi/SmbQOKwm3G
         GEs/E/0Gcqyb4J/iLt/pEjOf7W0NYepN7MYFT07Z3f/7WbZnuf1lmEr+TQobr0QwM52d
         nAGXTSMj935JFQbIVJLU236Daerq0pzbCQuIo/jkV5C3ap75n9KUnCWRKnJN4nBi1Gu0
         u47a8NEMqesJOkI613qv0j8KYRu3t3au9/4ffaXyVnPINamPLM8edHv+9QNJ2MF32KIF
         vucS+Y3DOiqDdmZFvEP+bpEqxFAM946Gt/hETaHg/3I2/o0wbAY+Sovz547BX32SgxzO
         KHWw==
X-Gm-Message-State: AJcUukerDSKoumkIvZNrgthmATQaPBn7Vtgm7ewOANQFuzZtvVNIg+Ax
        e0UBcutqdgP2ki6z2tYvJC8FUg==
X-Google-Smtp-Source: ALg8bN4o3QTXvzSyHghbovl3uuhczhuTH4f7BPtE96v9dSt5mHU0Qhbh1OmAJLTa98g0kwf0LPl6AA==
X-Received: by 2002:a62:8985:: with SMTP id n5mr20180814pfk.255.1547829141742;
        Fri, 18 Jan 2019 08:32:21 -0800 (PST)
Received: from jagan-XPS-13-9350.domain.name ([103.81.77.13])
        by smtp.gmail.com with ESMTPSA id z13sm13967086pgf.84.2019.01.18.08.32.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 08:32:21 -0800 (PST)
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
Subject: [PATCH v6 3/6] media: sun6i: Add A64 CSI block support
Date:   Fri, 18 Jan 2019 22:01:55 +0530
Message-Id: <20190118163158.21418-4-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190118163158.21418-1-jagan@amarulasolutions.com>
References: <20190118163158.21418-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

CSI block in Allwinner A64 has similar features as like in H3,
but default mod clock rate in BSP along with latest mainline testing
require to operate it at 300MHz.

So, add A64 CSI compatibe along with mod_rate quirk.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index a9aef630c3b4..d03559d27066 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -909,10 +909,15 @@ static int sun6i_csi_remove(struct platform_device *pdev)
 static const struct sun6i_csi_variant sun6i_a31_csi = {
 };
 
+static const struct sun6i_csi_variant sun50i_a64_csi = {
+	.mod_rate	= 300000000,
+};
+
 static const struct of_device_id sun6i_csi_of_match[] = {
 	{ .compatible = "allwinner,sun6i-a31-csi", .data = &sun6i_a31_csi, },
 	{ .compatible = "allwinner,sun8i-h3-csi", .data = &sun6i_a31_csi, },
 	{ .compatible = "allwinner,sun8i-v3s-csi", .data = &sun6i_a31_csi, },
+	{ .compatible = "allwinner,sun50i-a64-csi", .data = &sun50i_a64_csi, },
 	{},
 };
 MODULE_DEVICE_TABLE(of, sun6i_csi_of_match);
-- 
2.18.0.321.gffc6fa0e3


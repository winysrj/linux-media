Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF90C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3EB2083B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AjCI9+JM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfBFK0V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50496 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbfBFK0V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id z5so1874089wmf.0
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9uMMPdkJCtwwiAQ2DAjUCT6O07s1f5ZO4Mq8oQ/Fa8=;
        b=AjCI9+JMX12f5eBo3Oge+tqpofYBF971j1Dkg3bHYjyC+Q88BzC4SZiTWPvifBDCqd
         MZFB1G6jVrGpXfBhT1T+64woRp2U5vdmOIl9ucKcQKtcoaqE1esHYwECa4OXLl0JP+S5
         saDuCo4p2PO0yL0t6mAP+HVvuhmMB5kZFQHAqVub9lku/Nojlm7A9dkX5p7gQmUO81sy
         rSrbGrXt2WTnmGC41OTVy6IzQkCcixevUql1UOUpiYbcgsBHB85qREK+7cfPwiGeliEq
         Wn/hPYT7Uslql1ghW+K8cSokSvvn0txBuYI8+VcB96pkskYL+37Z+jGNTpmvRapb2OC5
         YINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9uMMPdkJCtwwiAQ2DAjUCT6O07s1f5ZO4Mq8oQ/Fa8=;
        b=QTypu+JfPsa17BASSW8GZpYPTnq9GbkDGWB/JzHEy9mHh1ofJrDoC040j2dtF7fRzz
         21BbbYYqtQAg+ZuMNcMPy9u5XxPjRd6Pktf7itQ+tfuPh5uR0unc5P4a9R+3fnV6HhGA
         mh37hhoxoMqfPUngikOIAs5c6P3NOjmZxHY1GCajT+7MsfulD1hzIBi52V6y0pbdwYBO
         /UHARtxXnDn09cliSsLAJEH1WmSaUqDKtrRYAqDUMoL5dPaZxAKqPqHmbTmBR8KZkCCr
         6H8rretV1p1mtQUeNI6NEbiiZJvfCjiB9/Fwo+GNCmhAsuilynNPNip5ZdxLN+yIp9AO
         ddNw==
X-Gm-Message-State: AHQUAuahHb6V0osa7ZzfpwaenWYWZMeBsW+1VNxrsB6j+9JjV/WGGapr
        KfuHV5YR27o2/BOJgQs7+sPbXw==
X-Google-Smtp-Source: AHgI3IZOdqTNLT0YwAUnBRw24sDhXGVPUGWdtoIj67EvYm2Sykegp+spzm6ADYs5bAvx+uQqR8knbQ==
X-Received: by 2002:a1c:2007:: with SMTP id g7mr2486138wmg.79.1549448779314;
        Wed, 06 Feb 2019 02:26:19 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:18 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 13/13] media: MAINTAINERS: add entry for Freescale i.MX7 media driver
Date:   Wed,  6 Feb 2019 10:25:22 +0000
Message-Id: <20190206102522.29212-14-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add maintainer entry for the imx7 media csi, mipi csis driver,
dt-bindings and documentation.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e211916d2bc..d8e0c9040736 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9348,6 +9348,17 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/platform/imx-pxp.[ch]
 
+MEDIA DRIVERS FOR FREESCALE IMX7
+M:	Rui Miguel Silva <rmfrfs@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/imx7-csi.txt
+F:	Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
+F:	Documentation/media/v4l-drivers/imx7.rst
+F:	drivers/staging/media/imx/imx7-media-csi.c
+F:	drivers/staging/media/imx/imx7-mipi-csis.c
+
 MEDIA DRIVERS FOR HELENE
 M:	Abylay Ospan <aospan@netup.ru>
 L:	linux-media@vger.kernel.org
-- 
2.20.1


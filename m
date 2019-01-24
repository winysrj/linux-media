Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A793FC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72A6F21872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jSbplplt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfAXQKG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:10:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45945 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbfAXQKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:10:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id t6so7043364wrr.12
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8IBIrFG6qOQny2BFb8zfG+j0ULZivadQuD97Xx/Nde4=;
        b=jSbplpltr1tgUPAUirt1+jqnbLu4pju+x97/3CjvnAsp+87g9Mul/1xzEVb4aeiDrZ
         bmeO2bik4Cfi7914Ok5Ial4yr6qxuCfzntvik//qOIGImifJR7sefNxvVLWCVdXLZ/qJ
         AamCt2SmrGZl+mdzBKdRI9J2MZN748sWgtkjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8IBIrFG6qOQny2BFb8zfG+j0ULZivadQuD97Xx/Nde4=;
        b=EQQ5Arq1jcB18fzwS/ZM+OF/k/EvYKX9OFLb3523XPPJEqNDsQyTGKVpow+dRxuTlH
         ZgCA+yj5ASnBF+nQd25mUIrJyW/wd31POsp+RjyK1QdS2FxtEZww9Gvy+GwuJjBtJPLp
         L0MDmqnFCjdyB/hjnapwfX0xK37vOBhwKRMWdRI/OsMRW8V2k7vCBkK0qD6Wc2QnGWbz
         pVmAIZbOh7LgjuCireJHsibCQiAMiDJoObJMP+54v6y+3rK473eZs8R6J5WqcD9oCq9n
         x32/VzcpW/uU3xEd/JPRP8mD51VSTLkEFLKoyb6lVHx/2KLoLGwUrbaQZlPqntgQS0dy
         wjiQ==
X-Gm-Message-State: AJcUukfZlVYlssCmHrbtKHEL+Gy2jV3WVX3expUqTkR4lktqtkwWZcMF
        P1ZpUz0J/6glXemJIaQ8JWL0cA==
X-Google-Smtp-Source: ALg8bN57xL5+k0i8LL9EzN2W/miwh0LwxgE7L8r+0BYTVaXZMHAr8FfY36Oe1EJccITdXpcVnSw9FA==
X-Received: by 2002:a5d:5208:: with SMTP id j8mr8078773wrv.188.1548346204377;
        Thu, 24 Jan 2019 08:10:04 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.10.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:10:03 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 13/13] media: MAINTAINERS: add entry for Freescale i.MX7 media driver
Date:   Thu, 24 Jan 2019 16:09:28 +0000
Message-Id: <20190124160928.31884-14-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add maintainer entry for the imx7 media csi, mipi csis driver,
dt-bindings and documentation.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51029a425dbe..ad267b3dd18b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9350,6 +9350,17 @@ T:	git git://linuxtv.org/media_tree.git
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


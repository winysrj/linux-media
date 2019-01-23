Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239FCC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E71C121019
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="fZMTkykL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfAWKxQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:53:16 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46238 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbfAWKxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:53:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so1820926wrt.13
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8IBIrFG6qOQny2BFb8zfG+j0ULZivadQuD97Xx/Nde4=;
        b=fZMTkykLlypxqA8+69RC0Je6H+H+ZbN45CWChnIfsuGIN5uA3IqlbutJut4pUMPOhZ
         EBYVieOZpkUKTJHk8PAo7vuZQcKFQbod8av0nB9PVUv3+UBhCGndiO52jY/OH8XfAOpg
         pjvPvIZ9YiLUcRlaNS3OSL9BzWGEvM/2K1G4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8IBIrFG6qOQny2BFb8zfG+j0ULZivadQuD97Xx/Nde4=;
        b=aecmwQAEkKeo2HYkufbXgKz/whTRXlqk1R1tzIB40zzCGxNnCT6ay1Ggu/B97tJa/u
         77faDEYuSPSoZhHdhrCELbRSeMhKgKmGADogSKltfsBGAC8FwO7rTzqQNm4/V/sSaRtK
         ucCl7sE1+YrGgzUnhZ0/ulBEed4/9TMc+2VqJEPgWpBDQ8yHegLtVbc8yThmLQx+PL+E
         /w0cHjjsc3SLpT6pDoGKlpCAzJc1KOc6p1JGTWgOhM1VEgaQSla/kACckrfBLmrHS4Yj
         +CGZ0XhkeDfwnaCukEJ8dHGSkGOvhqR6cMbSO1cjWSVIOJS322gAMGEHKFT55m82Hx20
         zarQ==
X-Gm-Message-State: AJcUukcrcQO5zKAkj4LVHLzUHY5Xzsrqjny5KhC9bouydQqtyG4LdlEp
        +W3Irm618T9sZAozg/62YZGyIA==
X-Google-Smtp-Source: ALg8bN4dQpT/XBioisyNtgcxWawI1FzRsNIbtmvB80+3GVGuECL8sd9bf1fnLogk1Z6cstVjvIzGBg==
X-Received: by 2002:adf:f691:: with SMTP id v17mr2069763wrp.114.1548240793784;
        Wed, 23 Jan 2019 02:53:13 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 143sm120717646wml.14.2019.01.23.02.53.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:53:13 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v10 13/13] media: MAINTAINERS: add entry for Freescale i.MX7 media driver
Date:   Wed, 23 Jan 2019 10:52:22 +0000
Message-Id: <20190123105222.2378-14-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123105222.2378-1-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
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


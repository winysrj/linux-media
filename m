Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE44C282CB
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3B1217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:48:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ho8bMKIT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfBIBsB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:48:01 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35276 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfBIBsA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 20:48:00 -0500
Received: by mail-pl1-f196.google.com with SMTP id p8so2535668plo.2;
        Fri, 08 Feb 2019 17:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3w1ZGnPWLWsPLUCMvmcd6xOmljpJ1mYZFLF4k+OJhIU=;
        b=ho8bMKITLlsBHmcfEfN+hEo3gwG8h6kqqoiJPbovFEymfo1vATaKQJGmOE5nwEVSNE
         k4GMTenRkw24PuQLVh7FwlsAiHzdjeTDddEK3ZdF6sOhxb1hQZ2IEk8foONtT2E+hPkI
         ilbsiGvnFDXP6GBMiIiz2dBymhRspB0PMErIjw2msmIgqxWfchZcOqE6tRhMqrnXjczz
         7S7+qNHO3YZB7shuVl/7OjYu5F0uM5mtZJa5afbhWbBehbZA5kX+V2WNKmwOZvuXLBXm
         Y0Tktmc4sT4sAuAiILgXhRNZFfvJgjSk6xFcYbT7UVNj4KGwqagwjjRBtgPnRw6FucOZ
         WdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3w1ZGnPWLWsPLUCMvmcd6xOmljpJ1mYZFLF4k+OJhIU=;
        b=qr66Y0CIot4/JeAchsYJPbLcv0J09T4upTZByYydrs2bPogNivOp4oyVuutq+a6riO
         Ibj94zXplhycgRMOzwlOV2VppsNhdcBE5296ewnLRc4Nvpj5mo/BP0LU8nBnP6rwMcr6
         aHoLRMSGQ2QilQx2Ht8LymKPOU8FYRA8CpuqzTRfUULLqaTMuQkwN0YVj7aEQoRP+KFk
         mZXJ4d2LqFVxEzHEj6ejsGM70fodPp2MUjR+llKMsNOhYjH2V78CtzrvFezyI6Uzzb7p
         eD00nWAqgbJtbPW+RT48co7a+qsb1vMCHtcm6dvLg2v859QgE4X819dLTio60n0qVVaY
         JUVA==
X-Gm-Message-State: AHQUAub8V0JDyGkfa+x2b+j9V/dFx7u3iSdl7o6wCLXD90phzeOJeoMI
        MrC+BIyDa4oWwSs376biZW0q3ni3
X-Google-Smtp-Source: AHgI3IY3vJo3kTRgtRisAUKAALoi0RkQIVnn0JCoEDwRJNi5dgXsLNPtwOyrbwOOHYSpOR5F7hnsNg==
X-Received: by 2002:a17:902:bcc6:: with SMTP id o6mr5327685pls.39.1549676879371;
        Fri, 08 Feb 2019 17:47:59 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id p67sm4305393pfg.44.2019.02.08.17.47.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 17:47:58 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 2/4] gpu: ipu-v3: ipu-ic: Simplify selection of encoding matrix
Date:   Fri,  8 Feb 2019 17:47:46 -0800
Message-Id: <20190209014748.10427-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209014748.10427-1-slongerbeam@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Simplify the selection of the Y'CbCr encoding matrices in init_csc().
A side-effect of this change is that init_csc() now allows YUV->YUV
using the identity matrix, intead of returning error.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 3ef61f0b509b..e459615a49a1 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -244,16 +244,12 @@ static int init_csc(struct ipu_ic *ic,
 	base = (u32 __iomem *)
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
-	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
+	if (inf == outf)
+		params = &ic_csc_identity;
+	else if (inf == IPUV3_COLORSPACE_YUV)
 		params = &ic_csc_ycbcr2rgb_bt601;
-	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
+	else
 		params = &ic_csc_rgb2ycbcr_bt601;
-	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
-		params = &ic_csc_identity;
-	else {
-		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
-		return -EINVAL;
-	}
 
 	/* Cast to unsigned */
 	c = (const u16 (*)[3])params->coeff;
-- 
2.17.1


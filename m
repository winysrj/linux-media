Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64986C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3525F20855
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpgbCNha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfBHT24 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:28:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41807 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfBHT2y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:28:54 -0500
Received: by mail-pg1-f195.google.com with SMTP id m1so2003912pgq.8;
        Fri, 08 Feb 2019 11:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3w1ZGnPWLWsPLUCMvmcd6xOmljpJ1mYZFLF4k+OJhIU=;
        b=UpgbCNhaVTHY2xLtiscAMNOIIDcLdSl6tFGaEEYCKyEavYa7wtNzKyH5XQT5UBSpc2
         9P8UNKuv6857rWRSH9g8MqT5yrhW+C8xGpbdQIH1xmzDTq8r6TPI3f91wJSjCmWrLIsB
         PLKJ8YB6e5X13ZNK9Jhet/nXq4YtBQDOvwJJk+v2mVnylgsQOfthIM1ED4Bv3Dnvp7cG
         gc9VvDBKphm0J8G5893F1giX2vmiBC+28AzXLLuW2T7p8PBLA6zrbmzbOkSdFACLUOEI
         UdybG5RogK416kWXp0oodGnepvg0libBClBzxzs7DKM+xg4yDcmHke8EwyQb/Iw9s32m
         9bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3w1ZGnPWLWsPLUCMvmcd6xOmljpJ1mYZFLF4k+OJhIU=;
        b=g+czOD0PToUAGIEeTTu8wczEXXd5SoAF6xRbJ8+M/1zYhaDhnD7dZh3fj5asZKXx++
         GCdF7CG/NjNsLJYo+u55iCQTqM3cULH/hjp30J4rqfHPyQPu2b89knjznSrZuM064yK8
         H0+mIwapJmavZ/9RlT52lYsxvaNl3Obu2YjTfous0PduZLxPSdoo4Qez63lBRbdjYC+i
         vn5jxwHPqWoW/c6qF+/JLdpiAHAkT826lD5v6PEUmlFDmLGCUP99pZzY3/neNd4MpJCg
         ljw+4UIO1SejrUSMUY5A0TlBfRDlLjisvquD1VS21WFn/xRlnVrYZPXG5y5WpG4NXgnR
         Xmbg==
X-Gm-Message-State: AHQUAuYcvSk/UZB9NTllXlyBFDZXrE3znHVeUgf0fDQkiOMYUiJjaLDv
        0662I7loliYaGxSvXbV+0LVIg1vy
X-Google-Smtp-Source: AHgI3IZ9xloEX+FlRQlYVbXSRHVwOw/h8kzxAJzttFWEyQVp04aXsA0+Epem0FK2nxKr3nzQkZ/P4w==
X-Received: by 2002:a65:4904:: with SMTP id p4mr6947876pgs.384.1549654133128;
        Fri, 08 Feb 2019 11:28:53 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id e128sm4443129pfe.67.2019.02.08.11.28.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:28:52 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/4] gpu: ipu-v3: ipu-ic: Simplify selection of encoding matrix
Date:   Fri,  8 Feb 2019 11:28:42 -0800
Message-Id: <20190208192844.13930-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190208192844.13930-1-slongerbeam@gmail.com>
References: <20190208192844.13930-1-slongerbeam@gmail.com>
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


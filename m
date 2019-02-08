Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AB7C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA68217D8
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ta7wPGWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfBHTTk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:19:40 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45094 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfBHTTi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:19:38 -0500
Received: by mail-pf1-f194.google.com with SMTP id j3so2112741pfi.12;
        Fri, 08 Feb 2019 11:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FMVIZC+Ut3hCcGkIAGAKElPF0VEiGdyoGwVPSPpdJa0=;
        b=Ta7wPGWBkdp/5vb9tEtLtLCG/RIYUlN6J8+HuOmvv5sgi2j6AbY9+7QNBhaGi848vF
         o+818GtdTGn+h6sJqZooFlM9fkLAhP8iI9hUJvNMldMV5v+SiFgsCN2hTtWlXTPhrKkE
         CL1vYywI67LlqzgrzlScRDUL++kAvK51xfnG6waV2izi1N2Y+AeKUob/iYtFwxiPVBqU
         cVGSW9lOLA3zVKEve+qXKmO4oqyZOKlepoXArN0kO9LT48vJlRMtCEOKUJWNvQa2zKex
         UAdLa5JDlaE2S4qIF6RPmp3JX9ZG7EUDubkKh6eJpgTS9WdGp58TbkYODf85nl5mH7eS
         STsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FMVIZC+Ut3hCcGkIAGAKElPF0VEiGdyoGwVPSPpdJa0=;
        b=H0LrIGcWxnZXuUYNOcnj/vff7L3Q0k3JbqR0ocLoDFJRZlHcAoX+Othm267+Z7RQSP
         gYPPLRiDLiwKdezTLRYtvjm7d40IVlH1Xe+3CiAUYluH62sffVcOOggV62zJLA7XonaK
         TCKEvEIjLkMiWS1a9o/N2k2uugWo3pYc6/fzVqvsk6+FS1LdTGhXKvR2QyfkMSFVCTnN
         /ENdG4o5anbAW09b2kXjfD80qxwdwxMCBvPqXm+t6e3Sbc4CODgrT+2GOa7FbKiyltvC
         RP+uGvI/e+RYJgiBqSUbR8B6zRQ/vUSVMjJEBYdJUeisiGR25KxXeHtkKZTZim5dXmOA
         59kw==
X-Gm-Message-State: AHQUAuaTODqrPlP/cH8UdePhR7qzCLWlZu8I49jv/PDlR9VzADTMf7q4
        YDEJQCM5lfHk0gRcITJtyEW+wv9K
X-Google-Smtp-Source: AHgI3IY2oMmOmQmLij9hkZFlL8X+I4haiIzq8sW0jlH2v71bkIMkH9oajNof8unrgs+p1VFtdGDABQ==
X-Received: by 2002:a63:5e43:: with SMTP id s64mr21933216pgb.101.1549653577436;
        Fri, 08 Feb 2019 11:19:37 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id o5sm4761817pgm.68.2019.02.08.11.19.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:19:36 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/4] gpu: ipu-v3: ipu-ic: Simplify selection of encoding matrix
Date:   Fri,  8 Feb 2019 11:19:26 -0800
Message-Id: <20190208191928.13273-3-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190208191928.13273-1-steve_longerbeam@mentor.com>
References: <20190208191928.13273-1-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Simplify the selection of the Y'CbCr encoding matrices in init_csc().
A side-effect of this change is that init_csc() now allows YUV->YUV
using the identity matrix, intead of returning error.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
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


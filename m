Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC61C43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D15B320851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpxH99Mi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfAQUtc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:49:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46891 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfAQUtc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:49:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id c73so5379511pfe.13;
        Thu, 17 Jan 2019 12:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UE+B2YfptHacugBOCw2gEIV1Rz9SUGZy1HzhzKDbTTE=;
        b=fpxH99MiE2fPDYlKz9VG+tdABZCK5dM9pYWw+jpiZBNIL8NN3wQ5q7fUcK0zXZXTHT
         cftrrBoVFusWi9yVGkp8IqC8eEzKS8qBIAbfgS1+buN5c4gXMHg4mSdOZjbaBirwbm2e
         V9+9jKy0rJNl2D3lEPSzozuQSx8DAL3mAU2XxOFATXfT5711/b6xE0+PxSaTD5WbO47P
         9y+7xBvJL/+sGa80V+VQ39BlrpbENV9SaXLIPu9WEUeg2He7thRcSr0TRQwhDXo523Ik
         rE0sbLFScYl6guV+zgUBVyZScGdcafNqF2kIuHd8lla+fj5rhpPrf/F8AVAZToKL2eAV
         gP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UE+B2YfptHacugBOCw2gEIV1Rz9SUGZy1HzhzKDbTTE=;
        b=PRrlkR3why2htzGAw75PbVYFGsQTEBGf0uj/myG3ya7a1yzjMUNrjUMHdsbCcbhNgi
         GHAX5700VBiY/j5iJT90w12vSXshkH33i8PeBP+zzuEwAOGcRryeKSPZTg7NTWUhuRIo
         EZlHVIxNtNLca9ydH73yXs79BxN22HUEvfK21Bll31ozBBbmD9QnODFXOrEc07/3lhRc
         CnilDFaKY26RPWkrXQHU52Knyhss7LIgPaMYfaVTCKOFF5WldXdh5XQF+WZQS1AprRNA
         ZoqqNFyxMneZb/nB+mq/n5CdZk5rCT2pCUGWzYlfLwVnFDgTV4D9eRL/xeGAvKw6U19n
         mXEg==
X-Gm-Message-State: AJcUukcg9hxRu63XUQBYxSUFp4jm9jj/TalBEoLhdaUxFQtt6/491Su/
        fK1FOTp/Rtd+ZtVXsQEGNUl547JcDHQ=
X-Google-Smtp-Source: ALg8bN4JtdtYKtrV73hHI6h6Ef2qVOtZL6B6IGMRjarlKvFI8JgagDM6HAfST53wyScES2PrhaOV8g==
X-Received: by 2002:a62:6dc7:: with SMTP id i190mr16468375pfc.166.1547758171430;
        Thu, 17 Jan 2019 12:49:31 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id b68sm4007481pfg.160.2019.01.17.12.49.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:49:30 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] media: imx: csi: Disable CSI immediately after last EOF
Date:   Thu, 17 Jan 2019 12:49:11 -0800
Message-Id: <20190117204912.28456-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117204912.28456-1-slongerbeam@gmail.com>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Disable the CSI immediately after receiving the last EOF before stream
off (and thus before disabling the IDMA channel).

This fixes a complete system hard lockup on the SabreAuto when streaming
from the ADV7180, by repeatedly sending a stream off immediately followed
by stream on:

while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done

Eventually this either causes the system lockup or EOF timeouts at all
subsequent stream on, until a system reset.

The lockup occurs when disabling the IDMA channel at stream off. Disabling
the CSI before disabling the IDMA channel appears to be a reliable fix for
the hard lockup.

Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")

Reported-by: Gaël PORTAY <gael.portay@collabora.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
Changes in v2:
- restore an empty line
- Add Fixes: and Cc: stable
---
 drivers/staging/media/imx/imx-media-csi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index e18f58f56dfb..e0f6f88e2e70 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
 	if (ret == 0)
 		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
 
+	ipu_csi_disable(priv->csi);
+
 	devm_free_irq(priv->dev, priv->eof_irq, priv);
 	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
 
@@ -793,9 +795,9 @@ static void csi_stop(struct csi_priv *priv)
 		/* stop the frame interval monitor */
 		if (priv->fim)
 			imx_media_fim_set_stream(priv->fim, NULL, false);
+	} else {
+		ipu_csi_disable(priv->csi);
 	}
-
-	ipu_csi_disable(priv->csi);
 }
 
 static const struct csi_skip_desc csi_skip[12] = {
-- 
2.17.1


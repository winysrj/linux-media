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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CA1C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3603120868
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tp456RGa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbfAQUPE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:15:04 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35538 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfAQUPD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:15:03 -0500
Received: by mail-pg1-f194.google.com with SMTP id s198so4933962pgs.2;
        Thu, 17 Jan 2019 12:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sgUZreCQVIZO2d4p0RUgihsvFO7rMp1SP2qO9BGpjm4=;
        b=Tp456RGaPKmgPbzrfZamiIQS/S83Iz1KhTg+iLVJaP3Ew/R2WkxOGRya/w8fbD4PE4
         5j5KLb7W3UbGu+d6fZ6xhpOm6CCUG74vJWL1ooqAKHAZqeahFZXqnPkg6IZ1oXHxz4Hr
         ni29v4S6pn7qQA84WZoHIqKn5o0VsJfoTLxOm68SElHsWW9IP2Ny5NShMqCCWB1FYEkd
         +CmOZICJ18kZ/EyUJXWiIqhJVSnz+3qKZ8/EjPpzYrqRg/aR3cJDydG3bdLjiqh/cahN
         3Wjy2VHzIm9eC9pKp/YlbDA9o0tWqbnUNlG5hfqznXHvrqRqlv0T1V2vu9PRaSlr3ilk
         Oczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sgUZreCQVIZO2d4p0RUgihsvFO7rMp1SP2qO9BGpjm4=;
        b=T8PaWsoDyIMbkx2b4jVudPGBtTLu7gy+kcm0VY14+Gl+Ebsu1AR0eU1sEBJy5YiN+V
         YY8jYtPGChNzSxRTtr+oYBPXBQxCBIN50kYh7wn+OKlN/qUDKypmNB2drffRsYByefYI
         mryztiGGtTearHigbGkL2uWDDScturPoIRB+loc+pAQW1durhF3HXzXzCK5hZiZu8+Kk
         gXAxsl9AbvScn6NILkFZ2zqGgTog2sK5cGRnhOJTjXe3KM/+nnS8EmQH+5I+MKqGOmPQ
         yuGyL+bOqvVoSZcVM4Ie7UoGuLnR24j81BZtgLHCUf/Z29sQhQZ2uSNABPhfUiZpIOnG
         CofA==
X-Gm-Message-State: AJcUukd85TKg6L+qF2rL/4z77cXEMrOjpRfMmQm53iPCTYlN01fRKT6V
        TZupAZHg5a/UVSQARdJ30GX5KdjgtGE=
X-Google-Smtp-Source: ALg8bN6zvLLMKPuIZW0HZ2J5Edupli9GHYZwwt1hBP2WSRR3RP0D5GegC+qNWoajL7etWGTrvOx1tQ==
X-Received: by 2002:a63:d10:: with SMTP id c16mr14830267pgl.382.1547756102468;
        Thu, 17 Jan 2019 12:15:02 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id b202sm5600744pfb.88.2019.01.17.12.15.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:15:01 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] media: imx: csi: Disable CSI immediately after last EOF
Date:   Thu, 17 Jan 2019 12:13:46 -0800
Message-Id: <20190117201347.27347-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117201347.27347-1-slongerbeam@gmail.com>
References: <20190117201347.27347-1-slongerbeam@gmail.com>
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

Reported-by: Gaël PORTAY <gael.portay@collabora.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index e18f58f56dfb..9218372cb997 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
 	if (ret == 0)
 		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
 
+	ipu_csi_disable(priv->csi);
+
 	devm_free_irq(priv->dev, priv->eof_irq, priv);
 	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
 
@@ -793,11 +795,10 @@ static void csi_stop(struct csi_priv *priv)
 		/* stop the frame interval monitor */
 		if (priv->fim)
 			imx_media_fim_set_stream(priv->fim, NULL, false);
+	} else {
+		ipu_csi_disable(priv->csi);
 	}
-
-	ipu_csi_disable(priv->csi);
 }
-
 static const struct csi_skip_desc csi_skip[12] = {
 	{ 1, 1, 0x00 }, /* Keep all frames */
 	{ 5, 6, 0x10 }, /* Skip every sixth frame */
-- 
2.17.1


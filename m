Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09C7C37121
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E50A21019
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JO8s7M9R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfAUXgF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 18:36:05 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46387 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfAUXgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 18:36:04 -0500
Received: by mail-pl1-f194.google.com with SMTP id t13so10478091ply.13;
        Mon, 21 Jan 2019 15:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7mt13rUi4jE9dYaj01KrE4gIkA7gm0/yil0LZB/81Rk=;
        b=JO8s7M9RnAqcT25lPti3cHqi504z6BdpoX+Ir+3FEiJSpZq/MrgHwxE1ZBGfjgAcQa
         VwDWWUSWRdJgz3GJPEfyikHtRBHT2+RxjA87wETiVL94O7+R85vjDpu8jCeQY+I+CwhH
         iqtGJzTGpNSuhAERql9XUKxJeYO5bI85l3CM1B3u5Ufh/9O1rBHRLx3humkUeBNy9Oa8
         oXIwK4CRDbV2wnI/ded8gwtkzejuvIoybgpVW2Zdbg2UVYJRXFeMT0vv2l0GR3XN83Om
         tfhLLaB3NbAIbW8cWog5rDaLEVp3a3rJQpSELC1G/t9SP+9z12UlWlIN5q15+wZ+L8Z7
         A7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7mt13rUi4jE9dYaj01KrE4gIkA7gm0/yil0LZB/81Rk=;
        b=tPYHuhdLhB/M6Onbyvtd8iItngLd9LCETkz36uaDShGLuP0uEyDqYnFi4QBw1pUCeI
         7b4Ob0F0gCFu6rDgTwX5uTj4DWWF4BdVzj+o5HANttFm838CU9A63mxYPr2k9idWfvyM
         N8ZNnlMiiCJ7dwUEC3+07+qYpmV6tzbrDsVTP5Te4KNcY5Onid5xeTu6QYsrjU1chV5S
         VNLdZaUX41B4+oW1e7aBdAprwBU/go37bnHdRJ1K2z2yGiWEtYqHAi3pt+wTNPixGOd4
         Ew4DpIoaA/zUV277dN47SBrgx2gdqZBgSNJcndyNfZWqMUkjgyOAJnnSJYSeMzoVKpJW
         9hGw==
X-Gm-Message-State: AJcUukfGPYpit2aM2y6eHQXVdFvEP8mwMW6HAcXETFnyjMzSGl8jfGH4
        CntOro74MjIVCWRrzHSiHx70neVthuY=
X-Google-Smtp-Source: ALg8bN5BhyC10v/Aes/Bttmq1Q4H5Y2mwxUW4Q8OWIiTQTLs4yIFUZFurguB+lqPnJLgqQ5OPfdW2A==
X-Received: by 2002:a17:902:a6:: with SMTP id a35mr32030468pla.201.1548113763031;
        Mon, 21 Jan 2019 15:36:03 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id y9sm14016345pfi.74.2019.01.21.15.36.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 15:36:02 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/3] media: imx: csi: Disable CSI immediately after last EOF
Date:   Mon, 21 Jan 2019 15:35:50 -0800
Message-Id: <20190121233552.20001-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121233552.20001-1-slongerbeam@gmail.com>
References: <20190121233552.20001-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Disable the CSI immediately after receiving the last EOF before stream
off (and thus before disabling the IDMA channel). Do this by moving the
wait for EOF completion into a new function csi_idmac_wait_last_eof().

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
Changes in v4:
- Disabling SMFC will have no effect if both CSI's are streaming. So
  go back to disabling CSI before channel as in v2, but split up
  csi_idmac_stop such that ipu_csi_disable can still be called within
  csi_stop.
Changes in v3:
- switch from disabling the CSI before the channel to disabling the
  SMFC before the channel.
Changes in v2:
- restore an empty line
- Add Fixes: and Cc: stable
---
 drivers/staging/media/imx/imx-media-csi.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 7abfe0aa1418..920e38885292 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -662,7 +662,7 @@ static int csi_idmac_start(struct csi_priv *priv)
 	return ret;
 }
 
-static void csi_idmac_stop(struct csi_priv *priv)
+static void csi_idmac_wait_last_eof(struct csi_priv *priv)
 {
 	unsigned long flags;
 	int ret;
@@ -679,7 +679,10 @@ static void csi_idmac_stop(struct csi_priv *priv)
 		&priv->last_eof_comp, msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
 	if (ret == 0)
 		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
+}
 
+static void csi_idmac_stop(struct csi_priv *priv)
+{
 	devm_free_irq(priv->dev, priv->eof_irq, priv);
 	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
 
@@ -786,6 +789,16 @@ static int csi_start(struct csi_priv *priv)
 
 static void csi_stop(struct csi_priv *priv)
 {
+	if (priv->dest == IPU_CSI_DEST_IDMAC)
+		csi_idmac_wait_last_eof(priv);
+
+	/*
+	 * Disable the CSI asap, after syncing with the last EOF.
+	 * Doing so after the IDMA channel is disabled has shown to
+	 * create hard system-wide hangs.
+	 */
+	ipu_csi_disable(priv->csi);
+
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		csi_idmac_stop(priv);
 
@@ -793,8 +806,6 @@ static void csi_stop(struct csi_priv *priv)
 		if (priv->fim)
 			imx_media_fim_set_stream(priv->fim, NULL, false);
 	}
-
-	ipu_csi_disable(priv->csi);
 }
 
 static const struct csi_skip_desc csi_skip[12] = {
-- 
2.17.1


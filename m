Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A36C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD3520C01
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="co2XAFyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfB0PlC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 10:41:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52042 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfB0PlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 10:41:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id n19so6271672wmi.1
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 07:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2TeGbVhYNwXOTscc2WhGOxMaTE/B/Q/Nr7rh+1T2nEw=;
        b=co2XAFyqUR8ia7JupodlNPpH4P3DpgRKqubwXclnHLrh5IPA7PDdixwvU8ZJFce3uN
         voQghKLTDu6F82szco6SqyUn+tftZnE3yb/zjG+B3xbWrw67OBXJi3YELTom9PfvGANW
         7WhhF2Y/EZxny70Dnfim+CoRdLLlp9TvnkHP1wm3DU7nvSenp6gOOIIawZqA73OHX07l
         Wm3xVFfzBdzdfIZnF71/BYczSZB1favGEIzNg+Y2FGqYlzY2ATvTUn7928TJejDe+HhQ
         ZhSKhQDUb2cl+MDEiaM651w0b5BZ28rfbaxPH0xJXV0fdevvSD/qFaiz64OVCax+JdBX
         6D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2TeGbVhYNwXOTscc2WhGOxMaTE/B/Q/Nr7rh+1T2nEw=;
        b=Nc7mihD5QwFyXrhv/mywYb3S+eosthkaVOXrab0ZcOlHJvMwYV9AoXbTBlIVKkp7uC
         HYu/mqyQggoDN+xgLTz2w/a4SwqzUliG4PFxDEnPsOUtSPz6DX3drA2lVfDYLRecOzMb
         dG/YD7nja7vP9N77ThajSRq1CUfYSE0dY2zfwHC3ktQh9p+MsUX3aeJgXwLDH3SFshm7
         HLjj0xJ1jk46YZ31A6Ho2LAONyDIOJrjXWRjCO/5WSCEY7/lZ4LLGjHVVKpH7wrL0qH8
         uMclk9L5S1PStP6WLROq8jX/7ZGy6NRS2zzYgXw1EucOwZU0IIeCd6mq/sbsfQNrN6Mc
         FRyw==
X-Gm-Message-State: AHQUAuaXT9v5Y6r8TQziLIL7Ult/wDk+bhnzrKvgZYUyVTAD7enOYslv
        HWz/BftW0hJzotNK8pz+ct6zVQ==
X-Google-Smtp-Source: AHgI3Ib9g25KF+RtWXf8/fSdqbDmGjSREKsum8F3ClmFpVX5wCkvvQ/t73LJqOnJBuvMBpqLm4HYzg==
X-Received: by 2002:a1c:3842:: with SMTP id f63mr2730953wma.25.1551282060177;
        Wed, 27 Feb 2019 07:41:00 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id u4sm3180717wmb.25.2019.02.27.07.40.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 07:40:59 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH] media: imx7_mipi_csis: remove internal ops
Date:   Wed, 27 Feb 2019 15:40:44 +0000
Message-Id: <20190227154044.28860-1-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove code that is not called anywhere, just
remove the internal ops.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 27 ----------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index f4674de09e83..75b904d36621 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -783,29 +783,6 @@ static irqreturn_t mipi_csis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int mipi_csi_registered(struct v4l2_subdev *mipi_sd)
-{
-	struct csi_state *state = mipi_sd_to_csis_state(mipi_sd);
-	unsigned int i;
-	int ret;
-
-	for (i = 0; i < CSIS_PADS_NUM; i++) {
-		state->pads[i].flags = (i == CSIS_PAD_SINK) ?
-			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
-	}
-
-	/* set a default mbus format  */
-	ret = imx_media_init_mbus_fmt(&state->format_mbus,
-				      MIPI_CSIS_DEF_PIX_HEIGHT,
-				      MIPI_CSIS_DEF_PIX_WIDTH, 0,
-				      V4L2_FIELD_NONE, NULL);
-	if (ret)
-		return ret;
-
-	return media_entity_pads_init(&mipi_sd->entity, CSIS_PADS_NUM,
-				      state->pads);
-}
-
 static const struct v4l2_subdev_core_ops mipi_csis_core_ops = {
 	.log_status	= mipi_csis_log_status,
 };
@@ -831,10 +808,6 @@ static const struct v4l2_subdev_ops mipi_csis_subdev_ops = {
 	.pad	= &mipi_csis_pad_ops,
 };
 
-static const struct v4l2_subdev_internal_ops mipi_csis_internal_ops = {
-	.registered = mipi_csi_registered,
-};
-
 static int mipi_csis_parse_dt(struct platform_device *pdev,
 			      struct csi_state *state)
 {
-- 
2.20.1


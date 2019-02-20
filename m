Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C621EC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95EA721773
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Upt2BiL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbfBTAFo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:05:44 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40988 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbfBTAFo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:44 -0500
Received: by mail-pl1-f193.google.com with SMTP id y5so5656148plk.8;
        Tue, 19 Feb 2019 16:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P8PzRIifprMXFLbQqXKcG+mi2gnEr+W/CIJ2rU/DvCo=;
        b=Upt2BiL1PvcfCiCG7UGwgUAwn+0/gHLWJHGAIlvsiSlaa2+jyGY1V2taOV+6y+h/eW
         eK1W12cwujjoz81KJhC/hFLSuoPD55DEdzywB4B6dJITl8n1OiXeatJ/r8b+b/4s550X
         TrAky23eYf1J7yDKHkTjg5GiOcoYFyBpFVpJXFrTjfx3nwsor6//GeoR8bXonp3YPqdP
         ennKrPlKVUkeqSVvk2i1NiKhP14rH63CiEu7tQHQb9WMbuNbthcZQav3yN7eAfIxqJHS
         /zYvfWenhmlA1gOhrLuleeKfPGjXyFY7uMjJVLa1Y9XoceulC5NiHZx643AUCFs3oPEW
         CyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P8PzRIifprMXFLbQqXKcG+mi2gnEr+W/CIJ2rU/DvCo=;
        b=CnFEoHThYsllxyii3k0otyVuFnfdEq7kcglrksB9/W59CBUQ7EAoz6DNg+RaErC5+d
         N+JP0BY1K+0ZFOq/QnmWEoEOchXfqJrUvj4Oxzw0xrlXU6O8sJSgVPqMETh1CyzJGGX6
         XDjOXpI6J9e5o3rN4+NKSv8mCmXBSRiM29qO9Y+TE8YBeSRz8CiyFdxAU1R1NCcrmSuJ
         nR7PiGR0RCQzc1VJ2R6y2nfJrLq8R0+Q6Qua4sVQBzJ6S/1RhKcXarAj7GraVuNZwu6l
         SBw6SBbZijSpaQJydoxjpn+nPmDNtt6z4bvMTcr3fvE2wCHw9T2eimpArWe6ck0mei7i
         kmKQ==
X-Gm-Message-State: AHQUAubiXaQM/lsiQK8zJiVGaKPyz2swtg6v6zn2gnPCDcPBVQ03fYFK
        y0bewtKvdA4dtfe5+Lwo29U0dQ85
X-Google-Smtp-Source: AHgI3IblQ7cwR7BHCD+aTEO7Kh2+LS7B09WpvXzkx28JJcwkc11kxx1xAyvcK+tl8LAbGmLv58aX0g==
X-Received: by 2002:a17:902:28e9:: with SMTP id f96mr33736202plb.169.1550621142980;
        Tue, 19 Feb 2019 16:05:42 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:42 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 7/7] media: imx: Allow BT.709 encoding for IC routes
Date:   Tue, 19 Feb 2019 16:05:21 -0800
Message-Id: <20190220000521.31130-8-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220000521.31130-1-slongerbeam@gmail.com>
References: <20190220000521.31130-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The IC now supports BT.709 Y'CbCr encoding, in addition to existing BT.601
encoding, so allow both, for pipelines that route through the IC.

Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v5:
- rebased this patch on top of repurposing the function to
  imx_media_try_colorimetry().
Changes in v2:
- move ic_route check above default colorimetry checks, and fill default
  colorimetry for ic_route, otherwise it's not possible to set BT.709
  encoding for ic routes.
---
 drivers/staging/media/imx/imx-media-utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index aa7d4be77a7e..12967d6d7e1a 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -524,7 +524,7 @@ EXPORT_SYMBOL_GPL(imx_media_init_cfg);
  * If this format is destined to be routed through the Image Converter,
  * quantization and Y`CbCr encoding must be fixed. The IC supports only
  * full-range quantization for RGB at its input and output, and only
- * BT.601 Y`CbCr encoding.
+ * BT.601 or Rec.709 Y`CbCr encoding.
  */
 void imx_media_try_colorimetry(struct v4l2_mbus_framefmt *tryfmt,
 			       bool ic_route)
@@ -563,7 +563,9 @@ void imx_media_try_colorimetry(struct v4l2_mbus_framefmt *tryfmt,
 		    tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT)
 			tryfmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 
-		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
+		if (tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_601 &&
+		    tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_709)
+			tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
 	} else {
 		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
 			tryfmt->ycbcr_enc =
-- 
2.17.1


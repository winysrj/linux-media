Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759E3C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4620920851
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdZKE4TC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfCGXe0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:34:26 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33198 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCGXeZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 18:34:25 -0500
Received: by mail-pg1-f195.google.com with SMTP id h11so12529399pgl.0;
        Thu, 07 Mar 2019 15:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P8PzRIifprMXFLbQqXKcG+mi2gnEr+W/CIJ2rU/DvCo=;
        b=GdZKE4TC0S9c8xw8+pku6KC+IcQz7/oS14Iy+h8J6cKk9NVbzokbjPO2hKSv76TIOW
         q5scB74e2asaolmraqUT4gGkslMHc+8zUJLCKW39DVge0+Bilim4wfsEMhdvayc9qfQd
         1/j70CgaCrlJkIOOH91fo5EB7KezdTVxKcy0CHafgX5b2eevf6rwcMGRj7UoHRgG98+0
         4Hqo3dECx9KggtQIHZcOyxOZxZwHQuJge/pHuyeVnfJzdFgQrm4Uk/szy1+P4QZUtBLm
         XoHCm17ZNCsexhBJQJcft+BOGmXW6kNMoJZOluoHawILjjfG83tjnFy9FWPpDPYjnSre
         Dqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P8PzRIifprMXFLbQqXKcG+mi2gnEr+W/CIJ2rU/DvCo=;
        b=MZu7zKZfbhqYlTvQHdEPi+csnICjg1GQEHyfiuPWpO89Z01QaXEz35vImG405hYGBi
         bX8MxotZ9CRqp48jLipA6cfJ0Halk8PkNTpdLfrUEOP+rCwxkUB7SWxdWXQxWRBcIjFu
         LgfOi64aFZUCo69GUq+Hgi1y5U+nx8PbStkhP7BVxtnfmnCTvB2rjYHNDJiA361yFiNV
         TCJipFe8A4gQu5rAmBb3JaD2ZDnSlbdJEOPsafZokbjmqPXgYrp0O8e6UatBlkziLhaS
         +wa8OmqIddJe2KLrk5wCqNy65ufTAv+rQwgPsYM2AL+0DibIhYdOupONtCSAJ+k8fFax
         25Aw==
X-Gm-Message-State: APjAAAXoI8rngWnAjsoMAwTW6iGFJRQyLpaqGGepim55/PbaOhE9VKNq
        x8A6yIc/AOgXTev4LVKRqZSVD6d5
X-Google-Smtp-Source: APXvYqzQ8LpszS8ehLXd5/tWANBUlGB0FXPywtirqMfanTBtLoxYPof4d9gyysGtsSJ+4LxqVdCSMw==
X-Received: by 2002:a17:902:a5c9:: with SMTP id t9mr15129840plq.196.1552001663912;
        Thu, 07 Mar 2019 15:34:23 -0800 (PST)
Received: from localhost.localdomain ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id m21sm8684866pfa.14.2019.03.07.15.34.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:34:23 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 7/7] media: imx: Allow BT.709 encoding for IC routes
Date:   Thu,  7 Mar 2019 15:33:56 -0800
Message-Id: <20190307233356.23748-8-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190307233356.23748-1-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
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


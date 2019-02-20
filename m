Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF1BC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3CE20665
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/5LJykt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfBTXxm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:53:42 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40181 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTXxl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 18:53:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id bj4so13099302plb.7;
        Wed, 20 Feb 2019 15:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mC7/BJozzMqsSGt/tWTYsBoObNJbPhAY/mCxN2pyMkQ=;
        b=U/5LJyktqO84a+XdSt5KX+BwUhp8RGTTghpSNQC4U/gUSzyosHdqGrzJlMt66Idekp
         7NOK8GL3aUOPYHutev48pNO12nThHzuqqy5wig+BjnV+dP1ueLEfBdV1KvTctdihkvRo
         HXFFLtvOAWG6YRqlLO7Y+Dh2vTw+H1aQKsvquZHifr0MTIL4+h8HsH+09oXD+TGWL1Zq
         hM8FEDq9PNMX8+Qqycw/YXE4TgZIlxkkzo//c9BUanjk8f6iX995wpOypIai6AnYb0c2
         GZ65thIg8TRVdtzj9mOjK0jNfkf6op/03ynrWLmdPwPHqjtmHl2/ga72tpB4OaSmHRCd
         20Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mC7/BJozzMqsSGt/tWTYsBoObNJbPhAY/mCxN2pyMkQ=;
        b=i9ZznjY6mz8uGAtYjNdq9Is7PnC0xPP3z9jsk5AVUVzJtNnhQhb5ztw8ui7wSE+1/C
         aBUKFsMtOdEjNcyg/O2tKkaaSrPZh6pxHD0tM+dkbg/ahO/5asfb9d1pTpAb82YwZaG1
         62a0J8Pa9BzDnoNQuuc8Az2FSbi9tJ30LpCL1sD5JwnWH41h2S+qMNryOCZBhy+u3qfd
         oGW+IAjF3XUN0j4njPoSLdlZXPMruFV+stGrRu9/E1T1pIc3CgQbdnKHG3yMZCIwlvS2
         4CwRih5zbpfv7aqSR0SxsYazvDiW+y9JvDXYigeD2VbmN1gScZEEL18FoiXzlRDIUYfj
         TivA==
X-Gm-Message-State: AHQUAuYZlD2Njc6D4UHQ6mSXOaUtoXpN70dEiptPtcCaP8BJVE2xRNcU
        r+ACEb7zS2YD+ahfxF2rtGy6ETic
X-Google-Smtp-Source: AHgI3IbYIQ5qJX6jcvBTanrpXwi2sJBQy848d395KoSAsWUsJTzH0FfwImnzftLb9nf2xZc8AYANLA==
X-Received: by 2002:a17:902:6b08:: with SMTP id o8mr6005004plk.105.1550706820322;
        Wed, 20 Feb 2019 15:53:40 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id v15sm25530158pgf.75.2019.02.20.15.53.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 15:53:39 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/4] media: imx: csi: Allow unknown nearest upstream entities
Date:   Wed, 20 Feb 2019 15:53:29 -0800
Message-Id: <20190220235332.15984-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220235332.15984-1-slongerbeam@gmail.com>
References: <20190220235332.15984-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On i.MX6, the nearest upstream entity to the CSI can only be the
CSI video muxes or the Synopsys DW MIPI CSI-2 receiver.

However the i.MX53 has no CSI video muxes or a MIPI CSI-2 receiver.
So allow for the nearest upstream entity to the CSI to be something
other than those.

Fixes: bf3cfaa712e5c ("media: staging/imx: get CSI bus type from nearest
upstream entity")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-media-csi.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 3b7517348666..41965d8b56c4 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -154,9 +154,10 @@ static inline bool requires_passthrough(struct v4l2_fwnode_endpoint *ep,
 /*
  * Parses the fwnode endpoint from the source pad of the entity
  * connected to this CSI. This will either be the entity directly
- * upstream from the CSI-2 receiver, or directly upstream from the
- * video mux. The endpoint is needed to determine the bus type and
- * bus config coming into the CSI.
+ * upstream from the CSI-2 receiver, directly upstream from the
+ * video mux, or directly upstream from the CSI itself. The endpoint
+ * is needed to determine the bus type and bus config coming into
+ * the CSI.
  */
 static int csi_get_upstream_endpoint(struct csi_priv *priv,
 				     struct v4l2_fwnode_endpoint *ep)
@@ -172,7 +173,8 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 	if (!priv->src_sd)
 		return -EPIPE;
 
-	src = &priv->src_sd->entity;
+	sd = priv->src_sd;
+	src = &sd->entity;
 
 	if (src->function == MEDIA_ENT_F_VID_MUX) {
 		/*
@@ -186,6 +188,14 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 			src = &sd->entity;
 	}
 
+	/*
+	 * If the source is neither the video mux nor the CSI-2 receiver,
+	 * get the source pad directly upstream from CSI itself.
+	 */
+	if (src->function != MEDIA_ENT_F_VID_MUX &&
+	    sd->grp_id != IMX_MEDIA_GRP_ID_CSI2)
+		src = &priv->sd.entity;
+
 	/* get source pad of entity directly upstream from src */
 	pad = imx_media_find_upstream_pad(priv->md, src, 0);
 	if (IS_ERR(pad))
-- 
2.17.1


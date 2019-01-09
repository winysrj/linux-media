Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82B3C43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA37A20883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBKx023g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfAIAQd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:33 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41113 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729590AbfAIAQP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id b7so2722005pfi.8;
        Tue, 08 Jan 2019 16:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P/8QzMGhwKMfmIOAF2zlUPiFd1xnlUH+CAb9uo8OAbQ=;
        b=gBKx023g1sVQJfTSr8KqKyluUSy9n+5B4jeyffhSD3sh2uWQIR6lM2rbVXHhh52jRJ
         r5jzltiu4zgo3RpfNFV6P45bTIHCq5JJlUXtGesVIzWRxmvw73z17AXo1w7lur6eriB7
         zawWqG1yPfzOXiVeeKOQvRdIwmB0UsfyS3PJqUIxDT+vVpwElcwpl4xoOpFLee4mUFxj
         UHLn8flkVvBApKnpoCkfUNHoWIJDuqZxJlNM2hhjqKxWPk6gDheEyoxKs15n1+it0zN5
         y/Gc8/V6marjLuukUufLj+GvxBY4l5fJX5nfSQ97RrFbQn9jMpS2/I8Zq1SiF9sUs07j
         Drjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P/8QzMGhwKMfmIOAF2zlUPiFd1xnlUH+CAb9uo8OAbQ=;
        b=UB1KdeTXVRXZYR9GgZS+9QBDwav4lsi24ZGvuDm5dUh70Kdn6opFOMKgQ1XL5y3XhF
         6/5wLrA/Q1Uz3vamXnCAW9+9zILIUS2NLfXvhCvl1hCArmE0IHRaPcJP26BW1clskJu+
         c4Xa+GBv2uttWTvfLNobNtCO5Z/6H69ahs+iQb2IPt0Ok1fm+ZYGwdz7grqQMuA773Vk
         odXPQjAjWJZsV9UnqIwk3RY2MFabjZoTkrZGiykth0QbqbnBIWSCpYLIJMLmh9zoCW24
         7ILKd6uUIiAg9X2axTiAPEKIFPhOelWUhwqBbfc3EZ/Gky3r+El7TlFKsCAzYDKwM9py
         LqRw==
X-Gm-Message-State: AJcUukdfKAPEu7O8rnQ5hyDQGSX3RnaT60ijV0SClb6dPIiySagoIhQA
        aSrQgNYVSiDg2QIWgX3+O3QKPI5u
X-Google-Smtp-Source: ALg8bN7NhP7FGaas3c7/lMoO21UyXU/zgYe2R9ZbhRHWt75Fa8MIhjPwG/ytaDbm/Pl1NpsnGRfCnQ==
X-Received: by 2002:a63:4f20:: with SMTP id d32mr3416555pgb.47.1546992974209;
        Tue, 08 Jan 2019 16:16:14 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:13 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 10/12] media: imx-csi: Move crop/compose reset after filling default mbus fields
Date:   Tue,  8 Jan 2019 16:15:49 -0800
Message-Id: <20190109001551.16113-11-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If caller passes un-initialized field type V4L2_FIELD_ANY to CSI
sink pad, the reset CSI crop window would not be correct, because
the crop window depends on a valid input field type. To fix move
the reset of crop and compose windows to after the call to
imx_media_fill_default_mbus_fields().

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 27 ++++++++++++-----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 47568ec43f4a..7afb7e367d76 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1409,19 +1409,6 @@ static void csi_try_fmt(struct csi_priv *priv,
 				      W_ALIGN, &sdformat->format.height,
 				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
 
-		/* Reset crop and compose rectangles */
-		crop->left = 0;
-		crop->top = 0;
-		crop->width = sdformat->format.width;
-		crop->height = sdformat->format.height;
-		if (sdformat->format.field == V4L2_FIELD_ALTERNATE)
-			crop->height *= 2;
-		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
-		compose->left = 0;
-		compose->top = 0;
-		compose->width = crop->width;
-		compose->height = crop->height;
-
 		*cc = imx_media_find_mbus_format(sdformat->format.code,
 						 CS_SEL_ANY, true);
 		if (!*cc) {
@@ -1437,6 +1424,20 @@ static void csi_try_fmt(struct csi_priv *priv,
 		imx_media_fill_default_mbus_fields(
 			&sdformat->format, infmt,
 			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
+
+		/* Reset crop and compose rectangles */
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = sdformat->format.width;
+		crop->height = sdformat->format.height;
+		if (sdformat->format.field == V4L2_FIELD_ALTERNATE)
+			crop->height *= 2;
+		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
+		compose->left = 0;
+		compose->top = 0;
+		compose->width = crop->width;
+		compose->height = crop->height;
+
 		break;
 	}
 }
-- 
2.17.1


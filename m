Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E10C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05C520859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YU1XcOA1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfAISRU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:20 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34620 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbfAISRF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:17:05 -0500
Received: by mail-pl1-f196.google.com with SMTP id w4so3949706plz.1;
        Wed, 09 Jan 2019 10:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gcttxf1Z7z55ZyajsIidmjFu/+A5UNPbDLAEbT+eqcI=;
        b=YU1XcOA1BUV/xA4+JRFmA3xBUJHINYc/XRFQqhEwVYRzF5j5yF4ytQHLMj56Lq42Mw
         U1uT7c05QJdh4XgeYanL1kteFOy5BoYw7X/QZLZz2Kksps3UJi4mVVWbl/Wx8hALRs0h
         9dFBzgvXMMESVOgQQLF4446CvGewKpAP/vjEO4Z7stl5FTRJ09lrr6adXFw0Lkf5dh/O
         DVdaM5jnj9hcs987K7+4O3L9ITr3EexkZ+HScvYRaxSv2n3w4NVTNwdkjKtYOSC3HhCU
         bQZDZ+Pci9i53XAYEtMdWcScajgNDWE233xf2VxD9vCaOfV+i5uwOOEYn1QJxi6C5/BS
         sJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gcttxf1Z7z55ZyajsIidmjFu/+A5UNPbDLAEbT+eqcI=;
        b=PCclVlQneW5HU/nqWCM/GksVbUG7xk0iXyJU2+vTp1hGz7rdY7ZK96NcVSrlEievfl
         Xh8VYPGAV4JEbfDWpNyQZcUK/bHEdatgv6NpM6/YyKaNEyEq9Yv+Nd/uPAIKPltzzZcw
         K5ykm1YwLu4xhQEJI9MODU8R7DvdAiBbkJa1PUb4wbrdafcr+My2ul8iWQyn6OwgRGZk
         YwFRd+V7tQ1asTLsTt3hQcEyLPkxjCjYp5QW9KabylBptq9TuzM3d7jxbTCPbR9L4u/t
         azdHPLsJfDT3urTAH7/jJXX2exQ9VFZI7xpurtUjG8i9VWNClO8vbFFtTzjsJ3GCMimN
         hJUQ==
X-Gm-Message-State: AJcUukcxvo0zl9nzF4ct3wxvSApl8u9NBRhf+sACINRv9ipPPzAHJmvl
        RemW+iVQpJbdjwY1OUV1RJAd9M2k
X-Google-Smtp-Source: ALg8bN7T+2Lz4uVyIZWE4w1XghOnFARIg46351Ro2O/v/EptoDAEYvWdDalN4kLDWvaBcu1vW+vJtA==
X-Received: by 2002:a17:902:5a5:: with SMTP id f34mr7128444plf.161.1547057824032;
        Wed, 09 Jan 2019 10:17:04 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.17.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:17:03 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 09/11] media: imx-csi: Move crop/compose reset after filling default mbus fields
Date:   Wed,  9 Jan 2019 10:16:39 -0800
Message-Id: <20190109181642.19378-10-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
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
index 6f1e11b8a7cb..8537ecb7dd17 100644
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


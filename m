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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2872CC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB67921738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGtqIi56"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfAISan (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:30:43 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42997 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfAISal (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:41 -0500
Received: by mail-pg1-f193.google.com with SMTP id d72so3658376pga.9;
        Wed, 09 Jan 2019 10:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gcttxf1Z7z55ZyajsIidmjFu/+A5UNPbDLAEbT+eqcI=;
        b=WGtqIi5677wxvJBBlWB+mpYP5kk5raN2DbE9alnTtwCYdqkfRbJ9fuV9ahtXA9jzUG
         tCIYLEX7PbCxOya5CrW5taIQ1HVrvbceLd2EI1EXZl/0lhxYlgeg8oF/WRsP8rrdb/EY
         6iMbwy7lgAh3EO/ld3Y4G293Du1jCuQgvgSqvhFx/UGCmVeI5d3xfstqmf2/cz4GRHo8
         fdVUp+/duIDy8ZpE2J1bnP7sAxXpG8anof9xXzJVNzS5ZQbS8y59EOGn3O1/kJ6oCTvI
         2LIb9w0lZrMUkqYMy0B6qRvIrFIq5BSN74RXg2FSFncOwG5ow+AI8Gttv+JQGHJdtblo
         5a6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gcttxf1Z7z55ZyajsIidmjFu/+A5UNPbDLAEbT+eqcI=;
        b=bfli4GnM0HfHmCvB+i/sFnNwcWGg0GkQn3sCJt6dQHKWAEnhBWUZ68GSEMgxQIEW4a
         9LPGhqPLo3sJXXUcIsXuRHjoRJlu1K95M4vPtftZRxkwecxbo6aMDE85PdZ+2Vjsyw//
         YmFj2FmOCnpumIZIgpikonc4Xi/2exVhcDkzgEtRP9pxI/YijLNlzPaRCwhT0H9I7agS
         Gorc1uTrGxEu3xNmr8mNKWkUA4L1PEgMMmy8Hued6CVXV4uyGhbH4jyQA8ljylZJknht
         v+ASk5x6tkBeGtJECNjHLyACgQRuF7cGq6AqcGmAlWkfgxwi5tnY0m1K3Mzkh8ZO1tA4
         o9+Q==
X-Gm-Message-State: AJcUukchxJLH1xGC3q9p9UK3+cKtHwzShaUf+Dfagup3gtrkqmMlMaqV
        Ucuzo0j+mu3+Q4qIwL/dQ3LLcUmk
X-Google-Smtp-Source: ALg8bN6FdJYp14emiXzv59a12NJnQLiojI3h4MpsS1VJwaaxq6sEwxw8GJkCcpcqKukNRx0SngHJPg==
X-Received: by 2002:a63:5207:: with SMTP id g7mr6484873pgb.253.1547058640199;
        Wed, 09 Jan 2019 10:30:40 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:39 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 09/11] media: imx-csi: Move crop/compose reset after filling default mbus fields
Date:   Wed,  9 Jan 2019 10:30:12 -0800
Message-Id: <20190109183014.20466-10-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
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


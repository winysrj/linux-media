Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B3CC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAAEB217D8
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gDAv/yoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfBHTTm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:19:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42864 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfBHTTm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:19:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id n74so872743pfi.9;
        Fri, 08 Feb 2019 11:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U26YXALvPL/5SPkHyPqlaMA16FEhlCL+u65z44XkYcY=;
        b=gDAv/yoeqYfokxMgIq2+HeBzDmiHcZrXsGLa/hxzkVA3NSkHASUn4mv+OOpyVMidE2
         8Wn1E8KLqYoR0pOH1jrJmm1R0trIxLxEnTZnmKbd5aXS3STPUFCFH9NS+R73fs5vVsH/
         TSo4uKh7RR7U74HoEmWfXqXK/Lu+9hidncWANhqp2h45giYJWYNfWqpoLU8Uy4WYg0Zs
         R6aLYravfJzHACIwQg1IfnUxr3kIkpEwbvP8aBTxC7mLjuGO8n6GuS0nITk6rzldYKjN
         8BJFtr6rdzI24Rgzr6VWUHbIG/yTdBqibwQPS9y+FluXfvyRKvwCKB1J2rZgat4qEO7a
         EXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U26YXALvPL/5SPkHyPqlaMA16FEhlCL+u65z44XkYcY=;
        b=hk5uZC9JNP2nfvfzZ87W9p8UlrV6cxqwaAP9BCPTjNidOyalqUv8SWDBF7Q449yLPo
         8mN7IYTo1sKXp04/TWqpiGroj3Cofc+IAiqxDr9ly77bKTYnh7qqBuaZuGqo7gQL4gQq
         IKAZ3Xse8EnGFPqaFiXPQxHsomL8T5UrXQ31J60dqI2aAvEs/iXCK32S5c7gwzsdmPCD
         MaCnq4fsv1m+DreaUFyGgAZcO9XXNux4w7QN3F+fgE3DOKnz6R1R4SBelPQCQ7DwVw0q
         NgxZ/u4ixtewHasNJpJLBm/NGJZmfmMPoiRqOqx/x3Y8hW/DL4vsBjVKfDyjgs46dzO/
         EWSw==
X-Gm-Message-State: AHQUAuZCDri9zv6rwDSK1WU+BaQWJCzD3Bz7I+IWTJjmCeJGR8Hvp+6W
        6Q7GWYZsFUPLSVhso0Y7lUfH+ooh
X-Google-Smtp-Source: AHgI3IYM4+lpa75pkDcWL010/7bijkNa7h5oEC1KCaUFtP6DM9mrWS+qtCbKMCXkTw5ox/j1hiQNOg==
X-Received: by 2002:a63:b24a:: with SMTP id t10mr21152310pgo.223.1549653581218;
        Fri, 08 Feb 2019 11:19:41 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id o5sm4761817pgm.68.2019.02.08.11.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:19:40 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/4] media: imx: Allow BT.709 encoding for IC routes
Date:   Fri,  8 Feb 2019 11:19:28 -0800
Message-Id: <20190208191928.13273-5-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190208191928.13273-1-steve_longerbeam@mentor.com>
References: <20190208191928.13273-1-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

The IC now supports BT.709 Y'CbCr encoding, in addition to existing BT.601
encoding, so allow both, for pipelines that route through the IC.

Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v2:
- move ic_route check above default colorimetry checks, and fill default
  colorimetry for ic_route, otherwise it's not possible to set BT.709
  encoding for ic routes.
---
 drivers/staging/media/imx/imx-media-utils.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 5f110d90a4ef..dde0e47550d7 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -544,6 +544,19 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 	if (tryfmt->field == V4L2_FIELD_ANY)
 		tryfmt->field = fmt->field;
 
+	if (ic_route) {
+		if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT)
+			tryfmt->colorspace = fmt->colorspace;
+
+		tryfmt->quantization = is_rgb ?
+			V4L2_QUANTIZATION_FULL_RANGE :
+			V4L2_QUANTIZATION_LIM_RANGE;
+
+		if (tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_601 &&
+		    tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_709)
+			tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
+	}
+
 	/* fill colorimetry if necessary */
 	if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT) {
 		tryfmt->colorspace = fmt->colorspace;
@@ -566,13 +579,6 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 					tryfmt->ycbcr_enc);
 		}
 	}
-
-	if (ic_route) {
-		tryfmt->quantization = is_rgb ?
-			V4L2_QUANTIZATION_FULL_RANGE :
-			V4L2_QUANTIZATION_LIM_RANGE;
-		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
-	}
 }
 EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
 
-- 
2.17.1


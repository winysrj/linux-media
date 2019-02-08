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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D9EC282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CAE2183F
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoHJhb7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfBHT26 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:28:58 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37763 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbfBHT25 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:28:57 -0500
Received: by mail-pg1-f193.google.com with SMTP id c25so2011504pgb.4;
        Fri, 08 Feb 2019 11:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+GiavFYmZpYMitroMq7xO+5Ht+hTs+Up5dnwk5QqqHQ=;
        b=NoHJhb7b9u1Un56ktMxJBassyhbpR3++U8HP0z3bQjpayO1owgpaJnZ9xA6zhDgyq9
         Q8h8sSRNb0lWA2d4EfBjZLC4j3hSE9HT0TZHQlO9CCQgygvuHue8WYzsMNH+5ODSefaE
         wgGzm5mzalpF4Hc4YYdyK1XqNY28eFwIFLPRxh7UKwV5KXMlzkeIydfTfdTpsSBecKPF
         f01IxOeEH7wmfbX/SaRjiLWuv5M+41wymbyUk0gzZxifftRndS6KGcw5PggAZkNFrJBj
         xBi6gv2pKh2FzCew1hoghbfgwzIOe6gGhlYk7qn9mKGIGOKNNlBeK6J83P3COAnzevxU
         qM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+GiavFYmZpYMitroMq7xO+5Ht+hTs+Up5dnwk5QqqHQ=;
        b=PT5A344JiV+sSJqjQgBtE/lHQou7oxqbOxU6p3qyel0GuE1r6Ff9AjtJzJdhIF+YEV
         cVBwmBAJNdiIYVJTd62xHqfYwfa0EOu+jm029yPKZQ11x0OryuQLEKmXRaXDzURcu93c
         hpfmH4y5+BQx/dPxmeKTsGFg/zmO12hUY2SmECz2Gk21zW64fzMwatytJ3MVv7eQlwmJ
         QoB5A3Z61gxHB4KzNR5xHv0Iewbb9X1I2yByLSO/XDD99df9+vmuUkEMwnG2P92VGX+N
         fQTGrgBROw0pXhfKkrF5MW9OY64G2k9rQIVPYrbIm/oyqgsTEzVN3JjDcSaMfxNMbo8n
         HNSQ==
X-Gm-Message-State: AHQUAubOVS/Wc46k9fczyzZxfoB3W9E3xoL52ryaQj7Xi4jB1fdv8RRU
        Jmne+1eFpXrJefkM6B58ZkIrXYSI
X-Google-Smtp-Source: AHgI3Ib9NY5QF4wKAHWmwp/rwOh0QYd4tW6P9RTAzVWsYtJyH/8rIhFAUAeZ00I+U/xOVrIvq79wwA==
X-Received: by 2002:a62:53c5:: with SMTP id h188mr23418472pfb.190.1549654136371;
        Fri, 08 Feb 2019 11:28:56 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id e128sm4443129pfe.67.2019.02.08.11.28.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:28:55 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 4/4] media: imx: Allow BT.709 encoding for IC routes
Date:   Fri,  8 Feb 2019 11:28:44 -0800
Message-Id: <20190208192844.13930-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190208192844.13930-1-slongerbeam@gmail.com>
References: <20190208192844.13930-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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


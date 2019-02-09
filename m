Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECB6C169C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 000CA217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NezphF+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfBIBsL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:48:11 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46323 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfBIBsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 20:48:03 -0500
Received: by mail-pl1-f195.google.com with SMTP id o6so2501685pls.13;
        Fri, 08 Feb 2019 17:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+GiavFYmZpYMitroMq7xO+5Ht+hTs+Up5dnwk5QqqHQ=;
        b=NezphF+Yq9MJuAS92CD13Si1d4BqyBJ4MEo91tRfAmi6bSP5XqNDMbnilvvvRkQudZ
         6ywm7tTmtDTDIKlovpkdgbQ+b02BXr/1WvX3f9lP0jgPCKEuVbU+NBxxBgvpBkTaVbFv
         pU34aI9BYgngXIdDQ8XBgKharG0RqtsKzNpTxNzTU4Ny402VOQ/25tpMDxs4s1rWQ6Z1
         6n3kF9T36bHkDgfe9qtyY548+8S538mQGz8FHVWJnFWXGLFTabDDUOsxPy+uxBwqOY7K
         lgVyigggKL0lSxIGHEBGjfGBTJ+r3uNUEH4i0jNu469LqmWvCfn+UvznBaJtOW7RlflT
         XtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+GiavFYmZpYMitroMq7xO+5Ht+hTs+Up5dnwk5QqqHQ=;
        b=MydMVMI3wTV99u4qIpxT781fF3SY4Lr056JENWktqCUsXcqRXUxJRkQVg2wdN22A+H
         0QeF6fX3QCnO6eneDNZtA0pKoFrXwSSQOuFmSiU1Hao4EryKesd6beAPjjdHRC/nSyAA
         AiDWz88NGxwFIF/+TIOOYzJNU2C75KFt3NhJeZkICZrGMqZwZH2y2oyg8eq0gOkE7Fef
         ioh/CDh5oRQ006DyATahEN+vgSsg4U/JdBI9DWyvFxJKTvCpctCw+P5juQsUxjGTRLo+
         ThGJqAmf6+95tyYM2/VqrnquwN6a93jh3cLVQCicP/SgL4sBRViRb2rdHMKA9kc0aiqu
         gzcA==
X-Gm-Message-State: AHQUAuaw6LWmvJhSfEgmvI3zMtobIrSKATX8YPHpw1SFZV3GS/XyjeQT
        FCLYOMJC3mgZ2cYDcqqIzayI5rP4
X-Google-Smtp-Source: AHgI3IbbnXtC4rfjyMoY9s0Kr6AggAhrPmfmiOfoqmF4ZVsDfT6d1F5ZGiOKLlHtTTde2KhqIG3Ktg==
X-Received: by 2002:a17:902:be03:: with SMTP id r3mr25383129pls.68.1549676882664;
        Fri, 08 Feb 2019 17:48:02 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id p67sm4305393pfg.44.2019.02.08.17.48.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 17:48:01 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 4/4] media: imx: Allow BT.709 encoding for IC routes
Date:   Fri,  8 Feb 2019 17:47:48 -0800
Message-Id: <20190209014748.10427-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209014748.10427-1-slongerbeam@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
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


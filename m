Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8678BC169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 514A821773
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QN4USepg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfBCTsS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 14:48:18 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39317 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfBCTsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 14:48:17 -0500
Received: by mail-pf1-f194.google.com with SMTP id r136so5758152pfc.6;
        Sun, 03 Feb 2019 11:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QAoOKPe12ieq5hCZTV0LGSX3PpYeMJKxTVN8PEs4WCw=;
        b=QN4USepgJsFxKXbhQa3j5yC5Yu2VdaBxLxQFiL8W41K82ckpEZNQuQffVCxwvREPac
         8PFMZHAV+s6EqJbQCBDZCeZXJi5Mpn5MFFhkpJp5wpORZn/J1sWuuLvphfd2KfTVVO85
         7Om74h3MVSGPR5yvSuhcbioY/EkgE7vDsaTYvgxSwes8gyJ4MiogtbfLBq3xiYsvL+Fa
         WObx4YmSkcRGl8a4SxJWr+XiGtqQkuCiFMt9pWFy7RQIZl7w4p63nAjhhXkXoho8Epat
         yUkIbb93zfcw5tiO1S9/ykUtZ0q+lwS1anos5345JEbky988vqjlLrYPoI7RhYw8H7mB
         8+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QAoOKPe12ieq5hCZTV0LGSX3PpYeMJKxTVN8PEs4WCw=;
        b=lFtQoYS0rg/NdV6lcyuXRYId4jAz6YMd7RR/2xc7vzxdV4jVfAyIJshx3ZH5Zps1Nh
         QQfcyPIIAFZfoQJEpP9T2KqMsPpRXoTwueWwMuqa0MjGaM8MvKGYK1ujpAeXax+NELzf
         HrNPCAmdN+HqJucS46SputEMayV1QjhBDaFlolvXT5jw9p8bal7Enor0ZOUUi8545NBK
         dV1x/SD+6vznWWg3mh0L+z8jTVQQ5/uIio1DzOfV9fiUcTgWSzTD/cDkZO9/mx+BlsG4
         slN5uV1/ugEiPYzoZ15nBfHzDOp8K5+D8c2f9kUCuS//I5vMmsxUxPSsMIuzhCBTGTA8
         Bf3w==
X-Gm-Message-State: AJcUukecIVY8/F2Pt+1pOH5XEL68sEJHI6C5jOAuSn5g6EY/LvvzOjbp
        WvRBK0xvipV6jAP50FlJvJd6zU53
X-Google-Smtp-Source: ALg8bN5ogv7yA/7prYRqjHeGodXTfL/ZyX2dpwT/TvI9Ep4ubgTYM5jUv4NUkekHqNbBmz7TffeCJA==
X-Received: by 2002:a63:eb52:: with SMTP id b18mr42799199pgk.213.1549223296459;
        Sun, 03 Feb 2019 11:48:16 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id f67sm23487724pff.29.2019.02.03.11.48.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 11:48:15 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] media: imx: Allow BT.709 encoding for IC routes
Date:   Sun,  3 Feb 2019 11:47:44 -0800
Message-Id: <20190203194744.11546-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190203194744.11546-1-slongerbeam@gmail.com>
References: <20190203194744.11546-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The IC now supports BT.709 Y'CbCr encoding, in addition to existing BT.601
encoding, so allow both, for pipelines that route through the IC.

Reported-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-utils.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 5f110d90a4ef..3512f09fb226 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -571,7 +571,9 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 		tryfmt->quantization = is_rgb ?
 			V4L2_QUANTIZATION_FULL_RANGE :
 			V4L2_QUANTIZATION_LIM_RANGE;
-		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
+		if (tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_601 &&
+		    tryfmt->ycbcr_enc != V4L2_YCBCR_ENC_709)
+			tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
 	}
 }
 EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
-- 
2.17.1


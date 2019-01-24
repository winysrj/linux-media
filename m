Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C44C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A431021872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="F71+4AqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfAXQKE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:10:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37395 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbfAXQKE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:10:04 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so7092545wrt.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CVbw2/xqDn6WjQlSRch+je/yckaVEkLsj0/B8a1pF/A=;
        b=F71+4AqLMyFJEEfclQ4djHmZF0FTZKeuGIl/LPJ2M/B09gXnBO3qfC/lz8COGEAuek
         SMzekRj27VilyjRor9gmgKzfzOWBQ5kzh081abYA7E8uaCubkLJuT1MpsTLzZ/fHrFvA
         wKcDTBMqTYA+QDaN1Ra5gmaieK6rr5ao4QD48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CVbw2/xqDn6WjQlSRch+je/yckaVEkLsj0/B8a1pF/A=;
        b=G8KdLT53H5A27kDaIJ+iGajxQerabGL9y+ICUBySXWCpWbTXAFHInFG5n6lRguUaxw
         okcqjqJ9dkaJX9BatxFfqvmECwtiZy9os2QKRvfm5tV2vY+6dhrWKQSk+1+LrzxhOWbp
         usm2gNeOtDLNiW2VVe2I64D36zstoJiIB+RODUKgjPfuDkIU6N1hLN0HMTLqPUy7sTyd
         GKajPqvqqy8sLfyoLKRw8pF47VFakN46tcLp83RuFPBJQizpC1m+lN+lpUqW1ppEeQzT
         3VCg8EdrHp2ajFC7Yg9yW05CLXV0879Klh3QWD2xQDVCK4UvlODUO8LsSlmy46dbAp0Z
         RuCg==
X-Gm-Message-State: AJcUukc+ImKbQHSp2HzIkCjPRKrRvbgZorG1qJb6p/Z+TcNvCQSZuxCf
        4/sz/WSI/XVdV3zFrOPCNyzghA==
X-Google-Smtp-Source: ALg8bN62PNEYnF5Cgm9TwOfVpthOdfVrwMmK5wEjUoM+eoOowHmPf3tckL1mPZ/NSD1QkPtHNVlyuA==
X-Received: by 2002:adf:dcd0:: with SMTP id x16mr7730583wrm.143.1548346202358;
        Thu, 24 Jan 2019 08:10:02 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.10.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:10:01 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 12/13] media: video-mux: add bayer formats
Date:   Thu, 24 Jan 2019 16:09:27 +0000
Message-Id: <20190124160928.31884-13-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add non vendor bayer formats to the  allowed format array.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/video-mux.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index c33900e3c23e..0ba30756e1e4 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -263,6 +263,26 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 	case MEDIA_BUS_FMT_UYYVYY16_0_5X48:
 	case MEDIA_BUS_FMT_JPEG_1X8:
 	case MEDIA_BUS_FMT_AHSV8888_1X32:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
+	case MEDIA_BUS_FMT_SBGGR14_1X14:
+	case MEDIA_BUS_FMT_SGBRG14_1X14:
+	case MEDIA_BUS_FMT_SGRBG14_1X14:
+	case MEDIA_BUS_FMT_SRGGB14_1X14:
+	case MEDIA_BUS_FMT_SBGGR16_1X16:
+	case MEDIA_BUS_FMT_SGBRG16_1X16:
+	case MEDIA_BUS_FMT_SGRBG16_1X16:
+	case MEDIA_BUS_FMT_SRGGB16_1X16:
 		break;
 	default:
 		sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;
-- 
2.20.1


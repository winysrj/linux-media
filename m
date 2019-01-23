Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1039C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A087220861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="KEvrarep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfAWKxO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:53:14 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46232 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbfAWKxN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:53:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id l9so1820792wrt.13
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gY2LNKMG7qpa54ba4CVP1G13ldcfqAPv/cqBQsiaTTo=;
        b=KEvrarepuUMtTfXKBQ5nc9RMscwWNeKfB766QwHscfHjgRfsycibJ9sxGxt1zKpbCr
         CyIN+9/fy4ju6tmqZYqGEFFIqRXhgmeEEp8JfNCd1cpr/FnTDFvfb5lAM4Z3gxSwth9J
         HA9eylytnBQoDSDDH9WejPTSUj7lqHCYPPXsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gY2LNKMG7qpa54ba4CVP1G13ldcfqAPv/cqBQsiaTTo=;
        b=IgS0bnIU8/fHG8OWtkZrsCR3Op7aVcVTWD/Spp7RNAtijnTkSh38V3xBUyyZRdO2vB
         q5Yrfbjoov/Y4WS4l1P7NGsuLAc0c+d6vbxQVvbjcM/L0GXYWuRG0cW0+Gk/OWT9Ky+y
         wsBCv5VMvkS4pU3pPxL1/G/V6TEPvWbxxc0onm8bcsDKEEqy0yEwYd1Z1qRIXAmzurvS
         FradEFihTY0GJZrPt9qtehRZ8a75RLlp8mDBJO8l9O0vXFBcsLYBLvxLtGihV6nHS53J
         Fh3HB8jYi4XpbvCvnrBpt7/7AxiE+jv4zDNPmlf3kiG0MpeNaMnE2/H0d2rWwMx9Gb7D
         ghvg==
X-Gm-Message-State: AJcUukfgTSSrahlgV0rnJz6cZBSwHGjlFCFlu2oUX22L1Wuqly9F+SP8
        XkVCnC17+TvW5/EMAfgIMqf4Yg==
X-Google-Smtp-Source: ALg8bN7LKkFRUclcJug/Q/VmiuUX9cPz0bRVucx0m6XURTZ29iSNkL0WufHPOCTvHA/eorxR6Par7w==
X-Received: by 2002:adf:ed92:: with SMTP id c18mr2196486wro.194.1548240791418;
        Wed, 23 Jan 2019 02:53:11 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 143sm120717646wml.14.2019.01.23.02.53.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:53:11 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v10 12/13] media: video-mux: add bayer formats
Date:   Wed, 23 Jan 2019 10:52:21 +0000
Message-Id: <20190123105222.2378-13-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123105222.2378-1-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add non vendor bayer formats to the  allowed format array.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
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


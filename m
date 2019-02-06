Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08C5C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFBCF217F9
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nj61gi4J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbfBFPOI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:14:08 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32878 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731206AbfBFPOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 10:14:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id h22so2060879wmb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 07:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tQ0yXI3h/vEMlDmKxGMU2fxncWjHgyDux1n9KSlzAIA=;
        b=Nj61gi4JqoZV0jJjt7qoStZV3bWnFJ9K/mBZxnPgrqze8zUK7p+uyfEVee71SO+70M
         F5VJ8OdOWslNj/v4A3cEOzZ1DPMIzJmBOy9XMtL/fSmcUeFE8OlG5HCwmnQXutfrFUrV
         q641ByZTMATwuueNZN8tpIMyWOG8FbhnXs0gPFF8tbOLkPNSZlPxGeaehgDEEGP63Y9t
         eOh0bK8wepkdl2cu9ocMBcA5mVVVGbjEP4zC93EAjA2MZdrVVmNiMD13vdaab/BBEpwg
         1UceeCed4sekuMVlRPpdZuUE8SEvcpa3KWpih857Cjke/KtPPQx6W6c34XKfsKXrqn6p
         g8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQ0yXI3h/vEMlDmKxGMU2fxncWjHgyDux1n9KSlzAIA=;
        b=jZorolvrhzD8dvNzdnHQTVQWjssNfL4XiHgKRnQm/PTQ/HeZCwRkeqQJ/l/RwvDsiE
         QyQR7XraR72xyI+rZxiPVNEDVmgw+MbGnrW4xiNKn9dvxVsS3CKqJ+mu+wzq0vL4J3+X
         phuKv5Ob6Njxg74c1xru2GBi4IR3ySeEXEnnQPFcn0RIcuhO5OZihb/BuuFwI8aQnXlN
         rLSVF4fN0B0Rx7UOksvj1CqgV6SWBnw8qn+GX9wKOR6O2M7/VdALv761qyrRl8+o6/Cr
         4I4a3uJ94DoD/lGxEkPwJgKgU6DfIAvP/jGuxxcovTGiMvnKtsEfJWtmRTFlmqhwH/AM
         YBYA==
X-Gm-Message-State: AHQUAubVyCxZ25HJ17B+lMhwo6L9SpdNPYACxgKk/ryy9H32PDMiuR7z
        MA6UdYydMt0b7/vU2ElhQhMcAg==
X-Google-Smtp-Source: AHgI3IYR9lHazJlfCZhaumjwUkHP0ugqtrtcSQsJm1e5MHVKEsxJt16ZDatvm1AL23lCcinm9tn5Zg==
X-Received: by 2002:a1c:e10a:: with SMTP id y10mr3571972wmg.73.1549466045316;
        Wed, 06 Feb 2019 07:14:05 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f22sm11207836wmj.26.2019.02.06.07.14.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 07:14:04 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v14 12/13] media: video-mux: add bayer formats
Date:   Wed,  6 Feb 2019 15:13:27 +0000
Message-Id: <20190206151328.21629-13-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206151328.21629-1-rui.silva@linaro.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add non vendor bayer formats to the  allowed format array.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
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


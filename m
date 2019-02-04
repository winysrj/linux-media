Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4484AC282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AC32087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 12:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WejHG5+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfBDMBR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 07:01:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38599 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfBDMBR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 07:01:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id m22so13185874wml.3
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 04:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tQ0yXI3h/vEMlDmKxGMU2fxncWjHgyDux1n9KSlzAIA=;
        b=WejHG5+wlU2rIeuPTYfK7VGsP0eHoyCxff7cN68YRq9E+xwrG53e8eE60NFgBGZq0q
         KyfSNYNlit/whkq4XLhK9IM70dwYIY8wYnHvKJVEJ2stAJfOcQT4W64+q4GrjJb/lK73
         owtUgbvbW57O0hkuP1YnHW4D9PINZ6H/ByIAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQ0yXI3h/vEMlDmKxGMU2fxncWjHgyDux1n9KSlzAIA=;
        b=BMWbMvOaKukIAbC8NRwP8WR82Sqy+EQMbOAN39b8pZBWzVai1EL/8ib7vYxxtOK+kb
         0Wh8SmnUI6rZ4812cLrrGySQ8Gr755D6d54L65s1wkiBsGpM24RfYQICSsFelHY+kFSJ
         nqgf4rFfNxJTLAkHuCIWCQM/f7mzvPx9A7f0fqgrb3lb786AanQ597prfbGzas+ngLid
         STY90rZ8NjsJLhUS6SsJEzyBci5FegKHs+TRxtzOC6X+ARR+chqz2aI/XZb2pozuTvar
         H1SGRKrKKmRdbHDqdIG1GxBIui9Wb3Tpq9s77YnZ1XJp2yLdNXTfpTYA+qoqqqeFtIT9
         xZCw==
X-Gm-Message-State: AHQUAuY9QGAzgqTv+za7FJCwMGRFtO9wEdAFd3zc6X1a2f5oz6X95Qbu
        mATa9YJwiIosk7e0C68f6uqwjw==
X-Google-Smtp-Source: AHgI3IY5CDSSoEkdJL4ye4T9JwLADiUQejEq7CoH+zLR6VsbFpbngkAYxvVlyu2BsSvkJgguHt/w5A==
X-Received: by 2002:a1c:2787:: with SMTP id n129mr13525033wmn.128.1549281675128;
        Mon, 04 Feb 2019 04:01:15 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id s8sm15404543wrn.44.2019.02.04.04.01.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 04:01:14 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v12 12/13] media: video-mux: add bayer formats
Date:   Mon,  4 Feb 2019 12:00:38 +0000
Message-Id: <20190204120039.1198-13-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
References: <20190204120039.1198-1-rui.silva@linaro.org>
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


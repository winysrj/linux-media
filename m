Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70491C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E3342083B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="URQDoEz9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfBFK0S (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42999 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbfBFK0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so6875172wrx.9
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tQ0yXI3h/vEMlDmKxGMU2fxncWjHgyDux1n9KSlzAIA=;
        b=URQDoEz9IDQN7u7gekNypHM89asOD6Xdw9+wuVMBswRJMNzNNWrdgumHQ/xv7Hs6OP
         aBZXIqx2KCNyr8HFtJi/gBafrODq/OtrK/uyuUSPqWLhOCeS2lHBoJBThxFH0rI5VKRY
         pZBlR5GJNi3amvpHGPeJooMe27SYtxIfULRuupxaEWc5AGl4Ft8XJYodwlo5ug4HC04f
         JMbdrW2Tl25SZgEswTzF4qYwIfn+3ouEwWI86ugQILY8To35lPCjOxFyL2MSKjf1iPsG
         1trZk7YAfX7c7vwY9K+tzUOahYpix5FwyRvENnMoUH40IMQO05UEdxXmiabjKrJUgBwt
         jouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQ0yXI3h/vEMlDmKxGMU2fxncWjHgyDux1n9KSlzAIA=;
        b=ErhcgXLJxc+qyBUFJtXHTcEwhGPird/SxKr3KymaQDsMbIkxcDbtao9ERM1JeHK2j3
         N0uGSuetQTQiWQ3eLd0O/JwJ1VW5d0jW1eXDPLNVKZUumWAjplDofDqbaAx1t11ILsfb
         FDoJmgn8Cr3d34ynPhh3Mo9aIXJzDao3kXjloPLYbD5PiJBthjlYUyPvpqdue6AN0oie
         S7gteauBkLViZnGOFdT2Nkxi8uBxeqccNDEM/qE7hOd0JmthX7KF6X5+zYM9wxKezb7L
         90HqKdpZANpBqiCWowpLUxXHVNTZB83OHmQGSSy+XLzrsvVx6joND0AP3PenDaAVorht
         fijA==
X-Gm-Message-State: AHQUAub4nsjn/G4Y6eZrccVzC0/9iIGOrB4ejQqLCbmNzJI7ihr8K8y4
        SZQgV7RJrJAF+AE2v1t6RZu+MSNyae8=
X-Google-Smtp-Source: AHgI3Ia6aK3/bE9vFLBSrpePQF9zkjXIUVS/2RgEIBlfRTDLVyJ3nNjtEG7ChtpQdehlN3Ng/vFViQ==
X-Received: by 2002:a5d:5285:: with SMTP id c5mr6861541wrv.167.1549448776626;
        Wed, 06 Feb 2019 02:26:16 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:16 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 12/13] media: video-mux: add bayer formats
Date:   Wed,  6 Feb 2019 10:25:21 +0000
Message-Id: <20190206102522.29212-13-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
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


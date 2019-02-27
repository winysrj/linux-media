Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C8EC00319
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 14:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ECBA2083D
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 14:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=qtec.com header.i=@qtec.com header.b="YKWCjLej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfB0Ord (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:47:33 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43524 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730352AbfB0Ord (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 09:47:33 -0500
Received: by mail-ed1-f66.google.com with SMTP id m35so14078813ede.10
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 06:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=qtec.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=neOMSgszrIpboFw9HXKowuFI5Qqw7ELHdHEqwV+9rJY=;
        b=YKWCjLejj2dW5JeT8HcFGuhHKBdgnmrWRZRNdTDTN9btx8fYFQcFdZbLIP+2WBHZEb
         FbVROCvBhd9v8qY+QdrTeUEk6Y0fzAy6DIjiNb/bob11J+RNGJtwmmVaeXO21wK8O24v
         CNVtVPTCIu46bQ4/jOxQLSwDMqHS1vVJ9EGlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=neOMSgszrIpboFw9HXKowuFI5Qqw7ELHdHEqwV+9rJY=;
        b=VS4vfhv0JLHEDpxXycXR/lQVC3Sd9KJ39cJHrkibKq+3ysPgEm+vToxWyt1U3GvYJx
         znVaqIVipvMvroUPsVsPyLXRGN10xOFhRkQf29mvcjXcGwTMI3kdmkKz2WWJ7iLB0izG
         OCsGa13OgKwp88wBAUAzrpK/SWXdqmJaJmVMmT47SuMyAWhZR5R484K+U30GKhn7Bhkt
         q9k6+Fm6S8Zzsu0WPz2pQyXY/VCA6/zBl10SDL92JgDoc77SZL8f6y3jRZxmzlF5Y5g8
         zslYW/nepnERw1pHScoUk0xrm1idLuiVZ3Y6um4SWiKCW5l4MsQk4Mb7WxhURyLbzM6D
         6b1A==
X-Gm-Message-State: AHQUAubgTTKr+H6ytp+oyC4/GbjcJRYJHfjeVmQ+tuVKS8mgjB7fvdy7
        ebwBuw1J4TDWoIhOrxXtAKjV8M09SCHupQ==
X-Google-Smtp-Source: AHgI3IaH4H1dsirX7phd8iGCUdrcb9V2CfORHhfovmL8NC8Hxviq0e+EI4hO8ihF2RIKB7wiYn2T4Q==
X-Received: by 2002:a50:9094:: with SMTP id c20mr2616159eda.126.1551278850956;
        Wed, 27 Feb 2019 06:47:30 -0800 (PST)
Received: from dgc.qtec.com (cpe.xe-3-0-1-778.vbrnqe10.dk.customer.tdc.net. [80.197.57.18])
        by smtp.gmail.com with ESMTPSA id i42sm4284135eda.86.2019.02.27.06.47.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 06:47:30 -0800 (PST)
From:   Daniel Gomez <daniel@qtec.com>
To:     linux-media@vger.kernel.org
Cc:     ricardo@ribalda.com, daniel@qtec.com
Subject: [PATCH 2/2] libv4lconvert: add support for BAYER16
Date:   Wed, 27 Feb 2019 15:47:10 +0100
Message-Id: <20190227144710.32427-2-daniel@qtec.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190227144710.32427-1-daniel@qtec.com>
References: <20190227144710.32427-1-daniel@qtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for 16 bit Bayer formats:
	-V4L2_PIX_FMT_SBGGR16
	-V4L2_PIX_FMT_SGBRG16
	-V4L2_PIX_FMT_SGRBG16
	-V4L2_PIX_FMT_SRGGB16

Tested using vivid included in linux v5.0-rc8.

Signed-off-by: Daniel Gomez <daniel@qtec.com>
---
 lib/libv4lconvert/bayer.c              |  9 ++++++
 lib/libv4lconvert/libv4lconvert-priv.h |  3 ++
 lib/libv4lconvert/libv4lconvert.c      | 45 ++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
index 96d26cce..7748e68d 100644
--- a/lib/libv4lconvert/bayer.c
+++ b/lib/libv4lconvert/bayer.c
@@ -662,3 +662,12 @@ void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
 		bayer8 += 4;
 	}
 }
+
+void v4lconvert_bayer16_to_bayer8(unsigned char *bayer16,
+		unsigned char *bayer8, int width, int height)
+{
+	int i;
+
+	for (i = 0; i < width * height; i++)
+		bayer8[i] = bayer16[2*i+1];
+}
diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 44d2d32e..a8046ce2 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -270,6 +270,9 @@ void v4lconvert_bayer10_to_bayer8(void *bayer10,
 void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
 		unsigned char *bayer8, int width, int height);
 
+void v4lconvert_bayer16_to_bayer8(unsigned char *bayer16,
+		unsigned char *bayer8, int width, int height);
+
 void v4lconvert_hm12_to_rgb24(const unsigned char *src,
 		unsigned char *dst, int width, int height);
 
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index a8cf856a..7dc409f2 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -140,6 +140,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_SGBRG10,		16,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SRGGB10,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SBGGR16,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SGBRG16,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SGRBG16,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SRGGB16,		16,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
 	{ V4L2_PIX_FMT_SN9C10X,		 0,	 9,	 9,	1 },
@@ -702,6 +706,10 @@ static int v4lconvert_processing_needs_double_conversion(
 	case V4L2_PIX_FMT_SGBRG10:
 	case V4L2_PIX_FMT_SGRBG10:
 	case V4L2_PIX_FMT_SRGGB10:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 	case V4L2_PIX_FMT_STV0680:
 		return 0;
 	}
@@ -1052,6 +1060,43 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		}
 	}
 
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16: {
+		int b16format = 1;
+
+		switch (src_pix_fmt) {
+		case V4L2_PIX_FMT_SBGGR16:
+			src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
+			break;
+		case V4L2_PIX_FMT_SGBRG16:
+			src_pix_fmt = V4L2_PIX_FMT_SGBRG8;
+			break;
+		case V4L2_PIX_FMT_SGRBG16:
+			src_pix_fmt = V4L2_PIX_FMT_SGRBG8;
+			break;
+		case V4L2_PIX_FMT_SRGGB16:
+			src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
+			break;
+		default:
+			b16format = 0;
+			break;
+		}
+
+		if (b16format) {
+			if (src_size < ((width * height * 2))) {
+				V4LCONVERT_ERR
+					("short raw bayer16 data frame\n");
+				errno = EPIPE;
+				result = -1;
+				break;
+			}
+			v4lconvert_bayer16_to_bayer8(src, src, width, height);
+			bytesperline = width;
+		}
+	}
+
 	/* Fall-through*/
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SGBRG8:
-- 
2.20.1


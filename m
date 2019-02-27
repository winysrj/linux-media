Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42120C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 14:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF2B6217F5
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 14:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=qtec.com header.i=@qtec.com header.b="bZEVoZLS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbfB0Orc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:47:32 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41443 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfB0Orc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 09:47:32 -0500
Received: by mail-ed1-f67.google.com with SMTP id x7so14079793eds.8
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 06:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=qtec.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cIEOfpBjSO8mrguz4mDYgD2BWvQeVzgl6ZJhuvnKJSk=;
        b=bZEVoZLS8U2RKJmoaplKS8wZmexluw0I1oYXDXsDaYNhFmcFR28uUfnU4UiAOeCSui
         vZdnC8P8sHkl7R2BiIPV9dwcX5kK0kr20c1AkFyfmP3L7lSlF3Y6my8fxio/Ifw7EE0o
         qoERQldJbDaQSY0nQymVGYFLojzf8R7Zc7klo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cIEOfpBjSO8mrguz4mDYgD2BWvQeVzgl6ZJhuvnKJSk=;
        b=IXsNWS5PdIxq2QXmMSV50M6NlD7jlU21d0YBenpHuaIVNV+IKwU3ecGIAi3LcJZPeD
         w11UEhu+5V5Fgra4YVvIb0NebOi1+buW7rmo519+yXspoM1zHCuaiWwjB2uSuHUfiMvF
         gxXp2HzjjwBB7E/W8+OsuniZCBF4SMPPs9kMH51cgQvmXGT6c8FGV8EqY/ymi/ncpESV
         NUwjWlPjdMgFE1RK7ctlvNFuWDTAPBB3ZKjdQg4D1RojaRPfizN01hPAlJV17LMQ8po8
         VwSmkkszN+LdTfKByumL/i13eXbZDUMMR9TVFVX9EFzJFDcbCF30eEWN9uwTC7gdFxhr
         zN6Q==
X-Gm-Message-State: AHQUAuZLE2kYf80k/gkkzPw66qnvF06a7NMRpuMoea8b4opK9swgIQW9
        cdQ/5BVbk2MeWcaWFZmwvG82amKA7lyQ0w==
X-Google-Smtp-Source: AHgI3IZfE1f+3DVsAjZN3cwzYcLVSk8/b88BcdlFJTnq4jlf/V5it8VBpMvS70PXxl+/D/8QmHYrYQ==
X-Received: by 2002:a17:906:5e43:: with SMTP id b3mr1777476eju.209.1551278850147;
        Wed, 27 Feb 2019 06:47:30 -0800 (PST)
Received: from dgc.qtec.com (cpe.xe-3-0-1-778.vbrnqe10.dk.customer.tdc.net. [80.197.57.18])
        by smtp.gmail.com with ESMTPSA id i42sm4284135eda.86.2019.02.27.06.47.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 06:47:29 -0800 (PST)
From:   Daniel Gomez <daniel@qtec.com>
To:     linux-media@vger.kernel.org
Cc:     ricardo@ribalda.com, daniel@qtec.com
Subject: [PATCH 1/2] libv4lconvert: add support for BAYER10
Date:   Wed, 27 Feb 2019 15:47:09 +0100
Message-Id: <20190227144710.32427-1-daniel@qtec.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for 10 bit Bayer formats:
	-V4L2_PIX_FMT_SBGGR10
	-V4L2_PIX_FMT_SGBRG10
	-V4L2_PIX_FMT_SRGGB10

Previous BAYER10 format declared (V4L2_PIX_FMT_SGRBG10) now is grouped
with the new list without the need of tmp buffer.

Update v4lconvert_10to8 function:
	- Renaming function name to keep naming convention with the
	other bayer10p conversion function:
		v4lconvert_10to8 -> v4lconvert_bayer10_to_bayer8

Tested using vivid included in linux v5.0-rc8.

Signed-off-by: Daniel Gomez <daniel@qtec.com>
---
 lib/libv4lconvert/bayer.c              | 10 ++++
 lib/libv4lconvert/libv4lconvert-priv.h |  2 +
 lib/libv4lconvert/libv4lconvert.c      | 65 +++++++++++++++++++-------
 3 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
index 11af6543..96d26cce 100644
--- a/lib/libv4lconvert/bayer.c
+++ b/lib/libv4lconvert/bayer.c
@@ -632,6 +632,16 @@ void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
 			!start_with_green, !blue_line);
 }
 
+void v4lconvert_bayer10_to_bayer8(void *bayer10,
+		unsigned char *bayer8, int width, int height)
+{
+	int i;
+	uint16_t *src = bayer10;
+
+	for (i = 0; i < width * height; i++)
+		bayer8[i] = src[i] >> 2;
+}
+
 void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
 		unsigned char *bayer8, int width, int height)
 {
diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 3020a39e..44d2d32e 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -264,6 +264,8 @@ void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
 void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
 		int width, int height, const unsigned int stride, unsigned int src_pixfmt, int yvu);
 
+void v4lconvert_bayer10_to_bayer8(void *bayer10,
+		unsigned char *bayer8, int width, int height);
 
 void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
 		unsigned char *bayer8, int width, int height);
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 6a4c66a8..a8cf856a 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -132,11 +132,14 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SBGGR10P,	10,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SGBRG10P,	10,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SGRBG10P,	10,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SRGGB10P,	10,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SBGGR10,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SGBRG10,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SRGGB10,		16,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
 	{ V4L2_PIX_FMT_SN9C10X,		 0,	 9,	 9,	1 },
@@ -695,6 +698,10 @@ static int v4lconvert_processing_needs_double_conversion(
 	case V4L2_PIX_FMT_SGBRG10P:
 	case V4L2_PIX_FMT_SGRBG10P:
 	case V4L2_PIX_FMT_SRGGB10P:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10:
 	case V4L2_PIX_FMT_STV0680:
 		return 0;
 	}
@@ -722,16 +729,6 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
 	return *buf;
 }
 
-static void v4lconvert_10to8(void *_src, unsigned char *dst, int width, int height)
-{
-	int i;
-	uint16_t *src = _src;
-	
-	for (i = 0; i < width * height; i++) {
-		dst[i] = src[i] >> 2;
-	}
-}
-
 int v4lconvert_oom_error(struct v4lconvert_data *data)
 {
 	V4LCONVERT_ERR("could not allocate memory\n");
@@ -907,8 +904,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 #endif
 	case V4L2_PIX_FMT_SN9C2028:
 	case V4L2_PIX_FMT_SQ905C:
-	case V4L2_PIX_FMT_STV0680:
-	case V4L2_PIX_FMT_SGRBG10: { /* Not compressed but needs some shuffling */
+	case V4L2_PIX_FMT_STV0680: { /* Not compressed but needs some shuffling */
 		unsigned char *tmpbuf;
 		struct v4l2_format tmpfmt = *fmt;
 
@@ -918,11 +914,6 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			return v4lconvert_oom_error(data);
 
 		switch (src_pix_fmt) {
-		case V4L2_PIX_FMT_SGRBG10:
-			v4lconvert_10to8(src, tmpbuf, width, height);
-			tmpfmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SGRBG8;
-			bytesperline = width;
-			break;
 		case V4L2_PIX_FMT_SPCA561:
 			v4lconvert_decode_spca561(src, tmpbuf, width, height);
 			tmpfmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SGBRG8;
@@ -1023,6 +1014,44 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			bytesperline = width;
 		}
 	}
+
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SRGGB10: {
+		int b10format = 1;
+
+		switch (src_pix_fmt) {
+		case V4L2_PIX_FMT_SBGGR10:
+			src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
+			break;
+		case V4L2_PIX_FMT_SGBRG10:
+			src_pix_fmt = V4L2_PIX_FMT_SGBRG8;
+			break;
+		case V4L2_PIX_FMT_SGRBG10:
+			src_pix_fmt = V4L2_PIX_FMT_SGRBG8;
+			break;
+		case V4L2_PIX_FMT_SRGGB10:
+			src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
+			break;
+		default:
+			b10format = 0;
+			break;
+		}
+
+		if (b10format) {
+			if (src_size < (width * height * 2)) {
+				V4LCONVERT_ERR
+					("short raw bayer10 data frame\n");
+				errno = EPIPE;
+				result = -1;
+				break;
+			}
+			v4lconvert_bayer10_to_bayer8(src, src, width, height);
+			bytesperline = width;
+		}
+	}
+
 	/* Fall-through*/
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SGBRG8:
-- 
2.20.1


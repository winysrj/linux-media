Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932D5C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 17:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59520217F9
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 17:06:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KXBfxC3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfBERGt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 12:06:49 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45459 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfBERGt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 12:06:49 -0500
Received: by mail-ed1-f66.google.com with SMTP id t6so2219349edw.12
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 09:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7QiibuPpWOpNLx94WVXHDAFCLQTyqDlOvyOdzdbqjis=;
        b=KXBfxC3bKmN7pj+iaVCj+yMc5q+QBco9LiyyntEcaqR5GttjoBCJDLBI/WC6PcIG2T
         kTxWUPkb+4atc+BPwTZa2oebE07K2k9rY+oreR9EqsGE0+E429nzSVQnw8peR9n04sKV
         jjZLp2ya6Xn3d1WrOF4FwS45BH5u3R5TF3qu79JDRCe96rn96IH3/aqUfLz8AzZPrChg
         Y8aif4Jau6htXpbh9M+QTLzRd2h5N7nVpUWw0QKWYFcVnOoh4xsxUDovzYXbhp9/PuMT
         iXsSnDYbK6RinPBSh7ZhfuAPsyRiftQWKbhaM9JRvmnBzgkN+ogQ0QjAOsBxrIN2Ki8y
         DYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=7QiibuPpWOpNLx94WVXHDAFCLQTyqDlOvyOdzdbqjis=;
        b=h4MlBUFjPhFRYkCueB+lH1ruvPRXhEtcFSITGiRPai7TH/wK9e1kNKxpYsGkCFGh5J
         lyCQ88ZN+cSGhQcyJP/BX+HBFtRBUOcDWJnAcMjHM2pWGinyGyxJoOd9cjzwOSCXMNiV
         Twm38FgAqdxfhkQyUV/eguRixS1J5A+0DJEqRWFctsaXTkeyo5g2lnieLt8O3DBEiH1S
         SIHhRStDEw8qNBjDO8Wf9gloSGyxxLYLcZfEkA7yRYwAISmkr0dYRYzghy4hMpUzWiTX
         7GLSiWDeKGtUOVVX/6XaKxaWy57tE17aH5ZPwMhd74MC0Z1vlrwbshpTTfXdtAFtBg1J
         ym6g==
X-Gm-Message-State: AHQUAuaarxeCOVabewSY5dO3qzSczJtDnc/+DNlABcwtlVnGbWgNQYS+
        hGJa4YJ5vYbjwHiWhI8KP4cppmUI
X-Google-Smtp-Source: AHgI3IZVfU206cFpQyS2dAFy9mSe/bqEgvMHwXCpiyiwPjdOck2YLy9xhGLhhmECVB79DbgT4megrA==
X-Received: by 2002:aa7:d9d6:: with SMTP id v22mr4667268eds.265.1549386407750;
        Tue, 05 Feb 2019 09:06:47 -0800 (PST)
Received: from neopili.qtec.com (cpe.xe-3-0-1-778.vbrnqe10.dk.customer.tdc.net. [80.197.57.18])
        by smtp.gmail.com with ESMTPSA id b19-v6sm3024061ejp.77.2019.02.05.09.06.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 09:06:46 -0800 (PST)
From:   Ricardo Ribalda Delgado <ricardo@ribalda.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Gregor Jasny <gjasny@googlemail.com>,
        linux-media@vger.kernel.org, daniel@qtec.com
Cc:     Ricardo Ribalda Delgado <ricardo@ribalda.com>
Subject: [PATCH] libv4lconvert: Fix support for compressed bayer formats
Date:   Tue,  5 Feb 2019 18:06:44 +0100
Message-Id: <20190205170644.29751-1-ricardo@ribalda.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

10 bit packet Bayer format broke the support for the other
compressed bayer formats.
Due to the fallthrough of the compressed formats, 10b code will be
executed for every 10b format.

Fixes: c44b30096589 ("libv4l: Add support for BAYER10P format conversion")
Signed-off-by: Ricardo Ribalda Delgado <ricardo@ribalda.com>
---
 lib/libv4lconvert/libv4lconvert.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index b3dbf5a0..718e1d43 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -990,12 +990,10 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 	case V4L2_PIX_FMT_SBGGR10P:
 	case V4L2_PIX_FMT_SGBRG10P:
 	case V4L2_PIX_FMT_SGRBG10P:
-	case V4L2_PIX_FMT_SRGGB10P:
-		if (src_size < ((width * height * 10)/8)) {
-			V4LCONVERT_ERR("short raw bayer10 data frame\n");
-			errno = EPIPE;
-			result = -1;
-		}
+	case V4L2_PIX_FMT_SRGGB10P: {
+
+		int b10format = 1;
+
 		switch (src_pix_fmt) {
 		case V4L2_PIX_FMT_SBGGR10P:
 			src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
@@ -1009,10 +1007,22 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		case V4L2_PIX_FMT_SRGGB10P:
 			src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
 			break;
+		default:
+			b10format = 0;
 		}
-		v4lconvert_bayer10p_to_bayer8(src, src, width, height);
-		bytesperline = width;
 
+		if (b10format) {
+			if (src_size < ((width * height * 10)/8)) {
+				V4LCONVERT_ERR
+					("short raw bayer10 data frame\n");
+				errno = EPIPE;
+				result = -1;
+				break;
+			}
+			v4lconvert_bayer10p_to_bayer8(src, src, width, height);
+			bytesperline = width;
+		}
+	}
 	/* Fall-through*/
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SGBRG8:
-- 
2.20.1


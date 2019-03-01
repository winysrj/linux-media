Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFE5C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0386820851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551444746;
	bh=TtzaGDnBnu/HB9FDGRnWhPK0qg7JkaEUm7MLTyjDUWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=edK+yP3LxmYjewgIZ7FrIa0WHPnEurGfzMyS0nzk2EMrtdH0UnL/JIyTDUuBoAYhL
	 LJYHiTqtq9tYmoOzsmMhEbef3Zj0/rWUH8ANk5K8Pa4VIKlCAJrHssQRCws+FOO3sE
	 jiHMW6CJmC/+9RuKdYUAp/iXq16BjEoQmxKtLYRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfCAMwZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:52:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbfCAMwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 07:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7q+FhjWdYXA1o+3VwsL572UHQ/YkxZUbnx9oC112dvQ=; b=E9BtiHc+b9BFzgt8ljPcjxyErG
        mZpvZif6xI3D4N2B7qVnVw5LG/Sf5u8Qi7a3YoAR6frPJrBnkUhxw5UrWL3SPuvjp7M6BDZk3Z0Kt
        6F9297nruD25rHA6sB9DNep5270rQ91wvvW3rl2sbnxhTGBKSp6uTBQD9Ihqoj5SsR1b+lOfmQr47
        X9AWVnJbTBgLRWWpHo+q6BDiBhNIZeqdkbRKu0HBlMVkEYk2YqSZNAEGjwbOFHGExArdDpk4Izedc
        schb569vR39+zHNBYLHpguXKDeQBl99JJ9apVIP6HTjpCNWVmjq9sqO6DpJ22sOBsu8kYn+h8YHro
        nt9RBI9Q==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzheK-0001Ac-Ee; Fri, 01 Mar 2019 12:52:24 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzheH-0001py-5o; Fri, 01 Mar 2019 09:52:21 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/3] media: vim2m: don't accept YUYV anymore as output format
Date:   Fri,  1 Mar 2019 09:52:19 -0300
Message-Id: <906312367485f0e67e16bc4fb12c239885b61dbc.1551444730.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <8d53fe1c2d8305dda9a360ace275c63dfacc3b1f.1551444730.git.mchehab+samsung@kernel.org>
References: <8d53fe1c2d8305dda9a360ace275c63dfacc3b1f.1551444730.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Handling any Y,Cr,Cb formats require some extra logic, as it
handles a group of two pixels. That's easy while we don't do
horizontal scaling.

However, doing horizontal scaling with such formats would require
a lot more code, in order to avoid distortions, as, if it scales
to two non-consecutive points, the logic would need to read 4
points in order to properly convert to RGB.

As this is just a test driver, and we want fast algorithms,
let's just get rid of this format as an output one.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 57 ++--------------------------------
 1 file changed, 2 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 1708becbaa9d..a0e52eb205e3 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -113,7 +113,7 @@ static struct vim2m_fmt formats[] = {
 	}, {
 		.fourcc	= V4L2_PIX_FMT_YUYV,
 		.depth	= 16,
-		.types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+		.types  = MEM2MEM_CAPTURE,
 	}, {
 		.fourcc	= V4L2_PIX_FMT_SBGGR8,
 		.depth	= 8,
@@ -280,26 +280,6 @@ static void fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
 		return;
 	}
 
-	/* Copy line at reverse order - YUYV format */
-	if (q_data_in->fmt->fourcc == V4L2_PIX_FMT_YUYV) {
-		int u, v, y, y1;
-
-		*src -= 2;
-
-		y1 = (*src)[0]; /* copy as second point */
-		u  = (*src)[1];
-		y  = (*src)[2]; /* copy as first point */
-		v  = (*src)[3];
-
-		*src -= 2;
-
-		*(*dst)++ = y;
-		*(*dst)++ = u;
-		*(*dst)++ = y1;
-		*(*dst)++ = v;
-		return;
-	}
-
 	/* copy RGB formats in reverse order */
 	memcpy(*dst, *src, depth);
 	memcpy(*dst + depth, *src - depth, depth);
@@ -352,6 +332,7 @@ static void copy_two_pixels(struct vim2m_q_data *q_data_in,
 			*src += step << 1;
 		}
 		break;
+	default:
 	case V4L2_PIX_FMT_RGB24:
 		for (i = 0; i < 2; i++) {
 			*r++ = (*src)[0];
@@ -370,40 +351,6 @@ static void copy_two_pixels(struct vim2m_q_data *q_data_in,
 			*src += step * 3;
 		}
 		break;
-	default: /* V4L2_PIX_FMT_YUYV */
-	{
-		int u, v, y, y1, u1, v1, tmp;
-
-		if (reverse) {
-			*src -= 2;
-
-			y1 = (*src)[0]; /* copy as second point */
-			u  = (*src)[1];
-			y  = (*src)[2]; /* copy as first point */
-			v  = (*src)[3];
-
-			*src -= 2;
-		} else {
-			y  = *(*src)++;
-			u  = *(*src)++;
-			y1 = *(*src)++;
-			v  = *(*src)++;
-		}
-
-		u1 = (((u - 128) << 7) +  (u - 128)) >> 6;
-		tmp = (((u - 128) << 1) + (u - 128) +
-		       ((v - 128) << 2) + ((v - 128) << 1)) >> 3;
-		v1 = (((v - 128) << 1) +  (v - 128)) >> 1;
-
-		*r++ = CLIP(y + v1);
-		*g++ = CLIP(y - tmp);
-		*b++ = CLIP(y + u1);
-
-		*r = CLIP(y1 + v1);
-		*g = CLIP(y1 - tmp);
-		*b = CLIP(y1 + u1);
-		break;
-	}
 	}
 
 	/* Step 2: store two consecutive points, reversing them if needed */
-- 
2.20.1


Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002FFC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C327621A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFCMs1Ni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbfBONGf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:35 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45091 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfBONGe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id w17so10238124wrn.12
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a4j6PQw1rq/Yi1h59JxaKOfx1J7PmiOubaFunImkWsk=;
        b=ZFCMs1NioShWzfqcoX4bzbicF/OzRkg8UzRHD/oAGrBhRoVNipGaPBXVOEOFPiJ4id
         Bz4u95qrMr3ogc75y6uyRulq3BAYhLQJqNv9zZkqYHsxxX1d/NagNmPkRc2oL1TTo1js
         ixlbH5g0XC3gAfje0ROq0WFm3CHV5WlCqCtFn865DEJWUbTsYLM7a9pQcGxoraCE+BNo
         +N1/oEepslI3niJcZ3AthI8aQWIv6erJn+J6vDikjqRQZwQoqKWcypp44Sf7jNa2Sczr
         65ZAYbg8jNKbvXejml09C6PgR7sFljiHfztL959kewwOQ/bjlZrCQjfqMq+QijyW2+PX
         5pqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a4j6PQw1rq/Yi1h59JxaKOfx1J7PmiOubaFunImkWsk=;
        b=F1byceU3gzdqkSK1u25r+XF5WifAAbJszuYGnMJKCdMjVaR1A/NJsj3VF8gSYBld/h
         6qDsjaD5qlsBh9l23x7UpFj26FN6e+LCl7mj+x++fo/uZWyvmy3g0VCpLYVbS0TgDSk3
         OPmTD/fU3NrlOrYafRX2i4eHD9zJmEApNTdQrJ2Fow6e1BKUVz9MQRbru4gXczOdurBg
         bPU/YYMPHYvjr+Dq9eSalNc9PPwyuD7OlxgT79+7OWHn/NTrwpA+kMZr+0s60F4Szh2X
         hDtBktL7a7A6rHXrKQNtlh/eyKWnbt3pygBHDPLCidG67ygTTECiKoNtC1rLVGl/x10f
         KPFw==
X-Gm-Message-State: AHQUAubLQ9LG1DL9HtULnIwTe/cDvKWaq/MvnbFGu1wIu+z04wUal1S1
        scldmB+1gVFrzo7ytweTBTGWLaipo4U=
X-Google-Smtp-Source: AHgI3IY+9B9Ye5Xk0nXJY51nnpl8l7+g78QQrvclOKzly4bbiOG3Zog7CDgMUvcqjm5DErhtksA7NQ==
X-Received: by 2002:a5d:5544:: with SMTP id g4mr6682530wrw.269.1550235992965;
        Fri, 15 Feb 2019 05:06:32 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:32 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 09/10] media: vicodec: add a flag FWHT_FL_P_FRAME to fwht header
Date:   Fri, 15 Feb 2019 05:05:09 -0800
Message-Id: <20190215130509.86290-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190215130509.86290-1-dafna3@gmail.com>
References: <20190215130509.86290-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the flag 'FWHT_FL_P_FRAME' to indicate that
the frame is a p-frame so it needs the previous buffer
as a reference frame. This is needed for the stateless
codecs.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h      | 1 +
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index eab4a97aa132..c2b1f3cc9fed 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -76,6 +76,7 @@
 #define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
 #define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
 #define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
+#define FWHT_FL_P_FRAME			BIT(10)
 
 /* A 4-values flag - the number of components - 1 */
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 40b1f4901fd3..1c20b5685201 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -257,6 +257,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
 	if (encoding & FWHT_ALPHA_UNENCODED)
 		flags |= FWHT_FL_ALPHA_IS_UNCOMPRESSED;
+	if (encoding & FWHT_FRAME_PCODED)
+		flags |= FWHT_FL_P_FRAME;
 	if (rf.height_div == 1)
 		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
 	if (rf.width_div == 1)
-- 
2.17.1


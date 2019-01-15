Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC74C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C491520656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:31:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDsUjuMT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfAOJbJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:31:09 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39514 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfAOJbJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:31:09 -0500
Received: by mail-wr1-f65.google.com with SMTP id t27so2095963wra.6
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 01:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=QDsUjuMTa8F7cjz4jMPwFCB7F0b8qtvsRjI92Ez5z2KUjsihifZZhNHOstN1p4rxsJ
         XLe+lR7Ontg3qxAobfe1UFZCKtRDxP82HmMTwVkFQboX8DdL5w90AHYGMt2hwtl1nsyw
         z7b17Bna4JMx9sBn/i3bot7uyrBRTKeBubLtlyir5/mIAjkDvvnC0Du3HjypngQUkiUO
         aSex8+82Nw1VsQZxJCVj+wH54pN87cKcHZJYK9nYh1WNCr9eSYS7A7rmwjNgB1I1DwcY
         PcHFeCL3y2gKUqq6SwNXAhx+XEQeBYQt/aWKN3zNXehYmG5roWtfHgpOJJRgmhSBbZiF
         AKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=X0Z3vp0w9D4TY7+c4u2YOZcIi1fuopAWg9Y/TrqnP4kR7t85jfXxT4fmdjBnlQ87Q8
         kj86i6XhYdxV3+guXRrQl51WVrqNlvZtxz1fv2JdmFuwQsKCdz0Lax01Vf8jHcodR1kD
         vPyh55Xj/snKsf/zBaau3XiUuTqiU3ORTkZt8Msb6+ln0/9QQyiFMZe35UlEuebIUirP
         zuoz+KTha9DcmD3eN2Xu8+78Cn0jYhmAtG2Ak/xyUPnLf+uXpTFmhth3d4s/m5jjtSdV
         BUIyX8kuyV7/85JpFgg1ZeTpAH5cu7MyRwYJcM2yPDnL8vCHeBciQU0zBMUuj46WbULf
         0khw==
X-Gm-Message-State: AJcUukeSQD2iKFqawPK9Dk9h6bUQDkdDUCkGfrrrCL2d92mS8ZvMUrai
        YdpF5HGqdg7yHhQLKy98Nok1IBaOfOs=
X-Google-Smtp-Source: ALg8bN5XVHJfGx8FTZ6HM3bTQ63gur4drJ65PHxm8uAGbCBgPjXoe+FeGzWTaw6Ny4Ir6tmtVGzaiw==
X-Received: by 2002:adf:ed92:: with SMTP id c18mr2282052wro.194.1547544667208;
        Tue, 15 Jan 2019 01:31:07 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id m193sm32998098wmb.26.2019.01.15.01.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 01:31:06 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 1/4] media: vicodec: bugfix - replace '=' with '|='
Date:   Tue, 15 Jan 2019 01:30:36 -0800
Message-Id: <20190115093039.70584-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In the fwht_encode_frame, 'encoding = encode_plane'
should be replaced with 'encoding |= encode_plane'
so existing flags won't be overwrriten.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 5630f1dc45e6..a6fd0477633b 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -787,10 +787,10 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 
 	if (frm->components_num == 4) {
 		rlco_max = rlco + size / 2 - 256;
-		encoding = encode_plane(frm->alpha, ref_frm->alpha, &rlco,
-					rlco_max, cf, frm->height, frm->width,
-					frm->luma_alpha_step,
-					is_intra, next_is_intra);
+		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
+					 rlco_max, cf, frm->height, frm->width,
+					 frm->luma_alpha_step,
+					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_ALPHA_UNENCODED;
 		encoding &= ~FWHT_FRAME_UNENCODED;
-- 
2.17.1


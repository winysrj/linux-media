Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE98C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEAE420657
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRkMndgo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394052AbfAPPZm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:25:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33757 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387580AbfAPPZl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 10:25:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so7429692wrr.0
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 07:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=WRkMndgosxGmgj2w/iVZY0lNMvUz446Aom6l+dDbEav4e7zDjcKseX7S5U1xDfPz1G
         FVCHJbuGOrDjUD/W6qo/NGRIpCMZ2tRqth8G3UMvWZLCyG6n6aDlEe4anBLB7/9lLWXT
         lUZRYIxMD/pQ1yDfiKntjZTEJk6lCnTz3rRTW+o5DmyjeFeWDiZQDqN0FqTaWYtb/84A
         ed8giMaDZj82M3NxzQO7rtF5CyK0Gz4x+TyeJVZuCtUuL47ZAPArXPQxZm+1DNSSYV7r
         1DK6QXombNJo54/fd5xeJpugOn/I20p/3CvaiVm7rRr1qeF5+MpyINmYz42EaeqB5Ls0
         EQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=K8XBVHJxVl/pLHylSDEprXq+BauMDeRBD5T8g2D8pM55fAL5DZv+xR+tW7DlPmFnsj
         SwQXdhLxGZHAt34BVvh7aWayph1bCrQtrrPhglZNws12ejXnE3EA4e1COr4eCVv7tc2J
         TDlsb7qyyg/mVqVGmNnxfD87X4+kONglBHkdFtqKf2NPck4S+SS2xRL5Rrc+7+CgUrJd
         c3e8ulKGCcDwfav1ALscaZ9seCsJF5rmoPun0lfBxhnEoSQLiHK6+ilZlAglFRgDCjHH
         M30TWTe+aJPGqDie8w7U5az5gyPzfTg6cZp4ihlDvvuNM1M88/rAIU8HafEhw6y+BqVR
         g1Cg==
X-Gm-Message-State: AJcUukfuKui4w2R5F76tlVMAkwSNqWA4CPc0Ps69OK/y5BtjKI0qMHet
        wH8cpbT00p/3pTIdEbI0pQTq5T77mvI=
X-Google-Smtp-Source: ALg8bN4FBGaFWiPXZEAXZ/5RzNFrQfpEl2Md4F+rJnJ1+SHNq3ScttcriWKcMLIVu5CJjax2tqzMxg==
X-Received: by 2002:a5d:6187:: with SMTP id j7mr8060244wru.300.1547652339663;
        Wed, 16 Jan 2019 07:25:39 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id l14sm161371758wrp.55.2019.01.16.07.25.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 07:25:38 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 1/6] media: vicodec: bugfix - replace '=' with '|='
Date:   Wed, 16 Jan 2019 07:25:22 -0800
Message-Id: <20190116152527.34411-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190116152527.34411-1-dafna3@gmail.com>
References: <20190116152527.34411-1-dafna3@gmail.com>
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


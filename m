Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21201C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 18:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32EA20856
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 18:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGuyxeMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfAQSYW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 13:24:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41418 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfAQSYW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 13:24:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so12090341wrs.8
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 10:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=TGuyxeMZ8eSR4ZSFKYiQJIYp65zTylgoTqnzd55CxMtu6OWvjTlnihGZvqmKS4gH2U
         6Ou1T+DQhjByetv+xhN+o3jLCRPPJUVcHwunccqMo8C6+0ozh37+iYGdee9Y8Q4/D+kx
         dcdFDIJuly085gNns+OD6ZmEo1EKU93iPa1ku+MuDQlkD8HbuDvX8As7qAEKepFdnvRF
         w0Gis2bN0/s6hNjxvTDj4i6ZHADC0Yv2Vk4N4ly2nU44EV4AHxo+/xRyq9OzgGiaq5ZD
         gbm005AjBN2OJcBV8Q99utnzwfM+G0xdRCXf7R6Ne4Ml1EJQTj5p32Ff01RJ5YYKhCB5
         JWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=XZ93qm8oatd3hWQfTgUW1W4VHXG9ZRAV/+Ct/ju2FPfdIQ0CZb2NTMSyu3JTZF5Jnf
         XCrDgPEa3swjMe1Tj8sr9qw1EXrK4cUQxv2sY86K/UgUo+cy5q1bWj572rLou9okEZSC
         IZJBghMgY48iBx/jCYoGDq/nKrACNHuapmr5UCfwysAZHE+3QC8sDTph/fE2kkb0BLzS
         hcLRApMguG9R1fpA6KQQWKZSTeiTUDJXvjhDDsIqlrlu9Cu9X0OSjpkR6TgNKDtpnsaX
         sK0Z0Qbz0qNkgW4KkcST9mUsrTWQjq2BslTIGTY+RV9TkDPQuG9l11R1y/DoxNmWpxyH
         MzAg==
X-Gm-Message-State: AJcUukdr/rE+CbKeHUhkhszkVyMz0czLCKoBSj5s8peTbli3KLUDyIz/
        86klWDJzLQSvZcpRxGh3K2t92fimuSM=
X-Google-Smtp-Source: ALg8bN779W4ckAVQh1MnjJ2Wk3mXhtQU4FrBfY9g2ld0stknFfF7GuqAVtkPX6MWpFl+WbLfHKha/Q==
X-Received: by 2002:a5d:6a42:: with SMTP id t2mr14107466wrw.50.1547749460029;
        Thu, 17 Jan 2019 10:24:20 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id o4sm76052266wrq.66.2019.01.17.10.24.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 10:24:19 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 1/6] media: vicodec: bugfix - replace '=' with '|='
Date:   Thu, 17 Jan 2019 10:23:14 -0800
Message-Id: <20190117182319.118359-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117182319.118359-1-dafna3@gmail.com>
References: <20190117182319.118359-1-dafna3@gmail.com>
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


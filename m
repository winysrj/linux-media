Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8179C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 17:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE9A20578
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 17:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJH6Tvf9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbeLQR5Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 12:57:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37875 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbeLQR5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 12:57:16 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so129434wmd.2
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 09:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=lJH6Tvf9EmEzQHPHHQUaoi4HY6QC/rPVX3pQzXAhRaAhhZUNUH59M/r7H+kfG4WFnf
         wOjsUZRULXZVuToDRUpp2R1I8ToD/qIt4UZKw8QUTPvqR2n6PkZ0rwz/FcUQZvUosw+g
         8fFuFIybYcniigGaaqa/1HdRUHMDzOPmKzQMujkDW1p7i7JIOlC+8TObCYktuRhY4RvD
         8zcHRjE17jtEfWEgrVAvEp5ely5/zAHEEmU1NrOaQLpBosDFBYkpEV8NecKI0UsjM3ug
         lFcybgu1WIn7G2ap6w3JHmsFMsFBMqJ2RXHDN5vFdD6HLZj3Hl9FqBETcmGkYdxHNrUZ
         jjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GsUE7+1OYPkQViw5v2tIo8Rgd6FdN8vkhk5Xa/EaFII=;
        b=NYyztzL+PN5b/3lZGeDwehRlQUEsUtFSXe9y0k70KFznSYhE+XJJ3v52rmBtnR13XR
         svBEQN+JMsWnYr3deVticeLYgDb1/z7AeCIjX3py7tIDD/c6WYrFjnmDY8MV9FU0Zh9G
         sHyfUcSIrwhUL8G7/rhk0g80nRkrrF6er5O70XwpwxINsMzLo5SBN/lFVh4/h34EMRZx
         310EkI5gEVLcrcYRG7NuBDSY3j9hGq51xU2JFgb+4g5F6qmwC2twXjLCmJw792aTHmbt
         RHlOi5PFP28yCzVex61ZUiJ6FF2XIQTNi9pRjrDQ9ORc2wp4D9r/nmbdqWyuqEUctHDO
         UVrQ==
X-Gm-Message-State: AA+aEWbGJXOJo9WwDtM7KPqRk+YR2F/0+jXfuCaabFO2Gf7cCvvkUGFt
        GMwYfyLLzwVg7HIdEikClV6Q27HYCc0=
X-Google-Smtp-Source: AFSGD/WOspmCjHI4mQsP0cXb6XWeehcTO/o7eJ/Ci46KprvffBBagNChXhhiLtXxdDiHRoClwJV9zw==
X-Received: by 2002:a1c:da0c:: with SMTP id r12mr132748wmg.54.1545069433845;
        Mon, 17 Dec 2018 09:57:13 -0800 (PST)
Received: from localhost.localdomain ([87.71.129.70])
        by smtp.gmail.com with ESMTPSA id h17sm742140wrt.59.2018.12.17.09.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Dec 2018 09:57:12 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2] media: vicodec: bugfix - replace '=' with '|='
Date:   Mon, 17 Dec 2018 09:56:17 -0800
Message-Id: <20181217175617.52839-1-dafna3@gmail.com>
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


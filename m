Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA6EC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 748DC2147C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jveAT8HH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfBYWW3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:29 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44495 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfBYWW3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:29 -0500
Received: by mail-wr1-f68.google.com with SMTP id w2so11689443wrt.11
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hS2J65e7s6nJaS/wJIm8W7tGBrjvRMsWaonRX9Aa1KY=;
        b=jveAT8HHi/sGTnH+XM35quYDs0YhK9GbotwpRbsuoCdBJCDILXsW8teL+O1f1NpCiL
         m2fAzRrHfuaO6Uflrpv/LCBivCbLo2SG1D9DRy6k/olyE01FYLmLpnH1fzeNyxYHVTXq
         1YyRbMP++vng/+TPRM7KF5sFmvAR89iuDc4qdYTFmWkgYznPScuhBq4MgiPcQspBW22H
         1eyCYY4ZliSTkZIXFDMycYbVKSwsHCkG1zkFO4X6hL9EVuo88yxWSPMhXveLgcucA2+6
         563FDVV0hhENN2vFe2lXSy9uNz7nbXE1LfLrwTtGteeKJqHp2EpsxnWfZmYSbNwXisWO
         vdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hS2J65e7s6nJaS/wJIm8W7tGBrjvRMsWaonRX9Aa1KY=;
        b=r5tYM+imosIwU7E7wF3mdgukasJmrmnAPiwk+IfD1ZmqyauldsbftfU+5SUu9RZbst
         cGln1YZozwtNLr+D5jaFrwX6daygcsUHAMuxo1JjENZnw99tHS+KhChWU9fqJIuw9YEX
         9HraoWvDu89TDe2t2i071tQpADtKdID9h2ecLQ0gpdj6eBIWL8830+FpOUuLXE4y5ZZt
         QzoCwBJ//cQXEJiJoW0WpXV9Xn32R15cmfpToZ1r/F/sI4H+5xLVEpbwY/ZFnkQUNa5a
         ygG12DCvIDjl7Ap/GqEbGSCo5hD629kfHlR6yYi2vUV/kpQAcL39zNgB3kaXc5rAf3Ek
         CArQ==
X-Gm-Message-State: AHQUAuZQ6UKSAkoAHDdPnDKMvI8U32tIGXbsZ2RUtTUagKHyXKbelLfJ
        BkUoBcA0QQzxsqK/1Jy++gR3cIITGA4=
X-Google-Smtp-Source: AHgI3IaLbifEnQABkyXBQpfoDPwRH4N5XkjxLYXjRvH2YyJOHgeMfqD+5AIFEpMK3K/eg5nBmkIKdg==
X-Received: by 2002:adf:f543:: with SMTP id j3mr13499745wrp.220.1551133347844;
        Mon, 25 Feb 2019 14:22:27 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 16/21] media: vicodec: add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
Date:   Mon, 25 Feb 2019 14:22:07 -0800
Message-Id: <20190225222210.121713-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
controls in ext-ctrls-codec.rst

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index 54b3797b67dd..a30ce4fd2ea1 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -1537,6 +1537,18 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
 	non-intra-coded frames, in zigzag scanning order. Only relevant for
 	non-4:2:0 YUV formats.
 
+
+
+.. _v4l2-mpeg-fwht:
+
+``V4L2_CID_FWHT_I_FRAME_QP (integer)``
+    Quantization parameter for an I frame for FWHT. Valid range: from 1
+    to 31.
+
+``V4L2_CID_FWHT_P_FRAME_QP (integer)``
+    Quantization parameter for a P frame for FWHT. Valid range: from 1
+    to 31.
+
 MFC 5.1 MPEG Controls
 =====================
 
-- 
2.17.1


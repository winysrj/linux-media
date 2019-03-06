Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E935C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A3DC206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ub264RGd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfCFVOi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33994 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfCFVOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id f14so15039167wrg.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J1x9nmxOmPvgVvYTLLB7Sji6XAxQvIs8qtgVWC75xxU=;
        b=ub264RGd5My7FGCrA9ITCLB8SX68FJaQ3KViyDY7+hRCGg9n1ZKXz9pO6lEreurOhk
         iQk0wYQXGJg+6+Dwv3xtNceGuX5URSiI77n3Z+XImWIolsGEunmNO6nJhJ26nNjt8q31
         MdIeo1ijEsf1dk8QAgPNB5IMy85/Zi1/cu+BbrnvdYJahAnrbKIM0FMZOLTJPy6AY49S
         FGCtTZPP0mcKKxIm1pwBMZsgfKpjTnEX/9UeC+minNadPVcEGL3d1S2+cc1SywzSDc5H
         efpXodIAAE7vacyod1Qb/lSArvWaZKZ/X1DMNofdkLr7Y02FHOTcXgnUk/kwyuSv6ZcA
         HvyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J1x9nmxOmPvgVvYTLLB7Sji6XAxQvIs8qtgVWC75xxU=;
        b=ewUu4mQu6QH5uiKmDG1uMibB2GxesdzcYUJJmaJhtOqO7fVAM4V9tI5qq2yNPLAmi9
         Efcawcv+DVZCwL9yOWDRQBLPieq05+nD+9FnTzXu5Ewod84drQMml/ZiGkzjYi0iWB7s
         abX/3706G3X+opu74RqGUgfy3nDF1E0N+oWQ6c+wcxOHS1dlW39zUR8BNx5tFtdMRXk0
         OhR16UcwSptlVdDDD/4dQpuZUhUAk25sk7kAZCd/rcbAjM04xtYOxq3cTDchVrRYAjB9
         VPXG7SrQCD+z/GgKSi/1T3FhU7nTei3uokC7V8BCQcY5B83KWfL/Y1W8F9rP07X7R9Jx
         0CVQ==
X-Gm-Message-State: APjAAAV7A4lgu0PvC61zfzsr2yC2TIfFm+BFgBLU0dxF7tjMVkefxWDg
        FqrDZwwt69/B/zjBkcuPc2kpdZDZFYk=
X-Google-Smtp-Source: APXvYqw7VLlfwZ8/cvuTdKpCLCiJwG0BmKcrL5FYTUKnthKFLZCk3w5omigHw+IoPET0VULmwOl1iA==
X-Received: by 2002:a5d:500e:: with SMTP id e14mr4221647wrt.219.1551906875488;
        Wed, 06 Mar 2019 13:14:35 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:34 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 19/23] media: vicodec: add documentation to V4L2_PIX_FMT_FWHT_STATELESS
Date:   Wed,  6 Mar 2019 13:13:39 -0800
Message-Id: <20190306211343.15302-20-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_PIX_FMT_FWHT_STATELESS
in pixfmt-compressed.rst

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index 2675bef3eefe..6c961cfb74da 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -125,3 +125,9 @@ Compressed Formats
       - Video elementary stream using a codec based on the Fast Walsh Hadamard
         Transform. This codec is implemented by the vicodec ('Virtual Codec')
 	driver. See the codec-fwht.h header for more details.
+    * .. _V4L2-PIX-FMT-FWHT-STATELESS:
+
+      - ``V4L2_PIX_FMT_FWHT_STATELESS``
+      - 'SFWH'
+      - Same format as V4L2_PIX_FMT_FWHT but requires stateless codec implementation.
+	See the :ref:`associated Codec Control IDs <v4l2-mpeg-fwht>`.
-- 
2.17.1


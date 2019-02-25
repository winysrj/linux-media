Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6932C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4AD92147C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMF+O0ie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfBYWWd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:33 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38832 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfBYWWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:32 -0500
Received: by mail-wm1-f68.google.com with SMTP id v26so475145wmh.3
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+8ZihpelRkfn+0gfKMXaEJDJnAScnujS+xKL63fuqQY=;
        b=IMF+O0iebzP/yfuKyhplwrBvV18GyK3ACFnDeHSIS/mGDmkyUgmOpp4+36sOO2UG5Z
         14LIip4PBia/FhQOISzj+j8V6x4/pYAv/oIcNfn3x8LaTl2LuIGYqe5+aL+gs9C9lKIh
         HNqO1MDdDUWqRCf4ZzxFnpImwS4ccGAirAYm9tX9DDEU3v2Gts5iV/0K6aF8dceEwoHu
         7OvULHTy3SypAKC8kITHLri7t50vMuhcz0BIZk5sdmwkvug/Eb9fdSQA0JH83R+8UdXB
         47INexw7IxZJFL4Ss7ZZfUuM2u8bQyaZPJBq6MNvbmxhBDnG0b2N+P0pCd6mbcJnOwwG
         +PSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+8ZihpelRkfn+0gfKMXaEJDJnAScnujS+xKL63fuqQY=;
        b=jvp38grfrSpAqJo+3BxXL9nqCftgfo1w1VRgWf6b15o+GR80Bm24UklGB+VGDQkD8t
         8gZuojCjjd8uLp/8qqs0pZ2Ui7VKSVfVrrguGQd6a2ORFTWMAqMBGV5rAPtTG2Zb+/gP
         b/uYdnMyCnSpSqXpqFRSKi96NAkQ/DZMmjzI3DZYwwj0IkL/2fsSIZ3v0roSt4cQXk+T
         rI3PjzZiUyIdq/+l0JKHO9KrAJvRNSSR/DkrHsFPDo1hZiINwH5bR+hm3YjId06adtka
         AI0PJinLw8GS5KhGMa83xB5fkVnP5nM2M4z/GoILcyGdVnaGMUnn/zRpE2KkeTCP/l1i
         9kRg==
X-Gm-Message-State: AHQUAuYYEVttGIVCOC7PUI6dHxVCF3hm5zs5shTdyni2GEazKuHyUknn
        SNKuGaIinqCfakaAKeoL6IL7z34QbJE=
X-Google-Smtp-Source: AHgI3IbMuxDioXYmPzDMF3pTbTX8jNCiCTDRkKgBLEw2K11ecOyLesOoFKLTByqoiHTc858eBYBpFw==
X-Received: by 2002:a1c:47:: with SMTP id 68mr530544wma.89.1551133350441;
        Mon, 25 Feb 2019 14:22:30 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:29 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 18/21] media: vicodec: add documentation to V4L2_PIX_FMT_FWHT_STATELESS
Date:   Mon, 25 Feb 2019 14:22:09 -0800
Message-Id: <20190225222210.121713-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_PIX_FMT_FWHT_STATELESS
in pixfmt-compressed.rst

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 Documentation/media/uapi/v4l/pixfmt-compressed.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index 2675bef3eefe..8db54a763d44 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -125,3 +125,8 @@ Compressed Formats
       - Video elementary stream using a codec based on the Fast Walsh Hadamard
         Transform. This codec is implemented by the vicodec ('Virtual Codec')
 	driver. See the codec-fwht.h header for more details.
+    * .. _V4L2-PIX-FMT-FWHT-STATELESS:
+
+      - ``V4L2_PIX_FMT_FWHT_STATELESS``
+      - 'SFWH'
+      - Same format as V4L2_PIX_FMT_FWHT but requires stateless codec implementation.
-- 
2.17.1


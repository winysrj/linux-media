Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF80C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC50920C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DyygAOfr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfBZRF4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52032 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfBZRFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id n19so3149493wmi.1
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2TNe9ZQ2NYVvjDvgjIaHN9hpzsidf+TwoLcC/f6w4mc=;
        b=DyygAOfr+5ew7s7mFctqQIdH6XhGrUEg3y6V93PmJQFQ0qfZBv9Uq5sHPnJ0X3JJ/m
         Qp2mBx/lY9oUBlDsKSAVG68ldi8ouD+eFdmwR8fdrgWVrBMD6L3oCekNNoW4a+nLXeFf
         WMk6h15XQoRU9+ba4V19DZGsnb4M8KfCVjR9/LJX3V5PLtzdZXz5Mb0k1abPhLw2qo27
         JdWiVkn/e1oxFcCh/WmWvQx9UNcj4dWvuOiacl7/hXxorzkhZNDBS/emrVvLtZlV3oEj
         0Eyf/bE5TQ3FHAVA/qbncNrAs8xT7wPso8W1+SJl23aZqup1ES5Qrb2j5fNwmKqk6gwu
         tcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2TNe9ZQ2NYVvjDvgjIaHN9hpzsidf+TwoLcC/f6w4mc=;
        b=i9sOe4nFfNFgZ2SBXb2JqSBw2+VpVkDUqKVzkdON14H8BXabNhAYF0aBsgZ0FYJ4UO
         7nxWfPJWWiq/dEXu/dxqM65VPGXgH64Wbx1lekdpz9C68Ig/xCIYRQIEwj5mXiU+fJvB
         5r+kJvvHEWG0LK1LW9YdilqZrQkU+mNsa/UyWCZkBKqnq2KuxAi5ymYr0/uLfwQTvihJ
         fVxFMRHlDM2GQAqYsL80AkgcNBCsE9RIFtFiDB4XvH5cY8EFmTR4KaP/4+rVhalvEaU+
         sW/CkD/cwsr/Pax7AIUm3aDY29MxhLMEZlRxgltadPqzdqSkiWNc2BQRzaMveANA4nCq
         FDEw==
X-Gm-Message-State: AHQUAuYVmOxR3hQE4iF051moZW/E8gPttO1FjDzLmnots6Ir7tsAxCAT
        JqSZdtdkhQMueFgavma90BmF+xMOnr8=
X-Google-Smtp-Source: AHgI3IZSaX+HHcLLIeWT6WQQ3W1YALEt+ia8ZQrUERGADRS8LIFy7HOIe0s/rXyHJaF09GX5M47XuQ==
X-Received: by 2002:a1c:5f86:: with SMTP id t128mr2370185wmb.87.1551200753461;
        Tue, 26 Feb 2019 09:05:53 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:52 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 16/21] media: vicodec: add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
Date:   Tue, 26 Feb 2019 09:05:09 -0800
Message-Id: <20190226170514.86127-17-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
controls in ext-ctrls-codec.rst

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index 54b3797b67dd..088d25a670cc 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -1537,6 +1537,17 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
 	non-intra-coded frames, in zigzag scanning order. Only relevant for
 	non-4:2:0 YUV formats.
 
+
+
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


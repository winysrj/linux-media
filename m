Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F87EC4360F
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED42D20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tx20YeWj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfCFVOe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43726 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfCFVOd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id d17so15025406wre.10
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cvnF/wqW+TOEgH405t2Qe3jNAkw3zuVAzQJkH4aS0TE=;
        b=tx20YeWj38BUyyk8tzqUCQSZQIK7t+u2jm11ice53bUywjbk54HSCxKy1V6KqUuvp1
         EmwJU2Qi/fRUNzE20jHOxPIdUb06FpX6UukLkbg9afHH2WNzBolT718ZPsKV1CCiTz6u
         DG/4RN9n/wZ+V+bJr9oPqKMnxdnBX8Bzgmf7ZvB8hoOv9MXPidDAIF6iCJfI+inziFw0
         h9vy8tsi25YAmRX+nx5WvvTFepsRJX86u8jbtkz8BtkC5ghKGUWZgMoGJyJnM7XLBOcx
         UHX9bo5e7btXmGKano5CCv7lBAktNtH6LDQvuUJGBXInGhp+liQD3u30YWZP+xvn0X3p
         w3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cvnF/wqW+TOEgH405t2Qe3jNAkw3zuVAzQJkH4aS0TE=;
        b=E9r9j1Y9FHAM7M4J5mNGK23nLdp1b4N/9EUWka1fwNGplUvp0Pp9FZ6bAZVSpfhdKi
         XM24yHhkOqSPA0kViXZ8XsChNsHA9AUXB2JZLHbfFYLO0k9bpd2r9W1eI/8xShrRW+eE
         Zv8JmPu/y4nxVca2s7hta7M+Jvm4Jm/YLrkwg5B5Aj+fgyULGFhFHDGiVe0WiRWi+2DR
         9e/hHHKL3L/Rdm1NhlwK7qnP5evhDdQu6C0dNdvYowwkXDOJyyZkuFktlM+27FXZcrfi
         3sh/LgPIWTZT1Gg2QrCz7uZ7EHQq34bbZqygLwRMJD3jRGS7sq5Bq7+7ubeYDmlpHZKE
         ThMQ==
X-Gm-Message-State: APjAAAU1+QPOMTr+2kroSvfgqtHfUKTCGEVQzBtadoMIiKXn2+VepBjI
        EiwY7JygwTRpQci9vAoHBRhUVEXW104=
X-Google-Smtp-Source: APXvYqyCI6CvBm1Fz7D7wahJzYGBHCs3bh3z+m892SOOeJaeoWBLBr74WpeqDmjPMA0jfYYQ+b+WGQ==
X-Received: by 2002:a5d:5351:: with SMTP id t17mr4141737wrv.73.1551906871667;
        Wed, 06 Mar 2019 13:14:31 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:31 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 17/23] media: vicodec: add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
Date:   Wed,  6 Mar 2019 13:13:37 -0800
Message-Id: <20190306211343.15302-18-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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
index c97fb7923be5..301a4dfbbbde 100644
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


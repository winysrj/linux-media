Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E2CC282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54522218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GPCj3Ido"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfBINyk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:40 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38358 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfBINyk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:40 -0500
Received: by mail-wm1-f66.google.com with SMTP id v26so8296876wmh.3
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g5pB2CcL2OHXa8Xh/kpuo3xabwgquLuvIuM8V7Y0Fdk=;
        b=GPCj3IdoQhuG53tGDrU5IORflbNcTcHZn4tsi0j7qnRjNcl3P2smoZmy4xjdKtV/ny
         lx6ZS4sNjGiX70iJRrYElCCEbdQFBON3FNT+sxbc++NEllhEePcYIfGV8cFv6HTltnMq
         YZdPnKYEQ4QprY4PymzvT4rBzOa6KjHlUHCheuVm6Efg4Cz4h73/cLIV2Lg6yhs5lxqN
         ijjP2gDJIK6uNxErWUX5DbjSKnA9F3kIQ1K2HZXTjIWcBSiTyhtz5wqQc2q5b70Dla4d
         dKPe2DcrIjMd78q9Zz1Xg54QgZ7O8OknhU955wW+u4pIoTbx4C7gsmfvOqbeDD2knOc6
         lmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g5pB2CcL2OHXa8Xh/kpuo3xabwgquLuvIuM8V7Y0Fdk=;
        b=F/H04SdcAHWq4Rd+Rtd6U4xF06ypc0Jly2OFU6WxBh7MsuW1D9eBDXEcsAqfyMDh2y
         Hup3Zuh04uWpU96mBltrJ/IKT9ZzFErNn8JMR+gERwqCB92bZDFyAL5Ev3pklGc3ohlX
         LYUcEljtLQ7n7MNAOEM6Z17fcGi+wqPQoWGvkJavgVJbl3ezKurZ2SZenOsWk8Runb8d
         oTQ2oq/1EUmPurFKMIAIdc6qIbE3+neDAqSS8WgOPUF1iyU7Wc9XQjda3ktzcdT3kRrE
         AaEf9JNAiuxJlkv/9ef+TOdy8xY/FpqlLczaVPB8UPndJ3ZG26SXY5Cteu7tVBq1p0D4
         7JsA==
X-Gm-Message-State: AHQUAua5yQZlzN3AtQjvatwovagIGXXVVXmZNoKW5I1lQjwLzM05pkWc
        9dZgQzOo6gsuvLTXohnJu03Ndw0KS1Q=
X-Google-Smtp-Source: AHgI3IbYDin+y1sNBZJv+tCVxnUDepG/PdoFi1X1E88wDnol6XlKBEPoVA2H2NegzApOipD1siWNmA==
X-Received: by 2002:adf:9b11:: with SMTP id b17mr21041730wrc.168.1549720477306;
        Sat, 09 Feb 2019 05:54:37 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:36 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 0/9] media: vicodec: add support to stateless decoder
Date:   Sat,  9 Feb 2019 05:54:18 -0800
Message-Id: <20190209135427.20630-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from previous sets:
---------------------------

Patch 3 - (keep the ref frame according to the format in decoder):
-----------------------------------------------------------------
Move the code that copies the capture buffer to the reference buffer
to a separate function 'copy_cap_to_ref'

Patches 4-6 - fixes according to the code review.

Patch 5 (Introducing stateless fwht defs and struct):
-----------------------------------------------------
add width,height fields to v4l2_ctrl_fwht_params

Patches 7-9 are new

Dafna Hirschfeld (9):
  media: vicodec: Move raw frame preparation code to a function
  media: vicodec: add field 'buf' to fwht_raw_frame
  media: vicodec: keep the ref frame according to the format in decoder
  media: vicodec: add struct for encoder/decoder instance
  media: vicodec: Introducing stateless fwht defs and structs
  media: vicodec: Register another node for stateless decoder
  media: vb2: Add func that return buffer by timestamp
  media: vicodec: call v4l2_m2m_buf_copy_metadata also upon error
  media: vicodec: Add support for stateless decoder.

 .../media/common/videobuf2/videobuf2-v4l2.c   |  14 +
 drivers/media/platform/vicodec/codec-fwht.c   |  68 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  11 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 416 +++++-----------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   3 +
 drivers/media/platform/vicodec/vicodec-core.c | 465 +++++++++++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          |   6 +
 include/media/videobuf2-v4l2.h                |   3 +
 include/uapi/linux/v4l2-controls.h            |  12 +
 include/uapi/linux/videodev2.h                |   1 +
 10 files changed, 555 insertions(+), 444 deletions(-)

-- 
2.17.1


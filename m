Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E407C4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C3D121A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOFI8JGQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394891AbfBONGR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39745 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394890AbfBONGQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so9183895wrw.6
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bnBiJ25WRaESUF6QUPK5DOLyWDoXWSDCtG8KOurDpxU=;
        b=NOFI8JGQOdXZ7NhGekX/Ni01ZxMcP+jHbPFf+OrjHMXmGYCXBu0mWgxQaJ6prslWgK
         8PXi723lBx1iFC8FZZ1p3LX4DTG2JWBsiSYuyM5rEbBTwHFdPgIi6wV754/xDwCAN6k6
         ptrdKpqqmIKwla5Qfx7QY8DtphIPpgLl07DEK/1hSl4wmf9v24EgFwwuCIlKbQoebf0Q
         xzL50Ag2LEAlUpD8pdInQnr69Rvno2U+YX+J2osfbuL9ZS5FblVj4XMoSoYq2xpROVZP
         C8aJMUmVJi9OpzYlm0UQIg7ICav7D/drbqSyMUP8Ved0k/D4p8Wro9pNs6C+pBSjLMv9
         DXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bnBiJ25WRaESUF6QUPK5DOLyWDoXWSDCtG8KOurDpxU=;
        b=szLotSYF+AJN3R6Bjk/XBvJ9L4YeHcqHsciWLqwl7SWjwhEB3/Udlk6y/xzua8vEo3
         xpM50TdzBGPdl6gHnWHv+xkna2OpKocvLnQ/eJfNbx8R09Y2bQu1fEI7OVOM4K3FEi6Z
         KkRBq2T9PjndmexlGBLdyoJYiwkJ7GIJgtGxzq+AusBdRpfCb+g7PlBrhU6iKtnnO2gC
         IKY6znpawvIy75llRUP3RSXkmB3KEbttGLMZ2NIc7rFwA3XlYBoeMqq/KABYcPx0G8mJ
         JZDDhUYO7MzTqzyRUhLAdfdOBSd2mDS5yFPindmvhemoJfFqtFfiBKDuvLFMLLsv4tkx
         bJxw==
X-Gm-Message-State: AHQUAuaA63RGR67fSH0VnfShsjWZ0C1AU2r3AhizhN0H47aGXgQndvLk
        X2B9LyC1yIxDY6E6sg5+9XUU8915zBM=
X-Google-Smtp-Source: AHgI3IYKTB1CtOTeeeWC2mUHHTAW+F2egk3NxpvhAKtwoDlZUbKdMYXGq6ZQe+dSoQ6pykOu4v135w==
X-Received: by 2002:adf:bc11:: with SMTP id s17mr1385973wrg.129.1550235974407;
        Fri, 15 Feb 2019 05:06:14 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:13 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 00/10] add support to stateless decoder
Date:   Fri, 15 Feb 2019 05:05:00 -0800
Message-Id: <20190215130509.86290-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from v1:
2 new patches
0001: media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
0009: media: vicodec: add a flag FWHT_FL_P_FRAME to fwht header

changed patches according to reviews:
0005,0007,0010

Dafna Hirschfeld (10):
  media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon
    failure
  media: vicodec: Move raw frame preparation code to a function
  media: vicodec: add field 'buf' to fwht_raw_frame
  media: vicodec: keep the ref frame according to the format in decoder
  media: vicodec: add struct for encoder/decoder instance
  media: vicodec: Introducing stateless fwht defs and structs
  media: vicodec: Register another node for stateless decoder
  media: vicodec: call v4l2_m2m_buf_copy_metadata also upon error
  media: vicodec: add a flag FWHT_FL_P_FRAME to fwht header
  media: vicodec: Add support for stateless decoder.

 drivers/media/platform/vicodec/codec-fwht.c   |  68 +-
 drivers/media/platform/vicodec/codec-fwht.h   |  12 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 418 ++++---------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   4 +
 drivers/media/platform/vicodec/vicodec-core.c | 589 +++++++++++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  24 +-
 include/media/v4l2-ctrls.h                    |   2 +-
 include/uapi/linux/v4l2-controls.h            |  14 +
 include/uapi/linux/videodev2.h                |   1 +
 9 files changed, 656 insertions(+), 476 deletions(-)

-- 
2.17.1


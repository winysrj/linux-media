Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A17C6369F
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 13:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284E820861
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 13:29:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9B+hUy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbfATN3T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 08:29:19 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35004 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730567AbfATN3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 08:29:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so8463548wmt.0
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 05:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KMebfeGKH5vx3QdepHUTjRfTO+pigvIDq6SJlAv97qw=;
        b=C9B+hUy0iuRhAizLVpWNRKd7MHw5hBQRi3Ma9kj6Uau/eyZJHfcA1r5ZWigmcMLYM5
         A5w/sEua8e8JrkD6OtX7Icrgo/p5G3XV0P+u00iz4i6QRuiJaIGvSVCXZM04gnZ/n0m0
         vzN8lakdgX2fIEpU+SNbvs5PjhhmOKFSJq7vHFJ5d5Yw1MdVczexgsPT14dkTTLi/wpo
         OivAq5zDUlHjyyItu3M+h58O+j9y1sJ8QrMfi/CmIIJQ6f09iaiRV17/m4lZmzZFTKyM
         cFb8xLzirw91pX0RzniNKwrn3aSTAbLGCDt8/VTwcLUxyiKz28dDOWVhONek6dqFFnQ3
         3nNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KMebfeGKH5vx3QdepHUTjRfTO+pigvIDq6SJlAv97qw=;
        b=ltJQ9AtgpQ7hP+vo0q0M/gCpXGN6QttjFC0PwNXvS2kiBQT9clOrYsoWn3fT9U/J3K
         YXacMXdWtgrZo51E8ixUkcRjMJXPntIrnJf0gYL+YFGRGHd8lve42CIsP6hdN5gQzpws
         HBY03BPx28wog8eOUTF6jpDGfhaR97mxL3uyYhYYkNT7NtFJodi89EP4nnQIFwAHwN3B
         tVvXxPHJvy2F9q3uCZmgajrZsXbn8fh+NJOA5/ixfD/a8bIdcNpwbFKRv3aIkSIghGk2
         CIr3i/w50+Tz/ZdY1OfHd1zVWigALc7BEZcnPx7HA2khPkaz9/3g0RLXwER8hQ9RqOjX
         WRLg==
X-Gm-Message-State: AJcUukdAJRvNrA67boKHwxYPLDuZ34fW1fJZd9PcuyIEyjJJPh/+kOht
        dLoDtUrVQd0Kyoet+CEDXMkUtIKne+8=
X-Google-Smtp-Source: ALg8bN4kFKk4kCeQU8q6yFfDBAuY/aH3tuoffMvYwlFFqYtNHBLO2EOYWAk8TQCqSPKaR7hxy71hNQ==
X-Received: by 2002:a1c:27c6:: with SMTP id n189mr21302643wmn.108.1547990956844;
        Sun, 20 Jan 2019 05:29:16 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id e16sm148601036wrn.72.2019.01.20.05.29.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 05:29:15 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 0/6] media: vicodec: source change support
Date:   Sun, 20 Jan 2019 05:29:01 -0800
Message-Id: <20190120132907.30812-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Main changes from v4:
1. in patch 5/6 - bugfix in get_next_header
if memchr returns NULL, set p to p_src + sz
2. in 6/6 - some bugfixzes in buf_queue callback
and remove the field comp_frame_size from vicodec_ctx
since it can already be accessed from state.header.
This also fixes a bug where comp_frame_size was set only
when the full header is dound in job_ready

Dafna Hirschfeld (6):
  media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
  media: vicodec: add support for CROP and COMPOSE selection
  media: vicodec: use 3 bits for the number of components
  media: vicodec: Add pixel encoding flags to fwht header
  media: vicodec: Separate fwht header from the frame data
  media: vicodec: Add support for resolution change event.

 drivers/media/platform/vicodec/codec-fwht.c   |  80 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  25 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 384 +++++++----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  15 +-
 drivers/media/platform/vicodec/vicodec-core.c | 611 ++++++++++++++----
 5 files changed, 812 insertions(+), 303 deletions(-)

-- 
2.17.1


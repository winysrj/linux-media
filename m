Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EBBC61CE4
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70F902087E
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHy8O1UJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbfATLPb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:15:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40484 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbfATLPa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 06:15:30 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so20069361wrt.7
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 03:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y3/hFW4GN16Be2yGUjLDnlYfrp+CPbxcc+i9fPNK43E=;
        b=DHy8O1UJR9LDaZBuQsI2la5q+zlEZyztW5sx2Wx+NMdhBc9gAhuSb3gBy8CEUX4ARl
         6ar5ijA0cx4/6YdM8fD4zu6Aebodrv4je2oHAiLD2iNTEMFHfX2Pv94eAaoLYso99otE
         kWrgn82ZOdAaFDiveQrDPl15OUCv0oUQO1iFwCGA7Z7exvvQmj57D4/6vcKXGhwTsrqY
         2WQo8mmwOnO063WQpavPz1TaqwlUHp9K8ENvcyViWhaq2CEUKv0a3szx2Y+up56WY+Af
         UTZe4aHD0I/69sF6UtW/3tcryQ3WtajcqA3N6RTtY7EY9n1O2fyvoWh3E4kbIo7vIq7O
         z5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y3/hFW4GN16Be2yGUjLDnlYfrp+CPbxcc+i9fPNK43E=;
        b=LIg1XeGPV8sjfcdocFOtlAYCUyosHBBqkBFXLmKLbQ9Is2/zXLI3eCb5Xxf3/R6HBN
         /jFmZOAjKgOzfCD9cX2SeK+uKAy87ltAlSGZcvoJ3Bia7iay8K72ghozFHy9R1slixm7
         RkePqcBLPUiyD2dRvGKkh/7jYFLP/+Eq+NeNpXEqyi1KrHa+/xrbZtzIMVmfb8WjMoCk
         RgwFR3YHYNaRvHyAGalwLdBlOlEbQDFGGusPo1neohT/IsF3cfuhf962xKttBOcXASyb
         xpqdYf3NoBdr6GycBSq+7pkqg7g1if4gg5Sn7+0DmJJySgZ+ZcgrkWzotl09deFFA0k7
         DOag==
X-Gm-Message-State: AJcUukcVrMxRU5uKj3Khe2KMOWtoqId4xbEioG43KrKcnxKCdGANUgFm
        EBCkthxhdiegjmLKigvtMoLskrB1rFI=
X-Google-Smtp-Source: ALg8bN6/fE1pBB4x5lsJQNBvSoJqv/NDA2jumNX1pq3gXwgG1PvuqHvWHk+5WoICBKCGY81HsgwSBQ==
X-Received: by 2002:a5d:6988:: with SMTP id g8mr22732877wru.33.1547982929058;
        Sun, 20 Jan 2019 03:15:29 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id n11sm28281796wrw.60.2019.01.20.03.15.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 03:15:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 0/6] Support for source change in m2m decoder
Date:   Sun, 20 Jan 2019 03:15:14 -0800
Message-Id: <20190120111520.114305-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

1. The first patch "Add support for crop and compose selection in streaming"
was already reviewed.
2. The actual support is added in the patch
"Add support for source change event for m2m decoder"
3. The last patch is only a suggestion for adding a new option
in the command line.

Dafna Hirschfeld (6):
  v4l2-ctl: Add support for crop and compose selection in streaming
  v4l2-ctl: Add function get_codec_type
  v4l2-ctl: test the excpetion fds first in streaming_set_m2m
  v4l2-ctl: Introduce capture_setup
  v4l2-ctl: Add support for source change event for m2m decoder
  v4l2-ctl: Add --stream-pixformat option

 utils/common/codec-fwht.patch         |   8 +-
 utils/common/v4l-stream.c             |  14 +-
 utils/common/v4l-stream.h             |   6 +-
 utils/qvidcap/capture.cpp             |   2 +
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 372 +++++++++++++++++++++++---
 utils/v4l2-ctl/v4l2-ctl.cpp           |  39 ++-
 utils/v4l2-ctl/v4l2-ctl.h             |   2 +
 7 files changed, 384 insertions(+), 59 deletions(-)

-- 
2.17.1


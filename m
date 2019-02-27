Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90976C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 07:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B04721852
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 07:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u8ITt8Mz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbfB0HIJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:08:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45289 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfB0HIJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 02:08:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id w17so16597970wrn.12
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 23:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vIEG65mmeyQkvJxh9LNg6RgDvgb+0tK2w+H0RkU86eY=;
        b=u8ITt8MznoiQuN87ZEJxCXTOlePI3jjoNQuzlXsS3oJdcZhuMTrBrfrLgykj27szEN
         ZfLCf4IgnYRKhrBEsS4tlf5fDsN998irOUSHRlxWvsLaCk9kKi3mt3uHLFWgb8AG0daG
         ZCy1xiNMv5fHqLyBid70DEgzDx3mnMavJQRZEnTqaaXxzMs64+3vOTNL2+uPm9RGz+Cb
         NXSUo3PUgUBVbdAnu4nhrjA5lxtlF6PSjczc3E2l1HnF67qEn4Y2B7psRfvj6KciXivP
         C4aYrQmTzpiqGGDZKD9CnH6qrcEVipGxqvr3oBa9/53AE2ptKQ8WFtau8Z8VgebGyLHZ
         pRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vIEG65mmeyQkvJxh9LNg6RgDvgb+0tK2w+H0RkU86eY=;
        b=Igte+ifqJp0UAex2Yfpuem21+QemF2SIYf6e0/lEeuFY68RR8UMryChz68iYeij4y8
         nsbAZrCSCPD8g90MD8poZNHqp383BtmPPjX0YnWnWMkoUXdU1ie5eow/sj2bqxNGMNzM
         KRk3uv6aB+/a/0WuQO5RJwGbivlOHKCCXU5ttkjf6SsSwH8/208BDipKH0OFvwsUHc5+
         s65sn88mCrvLnco5EY4TvW7Bb375oeYTDlh+x6eL8pub9KCfgedTomebvOStjRVdP8vs
         wqsHcHkUbiqcWsUBQ0FANTG84Z6Nd/Ogn0VvFtSxpYemZpoBQ3MyRIduUvWEWKH3URKq
         YIGg==
X-Gm-Message-State: APjAAAWxBFugdRKMmxYolro1pHDwT5Dbqv1MLELAzfzjEwC633RwJU0w
        b12tYpB6b58lvnhdmbOFaBFt1bZNeOU=
X-Google-Smtp-Source: APXvYqzXvhH7OtoWk2ImzBqmsT5E0hpz3N7HHiLu0s/aN+oO4m4L/ViPv3Ky06d/yzKI/s9cDdBwBQ==
X-Received: by 2002:adf:e385:: with SMTP id e5mr1154724wrm.267.1551251287316;
        Tue, 26 Feb 2019 23:08:07 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id i10sm41984852wrx.54.2019.02.26.23.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 23:08:06 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 0/3] stateless decoder implementation
Date:   Tue, 26 Feb 2019 23:07:54 -0800
Message-Id: <20190227070757.25092-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

changes from v4: remove comp_frame_size from fwht params

Dafna Hirschfeld (3):
  v4l-utils: copy fwht-ctrls.h from kernel dir
  v4l2-ctl: Add functions and variables to support fwht stateless
    decoder
  v4l2-ctl: Add implementation for the stateless fwht decoder.

 Makefile.am                           |   1 +
 utils/common/codec-fwht.patch         |   7 +-
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 363 +++++++++++++++++++++++++-
 3 files changed, 365 insertions(+), 6 deletions(-)

-- 
2.17.1


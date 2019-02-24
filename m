Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F459C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD101206BA
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0S0/NHM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfBXIlp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43049 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbfBXIlo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id d17so6611560wre.10
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=o8JGeHtWQV9JEjftL+iLEJJLAgHHBN9ingw2lVmwKVc=;
        b=A0S0/NHMkRsbYTtk0ceFQ4Ingromkh5WFqTiQjBvISNkwKSptvCQfdskNgJbbsSlAS
         OsNqKPavgGjHEf/7x9Xwf0n2bvoLYy4fWXThA49sYJtBheGsDjnQzrIFcKObuRgVS5u0
         yvs2CZKowvmSmcEBibTHJ7LyKvjWTMr/uOsqQHlbj3+aG7c9dzgaLwfDBVYHKgVNk5uw
         hM3yqsIK/UFak+QuVYBMCy2AMLZWCnv62ENTrd9VTlEXkpfQk9GQIFbJZOIocfHg5Om8
         duuMKnG9IxYtcX/NtuiEEIw8e0VxMLvjxRgphcWo5N9t4Vp8wSCcXrJwu+MOt309tQPy
         S50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o8JGeHtWQV9JEjftL+iLEJJLAgHHBN9ingw2lVmwKVc=;
        b=n08YBCLgCSPIJo5k1vrhU5u4L9j1mTe8/kfs4InqwK4iGxX02sneuZc7p8v4KmYxhV
         deJeQl4ego6pDkPv45D7TmDDuAt7aUvXRqA2cfD7Clj7IyXeY5v+B4Y3zhB+M3sA38cE
         xOyZUVdkQerTwIHj5F/srADtd2wSwRlQYWUhWbqZjdeXk+bNSdVOYGmNcgAOf05/3Wf0
         Zyzh4oktUmgI6HKuS6nXeCrzSoRactLAydi5+GEvXk866PyIBMPIPJUVwkcHyyGSJRti
         26g5pvNcGGPnZ+Z8dQDYBP4dBgC5MfUpZC8wCbCdcBMQKNEIxEJuj8wtC7Zir9ayMr3L
         XD/g==
X-Gm-Message-State: AHQUAuZu8T7ufejuZThFVk7hpnxgYPKa6bOiKRgf9r6HFUq+x7BCYPOq
        9DF759eNNfBC+Ext1r1VAM1s2Mf37lk=
X-Google-Smtp-Source: AHgI3Ia9uceaM0EZgzVFQuCu0NmEpfmOYFkH2EjmRAoEHJgGf/LE1ZoEush5XYjbzTUmLpeXbsEGqQ==
X-Received: by 2002:a5d:4686:: with SMTP id u6mr9014824wrq.206.1550997702668;
        Sun, 24 Feb 2019 00:41:42 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:41 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 0/8] add support to stateless decoder
Date:   Sun, 24 Feb 2019 00:41:18 -0800
Message-Id: <20190224084126.19412-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from v2:
patches 1,2,3,6 are new

Dafna Hirschfeld (8):
  v4l2-ctl: rename variable 'vic_fmt' to 'info'
  v4l2-ctl: bugfix: correctly read/write V4L2_PIX_FMT_NV24 padded buffer
  v4l2-ctl: test if do_setup_out_buffers returns -1 instead of non zero
  v4l2-ctl: move stateful m2m decode code to a separate function
  (c)v4l-helpers.h: Add support for the request api
  v4l-utils: copy fwht-ctrls.h from kernel dir
  v4l2-ctl: Add functions and variables to support fwht stateless
    decoder
  v4l2-ctl: Add implementation for the stateless fwht decoder.

 Makefile.am                           |   1 +
 utils/common/codec-fwht.patch         |   7 +-
 utils/common/cv4l-helpers.h           |   5 +
 utils/common/v4l-helpers.h            |  22 ++
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 482 ++++++++++++++++++++++----
 5 files changed, 455 insertions(+), 62 deletions(-)

-- 
2.17.1


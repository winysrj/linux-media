Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1E2C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 02:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF57C21900
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 02:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyZOZBKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfCVCvm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:51:42 -0400
Received: from mail-oi1-f202.google.com ([209.85.167.202]:48188 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfCVCvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 22:51:42 -0400
Received: by mail-oi1-f202.google.com with SMTP id p65so290553oib.15
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 19:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=j6/zuEG9+UIoYtW3U8W38qtzXfAkrhIL3/LLIBR4owU=;
        b=CyZOZBKPDThABvx4++PnjHBTyqsppM84QY45Tnfnue0M8+GlxUPCJ79DSuuZlIa24m
         /B6buINPT9/NDdN1cKcXus11GaqkiGhLBR3dXaf944zkSxqThK6hizYJFd32dB/Ewl8K
         Me97HW2Lf04EpNsbDyZPBga+X6bh5HRO2gG5T51eSn8Pwt0Fr24KEaMbv2+KKk92UfFB
         rReKWpgzDflXq8k2q2kDDRqS4/gwBtMALyl0fdKsa8kFAg1OasszIkRnAUQmiN93yWpM
         zMRHSczIX52FIX6SNRrqq+SegHURODWoSbSRhHPEOgFEPW3qjcJugYQUNf2he7tgnV1B
         9Nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=j6/zuEG9+UIoYtW3U8W38qtzXfAkrhIL3/LLIBR4owU=;
        b=FUxgvBJqozvG3Vrajl/O+C201yjDWee+873zVVbDFFmu0w1E0Tfy8z0NcyoS0q7NbG
         EPvaDbJ/ozWPVAubgb1G/XsW/bqdSFCyjFkvjak5PdR7X2bIEKuBRE/B3FPcrwjNtbOG
         +J0qXwIvQt7jJA2/M7IRi11dQwX2NKapjSgHdC3KXntqjv60xWgD4kCxgxVdlA/mTnxv
         spBnea7cJTPGGUxs4WCjGOOg4KKe+sY2oHfCti5SQHpOHjW2zE9UvHJuXQQqSIEbDI8x
         HFYWEQpfayzBfPO+a7ccwAoEeIhkA5MA9hUrsW4oFPDeiyxA0xsSKW4iT0hIzfxCoksN
         r7hw==
X-Gm-Message-State: APjAAAUmI/o3PnOq0cyk8ByhN9GdHlFLUlr/BZKs1uukdiU+/mjB2a7h
        xWy8bmMcywx04ySd0HZ8+qwsu52ekQ==
X-Google-Smtp-Source: APXvYqw9AFAovTG2lUrSPz11W4tKtJy9FEWIHiePCdq8Y3/EOtzqPeSiAwwQRVBroISNRkeegVOmNdGhhg==
X-Received: by 2002:aca:b683:: with SMTP id g125mr337075oif.17.1553223101756;
 Thu, 21 Mar 2019 19:51:41 -0700 (PDT)
Date:   Thu, 21 Mar 2019 19:51:32 -0700
Message-Id: <20190322025135.118201-1-fengc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [RFC v2 dma-buf 0/3] Improve the dma-buf tracking
From:   Chenbo Feng <fengc@google.com>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Cc:     kernel-team@android.com, Sumit Semwal <sumit.semwal@linaro.org>,
        erickreyes@google.com, Daniel Vetter <daniel@ffwll.ch>,
        Chenbo Feng <fengc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently, all dma-bufs share the same anonymous inode. While we can count
how many dma-buf fds or mappings a process has, we can't get the size of
the backing buffers or tell if two entries point to the same dma-buf. And
in debugfs, we can get a per-buffer breakdown of size and reference count,
but can't tell which processes are actually holding the references to each
buffer.

To resolve the issue above and provide better method for userspace to track
the dma-buf usage across different processes, the following changes are
proposed in dma-buf kernel side. First of all, replace the singleton inode
inside the dma-buf subsystem with a mini-filesystem, and assign each
dma-buf a unique inode out of this filesystem.  With this change, calling
stat(2) on each entry gives the caller a unique ID (st_ino), the buffer's
size (st_size), and even the number of pages assigned to each dma-buffer.
Secoundly, add the inode information to /sys/kernel/debug/dma_buf/bufinfo
so in the case where a buffer is mmap()ed into a process=E2=80=99s address =
space
but all remaining fds have been closed, we can still get the dma-buf
information and try to accociate it with the process by searching the
proc/pid/maps and looking for the corresponding inode number exposed in
dma-buf debug fs. Thirdly, created an ioctl to assign names to dma-bufs
which lets userspace assign short names (e.g., "CAMERA") to buffers. This
information can be extremely helpful for tracking and accounting shared
buffers based on their usage and original purpose. Last but not least, add
dma-buf information to /proc/pid/fdinfo by adding a show_fdinfo() handler
to dma_buf_file_operations. The handler will print the file_count and name
of each buffer.

Change in v2:
* Add a check to prevent changing dma-buf name when it is attached to
  devices.
* Fixed some compile warnings

Greg Hackmann (3):
  dma-buf: give each buffer a full-fledged inode
  dma-buf: add DMA_BUF_{GET,SET}_NAME ioctls
  dma-buf: add show_fdinfo handler

 drivers/dma-buf/dma-buf.c    | 121 ++++++++++++++++++++++++++++++++---
 include/linux/dma-buf.h      |   5 +-
 include/uapi/linux/dma-buf.h |   4 ++
 include/uapi/linux/magic.h   |   1 +
 4 files changed, 122 insertions(+), 9 deletions(-)

--=20
2.21.0.rc2.261.ga7da99ff1b-goog


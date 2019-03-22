Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B802C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 12:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A4B82070D
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 12:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="ftE8tYFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390769AbfCVM3x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:29:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36259 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390651AbfCVM3u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 08:29:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id r124so1443019pgr.3
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 05:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=/o8b/zZ6NprDWsXSmkG/SfqSy1qZBYXQNf6+um0F+b0=;
        b=ftE8tYFtQBBQie92Bv7tAu5aO2BAglFveBV9KL1w0tmXALkual8bgm/j3I5bl5wZ+e
         /0Qng0kJxIyVq8dGQItia2U0CF8wmr5UcTkhDgm16iEh2tbyu1JMIwH9ooKV0KmoZdpM
         ijfG6YnRMhg3QwvE4Wbv4i/ZnLngj+ZHotkEM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/o8b/zZ6NprDWsXSmkG/SfqSy1qZBYXQNf6+um0F+b0=;
        b=VpGA3Mc7Hs8AF+7UQs//duepo65IsPi0jDppolAFhpxrJBNDTxkF+PlRXn8sXPBLTh
         QCOaZdi1b5JZ/0kMpkRf9OF+nTmzaqJ/dsA6r6LDkYxn3rU7GHnoqprxYwanMV82OA+L
         w0e+YMVnq9fQoPXRejqy76m2zHHYJssNvaA4wy5I0JfW8lbsPhKbU/8ysuCR3trFaqqe
         EekOWYuOsvRnrF9SH5QY9z0a2waruiI9T84RCDEeXiGFV/c3MC46lOvzqU8jJp2ZpmEg
         P2ySKbxJgFisz8q2SeMC2yfPKmlmlBltIa9azEqYTMdIQodf+RRpEw9oIeGPZwc0v4m2
         8lHA==
X-Gm-Message-State: APjAAAW7uW6u4gHkfxFvKxbIF7dpUfOhGEvhq1BD7JFRq3mwFLe6AT/k
        MJrcwNO7pJgJBROZxuwFl8kkrw==
X-Google-Smtp-Source: APXvYqzsqtygRG9T2ppku3CZdV3yO3VQ78upwJuoSfMu+dwD0/EKHp0AZWxY4h53CfoWCXvdUyGWew==
X-Received: by 2002:a63:ed53:: with SMTP id m19mr8620860pgk.78.1553257789257;
        Fri, 22 Mar 2019 05:29:49 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id e22sm10014783pfi.126.2019.03.22.05.29.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 05:29:48 -0700 (PDT)
Date:   Fri, 22 Mar 2019 08:29:47 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Chenbo Feng <fengc@google.com>
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, kernel-team@android.com,
        Sumit Semwal <sumit.semwal@linaro.org>, erickreyes@google.com,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFC v2 dma-buf 0/3] Improve the dma-buf tracking
Message-ID: <20190322122947.GA47151@google.com>
References: <20190322025135.118201-1-fengc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190322025135.118201-1-fengc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 21, 2019 at 07:51:32PM -0700, Chenbo Feng wrote:
> Currently, all dma-bufs share the same anonymous inode. While we can count
> how many dma-buf fds or mappings a process has, we can't get the size of
> the backing buffers or tell if two entries point to the same dma-buf. And
> in debugfs, we can get a per-buffer breakdown of size and reference count,
> but can't tell which processes are actually holding the references to each
> buffer.
> 
> To resolve the issue above and provide better method for userspace to track
> the dma-buf usage across different processes, the following changes are
> proposed in dma-buf kernel side. First of all, replace the singleton inode
> inside the dma-buf subsystem with a mini-filesystem, and assign each
> dma-buf a unique inode out of this filesystem.  With this change, calling
> stat(2) on each entry gives the caller a unique ID (st_ino), the buffer's
> size (st_size), and even the number of pages assigned to each dma-buffer.
> Secoundly, add the inode information to /sys/kernel/debug/dma_buf/bufinfo
> so in the case where a buffer is mmap()ed into a process’s address space

Is there a better place to add bufinfo than debugfs, since debugfs is not
something Android may mount for non-debug uses in the future?

> but all remaining fds have been closed, we can still get the dma-buf
> information and try to accociate it with the process by searching the
> proc/pid/maps and looking for the corresponding inode number exposed in
> dma-buf debug fs. Thirdly, created an ioctl to assign names to dma-bufs
> which lets userspace assign short names (e.g., "CAMERA") to buffers. This
> information can be extremely helpful for tracking and accounting shared
> buffers based on their usage and original purpose. Last but not least, add
> dma-buf information to /proc/pid/fdinfo by adding a show_fdinfo() handler
> to dma_buf_file_operations. The handler will print the file_count and name
> of each buffer.

There are a couple more entries shown in fdinfo per patch 3/3 so it is worth
mentioning those here as well.

Also, is there kselftests to add or modify? I suggest we add those since they
are always invaluable.

I'll review more soon. Currently traveling. I am especially curious how you
created the new inodes since I recently had to do so for another usecase as
well. thanks!

 - Joel

> 
> Change in v2:
> * Add a check to prevent changing dma-buf name when it is attached to
>   devices.
> * Fixed some compile warnings
> 
> Greg Hackmann (3):
>   dma-buf: give each buffer a full-fledged inode
>   dma-buf: add DMA_BUF_{GET,SET}_NAME ioctls
>   dma-buf: add show_fdinfo handler
> 
>  drivers/dma-buf/dma-buf.c    | 121 ++++++++++++++++++++++++++++++++---
>  include/linux/dma-buf.h      |   5 +-
>  include/uapi/linux/dma-buf.h |   4 ++
>  include/uapi/linux/magic.h   |   1 +
>  4 files changed, 122 insertions(+), 9 deletions(-)
> 
> -- 
> 2.21.0.rc2.261.ga7da99ff1b-goog
> 

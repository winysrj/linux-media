Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFD5C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 01:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B3A21873
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 01:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uhgfdHQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfCOBuy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 21:50:54 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33398 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfCOBux (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 21:50:53 -0400
Received: by mail-lj1-f193.google.com with SMTP id z7so6555557lji.0
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2019 18:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j+EKE+JvaEx6WP8A7cFB62QmIXFykKUTN5Lyz0yPMTs=;
        b=uhgfdHQW/0lCQXPyiXhrb8qnM2uL4GV6kj0k1z+cqrZBmgRmrX+szBD5IGwzzwg0Dj
         ylCm/zecxSZToVaXVBRW1vS8kho0lc+ezsN+UC1T9eeWz1hm8s4iq4j7/rveOC+anxuZ
         CvKfGqq1xCOOvqBIEZ51TInasvzAsxT9dEQ59m2MRd0lYioHI88u/e1ZtMLxixCjSJHo
         HGPdLCkH9vSf2/Ti77TdK10fsL3IEIjOYi5a0HTSeE/XIA8gkvRzRXArVGdiqf1kmy0g
         JYcNusXEHuderXAfThoiSN8kAjvmsHMqxMq6hYQMnAvcwu8Yje2w3S2IGaNJQq0KbVs7
         tsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j+EKE+JvaEx6WP8A7cFB62QmIXFykKUTN5Lyz0yPMTs=;
        b=END9ewGdH0A8fEr6TKzskUrEg6uiNLgtU+xtPT2jExSLT09nBSmzMaXTJfxXDmxbaL
         PvT2DHgqMZBQVgxgolw9rXOCDxBBjPO8IxH8pWiABT92/AVQIs2350B4qufsMWa1cm65
         RXqfoAa9DNnwqpJCaixj1ResHpFSYyQUD1jBL1kK+LQ8Nd2ONngILKJzWNjXJdA5szIN
         ND/vLE2ViHvIku0wmoJw5XgaiTDHClSFlvxSIOpAMU+C9vM8E+PZuMh+FvLnctR6e0jO
         zRkPFbCx7xMnpT5PqltBvYL28u7Rcxv61H6N7dcHR1pH8vJuvajkBb6LZ6CKddZw19wn
         0WjQ==
X-Gm-Message-State: APjAAAV8dUUqTTlPQrFj3TpL1DY16JaspIr5qQ+Erc/GcwnE9m3HXHZl
        DOxeR4MrL6HtciOil8jdFtwMFMMkOQaKS3+02PFgBg==
X-Google-Smtp-Source: APXvYqzZUMnyKgJTSmKY+4z5LkK3GWu47MnckgjpVadGy/s9ZKdlw/iQ4jUybICb39RfY+qKbC1oQRS6ri2V+RO5tzs=
X-Received: by 2002:a2e:1510:: with SMTP id s16mr595740ljd.62.1552614651111;
 Thu, 14 Mar 2019 18:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190227035448.117169-1-fengc@google.com> <CAO_48GG0sW3AJNVJnydjuWUQHcmWe5aQrB=X0Wo7uBtDnPtoYg@mail.gmail.com>
In-Reply-To: <CAO_48GG0sW3AJNVJnydjuWUQHcmWe5aQrB=X0Wo7uBtDnPtoYg@mail.gmail.com>
From:   Chenbo Feng <fengc@google.com>
Date:   Thu, 14 Mar 2019 18:50:40 -0700
Message-ID: <CAMOXUJmmmvaD7A5taHgsUnt=7RxvbpdnYwqTDun6K42kVHCxhQ@mail.gmail.com>
Subject: Re: [RFC dma-buf 0/3] Improve the dma-buf tracking
To:     Sumit Semwal <sumit.semwal@linaro.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, Erick Reyes <erickreyes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 14, 2019 at 10:49 AM Sumit Semwal <sumit.semwal@linaro.org> wro=
te:
>
> Hello Chenbo,Thank you for your RFC series.
>
> On Wed, 27 Feb 2019 at 09:24, Chenbo Feng <fengc@google.com> wrote:
> >
> > Currently, all dma-bufs share the same anonymous inode. While we can co=
unt
> > how many dma-buf fds or mappings a process has, we can't get the size o=
f
> > the backing buffers or tell if two entries point to the same dma-buf. A=
nd
> > in debugfs, we can get a per-buffer breakdown of size and reference cou=
nt,
> > but can't tell which processes are actually holding the references to e=
ach
> > buffer.
> >
> > To resolve the issue above and provide better method for userspace to t=
rack
> > the dma-buf usage across different processes, the following changes are
> > proposed in dma-buf kernel side. First of all, replace the singleton in=
ode
> > inside the dma-buf subsystem with a mini-filesystem, and assign each
> > dma-buf a unique inode out of this filesystem.  With this change, calli=
ng
> > stat(2) on each entry gives the caller a unique ID (st_ino), the buffer=
's
> > size (st_size), and even the number of pages assigned to each dma-buffe=
r.
> > Secoundly, add the inode information to /sys/kernel/debug/dma_buf/bufin=
fo
> > so in the case where a buffer is mmap()ed into a process=E2=80=99s addr=
ess space
> > but all remaining fds have been closed, we can still get the dma-buf
> > information and try to accociate it with the process by searching the
> > proc/pid/maps and looking for the corresponding inode number exposed in
> > dma-buf debug fs. Thirdly, created an ioctl to assign names to dma-bufs
> > which lets userspace assign short names (e.g., "CAMERA") to buffers. Th=
is
> > information can be extremely helpful for tracking and accounting shared
> > buffers based on their usage and original purpose. Last but not least, =
add
> > dma-buf information to /proc/pid/fdinfo by adding a show_fdinfo() handl=
er
> > to dma_buf_file_operations. The handler will print the file_count and n=
ame
> > of each buffer.
>
> In general, I think I like the idea as it contributes to a much more
> relevant usage analysis of dma-buf backed buffers.
> I will get to doing a more detailed review soon, but immediately, we
> might want to think a bit about the get/set_name IOCTLS - do we need
> to think of disallowing multiple renaming of buffers once they start
> getting used? It could otherwise make the whole metrics a lot
> confused?
Yes, I agree we need to control the dma-buf naming to make sure it
doesn't confuse the user. Ideally the process asked for dma-buf need
to make sure they only set the name once when they are using the
buffer for the same purpose. But I guess we can add check in kernel
side to make sure the name only get initialized once and can never
change after it. Or do we have better way to disallow multiple
renaming of buffers once they start getting used? Can we find a way to
set the name information in dma_buf_export so no one can change it
after that?
>
> >
> > Greg Hackmann (3):
> >   dma-buf: give each buffer a full-fledged inode
> >   dma-buf: add DMA_BUF_{GET,SET}_NAME ioctls
> >   dma-buf: add show_fdinfo handler
> >
> >  drivers/dma-buf/dma-buf.c    | 121 ++++++++++++++++++++++++++++++++---
> >  include/linux/dma-buf.h      |   5 +-
> >  include/uapi/linux/dma-buf.h |   4 ++
> >  include/uapi/linux/magic.h   |   1 +
> >  4 files changed, 122 insertions(+), 9 deletions(-)
> >
> > --
> > 2.21.0.rc2.261.ga7da99ff1b-goog
> >
>
> Best,
> Sumit.

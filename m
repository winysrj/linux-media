Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AA1C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 17:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D074218A1
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 17:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z4Filnma"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfCNRtT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 13:49:19 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38753 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfCNRtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 13:49:18 -0400
Received: by mail-ot1-f68.google.com with SMTP id e80so776150ote.5
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2019 10:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7QeesPBLVC4Xvhqsvje2fdOGstxWInZX/y0Xrblk/lI=;
        b=Z4FilnmaoC0PufNfruldxw5igd6C4XDa/FOoEve6mdpYGblElx6ydzZDxg4RqIR9Gf
         2E7lZlZ3sVy8YawqgimGeS1LrBPV1NAuigwiAnhUpn8S14ctJc0/WT5lB+++wHch1J00
         MIQHLFs94TTzY6LslQO+98zz7Q6O+KCYB3SViKgFYtPu/svYHFtSFcexXqPilMNx5xuj
         DBa09dd0thbr897DRNt9LJKRljVK36DCcMjJVLYskNB+zszmlxqhmOWCW0bunF6RQ9mg
         okrCyz2XDQznUBDlEgtSew2vATKJPm0y8axW59QvW5Jm7ElOh11/LyLA37lfE4F3oGB6
         BWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7QeesPBLVC4Xvhqsvje2fdOGstxWInZX/y0Xrblk/lI=;
        b=uQTDY3QcYPQwI680ZJAPzC+myRjMYHNDkko+nnzZN9Dx6wzlSJC4No5lkcpqO0kt32
         9tAaRKH1wbKw6xUqU1KrK3MBve2lJirclEj4upsTo3Oz/wRSor+Q40Y0il63PF2hHwqA
         omDL9pvpswyNt7BXQzUC0YmvzcKN2dbYTBiErUJnURnVH1/SwT6LLC1riDNqjHHc+TxO
         2BPpnSehFZFY6koipNmy9Uogxm8vKqEWjN53cNanT6bG2Vru7ST99N5wX0aALdhR4zhl
         Zpm8MHQ9BssqiZ9X1zuDPpKTQXTp/BuAAYM9FtVh9fOjIvO2xKbswsCaSm7KS4SRGyY2
         BbCg==
X-Gm-Message-State: APjAAAXgMZ0S0GEJsYWKpka7bOaSsIoFYKP/TSh5tUkCO86PB4NwYMqg
        COFJycY5S7cdyIjNr3ElGGxWgtUH5qIbFdf7m7WudA==
X-Google-Smtp-Source: APXvYqypN5gRTVXMBasPnYVXvqpdTgnEHZyxkOD4BvffdxS744MKMbHgfTQaH8osoGbqSyjY4jJrJiyuH3VG0QZeiZs=
X-Received: by 2002:a05:6830:1493:: with SMTP id s19mr32952288otq.117.1552585757971;
 Thu, 14 Mar 2019 10:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190227035448.117169-1-fengc@google.com>
In-Reply-To: <20190227035448.117169-1-fengc@google.com>
From:   Sumit Semwal <sumit.semwal@linaro.org>
Date:   Thu, 14 Mar 2019 23:19:06 +0530
Message-ID: <CAO_48GG0sW3AJNVJnydjuWUQHcmWe5aQrB=X0Wo7uBtDnPtoYg@mail.gmail.com>
Subject: Re: [RFC dma-buf 0/3] Improve the dma-buf tracking
To:     Chenbo Feng <fengc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, erickreyes@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Chenbo,Thank you for your RFC series.

On Wed, 27 Feb 2019 at 09:24, Chenbo Feng <fengc@google.com> wrote:
>
> Currently, all dma-bufs share the same anonymous inode. While we can coun=
t
> how many dma-buf fds or mappings a process has, we can't get the size of
> the backing buffers or tell if two entries point to the same dma-buf. And
> in debugfs, we can get a per-buffer breakdown of size and reference count=
,
> but can't tell which processes are actually holding the references to eac=
h
> buffer.
>
> To resolve the issue above and provide better method for userspace to tra=
ck
> the dma-buf usage across different processes, the following changes are
> proposed in dma-buf kernel side. First of all, replace the singleton inod=
e
> inside the dma-buf subsystem with a mini-filesystem, and assign each
> dma-buf a unique inode out of this filesystem.  With this change, calling
> stat(2) on each entry gives the caller a unique ID (st_ino), the buffer's
> size (st_size), and even the number of pages assigned to each dma-buffer.
> Secoundly, add the inode information to /sys/kernel/debug/dma_buf/bufinfo
> so in the case where a buffer is mmap()ed into a process=E2=80=99s addres=
s space
> but all remaining fds have been closed, we can still get the dma-buf
> information and try to accociate it with the process by searching the
> proc/pid/maps and looking for the corresponding inode number exposed in
> dma-buf debug fs. Thirdly, created an ioctl to assign names to dma-bufs
> which lets userspace assign short names (e.g., "CAMERA") to buffers. This
> information can be extremely helpful for tracking and accounting shared
> buffers based on their usage and original purpose. Last but not least, ad=
d
> dma-buf information to /proc/pid/fdinfo by adding a show_fdinfo() handler
> to dma_buf_file_operations. The handler will print the file_count and nam=
e
> of each buffer.

In general, I think I like the idea as it contributes to a much more
relevant usage analysis of dma-buf backed buffers.
I will get to doing a more detailed review soon, but immediately, we
might want to think a bit about the get/set_name IOCTLS - do we need
to think of disallowing multiple renaming of buffers once they start
getting used? It could otherwise make the whole metrics a lot
confused?

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

Best,
Sumit.

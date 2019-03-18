Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42724C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 16:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1034A20863
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 16:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o3oDtvf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfCRQRZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:17:25 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42342 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfCRQRZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 12:17:25 -0400
Received: by mail-ot1-f66.google.com with SMTP id i5so14920790oto.9
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 09:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oM7GzbsX6BXcI27/2wLinFMr6i84e0pxvUNOIyDhlk0=;
        b=o3oDtvf83CZqt6RoVFvrJgraX8zxwpQgZl+XhQPBpdYxqIkuyS3O7M3v0h9IIPBKeO
         M47sODs4f9Ip2rzcYcApveumryjwS9D5bHyRsCoG/zXCCJYE0f4+qJYaBA7yXjTNFiCO
         JaQ6gkufwIVfhdlVoPmPj3frnaaJ5D3NSs7y2lJNry1FNoYAqpXIJ93j/EGysQn2gf5p
         rDeOkK5vVKPraqRYnzkVmpiY5upB13Il0JAgrL/ZYyLZTRXsn+sub9te1ae2jJtOrc/T
         KLdj1Yb0toMkewPetvXS7pl9LM4blWJZtD1TzYtRH6+fzPuGV447TVdXQDY22uKWzdPE
         jgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oM7GzbsX6BXcI27/2wLinFMr6i84e0pxvUNOIyDhlk0=;
        b=epuaUAtKP23rwXHWYSX700CIvMtWDEP2pss84AwxMQpNPSkm7NGOfMUlZ6MEE7UaRa
         WAZj7bf0ScTLqATAKU5j2i8U3HR6aUe3ObkPgW+ELmEEciNfeuDaSvUGlRfCLCoPyHH3
         tFpBLtBu3L91zMMyw1CULnwr9GQ1M9WKOyp7hZU4n0tXsqrKHpVpwD+NuXxL3U9+PLCH
         OkVFW3ElQdQYxct3Xi84qkUNnK5T3zP/8DtqWkiOnF8BcB4jKaMJCDexh9Civ340YUql
         Oo71t50hNzjpiTDu0xK6QER/fxPU0wSBxNyxuwn9H+5vJt/Txbzrn0gLjiu1TlsBP6/J
         I9jA==
X-Gm-Message-State: APjAAAVqcp1qnakZqQTTvNfubSpem+LmFgTh3PScr+td4FDkTKSqgtG9
        3HquEwyKUi+KC+33cjZte3q8pgnZUHvyS8yaBJTLRA==
X-Google-Smtp-Source: APXvYqwO79bnTJ4TBihYvcX0tGkp8ZdflSJz70skZwufx+hdRQ6m22JE43NhjES2ILh5jqqFVSFPSEDcEnYsaPX7NPQ=
X-Received: by 2002:a9d:ef4:: with SMTP id 107mr2959918otj.152.1552925844096;
 Mon, 18 Mar 2019 09:17:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190227035448.117169-1-fengc@google.com> <CAO_48GG0sW3AJNVJnydjuWUQHcmWe5aQrB=X0Wo7uBtDnPtoYg@mail.gmail.com>
 <CAKMK7uFMj7wQQ7hVubXgbP61gmAE3zGcNQyDW5gexZO75z4sDw@mail.gmail.com>
In-Reply-To: <CAKMK7uFMj7wQQ7hVubXgbP61gmAE3zGcNQyDW5gexZO75z4sDw@mail.gmail.com>
From:   Sumit Semwal <sumit.semwal@linaro.org>
Date:   Mon, 18 Mar 2019 21:47:12 +0530
Message-ID: <CAO_48GEFz99yL34NSB5TCrg1S0X00Z_UysoFugozGK3aEazGig@mail.gmail.com>
Subject: Re: [RFC dma-buf 0/3] Improve the dma-buf tracking
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Chenbo Feng <fengc@google.com>, erickreyes@google.com,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daniel,

On Fri, 15 Mar 2019 at 16:36, Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Thu, Mar 14, 2019 at 6:49 PM Sumit Semwal <sumit.semwal@linaro.org> wr=
ote:
> >
> > Hello Chenbo,Thank you for your RFC series.
> >
> > On Wed, 27 Feb 2019 at 09:24, Chenbo Feng <fengc@google.com> wrote:
> > >
> > > Currently, all dma-bufs share the same anonymous inode. While we can =
count
> > > how many dma-buf fds or mappings a process has, we can't get the size=
 of
> > > the backing buffers or tell if two entries point to the same dma-buf.=
 And
> > > in debugfs, we can get a per-buffer breakdown of size and reference c=
ount,
> > > but can't tell which processes are actually holding the references to=
 each
> > > buffer.
> > >
> > > To resolve the issue above and provide better method for userspace to=
 track
> > > the dma-buf usage across different processes, the following changes a=
re
> > > proposed in dma-buf kernel side. First of all, replace the singleton =
inode
> > > inside the dma-buf subsystem with a mini-filesystem, and assign each
> > > dma-buf a unique inode out of this filesystem.  With this change, cal=
ling
> > > stat(2) on each entry gives the caller a unique ID (st_ino), the buff=
er's
> > > size (st_size), and even the number of pages assigned to each dma-buf=
fer.
> > > Secoundly, add the inode information to /sys/kernel/debug/dma_buf/buf=
info
> > > so in the case where a buffer is mmap()ed into a process=E2=80=99s ad=
dress space
> > > but all remaining fds have been closed, we can still get the dma-buf
> > > information and try to accociate it with the process by searching the
> > > proc/pid/maps and looking for the corresponding inode number exposed =
in
> > > dma-buf debug fs. Thirdly, created an ioctl to assign names to dma-bu=
fs
> > > which lets userspace assign short names (e.g., "CAMERA") to buffers. =
This
> > > information can be extremely helpful for tracking and accounting shar=
ed
> > > buffers based on their usage and original purpose. Last but not least=
, add
> > > dma-buf information to /proc/pid/fdinfo by adding a show_fdinfo() han=
dler
> > > to dma_buf_file_operations. The handler will print the file_count and=
 name
> > > of each buffer.
> >
> > In general, I think I like the idea as it contributes to a much more
> > relevant usage analysis of dma-buf backed buffers.
> > I will get to doing a more detailed review soon, but immediately, we
> > might want to think a bit about the get/set_name IOCTLS - do we need
> > to think of disallowing multiple renaming of buffers once they start
> > getting used? It could otherwise make the whole metrics a lot
> > confused?
> >
> > >
> > > Greg Hackmann (3):
> > >   dma-buf: give each buffer a full-fledged inode
> > >   dma-buf: add DMA_BUF_{GET,SET}_NAME ioctls
> > >   dma-buf: add show_fdinfo handler
>
> I'm not seeing the patches, so just quick comment here: Some drivers
> (at least vc4) already have the concept of buffer names. Would be neat
> to integrate this between dma-buf and drm_gem in prime.
>
FYI, here's the patch series - https://patchwork.freedesktop.org/series/572=
82/

Best,
Sumit.

> Aside from that sounds like a good idea overall, but I can't see any deta=
ils.
> -Daniel
>
> > >
> > >  drivers/dma-buf/dma-buf.c    | 121 ++++++++++++++++++++++++++++++++-=
--
> > >  include/linux/dma-buf.h      |   5 +-
> > >  include/uapi/linux/dma-buf.h |   4 ++
> > >  include/uapi/linux/magic.h   |   1 +
> > >  4 files changed, 122 insertions(+), 9 deletions(-)
> > >
> > > --
> > > 2.21.0.rc2.261.ga7da99ff1b-goog
> > >
> >
> > Best,
> > Sumit.
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



--=20
Thanks and regards,

Sumit Semwal
Linaro Consumer Group - Kernel Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs

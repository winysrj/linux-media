Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:33672 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3EPGlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 02:41:02 -0400
Received: by mail-we0-f169.google.com with SMTP id x54so2453150wes.28
        for <linux-media@vger.kernel.org>; Wed, 15 May 2013 23:41:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPrYoTGjMQtTu5VTTY802YaFy8-zR-aEd=27ZKqcF60FAsR-JA@mail.gmail.com>
References: <CAPrYoTGjMQtTu5VTTY802YaFy8-zR-aEd=27ZKqcF60FAsR-JA@mail.gmail.com>
Date: Thu, 16 May 2013 12:11:00 +0530
Message-ID: <CAK7N6vpEp6E5ekUeqyQbYhE75rqSU1JP6sjonTb575yqDkhNXw@mail.gmail.com>
Subject: Re: Doubt regarding DMA / VMALLOC memory ops
From: anish singh <anish198519851985@gmail.com>
To: Chetan Nanda <chetannanda@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 15, 2013 at 4:10 PM, Chetan Nanda <chetannanda@gmail.com> wrote:
> Hi,
>
> I am new to V4L2 kernel framework. And currently trying to understand V4L2
> kernel sub-system.
> In videobuf2 sub-system, before calling 'vb2_queue_init(q)',  q's mem_ops is
> being initialized (depending on type of buffer) as
>
> q->mem_ops = &vb2_vmalloc_memops;
> or
> q->mem_ops = &vb2_dma_contig_memops
These are just assigning function pointers to be called when we do
memory related operations.
>
> What is the purpose of these memory operations?
> If user space is allocating the buffer (physically contiguous) via some other
> kernel driver (hwmem - for android). Even then do we need to set mem_ops =
> vb2_dma_contig_memops?
I think what you are referring here is the ION/PMEM memory being assigned
by the user space in android.If the user space is assinging the memory
then VB2_MMAP | VB2_USERPTR will be used and this function pointer
mentioned by you earlier would not be same but it would be ION/PMEM related
callbacks.
Basically in the case of userptr the OEM's have a specific way of handling
contigiuos memory and is not covered by the generic VB2 code but managing
those contigious memory is covered by VB2.
VB2 provides all the callbacks using which you can write your own memory
management code.
>
>
> Thanks,
> Chetan Nanda
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

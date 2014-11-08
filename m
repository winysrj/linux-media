Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40270 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaKHKuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 05:50:14 -0500
Received: by mail-lb0-f177.google.com with SMTP id u10so603172lbd.8
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 02:50:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMm-=zA3gEPzLm+4krS1feT-xi69O9YFnuR=17FRaNhpyuOb4g@mail.gmail.com>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
 <1415350234-9826-5-git-send-email-hverkuil@xs4all.nl> <CAMm-=zA3gEPzLm+4krS1feT-xi69O9YFnuR=17FRaNhpyuOb4g@mail.gmail.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Sat, 8 Nov 2014 19:43:57 +0900
Message-ID: <CAMm-=zCxBwzwz8W=LaS-dgxYrmHWpT5LVN=FyNbfAVkiCzPjDA@mail.gmail.com>
Subject: Re: [RFCv5 PATCH 04/15] vb2-dma-sg: add dmabuf import support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 8, 2014 at 7:20 PM, Pawel Osciak <pawel@osciak.com> wrote:
> Hi Hans,
> Thank you for the patch.
>
> On Fri, Nov 7, 2014 at 5:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add support for dmabuf to vb2-dma-sg.
>
> importing dmabuf into videobuf2-dma-sg.
>

One thing I missed in the review, I think vb2_dma_sg_vaddr() needs to
be updated in this patch to take into account that we may have an
attachment present, just like it's done in dma-contig, i.e. if !vaddr
and attachment present, call the dma_buf_vmap() dmabuf op instead of
vm_map_ram.

-- 
Best regards,
Pawel Osciak

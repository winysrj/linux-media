Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34478 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753612AbdEIESn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 00:18:43 -0400
Received: by mail-wr0-f182.google.com with SMTP id l9so59317118wre.1
        for <linux-media@vger.kernel.org>; Mon, 08 May 2017 21:18:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
References: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 9 May 2017 09:48:21 +0530
Message-ID: <CAO_48GHLFWK0iwZdGgRMfYJefSGpX351Suj1KgFRH2E5+GPrBA@mail.gmail.com>
Subject: Re: [PATCH 0/4] DMA-buf: Fine-tuning for four function implementations
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Markus,

On 8 May 2017 at 14:40, SF Markus Elfring <elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 8 May 2017 11:05:05 +0200
>
> A few update suggestions were taken into account
> from static source code analysis.
>
> Markus Elfring (4):
>   Combine two function calls into one in dma_buf_debug_show()
>   Improve a size determination in dma_buf_attach()
>   Adjust a null pointer check in dma_buf_attach()
>   Use seq_putc() in two functions

All queued up in drm-misc-next now. Thanks!
>
>  drivers/dma-buf/dma-buf.c    | 8 +++-----
>  drivers/dma-buf/sync_debug.c | 6 +++---
>  2 files changed, 6 insertions(+), 8 deletions(-)
>
> --
> 2.12.2
>

Best regards,
Sumit.

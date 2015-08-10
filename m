Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34429 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbbHJQoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 12:44:34 -0400
Received: by iodb91 with SMTP id b91so115403086iod.1
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2015 09:44:34 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 10 Aug 2015 09:44:34 -0700
Message-ID: <CA+55aFzu_uZh1i1Wa1r0O2c-Gu6L7YsUEpSHo2xZgEC9bg9sFw@mail.gmail.com>
Subject: [FWD] PROBLEM: there exists a wrong return value of function mantis_dma_init()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?B?SmFuIEtsw7Z0emtl?= <jan@kloetzke.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It does seem like the error handling for mantis_dma_init() is insane..

                   Linus

On Sun, Aug 9, 2015 at 5:12 PM, RUC_Soft_Sec <zy900702@163.com> wrote:
> Summary:
>     there exists a wrong return value of function mantis_dma_init().It's a
> theoretical problem. we use static analysis method to detect this bug.
> Bug Description:
>
>    In function mantis_dma_init() at
> drivers/media/pci/mantis/mantis_dma.c：131, the call to
> mantis_alloc_buffers() in line 136 may return a negative error code, and
> thus function mantis_dma_init() will return the value of variable err. And,
> the function mantis_dma_init() will return 0 at last when it runs well.
> However, when the call to mantis_alloc_buffers() in line 136 return a
> negative error code, the value of err is 0. So the function
> mantis_dma_init() will return 0 to its caller functions when it runs error
> because of the failing call to mantis_alloc_buffers(), leading to a wrong
> return value of function mantis_dma_init().
> The related code snippets in mantis_dma_init() is as following.
> mantis_dma_init @@ drivers/media/pci/mantis/mantis_dma.c：131
>  131int mantis_dma_init(struct mantis_pci *mantis)
>  132{
>  133        int err = 0;
>  134
>  135        dprintk(MANTIS_DEBUG, 1, "Mantis DMA init");
>  136        if (mantis_alloc_buffers(mantis) < 0) {
>  137                dprintk(MANTIS_ERROR, 1, "Error allocating DMA buffer");
>  138
>  139                /* Stop RISC Engine */
>  140                mmwrite(0, MANTIS_DMA_CTL);
>  141
>  142                goto err;
>  143        }
>  144
>  145        return 0;
>  146err:
>  147        return err;
>  148}
>
> Moreover, in the caller function of mantis_dma_init() the return value will
> be checked if it is a negative number. Now, the return value of
> mantis_dma_init() is always 0 and the check is useless.
> The related code snippets in mantis_core_init() is as following.
>  137int mantis_core_init(struct mantis_pci *mantis)
>  138{
>             ...
>  163        err = mantis_dma_init(mantis);
>  164        if (err < 0) {
>  165                dprintk(verbose, MANTIS_ERROR, 1, "Mantis DMA init
> failed");
>  166                return err;
>  167        }
>             ...
>  179        return 0;
>  180}
>
> Kernel version:
>     3.19.1
>
>
>
>

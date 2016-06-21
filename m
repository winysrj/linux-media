Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34894 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbcFUCS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 22:18:26 -0400
Received: by mail-lb0-f182.google.com with SMTP id o4so1218803lbp.2
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 19:18:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
References: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 21 Jun 2016 07:47:48 +0530
Message-ID: <CAO_48GEgSLAjfhHsk6wtXy73M1_rQVp9r9zk3mOhZsnVZVK_Wg@mail.gmail.com>
Subject: Re: [PATCH 0/3] dma-buf: debugfs fixes
To: Mathias Krause <minipli@googlemail.com>
Cc: Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mathias,

On 19 June 2016 at 18:01, Mathias Krause <minipli@googlemail.com> wrote:
> This small series is the v2 of the patch posted initially here:
>
>   http://www.spinics.net/lists/linux-media/msg101347.html
>
> It not only fixes the type mix-up and addresses Daniel's remark (patch 1),
> it also smoothes out the error handling in dma_buf_init_debugfs() (patch 2)
> and removes the then unneeded function dma_buf_debugfs_create_file() (patch
> 3).
>
> Please apply!
>
Thanks for your patchset; applied via drm-misc!

> Mathias Krause (3):
>   dma-buf: propagate errors from dma_buf_describe() on debugfs read
>   dma-buf: remove dma_buf directory on bufinfo file creation errors
>   dma-buf: remove dma_buf_debugfs_create_file()
>
>  drivers/dma-buf/dma-buf.c |   44 ++++++++++++++------------------------------
>  include/linux/dma-buf.h   |    2 --
>  2 files changed, 14 insertions(+), 32 deletions(-)
>
> --
> 1.7.10.4
>



-- 
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org │ Open source software for ARM SoCs

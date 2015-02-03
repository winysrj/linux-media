Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:38773 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966485AbbBCUgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 15:36:31 -0500
Received: by mail-yh0-f45.google.com with SMTP id f73so19573314yha.4
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 12:36:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1YIjr7-00007P-Tr@www.linuxtv.org>
References: <E1YIjr7-00007P-Tr@www.linuxtv.org>
Date: Tue, 3 Feb 2015 22:36:30 +0200
Message-ID: <CAHp75VfSxSDV1zs-bjhhZAS8YByEdW6-t1=PnZ7qZJhdPG-kUg@mail.gmail.com>
Subject: Re: [git:media_tree/master] [media] lirc_dev: avoid potential null-dereference
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 3, 2015 at 9:33 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
>
> Subject: [media] lirc_dev: avoid potential null-dereference
> Author:  Andy Shevchenko <andy.shevchenko@gmail.com>
> Date:    Tue Jan 6 22:53:37 2015 -0300
>
> We have to check pointer for NULL and then dereference it.

Sorry, seems I forgot to write that it is non-needed fix.
Regarding to the current poll_wait() implementation and that fact that
wait_poll is a first member of the struct lirc_buffer there is no
dereference.

>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
>  drivers/media/rc/lirc_dev.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> ---
>
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=3656cddd50018d562d2df87c4698783898732914
>
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 1e0545a..4de0e85 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -553,14 +553,14 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
>         if (!ir->attached)
>                 return POLLERR;
>
> -       poll_wait(file, &ir->buf->wait_poll, wait);
> +       if (ir->buf) {
> +               poll_wait(file, &ir->buf->wait_poll, wait);
>
> -       if (ir->buf)
>                 if (lirc_buffer_empty(ir->buf))
>                         ret = 0;
>                 else
>                         ret = POLLIN | POLLRDNORM;
> -       else
> +       } else
>                 ret = POLLERR;
>
>         dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",



-- 
With Best Regards,
Andy Shevchenko

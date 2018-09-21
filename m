Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42726 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391243AbeIVCWU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 22:22:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id x20-v6so897755pln.9
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 13:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20180921195736.7977-1-natechancellor@gmail.com>
In-Reply-To: <20180921195736.7977-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 21 Sep 2018 13:31:37 -0700
Message-ID: <CAKwvOdk-w04qavrzeOg_yCH6gYRE4UEX49TJBEb8wMjRssPDdQ@mail.gmail.com>
Subject: Re: [PATCH] media: cx18: Don't check for address of video_dev
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: awalls@md.metrocast.net,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 21, 2018 at 1:03 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns that the address of a pointer will always evaluated as true
> in a boolean context.
>
> drivers/media/pci/cx18/cx18-driver.c:1255:23: warning: address of
> 'cx->streams[i].video_dev' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>                 if (&cx->streams[i].video_dev)
>                 ~~   ~~~~~~~~~~~~~~~^~~~~~~~~
> 1 warning generated.
>
> Presumably, the contents of video_dev should have been checked, not the
> address. This check has been present since 2009, introduced by commit
> 21a278b85d3c ("V4L/DVB (11619): cx18: Simplify the work handler for
> outgoing mailbox commands")
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> Alternatively, this if statement could just be removed since it has
> evaluated to true since 2009 and I assume some issue with this would
> have been discovered by now.
>
>  drivers/media/pci/cx18/cx18-driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 56763c4ea1a7..753a37c7100a 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -1252,7 +1252,7 @@ static void cx18_cancel_out_work_orders(struct cx18 *cx)
>  {
>         int i;
>         for (i = 0; i < CX18_MAX_STREAMS; i++)
> -               if (&cx->streams[i].video_dev)
> +               if (cx->streams[i].video_dev)

cx->streams[i].video_dev has the type `struct video_device video_dev`.
So wouldn't this change always be true as well, since the struct is
embedded?

>                         cancel_work_sync(&cx->streams[i].out_work_order);
>  }
>
> --
> 2.19.0
>


-- 
Thanks,
~Nick Desaulniers

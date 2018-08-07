Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41299 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390234AbeHGTon (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 15:44:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id z8-v6so8150670pgu.8
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 10:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <7fbc03c87b03ffb9128fe67bcbca6f1c6cc96c5c.1533644783.git.mchehab+samsung@kernel.org>
 <73679ccd7a36de61bd8405e9828989e9dd959bc5.1533644783.git.mchehab+samsung@kernel.org>
In-Reply-To: <73679ccd7a36de61bd8405e9828989e9dd959bc5.1533644783.git.mchehab+samsung@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 7 Aug 2018 10:29:10 -0700
Message-ID: <CAKwvOd=BfQ5S7kY0D8yxVRYmr+aJjq64ZwcyRBmjhOTjLDr+WA@mail.gmail.com>
Subject: Re: [PATCH 2/3] media: drxj: get rid of uneeded casts
To: mchehab+samsung@kernel.org
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2018 at 5:26 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Instead of doing casts, use %zd to print sizes, in order to make
> smatch happier:
>         drivers/media/dvb-frontends/drx39xyj/drxj.c:11814 drx_ctrl_u_code() warn: argument 4 to %u specifier is cast from pointer
>         drivers/media/dvb-frontends/drx39xyj/drxj.c:11845 drx_ctrl_u_code() warn: argument 3 to %u specifier is cast from pointer
>         drivers/media/dvb-frontends/drx39xyj/drxj.c:11869 drx_ctrl_u_code() warn: argument 3 to %u specifier is cast from pointer
>         drivers/media/dvb-frontends/drx39xyj/drxj.c:11878 drx_ctrl_u_code() warn: argument 3 to %u specifier is cast from pointer
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/dvb-frontends/drx39xyj/drxj.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> index 2948d12d7c14..9628d4067fe1 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
> +++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> @@ -11810,8 +11810,8 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
>                 block_hdr.CRC = be16_to_cpu(*(__be16 *)(mc_data));
>                 mc_data += sizeof(u16);
>
> -               pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
> -                       (unsigned)(mc_data - mc_data_init), block_hdr.addr,
> +               pr_debug("%zd: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
> +                       (mc_data - mc_data_init), block_hdr.addr,
>                          block_hdr.size, block_hdr.flags, block_hdr.CRC);
>
>                 /* Check block header on:
> @@ -11841,8 +11841,8 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
>                                                         mc_block_nr_bytes,
>                                                         mc_data, 0x0000)) {
>                                 rc = -EIO;
> -                               pr_err("error writing firmware at pos %u\n",
> -                                      (unsigned)(mc_data - mc_data_init));
> +                               pr_err("error writing firmware at pos %zd\n",
> +                                      mc_data - mc_data_init);
>                                 goto release;
>                         }
>                         break;
> @@ -11865,8 +11865,8 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
>                                                     (u16)bytes_to_comp,
>                                                     (u8 *)mc_data_buffer,
>                                                     0x0000)) {
> -                                       pr_err("error reading firmware at pos %u\n",
> -                                              (unsigned)(mc_data - mc_data_init));
> +                                       pr_err("error reading firmware at pos %zd\n",
> +                                              mc_data - mc_data_init);
>                                         return -EIO;
>                                 }
>
> @@ -11874,8 +11874,8 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
>                                                 bytes_to_comp);
>
>                                 if (result) {
> -                                       pr_err("error verifying firmware at pos %u\n",
> -                                              (unsigned)(mc_data - mc_data_init));
> +                                       pr_err("error verifying firmware at pos %zd\n",
> +                                              mc_data - mc_data_init);
>                                         return -EIO;
>                                 }
>
> --
> 2.17.1
>

>From Documentation/printk-formats.txt, it looks like %zd is for
ssize_t, which is what I would expect for pointer subtracting (well
maybe intptr_t, but ssize_t should be word-size-independent).

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

-- 
Thanks,
~Nick Desaulniers

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58756 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaFRXuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jun 2014 19:50:10 -0400
Received: by mail-oa0-f47.google.com with SMTP id n16so3550439oag.20
        for <linux-media@vger.kernel.org>; Wed, 18 Jun 2014 16:50:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403128945-28298-1-git-send-email-xypron.glpk@gmx.de>
References: <1403128945-28298-1-git-send-email-xypron.glpk@gmx.de>
Date: Wed, 18 Jun 2014 16:50:09 -0700
Message-ID: <CAGXu5jKLoRkKuu8T=im6oEhn3WmXjZPwFXEbaPT6SeL29XrS0g@mail.gmail.com>
Subject: Re: [PATCH 1/1] media: dib9000: avoid out of bound access
From: Kees Cook <keescook@chromium.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 18, 2014 at 3:02 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> The current test to avoid out of bound access to mb[] is insufficient.
> For len = 19 non-existent mb[10] will be accessed.
>
> A check in the for loop is insufficient to avoid out of bound access in
> dib9000_mbx_send_attr.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/media/dvb-frontends/dib9000.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
> index e540cfb..6a71917 100644
> --- a/drivers/media/dvb-frontends/dib9000.c
> +++ b/drivers/media/dvb-frontends/dib9000.c
> @@ -1040,10 +1040,13 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
>         if (address >= 1024 || !state->platform.risc.fw_is_running)
>                 return -EINVAL;
>
> +       if (len > 18)
> +               return -EINVAL;
> +
>         /* dprintk( "APB access thru wr fw %d %x", address, attribute); */
>
>         mb[0] = (unsigned short)address;
> -       for (i = 0; i < len && i < 20; i += 2)
> +       for (i = 0; i < len; i += 2)
>                 mb[1 + (i / 2)] = (b[i] << 8 | b[i + 1]);

Good catch on the mb[] access! However, I think there is still more to
fix since b[i + 1] can read past the end of b: Say b is defined as "u8
b[3]". Passing len 3 means the second loop, with i==2 will access b[2]
and b[3], the latter is out of range.

-Kees

>
>         dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, 1 + len / 2, attribute);
> --
> 2.0.0
>



-- 
Kees Cook
Chrome OS Security

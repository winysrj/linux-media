Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40672 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0LaKdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 05:33:52 -0500
MIME-Version: 1.0
In-Reply-To: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
Date: Fri, 31 Dec 2010 11:33:49 +0100
Message-ID: <AANLkTins7rj1o4rEcEFmVSA2=1yXZSfLdO000gqQP7cg@mail.gmail.com>
Subject: Re: [PATCH 01/15]arch:m68k:ifpsp060:src:fpsp.S Typo change diable to disable.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-m68k@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
	spi-devel-general@lists.sourceforge.net,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Dec 31, 2010 at 00:07, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The below patch fixes a typo "diable" to "disable". Please let me know if this
> is correct or not.
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  arch/m68k/ifpsp060/src/fpsp.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/ifpsp060/src/fpsp.S b/arch/m68k/ifpsp060/src/fpsp.S
> index 73613b5..26e85e2 100644
> --- a/arch/m68k/ifpsp060/src/fpsp.S
> +++ b/arch/m68k/ifpsp060/src/fpsp.S
> @@ -3881,7 +3881,7 @@ _fpsp_fline:
>  # FP Unimplemented Instruction stack frame and jump to that entry
>  # point.
>  #
> -# but, if the FPU is disabled, then we need to jump to the FPU diabled
> +# but, if the FPU is disabled, then we need to jump to the FPU disabled
>  # entry point.
>        movc            %pcr,%d0
>        btst            &0x1,%d0

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

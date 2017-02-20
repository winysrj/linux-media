Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:57617 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751341AbdBTLtY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 06:49:24 -0500
Date: Mon, 20 Feb 2017 13:48:23 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Francesco <francesco@bsod.eu>
Cc: linux-media@vger.kernel.org
Subject: Re: PATCH: v4l-utils/utils/ir-ctl/irc-ctl.c: fix musl build
Message-ID: <20170220114823.hv3uy36tw3q2cwyr@tarshish>
References: <df17ce75ae92e047060082c98a00b50d@bsod.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df17ce75ae92e047060082c98a00b50d@bsod.eu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco,

On Mon, Feb 20, 2017 at 12:33:14PM +0100, Francesco wrote:
> This is my fist attempt to send a patch for v4l-utils project.
> I maintain v4l-utils package for Alpine Linux (www.alpinelinux.org), a
> musl-based distro.
> 
> This patch allows the build for v4l-utils by allowing alternatives to GLIBC
> assumptions.
> 
> Thanks for considering.

> From 71f399cb1399c35ff4ce165c2cec0fcd3256d34e Mon Sep 17 00:00:00 2001
> From: Francesco Colista <fcolista@ita.wtbts.net>
> Date: Mon, 20 Feb 2017 10:16:01 +0100
> Subject: [PATCH] utils/ir-ctl/ir-ctl.c: fix build with musl library
> 
> This patch allows to build correctly v4l-utils on musl-based distributions.
> It provides alternative to glibc assumptions.
> ---
>  utils/ir-ctl/ir-ctl.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
> index bc58cee0..0bd0ddcc 100644
> --- a/utils/ir-ctl/ir-ctl.c
> +++ b/utils/ir-ctl/ir-ctl.c
> @@ -42,6 +42,20 @@
>  # define _(string) string
>  #endif
>  
> +#if !defined(__GLIBC__)

This might break other libc implementations. Instead, do

  #ifndef TEMP_FAILURE_RETRY

See 
https://git.busybox.net/buildroot/tree/package/libv4l/0002-ir-ctl-fixes-for-musl-compile.patch

> +
> +/* Evaluate EXPRESSION, and repeat as long as it returns -1 with `errno'
> +   set to EINTR.  */
> +
> +# define TEMP_FAILURE_RETRY(expression) \
> +  (__extension__                                                              \
> +    ({ long int __result;                                                     \
> +       do __result = (long int) (expression);                                 \
> +       while (__result == -1L && errno == EINTR);                             \
> +       __result; }))
> +
> +#endif
> +
>  # define N_(string) string

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -

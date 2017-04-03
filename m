Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38163 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751008AbdDCJ2g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 05:28:36 -0400
Subject: Re: Conditional sys/sysmacros.h inclusion
To: Ingo Feinerer <feinerer@logic.at>, linux-media@vger.kernel.org
References: <20170313115838.GA28761@t450.itgeo.fhwn.ac.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8429768f-9edc-e701-5fe2-0ca7f6d168ee@xs4all.nl>
Date: Mon, 3 Apr 2017 11:28:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170313115838.GA28761@t450.itgeo.fhwn.ac.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ingo,

I was about to commit this when I noticed that you didn't add a
Signed-off-by line in your email. We need that for v4l-utils.

See section 11 here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=HEAD

for details about that tag.

Just reply with your Signed-off-by and I'll merge this patch.

Regards,

	Hans

On 03/13/2017 12:58 PM, Ingo Feinerer wrote:
> Hi,
> 
> please find attached a diff that makes the inclusion of the sys/sysmacros.h
> header file conditional. I noticed it on OpenBSD which has no sys/sysmacros.h,
> so compilation fails there.
> 
> Best regards,
> Ingo
> 
> diff --git a/configure.ac b/configure.ac
> index f3269728a..ae58da377 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -146,6 +146,7 @@ if test "x$gl_cv_func_ioctl_posix_signature" = xyes; then
>  fi
>  
>  AC_CHECK_FUNCS([__secure_getenv secure_getenv])
> +AC_HEADER_MAJOR
>  
>  # Check host os
>  case "$host_os" in
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index 59f28b137..1e784eda8 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -20,7 +20,9 @@
>   */
>  
>  #include <sys/types.h>
> +#if defined(MAJOR_IN_SYSMACROS)
>  #include <sys/sysmacros.h>
> +#endif
>  #include <sys/mman.h>
>  #include <fcntl.h>
>  #include <sys/stat.h>
> 

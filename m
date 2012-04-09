Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab2DIMew (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Apr 2012 08:34:52 -0400
Message-ID: <4F82D768.5030007@redhat.com>
Date: Mon, 09 Apr 2012 09:34:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] media_build: fix module_*_driver redefined warnings
References: <1332252617-3171-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1332252617-3171-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

Em 20-03-2012 11:10, Gianluca Gennari escreveu:
> The conditions "#ifndef module_usb_driver" and "#ifndef module_platform_driver"
> are always true, as the header files where this macros are defined are not
> included in compat.h (linux/usb.h and linux/platform_devices.h).
> 
> This produces a lot of warnings like "module_usb_driver redefined" or
> "module_platform_driver redefined" with kernels 3.2 and 3.3.
> 
> But including the header files in compat.h produces other "redefined" warnings,
> so let's check the kernel version instead.
> 
> module_usb_driver was first introduced in kernel 3.3,
> while module_platform_driver was introduced in kernel 3.2.
> 
> Tested with kernel 3.3, 3.2 and 3.0.
> 
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
> ---
>  v4l/compat.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/v4l/compat.h b/v4l/compat.h
> index 62710c9..ab0f2e7 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -864,7 +864,7 @@ static inline int snd_ctl_enum_info(struct snd_ctl_elem_info *info, unsigned int
>  #endif
>  #endif /*pr_debug_ratelimited */
>  
> -#ifndef module_usb_driver
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 3, 0)

Please avoid adding more tests for an specific Kernel version here. There are
two issues with checks like that:

	1) this may break on some kernel-fix release that might backport the function.
This is not very common, but there was some cases like that, in the USB subsystem;

	2) this generally breaks compilation, after some time, if someone tries
to compile it against a distribution-patched kernel, as the new code may be
backported there.

That's said, if just doing an "#ifdef module_usb_driver" doesn't work because this
is not a macro, you can add a simple check at this script:
	v4l/scripts/make_config_compat.pl 

like this one:

	check_file_for_func("include/linux/delay.h", "usleep_range", "NEED_USLEEP_RANGE");

This function will seek for "usleep_range" at the delay.h header. If not found, it will
add a #define NEED_USLEEP_RANGE at v4l/config-compat.h, that can be checked inside compat.h:

#ifdef NEED_USLEEP_RANGE
#define usleep_range(min, max) msleep(min/1000)
#endif

You can use the same kind of logic for module_usb_driver.

Regards,
Mauro


>  #define module_usb_driver(drv)			\
>  static int __init usb_mod_init(void)		\
>  {						\
> @@ -878,7 +878,7 @@ module_init(usb_mod_init);			\
>  module_exit(usb_mod_exit);
>  #endif /* module_usb_driver */
>  
> -#ifndef module_platform_driver
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 2, 0)
>  #define module_platform_driver(drv)		\
>  static int __init plat_mod_init(void)		\
>  {						\


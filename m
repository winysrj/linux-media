Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55666 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2JANJh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 09:09:37 -0400
Received: by bkcjk13 with SMTP id jk13so4926278bkc.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 06:09:36 -0700 (PDT)
Message-ID: <5069960C.8020507@gmail.com>
Date: Mon, 01 Oct 2012 15:09:32 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	jwboyer@fedora, devel@lists.fedoraproject.org,
	kernel@lists.fedoraproject.org
Subject: Re: [v3 1/1] driver-core: Shut up dev_dbg_reatelimited() without
 DEBUG
References: <20120904.074040.1817050383890381031.hdoyu@nvidia.com>
In-Reply-To: <20120904.074040.1817050383890381031.hdoyu@nvidia.com>
Content-Type: multipart/mixed;
 boundary="------------020608040600040703020303"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020608040600040703020303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/04/2012 06:40 AM, Hiroshi Doyu wrote:
> dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
> suppressed". This shouldn't print anything without DEBUG.
> 
> With CONFIG_DYNAMIC_DEBUG, the print should be configured as expected.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> Tested-by: Antti Palosaari <crope@iki.fi>
> Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> ---
>  include/linux/device.h |   62 +++++++++++++++++++++++++++++------------------
>  1 files changed, 38 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 9648331..bb6ffcb 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -932,6 +932,32 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
>  
>  #endif
>  
> +/*
> + * Stupid hackaround for existing uses of non-printk uses dev_info
> + *
> + * Note that the definition of dev_info below is actually _dev_info
> + * and a macro is used to avoid redefining dev_info
> + */
> +
> +#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
> +
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +#define dev_dbg(dev, format, ...)		     \
> +do {						     \
> +	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> +} while (0)
> +#elif defined(DEBUG)
> +#define dev_dbg(dev, format, arg...)		\
> +	dev_printk(KERN_DEBUG, dev, format, ##arg)
> +#else
> +#define dev_dbg(dev, format, arg...)				\
> +({								\
> +	if (0)							\
> +		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
> +	0;							\
> +})
> +#endif
> +
>  #define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
>  do {									\
>  	static DEFINE_RATELIMIT_STATE(_rs,				\
> @@ -955,33 +981,21 @@ do {									\
>  	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>  #define dev_info_ratelimited(dev, fmt, ...)				\
>  	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
> +#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
>  #define dev_dbg_ratelimited(dev, fmt, ...)				\
> -	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
> -
> -/*
> - * Stupid hackaround for existing uses of non-printk uses dev_info
> - *
> - * Note that the definition of dev_info below is actually _dev_info
> - * and a macro is used to avoid redefining dev_info
> - */
> -
> -#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
> -
> -#if defined(CONFIG_DYNAMIC_DEBUG)
> -#define dev_dbg(dev, format, ...)		     \
> -do {						     \
> -	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
> +	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
> +	    __ratelimit(&_rs))						\
> +		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
> +				   ##__VA_ARGS__);			\
>  } while (0)
> -#elif defined(DEBUG)
> -#define dev_dbg(dev, format, arg...)		\
> -	dev_printk(KERN_DEBUG, dev, format, ##arg)
>  #else
> -#define dev_dbg(dev, format, arg...)				\
> -({								\
> -	if (0)							\
> -		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
> -	0;							\
> -})
> +#define dev_dbg_ratelimited(dev, fmt, ...)			\
> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>  #endif
>  
>  #ifdef VERBOSE_DEBUG
> 

http://patchwork.linuxtv.org/patch/14158/
Koji have the old one.
Please do patch whit this one from Hiroshi, so we can use it with
latest&greatest media_build without 'usb_urb_complete' flood.
In an attach is Beefy Miracle aligned diff.

Muchas gracias,
poma


--------------020608040600040703020303
Content-Type: text/x-patch;
 name="shut-up-dev_dbg-3.5.4-2.fc17.x86_64.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="shut-up-dev_dbg-3.5.4-2.fc17.x86_64.diff"

--- v3-1-1-driver-core-Shut-up-dev_dbg_reatelimited-without-DEBUG.patch	2012-10-01 12:21:59.743710145 +0200
+++ device.h-3.5.4-2.fc17.x86_64.patch	2012-10-01 14:29:52.875520419 +0200
@@ -1,8 +1,6 @@
-diff --git a/include/linux/device.h b/include/linux/device.h
-index 9648331..bb6ffcb 100644
---- a/include/linux/device.h
-+++ b/include/linux/device.h
-@@ -932,6 +932,32 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
+--- /usr/src/kernels/3.5.4-2.fc17.x86_64/include/linux/device.h.orig	2012-10-01 14:28:24.609693878 +0200
++++ /usr/src/kernels/3.5.4-2.fc17.x86_64/include/linux/device.h	2012-10-01 14:29:50.725647318 +0200
+@@ -939,6 +939,32 @@
  
  #endif
  
@@ -35,7 +33,7 @@
  #define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
  do {									\
  	static DEFINE_RATELIMIT_STATE(_rs,				\
-@@ -955,33 +981,21 @@ do {									\
+@@ -962,33 +988,21 @@
  	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
  #define dev_info_ratelimited(dev, fmt, ...)				\
  	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)

--------------020608040600040703020303--

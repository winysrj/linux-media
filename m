Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3447 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3BIPYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 10:24:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH] media_build: add PTR_RET to compat.h
Date: Sat, 9 Feb 2013 16:23:59 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
References: <1360418680-9682-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1360418680-9682-1-git-send-email-gennarone@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302091623.59942.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat February 9 2013 15:04:40 Gianluca Gennari wrote:
> PTR_RET is used by the solo6x10 staging driver,
> and was introduced in kernel 2.6.39.
> Add it to compat.h for compatibility with older kernels.

Applied, thanks!

Regards,

	Hans

> 
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
> ---
>  v4l/compat.h                      | 10 ++++++++++
>  v4l/scripts/make_config_compat.pl |  1 +
>  2 files changed, 11 insertions(+)
> 
> diff --git a/v4l/compat.h b/v4l/compat.h
> index 1a82bb7..b27b178 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -1137,4 +1137,14 @@ static inline int usb_translate_errors(int error_code)
>  }
>  #endif
>  
> +#ifdef NEED_PTR_RET
> +static inline int __must_check PTR_RET(const void *ptr)
> +{
> +	if (IS_ERR(ptr))
> +		return PTR_ERR(ptr);
> +	else
> +		return 0;
> +}
> +#endif
> +
>  #endif /*  _COMPAT_H */
> diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
> index 583ef9d..51a1f5d 100644
> --- a/v4l/scripts/make_config_compat.pl
> +++ b/v4l/scripts/make_config_compat.pl
> @@ -588,6 +588,7 @@ sub check_other_dependencies()
>  	check_files_for_func("config_enabled", "NEED_IS_ENABLED", "include/linux/kconfig.h");
>  	check_files_for_func("DEFINE_PCI_DEVICE_TABLE", "NEED_DEFINE_PCI_DEVICE_TABLE", "include/linux/pci.h");
>  	check_files_for_func("usb_translate_errors", "NEED_USB_TRANSLATE_ERRORS", "include/linux/usb.h");
> +	check_files_for_func("PTR_RET", "NEED_PTR_RET", "include/linux/err.h");
>  
>  	# For tests for uapi-dependent logic
>  	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
> 

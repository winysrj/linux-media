Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39822 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750922AbdGZI6B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 04:58:01 -0400
Subject: Re: [PATCH] Add compat code for skb_put_data
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
References: <20170723093151.26338-1-zzam@gentoo.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2c19b8e1-34ef-102e-4686-31d21c409ad8@xs4all.nl>
Date: Wed, 26 Jul 2017 10:57:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170723093151.26338-1-zzam@gentoo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2017 11:31 AM, Matthias Schwarzott wrote:
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Applied, much appreciated that you looked into this!

Regards.

	Hans

> ---
>   v4l/compat.h                      | 12 ++++++++++++
>   v4l/scripts/make_config_compat.pl |  1 +
>   2 files changed, 13 insertions(+)
> 
> diff --git a/v4l/compat.h b/v4l/compat.h
> index 47e2694..e565292 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -2072,4 +2072,16 @@ static inline bool is_of_node(struct fwnode_handle *fwnode)
>   }
>   #endif
>   
> +#ifdef NEED_SKB_PUT_DATA
> +static inline void *skb_put_data(struct sk_buff *skb, const void *data,
> +                                 unsigned int len)
> +{
> +        void *tmp = skb_put(skb, len);
> +
> +        memcpy(tmp, data, len);
> +
> +        return tmp;
> +}
> +#endif
> +
>   #endif /*  _COMPAT_H */
> diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
> index d186cb4..5ac59ab 100644
> --- a/v4l/scripts/make_config_compat.pl
> +++ b/v4l/scripts/make_config_compat.pl
> @@ -699,6 +699,7 @@ sub check_other_dependencies()
>   	check_files_for_func("of_fwnode_handle", "NEED_FWNODE", "include/linux/of.h");
>   	check_files_for_func("to_of_node", "NEED_TO_OF_NODE", "include/linux/of.h");
>   	check_files_for_func("is_of_node", "NEED_IS_OF_NODE", "include/linux/of.h");
> +	check_files_for_func("skb_put_data", "NEED_SKB_PUT_DATA", "include/linux/skbuff.h");
>   
>   	# For tests for uapi-dependent logic
>   	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
> 

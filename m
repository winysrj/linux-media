Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36897 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbcBVJyV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 04:54:21 -0500
Date: Mon, 22 Feb 2016 06:54:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC 2/4] media: Rearrange the fields in the G_TOPOLOGY IOCTL
 argument
Message-ID: <20160222065415.473a8c64@recife.lan>
In-Reply-To: <1456090575-28354-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
	<1456090575-28354-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 21 Feb 2016 23:36:13 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> This avoids having multiple reserved fields in the struct. Reserved fields
> are added in order to align the struct size to a power of two as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/media.h | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 008d077..77a95db 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -341,21 +341,16 @@ struct media_v2_link {
>  struct media_v2_topology {
>  	__u64 topology_version;
>  
> -	__u32 num_entities;
> -	__u32 reserved1;
>  	__u64 ptr_entities;
> -
> -	__u32 num_interfaces;
> -	__u32 reserved2;
>  	__u64 ptr_interfaces;
> -
> -	__u32 num_pads;
> -	__u32 reserved3;
>  	__u64 ptr_pads;
> +	__u64 ptr_links;
>  
> +	__u32 num_entities;
> +	__u32 num_interfaces;
> +	__u32 num_pads;
>  	__u32 num_links;
> -	__u32 reserved4;
> -	__u64 ptr_links;
> +	__u32 reserved[18];
>  };

This patch deserves more discussion. I suggest we discuss it on our
next IRC meeting about the MC (likely today).

>  
>  static inline void __user *media_get_uptr(__u64 arg)


-- 
Thanks,
Mauro

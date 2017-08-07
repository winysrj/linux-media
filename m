Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59439 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbdHGUWi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:22:38 -0400
Date: Mon, 7 Aug 2017 21:22:37 +0100
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] keytable.c: add support for the CEC protocol
Message-ID: <20170807202236.6fgbhxt3mk4svelc@gofer.mess.org>
References: <991a08f5-40e1-e364-1400-91236c6fbeb0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <991a08f5-40e1-e364-1400-91236c6fbeb0@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 07, 2017 at 02:52:01PM +0200, Hans Verkuil wrote:
> The CEC protocol wasn't known, so 'Supported protocols:' would just say
> 'other' instead of 'cec'.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sean Young <sean@mess.org>

> ---
> diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
> index 634f4561..55abfc19 100644
> --- a/utils/keytable/keytable.c
> +++ b/utils/keytable/keytable.c
> @@ -106,6 +106,7 @@ enum sysfs_protocols {
>  	SYSFS_RC6		= (1 << 10),
>  	SYSFS_SHARP		= (1 << 11),
>  	SYSFS_XMP		= (1 << 12),
> +	SYSFS_CEC		= (1 << 13),
>  	SYSFS_INVALID		= 0,
>  };
> 
> @@ -138,6 +139,7 @@ const struct protocol_map_entry protocol_map[] = {
>  	{ "rc-6-mce",	NULL,		SYSFS_INVALID	},
>  	{ "sharp",	NULL,		SYSFS_SHARP	},
>  	{ "xmp",	"/xmp_decoder",	SYSFS_XMP	},
> +	{ "cec",	NULL,		SYSFS_CEC	},
>  	{ NULL,		NULL,		SYSFS_INVALID	},
>  };

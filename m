Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33077 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbcGKRAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 13:00:17 -0400
Received: by mail-pf0-f194.google.com with SMTP id c74so13785905pfb.0
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 10:00:16 -0700 (PDT)
Date: Mon, 11 Jul 2016 10:00:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/5] serio.h: add new define for the Pulse-Eight USB-CEC
 Adapter
Message-ID: <20160711170013.GA26822@dtor-ws>
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
 <1468156281-25731-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468156281-25731-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 10, 2016 at 03:11:18PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is for the new pulse8-cec staging driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>


Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Please feel free to merge through media tree. If you could change the
subject to read:

Input: serio - add new protocol for the Pulse-Eight USB-CEC Adapter

That would be great.

Thanks!

> ---
>  include/uapi/linux/serio.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/serio.h b/include/uapi/linux/serio.h
> index c2ea169..f2447a8 100644
> --- a/include/uapi/linux/serio.h
> +++ b/include/uapi/linux/serio.h
> @@ -78,5 +78,6 @@
>  #define SERIO_TSC40	0x3d
>  #define SERIO_WACOM_IV	0x3e
>  #define SERIO_EGALAX	0x3f
> +#define SERIO_PULSE8_CEC	0x40
>  
>  #endif /* _UAPI_SERIO_H */
> -- 
> 2.8.1
> 

-- 
Dmitry

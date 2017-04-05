Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35774 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753859AbdDEAVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 20:21:00 -0400
Date: Tue, 4 Apr 2017 17:20:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/2] serio.h: add SERIO_RAINSHADOW_CEC ID
Message-ID: <20170405002056.GB19744@dtor-ws>
References: <20170203152633.33323-1-hverkuil@xs4all.nl>
 <20170203152633.33323-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203152633.33323-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 03, 2017 at 04:26:32PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new serio ID for the RainShadow Tech USB HDMI CEC adapter.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  include/uapi/linux/serio.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/serio.h b/include/uapi/linux/serio.h
> index f2447a8..f42e919 100644
> --- a/include/uapi/linux/serio.h
> +++ b/include/uapi/linux/serio.h
> @@ -79,5 +79,6 @@
>  #define SERIO_WACOM_IV	0x3e
>  #define SERIO_EGALAX	0x3f
>  #define SERIO_PULSE8_CEC	0x40
> +#define SERIO_RAINSHADOW_CEC	0x41
>  
>  #endif /* _UAPI_SERIO_H */
> -- 
> 2.10.2
> 

-- 
Dmitry

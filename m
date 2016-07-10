Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42154 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbcGJNVC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 09:21:02 -0400
Subject: Re: [PATCH 2/5] serio.h: add new define for the Pulse-Eight USB-CEC
 Adapter
To: linux-media@vger.kernel.org
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
 <1468156281-25731-3-git-send-email-hverkuil@xs4all.nl>
Cc: lars@opdenkamp.eu, linux-input <linux-input@vger.kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <25823b5a-3547-8f8a-bfa2-7ea842953673@xs4all.nl>
Date: Sun, 10 Jul 2016 15:20:57 +0200
MIME-Version: 1.0
In-Reply-To: <1468156281-25731-3-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added linux-input to the Cc list.

Dmitry, it probably makes the most sense if this goes through the media
tree with your Ack, unless you know there will be a conflict.

Regards,

	Hans

On 07/10/2016 03:11 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is for the new pulse8-cec staging driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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
> 

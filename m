Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45623 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZBJESv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 23:18:51 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Roel Kluin <roel.kluin@gmail.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Tue, 10 Feb 2009 09:48:25 +0530
Subject: RE: [PATCH] v4l/tvp514x: try_count reaches 0, not -1
Message-ID: <19F8576C6E063C45BE387C64729E739403FA81B5F0@dbde02.ent.ti.com>
In-Reply-To: <4990A6B2.1080902@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Roel Kluin [mailto:roel.kluin@gmail.com]
> Sent: Tuesday, February 10, 2009 3:27 AM
> To: Hiremath, Vaibhav; mchehab@redhat.com
> Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> Subject: [PATCH] v4l/tvp514x: try_count reaches 0, not -1
> 
> with while (try_count-- > 0) { ... } try_count reaches 0, not -1.
> 
[Hiremath, Vaibhav] Please look at the loop,

        while (try_count-- > 0) {
		Wait till TVP locks the Signal.
        }

        if ((current_std == STD_INVALID) || (try_count < 0))
                return -EINVAL;

The above loop fails to lock the signal, and then the value of try_count will be -1 and not 0. The values 0-4 indicates the signal has been locked, provided that current_std != STD_INVALID.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/video/tvp514x.c
> b/drivers/media/video/tvp514x.c
> index 8e23aa5..5f4cbc2 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -686,7 +686,7 @@ static int ioctl_s_routing(struct
> v4l2_int_device *s,
>  			break;	/* Input detected */
>  	}
> 
> -	if ((current_std == STD_INVALID) || (try_count < 0))
> +	if ((current_std == STD_INVALID) || (try_count <= 0))
>  		return -EINVAL;
> 
>  	decoder->current_std = current_std;

[Hiremath, Vaibhav] I believe we don't need this fix here.

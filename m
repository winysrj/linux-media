Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2991 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0HGQMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 12:12:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: [PATCH for linux-next] V4L/DVB: v4l2: v4l2-ctrls.c needs kzalloc/kfree prototype
Date: Sat, 7 Aug 2010 18:12:45 +0200
Cc: linux-media@vger.kernel.org
References: <alpine.DEB.2.00.1008071734460.5908@calimero>
In-Reply-To: <alpine.DEB.2.00.1008071734460.5908@calimero>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008071812.45208.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 August 2010 17:47:57 Laurent Riffard wrote:
> linux-next 20100807 failed to compile:
> 
> drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_init’:
> drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of function ‘kzalloc’
> drivers/media/video/v4l2-ctrls.c:767: warning: assignment makes pointer from integer without a cast
> drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_free’:
> drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of function ‘kfree’

Thanks for the notification, but I discovered it myself already and posted a
pull request fixing this yesterday.

Regards,

	Hans

> ...
> 
> ---
>   drivers/media/video/v4l2-ctrls.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 84c1a53..951c8c6 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -19,6 +19,7 @@
>    */
> 
>   #include <linux/ctype.h>
> +#include <linux/slab.h>         /* for kzalloc/kfree */
>   #include <media/v4l2-ioctl.h>
>   #include <media/v4l2-device.h>
>   #include <media/v4l2-ctrls.h>
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

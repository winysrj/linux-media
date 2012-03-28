Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:35173 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758165Ab2C1Q2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 12:28:00 -0400
Message-ID: <4F733C0E.8030209@xenotime.net>
Date: Wed, 28 Mar 2012 09:27:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH for v3.4] Add missing slab.h to radio-rtrack2.c
References: <201203271139.21762.hverkuil@xs4all.nl>
In-Reply-To: <201203271139.21762.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/27/2012 02:39 AM, Hans Verkuil wrote:

> Missed this one, this patch should solve this issue:
> 
> http://www.spinics.net/lists/linux-media/msg45880.html
> 
> Slab.h was added to all the other isa drivers, but not radio-rtrack2.c.
> 
> Subject: [PATCH] radio-rtrack2: add missing slab.h.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/media/radio/radio-rtrack2.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-
> rtrack2.c
> index b275c5d..b1f844c 100644
> --- a/drivers/media/radio/radio-rtrack2.c
> +++ b/drivers/media/radio/radio-rtrack2.c
> @@ -17,6 +17,7 @@
>  #include <linux/videodev2.h>	/* kernel radio structs		*/
>  #include <linux/mutex.h>
>  #include <linux/io.h>		/* outb, outb_p			*/
> +#include <linux/slab.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include "radio-isa.h"



-- 
~Randy

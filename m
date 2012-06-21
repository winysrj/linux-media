Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2615 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2FUGN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 02:13:27 -0400
Message-ID: <4FE2BB56.2050306@xs4all.nl>
Date: Thu, 21 Jun 2012 08:12:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] media: pms.c needs linux/slab.h
References: <20120619212521.D53D6A01BD@akpm.mtv.corp.google.com> <4FE27936.8090401@xenotime.net>
In-Reply-To: <4FE27936.8090401@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/06/12 03:30, Randy Dunlap wrote:
> From: Randy Dunlap<rdunlap@xenotime.net>
>
> drivers/media/video/pms.c uses kzalloc() and kfree() so it should
> include<linux/slab.h>  to fix build errors and a warning.
>
> drivers/media/video/pms.c:1047:2: error: implicit declaration of function 'kzalloc'
> drivers/media/video/pms.c:1047:6: warning: assignment makes pointer from integer without a cast
> drivers/media/video/pms.c:1116:2: error: implicit declaration of function 'kfree'
>
> Found in mmotm but applies to mainline.
>
> Signed-off-by: Randy Dunlap<rdunlap@xenotime.net>
> Cc: Hans Verkuil<hverkuil@xs4all.nl>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>   drivers/media/video/pms.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- mmotm-0619.orig/drivers/media/video/pms.c
> +++ mmotm-0619/drivers/media/video/pms.c
> @@ -29,6 +29,7 @@
>   #include<linux/ioport.h>
>   #include<linux/init.h>
>   #include<linux/mutex.h>
> +#include<linux/slab.h>
>   #include<linux/uaccess.h>
>   #include<linux/isa.h>
>   #include<asm/io.h>


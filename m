Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:43639 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZLAGkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 01:40:23 -0500
Message-ID: <4B14BA40.7040500@oracle.com>
Date: Mon, 30 Nov 2009 22:40:00 -0800
From: Randy Dunlap <randy.dunlap@Oracle.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@Oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH -next] media/common/tuners: fix use of KERNEL_VERSION
References: <4B14B8F1.6000805@oracle.com>
In-Reply-To: <4B14B8F1.6000805@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> pms.c uses KERNEL_VERSION so it needs to include version.h.

Incorrect $subject, sorry.

> drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/media/video/pms.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20091130.orig/drivers/media/video/pms.c
> +++ linux-next-20091130/drivers/media/video/pms.c
> @@ -29,6 +29,7 @@
>  #include <linux/mm.h>
>  #include <linux/ioport.h>
>  #include <linux/init.h>
> +#include <linux/version.h>
>  #include <asm/io.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-common.h>


-- 
~Randy

Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:36344 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZLCQVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 11:21:46 -0500
Date: Thu, 3 Dec 2009 08:20:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com,
	linux-media@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: pms: KERNEL_VERSION requires version.h
Message-Id: <20091203082023.282569b8.randy.dunlap@oracle.com>
In-Reply-To: <1259833707-23776-1-git-send-email-a.beregalov@gmail.com>
References: <1259833707-23776-1-git-send-email-a.beregalov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  3 Dec 2009 12:48:27 +0300 Alexander Beregalov wrote:

> Fix this build error:
> drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

I've already sent this patch, so I can also ack it...

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  drivers/media/video/pms.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
> index 00228d5..a118bb1 100644
> --- a/drivers/media/video/pms.c
> +++ b/drivers/media/video/pms.c
> @@ -35,6 +35,7 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-device.h>
>  #include <linux/mutex.h>
> +#include <linux/version.h>
>  
>  #include <asm/uaccess.h>
>  
> -- 


---
~Randy

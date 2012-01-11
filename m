Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34349 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2AKKW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 05:22:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] Fix compile error in as3645a.c
Date: Wed, 11 Jan 2012 11:23:24 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201201111054.20677.hverkuil@xs4all.nl>
In-Reply-To: <201201111054.20677.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111123.24963.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 11 January 2012 10:54:20 Hans Verkuil wrote:
> Building as3645a.c using media_build on kernel 3.2 gives this error:
> 
> media_build/v4l/as3645a.c: In function 'as3645a_probe':
> media_build/v4l/as3645a.c:815:2: error: implicit declaration of function
> 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/as3645a.c:815:8: warning: assignment makes pointer from
> integer without a cast [enabled by default]
> media_build/v4l/as3645a.c:842:3: error: implicit declaration of function
> 'kfree' [-Werror=implicit-function-declaration] cc1: some warnings being
> treated as errors
> 
> The fix is trivial:
> 
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> index ec859a5..f241702 100644
> --- a/drivers/media/video/as3645a.c
> +++ b/drivers/media/video/as3645a.c
> @@ -29,6 +29,7 @@
>  #include <linux/i2c.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/slab.h>
> 
>  #include <media/as3645a.h>
>  #include <media/v4l2-ctrls.h>
> 
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I got the same fix queued up in my tree already. Should I consider I have your 
ack ? :-)

-- 
Regards,

Laurent Pinchart

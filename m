Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53350 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0D1O2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 10:28:18 -0400
Message-ID: <4BD845E5.6040709@maxwell.research.nokia.com>
Date: Wed, 28 Apr 2010 17:27:49 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Sergio Aguirre <saaguirre@ti.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L: Events: Include slab.h explicitly
References: <1272380899-30398-1-git-send-email-saaguirre@ti.com>
In-Reply-To: <1272380899-30398-1-git-send-email-saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergio Aguirre wrote:
> After commit ID:
> 
>   commit de380b55f92986c1a84198149cb71b7228d15fbd
>   Author: Tejun Heo <tj@kernel.org>
>   Date:   Wed Mar 24 17:06:43 2010 +0900
> 
>       percpu: don't implicitly include slab.h from percpu.h
> 
> slab.h include was not longer implicitly included with sched.h.
> 
> So, now we have to include slab.h explicitly.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/v4l2-event.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index aea4332..7f31cd2 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -26,6 +26,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
>  
> +#include <linux/slab.h>
>  #include <linux/sched.h>
>  
>  int v4l2_event_init(struct v4l2_fh *fh)

Thanks for the patch, Sergio!

I was going to say that I'll send a new pull request but apparently
forgot to send this one in time. Anyway, this is now included in the
patchset, merged with another patch.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

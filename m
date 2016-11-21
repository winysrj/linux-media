Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37102
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932291AbcKUNdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 08:33:17 -0500
Date: Mon, 21 Nov 2016 11:33:11 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: videodev2: Include linux/time.h for timeval
 and timespec structs
Message-ID: <20161121113311.0ec196f7@vento.lan>
In-Reply-To: <1477565451-3621-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1477565451-3621-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Oct 2016 13:50:51 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> struct timeval and struct timespec are defined in linux/time.h. Explicitly
> include the header if __KERNEL__ is defined.

The patch below doesn't do what you're mentioned above. It unconditionally
include linux/time.h, and, for userspace, it will *also* include
sys/time.h...

I suspect that this would cause problems on userspace.

Btw, you didn't mention on your description what's the bug you're
trying to fix.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/videodev2.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 4364ce6..bbab50c 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -61,6 +61,7 @@
>  #endif
>  #include <linux/compiler.h>
>  #include <linux/ioctl.h>
> +#include <linux/time.h>
>  #include <linux/types.h>
>  #include <linux/v4l2-common.h>
>  #include <linux/v4l2-controls.h>


Thanks,
Mauro

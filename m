Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FLTulV021745
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 17:29:57 -0400
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FLT6ux012060
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 17:29:06 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: v4l-dvb-maintainer@linuxtv.org
Date: Mon, 15 Sep 2008 23:29:13 +0200
References: <20080909211058.6870.WEIYI.HUANG@gmail.com>
In-Reply-To: <20080909211058.6870.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809152329.13321.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Huang Weiyi <weiyi.huang@gmail.com>,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] V4L/DVB: uvc: remove unused #include
	<version.h>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tuesday 09 September 2008, Huang Weiyi wrote:
> The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
>   drivers/media/video/pwc/pwc-ctrl.c
>
> This patch removes the said #include <version.h>.
>   drivers/media/video/uvc/uvc_v4l2.c

This breaks compilation on 2.6.27-rc6 (and probably older kernels as well). 

CC [M]  drivers/media/video/uvc/uvc_v4l2.o
drivers/media/video/uvc/uvc_v4l2.c: In function ‘uvc_v4l2_do_ioctl’:
drivers/media/video/uvc/uvc_v4l2.c:491: error: implicit declaration of 
function ‘KERNEL_VERSION’
make[4]: *** [drivers/media/video/uvc/uvc_v4l2.o] Error 1
make[3]: *** [drivers/media/video/uvc] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

The linux/version.h include should either be kept in uvc_v4l2.c or moved to 
uvcvideo.h.

>   drivers/media/video/uvc/uvc_ctrl.c
>   drivers/media/video/uvc/uvc_driver.c

While you're at it, you can also remove linux/version.h from uvc_queue.c, 
uvc_status.c and uvc_video.c.

> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
>
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index d7bd71b..70ec240 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -12,7 +12,6 @@
>   */
>
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/usb.h>
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 6ef3e52..65bfa2f 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -12,7 +12,6 @@
>   */
>
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 7e10203..2d959aa 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -24,7 +24,6 @@
>   */
>
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/usb.h>

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

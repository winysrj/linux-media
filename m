Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8HFUqRk024269
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 11:30:52 -0400
Received: from mgw-mx09.nokia.com (smtp.nokia.com [192.100.105.134])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8HFUfPp029697
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 11:30:41 -0400
Message-ID: <48D1227D.5070207@nokia.com>
Date: Wed, 17 Sep 2008 18:30:05 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Hardik Shah <hardik.shah@ti.com>
References: <hardik.shah@ti.com>
	<1221663942-7160-1-git-send-email-hardik.shah@ti.com>
In-Reply-To: <1221663942-7160-1-git-send-email-hardik.shah@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-omap@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
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

Hi, Hardik!

ext Hardik Shah wrote:
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 2703c66..e899dd2 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -762,8 +762,6 @@ source "drivers/media/video/au0828/Kconfig"
> 
>  source "drivers/media/video/ivtv/Kconfig"
> 
> -source drivers/media/video/omap/Kconfig
> -
>  source "drivers/media/video/cx18/Kconfig"
> 
>  config VIDEO_M32R_AR
> @@ -802,6 +800,14 @@ config VIDEO_OMAP2
>  	---help---
>  	  Driver for an OMAP 2 camera controller.
> 
> +config VIDEO_OMAP3

This is the same configuration option as we are using for the OMAP 3 
camera driver at the moment.

Could you, for example, call this VIDEO_OMAP3_VIDEOOUT?

CONFIG_VIDEO_OMAP2 enables the OMAP 2 camera driver.

> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 3e580e8..10f879c 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -107,6 +107,8 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
>  obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
> 
>  obj-$(CONFIG_VIDEO_OMAP2) += omap24xxcam.o omap24xxcam-dma.o
> +obj-$(CONFIG_VIDEO_OMAP3) += omap/

It's just two C source code files --- how about putting them into the 
parent directory? The omap directory has just one driver in it, the OMAP 
1 camera driver. I think at some point it was intended to be moved to 
the parent directory although this hasn't happened.

Best regards,

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

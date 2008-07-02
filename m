Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m627Rabf013350
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 03:27:36 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m627ROtY019055
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 03:27:25 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KDwkI-0003Ul-1y
	for video4linux-list@redhat.com; Wed, 02 Jul 2008 07:27:18 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 07:27:18 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 02 Jul 2008 07:27:18 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Wed, 02 Jul 2008 10:27:12 +0300
Message-ID: <486B2DD0.7060903@teltonika.lt>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
	<20080701124657.30446.28078.sendpatchset@rx1.opensource.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080701124657.30446.28078.sendpatchset@rx1.opensource.se>
Cc: linux-sh@vger.kernel.org
Subject: Re: [PATCH 02/07] soc_camera: Let the host select videobuf_queue
 type
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

Magnus Damm wrote:
> This patch makes it possible for hosts (soc_camera drivers for the soc)
> to select a different videobuf queue than VIDEOBUF_DMA_SG. This is needed
> by the SuperH Mobile CEU hardware which requires physically contiguous
> buffers. While at it, rename the spinlock callbacks to file callbacks.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  drivers/media/video/Kconfig      |    4 ++--
>  drivers/media/video/pxa_camera.c |   15 ++++++++++++---
>  drivers/media/video/soc_camera.c |   27 +++++++--------------------
>  include/media/soc_camera.h       |    6 +++---
>  4 files changed, 24 insertions(+), 28 deletions(-)
> 
> --- 0001/drivers/media/video/Kconfig
> +++ work/drivers/media/video/Kconfig	2008-07-01 13:05:48.000000000 +0900
> @@ -901,8 +901,7 @@ endif # V4L_USB_DRIVERS
>  
>  config SOC_CAMERA
>  	tristate "SoC camera support"
> -	depends on VIDEO_V4L2 && HAS_DMA
> -	select VIDEOBUF_DMA_SG
> +	depends on VIDEO_V4L2

Bug here. You won't be able to compile soc_camera without host driver
or host driver as module. SOC_CAMERA has to select VIDEOBUF_GEN!

>  	help
>  	  SoC Camera is a common API to several cameras, not connecting
>  	  over a bus like PCI or USB. For example some i2c camera connected

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

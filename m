Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47251 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbeBWJFI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 04:05:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com,
        hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/1] videobuf2: Add VIDEOBUF2_V4L2 Kconfig option for videobuf2 V4L2 part
Date: Fri, 23 Feb 2018 11:05:53 +0200
Message-ID: <2740586.KYEUzdRcqz@avalon>
In-Reply-To: <20180223082946.7471-1-sakari.ailus@linux.intel.com>
References: <20180223082946.7471-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 23 February 2018 10:29:46 EET Sakari Ailus wrote:
> Videobuf2 is now separate from V4L2 and can be now built without it, at
> least in principle --- enabling videobuf2 in kernel configuration attempts
> to compile videobuf2-v4l2.c but that will fail if CONFIG_VIDEO_V4L2 isn't
> enabled.
> 
> Solve this by adding a separate Kconfig option for videobuf2-v4l2 and make
> it a separate module as well. This means that drivers now need to choose
> both the appropriate videobuf2 memory type
> (VIDEOBUF2_{VMALLOC,DMA_CONTIG,DMA_SG}) and VIDEOBUF2_V4L2 if they need
> both.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Mauro,
> 
> I'm proposing to merge this as it fixes build errors. We can later in
> rework the Kconfig options; the rework isn't related to fixing the build
> errors in general but rather is a change in the approach used to manage
> dependencies. Let's discuss that on #v4l.
> 
> since v1:
> 
> - Select VIDEOBUF2_V4L2 if both VIDEO_V4L2 and VIDEOBUF2_CORE are
>   selected. This way the patch no longer requires changing Kconfig entries
>   for effectively all drivers. In certain rare configurations (V4L2 and
>   VIDEOBUF2 are enabled but no V4L2 driver uses VIDEOBUF2) VIDEOBUF2_V4L2
>   could be enabled without it being needed. This is not really an issue
>   though.
> 
>  drivers/media/common/videobuf2/Kconfig  | 3 +++
>  drivers/media/common/videobuf2/Makefile | 3 ++-
>  drivers/media/v4l2-core/Kconfig         | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/Kconfig
> b/drivers/media/common/videobuf2/Kconfig index 5df05250de94..17c32ea58395
> 100644
> --- a/drivers/media/common/videobuf2/Kconfig
> +++ b/drivers/media/common/videobuf2/Kconfig
> @@ -3,6 +3,9 @@ config VIDEOBUF2_CORE
>  	select DMA_SHARED_BUFFER
>  	tristate
> 
> +config VIDEOBUF2_V4L2
> +	tristate
> +
>  config VIDEOBUF2_MEMOPS
>  	tristate
>  	select FRAME_VECTOR
> diff --git a/drivers/media/common/videobuf2/Makefile
> b/drivers/media/common/videobuf2/Makefile index 19de5ccda20b..7e27bdd44dcc
> 100644
> --- a/drivers/media/common/videobuf2/Makefile
> +++ b/drivers/media/common/videobuf2/Makefile
> @@ -1,5 +1,6 @@
> 
> -obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o videobuf2-v4l2.o
> +obj-$(CONFIG_VIDEOBUF2_CORE) += videobuf2-core.o
> +obj-$(CONFIG_VIDEOBUF2_V4L2) += videobuf2-v4l2.o
>  obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
>  obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
>  obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
> diff --git a/drivers/media/v4l2-core/Kconfig
> b/drivers/media/v4l2-core/Kconfig index bf52fbd07aed..8e37e7c5e0f7 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -7,6 +7,7 @@ config VIDEO_V4L2
>  	tristate
>  	depends on (I2C || I2C=n) && VIDEO_DEV
>  	select RATIONAL
> +	select VIDEOBUF2_V4L2 if VIDEOBUF2_CORE
>  	default (I2C || I2C=n) && VIDEO_DEV

I thought that if VIDEO_V4L2=y and VIDEOBUF2_CORE=m, this would set 
VIDEOBUF2_V4L2=y, but testing the patch proved me wrong.

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
>  config VIDEO_ADV_DEBUG

-- 
Regards,

Laurent Pinchart

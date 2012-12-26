Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab2LZMbu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 07:31:50 -0500
Date: Wed, 26 Dec 2012 10:31:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 1/2] v4l2: blackfin: convert ppi driver to a module
Message-ID: <20121226103109.576e70d3@redhat.com>
In-Reply-To: <1353440976-1112-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1353440976-1112-1-git-send-email-scott.jiang.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

Em Tue, 20 Nov 2012 14:49:35 -0500
Scott Jiang <scott.jiang.linux@gmail.com> escreveu:

Coul you please send us a patch adding you at MAINTAINERS for this driver?

Thanks!
Mauro

> Other drivers can make use of it.
> 
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
>  drivers/media/platform/blackfin/Kconfig  |    6 +++++-
>  drivers/media/platform/blackfin/Makefile |    4 ++--
>  drivers/media/platform/blackfin/ppi.c    |    7 +++++++
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
> index ecd5323..519990e 100644
> --- a/drivers/media/platform/blackfin/Kconfig
> +++ b/drivers/media/platform/blackfin/Kconfig
> @@ -2,9 +2,13 @@ config VIDEO_BLACKFIN_CAPTURE
>  	tristate "Blackfin Video Capture Driver"
>  	depends on VIDEO_V4L2 && BLACKFIN && I2C
>  	select VIDEOBUF2_DMA_CONTIG
> +	select VIDEO_BLACKFIN_PPI
>  	help
>  	  V4L2 bridge driver for Blackfin video capture device.
>  	  Choose PPI or EPPI as its interface.
>  
>  	  To compile this driver as a module, choose M here: the
> -	  module will be called bfin_video_capture.
> +	  module will be called bfin_capture.
> +
> +config VIDEO_BLACKFIN_PPI
> +	tristate
> diff --git a/drivers/media/platform/blackfin/Makefile b/drivers/media/platform/blackfin/Makefile
> index aa3a0a2..30421bc 100644
> --- a/drivers/media/platform/blackfin/Makefile
> +++ b/drivers/media/platform/blackfin/Makefile
> @@ -1,2 +1,2 @@
> -bfin_video_capture-objs := bfin_capture.o ppi.o
> -obj-$(CONFIG_VIDEO_BLACKFIN_CAPTURE) += bfin_video_capture.o
> +obj-$(CONFIG_VIDEO_BLACKFIN_CAPTURE) += bfin_capture.o
> +obj-$(CONFIG_VIDEO_BLACKFIN_PPI)     += ppi.o
> diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
> index d295921..9374d67 100644
> --- a/drivers/media/platform/blackfin/ppi.c
> +++ b/drivers/media/platform/blackfin/ppi.c
> @@ -17,6 +17,7 @@
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/slab.h>
>  
>  #include <asm/bfin_ppi.h>
> @@ -263,9 +264,15 @@ struct ppi_if *ppi_create_instance(const struct ppi_info *info)
>  	pr_info("ppi probe success\n");
>  	return ppi;
>  }
> +EXPORT_SYMBOL(ppi_create_instance);
>  
>  void ppi_delete_instance(struct ppi_if *ppi)
>  {
>  	peripheral_free_list(ppi->info->pin_req);
>  	kfree(ppi);
>  }
> +EXPORT_SYMBOL(ppi_delete_instance);
> +
> +MODULE_DESCRIPTION("Analog Devices PPI driver");
> +MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
> +MODULE_LICENSE("GPL v2");


-- 

Cheers,
Mauro

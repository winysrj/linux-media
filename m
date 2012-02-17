Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51439 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2BQSVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 13:21:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/7] media: video: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 19:19:24 +0100
Message-ID: <12313292.IcES5uVq6k@avalon>
In-Reply-To: <1329469034-25493-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <2218117.VoHfpPQjC4@avalon> <1329469034-25493-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patches.

On Friday 17 February 2012 10:57:07 Andy Shevchenko wrote:
> Without this we have got the warnings like following if build with "make W=1
> O=/var/tmp":
>    CHECK   drivers/media/video/videobuf-vmalloc.c
>    CC [M]  drivers/media/video/videobuf-vmalloc.o
>  +cc1: warning: drivers/media/dvb/dvb-core: No such file or directory
> [enabled by default] +cc1: warning: drivers/media/dvb/frontends: No such
> file or directory [enabled by default] +cc1: warning:
> drivers/media/dvb/dvb-core: No such file or directory [enabled by default]
> +cc1: warning: drivers/media/dvb/frontends: No such file or directory
> [enabled by default] LD      drivers/media/built-in.o
> 
> Some details could be found in [1] as well.
> 
> [1] http://comments.gmane.org/gmane.linux.kbuild.devel/7733
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/Makefile |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 3541388..3bf0aa8 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -199,6 +199,6 @@ obj-y	+= davinci/
> 
>  obj-$(CONFIG_ARCH_OMAP)	+= omap/
> 
> -ccflags-y += -Idrivers/media/dvb/dvb-core
> -ccflags-y += -Idrivers/media/dvb/frontends
> -ccflags-y += -Idrivers/media/common/tuners
> +ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
> +ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
> +ccflags-y += -I$(srctree)/drivers/media/common/tuners

-- 
Regards,

Laurent Pinchart

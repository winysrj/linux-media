Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37566 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2BPGWv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 01:22:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "linux-media @ vger . kernel . org" <linux-media@vger.kernel.org>,
	David Cohen <dacohen@gmail.com>
Subject: Re: [PATCH] media: video: append $(srctree) to -I parameters
Date: Thu, 16 Feb 2012 07:22:33 +0100
Message-ID: <2218117.VoHfpPQjC4@avalon>
In-Reply-To: <1329318481-8530-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1329318481-8530-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch.

On Wednesday 15 February 2012 17:08:01 Andy Shevchenko wrote:
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

There are several occurencies if the same issue throughout drivers/. Could you 
send a patch that fixes them all in one go ?
 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

The above link mentions $(src). Is that different than $(srctree) ?

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37270 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0G3NpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 09:45:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [media-ctl PATCH 2/3] Just include kernel headers
Date: Fri, 30 Jul 2010 15:45:06 +0200
Cc: linux-media@vger.kernel.org
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com> <1279124246-12187-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1279124246-12187-3-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007301545.07534.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Wednesday 14 July 2010 18:17:25 Sergio Aguirre wrote:
> We shouldn't require full kernel source for this.

That's right in theory, but I then get

$ make KDIR=/home/laurent/src/arm/kernel/
arm-none-linux-gnueabi-gcc -O2 -Wall -fpic -I. -I/home/laurent/src/arm/kernel//include    -c -o media.o media.c
In file included from /opt/cs/arm-2009q1/bin/../arm-none-linux-gnueabi/libc/usr/include/asm/types.h:4,
                 from /home/laurent/src/arm/kernel//include/linux/types.h:4,
                 from /home/laurent/src/arm/kernel//include/linux/videodev2.h:66,
                 from media.c:31:
/home/laurent/src/arm/kernel//include/asm-generic/int-ll64.h:11:29: error: asm/bitsperlong.h: No such file or directory
make: *** [media.o] Error 1

when building against a kernel tree.

> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  Makefile |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index bf4cf55..300ed7e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,11 +1,9 @@
> -SRCARCH ?= arm
>  CROSS_COMPILE ?= arm-none-linux-gnueabi-
> -KDIR ?= /usr/src/linux
> +HDIR ?= /usr/include
> 
> -KINC := -I$(KDIR)/include -I$(KDIR)/arch/$(SRCARCH)/include
>  CC   := $(CROSS_COMPILE)gcc
> 
> -CFLAGS = -O2 -Wall -fpic -I. $(KINC)
> +CFLAGS = -O2 -Wall -fpic -I$(HDIR)
>  OBJS = media.o main.o options.o subdev.o
> 
>  all: media-ctl

-- 
Regards,

Laurent Pinchart

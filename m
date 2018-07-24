Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388142AbeGXEps (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 00:45:48 -0400
Date: Tue, 24 Jul 2018 00:41:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] media: staging: omap4iss: Include asm/cacheflush.h
 after generic includes
Message-ID: <20180724004110.37d0e5dc@coco.lan>
In-Reply-To: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
References: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Jul 2018 14:39:33 -0700
Guenter Roeck <linux@roeck-us.net> escreveu:

> Including asm/cacheflush.h first results in the following build error when
> trying to build sparc32:allmodconfig.
> 
> In file included from arch/sparc/include/asm/page.h:10:0,
>                  from arch/sparc/include/asm/string_32.h:13,
>                  from arch/sparc/include/asm/string.h:7,
>                  from include/linux/string.h:20,
>                  from include/linux/bitmap.h:9,
>                  from include/linux/cpumask.h:12,
>                  from arch/sparc/include/asm/smp_32.h:15,
>                  from arch/sparc/include/asm/smp.h:7,
>                  from arch/sparc/include/asm/switch_to_32.h:5,
>                  from arch/sparc/include/asm/switch_to.h:7,
>                  from arch/sparc/include/asm/ptrace.h:120,
>                  from arch/sparc/include/asm/thread_info_32.h:19,
>                  from arch/sparc/include/asm/thread_info.h:7,
>                  from include/linux/thread_info.h:38,
>                  from arch/sparc/include/asm/current.h:15,
>                  from include/linux/mutex.h:14,
>                  from include/linux/notifier.h:14,
>                  from include/linux/clk.h:17,
>                  from drivers/staging/media/omap4iss/iss_video.c:15:
> include/linux/highmem.h: In function 'clear_user_highpage':
> include/linux/highmem.h:137:31: error:
> 	passing argument 1 of 'sparc_flush_page_to_ram' from incompatible
> 	pointer type
> 
> Include generic includes files first to fix the problem.
> 
> Fixes: fc96d58c10162 ("[media] v4l: omap4iss: Add support for OMAP4 camera interface - Video devices")
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/staging/media/omap4iss/iss_video.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index a3a83424a926..16478fe9e3f8 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -11,7 +11,6 @@
>   * (at your option) any later version.
>   */
>  
> -#include <asm/cacheflush.h>
>  #include <linux/clk.h>
>  #include <linux/mm.h>
>  #include <linux/pagemap.h>
> @@ -24,6 +23,8 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-mc.h>
>  
> +#include <asm/cacheflush.h>
> +
>  #include "iss_video.h"
>  #include "iss.h"

While I won't be against merging it, IMHO a better fix would be to
add the includes asm/cacheflush.h needs inside it, e. g. something
like adding:

	#include <linux/highmem.h>

at the sparc32 variant of it. Btw, ./arch/sparc/include/asm/cacheflush_64.h
seems to include linux/mm.h... So, I guess the right fix would
be something like:

diff --git a/arch/sparc/include/asm/cacheflush_32.h b/arch/sparc/include/asm/cacheflush_32.h
index fb66094a2c30..daeccbdc371a 100644
--- a/arch/sparc/include/asm/cacheflush_32.h
+++ b/arch/sparc/include/asm/cacheflush_32.h
@@ -2,6 +2,8 @@
 #ifndef _SPARC_CACHEFLUSH_H
 #define _SPARC_CACHEFLUSH_H
 
+#include <linux/mm.h>
+
 #include <asm/cachetlb_32.h>
 
 #define flush_cache_all() \



Thanks,
Mauro

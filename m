Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:34662 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1CZEdG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 00:33:06 -0400
Date: Fri, 25 Mar 2011 23:33:04 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Dan Carpenter <error27@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Mike Isely <isely@isely.net>
Subject: Re: [PATCH 2/6] [media] pvrusb2: fix remaining checkpatch.pl
 complaints
In-Reply-To: <20110326015112.GG2008@bicker>
Message-ID: <alpine.DEB.1.10.1103252332110.12072@ivanova.isely.net>
References: <20110326015112.GG2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


I am OK with the #include change, but NOT the if-statement change.  But 
since it's bundled into one patch...

Nacked-By: Mike Isely <isely@pobox.com>


On Sat, 26 Mar 2011, Dan Carpenter wrote:

> * Include <linux/string.h> instead of <asm/string.h>.
> * Remove unneeded curly braces.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
> index a5d4867..370a9ab 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
> @@ -20,7 +20,7 @@
>  
>  #include "pvrusb2-std.h"
>  #include "pvrusb2-debug.h"
> -#include <asm/string.h>
> +#include <linux/string.h>
>  #include <linux/slab.h>
>  
>  struct std_name {
> @@ -294,9 +294,8 @@ static struct v4l2_standard *match_std(v4l2_std_id id)
>  	unsigned int idx;
>  
>  	for (idx = 0; idx < generic_standards_cnt; idx++) {
> -		if (generic_standards[idx].id & id) {
> +		if (generic_standards[idx].id & id)
>  			return generic_standards + idx;
> -		}
>  	}
>  	return NULL;
>  }
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

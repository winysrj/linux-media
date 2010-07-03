Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:52928 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab0GCWs7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 18:48:59 -0400
Date: Sat, 3 Jul 2010 17:43:32 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Julia Lawall <julia@diku.dk>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Mike Isely <isely@isely.net>
Subject: Re: [git:v4l-dvb/other] V4L/DVB: drivers/media/video/pvrusb2: Add
 missing mutex_unlock
In-Reply-To: <E1OV9yX-0006Dg-H2@www.linuxtv.org>
Message-ID: <alpine.DEB.1.10.1007031733360.19299@cnc.isely.net>
References: <E1OV9yX-0006Dg-H2@www.linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro:

FYI, I posted an "Acked-By: Mike Isely <isely@pobox.com>" weeks ago, 
back on 27-May, immediately after the patch was posted.  It's a great 
catch, and the bug has been there since basically the beginning of the 
driver.  Was I ever supposed to see any kind of reaction to that ack 
(e.g. having the "Acked-By" added to the patch)?  I had posted it in 
reply to the original patch, copied back to the patch author, to lkml, 
to linux-media, kernel-janitors, and Mauro.

  -Mike


On Sat, 3 Jul 2010, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/v4l-dvb.git tree:
> 
> Subject: V4L/DVB: drivers/media/video/pvrusb2: Add missing mutex_unlock
> Author:  Julia Lawall <julia@diku.dk>
> Date:    Tue Jun 29 01:42:53 2010 -0300
> 
> Add a mutex_unlock missing on the error path.  In the other functions in
> the same file the locks and unlocks of this mutex appear to be balanced,
> so it would seem that the same should hold in this case.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * mutex_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * mutex_unlock(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
> Cc: Mike Isely <isely@isely.net>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/pvrusb2/pvrusb2-ioread.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=ccbc746b6bc3662b11679c75d1793753228ae67a
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-ioread.c b/drivers/media/video/pvrusb2/pvrusb2-ioread.c
> index b482478..bba6115 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-ioread.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-ioread.c
> @@ -223,7 +223,10 @@ int pvr2_ioread_setup(struct pvr2_ioread *cp,struct pvr2_stream *sp)
>  				   " pvr2_ioread_setup (setup) id=%p",cp);
>  			pvr2_stream_kill(sp);
>  			ret = pvr2_stream_set_buffer_count(sp,BUFFER_COUNT);
> -			if (ret < 0) return ret;
> +			if (ret < 0) {
> +				mutex_unlock(&cp->mutex);
> +				return ret;
> +			}
>  			for (idx = 0; idx < BUFFER_COUNT; idx++) {
>  				bp = pvr2_stream_get_buffer(sp,idx);
>  				pvr2_buffer_set_buffer(bp,
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m82JhKco018605
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 15:43:21 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m82Jh8ss003183
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 15:43:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 2 Sep 2008 21:42:04 +0200
References: <1218324197.24441.20.camel@brick> <1220380552.2137.3.camel@brick>
	<1220381401.2137.6.camel@brick>
In-Reply-To: <1220381401.2137.6.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809022142.04578.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [BUILDFIX] byteorder: remove direct byteorder includes
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

Hi Harvey,

On Tuesday 02 September 2008 20:50:00 Harvey Harrison wrote:
> All of the functionality has been collected in linux/swab.h
> 
> Needed to prevent build brakage as arches start moving over
> to the new byteorder implementation.

1) With this patch the i686, x86_64 and powerpc64 build fail on 
av7110.c, as I said in my original mail. Do you have additional patches 
that address this?

2) For the cx18, ivtv and vpx3220 please just remove the swabb.h 
include: it's either not really needed or included through another 
include. The v4l-dvb master repository has been updated to just remove 
these linux/byteorder/swabb.h includes in these three sources.

Regards,

	Hans

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Sorry, I only sent you half-a-patch in my last message, this is the
> full patch needed.
> 
>  drivers/media/dvb/ttpci/av7110.c       |    2 +-
>  drivers/media/video/cx18/cx18-driver.h |    2 +-
>  drivers/media/video/ivtv/ivtv-driver.h |    2 +-
>  drivers/media/video/vpx3220.c          |    2 +-
>  kernel/rcupreempt.c                    |    2 +-
>  tests/rcutorture.c                     |    2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/dvb/ttpci/av7110.c
> b/drivers/media/dvb/ttpci/av7110.c
> index c0a1746..792a175 100644
> --- a/drivers/media/dvb/ttpci/av7110.c
> +++ b/drivers/media/dvb/ttpci/av7110.c
> @@ -36,7 +36,7 @@
>  #include <linux/fs.h>
>  #include <linux/timer.h>
>  #include <linux/poll.h>
> -#include <linux/byteorder/swabb.h>
> +#include <linux/swab.h>
>  #include <linux/smp_lock.h>
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/media/video/cx18/cx18-driver.h
> b/drivers/media/video/cx18/cx18-driver.h
> index 2635989..8787a5f 100644
> --- a/drivers/media/video/cx18/cx18-driver.h
> +++ b/drivers/media/video/cx18/cx18-driver.h
> @@ -38,7 +38,7 @@
>  #include <linux/i2c-algo-bit.h>
>  #include <linux/list.h>
>  #include <linux/unistd.h>
> -#include <linux/byteorder/swab.h>
> +#include <linux/swab.h>
>  #include <linux/pagemap.h>
>  #include <linux/workqueue.h>
>  #include <linux/mutex.h>
> diff --git a/drivers/media/video/ivtv/ivtv-driver.h
> b/drivers/media/video/ivtv/ivtv-driver.h
> index 2ceb522..2213473 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.h
> +++ b/drivers/media/video/ivtv/ivtv-driver.h
> @@ -49,7 +49,7 @@
>  #include <linux/i2c-algo-bit.h>
>  #include <linux/list.h>
>  #include <linux/unistd.h>
> -#include <linux/byteorder/swab.h>
> +#include <linux/swab.h>
>  #include <linux/pagemap.h>
>  #include <linux/scatterlist.h>
>  #include <linux/workqueue.h>
> diff --git a/drivers/media/video/vpx3220.c
> b/drivers/media/video/vpx3220.c
> index 3529302..6828411 100644
> --- a/drivers/media/video/vpx3220.c
> +++ b/drivers/media/video/vpx3220.c
> @@ -24,7 +24,7 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  
> -#include <linux/byteorder/swab.h>
> +#include <linux/swab.h>
>  
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index ca4bbbe..494d0e8 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -54,7 +54,7 @@
>  #include <linux/cpu.h>
>  #include <linux/random.h>
>  #include <linux/delay.h>
> -#include <linux/byteorder/swabb.h>
> +#include <linux/swab.h>
>  #include <linux/cpumask.h>
>  #include <linux/rcupreempt_trace.h>
>  
> diff --git a/tests/rcutorture.c b/tests/rcutorture.c
> index 90b5b12..67856af 100644
> --- a/tests/rcutorture.c
> +++ b/tests/rcutorture.c
> @@ -42,7 +42,7 @@
>  #include <linux/freezer.h>
>  #include <linux/cpu.h>
>  #include <linux/delay.h>
> -#include <linux/byteorder/swabb.h>
> +#include <linux/swab.h>
>  #include <linux/stat.h>
>  #include <linux/srcu.h>
>  #include <linux/slab.h>
> -- 
> 1.6.0.1.400.ga23d3
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

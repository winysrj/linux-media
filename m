Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n057Lg0T005147
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 02:21:43 -0500
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n057LSBf008587
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 02:21:28 -0500
Date: Sun, 4 Jan 2009 23:20:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Message-Id: <20090104232057.c91b1452.akpm@linux-foundation.org>
In-Reply-To: <33812.1230893486@turing-police.cc.vt.edu>
References: <33812.1230893486@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: 2.6.28-mmotm1230 - include/media/v4l2-ioctl.h prototype mismatch
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

On Fri, 02 Jan 2009 05:51:26 -0500 Valdis.Kletnieks@vt.edu wrote:

> I'm seeing the following warning message during a kernel build:
> 
>   CC [M]  drivers/media/video/gspca/gspca.o
> drivers/media/video/gspca/gspca.c:1811: warning: initialization from incompatible pointer type
> 
> The root cause appears to be a missed prototype change in a conversion from
> ioctl to unlocked_ioctl - in struct file_operations, the former is an int,
> but the latter is a long.  So we clean it up.
> 
> I have to admit not having checked deeply for second-order effects, but the
> kernel builds without warnings and the result works for me.  The only other
> use of __video_ioctl2 I can see is in drivers/media/video/ivtv/ivtv-ioctl.c,
> and there it's used as a return value from a function already defined to return
> a long, so we save an int->long cast...
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> --- linux-2.6.28-mmotm1230/include/media/v4l2-ioctl.h.dist	2009-01-01 17:23:00.000000000 -0500
> +++ linux-2.6.28-mmotm1230/include/media/v4l2-ioctl.h	2009-01-02 05:40:45.000000000 -0500
> @@ -297,7 +297,7 @@ extern int video_usercopy(struct file *f
>  /* Standard handlers for V4L ioctl's */
>  
>  /* This prototype is used on fops.unlocked_ioctl */
> -extern int __video_ioctl2(struct file *file,
> +extern long __video_ioctl2(struct file *file,
>  			unsigned int cmd, unsigned long arg);
>  
>  /* This prototype is used on fops.ioctl
> --- linux-2.6.28-mmotm1230/drivers/media/video/v4l2-ioctl.c.dist	2009-01-01 17:22:50.000000000 -0500
> +++ linux-2.6.28-mmotm1230/drivers/media/video/v4l2-ioctl.c	2009-01-02 05:45:39.000000000 -0500
> @@ -1852,7 +1852,7 @@ static int __video_do_ioctl(struct file 
>  	return ret;
>  }
>  
> -int __video_ioctl2(struct file *file,
> +long __video_ioctl2(struct file *file,
>  	       unsigned int cmd, unsigned long arg)
>  {
>  	char	sbuf[128];

That code seems to have magically disappeared from linux-next.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

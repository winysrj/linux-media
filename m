Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBNKGqon016706
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 15:16:52 -0500
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBNKGfvd031279
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 15:16:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 23 Dec 2008 21:16:37 +0100
References: <1230062078.1699.56.camel@localhost>
In-Reply-To: <1230062078.1699.56.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812232116.38027.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH] Wrong returned value of __video_ioctl2()
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

On Tuesday 23 December 2008 20:54:38 Jean-Francois Moine wrote:
> This patch suppresses the warning on setting the dev_fops unlocked_ioctl
> function to __video_ioctl2.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Hi Jean-Francois,

This patch clashes with an other pull request from me where the whole 
__video_ioctl2 function disappears.

But the prototype is indeed wrong and so I will go through my code and 
ensure that all the ioctl return types are long.

Thank you for bringing this to our attention and I'll make sure to fix these 
prototypes.

Regards,

	Hans

>
> diff -r c7b89ff3a3df linux/drivers/media/video/v4l2-ioctl.c
> --- a/linux/drivers/media/video/v4l2-ioctl.c	Tue Dec 23 19:57:17 2008
> +0100 +++ b/linux/drivers/media/video/v4l2-ioctl.c	Tue Dec 23 20:42:08
> 2008 +0100 @@ -1853,7 +1853,7 @@
>  	return ret;
>  }
>
> -int __video_ioctl2(struct file *file,
> +long __video_ioctl2(struct file *file,
>  	       unsigned int cmd, unsigned long arg)
>  {
>  	char	sbuf[128];
> diff -r c7b89ff3a3df linux/include/media/v4l2-ioctl.h
> --- a/linux/include/media/v4l2-ioctl.h	Tue Dec 23 19:57:17 2008 +0100
> +++ b/linux/include/media/v4l2-ioctl.h	Tue Dec 23 20:42:08 2008 +0100
> @@ -297,7 +297,7 @@
>  /* Standard handlers for V4L ioctl's */
>
>  /* This prototype is used on fops.unlocked_ioctl */
> -extern int __video_ioctl2(struct file *file,
> +extern long __video_ioctl2(struct file *file,
>  			unsigned int cmd, unsigned long arg);
>
>  /* This prototype is used on fops.ioctl



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

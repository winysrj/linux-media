Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m694tBnn030765
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 00:55:11 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m694sR9p032181
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 00:54:28 -0400
Message-ID: <48744036.506@hhs.nl>
Date: Wed, 09 Jul 2008 06:36:06 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
References: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
In-Reply-To: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix kobj ref count
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

David Ellingsworth wrote:
> Mauro,
> 
> If Laurent approves, please apply the following patch to the devel
> branch. I've been using it locally for the past five days or so
> without issue.
> 
> This patch increments the kobject reference count during video_open
> and decrements it during video_close. Doing so allows
> video_unregister_device to be called during the disconnect callback of
> usb and pci devices. It also ensures that the video_device struct is
> not freed while it is still in use and that the kobject release
> callback occurs at the appropriate time. With this patch, the
> following sequence is now possible and no longer results in a crash.
> 
> video_open
>   disconnect
>     video_unregister_device
>       video_ioctl2 (crash was here)
>         video_close
>           video_release
> 

I like this patch, I really do, as currently this refcounting needs to 
be done in all v4l devices seperately, and an video_ioctl2 wrapper needs 
to be used to stop the crash (check if device was disconnected and thus 
video_unregister_device was called and ifso don't call video_ioctl2).

So I've taken a good look and this, and I cannot find any issues.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

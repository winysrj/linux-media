Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n04KWrLR010100
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 15:32:53 -0500
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n04KWdHB030796
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 15:32:39 -0500
Date: Sun, 4 Jan 2009 12:32:37 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: matthieu castet <castet.matthieu@free.fr>
In-Reply-To: <495FCA60.5060008@free.fr>
Message-ID: <Pine.LNX.4.58.0901041226330.25853@shell2.speakeasy.net>
References: <495FCA60.5060008@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: v4l1 doesn't work anymore with bttv on 2.6.26
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

On Sat, 3 Jan 2009, matthieu castet wrote:
> This is a copy of the bugreport i did on debian bugtracker :
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=510621
>
> I got a v4l1 application that worked for years.
> With the current kernel, it hangs in a state where VIDIOCMCAPTURE always
> return -EBUSY.
>
> After some debug, it seems that VIDIOCMCAPTURE fails the first time
> because of videobuf_queue_is_busy 'vbuf: busy: buffer #0 mapped'.

Around that time frame the bttv driver was converted from having native
v4l1 support to using the v4l1->v4l2 compat module.  The bttv driver
supported a non-standard v4l1 buffer allocation method were there buffers
get allocated or resized in the MCAPTURE ioctl and the v4l1 compat module
doesn't support this.  I bet this is what your problem is.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

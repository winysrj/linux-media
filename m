Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63Kaccx008674
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:36:38 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63KaQra008183
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:36:26 -0400
Date: Thu, 3 Jul 2008 22:36:23 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080703203623.GI18818@vidsoft.de>
References: <4867F380.1040803@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4867F380.1040803@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: Announcing libv4l 0.3.1 aka "the vlc release"
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

Hi,

I've just included libv4l2 in our app. After after a short debugging
session I noticed the following:

In the man page the ioctl prototype is defined as
int ioctl(int d, int request, ...). To catch the EINTR case I wrote a
wrapper function:

int xioctl (int fd, int request, void *arg)

But as long as the request argument is int instead of unsigned long, the
request gets sign extended:

xioctl (fd, VIDIOC_TRY_FMT, &fmt)
(gdb) p/x request
$2 = 0xc0d05640

int v4l2_ioctl (int fd, unsigned long int request, ...);
(gdb) p/x request
$3 = 0xffffffffc0d05640

Maybe you should mention this "issue" in the FAQ or documentaion.

Cheers,
Gregor

PS: Should I submit the sar-constraint patch to Thierry myself?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

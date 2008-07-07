Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67LrsLc010525
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 17:53:54 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67LrgTu012609
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 17:53:42 -0400
Message-ID: <48729200.1090304@hhs.nl>
Date: Tue, 08 Jul 2008 00:00:32 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Gregor Jasny <jasny@vidsoft.de>
References: <4867F380.1040803@hhs.nl> <20080703203623.GI18818@vidsoft.de>
In-Reply-To: <20080703203623.GI18818@vidsoft.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Gregor Jasny wrote:
> Hi,
> 
> I've just included libv4l2 in our app. After after a short debugging
> session I noticed the following:
> 
> In the man page the ioctl prototype is defined as
> int ioctl(int d, int request, ...). To catch the EINTR case I wrote a
> wrapper function:
> 
> int xioctl (int fd, int request, void *arg)
> 
> But as long as the request argument is int instead of unsigned long, the
> request gets sign extended:
> 
> xioctl (fd, VIDIOC_TRY_FMT, &fmt)
> (gdb) p/x request
> $2 = 0xc0d05640
> 
> int v4l2_ioctl (int fd, unsigned long int request, ...);
> (gdb) p/x request
> $3 = 0xffffffffc0d05640
> 
> Maybe you should mention this "issue" in the FAQ or documentaion.
> 

Thanks for reporting this, this has saved me quite some time while debugging 
issues with xawtv and kopete. I believe that the upper 32 bits added by this 
(obviously wrong code) get thrown away somewhere down the path to the kernel on 
64 bit archs, so I've modified libv4l to just ignore the upper 32 bits to match 
this behavior.

Regards,

Hans

> PS: Should I submit the sar-constraint patch to Thierry myself?

Nope I was just being slow, just like with answering this. Thanks for the 
testing and the patches!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

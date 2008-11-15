Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFKxwZ6030611
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 15:59:58 -0500
Received: from QMTA04.westchester.pa.mail.comcast.net
	(qmta04.westchester.pa.mail.comcast.net [76.96.62.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFKxibE002750
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 15:59:44 -0500
Message-ID: <491F3840.4030301@personnelware.com>
Date: Sat, 15 Nov 2008 14:59:44 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <491CB0A6.9080509@personnelware.com>
In-Reply-To: <491CB0A6.9080509@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: minimum v4l2 api - framework
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

Tomorrow (Nov 16) I will be at a Linuxfest, where I am going to try to find
someone up for writing this driver.

I am assuming there is some code they should use as a starting point.
Either
A) "This is the generic/abstract code that can be extended to make a
specific/concrete driver" (what I would call a framework)
B) "driver foo.c is a good example of how a V4L2 driver should be written; copy
it and swap out the hardware specific code."
C) "vivi.c is close enough.  you should really just work on fixing it."

I am hoping the correct answer is:
http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/file/6292505ca617/linux/Documentation/video4linux/v4l2-framework.txt

If someone can give me a rough stub to start with, that would make tomorrow's
work more promising.

Carl K


Carl Karsten wrote:
> Apparently vivi is messed up enough that maybe it makes sense to write a new
> test driver.
> 
> What is the minimum interface a v4l2 driver could have?
> 
> Something like: it registers itself as /dev/videoN, and
> QueryCaps returns nothing.
> It does not return any image. (yeah ?)
> It can be unloaded.
> 
> and anything else that someone thinks is required for a well behaved driver that
> follows the spec.
> 
> The plan is to start with that, get it and my tester working in harmony, then
> start adding things to both sides of the fence.  I am thinking additional
> features will be enabled via module parameters, so that it can always be dumbed
> down back to it's minimum.
> 
> Carl K
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

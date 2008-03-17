Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2H17Qfl028104
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:07:26 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2H16sK9016386
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:06:54 -0400
Message-ID: <47DDC428.1060306@linuxtv.org>
Date: Sun, 16 Mar 2008 21:06:48 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Ben Caldwell <benny.caldwell@gmail.com>
References: <1dea8a6d0803161804u1eef6c50uc86c0aa7e1dd2da8@mail.gmail.com>
In-Reply-To: <1dea8a6d0803161804u1eef6c50uc86c0aa7e1dd2da8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: tuner-types.h symlink
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

Ben Caldwell wrote:
> This is my first post on the v4l list, so hi everyone!
> 
> I just got a warning compiling the latest v4l source from mercurial, there
> was a missing symbol "tuner_count" in "tuner-simple.ko"
> 
> I fixed the problem by adding a symlink in v4l-dvb/v4l:
> 
> *$ ln -s ../linux/include/media/tuner-types.h  tuner-types.h*
> **
> I'm hoping that someone here can check that this is indeed the right thing
> to do and commit a change to the repository for me if it is.

Which module's build produced this warning?  Can you show us the warning?

-Mike


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

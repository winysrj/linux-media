Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2H14wip027052
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:04:58 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2H14ScK014978
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:04:28 -0400
Received: by wf-out-1314.google.com with SMTP id 28so4933873wfc.6
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 18:04:27 -0700 (PDT)
Message-ID: <1dea8a6d0803161804u1eef6c50uc86c0aa7e1dd2da8@mail.gmail.com>
Date: Mon, 17 Mar 2008 10:04:27 +0900
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: V4L <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: tuner-types.h symlink
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

This is my first post on the v4l list, so hi everyone!

I just got a warning compiling the latest v4l source from mercurial, there
was a missing symbol "tuner_count" in "tuner-simple.ko"

I fixed the problem by adding a symlink in v4l-dvb/v4l:

*$ ln -s ../linux/include/media/tuner-types.h  tuner-types.h*
**
I'm hoping that someone here can check that this is indeed the right thing
to do and commit a change to the repository for me if it is.

Thanks,

Ben Caldwell
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

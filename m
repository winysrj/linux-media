Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8LKGncs020510
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 16:16:49 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8LKGlVb010476
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 16:16:48 -0400
Received: by gxk8 with SMTP id 8so2281795gxk.3
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 13:16:47 -0700 (PDT)
Message-ID: <9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
Date: Sun, 21 Sep 2008 13:16:47 -0700
From: "Scott Bronson" <bronson@rinspin.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48D49A39.5010909@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<412bdbff0809191428j760ed51cy8fecd68e1cb738a4@mail.gmail.com>
	<9d87242f0809192005t246311dp796aa28cb744b3af@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
	<48D49A39.5010909@linuxtv.org>
Cc: video4linux-list@redhat.com
Subject: Re: Unreliable tuning with HVR-950q
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

On Fri, Sep 19, 2008 at 11:37 PM, Steven Toth <stoth@linuxtv.org> wrote:
> I guess it's possible that the frontend is being overwhelmed. What happens
> if you discinnect the antenna and hold it very close to the antenna
> connector on the usb device and try locking on a channel that doesn't
> normally lock (on a very close transmitter).

Yes, that does seem to help.  I can't find a distance that gives locks
100% of the time, but 1mm distance seems to take it from 50% to
80-90%.

It seems to always get a lock if I just keep trying.  I just quickly
keep hitting return and escape until I get a picture.  It rarely takes
more than 3 attempts.  However, if I just leave it alone as it tries
tune, it will sit there forever (well, at least 1/2 hour) and never
get it.

Thanks, tell me if there's anything more I can do.

    - Scott

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

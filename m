Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MJEZ5W017182
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 15:14:35 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MJDiSq020810
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 15:14:25 -0400
Received: by mail-gx0-f15.google.com with SMTP id 8so3390666gxk.3
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 12:14:25 -0700 (PDT)
Message-ID: <9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
Date: Mon, 22 Sep 2008 12:06:29 -0700
From: "Scott Bronson" <bronson@rinspin.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48D702B5.8020800@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<412bdbff0809191428j760ed51cy8fecd68e1cb738a4@mail.gmail.com>
	<9d87242f0809192005t246311dp796aa28cb744b3af@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
	<48D49A39.5010909@linuxtv.org>
	<9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
	<48D702B5.8020800@linuxtv.org>
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

On Sun, Sep 21, 2008 at 7:28 PM, Steven Toth <stoth@linuxtv.org> wrote:
> This is really starting to sound like a signal level issue. Try attenuating,
> this will probably help. Radio shack probably have a selection of 5 and 10db
> inline connectors that should help.

I'll try that.  It will attenuate distant stations too, right?  I
might have to buy two tuners, one for close stations and one for far
away ones...?

> This isn't something that we can compensate for in software.

I'm not sure about that...  Rapidly re-trying seems to always produce
a lock.  I suppose the driver could do that automatically when needed.
 (yes it's a hack, but drivers have always needed to hack around
hardware limitations)

Is there any way to log the tuning metrics, like signal and noise
level, etc?  There may be a pattern here.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

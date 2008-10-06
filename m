Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96FvWUx017151
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 11:57:32 -0400
Received: from mta2.srv.hcvlny.cv.net (mta2.srv.hcvlny.cv.net [167.206.4.197])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96FvAJM023554
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 11:57:10 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8B003YEQZ9BFB0@mta2.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Mon, 06 Oct 2008 11:57:10 -0400 (EDT)
Date: Mon, 06 Oct 2008 11:57:09 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <412bdbff0810060853k6925b37ax6801943d6b31bf61@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-id: <48EA3555.6060104@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
	<48D702B5.8020800@linuxtv.org>
	<9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
	<48D7F064.4010103@linuxtv.org>
	<9d87242f0809222335l67860769k6369db5665b10f98@mail.gmail.com>
	<48D907BB.4020801@linuxtv.org>
	<9d87242f0809260952h7542a051ud6d539269638d6b4@mail.gmail.com>
	<9d87242f0810011146r7c2b2083pdd7d940f4c427382@mail.gmail.com>
	<48EA3216.90407@linuxtv.org>
	<412bdbff0810060853k6925b37ax6801943d6b31bf61@mail.gmail.com>
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

Devin Heitmueller wrote:
> Hello Steven,
> 
> On Mon, Oct 6, 2008 at 11:43 AM, Steven Toth <stoth@linuxtv.org> wrote:
>>> Does anybody else have a 950q?  Does it work?  To me, it appears that
>>> either its tuner is junk or the Linux driver needs some work.  I guess
>>> my next step is to set up a Windows machine and try it there.
>> We _do_ have rock solid HVR950q support for digital, on lots of platforms in
>> various locations.
>>
>> Based on the facts so far it's probably something specific to your stick,
>> your location or your testing. Try windows and report back if you can.
> 
> Just an FYI:  I'm actively debugging an issue with xc5000 signal lock
> that looks like some sort of timing issue.  I found that some fixes I
> made in my local tree to optimize time to lock resulted in getting
> lock *much* faster in many cases, but failing entirely in others.
> When it works, I get lock in 330ms; when it fails I don't get lock
> even when polling the demod at 100ms interval for 2 seconds.
> 
> I'm doing this on a Pinnacle 801e (xc5000/s5h1411) and not a HVR-950q,
> but it's possible it's the same issue.
> 
> Will report back when I have isolated the problem.

Good to know, thanks Devin.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96Frhag014495
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 11:53:43 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96FrVmE021813
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 11:53:31 -0400
Received: by ug-out-1314.google.com with SMTP id o38so1529014ugd.13
	for <video4linux-list@redhat.com>; Mon, 06 Oct 2008 08:53:30 -0700 (PDT)
Message-ID: <412bdbff0810060853k6925b37ax6801943d6b31bf61@mail.gmail.com>
Date: Mon, 6 Oct 2008 11:53:30 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48EA3216.90407@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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

Hello Steven,

On Mon, Oct 6, 2008 at 11:43 AM, Steven Toth <stoth@linuxtv.org> wrote:
>> Does anybody else have a 950q?  Does it work?  To me, it appears that
>> either its tuner is junk or the Linux driver needs some work.  I guess
>> my next step is to set up a Windows machine and try it there.
>
> We _do_ have rock solid HVR950q support for digital, on lots of platforms in
> various locations.
>
> Based on the facts so far it's probably something specific to your stick,
> your location or your testing. Try windows and report back if you can.

Just an FYI:  I'm actively debugging an issue with xc5000 signal lock
that looks like some sort of timing issue.  I found that some fixes I
made in my local tree to optimize time to lock resulted in getting
lock *much* faster in many cases, but failing entirely in others.
When it works, I get lock in 330ms; when it fails I don't get lock
even when polling the demod at 100ms interval for 2 seconds.

I'm doing this on a Pinnacle 801e (xc5000/s5h1411) and not a HVR-950q,
but it's possible it's the same issue.

Will report back when I have isolated the problem.

Regards,

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

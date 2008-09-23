Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NFEFY0010124
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 11:14:16 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8NFE7IA008515
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 11:14:07 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7N00GWSMBGS990@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Tue, 23 Sep 2008 11:14:05 -0400 (EDT)
Date: Tue, 23 Sep 2008 11:14:03 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <9d87242f0809222335l67860769k6369db5665b10f98@mail.gmail.com>
To: Scott Bronson <bronson@rinspin.com>
Message-id: <48D907BB.4020801@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<412bdbff0809191428j760ed51cy8fecd68e1cb738a4@mail.gmail.com>
	<9d87242f0809192005t246311dp796aa28cb744b3af@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
	<48D49A39.5010909@linuxtv.org>
	<9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
	<48D702B5.8020800@linuxtv.org>
	<9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
	<48D7F064.4010103@linuxtv.org>
	<9d87242f0809222335l67860769k6369db5665b10f98@mail.gmail.com>
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

Scott Bronson wrote:
> On Mon, Sep 22, 2008 at 12:22 PM, Steven Toth <stoth@linuxtv.org> wrote:
>> Watch the SNR value, it's measures in db and expressed in hex with one
>> decimal place. So, 0x102 = 25.8db
> 
> OK.  Watching the display in MythTV, when I see this I immediately
> know that the tuner will never lock.
> 
>     Signal 0% | S/N 2.4dB | BE 0 | (L__) Partial Lock
> 
> 
> And when I see this, I know that in 1/2 second I'll see a TV picture:
> 
>     Signal 0% | S/N 2.4dB | BE 0 | (LAM) Lock
> 
> 
> It's always the same: 0% signal, 2.4dB S/N and BE 0.  Does "L__" offer
> any hints as to why locks are so elusive?

Scott, thanks for the info.

I'm not actually comfortable trusting the myth display without digging 
into it's code, I don't know what it does with the values. Try using the 
azap statistics, which I'm happier to discuss.

At this point I don't see any software fixes, we're not going to make 
the driver retune a number of times. You're overwhelming the tuner/demod 
frontend with high RF levels.

If you have SNR numbers they would be good to see, but they are for 
informational purposes at this point. They are a curiosity.

You likely need an attenuator.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MJMOYh021076
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 15:22:25 -0400
Received: from mta3.srv.hcvlny.cv.net (mta3.srv.hcvlny.cv.net [167.206.4.198])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MJMDSv027185
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 15:22:13 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7M008TU350ZQ20@mta3.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Mon, 22 Sep 2008 15:22:13 -0400 (EDT)
Date: Mon, 22 Sep 2008 15:22:12 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
To: Scott Bronson <bronson@rinspin.com>
Message-id: <48D7F064.4010103@linuxtv.org>
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
> On Sun, Sep 21, 2008 at 7:28 PM, Steven Toth <stoth@linuxtv.org> wrote:
>> This is really starting to sound like a signal level issue. Try attenuating,
>> this will probably help. Radio shack probably have a selection of 5 and 10db
>> inline connectors that should help.
> 
> I'll try that.  It will attenuate distant stations too, right?  I
> might have to buy two tuners, one for close stations and one for far
> away ones...?

That's fairly unusual, unless you're trying to receive TV at the low 
extremes of the tuner. I guess never say never.

> 
>> This isn't something that we can compensate for in software.
> 
> I'm not sure about that...  Rapidly re-trying seems to always produce
> a lock.  I suppose the driver could do that automatically when needed.
>  (yes it's a hack, but drivers have always needed to hack around
> hardware limitations)
> 
> Is there any way to log the tuning metrics, like signal and noise
> level, etc?  There may be a pattern here.

Watch the SNR value, it's measures in db and expressed in hex with one 
decimal place. So, 0x102 = 25.8db

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

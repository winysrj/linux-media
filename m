Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m8K6jYA4018107
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 02:45:34 -0400
Received: from mta2.srv.hcvlny.cv.net (mta2.srv.hcvlny.cv.net [167.206.4.197])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m8K6jGEj023927
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 02:45:17 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7H002WNEEX6N61@mta2.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Sat, 20 Sep 2008 02:37:46 -0400 (EDT)
Date: Sat, 20 Sep 2008 02:37:45 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
To: Scott Bronson <bronson@rinspin.com>
Message-id: <48D49A39.5010909@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<412bdbff0809191428j760ed51cy8fecd68e1cb738a4@mail.gmail.com>
	<9d87242f0809192005t246311dp796aa28cb744b3af@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
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
> On Fri, Sep 19, 2008 at 8:05 PM, Scott Bronson <bronson@rinspin.com> wrote:
>> On Fri, Sep 19, 2008 at 2:28 PM, Devin Heitmueller
>> <devin.heitmueller@gmail.com> wrote:
>>> What application are you using?  Kaffeine?  Scan?
>> mplayer and MythTV.  They seem to be about equally unreliable.
> 
> And scan of course.  I haven't noticed any problems with it missing channels.
> 
> Does scan try to acquire a lock?  Would it be useful for me to run it
> 5 or 6 times in a row and see how consistent its results are?

I guess it's possible that the frontend is being overwhelmed. What 
happens if you discinnect the antenna and hold it very close to the 
antenna connector on the usb device and try locking on a channel that 
doesn't normally lock (on a very close transmitter).

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFMkxxd023404
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 17:46:59 -0500
Received: from QMTA10.westchester.pa.mail.comcast.net
	(qmta10.westchester.pa.mail.comcast.net [76.96.62.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFMjwbS006499
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 17:45:58 -0500
Message-ID: <491F5127.4090004@personnelware.com>
Date: Sat, 15 Nov 2008 16:45:59 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <491CB0A6.9080509@personnelware.com>	<491F3840.4030301@personnelware.com>
	<200811152307.58719.hverkuil@xs4all.nl>
In-Reply-To: <200811152307.58719.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

Hans Verkuil wrote:
> On Saturday 15 November 2008 21:59:44 Carl Karsten wrote:
>> Tomorrow (Nov 16) I will be at a Linuxfest, where I am going to try
>> to find someone up for writing this driver.
>>
>> I am assuming there is some code they should use as a starting point.
>> Either
>> A) "This is the generic/abstract code that can be extended to make a
>> specific/concrete driver" (what I would call a framework)
>> B) "driver foo.c is a good example of how a V4L2 driver should be
>> written; copy it and swap out the hardware specific code."
>> C) "vivi.c is close enough.  you should really just work on fixing
>> it."
>>
>> I am hoping the correct answer is:
>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/file/6292505ca617/linu
>> x/Documentation/video4linux/v4l2-framework.txt
> 
> Hopefully this will be the correct answer in the near future, but now it 
> refers to structs that do not yet exist. I've reserved next weekend to 
> continue work on this.
> 
> It's probably a good idea for me to create a template driver that can be 
> used as a proper starting point, however nothing will be available soon 
> enough for you. I don't think we have a 'perfect' driver right now. All 
> drivers have their own problems. It's one of the main reasons I'm 
> working on a better framework.
> 
> In any case, I don't think vivi is a good example, it's not written as a 
> template driver, that was never the intention of vivi.

How's this sound:  I'll hold off putting any effort into this this weekend.  Let
me know how things go next weekend, and if everything worked out as you hoped we
can start then.  That sounds like a much better use of everyone's time, and it
results in your code being tested in a fairly clean environment (no flaky
hardware that you don't even have, and simple apps that don't do much at all.)

I think you are misunderstanding why I mentioned vivi: All I want at this point
is what vivi is sposed to be, but it fails due to bugs.  A few people have
suggested that vivi is poorly coded, so fixing the bugs may be more difficult
than starting over.

I'll document the process of developing a test driver using the framework and
creating unit tests along the way.  This doc will be good for anyone developing
a real driver.

Carl K

> 
> Regards,
> 
> 	Hans
> 
>> If someone can give me a rough stub to start with, that would make
>> tomorrow's work more promising.
>>
>> Carl K
>>
>> Carl Karsten wrote:
>>> Apparently vivi is messed up enough that maybe it makes sense to
>>> write a new test driver.
>>>
>>> What is the minimum interface a v4l2 driver could have?
>>>
>>> Something like: it registers itself as /dev/videoN, and
>>> QueryCaps returns nothing.
>>> It does not return any image. (yeah ?)
>>> It can be unloaded.
>>>
>>> and anything else that someone thinks is required for a well
>>> behaved driver that follows the spec.
>>>
>>> The plan is to start with that, get it and my tester working in
>>> harmony, then start adding things to both sides of the fence.  I am
>>> thinking additional features will be enabled via module parameters,
>>> so that it can always be dumbed down back to it's minimum.
>>>
>>> Carl K
>>>
>>>
>>> --
>>> video4linux-list mailing list
>>> Unsubscribe
>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>> --
>> video4linux-list mailing list
>> Unsubscribe
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

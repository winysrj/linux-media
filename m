Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1KFbTBc030762
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:37:29 -0500
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1KFbIQi006860
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:37:19 -0500
Message-ID: <8617.62.70.2.252.1235144231.squirrel@webmail.xs4all.nl>
Date: Fri, 20 Feb 2009 16:37:11 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: HVR-950q analog support - testers wanted
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


> On Fri, Feb 20, 2009 at 10:18 AM, Steven Toth <stoth@linuxtv.org> wrote:
>> Devin Heitmueller wrote:
>>>
>>> Hello,
>>>
>>> There is now a test repository that provides analog support for the
>>> HVR-950q:
>>>
>>> http://linuxtv.org/hg/~dheitmueller/hvr950q-analog
>>>
>>> I welcome people interested in analog support for the 950q to download
>>> the tree and provide feedback.
>>
>> I only have time today for a small amount of testing but QAM and ATSC
>> are
>> still working reliably. No obvious issues. No obvious regressions.
>>
>> I'll load this up on my myth box this weekend and ensure it's still
>> reliable
>> over the long term.
>>
>> I'll be in touch.
>
> Hello Steven,
>
> Thank you for taking the time to test.
>
> One thing that would be useful, and I'm addressing this to everyone,
> is when reporting feedback (positive or negative) you please indicate
> which application(s) you tested with, as well as what kernel version
> and CPU architecture you tested on.
>
> Right now one of the big issues is while that I do not know of any
> issues, the code has had limited exposure in terms of the applications
> and kernels tested with.  By providing this information, that will
> help me tremendously in evaluating whether enough *different* cases
> are being tested or whether everybody is basically testing the same
> thing.

A good test is to play with v4l2-ctl and check the implemented ioctls. I
often discover that drivers forget to fill in some fields, or do not
handle invalid input, etc. Esp. try v4l2-ctl --all and v4l2-ctl
--list-ctrls-menus.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

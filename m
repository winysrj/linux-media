Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9EjWeN010111
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 09:45:40 -0500
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9EEl2k020689
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 09:14:47 -0500
Message-ID: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
Date: Tue, 9 Dec 2008 15:14:46 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Brandon Jenkins" <bcjenkins@tvwhere.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
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

OK, I'll mail you a diff this evening. In the meantime, can you compile
v4l2-ctl for 32-bit? That's the test tool for several of my tests.

Regards,

       Hans

> Hans,
>
> I would love to test! I am using 3 HVR-1600s and an HD-PVR for encoders.
>
> Brandon
> On Tue, Dec 9, 2008 at 9:03 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Brandon,
>>
>> As you noticed I found suspicious code in the current source. At the
>> moment I have no easy way of testing this, although I hope to be able to
>> do that some time in the next week or the week after that.
>>
>> However, if you are able to do some testing for me, then that would be
>> very welcome and definitely speed things up.
>>
>> I have a patch that I can mail you and a bunch of tests to perform.
>>
>> Let me know if you can help.
>>
>> Regards,
>>
>>        Hans
>>
>>> Hi Hans,
>>>
>>> I noted over the weekend that you were working on updating the
>>> v4l2-compat-ioctl32 module, thank you! Do you have a sense of timing
>>> for availability in your tree? I know of a few SageTV users who will
>>> be glad to see it done. :)
>>>
>>> Thanks in advance,
>>>
>>> Brandon
>>>
>>
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>>
>>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

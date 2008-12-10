Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA8SKO4029857
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 03:28:20 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA8R73U024464
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 03:27:39 -0500
Message-ID: <493F7D11.405@hhs.nl>
Date: Wed, 10 Dec 2008 09:25:53 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jim Paris <jim@jtan.com>
References: <20081209215837.GA24743@psychosis.jim.sh> <493EEA59.2040406@hhs.nl>
	<20081209220858.GA25496@psychosis.jim.sh>
In-Reply-To: <20081209220858.GA25496@psychosis.jim.sh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: gspca: fix vidioc_s_jpegcomp locking
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

Jim Paris wrote:
> Hans de Goede wrote:
>> Jim Paris wrote:
>>> This locking looked wrong.
>>>
>> Hi,
>>
>> I appreciate the effort, but please do not send patches just because 
>> something looks wrong. The original code is perfectly fine. It check if 
>> the sub driver supports set_jcomp at all, this check does not need 
>> locking.
> 
> Well, the patch was a request for comments.  But please double-check.
> In the current code, if set_jcomp is NULL, the lock is taken but never
> released.
> 
> I agree that the check does not need locking, which is why my change
> moved the check outside the lock.
> 

Blergh, sorry I completely misread your patch, somehow reversing what it did in 
my head.

You are completely right, the original code is wrong, and this patch needs to 
be applied.

Sorry!

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

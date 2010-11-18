Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58536 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0KRP7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 10:59:03 -0500
Received: by yxf34 with SMTP id 34so1910631yxf.19
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 07:59:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <55f4fc73372a105a2d20ed1ab39a6a4a.squirrel@webmail.xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
	<659fdfa774acb1e359cb0c3c3b48b5e26bb3fcc9.1289944160.git.hverkuil@xs4all.nl>
	<AANLkTikH0+hhWwTUAkYS1Z_WpwQvyZrw1sCt1vkjghN3@mail.gmail.com>
	<e29b49a76577b6eb777d1aa0dba7bd95.squirrel@webmail.xs4all.nl>
	<AANLkTimuV4ZZEcbrf4a2toHLcKMDAEQF9ZLWkju6zwZ0@mail.gmail.com>
	<55f4fc73372a105a2d20ed1ab39a6a4a.squirrel@webmail.xs4all.nl>
Date: Thu, 18 Nov 2010 10:58:57 -0500
Message-ID: <AANLkTi=Qi9U2iGbsumhu0OBUkUBae9Woe_4R5V53Wu0v@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 07/15] dsbr100: convert to unlocked_ioctl.
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 18, 2010 at 10:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> On Thu, Nov 18, 2010 at 9:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>
>>>> This driver has quite a few locking issues that would only be made
>>>> worse by your patch. A much better patch for this can be found here:
>>>>
>>>> http://desource.dyndns.org/~atog/gitweb?p=linux-media.git;a=commitdiff;h=9c5d8ebb602e9af46902c5f3d4d4cc80227d3f7c
>>>
>>> Much too big for 2.6.37. I'll just drop this patch from my patch series.
>>> Instead it will rely on the new lock in v4l2_device (BKL replacement)
>>> that
>>> serializes all ioctls. For 2.6.38 we can convert it to core assisted
>>> locking which is much easier.
>>>
>>
>> I don't see how this patch is really any bigger than some of the
>> others in your series. Sure there are a lot of deletions, but the
>> number of additions is quite small. There are much worse ways all the
>> locking issues in this driver could have been corrected. This patch
>> manages to do just that while reducing the overall size of the driver
>> at the same time.
>
> Basically there are two reasons why I'm not including this in my patch
> series: 1) you disagreed with my patch and 2) I disagree with your patch.
>
> In this case the patch for 2.6.37 should either be small and trivial, or
> we should postpone it to 2.6.38 and use proper core-assisted locking
> (which makes the most sense for this driver in my opinion). And I really
> dislike those BUG_ONs you've added, to be honest. Sorry about that...

The reality is that the BUG_ONs should never be hit. I added those
because I don't have the hardware needed to test my changes. So if I
missed something, the issue would be very apparent to whoever was
doing the testing. If someone would actually test this series, the
BUG_ONs could be removed. Maybe a WARN_ON would have been better, but
to me accessing the device struct without holding the lock is a bug.
The only valid case where it would be okay to do that would be from
within the probe function before the device is registered.

>
> Anyway, feel free to post your own patch for this driver. I've no problems
> with that at all. It is clear that this driver takes more time to get a
> proper patch for that makes everyone happy, and I really need to make the
> git pull request for 2.6.37 tomorrow as we don't want to do this too late
> in the 2.6.37 cycle.
>

I understand, but if you or anyone else had actually bothered to
review this patch when it was submitted back in May then it might have
made its way into the kernel by now. At the time the patch was
written, core assisted locking wasn't even implemented. Granted the
ioctl added to correct the locking might cause a cache miss, but this
is acceptable for such a simple driver. This is a good first step
towards core assisted locking.

Regards,

David Ellingsworth

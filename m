Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2827 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0KRP3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 10:29:41 -0500
Message-ID: <55f4fc73372a105a2d20ed1ab39a6a4a.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTimuV4ZZEcbrf4a2toHLcKMDAEQF9ZLWkju6zwZ0@mail.gmail.com>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
    <659fdfa774acb1e359cb0c3c3b48b5e26bb3fcc9.1289944160.git.hverkuil@xs4all.nl>
    <AANLkTikH0+hhWwTUAkYS1Z_WpwQvyZrw1sCt1vkjghN3@mail.gmail.com>
    <e29b49a76577b6eb777d1aa0dba7bd95.squirrel@webmail.xs4all.nl>
    <AANLkTimuV4ZZEcbrf4a2toHLcKMDAEQF9ZLWkju6zwZ0@mail.gmail.com>
Date: Thu, 18 Nov 2010 16:29:36 +0100
Subject: Re: [RFCv2 PATCH 07/15] dsbr100: convert to unlocked_ioctl.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "David Ellingsworth" <david@identd.dyndns.org>
Cc: linux-media@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> On Thu, Nov 18, 2010 at 9:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> This driver has quite a few locking issues that would only be made
>>> worse by your patch. A much better patch for this can be found here:
>>>
>>> http://desource.dyndns.org/~atog/gitweb?p=linux-media.git;a=commitdiff;h=9c5d8ebb602e9af46902c5f3d4d4cc80227d3f7c
>>
>> Much too big for 2.6.37. I'll just drop this patch from my patch series.
>> Instead it will rely on the new lock in v4l2_device (BKL replacement)
>> that
>> serializes all ioctls. For 2.6.38 we can convert it to core assisted
>> locking which is much easier.
>>
>
> I don't see how this patch is really any bigger than some of the
> others in your series. Sure there are a lot of deletions, but the
> number of additions is quite small. There are much worse ways all the
> locking issues in this driver could have been corrected. This patch
> manages to do just that while reducing the overall size of the driver
> at the same time.

Basically there are two reasons why I'm not including this in my patch
series: 1) you disagreed with my patch and 2) I disagree with your patch.

In this case the patch for 2.6.37 should either be small and trivial, or
we should postpone it to 2.6.38 and use proper core-assisted locking
(which makes the most sense for this driver in my opinion). And I really
dislike those BUG_ONs you've added, to be honest. Sorry about that...

Anyway, feel free to post your own patch for this driver. I've no problems
with that at all. It is clear that this driver takes more time to get a
proper patch for that makes everyone happy, and I really need to make the
git pull request for 2.6.37 tomorrow as we don't want to do this too late
in the 2.6.37 cycle.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco


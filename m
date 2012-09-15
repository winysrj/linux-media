Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2IOK01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 06:26:27 -0400
Received: by bkwj10 with SMTP id j10so1664264bkw.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 03:26:26 -0700 (PDT)
Message-ID: <505457CF.7060009@gmail.com>
Date: Sat, 15 Sep 2012 12:26:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmo?= =?ISO-8859-1?Q?nt?=
	<remi@remlab.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <50539C29.2070209@iki.fi> <201209150941.59198.hverkuil@xs4all.nl> <3763500.054S7eWLyn@avalon>
In-Reply-To: <3763500.054S7eWLyn@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/15/2012 11:31 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Saturday 15 September 2012 09:41:59 Hans Verkuil wrote:
>> On Fri September 14 2012 23:05:45 Sakari Ailus wrote:
>>> Rémi Denis-Courmont wrote:
>>>> Le vendredi 14 septembre 2012 23:25:01, Sakari Ailus a écrit :
>>>>> I had a quick discussion with Laurent, and what he suggested was to use
>>>>> the kernel version to figure out the type of the timestamp. The drivers
>>>>> that use the monotonic time right now wouldn't be affected by the new
>>>>> flag on older kernels. If we've decided we're going to switch to
>>>>> monotonic time anyway, why not just change all the drivers now and
>>>>> forget the capability flag.
>>>>
>>>> That does not work In Real Life.
>>>>
>>>> People do port old drivers forward to new kernels.
>>>> People do port new drivers back to old kernels
>>>
>>> Why would you port a driver from an old kernel to a new kernel? Or are
>>> you talking about out-of-tree drivers?
>>
>> More likely the latter.
>>
>>> If you do port drivers across different kernel versions I guess you're
>>> supposed to use the appropriate interfaces for those kernels, too. Using
>>> a helper function helps here, so compiling a backported driver would
>>> fail w/o the helper function that produces the timestamp, forcing the
>>> backporter to notice the situation.
>>>
>>> Anyway, I don't have a very strict opinion on this, so I'm okay with the
>>> flag, too, but I personally simply don't think it's the best choice we
>>> can make now. Also, without converting the drivers now the user space
>>> must live with different kinds of timestamps much longer.
>>
>> There are a number of reasons why I want to go with a flag:
>>
>> - Out-of-tree drivers which are unlikely to switch to monotonic in practice
>> - Backporting drivers
>> - It makes it easy to verify in v4l2-compliance and enforce the use of
>>    the monotonic clock.
>> - It's easy for apps to check.
>>
>> The third reason is probably the most important one for me. There tends to
>> be a great deal of inertia before changes like this are applied to new
>> drivers, and without being able to (easily) check this in v4l2-compliance
>> more drivers will be merged that keep using gettimeofday. It's all too easy
>> to miss in a review.
> 
> If we switch all existing drivers to monotonic timestamps in kernel release
> 3.x, v4l2-compliance can just use the version it gets from VIDIOC_QUERYCAP and
> enforce monotonic timestamps verification if the version is>= 3.x. This isn't
> more difficult for apps to check than a dedicated flag (although it's less
> explicit).
> 
> My concern is identical to Sakari's, I'm not very keen on introducing a flag
> that all drivers will set in the very near future and that we will have to
> keep around forever.
> 
>> That doesn't mean that it isn't a good idea to convert existing drivers
>> asap. But it's not something I'm likely to take up myself.
> 
> Sakari, are you volunteering for that ? ;-)
> 
>> Creating a small helper function as you suggested elsewhere is a good idea
>> as well. I'll write something for that.

IMHO, using a flag is going to more reliable, i.e. it is going to be reliable.
It shouldn't be a big deal to set the flag, unless we're running out of free
bits in the caps field. Once all drivers are converted it could be set in
v4l2-core. And applications would always know what they get.

--

Regards,
Sylwester


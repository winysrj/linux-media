Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:34228 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754136AbdHWPkL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 11:40:11 -0400
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <4fa22637-c58e-79e3-be22-575b0a4ff3f9@iki.fi>
 <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl> <2623469.qW6Q8oGARq@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ce8f30fb-9481-7cf0-8da5-68ccf57ec2dc@xs4all.nl>
Date: Wed, 23 Aug 2017 17:40:06 +0200
MIME-Version: 1.0
In-Reply-To: <2623469.qW6Q8oGARq@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/17 14:29, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday, 23 August 2017 12:09:15 EEST Hans Verkuil wrote:
>> On 08/04/17 20:25, Sakari Ailus wrote:
>>> Niklas Söderlund wrote:
>>>> On 2017-07-20 19:14:01 +0300, Sakari Ailus wrote:
>>>>> On Wed, Jul 19, 2017 at 01:42:55PM +0200, Hans Verkuil wrote:
>>>>>> On 18/07/17 21:03, Sakari Ailus wrote:
>>>>>>> Hi folks,
>>>>>>>
>>>>>>> This RFC patchset achieves a number of things which I've put to the
>>>>>>> same patchset for they need to be show together to demonstrate the use
>>>>>>> cases.
>>>>>>>
>>>>>>> I don't really intend this to compete with Niklas's patchset but much
>>>>>>> of the problem area addressed by the two is the same.
>>>>>>>
>>>>>>> Comments would be welcome.
>>>>>>>
>>>>>>> - Add AS3645A LED flash class driver.
>>>>>>>
>>>>>>> - Add async notifiers (by Niklas).
>>>>>>>
>>>>>>> - V4L2 sub-device node registration is moved to take place at the same
>>>>>>>   time with the registration of the sub-device itself. With this
>>>>>>>   change, sub-device node registration behaviour is aligned with video
>>>>>>>   node registration.
>>>>>>>
>>>>>>> - The former is made possible by moving the bound() callback after
>>>>>>>   sub-device registration.
>>>>>>>
>>>>>>> - As all the device node registration and link creation is done as the
>>>>>>>   respective devices are probed, there is no longer dependency to the
>>>>>>>   notifier complete callback which as itself is seen problematic. The
>>>>>>>   complete callback still exists but there's no need to use it,
>>>>>>>   pending changes in individual drivers.
>>>>>>>   
>>>>>>>   See:
>>>>>>>   <URL:http://www.spinics.net/lists/linux-media/msg118323.html>
>>>>>>>   
>>>>>>>   As a result, if a part of the media device fails to initialise
>>>>>>>   because it is e.g. physically broken, it will be possible to use
>>>>>>>   what works.
>>>>>>
>>>>>> I've got major problems with this from a userspace point of view. In
>>>>>> the vast majority of cases you just want to bail out if one or more
>>>>>> subdevs fail.
>>>>>
>>>>> I admit it's easier for the user space if the device becomes available
>>>>> only when all its component drivers have registered.
>>>>>
>>>>> Also remember that video nodes are registered in the file system right
>>>>> on device probe time. It's only sub-device and media device node
>>>>> registration that has taken place in the notifier's complete handler.
>>>>
>>>> Is this always the case? In the R-Car VIN driver I register the video
>>>> devices using video_register_device() in the complete handler. Am I
>>>> doing things wrong in that driver? I had a patch where I moved the
>>>> video_register_device() call to probe time but it got shoot down in
>>>> review and was dropped.
>>>
>>> I don't think the current implementation is wrong, it's just different
>>> from other drivers; there's really no requirement regarding this AFAIU.
>>> It's one of the things where no attention has been paid I presume.
>>
>> It actually is a requirement: when a device node appears applications can
>> reasonably expect to have a fully functioning device. True for any device
>> node.
> 
> Why not ? I'm not aware of any such kernel-wide requirement. 
> 
>> You don't want to have to wait until some unspecified time before the full
>> functionality is there.
> 
> We certainly should specify that time and give userspace a way to find out 
> what is usable and when.
> 
>> I try to pay attention to this when reviewing code, since not following this
>> rule basically introduces a race condition which is hard to test.
>>
>>> However doing anything that can fail earlier on would be nicer since
>>> there's no reasonable way to signal an error from complete callback
>>> either.
>>
>> Right.
>>
>> Adding support for cases where devices may not be present is very desirable,
>> but this should go through an RFC process first to hammer out all the
>> details.
>>
>> Today we do not support this and we have to review code with that in mind.
>>
>> So the first async subnotifiers implementation should NOT support this
>> (although it can of course be designed with this in mind).
> 
> I very much disagree. The first async subnotifiers implementation (and I still 
> believe we don't need subnotifiers, there's nothing "sub" in them) shall 
> support this. If it means we first have to hammer out the details of out it 
> will work, so be it.

I see no reason to block the highly desirable async (sub)notifier code
while waiting for us to hammer out the details of something that is for the
most part unrelated to this. That usually takes a lot of time and since
the async (sub)notifier code is an internal API that can be changed later
you really don't want it to be stuck in limbo for all that time.

There are already a few drivers pending on this and, as you said yourself,
it is very unpleasant for driver authors to have their work stuck in the
queue for a long time.

Ditto for postponing work on this until the life-time issues have been
solved. If Niklas can do this work while you and Sakari work on the life-time
issues, then I see nothing wrong with that.

For APIs internal to the kernel you can make gradual improvements. As long
as each change makes things a bit better I happily accept it. Waiting until
everything is perfect and beautiful means nothing ever gets accepted since
it'll never be perfect as there is always something that can be done better...

It's what makes uAPI additions so hard, because you have to try and make it
as close to perfect as you can, and we never quite succeed there either.

Regards,

	Hans

>> Once it is in we can start on an RFC on how to support partial pipelines. I
>> have a lot of questions about that that need to be answered first.
>>
>> One thing at a time. Trying to do everything at once never works.
> 
> Sure, so let's start with probe time device node registration, and then move 
> on to subnotifiers.

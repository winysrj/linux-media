Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58814 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751250AbdHEIBo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 04:01:44 -0400
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <eb0ff309-bdf5-30f9-06da-2fc6c35fbf6a@xs4all.nl>
 <20170720161400.ijud3kppizb44acw@valkosipuli.retiisi.org.uk>
 <20170721065754.GC20077@bigcity.dyn.berto.se>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <4fa22637-c58e-79e3-be22-575b0a4ff3f9@iki.fi>
Date: Fri, 4 Aug 2017 21:25:22 +0300
MIME-Version: 1.0
In-Reply-To: <20170721065754.GC20077@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Niklas Söderlund wrote:
> Hi Sakari,
> 
> On 2017-07-20 19:14:01 +0300, Sakari Ailus wrote:
>> Hi Hans,
>>
>> Thanks for the review.
>>
>> On Wed, Jul 19, 2017 at 01:42:55PM +0200, Hans Verkuil wrote:
>>> On 18/07/17 21:03, Sakari Ailus wrote:
>>>> Hi folks,
>>>>
>>>> This RFC patchset achieves a number of things which I've put to the same
>>>> patchset for they need to be show together to demonstrate the use cases.
>>>>
>>>> I don't really intend this to compete with Niklas's patchset but much of
>>>> the problem area addressed by the two is the same.
>>>>
>>>> Comments would be welcome.
>>>>
>>>> - Add AS3645A LED flash class driver.
>>>>
>>>> - Add async notifiers (by Niklas).
>>>>
>>>> - V4L2 sub-device node registration is moved to take place at the same time
>>>>   with the registration of the sub-device itself. With this change,
>>>>   sub-device node registration behaviour is aligned with video node
>>>>   registration.
>>>>
>>>> - The former is made possible by moving the bound() callback after
>>>>   sub-device registration.
>>>>
>>>> - As all the device node registration and link creation is done as the
>>>>   respective devices are probed, there is no longer dependency to the
>>>>   notifier complete callback which as itself is seen problematic. The
>>>>   complete callback still exists but there's no need to use it, pending
>>>>   changes in individual drivers.
>>>>
>>>>   See:
>>>>   <URL:http://www.spinics.net/lists/linux-media/msg118323.html>
>>>>
>>>>   As a result, if a part of the media device fails to initialise because it
>>>>   is e.g. physically broken, it will be possible to use what works.
>>>
>>> I've got major problems with this from a userspace point of view. In the vast
>>> majority of cases you just want to bail out if one or more subdevs fail.
>>
>> I admit it's easier for the user space if the device becomes available only
>> when all its component drivers have registered.
>>
>> Also remember that video nodes are registered in the file system right on
>> device probe time. It's only sub-device and media device node registration
>> that has taken place in the notifier's complete handler.
> 
> Is this always the case? In the R-Car VIN driver I register the video 
> devices using video_register_device() in the complete handler. Am I 
> doing things wrong in that driver? I had a patch where I moved the 
> video_register_device() call to probe time but it got shoot down in 
> review and was dropped.

I don't think the current implementation is wrong, it's just different
from other drivers; there's really no requirement regarding this AFAIU.
It's one of the things where no attention has been paid I presume.

However doing anything that can fail earlier on would be nicer since
there's no reasonable way to signal an error from complete callback either.

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi

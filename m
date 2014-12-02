Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41876 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbaLBMyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 07:54:09 -0500
Message-ID: <547DB631.3060309@xs4all.nl>
Date: Tue, 02 Dec 2014 13:53:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API
 for v4l2_subdev_get_try_*()
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com> <1680188.7K1XCBdsCk@avalon> <CA+V-a8uaw2X_a3rfx0=avbuGnUdbqveMvJaU25hewzv9eAA8+Q@mail.gmail.com> <1429705.acTXlHE2TG@avalon> <547D6E20.7040406@xs4all.nl>
In-Reply-To: <547D6E20.7040406@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/02/14 08:45, Hans Verkuil wrote:
> On 12/02/2014 12:26 AM, Laurent Pinchart wrote:
>> Hi Prabhakar,
>>
>> On Sunday 30 November 2014 21:30:35 Prabhakar Lad wrote:
>>> On Sun, Nov 30, 2014 at 9:16 PM, Laurent Pinchart wrote:
>>>> On Sunday 30 November 2014 21:05:50 Prabhakar Lad wrote:
>>>>> On Sat, Nov 29, 2014 at 7:12 PM, Laurent Pinchart wrote:
>>>>>> Hi Prabhakar,
>>>>>
>>>>> [Snip]
>>>>>
>>>>>>>> Sure. That's a better choice than removing the config option
>>>>>>>> dependency of the fields struct v4l2_subdev.
>>>>>>
>>>>>> Decoupling CONFIG_VIDEO_V4L2_SUBDEV_API from the availability of the
>>>>>> in-kernel pad format and selection rectangles helpers is definitely a
>>>>>> good idea. I was thinking about decoupling the try format and
>>>>>> rectangles from v4l2_subdev_fh by creating a kind of configuration store
>>>>>> structure to store them, and embedding that structure in v4l2_subdev_fh.
>>>>>> The pad-level operations would then take a pointer to the configuration
>>>>>> store instead of the v4l2_subdev_fh. Bridge drivers that want to
>>>>>> implement TRY_FMT based on pad-level operations would create a
>>>>>> configuration store, use the pad-level operations, and destroy the
>>>>>> configuration store. The userspace subdev API would use the
>>>>>> configuration store from the file handle.
>>>>>
>>>>> are planning to work/post any time soon ? Or are you OK with suggestion
>>>>> from Hans ?
>>>>
>>>> I have no plan to work on that myself now, I was hoping you could
>>>> implement it ;-)
>>>
>>> OK will implement it.
>>>
>>> Can you please elaborate a more on this "The userspace subdev API would use
>>> the configuration store from the file handle."
>>
>> Basically,
>>
>> 1. Create a subdev pad configuration store structure to store the formats and 
>> selection rectangles for each pad.
> 
> I wouldn't call it a 'store'. Just call it fmt_config or pad_config something like
> that.
> 
>>
>> 2. Embed an instance of that structure in v4l2_subdev_fh.
>>
>> 3. Modify the subdev pad ops to take a configuration store pointer instead of 
>> a file handle pointer.
>>
>> The userspace API implementation (v4l2-subdev.c) would then pass &fh->store to 
>> the pad operations instead of fh.
>>
>> Bridge drivers that need to implement TRY_FMT on top of pad ops would create a 
>> temporary store (or temporary stores when multiple subsdevs are involved), 
>> call the pad ops with a pointer to the temporary store to propagate TRY 
>> formats, destroy the store(s) and return the resulting format.
> 
> That will work. I think this is a good approach and it shouldn't be too difficult.

Laurent, just so I understand this correctly: does this mean that all occurrences
of 'struct v4l2_subdev_fh *fh' will be replaced by 'struct v4l2_subdev_pad_config *cfg'?

Is there any reason why the 'fh' should still be passed on?

Personally I am in favor of this since the 'fh' always made it hard for bridge
drivers to use these pad ops. So if we can replace it by something that can
be used by bridge drivers as well, then that will make it easier to move all
drivers over to the pad ops.

Regards,

	Hans

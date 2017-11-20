Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:54776 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdKTLAB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 06:00:01 -0500
Subject: Re: camss: camera controls missing on vfe interfaces
To: Todor Tomov <todor.tomov@linaro.org>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
 <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
 <9ac5306d-c048-5d04-4ea9-2d5d08165350@linaro.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <b2ee60be-508f-bc16-5632-1bd0e694b6cc@zonque.org>
Date: Mon, 20 Nov 2017 11:59:59 +0100
MIME-Version: 1.0
In-Reply-To: <9ac5306d-c048-5d04-4ea9-2d5d08165350@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Thanks for following up!

On Monday, November 20, 2017 09:32 AM, Todor Tomov wrote:
> On 15.11.2017 21:31, Daniel Mack wrote:
>> Todor et all,
>>
>> Any hint on how to tackle this?
>>
>> I can contribute patches, but I'd like to understand what the idea is.
>>
>>
>> Thanks,
>> Daniel
>>
>>
>> On Thursday, October 26, 2017 06:11 PM, Daniel Mack wrote:
>>> Hi Todor,
>>>
>>> When using the camss driver trough one of its /dev/videoX device nodes,
>>> applications are currently unable to see the video controls the camera
>>> sensor exposes.
>>>
>>> Same goes for other ioctls such as VIDIOC_ENUM_FMT, so the only valid
>>> resolution setting for applications to use is the one that was
>>> previously set through the media controller layer. Applications usually
>>> query the available formats and then pick one using the standard V4L2
>>> APIs, and many can't easily be forced to use a specific one.
>>>
>>> If I'm getting this right, could you explain what's the rationale here?
>>> Is that simply a missing feature or was that approach chosen on purpose?
>>>
> 
> It is not a missing feature, it is more of a missing userspace implementation.
> When working with a media oriented device driver, the userspace has to
> config the media pipeline too and if controls are exposed by the subdev nodes,
> the userspace has to configure them on the subdev nodes.
> 
> As there weren't a lot of media oriented drivers there is no generic
> implementation/support for this in the userspace (at least I'm not aware of
> any). There have been discussions about adding such functionality in libv4l
> so that applications which do not support media configuration can still
> use these drivers. I'm not sure if decision for this was taken or not or
> is it just that there was noone to actually do the work. Probably Laurent,
> Mauro or Hans know more about what were the plans for this.

Hmm, that's not good.

Considering the use-case in our application, the pipeline is set up once
and considered more or less static, and then applications such as the
Chrome browsers make use of the high-level VFE interface. If there are
no controls exposed on that interface, they are not available to the
application. Patching all userspace applications is an uphill battle
that can't be won I'm afraid.

Is there any good reason not to expose the sensor controls on the VFE? I
guess it would be easy to do, right?


Thanks,
Daniel

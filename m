Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:41936 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdKTIcP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 03:32:15 -0500
Received: by mail-wm0-f48.google.com with SMTP id b189so16981982wmd.0
        for <linux-media@vger.kernel.org>; Mon, 20 Nov 2017 00:32:14 -0800 (PST)
Subject: Re: camss: camera controls missing on vfe interfaces
To: Daniel Mack <daniel@zonque.org>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
 <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <9ac5306d-c048-5d04-4ea9-2d5d08165350@linaro.org>
Date: Mon, 20 Nov 2017 10:32:12 +0200
MIME-Version: 1.0
In-Reply-To: <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Sorry for my late reply. This is actually an important question that you ask.

On 15.11.2017 21:31, Daniel Mack wrote:
> Todor et all,
> 
> Any hint on how to tackle this?
> 
> I can contribute patches, but I'd like to understand what the idea is.
> 
> 
> Thanks,
> Daniel
> 
> 
> On Thursday, October 26, 2017 06:11 PM, Daniel Mack wrote:
>> Hi Todor,
>>
>> When using the camss driver trough one of its /dev/videoX device nodes,
>> applications are currently unable to see the video controls the camera
>> sensor exposes.
>>
>> Same goes for other ioctls such as VIDIOC_ENUM_FMT, so the only valid
>> resolution setting for applications to use is the one that was
>> previously set through the media controller layer. Applications usually
>> query the available formats and then pick one using the standard V4L2
>> APIs, and many can't easily be forced to use a specific one.
>>
>> If I'm getting this right, could you explain what's the rationale here?
>> Is that simply a missing feature or was that approach chosen on purpose?
>>

It is not a missing feature, it is more of a missing userspace implementation.
When working with a media oriented device driver, the userspace has to
config the media pipeline too and if controls are exposed by the subdev nodes,
the userspace has to configure them on the subdev nodes.

As there weren't a lot of media oriented drivers there is no generic
implementation/support for this in the userspace (at least I'm not aware of
any). There have been discussions about adding such functionality in libv4l
so that applications which do not support media configuration can still
use these drivers. I'm not sure if decision for this was taken or not or
is it just that there was noone to actually do the work. Probably Laurent,
Mauro or Hans know more about what were the plans for this.

-- 
Best regards,
Todor Tomov

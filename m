Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:58592 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752097AbdKZXuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 18:50:18 -0500
Subject: Re: camss: camera controls missing on vfe interfaces
From: Daniel Mack <daniel@zonque.org>
To: Todor Tomov <todor.tomov@linaro.org>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
 <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
 <9ac5306d-c048-5d04-4ea9-2d5d08165350@linaro.org>
 <b2ee60be-508f-bc16-5632-1bd0e694b6cc@zonque.org>
Message-ID: <597a0559-13a1-c3e6-8d03-8dc67c335234@zonque.org>
Date: Mon, 27 Nov 2017 00:50:15 +0100
MIME-Version: 1.0
In-Reply-To: <b2ee60be-508f-bc16-5632-1bd0e694b6cc@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor, everyone,

On Monday, November 20, 2017 11:59 AM, Daniel Mack wrote:
> On Monday, November 20, 2017 09:32 AM, Todor Tomov wrote:
>> It is not a missing feature, it is more of a missing userspace implementation.
>> When working with a media oriented device driver, the userspace has to
>> config the media pipeline too and if controls are exposed by the subdev nodes,
>> the userspace has to configure them on the subdev nodes.
>>
>> As there weren't a lot of media oriented drivers there is no generic
>> implementation/support for this in the userspace (at least I'm not aware of
>> any). There have been discussions about adding such functionality in libv4l
>> so that applications which do not support media configuration can still
>> use these drivers. I'm not sure if decision for this was taken or not or
>> is it just that there was noone to actually do the work. Probably Laurent,
>> Mauro or Hans know more about what were the plans for this.
> 
> Hmm, that's not good.
> 
> Considering the use-case in our application, the pipeline is set up once
> and considered more or less static, and then applications such as the
> Chrome browsers make use of the high-level VFE interface. If there are
> no controls exposed on that interface, they are not available to the
> application. Patching all userspace applications is an uphill battle
> that can't be won I'm afraid.
> 
> Is there any good reason not to expose the sensor controls on the VFE? I
> guess it would be easy to do, right?

Do you see an alternative to implementing the above in order to support
existing v4l-enabled applications?


Thanks,
Daniel

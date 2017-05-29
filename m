Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39762 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750854AbdE2HzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 03:55:13 -0400
Subject: Re: [PATCH v2 15/17] rcar-vin: register the video device at probe
 time
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
 <20170524001540.13613-16-niklas.soderlund@ragnatech.se>
 <5c911c00-ef4c-89c9-4629-20abaeb37f26@xs4all.nl>
 <072c6d94-3ede-724d-2626-e085e17f7c6d@xs4all.nl>
 <20170529074926.GL5567@bigcity.dyn.berto.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <98f45f1c-83ef-f7cd-f774-1978eeff2a45@xs4all.nl>
Date: Mon, 29 May 2017 09:55:07 +0200
MIME-Version: 1.0
In-Reply-To: <20170529074926.GL5567@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2017 09:49 AM, Niklas Söderlund wrote:
> Hi Hans,
> 
> Thanks for taking the time to look at this :-)
> 
> On 2017-05-29 08:56:31 +0200, Hans Verkuil wrote:
>> On 05/29/2017 08:52 AM, Hans Verkuil wrote:
>>> Hi Niklas,
>>>
>>> On 05/24/2017 02:15 AM, Niklas Söderlund wrote:
>>>> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>>
>>>> The driver registers the video device from the async complete callback
>>>> and unregistered in the async unbind callback. This creates problems if
>>>> if the subdevice is bound, unbound and later rebound. The second time
>>>> video_register_device() is called it fails:
>>>>
>>>>       kobject (eb3be918): tried to init an initialized object, something is seriously wrong.
>>>>
>>>> To prevent this register the video device at prob time and don't allow
>>>> user-space to open the video device if the subdevice have not yet been
>>>> bound.
>>>
>>> This patch feels wrong. Creating the video device in the notify_complete seems
>>> right to me, so the problem is much more likely in the removal of the video device.
>>>
>>> What *exactly* goes wrong here
> 
> When calling video_register_device() it fails since the device structure
> have already been registered once. So it is not possible to register,
> unregister and then register the same video device struct. The other
> solution to this is to memset the whole embedded video device struct to
> zero  before initializing it and calling video_register_device(), but
> that feels more wrong. Let me know what you think and I will rework this
> patch.
> 
> 
>>>
>>> FYI: I'm taking all other patches of this series,
>>
>> Oops, I saw Sakari had two comments. I'll wait for a v3 then.
>>
>> If you make a v3 with Sakari's suggestions and drop this patch, then I can merge
>> it and make a pull request for it.
> 
> I can't find Sakaris comments in my inbox or on the ML for this thread.
> Where did you see them?

Sorry, my mistake. Those comments were for the

"[PATCH v2 0/2] media: entity: add operation to help map DT node to media pad"

patch series.

Never mind. I'm going to merge all but this patch and get back to you on this one.

Regards,

	Hans

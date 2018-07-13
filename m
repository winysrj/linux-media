Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36055 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbeGMJch (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 05:32:37 -0400
Received: by mail-wm0-f66.google.com with SMTP id s14-v6so8730077wmc.1
        for <linux-media@vger.kernel.org>; Fri, 13 Jul 2018 02:18:49 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
 <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
 <20180705094421.0bad52e2@coco.lan>
 <2f4121bb-1774-410c-5425-f9977d38a02e@xs4all.nl>
 <7efd92ca-1891-4054-29d5-dca5813b37d6@redhat.com>
 <20180711103958.gd6szkgfljjnr44w@pengutronix.de>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <94a592f4-a130-b210-a461-9a4f758164a8@redhat.com>
Date: Fri, 13 Jul 2018 11:18:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180711103958.gd6szkgfljjnr44w@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2018 12:39 PM, Marco Felsch wrote:
> Hi Javier,
> 
> On 18-07-08 15:11, Javier Martinez Canillas wrote:
>> [adding Marco Felsch since he has been working on this driver]
>>
>> On 07/05/2018 03:12 PM, Hans Verkuil wrote:
>>> On 05/07/18 14:44, Mauro Carvalho Chehab wrote:
>>>> Javier,
>>>>
>>>> How standard settings work with the current OMAP3 drivers with tvp5150?
>>>
>>> It looks like tvp5150 uses autodetect of the standard, which in general is
>>
>> That's correct, the driver uses standard autodetect.
>>
>>> not a good thing to do since different standards have different buffer
>>> sizes. But this chip can scale, so it might scale PAL to NTSC or vice versa
>>> if the standard switches mid-stream. Or it only detects the standard when
>>> it starts streaming, I'm not sure.
>>>
>>
>> Not sure about this either, IIUC switching the standard mid-stream won't work.
> 
> As far as I know, the detection happens after a sync lost event.
>

Ah, good to know.
 
>>> In any case, this is not normal behavior, for almost all analog video
>>> receivers you need to be able to set the std explicitly.
>>>
>>
>> Indeed. I see that Marco's recent series [0] add supports for the .querystd [1]
>> and .g_std [2] callbacks to the tvp5150 driver, so that way user-space can get
>> back the detected standard.
>>
>> [0]: https://www.spinics.net/lists/linux-media/msg136869.html
>> [1]: https://www.spinics.net/lists/linux-media/msg136872.html
>> [2]: https://www.spinics.net/lists/linux-media/msg136875.html
> 
> I tought the std will be set by the v4l2_subdev_video_ops.s_std()
> operation. If the user change the std manually, the autodection is
> disabled.
>

Yes, what I tried to say is that user-space won't have a way to know which std
to set without a .querystd, or know what std was autodetected withou a .g_std.

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat

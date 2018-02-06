Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53802 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753156AbeBFVJ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:09:29 -0500
Subject: Re: [PATCH v8 5/7] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
 <1517948874-21681-6-git-send-email-tharvey@gateworks.com>
 <3630ba30-eb18-0829-7b0c-f0a786232969@xs4all.nl>
 <CAJ+vNU1SWma59YwvRO7jDAu2=ndgSU6CgYtKs0792+oqDAEtrQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1ff2a81e-04f7-02eb-6ba2-70227665839b@xs4all.nl>
Date: Tue, 6 Feb 2018 22:09:24 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU1SWma59YwvRO7jDAu2=ndgSU6CgYtKs0792+oqDAEtrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2018 10:03 PM, Tim Harvey wrote:
> On Tue, Feb 6, 2018 at 12:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/06/2018 09:27 PM, Tim Harvey wrote:
>>> Add support for the TDA1997x HDMI receivers.
>>>
>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>>> ---
>>
>> <snip>
>>
>>> +static int tda1997x_get_dv_timings_cap(struct v4l2_subdev *sd,
>>> +                                    struct v4l2_dv_timings_cap *cap)
>>> +{
>>> +     if (cap->pad != TDA1997X_PAD_SOURCE)
>>> +             return -EINVAL;
>>> +
>>> +     *cap = tda1997x_dv_timings_cap;
>>> +     return 0;
>>> +}
>>> +
>>> +static int tda1997x_enum_dv_timings(struct v4l2_subdev *sd,
>>> +                                 struct v4l2_enum_dv_timings *timings)
>>> +{
>>> +     if (timings->pad != TDA1997X_PAD_SOURCE)
>>> +             return -EINVAL;
>>> +
>>> +     return v4l2_enum_dv_timings_cap(timings, &tda1997x_dv_timings_cap,
>>> +                                     NULL, NULL);
>>> +}
>>
>> You shouldn't need this pad test: it's done in the v4l2-subdev.c core code
>> already. But please double-check :-)
>>
> 
> oh right - forgot to check that. Yes, v4l2-subdev.c has pad bounds
> checking on all ops I use so I can remove them.
> 
>> Can you post the output of the v4l2-compliance test? I'm curious to see it.
> 
> it's in the cover letter (should I move it to the driver patch for
> subsequent submittals?)

Ah, it was all the way down after the MC topology. That's why I missed it.

> 
>>
>> Can you also try to run v4l2-compliance -m /dev/mediaX? That also tests
>> whether the right entity types are set (note: testing for that should
>> also happen in the subdev compliance test, but I haven't done that yet).
>>
> 
> root@ventana:~# v4l2-compliance -m0
> v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
> Media Driver Info:
>         Driver name      : imx-media
>         Model            : imx-media
>         Serial           :
>         Bus info         :
>         Media version    : 4.15.0
>         Hardware revision: 0x00000000 (0)
>         Driver version   : 4.15.0
> 
> Compliance test for device /dev/media0:
> 
> Required ioctls:
>         test MEDIA_IOC_DEVICE_INFO: OK
> 
> Allow for multiple opens:
>         test second /dev/media0 open: OK
>         test MEDIA_IOC_DEVICE_INFO: OK
>         test for unlimited opens: OK
> 
> Media Controller ioctls:
>                 fail: v4l2-test-media.cpp(141): ent.function ==
> MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
>         test MEDIA_IOC_G_TOPOLOGY: FAIL
>                 fail: v4l2-test-media.cpp(256):
> v2_entities_set.find(ent.id) == v2_entities_set.end()
>         test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
>         test MEDIA_IOC_SETUP_LINK: OK
> 
> Total: 7, Succeeded: 5, Failed: 2, Warnings: 0
> 
> foiled again!
> 
> Is something missing after v4l2_i2c_subdev_init() or is this perhaps
> something missing in the imx media drivers?
> 
>         v4l2_i2c_subdev_init(sd, client, &tda1997x_subdev_ops);
>         snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
>                  id->name, i2c_adapter_id(client->adapter),
>                  client->addr);
>         sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
>         sd->entity.ops = &tda1997x_media_ops;

Yeah, I was afraid of that. Anyway, I saw some issues in the subdev compliance.
I'll reply to the cover letter about that.

Regards,

	Hans

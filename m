Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52864 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbeBFVDb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 16:03:31 -0500
Received: by mail-wm0-f65.google.com with SMTP id g1so6306404wmg.2
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 13:03:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3630ba30-eb18-0829-7b0c-f0a786232969@xs4all.nl>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
 <1517948874-21681-6-git-send-email-tharvey@gateworks.com> <3630ba30-eb18-0829-7b0c-f0a786232969@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 6 Feb 2018 13:03:29 -0800
Message-ID: <CAJ+vNU1SWma59YwvRO7jDAu2=ndgSU6CgYtKs0792+oqDAEtrQ@mail.gmail.com>
Subject: Re: [PATCH v8 5/7] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 6, 2018 at 12:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/06/2018 09:27 PM, Tim Harvey wrote:
>> Add support for the TDA1997x HDMI receivers.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>> ---
>
> <snip>
>
>> +static int tda1997x_get_dv_timings_cap(struct v4l2_subdev *sd,
>> +                                    struct v4l2_dv_timings_cap *cap)
>> +{
>> +     if (cap->pad != TDA1997X_PAD_SOURCE)
>> +             return -EINVAL;
>> +
>> +     *cap = tda1997x_dv_timings_cap;
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_enum_dv_timings(struct v4l2_subdev *sd,
>> +                                 struct v4l2_enum_dv_timings *timings)
>> +{
>> +     if (timings->pad != TDA1997X_PAD_SOURCE)
>> +             return -EINVAL;
>> +
>> +     return v4l2_enum_dv_timings_cap(timings, &tda1997x_dv_timings_cap,
>> +                                     NULL, NULL);
>> +}
>
> You shouldn't need this pad test: it's done in the v4l2-subdev.c core code
> already. But please double-check :-)
>

oh right - forgot to check that. Yes, v4l2-subdev.c has pad bounds
checking on all ops I use so I can remove them.

> Can you post the output of the v4l2-compliance test? I'm curious to see it.

it's in the cover letter (should I move it to the driver patch for
subsequent submittals?)

>
> Can you also try to run v4l2-compliance -m /dev/mediaX? That also tests
> whether the right entity types are set (note: testing for that should
> also happen in the subdev compliance test, but I haven't done that yet).
>

root@ventana:~# v4l2-compliance -m0
v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.15.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.15.0

Compliance test for device /dev/media0:

Required ioctls:
        test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
        test second /dev/media0 open: OK
        test MEDIA_IOC_DEVICE_INFO: OK
        test for unlimited opens: OK

Media Controller ioctls:
                fail: v4l2-test-media.cpp(141): ent.function ==
MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
        test MEDIA_IOC_G_TOPOLOGY: FAIL
                fail: v4l2-test-media.cpp(256):
v2_entities_set.find(ent.id) == v2_entities_set.end()
        test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
        test MEDIA_IOC_SETUP_LINK: OK

Total: 7, Succeeded: 5, Failed: 2, Warnings: 0

foiled again!

Is something missing after v4l2_i2c_subdev_init() or is this perhaps
something missing in the imx media drivers?

        v4l2_i2c_subdev_init(sd, client, &tda1997x_subdev_ops);
        snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
                 id->name, i2c_adapter_id(client->adapter),
                 client->addr);
        sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
        sd->entity.ops = &tda1997x_media_ops;

Regards,

Tim

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33373 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbeBFTby (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 14:31:54 -0500
Received: by mail-wm0-f52.google.com with SMTP id x4-v6so19293618wmc.0
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 11:31:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9fd654a6-086a-bb00-b84f-383580e18fee@xs4all.nl>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
 <CAJ+vNU1erjHtttuctgR=xd_XmhvxzyuhqdmyfOLKFVaiVf=ufg@mail.gmail.com>
 <c1f94f39-8f20-8503-9619-3108190d77c6@xs4all.nl> <CAJ+vNU15Q2C3mC4DjHKhX+56w-o-U4nOqndZwg6ncC2SCAaUhw@mail.gmail.com>
 <9fd654a6-086a-bb00-b84f-383580e18fee@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 6 Feb 2018 11:31:52 -0800
Message-ID: <CAJ+vNU0uSnAaRdDQOEpN6BW0kq_5H_kcrQJM=6csTjE_dnPdBQ@mail.gmail.com>
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 6, 2018 at 11:05 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/06/2018 07:48 PM, Tim Harvey wrote:
>> On Mon, Feb 5, 2018 at 11:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 02/06/2018 08:16 AM, Tim Harvey wrote:
>>>> On Sat, Feb 3, 2018 at 7:56 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> <snip>
>>>>
>>>> With regards to the 3 failures:
>>>>
>>>> 1. test VIDIOC_G/S_EDID: FAIL
>>>> This is a valid catch where I was returning -EINVAL when the caller
>>>> was simply querying the edid - I've fixed it in my driver
>>>>
>>>> 2. test VIDIOC_DV_TIMINGS_CAP: FAIL
>>>> fail: v4l2-test-io-config.cpp(375): doioctl(node,
>>>> VIDIOC_DV_TIMINGS_CAP, &timingscap) != EINVAL
>>>> fail: v4l2-test-io-config.cpp(392): EDID check failed for source pad 0.
>>>>
>>>> It looks like the purpose of the test is to do an ioctl with an
>>>> invalid pad setting to ensure -EINVAL is returned. However by the time
>>>> the VIDIOC_DV_TIMINGS_CAP ioctl used here gets routed to a
>>>
>>> No, VIDIOC_SUBDEV_DV_TIMINGS_CAP == VIDIOC_DV_TIMINGS_CAP, i.e. the
>>> v4l-subdev API reuses the same ioctl as is used in the 'main' V4L2 API.
>>> See include/uapi/linux/v4l2-subdev.h at the end for a list of 'alias'
>>> ioctls.
>>
>> Ah... thanks - I realized that was happening somehow but couldn't see how :)
>>
>>>
>>> Looking at v7 your tda1997x_get_dv_timings_cap() function doesn't check
>>> for a valid pad field. Same for tda1997x_enum_dv_timings().
>>
>> Right - I noticed this right off as well - I've added pad validation
>> but that didn't resolve the failure.
>>
>> The test failing is:
>>
>>         memset(&timingscap, 0, sizeof(timingscap));
>>         timingscap.pad = node->is_subdev() ? node->entity.pads : 1;
>> ^^^^ this sets pad=node->entity.pads=1 which is invalid
>>         fail_on_test(doioctl(node, VIDIOC_DV_TIMINGS_CAP, &timingscap)
>> != EINVAL);
>> ^^^^ tda1997x_get_dv_timings_cap() gets called with cap->pad = 0 which
>> is valid to returns 0. I don't understand how the userspace pad=1 get
>> changed to pad=0 in my handler.
>
> Actually, you don't need to test the pad in the driver, I just looked at
> the code in v4l2-core/v4l2-subdev.c and the pad is tested there already.
>
> And I just found why it is cleared: it's a bug in v4l2-ioctl.c.
>
> Look up VIDIOC_DV_TIMINGS_CAP in the big table and change this:
>
>         INFO_FL_CLEAR(v4l2_dv_timings_cap, type)
>
> to this:
>
>         INFO_FL_CLEAR(v4l2_dv_timings_cap, pad)
>
> We never noticed this because we never tested this for subdevs. And that's
> why you write compliance tests!

Indeed that fixes it. I'll add that patch to my series.

All of the items on your review of v7 make sense and I'll be posting a
v8 hopefully shortly.

Thanks!

Tim

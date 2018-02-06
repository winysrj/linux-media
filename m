Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43284 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752514AbeBFTGE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 14:06:04 -0500
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Tim Harvey <tharvey@gateworks.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
 <CAJ+vNU1erjHtttuctgR=xd_XmhvxzyuhqdmyfOLKFVaiVf=ufg@mail.gmail.com>
 <c1f94f39-8f20-8503-9619-3108190d77c6@xs4all.nl>
 <CAJ+vNU15Q2C3mC4DjHKhX+56w-o-U4nOqndZwg6ncC2SCAaUhw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9fd654a6-086a-bb00-b84f-383580e18fee@xs4all.nl>
Date: Tue, 6 Feb 2018 20:05:57 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU15Q2C3mC4DjHKhX+56w-o-U4nOqndZwg6ncC2SCAaUhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2018 07:48 PM, Tim Harvey wrote:
> On Mon, Feb 5, 2018 at 11:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/06/2018 08:16 AM, Tim Harvey wrote:
>>> On Sat, Feb 3, 2018 at 7:56 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> <snip>
>>>
>>> With regards to the 3 failures:
>>>
>>> 1. test VIDIOC_G/S_EDID: FAIL
>>> This is a valid catch where I was returning -EINVAL when the caller
>>> was simply querying the edid - I've fixed it in my driver
>>>
>>> 2. test VIDIOC_DV_TIMINGS_CAP: FAIL
>>> fail: v4l2-test-io-config.cpp(375): doioctl(node,
>>> VIDIOC_DV_TIMINGS_CAP, &timingscap) != EINVAL
>>> fail: v4l2-test-io-config.cpp(392): EDID check failed for source pad 0.
>>>
>>> It looks like the purpose of the test is to do an ioctl with an
>>> invalid pad setting to ensure -EINVAL is returned. However by the time
>>> the VIDIOC_DV_TIMINGS_CAP ioctl used here gets routed to a
>>
>> No, VIDIOC_SUBDEV_DV_TIMINGS_CAP == VIDIOC_DV_TIMINGS_CAP, i.e. the
>> v4l-subdev API reuses the same ioctl as is used in the 'main' V4L2 API.
>> See include/uapi/linux/v4l2-subdev.h at the end for a list of 'alias'
>> ioctls.
> 
> Ah... thanks - I realized that was happening somehow but couldn't see how :)
> 
>>
>> Looking at v7 your tda1997x_get_dv_timings_cap() function doesn't check
>> for a valid pad field. Same for tda1997x_enum_dv_timings().
> 
> Right - I noticed this right off as well - I've added pad validation
> but that didn't resolve the failure.
> 
> The test failing is:
> 
>         memset(&timingscap, 0, sizeof(timingscap));
>         timingscap.pad = node->is_subdev() ? node->entity.pads : 1;
> ^^^^ this sets pad=node->entity.pads=1 which is invalid
>         fail_on_test(doioctl(node, VIDIOC_DV_TIMINGS_CAP, &timingscap)
> != EINVAL);
> ^^^^ tda1997x_get_dv_timings_cap() gets called with cap->pad = 0 which
> is valid to returns 0. I don't understand how the userspace pad=1 get
> changed to pad=0 in my handler.

Actually, you don't need to test the pad in the driver, I just looked at
the code in v4l2-core/v4l2-subdev.c and the pad is tested there already.

And I just found why it is cleared: it's a bug in v4l2-ioctl.c.

Look up VIDIOC_DV_TIMINGS_CAP in the big table and change this:

	INFO_FL_CLEAR(v4l2_dv_timings_cap, type)

to this:

	INFO_FL_CLEAR(v4l2_dv_timings_cap, pad)

We never noticed this because we never tested this for subdevs. And that's
why you write compliance tests!

> 
>>
>>> VIDIOC_SUBDEV_DV_TIMINGS_CAP the pad is changed to 0 which is valid.
>>> I'm not following what's going on here.
>>>
>>> 3. test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
>>> fail: v4l2-test-subdevs.cpp(303): fmt.code == 0 || fmt.code == ~0U
>>> fail: v4l2-test-subdevs.cpp(342): checkMBusFrameFmt(node, fmt.format)
>>>
>>> This is reporting that a VIDIOC_SUBDEV_G_FMT with
>>> which=V4L2_SUBDEV_FORMAT_TRY returns format->code = 0. The following
>>> is my set_format:
>>>
>>> static int tda1997x_get_format(struct v4l2_subdev *sd,
>>>                                struct v4l2_subdev_pad_config *cfg,
>>>                                struct v4l2_subdev_format *format)
>>> {
>>>         struct tda1997x_state *state = to_state(sd);
>>>
>>>         v4l_dbg(1, debug, state->client, "%s pad=%d which=%d\n",
>>>                 __func__, format->pad, format->which);
>>>         if (format->pad != TDA1997X_PAD_SOURCE)
>>>                 return -EINVAL;
>>>
>>>         tda1997x_fill_format(state, &format->format);
>>>
>>>         if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>>>                 struct v4l2_mbus_framefmt *fmt;
>>>
>>>                 fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>>>                 format->format.code = fmt->code;
>>>         } else {
>>>                 format->format.code = state->mbus_code;
>>>         }
>>>
>>>         return 0;
>>> }
>>>
>>> I don't at all understand the V4L2_SUBDEV_FORMAT_TRY logic here which
>>> I took from other subdev drivers as boilerplate. Is the test valid?
>>
>> The test is valid, this really shouldn't return a 0 code. But I am not
>> sure what the right logic is. I'll need to do some digging myself.
> 
> I got lost in the v4l2_subdev_get_try_format implementation but closer
> inspection shows me that v4l2_subdev_get_try_format returns the
> try_fmt field of the v4l2_subdev_pad_config used for storing subdev
> pad info. What I'm missing is how that struct/field gets initialized?
> Do I need to implement an init_cfg op?

See my review of v7.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:58849 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750770AbeBIHlL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 02:41:11 -0500
Subject: Re: [PATCH v9 6/8] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1518043367-11531-1-git-send-email-tharvey@gateworks.com>
 <1518043367-11531-7-git-send-email-tharvey@gateworks.com>
 <f19fd00d-66fb-a4a2-295b-d4bfae3b4e51@xs4all.nl>
 <CAJ+vNU1CTUQ9EFiV09XeihSHeAMw3C=0JYFL+NPM=DOTTrAP4w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d31d879e-d55a-c300-4c6d-f0d75c575f83@xs4all.nl>
Date: Fri, 9 Feb 2018 08:41:06 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU1CTUQ9EFiV09XeihSHeAMw3C=0JYFL+NPM=DOTTrAP4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2018 07:01 AM, Tim Harvey wrote:
>>> +static int
>>> +tda1997x_g_input_status(struct v4l2_subdev *sd, u32 *status)
>>> +{
>>> +     struct tda1997x_state *state = to_state(sd);
>>> +
>>> +     mutex_lock(&state->lock);
>>> +     if (state->detected_timings)
>>
>> What this actually tests if the driver was able to detect a valid signal
>> and lock to it.
>>
>> In practice you have three possible outcomes:
>>
>> - There is no HDMI signal at all: return V4L2_IN_ST_NO_SIGNAL
>> - There is a signal, but the receiver could not lock to it: return V4L2_IN_ST_NO_SYNC
>> - There is a signal, and the receiver could lock: return 0.
>>
>> Just because this returns 0, doesn't mean that QUERY_DV_TIMINGS will succeed.
>> There may be other constraints (e.g. the driver doesn't support certain formats
>> such as interlaced) that can cause QUERY_DV_TIMINGS to return an error, even
>> though the receiver could sync.
>>
>> Usually the hardware has some bits that tell whether there is a signal
>> (usually the TMDS clock) and whether it could sync or not (H and V syncs).
>>
>> That's really all you need to test here.
> 
> makes sense. I don't have any decent documentation on the TMDS regs
> used in tda1997x_read_activity_status but I can use the some other
> things to determine this.
> 
> I don't see v4l2-subdev.c (or anything) ever calling g_input_status.
> How do I test this?

Huh, that's a very good question! It is meant to be called by bridge
drivers implementing VIDIOC_ENUMINPUT. But that doesn't apply to the imx
driver since it is expecting userspace to talk directly to the subdev.

Now for the DV_TIMINGS API this doesn't matter all that much since
QUERY_DV_TIMINGS can do the same job through the returned error code, but
for analog TV there is no such option (QUERYSTD doesn't support such
detailed feedback).

I see that you have an adv7180 in your system. Can you run
'v4l2-compliance -uX' for the adv7180 subdev and post the output here?

Analog TV receivers are rare in MC bridge drivers, and I see that the subdev
API doesn't even support the G/S/QUERY/ENUM_STD ioctls! I think the adv7180 is
basically unusable in your system. And we need a subdev replacement for
VIDIOC_ENUMINPUT.

Was the adv7180 ever tested? Are you able to test it?

Regards,

	Hans

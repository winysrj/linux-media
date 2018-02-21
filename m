Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34074 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933537AbeBUNLl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 08:11:41 -0500
Subject: Re: [PATCHv2] media: add tuner standby op, use where needed
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <06ad8080-255f-b770-40b7-e6bc98b6ce60@cisco.com>
 <1537413.80bhSTNWuA@avalon> <52db5ff1-c91c-f210-6a09-68522128d336@xs4all.nl>
 <3222129.ciFPb3AyAM@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1346de8d-cc81-2831-051d-200da9edd52d@xs4all.nl>
Date: Wed, 21 Feb 2018 14:11:36 +0100
MIME-Version: 1.0
In-Reply-To: <3222129.ciFPb3AyAM@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/18 13:37, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday, 21 February 2018 09:40:29 EET Hans Verkuil wrote:
>> On 02/21/2018 01:02 AM, Laurent Pinchart wrote:
>>> On Tuesday, 20 February 2018 11:44:20 EET Hans Verkuil wrote:
>>>> The v4l2_subdev core s_power op was used for two different things: power
>>>> on/off sensors or video decoders/encoders and to put a tuner in standby
>>>> (and only the tuner!). There is no 'tuner wakeup' op, that's done
>>>> automatically when the tuner is accessed.
>>>>
>>>> The danger with calling (s_power, 0) to put a tuner into standby is that
>>>> it is usually broadcast for all subdevs. So a video receiver subdev that
>>>> supports s_power will also be powered off, and since there is no
>>>> corresponding (s_power, 1) they will never be powered on again.
>>>>
>>>> In addition, this is specifically meant for tuners only since they draw
>>>> the most current.
>>>>
>>>> This patch adds a new tuner op called 'standby' and replaces all calls to
>>>> (core, s_power, 0) by (tuner, standby). This prevents confusion between
>>>> the two uses of s_power. Note that there is no overlap: bridge drivers
>>>> either just want to put the tuner into standby, or they deal with
>>>> powering on/off sensors. Never both.
>>>>
>>>> This also makes it easier to replace s_power for the remaining bridge
>>>> drivers with some PM code later.
>>>>
>>>> Whether we want something cleaner for tuners in the future is a separate
>>>> topic. There is a lot of legacy code surrounding tuners, and I am very
>>>> hesitant about making changes there.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>> Changes since v1:
>>>> - move the standby op to the tuner_ops, which makes much more sense.
>>>> ---
>>>
>>> [snip]
>>>
>>>> diff --git a/drivers/media/v4l2-core/tuner-core.c
>>>> b/drivers/media/v4l2-core/tuner-core.c index 82852f23a3b6..cb126baf8771
>>>> 100644
>>>> --- a/drivers/media/v4l2-core/tuner-core.c
>>>> +++ b/drivers/media/v4l2-core/tuner-core.c
>>>> @@ -1099,23 +1099,15 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
>>>>   */
>>>>  
>>>>  /**
>>>> - * tuner_s_power - controls the power state of the tuner
>>>> + * tuner_standby - controls the power state of the tuner
>>>
>>> I'd update the description too.
>>>
>>>>   * @sd: pointer to struct v4l2_subdev
>>>>   * @on: a zero value puts the tuner to sleep, non-zero wakes it up
>>>
>>> And this parameter doesn't exist anymore. You could have caught that by
>>> compiling the documentation.
>>
>> Oops! I'll make a v3. Thanks for catching this.
>>
>>>>   */
>>>> -static int tuner_s_power(struct v4l2_subdev *sd, int on)
>>>> +static int tuner_standby(struct v4l2_subdev *sd)
>>>>  {
>>>>  	struct tuner *t = to_tuner(sd);
>>>>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>>>>
>>>> -	if (on) {
>>>> -		if (t->standby && set_mode(t, t->mode) == 0) {
>>>> -			dprintk("Waking up tuner\n");
>>>> -			set_freq(t, 0);
>>>> -		}
>>>> -		return 0;
>>>> -	}
>>>> -
>>>
>>> Interesting how this code was not used. I've had a look at tuner-core
>>> driver out of curiosity, it clearly shows its age :/ I2C address probing
>>> belongs to another century.
>>
>> Not really. It's still needed for USB/PCI devices.
> 
> Why is that ?

1) Historical: in the past we never kept track of e.g. i2c addresses but
   always relied on probing. We're stuck with that.

2) You can have different devices with the same IDs. And no way of knowing
   what's on there except by probing. Quite often they swap the tuner for
   another tuner with a different i2c address without changing the IDs.
   Most tuner devices use the same Philips-based registers so they can be
   handled by the same driver (tuner-simple), but the i2c addresses are
   all over the place.

   But also other devices can be changed, or two vendors used the same
   reference design, each made changes but never updated the IDs from the
   original design.

Basically it's much less structured than a proper device tree for a board.

Regards,

	Hans

> 
>> I was also surprised that it wasn't used. I expected to see some internal
>> calls to tuner_s_power(sd, 1) to turn things on, but that's not what
>> happened.
>>
>>>>  	dprintk("Putting tuner to sleep\n");
>>>>  	t->standby = true;
>>>>  	if (analog_ops->standby)
> 
> [snip]
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35094 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbKKMUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 07:20:24 -0500
MIME-Version: 1.0
In-Reply-To: <56433063.3010401@xs4all.nl>
References: <1447243114-1011-1-git-send-email-ricardo.ribalda@gmail.com> <56433063.3010401@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 11 Nov 2015 13:20:02 +0100
Message-ID: <CAPybu_2=S-H_AEa4usdNEJt6psrRD+C4sjuPUCVoGZWpt+t_8w@mail.gmail.com>
Subject: Re: [PATCH] v4l2-core/v4l2-ctrls: Filter NOOP CH_RANGE events
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Dimitrios Katsaros <patcherwork@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

On my cameras, the framerate can be controlled in very fine steps (so
you can be in sync with the conveyor belt). The exposure time is
dependent on the framerate. I was calling modify_range every time
there was a change on the framerate on all the different heads.
Leading to invalid/noop events.

I have already fixed it on my sensor code, but there is a lot of copy
paste.... I thought that check belong to the framework. It also will
give some consistency, because If my memory is good, set_ctrl does not
send and event if the value is unchanged.


Thanks :)

And take as much time as you need for   V4L2_CTRL_WHICH_DEF_VAL :-)



On Wed, Nov 11, 2015 at 1:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/11/15 12:58, Ricardo Ribalda Delgado wrote:
>> If modify_range is called but no range is changed, do not send the
>> CH_RANGE event.
>
> While not opposed to this patch, I do wonder what triggered this patch?
> Is it just a matter of efficiency? And since it is a driver that calls
> this, shouldn't the driver only call this function when something
> actually changes?
>
> In other words, can you give some background information?
>
> Regards,
>
>         Hans
>
> PS: still haven't processed your V4L2_CTRL_WHICH_DEF_VAL patch series. Hope
> to do this next week at the latest.
>
>>
>> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 23 ++++++++++++++---------
>>  1 file changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 4a1d9fdd14bb..f9c0e8150bd1 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -3300,7 +3300,8 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
>>  int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>>                       s64 min, s64 max, u64 step, s64 def)
>>  {
>> -     bool changed;
>> +     bool value_changed;
>> +     bool range_changed = false;
>>       int ret;
>>
>>       lockdep_assert_held(ctrl->handler->lock);
>> @@ -3324,10 +3325,14 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>>       default:
>>               return -EINVAL;
>>       }
>> -     ctrl->minimum = min;
>> -     ctrl->maximum = max;
>> -     ctrl->step = step;
>> -     ctrl->default_value = def;
>> +     if ((ctrl->minimum != min) || (ctrl->maximum != max) ||
>> +             (ctrl->step != step) || ctrl->default_value != def) {
>> +             range_changed = true;
>> +             ctrl->minimum = min;
>> +             ctrl->maximum = max;
>> +             ctrl->step = step;
>> +             ctrl->default_value = def;
>> +     }
>>       cur_to_new(ctrl);
>>       if (validate_new(ctrl, ctrl->p_new)) {
>>               if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
>> @@ -3337,12 +3342,12 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>>       }
>>
>>       if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
>> -             changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
>> +             value_changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
>>       else
>> -             changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
>> -     if (changed)
>> +             value_changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
>> +     if (value_changed)
>>               ret = set_ctrl(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
>> -     else
>> +     else if (range_changed)
>>               send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
>>       return ret;
>>  }
>>



-- 
Ricardo Ribalda

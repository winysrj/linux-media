Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38325 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbeBTJV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 04:21:57 -0500
Subject: Re: [RFC PATCH] Add core tuner_standby op, use where needed
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <b94bf7a2-27b3-94f5-5eb9-88462c92ca38@xs4all.nl>
 <2482708.3kx7sGYsxZ@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1efe0682-6942-9852-ab85-c5e706f962f8@xs4all.nl>
Date: Tue, 20 Feb 2018 10:21:49 +0100
MIME-Version: 1.0
In-Reply-To: <2482708.3kx7sGYsxZ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/18 20:27, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday, 19 February 2018 15:12:05 EET Hans Verkuil wrote:
>> The v4l2_subdev core s_power op was used to two different things: power
>> on/off sensors or video decoders/encoders and to put a tuner in standby
>> (and only the tuner). There is no 'tuner wakeup' op, that's done
>> automatically when the tuner is accessed.
>>
>> The danger with calling (s_power, 0) to put a tuner into standby is that it
>> is usually broadcast for all subdevs. So a video receiver subdev that also
>> supports s_power will also be powered off, and since there is no
>> corresponding (s_power, 1) they will never be powered on again.
>>
>> In addition, this is specifically meant for tuners only since they draw the
>> most current.
>>
>> This patch adds a new core op called 'tuner_standby' and replaces all calls
>> to (s_power, 0) by tuner_standby. This prevents confusion between the two
>> uses of s_power. Note that there is no overlap: bridge drivers either just
>> want to put the tuner into standby, or they deal with powering on/off
>> sensors. Never both.
>>
>> This also makes it easier to replace s_power for the remaining bridge
>> drivers with some PM code later.
>>
>> Whether we want something similar for tuners in the future is a separate
>> topic. There is a lot of legacy code surrounding tuners, and I am very
>> hesitant about making changes there.
> 
> While I don't request you to make changes, someone should. I assume the tuners 
> are still maintained, aren't they ? :-)

Theoretically. DVB tuners are certainly maintained, but analog TV? I haven't
seen patches for such tuners in years.

>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
> 
> [snip]
>  
>>  static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 980a86c08fce..b214da92a5c0 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -184,6 +184,9 @@ struct v4l2_subdev_io_pin_config {
>>   * @s_power: puts subdevice in power saving mode (on == 0) or normal
>> operation *	mode (on == 1).
>>   *
>> + * @tuner_standby: puts the tuner in standby mode. It will be woken up
>> + *	automatically the next time it is used.
>> + *
>>   * @interrupt_service_routine: Called by the bridge chip's interrupt
>> service
>>   *	handler, when an interrupt status has be raised due to this subdev,
>>   *	so that this subdev can handle the details.  It may schedule work to be
>> @@ -212,6 +215,7 @@ struct v4l2_subdev_core_ops {
>>  	int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register
>> *reg); #endif
>>  	int (*s_power)(struct v4l2_subdev *sd, int on);
>> +	int (*tuner_standby)(struct v4l2_subdev *sd);
> 
> If it's a tuner operation, how about moving it to v4l2_subdev_tuner_ops ? That 
> would at least make it clear that it shouldn't be used by other drivers (and I 
> think we should also mention in the documentation that this is a legacy 
> operation that shouldn't be used for any new purpose).

That makes a lot of sense. I'll move it.

> 
>>  	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
>>  						u32 status, bool *handled);
>>  	int (*subscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,
> 
> I'd prefer the bridge drivers to be fixed to use s_power in a balanced way, 
> but I understand that it might be difficult to achieve in a timely fashion. 
> I'm thus not against this patch, but I don't think it makes too much sense to 
> merge it without a user, that is a patch series that works on removing 
> s_power.
> 

I actually think it is a nice cleanup/clarification regardless of removing
s_power. The s_power op was really abused for tuners. And let's be honest:
having s_power(0) and never s_power(1) was very confusing!

So I believe that this can go in regardless of the other work.

Regards,

	Hans

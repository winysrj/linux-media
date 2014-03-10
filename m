Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4972 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaCJXc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:32:59 -0400
Message-ID: <531E4BA0.7010407@xs4all.nl>
Date: Tue, 11 Mar 2014 00:32:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 1/3] v4l2-subdev.h: add g_tvnorms video op
References: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl> <1392637454-29179-2-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1403110014000.10570@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1403110014000.10570@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2014 12:23 AM, Guennadi Liakhovetski wrote:
> Hi Hans,
> 
> Thanks for taking care about this problem. I'm not sure it would be ok for 
> me to pull this specific patch via my tree, because it's for the V4L2 
> core, and the other 2 patches in this series depend on this one.

It's OK by me to pull this through your tree.

> But 
> anyway I've got a question to this patch:
> 
> On Mon, 17 Feb 2014, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> While there was already a g_tvnorms_output video op, it's counterpart for
>> video capture was missing. Add it.
>>
>> This is necessary for generic bridge drivers like soc-camera to set the
>> video_device tvnorms field correctly. Otherwise ENUMSTD cannot work.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/media/v4l2-subdev.h | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index d67210a..787d078 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -264,8 +264,11 @@ struct v4l2_mbus_frame_desc {
>>     g_std_output: get current standard for video OUTPUT devices. This is ignored
>>  	by video input devices.
>>  
>> -   g_tvnorms_output: get v4l2_std_id with all standards supported by video
>> -	OUTPUT device. This is ignored by video input devices.
>> +   g_tvnorms: get v4l2_std_id with all standards supported by the video
>> +	CAPTURE device. This is ignored by video output devices.
>> +
>> +   g_tvnorms_output: get v4l2_std_id with all standards supported by the video
>> +	OUTPUT device. This is ignored by video capture devices.
> 
> Why do we need two separate operations with the same functionality - one 
> for capture and one for output? Can we have subdevices, that need to 
> implement both? Besides, what about these two core ops:
> 
> 	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
> 	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
> 
> ? Seems like a slightly different approach is needed? Or am I missing 
> anything?

There are drivers (ivtv) that have both capture and output subdevices. Each can
have its own standard. Such drivers use v4l2_device_call_all() to call the
same op for all subdevs so any subdev that can handle that op gets called.
So they use it to call the s_std op to change the capture standard and they
call s_std_output to change the output standard.

If you can't tell the difference between capture tvnorms and output tvnorms this
becomes tricky to handle. Just keep the two separate and there is no confusion.

Note that the video ops have the g/s_std_output ops. It's due to historical
reasons that g/s_std ended up in the core ops. They probably should be moved to
the video ops, but it's just not worth the effort.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
>>     s_crystal_freq: sets the frequency of the crystal used to generate the
>>  	clocks in Hz. An extra flags field allows device specific configuration
>> @@ -308,6 +311,7 @@ struct v4l2_subdev_video_ops {
>>  	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
>>  	int (*g_std_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
>>  	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
>> +	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);
>>  	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
>>  	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
>>  	int (*s_stream)(struct v4l2_subdev *sd, int enable);
>> -- 
>> 1.8.5.2
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


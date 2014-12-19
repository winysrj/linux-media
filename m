Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52098 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbaLSLhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 06:37:20 -0500
Message-ID: <54940DE9.1020709@xs4all.nl>
Date: Fri, 19 Dec 2014 12:37:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/8] v4l2-subdev: drop unused op enum_mbus_fmt
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1412182307100.11953@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1412182307100.11953@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/18/2014 11:08 PM, Guennadi Liakhovetski wrote:
> Hi Hans,
> 
> On Thu, 4 Dec 2014, Hans Verkuil wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Weird, this op isn't used at all. Seems to be orphaned code.
>> Remove it.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/media/v4l2-subdev.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index b052184..5beeb87 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -342,8 +342,6 @@ struct v4l2_subdev_video_ops {
>>  			struct v4l2_dv_timings *timings);
>>  	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
>>  			     u32 *code);
>> -	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
>> -			     struct v4l2_frmsizeenum *fsize);
> 
> After so many cheerful acks I feel a bit bluffed, but... Your subject says 
> "drop enum_mbus_fmt" and your patch drops enum_mbus_fsizes... What am I 
> missing??

Oops. Obviously the function name in the subject is wrong.

Interesting that everyone (except you!) just read over that :-)

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
>>  	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
>>  			  struct v4l2_mbus_framefmt *fmt);
>>  	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
>> -- 
>> 2.1.3
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

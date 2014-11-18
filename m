Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42479 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaKRNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 08:36:18 -0500
MIME-Version: 1.0
In-Reply-To: <546B13CC.6050605@xs4all.nl>
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com> <546B13CC.6050605@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 18 Nov 2014 13:35:46 +0000
Message-ID: <CA+V-a8sZ0HwnBrYcaT_i3ExDQnYe05xABckqOCeECemngDEsjQ@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API
 for v4l2_subdev_get_try_*()
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Nov 18, 2014 at 9:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/17/14 11:41, Lad, Prabhakar wrote:
>> this patch removes the guard CONFIG_VIDEO_V4L2_SUBDEV_API
>> for v4l2_subdev_get_try_*() functions.
>> In cases where a subdev using v4l2_subdev_get_try_*() calls
>> internally and the bridge using subdev pad ops which is
>> not MC aware forces to select MEDIA_CONTROLLER, as
>> VIDEO_V4L2_SUBDEV_API is dependent on it.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  include/media/v4l2-subdev.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 5860292..076ca11 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -642,7 +642,6 @@ struct v4l2_subdev_fh {
>>  #define to_v4l2_subdev_fh(fh)        \
>>       container_of(fh, struct v4l2_subdev_fh, vfh)
>>
>> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>>  #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)                \
>>       static inline struct rtype *                                    \
>>       v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,       \
>> @@ -656,7 +655,6 @@ struct v4l2_subdev_fh {
>>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
>>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
>>  __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
>> -#endif
>>
>>  extern const struct v4l2_file_operations v4l2_subdev_fops;
>>
>>
>
> The problem is that v4l2_subdev_get_try_*() needs a v4l2_subdev_fh which
> you don't have if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined. So I don't
> see how removing the guards help with that.
>
Yes

> What can be done is that if CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
> then these functions return NULL.
>
exactly.

> BTW, one patch I will very happily accept is one where the __V4L2_SUBDEV_MK_GET_TRY
> is removed and these three try functions are just written as proper
> static inlines. I find it very obfuscated code.
>
the functions were initially inline itself which were changes into
macro's later.

> In addition, because it is a macro you won't find the function definitions
> if you grep on the function name.
>
> But any functional changes here need to be Acked by Laurent first.
>
Yes, ill probably wait until Laurent is back from his holidays.

Thanks,
--Prabhakar Lad

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20577 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2BQKsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 05:48:36 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZJ00B0FA0X1G40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 10:48:33 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZJ006N4A0XCI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 10:48:33 +0000 (GMT)
Date: Fri, 17 Feb 2012 11:48:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 4/6] V4L: Add get/set_frame_config subdev callbacks
In-reply-to: <4F3D86E5.9020809@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F3E3080.9020907@samsung.com>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
 <1329416639-19454-5-git-send-email-s.nawrocki@samsung.com>
 <4F3D86E5.9020809@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for your comments.

On 02/16/2012 11:44 PM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
>> Add subdev callbacks for setting up parameters of frame on media bus that
>> are not exposed to user space directly. This is more a stub containing
>> only parameters needed to setup V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 data
>> transmision and the associated frame embedded data.
>>
>> The @length field of struct v4l2_frame_config determines maximum number
>> of frame samples per frame, excluding embedded non-image data.
>>
>> @header_length and @footer length determine the size in bytes of data
>> embedded at frame beginning and end respectively.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  include/media/v4l2-subdev.h |   18 ++++++++++++++++++
>>  1 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index be74061..bd95f00 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -21,6 +21,7 @@
>>  #ifndef _V4L2_SUBDEV_H
>>  #define _V4L2_SUBDEV_H
>>  
>> +#include <linux/types.h>
>>  #include <linux/v4l2-subdev.h>
>>  #include <media/media-entity.h>
>>  #include <media/v4l2-common.h>
>> @@ -45,6 +46,7 @@ struct v4l2_fh;
>>  struct v4l2_subdev;
>>  struct v4l2_subdev_fh;
>>  struct tuner_setup;
>> +struct v4l2_frame_config;
>>  
>>  /* decode_vbi_line */
>>  struct v4l2_decode_vbi_line {
>> @@ -476,6 +478,10 @@ struct v4l2_subdev_pad_ops {
>>  		       struct v4l2_subdev_crop *crop);
>>  	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>>  		       struct v4l2_subdev_crop *crop);
>> +	int (*set_frame_config)(struct v4l2_subdev *sd, unsigned int pad,
>> +				struct v4l2_frame_config *fc);
>> +	int (*get_frame_config)(struct v4l2_subdev *sd, unsigned int pad,
>> +				struct v4l2_frame_config *fc);
>>  };
>>  
>>  struct v4l2_subdev_ops {
>> @@ -567,6 +573,18 @@ struct v4l2_subdev_fh {
>>  #define to_v4l2_subdev_fh(fh)	\
>>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>>  
>> +/**
>> + * struct v4l2_frame_config - media bus data frame configuration
>> + * @length: maximum number of media bus samples per frame
>> + * @header_length: size of embedded data at frame start (header)
>> + * @footer_length: size of embedded data at frame end (footer)
>> + */
>> +struct v4l2_frame_config {
>> +	size_t length;
>> +	size_t header_length;
>> +	size_t footer_length;
>> +};
>> +
>>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>>  static inline struct v4l2_mbus_framefmt *
>>  v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
>
> I think we need something a little more expressive to describe the
> metadata. Preferrably the structure of the whole frame.

Yes, that was my intention. This patch is really just a starting point.
I wanted this data structure to be describing the frame data organization,
not necessarily containing all the details about each frame's part. Those
would be available through other data structures/callbacks.

> Is the size of your metadata measured in just bytes? If we have a frame
> that has width and height the metadata is just spread to a number of
> lines. That's the case on the SMIA(++) driver, for example.

Yes, it's in bytes. Number of lines is not helpful when you have 2 frames
of distinct resolutions mixed in one data plane.

Then we need to express the number of lines as well. If we need only size
in bytes or size in number of pixel scan lines (without HBLANK ?) the probably
a union would do ? On the other hand, it would be not obvious to the hosts
which union member is used by which sensor. So maybe (just a rough idea):

struct v4l2_frame_config {
	struct {
		unsigned int num_lines;
		size_t length;
	} header;

	struct {
		size_t length;
	} data;

	struct {
		unsigned int num_lines;
		size_t length;
	} header;
};

?
> Is the length field intended to be what once was planned in
> v4l2_mbus_framefmt and later on as a control?

Yes, that's same thing. It seemed more appropriate to me to handle it this
way. If some subdevs need adjusting it from user space probably a private
control is good for that.

> Also, only some receivers will be able to separate the metadata from the
> rest of the frame. The above struct doesn't have information on the
> format of the metadata either.

I skipped it deliberately, given diversity of formats amongs various hardware.
I assumed metadata is passed transparently by the hosts and they don't need
to know all details of the meta data. Obviously that's something still could
be addressed in future, I guess...

> I admit that I should have written an RFC on this but it's my general
> lack of time that has prevented me from doing that. :-I

Yeah, AFAIR you brought up an idea of the frame description during previous
discussions. Still I can see nothing really preventing you from writing
the RFC :-)

-- 

Thanks,
Sylwester

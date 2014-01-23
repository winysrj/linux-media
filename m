Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4029 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaAWOX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 09:23:59 -0500
Message-ID: <52E125ED.90504@xs4all.nl>
Date: Thu, 23 Jan 2014 15:23:41 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 05/21] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-6-git-send-email-hverkuil@xs4all.nl> <52E04DEB.2000800@gmail.com>
In-Reply-To: <52E04DEB.2000800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/23/2014 12:02 AM, Sylwester Nawrocki wrote:
> On 01/20/2014 01:45 PM, Hans Verkuil wrote:
>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>
>> Add a new struct and ioctl to extend the amount of information you can
>> get for a control.
>>
>> It gives back a unit string, the range is now a s64 type, and the matrix
>> and element size can be reported through cols/rows/elem_size.
>>
>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>> ---
>>   include/uapi/linux/videodev2.h | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 4d7782a..9e5b7d4 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1272,6 +1272,34 @@ struct v4l2_queryctrl {
>>   	__u32		     reserved[2];
>>   };
>>
>> +/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
>> +struct v4l2_query_ext_ctrl {
>> +	__u32		     id;
>> +	__u32		     type;
>> +	char		     name[32];
>> +	char		     unit[32];
> 
>> +	union {
>> +		__s64 val;
>> +		__u32 reserved[4];
>> +	} min;
>> +	union {
>> +		__s64 val;
>> +		__u32 reserved[4];
>> +	} max;
>> +	union {
>> +		__u64 val;
>> +		__u32 reserved[4];
>> +	} step;
>> +	union {
>> +		__s64 val;
>> +		__u32 reserved[4];
>> +	} def;
> 
> Are these reserved[] arrays of any use ?

Excellent question. I'd like to know as well :-)

The idea is that if the type of the control is complex, then for certain types
it might still make sense to have a range. E.g. say that the type is v4l2_rect,
then you can define min/max/step/def v4l2_rect entries in the unions. Ditto
for a v4l2_fract (it would be nice to be able to specify the min/max allowed
scaling factors, for example).

The question is, am I over-engineering or is this the best idea since sliced
bread? Without the 'reserved' part this idea will be impossible to implement,
and I don't think it hurts to have it in.

> 
>> +	__u32                flags;
>> +	__u32                cols, rows;
> 
> nit: I would put them on separate lines and use full words.

Separate lines: no problem, but do I really have to write 'columns' in full? :-(

Regards,

	Hans

> 
>> +	__u32                elem_size;
>> +	__u32		     reserved[17];
>> +};
>> +
>>   /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
>>   struct v4l2_querymenu {
>>   	__u32		id;
>> @@ -1965,6 +1993,8 @@ struct v4l2_create_buffers {
>>      Never use these in applications! */
>>   #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>>
>> +#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
>> +
>>   /* Reminder: when adding new ioctls please add support for them to
>>      drivers/media/video/v4l2-compat-ioctl32.c as well! */
> 
> --
> Regards,
> Sylwester
> 


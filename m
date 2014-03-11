Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3191 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaCKU3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 16:29:45 -0400
Message-ID: <531F7229.9070306@xs4all.nl>
Date: Tue, 11 Mar 2014 21:29:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 05/35] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <1392631070-41868-6-git-send-email-hverkuil@xs4all.nl> <20140311164221.13537163@samsung.com>
In-Reply-To: <20140311164221.13537163@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2014 08:42 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Feb 2014 10:57:20 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add a new struct and ioctl to extend the amount of information you can
>> get for a control.
>>
>> It gives back a unit string, the range is now a s64 type, and the matrix
>> and element size can be reported through cols/rows/elem_size.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/uapi/linux/videodev2.h | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 4d7782a..858a6f3 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1272,6 +1272,35 @@ struct v4l2_queryctrl {
>>  	__u32		     reserved[2];
>>  };
>>  
>> +/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
>> +struct v4l2_query_ext_ctrl {
>> +	__u32		     id;
>> +	__u32		     type;
>> +	char		     name[32];
>> +	char		     unit[32];
>> +	union {
>> +		__s64 val;
>> +		__u32 reserved[4];
> 
> Why to reserve 16 bytes here? for anything bigger than 64
> bits, we could use a pointer.
> 
> Same applies to the other unions.

The idea was to allow space for min/max/step/def values for compound types
if applicable. But that may have been overengineering.

> 
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
> Please call it default. It is ok to simplify names inside a driver,
> but better to not do it at the API.

default_value, then. 'default' is a keyword. I should probably rename min and max
to minimum and maximum to stay in sync with v4l2_queryctrl.

> 
>> +	__u32                flags;
> 
>> +	__u32                cols;
>> +	__u32                rows;
>> +	__u32                elem_size;
> 
> The three above seem to be too specific for an array.
> 
> I would put those on a separate struct and add here an union,
> like:
> 
> 	union {
> 		struct v4l2_array arr;
> 		__u32 reserved[8];
> 	}

I have to sleep on this. I'm not sure this helps in any way.

> 
>> +	__u32		     reserved[17];
> 
> This also seems too much. Why 17?

It aligned the struct up to some nice number. Also, experience tells me that
whenever I limit the number of reserved fields it bites me later.

> 
>> +};
> 
>> +
>>  /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
>>  struct v4l2_querymenu {
>>  	__u32		id;
>> @@ -1965,6 +1994,8 @@ struct v4l2_create_buffers {
>>     Never use these in applications! */
>>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>>  
>> +#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
>> +
>>  /* Reminder: when adding new ioctls please add support for them to
>>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>>  
> 
> 

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9638 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbaAWPF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 10:05:26 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZV00FBA0L1L630@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Jan 2014 15:05:25 +0000 (GMT)
Message-id: <52E12FB2.5040308@samsung.com>
Date: Thu, 23 Jan 2014 16:05:22 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 05/21] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-6-git-send-email-hverkuil@xs4all.nl>
 <52E04DEB.2000800@gmail.com> <52E125ED.90504@xs4all.nl>
In-reply-to: <52E125ED.90504@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/01/14 15:23, Hans Verkuil wrote:
> On 01/23/2014 12:02 AM, Sylwester Nawrocki wrote:
>> On 01/20/2014 01:45 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>>
>>> Add a new struct and ioctl to extend the amount of information you can
>>> get for a control.
>>>
>>> It gives back a unit string, the range is now a s64 type, and the matrix
>>> and element size can be reported through cols/rows/elem_size.
>>>
>>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>>> ---
>>>   include/uapi/linux/videodev2.h | 30 ++++++++++++++++++++++++++++++
>>>   1 file changed, 30 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 4d7782a..9e5b7d4 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -1272,6 +1272,34 @@ struct v4l2_queryctrl {
>>>   	__u32		     reserved[2];
>>>   };
>>>
>>> +/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
>>> +struct v4l2_query_ext_ctrl {
>>> +	__u32		     id;
>>> +	__u32		     type;
>>> +	char		     name[32];
>>> +	char		     unit[32];
>>
>>> +	union {
>>> +		__s64 val;
>>> +		__u32 reserved[4];
>>> +	} min;
>>> +	union {
>>> +		__s64 val;
>>> +		__u32 reserved[4];
>>> +	} max;
>>> +	union {
>>> +		__u64 val;
>>> +		__u32 reserved[4];
>>> +	} step;
>>> +	union {
>>> +		__s64 val;
>>> +		__u32 reserved[4];
>>> +	} def;
>>
>> Are these reserved[] arrays of any use ?
> 
> Excellent question. I'd like to know as well :-)
> 
> The idea is that if the type of the control is complex, then for certain types
> it might still make sense to have a range. E.g. say that the type is v4l2_rect,
> then you can define min/max/step/def v4l2_rect entries in the unions. Ditto
> for a v4l2_fract (it would be nice to be able to specify the min/max allowed
> scaling factors, for example).

Huh, sorry, I misread the patch. Please ignore this comment.

Certainly we need an ability to query other compound control types as well.
16 bytes seems a reasonable size, I guess it is going to be sufficient for
most cases. If not we could add a pointer member to the union...?

> The question is, am I over-engineering or is this the best idea since sliced
> bread? Without the 'reserved' part this idea will be impossible to implement,
> and I don't think it hurts to have it in.

Yes, that's how I imagined it as well, I didn't mean questioning the union
idea at all.

>>> +	__u32                flags;
>>> +	__u32                cols, rows;
>>
>> nit: I would put them on separate lines and use full words.
> 
> Separate lines: no problem, but do I really have to write 'columns' in full? :-(

Yes, sorry, one shall abide by the rules! :-)

Really, it's up to you - as the author, I think you're entitled to decide
about such details. ;) The short version looks probably neater anyway.

--
Regards,
Sylwester

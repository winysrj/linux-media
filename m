Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31163 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3GIJSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 05:18:42 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPN000MKWJ0KO30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Jul 2013 10:18:40 +0100 (BST)
Message-id: <51DBD56F.6070706@samsung.com>
Date: Tue, 09 Jul 2013 11:18:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/5] v4l2: add matrix support.
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
 <1372422454-13752-2-git-send-email-hverkuil@xs4all.nl>
 <51D9E2BB.2080308@gmail.com> <201307080915.56953.hverkuil@xs4all.nl>
In-reply-to: <201307080915.56953.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2013 09:15 AM, Hans Verkuil wrote:
> On Sun July 7 2013 23:50:51 Sylwester Nawrocki wrote:
>> On 06/28/2013 02:27 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>>
>>> This patch adds core support for matrices: querying, getting and setting.
>>>
>>> Two initial matrix types are defined for motion detection (defining regions
>>> and thresholds).
>>>
>>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>>> ---
>>>   drivers/media/v4l2-core/v4l2-dev.c   |  3 ++
>>>   drivers/media/v4l2-core/v4l2-ioctl.c | 23 ++++++++++++-
>>>   include/media/v4l2-ioctl.h           |  8 +++++
>>>   include/uapi/linux/videodev2.h       | 64 ++++++++++++++++++++++++++++++++++++
>>>   4 files changed, 97 insertions(+), 1 deletion(-)
>>
[...]
>>> +/* Define to which motion detection region each element belongs.
>>> + * Each element is a __u8. */
>>> +#define V4L2_MATRIX_TYPE_MD_REGION     (1)
>>> +/* Define the motion detection threshold for each element.
>>> + * Each element is a __u16. */
>>> +#define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
>>> +
>>> +/**
>>> + * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
>>> + * @type:	matrix type
>>> + * @ref:	reference to some object (if any) owning the matrix
>>> + * @columns:	number of columns in the matrix
>>> + * @rows:	number of rows in the matrix
>>> + * @elem_min:	minimum matrix element value
>>> + * @elem_max:	maximum matrix element value
>>> + * @elem_size:	size in bytes each matrix element
>>> + * @reserved:	future extensions, applications and drivers must zero this.
>>> + */
>>> +struct v4l2_query_matrix {
>>> +	__u32 type;
>>> +	union {
>>> +		__u32 reserved[4];
>>> +	} ref;
>>> +	__u32 columns;
>>> +	__u32 rows;
>>> +	union {
>>> +		__s64 val;
>>> +		__u64 uval;
>>> +		__u32 reserved[4];
>>> +	} elem_min;
>>> +	union {
>>> +		__s64 val;
>>> +		__u64 uval;
>>> +		__u32 reserved[4];
>>> +	} elem_max;
>>> +	__u32 elem_size;
>>
>> How about reordering it to something like:
>>
>> 	struct {
>> 		union {
>> 			__s64 val;
>> 			__u64 uval;
>> 			__u32 reserved[4];
>> 		} min;
>> 		union {
>> 			__s64 val;
>> 			__u64 uval;
>> 			__u32 reserved[4];
>> 		} max;
>> 		__u32 size;
>> 	} element;
>>
>> ?
> 
> Makes sense, although I prefer 'elem' over the longer 'element'. Would that
> be OK with you?

Yes, I'm fine with that. Just thought using full words where sensible is
a good practice. But the shorter form seems better indeed in this case.

Regards,
Sylwester

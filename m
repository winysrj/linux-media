Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2311 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaCKUXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 16:23:42 -0400
Message-ID: <531F70BE.5060307@xs4all.nl>
Date: Tue, 11 Mar 2014 21:23:26 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 04/35] videodev2.h: add initial support for complex
 controls.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <1392631070-41868-5-git-send-email-hverkuil@xs4all.nl> <20140311163414.0c1f788e@samsung.com>
In-Reply-To: <20140311163414.0c1f788e@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 03/11/2014 08:34 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Feb 2014 10:57:19 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Complex controls are controls that can be used for compound and array
>> types. This allows for more complex data structures to be used with the
>> control framework.
>>
>> Such controls always have the V4L2_CTRL_FLAG_HIDDEN flag set. Note that
>> 'simple' controls can also set that flag.
>>
>> The existing V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate controls
>> that do not have the HIDDEN flag, so a new V4L2_CTRL_FLAG_NEXT_HIDDEN flag
>> is added to enumerate hidden controls. Set both flags to enumerate any
>> controls (hidden or not).
>>
>> Complex control types will start at V4L2_CTRL_COMPLEX_TYPES. In addition, any
>> control that uses the new 'p' field or the existing 'string' field will have
>> flag V4L2_CTRL_FLAG_IS_PTR set.
>>
>> While not strictly necessary, adding that flag makes life for applications
>> a lot simpler. If the flag is not set, then the control value is set
>> through the value or value64 fields of struct v4l2_ext_control, otherwise
>> a pointer points to the value.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  include/uapi/linux/videodev2.h | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 6ae7bbe..4d7782a 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1228,6 +1228,7 @@ struct v4l2_ext_control {
>>  		__s32 value;
>>  		__s64 value64;
>>  		char *string;
>> +		void *p;
> 
> Hmm... don't we have already "string" for pointers? Also, calling it
> as "p" inside an userspace api doesn't seem to nice ("ptr" would be
> better).
> 
> Btw, you likely already noticed the mess, as, when you added 
> this email's comment, you said that complex controls could
> either use "p" or "string".
> 
> Nack. It should just use "string". Let's not add even more complexity
> to this "complex" controls.

It is really, really weird to refer to a matrix type or struct type
through a 'string'. Also, the type of 'string' is a char pointer
which is totally wrong unless the type is really a string.

Finally there is a slight difference in handling strings: the size of
the memory 'string' points to just has to be large enough to store the
0-terminated string instead of being able to store the maximum possible
size of the string (max + 1). This is IMHO a design mistake regarding
strings on my part. I should always have required that the memory is
always sizes for the worst-case.

I might take another look if I can change this behavior without
breaking existing applications.

I don't mind changing 'p' to 'ptr', no problem.

> 
>>  	};
>>  } __attribute__ ((packed));
>>  
>> @@ -1252,7 +1253,10 @@ enum v4l2_ctrl_type {
>>  	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
>>  	V4L2_CTRL_TYPE_STRING        = 7,
>>  	V4L2_CTRL_TYPE_BITMASK       = 8,
>> -	V4L2_CTRL_TYPE_INTEGER_MENU = 9,
>> +	V4L2_CTRL_TYPE_INTEGER_MENU  = 9,
>> +
>> +	/* Complex types are >= 0x0100 */
>> +	V4L2_CTRL_COMPLEX_TYPES	     = 0x0100,
>>  };
> 
> Not sure if I got why you're calling it as "TYPES" and saying that
> everything >= 0x100 is complex. What's your idea here?

Types divide into 'simple' types (the ones we have today) and the
new complex (compound?) types. I need an easy way to determine
which it is, so any types with values >= 0x100 fall into the latter
category. Later in the patch series when such types are actually
added the meaning becomes more obvious.
 
> Also, at least for me with my engineering formation, "complex"
> means a number with an imaginary component.
> 
> And yes, we do have complex numbers on some usecases for
> V4L (for example, SDR in-phase/quadrature, e. g.  I/Q
> representation can be seen as an array of complex numbers).
> 
> So, I won't doubt that someone might propose some day to add a
> way to set a complex number via a V4L2 control.
> 
> So, please use a better naming here to avoid troubles.

COMPOUND_TYPES? Not a bad name, I think.

Regards,

	Hans

> 
>>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
>> @@ -1288,9 +1292,12 @@ struct v4l2_querymenu {
>>  #define V4L2_CTRL_FLAG_SLIDER 		0x0020
>>  #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
>>  #define V4L2_CTRL_FLAG_VOLATILE		0x0080
>> +#define V4L2_CTRL_FLAG_HIDDEN		0x0100
>> +#define V4L2_CTRL_FLAG_IS_PTR		0x0200
>>  
>> -/*  Query flag, to be ORed with the control ID */
>> +/*  Query flags, to be ORed with the control ID */
>>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
>> +#define V4L2_CTRL_FLAG_NEXT_HIDDEN	0x40000000
>>  
>>  /*  User-class control IDs defined by V4L2 */
>>  #define V4L2_CID_MAX_CTRLS		1024
> 
> 


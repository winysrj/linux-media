Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:22016 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0JEWci (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 18:32:38 -0400
Message-ID: <4CABA778.8070607@maxwell.research.nokia.com>
Date: Wed, 06 Oct 2010 01:32:24 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v3 01/11] v4l: Move the media/v4l2-mediabus.h header
 to include/linux
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CAB39AB.2070806@maxwell.research.nokia.com> <Pine.LNX.4.64.1010051728360.31708@axis700.grange> <201010051734.46667.hverkuil@xs4all.nl>
In-Reply-To: <201010051734.46667.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Hans Verkuil wrote:
> On Tuesday, October 05, 2010 17:30:21 Guennadi Liakhovetski wrote:
>> On Tue, 5 Oct 2010, Sakari Ailus wrote:
...
>>>> +/**
>>>> + * struct v4l2_mbus_framefmt - frame format on the media bus
>>>> + * @width:	frame width
>>>> + * @height:	frame height
>>>> + * @code:	data format code
>>>> + * @field:	used interlacing type
>>>> + * @colorspace:	colorspace of the data
>>>> + */
>>>> +struct v4l2_mbus_framefmt {
>>>> +	__u32				width;
>>>> +	__u32				height;
>>>> +	__u32				code;
>>>> +	enum v4l2_field			field;
>>>> +	enum v4l2_colorspace		colorspace;
>>>> +};
>>>
>>> I think this struct would benefit from some reserved fields since it's
>>> part of the user space interface.
>>
>> IIUC, this struct is not going to be used in ioctl()s, that's what struct 
>> v4l2_subdev_mbus_code_enum is for. But in this case - why don't we make 
>> the "code" field above of type "enum v4l2_mbus_pixelcode"?
> 
> Hmm, if it is not part of the public API, then it doesn't belong here at all.
> 
> media/v4l2-mediabus.h should be split in a media header and a linux header in
> that case.

The struct is embedded in other the ioctl structures, so it _is_ part of
the public API, although not used directly as an ioctl argument. Those
structs are added by patch 9.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

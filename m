Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:21959 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab0JEWbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 18:31:22 -0400
Message-ID: <4CABA72C.3070509@maxwell.research.nokia.com>
Date: Wed, 06 Oct 2010 01:31:08 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v3 01/11] v4l: Move the media/v4l2-mediabus.h header
 to include/linux
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com> <1286288714-16506-2-git-send-email-laurent.pinchart@ideasonboard.com> <4CAB39AB.2070806@maxwell.research.nokia.com> <Pine.LNX.4.64.1010051728360.31708@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010051728360.31708@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi!

Guennadi Liakhovetski wrote:
> On Tue, 5 Oct 2010, Sakari Ailus wrote:
...
>>> +/**
>>> + * struct v4l2_mbus_framefmt - frame format on the media bus
>>> + * @width:	frame width
>>> + * @height:	frame height
>>> + * @code:	data format code
>>> + * @field:	used interlacing type
>>> + * @colorspace:	colorspace of the data
>>> + */
>>> +struct v4l2_mbus_framefmt {
>>> +	__u32				width;
>>> +	__u32				height;
>>> +	__u32				code;
>>> +	enum v4l2_field			field;
>>> +	enum v4l2_colorspace		colorspace;
>>> +};
>>
>> I think this struct would benefit from some reserved fields since it's
>> part of the user space interface.
> 
> IIUC, this struct is not going to be used in ioctl()s, that's what struct 
> v4l2_subdev_mbus_code_enum is for. But in this case - why don't we make 

Oh, you're right. My mistake.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63063 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2BHWsd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 17:48:33 -0500
Received: by eekc14 with SMTP id c14so354082eek.19
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2012 14:48:31 -0800 (PST)
Message-ID: <4F32FBBB.7020007@gmail.com>
Date: Wed, 08 Feb 2012 23:48:27 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
References: <4F27CF29.5090905@samsung.com> <4637542.W3k3fJhoQF@avalon> <4F2D641A.5020900@gmail.com> <4116034.kVC1fDZsLk@avalon>
In-Reply-To: <4116034.kVC1fDZsLk@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/05/2012 02:30 PM, Laurent Pinchart wrote:
> On Saturday 04 February 2012 18:00:10 Sylwester Nawrocki wrote:
>> On 02/04/2012 12:34 PM, Laurent Pinchart wrote:
>>> On Thursday 02 February 2012 12:14:08 Sylwester Nawrocki wrote:
>>>> On 02/02/2012 10:55 AM, Laurent Pinchart wrote:
>>>>> Do all those sensors interleave the data in the same way ? This sounds
>>>>> quite
>>>>
>>>> No, each one uses it's own interleaving method.
>>>>
>>>>> hackish and vendor-specific to me, I'm not sure if we should try to
>>>>> generalize that. Maybe vendor-specific media bus format codes would be
>>>>> the way to go. I don't expect ISPs to understand the format, they will
>>>>> likely be configured in pass-through mode. Instead of adding explicit
>>>>> support for all those weird formats to all ISP drivers, it might make
>>>>> sense to add a "binary blob" media bus code to be used by the ISP.
>>>>
>>>> This could work, except that there is no way to match a fourcc with media
>>>> bus code. Different fourcc would map to same media bus code, making it
>>>> impossible for the brigde to handle multiple sensors or one sensor
>>>> supporting multiple interleaved formats. Moreover there is a need to map
>>>> media bus code to the MIPI-CSI data ID. What if one sensor sends "binary"
>>>> blob with MIPI-CSI "User Define Data 1" and the other with "User Define
>>>> Data 2" ?
>>>
>>> My gut feeling is that the information should be retrieved from the sensor
>>> driver. This is all pretty vendor-specific, and adding explicit support
>>> for such sensors to each bridge driver wouldn't be very clean. Could the
>>> bridge
>>
>> We have many standard pixel codes in include/linux/v4l2-mediabus.h, yet each
>> bridge driver supports only a subset of them. I wouldn't expect a sudden
>> need for all existing bridge drivers to support some strange interleaved
>> image formats.
> 
> Those media bus codes are standard, so implementing explicit support for them
> in bridge drivers is fine with me. What I want to avoid is adding explicit
> support for sensor-specific formats to bridges. There should be no dependency
> between the bridge and the sensor.

OK, I see your point. Naturally I agree here, even though sometimes the hardware
engineers make this process of getting rid of the dependencies more painful that
it really could be.

>>> query the sensor using a subdev operation ?
>>
>> There is also a MIPI-CSI2 receiver in between that needs to be configured.
>> I.e. it must know that it processes the User Defined Data 1, which implies
>> certain pixel alignment, etc. So far a media bus pixel codes have been
>> a base information to handle such things.
> 
> For CSI user-defined data types, I still think that the information required
> to configure the CSI receiver should come from the sensor. Only the sensor
> knows what user-defined data type it will generate.

I agree. Should we have separate callback at the sensor ops for this or should 
it belong to a bigger data structure (like the "frame description" structure 
mentioned before) ? The latter might be more reasonable.

>>>> Maybe we could create e.g. V4L2_MBUS_FMT_USER?, for each MIPI-CSI User
>>>> Defined data identifier, but as I remember it was decided not to map
>>>> MIPI-CSI data codes directly onto media bus pixel codes.
>>>
>>> Would setting the format directly on the sensor subdev be an option ?
>>
>> Do you mean setting a MIPI-CSI2 format ?
> 
> No, I mean setting the media bus code on the sensor output pad to a vendor-
> specific value.

I'm afraid we need a vendor/sensor specific format identifier since the sensor
produces truly vendor specific format. In fact this format is made to overcome
hardware limitations of the video bridge. We can of course standardize things 
like: embedded (non-image) data presence and size at beginning and an end of 
frame, MIPI-CSIS2 data type, interleaving method (different data type and/or 
virtual channel), etc. But still there will be some crap that is relevant to 
only one hardware type and it would need to be distinguished in some way.

--

Regards,
Sylwester

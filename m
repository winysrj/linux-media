Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62936 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2BDRAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 12:00:14 -0500
Received: by eaah12 with SMTP id h12so1877142eaa.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 09:00:13 -0800 (PST)
Message-ID: <4F2D641A.5020900@gmail.com>
Date: Sat, 04 Feb 2012 18:00:10 +0100
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
References: <4F27CF29.5090905@samsung.com> <201202021055.19705.laurent.pinchart@ideasonboard.com> <4F2A7000.7080201@samsung.com> <4637542.W3k3fJhoQF@avalon>
In-Reply-To: <4637542.W3k3fJhoQF@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/04/2012 12:34 PM, Laurent Pinchart wrote:
> On Thursday 02 February 2012 12:14:08 Sylwester Nawrocki wrote:
>> On 02/02/2012 10:55 AM, Laurent Pinchart wrote:
>>> Do all those sensors interleave the data in the same way ? This sounds
>>> quite
>> No, each one uses it's own interleaving method.
>>
>>> hackish and vendor-specific to me, I'm not sure if we should try to
>>> generalize that. Maybe vendor-specific media bus format codes would be
>>> the way to go. I don't expect ISPs to understand the format, they will
>>> likely be configured in pass-through mode. Instead of adding explicit
>>> support for all those weird formats to all ISP drivers, it might make
>>> sense to add a "binary blob" media bus code to be used by the ISP.
>>
>> This could work, except that there is no way to match a fourcc with media
>> bus code. Different fourcc would map to same media bus code, making it
>> impossible for the brigde to handle multiple sensors or one sensor
>> supporting multiple interleaved formats. Moreover there is a need to map
>> media bus code to the MIPI-CSI data ID. What if one sensor sends "binary"
>> blob with MIPI-CSI "User Define Data 1" and the other with "User Define
>> Data 2" ?
> 
> My gut feeling is that the information should be retrieved from the sensor
> driver. This is all pretty vendor-specific, and adding explicit support for
> such sensors to each bridge driver wouldn't be very clean. Could the bridge

We have many standard pixel codes in include/linux/v4l2-mediabus.h, yet each
bridge driver supports only a subset of them. I wouldn't expect a sudden
need for all existing bridge drivers to support some strange interleaved 
image formats.

> query the sensor using a subdev operation ?

There is also a MIPI-CSI2 receiver in between that needs to be configured.
I.e. it must know that it processes the User Defined Data 1, which implies
certain pixel alignment, etc. So far a media bus pixel codes have been 
a base information to handle such things.

>> Maybe we could create e.g. V4L2_MBUS_FMT_USER?, for each MIPI-CSI User
>> Defined data identifier, but as I remember it was decided not to map
>> MIPI-CSI data codes directly onto media bus pixel codes.
> 
> Would setting the format directly on the sensor subdev be an option ?

Do you mean setting a MIPI-CSI2 format ?
It should work as long as the bridge driver can identify media bus code
given a fourcc. I can't recall situation where a reverse lookup is
necessary, i.e. struct v4l2_mbus_framefmt::code -> fourcc. This would
fail since e.g. JPEG and YUV/JPEG would both correspond to User 1 format.

--

Regards,
Sylwester

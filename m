Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35615 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2BALlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 06:41:47 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYP001FVPTLGS@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 11:41:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYP00GGQPTLDA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 11:41:45 +0000 (GMT)
Date: Wed, 01 Feb 2012 12:41:44 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <20120201100007.GA841@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F2924F8.3040408@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <4F27CF29.5090905@samsung.com>
 <20120201100007.GA841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/01/2012 11:00 AM, Sakari Ailus wrote:
>> Some camera sensors generate data formats that cannot be described using
>> current convention of the media bus pixel code naming.
>>
>> For instance, interleaved JPEG data and raw VYUY. Moreover interleaving
>> is rather vendor specific, IOW I imagine there might be many ways of how
>> the interleaving algorithm is designed.
> 
> Is that truly interleaved, or is that e.g. first yuv and then jpeg?
> Interleaving the two sounds quite strange to me.

It's truly interleaved. There might be some chance for yuv/jpeg one after
the other, but the interleaved format needs to be supported.

>> I'm wondering how to handle this. For sure such an image format will need
>> a new vendor-specific fourcc. Should we have also vendor specific media bus code ?
>>
>> I would like to avoid vendor specific media bus codes as much as possible.
>> For instance defining something like
>>
>> V4L2_MBUS_FMT_VYUY_JPEG_1X8
>>
>> for interleaved VYUY and JPEG data might do, except it doesn't tell anything
>> about how the data is interleaved.
>>
>> So maybe we could add some code describing interleaving (xxxx)
>>
>> V4L2_MBUS_FMT_xxxx_VYUY_JPEG_1X8
>>
>> or just the sensor name instead ?
> 
> If that format is truly vendor specific, I think a vendor or sensor specific
> media bus code / 4cc would be the way to go. On the other hand, you must be
> prepared to handle these formats in your ISP driver, too.

Yes, I don't see an issue in adding a support for a new format in ISP/bridge
driver, it needs to know anyway e.g. what MIPI-CSI data type corresponds
to the data from sensor.

> I'd guess that all the ISP would do to such formats is to write them to
> memory since I don't see much use for either in ISPs --- both typically are
> output of the ISP.

Yep, correct. In fact in those cases the sensor has complicated ISP built in,
so everything a bridge have to do is to pass data over to user space.

Also non-image data might need to be passed to user space as well.

> I think we will need to consider use cases where the sensors produce other
> data than just the plain image: I've heard of a sensor producing both
> (consecutively, I understand) and there are sensors that produce metadata as
> well. For those, we need to specify the format of the full frame, not just
> the image data part of it --- which we have called "frame" at least up to
> this point.

Yes, moreover such formats partly determine data layout in memory, rather than
really just a format on a video bus.

> If the case is that the ISP needs this kind of information from the sensor
> driver to be able to handle this kind of data, i.e. to write the JPEG and
> YUV to separate memory locations, I'm proposing to start working on this

It's not the case here, it would involve unnecessary copying in kernel space.
Even in case of whole consequitive data planes contiguous buffer is needed.
And it's not easy to split because the border between the data planes cannot
be arbitrarily aligned.

> now rather than creating a single hardware-specific solution.

Yes, I'm attempting rather generic approach, even just for that reason that
there are multiple Samsung sensors that output hybrid data. I've seen Sony
sensor doing that as well.


Regards
-- 
Sylwester Nawrocki
Samsung Poland R&D Center

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56240 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1KVLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 06:54:43 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV200F2X936V3@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Nov 2011 11:54:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV200IC89358F@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Nov 2011 11:54:42 +0000 (GMT)
Date: Tue, 22 Nov 2011 12:54:41 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH v1 1/3] v4l: Add new framesamples field to struct
 v4l2_mbus_framefmt
In-reply-to: <4ECB827A.7020405@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4ECB8D81.90108@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1321955740-24452-1-git-send-email-s.nawrocki@samsung.com>
 <1321955740-24452-2-git-send-email-s.nawrocki@samsung.com>
 <4ECB827A.7020405@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 11/22/2011 12:07 PM, Tomasz Stanislawski wrote:
> On 11/22/2011 10:55 AM, Sylwester Nawrocki wrote:
>> The purpose of the new field is to allow the video pipeline elements to
>> negotiate memory buffer size for compressed data frames, where the buffer
>> size cannot be derived from pixel width and height and the pixel code.
>>
>> For VIDIOC_SUBDEV_S_FMT and VIDIOC_SUBDEV_G_FMT ioctls, the framesamples
>> parameter should be calculated by the driver from pixel width, height,
>> color format and other parameters if required and returned to the caller.
>> This applies to compressed data formats only.
>>
>> The application should propagate the framesamples value, whatever returned
>> at the first sub-device within a data pipeline, i.e. at the pipeline's data
>> source.
>>
>> For compressed data formats the host drivers should internally validate
>> the framesamples parameter values before streaming is enabled, to make sure
>> the memory buffer size requirements are satisfied along the pipeline.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/DocBook/media/v4l/subdev-formats.xml |    7 ++++++-
>>   include/linux/v4l2-mediabus.h                      |    4 +++-
>>   2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> b/Documentation/DocBook/media/v4l/subdev-formats.xml
>> index 49c532e..d0827b4 100644
>> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
>> @@ -35,7 +35,12 @@
>>       </row>
>>       <row>
>>       <entry>__u32</entry>
>> -    <entry><structfield>reserved</structfield>[7]</entry>
>> +    <entry><structfield>framesamples</structfield></entry>
> 
> Why you do not use name sizeimage?

The media bus format data structure describes data as seen on the media bus,
in general single subdevs might not know how data samples are translated into
data in memory. So, not in my opinion only, the name 'framesamples' is more 
appropriate, even though the translation of some media bus data formats into 
data in memory is straightforward.
We've discussed this roughly several times, e.g. during the Cambourne meeting.

> It is used in struct v4l2_plane_pix_format and struct v4l2_pix_format?
> 
> Should old drivers be modified to update this field?

I think the drivers that expose a sub-device node to user space might need to
be modified to set the framesamples field to 0 for raw formats. There is about
9 of them in the mainline AFAICS, and only two use compressed formats.


--
Regards,
Sylwester

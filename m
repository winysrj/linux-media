Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24321 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1KXPxO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 10:53:14 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV600MMP9GO8H@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 15:53:12 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV6004529GOR0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 15:53:12 +0000 (GMT)
Date: Thu, 24 Nov 2011 16:53:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add a global color alpha control
In-reply-to: <201111241500.23204.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@redhat.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4ECE6868.8000503@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com>
 <201111241306.11651.laurent.pinchart@ideasonboard.com>
 <201111241322.10889.hverkuil@xs4all.nl>
 <201111241500.23204.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2011 03:00 PM, Laurent Pinchart wrote:
> On Thursday 24 November 2011 13:22:10 Hans Verkuil wrote:
>> On Thursday, November 24, 2011 13:06:09 Laurent Pinchart wrote:
>>> On Thursday 24 November 2011 12:49:00 Hans Verkuil wrote:
>>>> On Thursday, November 24, 2011 12:39:54 Sylwester Nawrocki wrote:
>>>>> On 11/24/2011 12:09 PM, Laurent Pinchart wrote:
>>>>>> On Thursday 24 November 2011 12:00:45 Hans Verkuil wrote:
>>>>>>> On Thursday, November 24, 2011 11:53:16 Sylwester Nawrocki wrote:
>> Well, if that's the case, then we already have an API for that
>> (http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-window, field
>> global_alpha).
>>
>> It was my understanding that this is used with a mem2mem device where you
>> just want to fill in the alpha channel to the desired value. It's not used
>> inside the device at all (that happens later in the pipeline).
> 
> OK, now I understand. Maybe the documentation should describe this a bit more 
> explicitly ?

I've modified the control description so now it is:

V4L2_CID_ALPHA_COMPONENT	
integer	

Sets the alpha color component on the capture device or on the capture buffer
queue of a mem-to-mem device. It is applicable to any pixel formats that
contain the alpha component, e.g. _packed RGB image_ formats.


And the part below Table 2.6

Bit 7 is the most significant bit. The value of a = alpha bits is undefined
when reading from the driver, ignored when writing to the driver, except when
alpha blending has been negotiated for a Video Overlay or Video Output Overlay
or when alpha component has been configured for a Video Capture by means of
V4L2_CID_ALPHA_COMPONENT control.


--
Regards,
Sylwester

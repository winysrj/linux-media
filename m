Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:46257 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1CAII1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 03:08:27 -0500
Message-ID: <4D6CA9E0.5020508@maxwell.research.nokia.com>
Date: Tue, 01 Mar 2011 10:10:08 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: V4L2 'brainstorming' meeting in Warsaw, March 2011
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36190F532AF3@bssrvexch01> <201102281903.39708.hverkuil@xs4all.nl> <201102281912.01542.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102281912.01542.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> On Monday 28 February 2011 19:03:39 Hans Verkuil wrote:
>> On Monday, February 28, 2011 18:11:47 Marek Szyprowski wrote:
> 
> [snip]
> 
>>> 4. Agenda
>>>
>>>         TBD, everyone is welcomed to put his items here :)
>>
>> In no particular order:
>>
>> 1) pipeline configuration, cropping and scaling:
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html
>>
>> 2) HDMI API support
>>
>> Some hotplug/CEC code can be found here:
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
>>
>> but Cisco will soon post RFCs on this topic as well.
>>
>> 3) Snapshot functionality.
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html
>>
>> If we finish quicker than expected, then we can also look at this:
>>
>> - use of V4L2 as a frontend for SW/DSP codecs
> 
> In still no particular order:
> 
>  - Muxed formats (H.264 inside MJPEG)
>  - H.264
>  - Buffers pool
>  - Entity information ioctl
>  - Userspace drivers (OMX)
>  - Sensor blanking/pixel-clock/frame-rate settings (including 
> enumeration/discovery)
>  - GL/ES in V4L2 devices

Unordered, again:

- Multiple video buffer queues per device (currently implemented in the
OMAP 3 ISP driver in non-standard way).

- Synchronising parameters (e.g. exposure time and gain) on given
frames. Some sensors support this on hardware. There are many use cases
which benefit from this, for example this one:

<URL:http://fcam.garage.maemo.org/>

- Flash synchronisation (might fall under the above topic).

- Frame metadata. It is important for the control algorithms (exposure,
white balance, for example), to know which sensor settings have been
used to expose a given frame. Many sensors do support this. Do we want
to parse this in the kernel or does it belong to user space? The
metadata formats are mostly sensor dependent.


The dates are okay for me but I'm not yet certain of my participation
for other reasons.


Best regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

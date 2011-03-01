Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:53274 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab1CAJUH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 04:20:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PuLkU-0002RC-02
	for linux-media@vger.kernel.org; Tue, 01 Mar 2011 10:20:06 +0100
Received: from 217067201162.u.itsa.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2011 10:20:05 +0100
Received: from t.stanislaws by 217067201162.u.itsa.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2011 10:20:05 +0100
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: V4L2 'brainstorming' meeting in Warsaw, March 2011
Date: Tue, 01 Mar 2011 09:46:52 +0100
Message-ID: <ikibpu$2cb$1@dough.gmane.org>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36190F532AF3@bssrvexch01> <201102281903.39708.hverkuil@xs4all.nl> <201102281912.01542.laurent.pinchart@ideasonboard.com> <4D6CA9E0.5020508@maxwell.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4D6CA9E0.5020508@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari Ailus wrote:
> Laurent Pinchart wrote:
>> On Monday 28 February 2011 19:03:39 Hans Verkuil wrote:
>>> On Monday, February 28, 2011 18:11:47 Marek Szyprowski wrote:
>> [snip]
>>
>>>> 4. Agenda
>>>>
>>>>         TBD, everyone is welcomed to put his items here :)
>>> In no particular order:
>>>
>>> 1) pipeline configuration, cropping and scaling:
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html
>>>
>>> 2) HDMI API support
>>>
>>> Some hotplug/CEC code can be found here:
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html
>>>
>>> but Cisco will soon post RFCs on this topic as well.
>>>
>>> 3) Snapshot functionality.
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html
>>>
>>> If we finish quicker than expected, then we can also look at this:
>>>
>>> - use of V4L2 as a frontend for SW/DSP codecs
>> In still no particular order:
>>
>>  - Muxed formats (H.264 inside MJPEG)
>>  - H.264
>>  - Buffers pool
>>  - Entity information ioctl
>>  - Userspace drivers (OMX)
>>  - Sensor blanking/pixel-clock/frame-rate settings (including 
>> enumeration/discovery)
>>  - GL/ES in V4L2 devices
> 
> Unordered, again:
> 
> - Multiple video buffer queues per device (currently implemented in the
> OMAP 3 ISP driver in non-standard way).
> 
> - Synchronising parameters (e.g. exposure time and gain) on given
> frames. Some sensors support this on hardware. There are many use cases
> which benefit from this, for example this one:
> 
> <URL:http://fcam.garage.maemo.org/>
> 
> - Flash synchronisation (might fall under the above topic).
> 
> - Frame metadata. It is important for the control algorithms (exposure,
> white balance, for example), to know which sensor settings have been
> used to expose a given frame. Many sensors do support this. Do we want
> to parse this in the kernel or does it belong to user space? The
> metadata formats are mostly sensor dependent.
> 
> 
> The dates are okay for me but I'm not yet certain of my participation
> for other reasons.
> 
> 
> Best regards,
> 

I propose few topic:

1. Acquiring subdevs from other devices using subdev pool
http://www.mail-archive.com/linux-media@vger.kernel.org/msg21831.html

2. Buffer cropping.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html

3. Introducing subdev hierarchy. Below there is a link to driver using it:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28885/focus=28890

Best regards
Tomasz Stanislawski


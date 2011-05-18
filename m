Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30707 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1ERQen (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 12:34:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLE00BN7GPTR870@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 17:34:41 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLE00KLOGPS8G@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 17:34:40 +0100 (BST)
Date: Wed, 18 May 2011 18:34:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: Codec controls question
In-reply-to: <201105181803.18893.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4DD3F520.4080609@samsung.com>
References: <003801cc14ae$be448b90$3acda2b0$%debski@samsung.com>
 <16ed9ac8f44869af2d6ff7cded1c0023.squirrel@webmail.xs4all.nl>
 <4DD3EC71.5040100@samsung.com>
 <201105181803.18893.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 05/18/2011 06:03 PM, Laurent Pinchart wrote:
> On Wednesday 18 May 2011 17:57:37 Sylwester Nawrocki wrote:
>> On 05/18/2011 05:22 PM, Hans Verkuil wrote:
>>>
>>> I have experimented with control events to change ranges and while it can
>>> be done technically it is in practice a bit of a mess. I think personally
>>> it is just easier to have separate controls.
>>>
>>> We are going to have similar problems if different video inputs are
>>> controlled by different i2c devices with different (but partially
>>> overlapping) controls. So switching an input also changes the controls. I
>>> have experimented with this while working on control events and it became
>>> very messy indeed. I won't do this for the first version of control
>>> events.
>>>
>>> One subtle but real problem with changing control ranges on the fly is
>>> that it makes it next to impossible to save all control values to a file
>>> and restore them later. That is a desirable feature that AFAIK is
>>> actually in use already.
>>
>> What are your views on creating controls in subdev s_power operation ?
>> Some sensors/ISPs have control ranges dependant on a firmware revision.
>> So before creating the controls min/max/step values need to be read from
>> them over I2C. We chose to postpone enabling ISP's power until a
>> corresponding video (or subdev) device node is opened. And thus controls
>> are not created during driver probing, because there is no enough
>> information to do this.
> 
> You can power the device up during probe, read the hardware/firmware version, 
> power it down and create/initialize controls depending on the retrieved 
> information.

Yes, I suppose this is what all drivers should normally do. But if for example
there are 2 sensor's registered during a media device initialization and it takes
about 100ms and 600 ms to initialize each one respectively, then if the driver
is compiled in the kernel the system boot time would increase by 700ms.   
If the whole driver is compiled as a LKM this could be acceptable though.

I'm still not convinced, the most straightforward method would be to power up
the sensor in probe(), but there comes that unfortunate delay. 

> 
>> I don't see a possibility for the applications to be able to access the
>> controls before they are created as this happens during a first device
>> (either video or subdev) open(). And they are destroyed only in
>> video/subdev device relase().
>>
>> Do you see any potential issues with this scheme ?
> 

Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center

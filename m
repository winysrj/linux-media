Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53840 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZIVSZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 14:25:12 -0400
Message-ID: <4AB7B66E.6080308@maxwell.research.nokia.com>
Date: Mon, 21 Sep 2009 20:22:54 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Subject: Re: RFCv2: Media controller proposal
References: <200909100913.09065.hverkuil@xs4all.nl>	<200909112123.44778.hverkuil@xs4all.nl>	<20090911165937.776a638d@caramujo.chehab.org>	<200909112215.15155.hverkuil@xs4all.nl> <20090911183758.31184072@caramujo.chehab.org>
In-Reply-To: <20090911183758.31184072@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Fri, 11 Sep 2009 22:15:15 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On Friday 11 September 2009 21:59:37 Mauro Carvalho Chehab wrote:
>>> Em Fri, 11 Sep 2009 21:23:44 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>> The second problem is that this will pollute the 'namespace' of a v4l device
>>>> node. Device drivers need to pass all those private ioctls to the right
>>>> sub-device. But they shouldn't have to care about that. If someone wants to
>>>> tweak the resizer (e.g. scaling coefficients), then pass it straight to the
>>>> resizer component.
>>> Sorry, I missed your point here
>> Example: a sub-device can produce certain statistics. You want to have an
>> ioctl to obtain those statistics. If you call that through /dev/videoX, then
>> that main driver has to handle that ioctl in vidioc_default and pass it on
>> to the right subdev. So you have to write that vidioc_default handler,
>> know about the sub-devices that you have and which sub-device is linked to
>> the device node. You really don't want to have to do that. Especially not
>> when you are dealing with i2c devices that are loaded from platform code.
>> If a video encoder supports private ioctls, then an omap3 driver doesn't
>> want to know about that. Oh, and before you ask: just broadcasting that
>> ioctl is not a solution if you have multiple identical video encoders.
> 
> This can be as easy as reading from /sys/class/media/dsp:stat0/stats

In general, the H3A block producing the statistics is configured first,
after which it starts producing statistics. Statistics buffers are
usually smallish, the maximum size is half MiB or so. For such a buffer
you'd have to ask the data for a number of times since the sysfs show() 
limit is one page (4 kiB usually).

Statistics are also often available before the actual frame since the
whole frame is not used to compute them. The statistics are used by e.g.
the AEWB algorithm which then comes up with the new exposure and gain
values. Applying them to the sensor in time is important since the
sensor may start exposing a new frame already before the last one has ended.

This requires event delivery to userspace (Laurent has written about it
under subject "[RFC] Video events").

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com




Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62040 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbZCDTWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 14:22:30 -0500
Message-ID: <49AED4DC.5050507@nokia.com>
Date: Wed, 04 Mar 2009 21:22:04 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
Reply-To: sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
References: <5e9665e10903021848u328e0cd4m5186344be15b817@mail.gmail.com> <200903030836.55692.hverkuil@xs4all.nl> <5e9665e10903031642h2aa38c22o73a8db6714846031@mail.gmail.com> <200903040839.48104.hverkuil@xs4all.nl>
In-Reply-To: <200903040839.48104.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Wednesday 04 March 2009 01:42:13 DongSoo(Nathaniel) Kim wrote:
>> Thank you for your kind explanation Hans.
>>
>> Problem is omap3 camera subsystem is making device node for every int
>> device attached to it.
> 
> That's wrong. Multiple devices should only be created if they can all be 
> used at the same time. Otherwise there should be just one device that uses 
> S_INPUT et al to select between the inputs.

There might be situations where multiple device nodes would be 
beneficial even if they cannot be used simultaneously in all cases.

Currently the omap34xxcam camera driver creates one device per camera. A 
camera in this case contains an isp (or camera controller), image 
sensor, lens and flash. The properties like maximum frame rate or 
resolution of a camera are usually (almost) completely defined by those 
of the sensor, lens and flash. This affects also cropping capabilities.

Several programs can access video devices simultaneously. What happens 
if another program switches the input when the first one doesn't expect 
it? The original user won't notice the change, instead of getting -EBUSY 
when trying to open the other video device.

In short, it's been just more clear to have one device per camera. There 
may be other reasons but these come to mind this time.

> BTW, do I understand correctly that e.g. lens drivers also get their 
> own /dev/videoX node? Please tell me I'm mistaken! Since that would be so 
> very wrong.

Yes, you're mistaken this time. :)

The contents of a video devices are defined in platform data.

> I hope that the conversion to v4l2_subdev will take place soon. You are 
> basically stuck in a technological dead-end :-(

Making things working properly in camera and ISP drivers has taken much 
more time than was anticipated and v4l2_subdev framework has developed a 
lot during that time. You're right --- we'll start thinking of how and 
when to move to v4l2_subdev.

Thanks.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

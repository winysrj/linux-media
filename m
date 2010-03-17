Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0CQVJO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 17:09:14 -0400
Message-ID: <4BA144F3.7000706@redhat.com>
Date: Wed, 17 Mar 2010 18:09:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: introduce a Kconfig variable to disable helper-chip
 autoselection
References: <Pine.LNX.4.64.1003171336180.4354@axis700.grange> <Pine.LNX.4.64.1003171446360.4354@axis700.grange> <4BA12D47.8090808@redhat.com> <201003172054.53553.hverkuil@xs4all.nl>
In-Reply-To: <201003172054.53553.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Hans Verkuil wrote:
> On Wednesday 17 March 2010 20:28:07 Mauro Carvalho Chehab wrote:
>> Guennadi Liakhovetski wrote:
>>
>>> Hi Mauro
>>>
>>> we just discussed this with Hans on IRC, and if I understood him 
>>> correctly, he was of the same opinion, that adding such a variable could 
>>> help.
>>>
>>> The problem is the following: this automatic selection works in a way, 
>>> that various bridge drivers select "helper" chip drivers (i2c subdevice 
>>> drivers" if this autoselection is enabled, e.g.
>>>
>>> config VIDEO_MXB
>>> 	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
>>> 	depends on PCI && VIDEO_V4L1 && I2C
>>> 	select VIDEO_SAA7146_VV
>>> 	select VIDEO_TUNER
>>> 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
>>> 	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
>>> 	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
>>> 	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
>>>
>>> With SoC-based set ups this cannot work. The only location where this 
>>> information is available is platform code under arch/... and selecting 
>>> these drivers from there would be awkward imho.
>> Kconfig works fine if the var is on another place. So, you could do things
>> like:
>>
>> config VIDEO_xxx
>> 	select VIDEO_foo if VIDEO_HELPER_CHIPS_AUTO && ARCH_bar
>>
>> You may even convert it into dependencies like:
>>
>> config VIDEO_I2C_foo
>> 	depends on ARCH_bar && config VIDEO_xxx
>> 	default y if VIDEO_HELPER_CHIPS_AUTO
> 
> I2C drivers are NOT dependent on architectures. They can be used anywhere.
> 
>> The depends on syntax generally works better than using select. We've converted
>> some select into depends on a few places like tuner, like, for example:
>>
>> config MEDIA_TUNER_TDA827X
>>         tristate "Philips TDA827X silicon tuner"
>>         depends on VIDEO_MEDIA && I2C
>>         default m if MEDIA_TUNER_CUSTOMISE
>>
>>> So, for example, we want 
>>> to put the ak881x video encoder driver under
>>>
>>> comment "Video encoders"
>>>
>>> and those drivers are only visible if VIDEO_HELPER_CHIPS_AUTO is 
>>> unselected, and if it is selected, which it is by default, there is noone 
>>> to automatically select ak881x. So, I think, the proposed patch is not a 
>>> work-around, but a reasonable solution for this issue.
>> Even the menu being invisible, any of the above logic would work, if you do
>> something like:
>>
>> config VIDEO_AK881X
>> 	depends on ARCH_MX1 && I2C
>> 	default y if VIDEO_HELPER_CHIPS_AUTO && SOC_CAMERA
>>
>> or:
>>
>> config SOC_CAMERA
>> 	select VIDEO_AK881X if VIDEO_HELPER_CHIPS_AUTO && ARCH_MX1
> 
> Same problem here: the architecture does not determine whether this i2c driver
> is needed. That is determined by the board definition. I guess the right place
> to do this is probably in a 'mach' specific Kconfig like for example
> arch/arm/mach-davinci/Kconfig.
> 
> But to be honest, I think that the SoC + VIDEO_HELPER_CHIPS_AUTO combination
> is pretty pointless.
> 
> Regards,
> 
> 	Hans
> 

I've discussed this issue with Guennadi on IRC today. The better seems to just
disable or change the default to 'n' for the AUTO/CUSTOMISE options, when 
CONFIG_EMBEDDED. He's working on a new patch.

-- 

Cheers,
Mauro

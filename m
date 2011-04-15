Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:22960 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1DOFZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2011 01:25:16 -0400
Message-ID: <4DA7D727.2010708@maxwell.research.nokia.com>
Date: Fri, 15 Apr 2011 08:27:03 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sung Hee Park <shpark7@stanford.edu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	andrew.b.adams@gmail.com
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <BANLkTik+xqCD7uiGUchsehoUy+gwM+Cjdg@mail.gmail.com> <4DA59426.80803@maxwell.research.nokia.com> <201104142138.45541.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104142138.45541.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Heippa,

> On Wednesday 13 April 2011 14:16:38 Sakari Ailus wrote:
>> Sung Hee Park wrote:
>>> Here are two more use-cases for flash that might help inform the API
>>> design. Sakari encouraged me to post these. The person writing this is
>>> Andrew Adams, but I'm sending this from Sung Hee's account, because I
>>> only just subscribed to linux-media and can't immediately figure out how
>>> to reply to messages from before I subscribed. Sung Hee and I are both
>>> grad students at Stanford who work on FCam
>>> (http://fcam.garage.maemo.org/)
>>
>> Hi Andrew,
>>
>> Many thanks for the comments.
>>
>>> Second-curtain-sync:
>>>
>>> Sometimes you want to fire the flash at the end of a long exposure time.
>>> It's usually a way to depict motion. Here's an example:
>>> http://www.flickr.com/photos/latitudes/133206615/.
>>>
>>> This only really applies to xenon flashes because you can't get a crisp
>>> image out of a longer duration LED flash. Even then it's somewhat
>>> problematic on rolling-shutter sensors but still possible provided you
>>> don't mind a slight shear to the crisp part of the image. From an API
>>> perspective, it requires you to be able to specify a trigger time at
>>> some number of microseconds into the exposure. On the N900 we did this
>>> with a real-time thread.
>>>
>>> Triggering external hardware:
>>>
>>> This use-case is a little weirder, but it has the same API requirement.
>>> Some photographic setups require you to synchronize some piece of
>>> hardware with the exposure (e.g. an oscilloscope, or an external slave
>>> flash). On embedded devices this is generally difficult. If you can at
>>> least fire the flash at a precise delay into the exposure, you can
>>> attach a photodiode to it, and use the flash+photodiode as an
>>> opto-isolator to trigger your external hardware.
>>>
>>> So we're in favor of having user-settable flash duration, and also
>>> user-settable trigger times (with reference to the start of the exposure
>>> time). I'm guessing that in a SMIA++ driver the trigger time would
>>> actually be a control on the sensor device, but it seemed relevant to
>>> bring up while you guys were talking about the flash API.
>>
>> From this I reckon that in a general case the handling of the flash
>> timing cannot be left for the drivers only. There must be a way to
>> control it.
>>
>> So I'd think that also the level/edge trigger for the flash should be
>> visible. On edge trigger, the only limiting factor for the flash
>> duration on hardware would be the relatively coarse watchdog timer, and
>> I'd think the user should be able to know that.
> 
> I agree that the user should be able to query the limit. The limit value 
> should come from platform data.

Agreed.

>> The flash timing controls should be exposed by the sensor driver since
>> the sensor is what actually performs the timing.
>>
>> Laurent; what do you think?
> 
> As already discussed with you offline, I think we will need flash timing 
> controls on the sensor when the flash controller is configured with external 
> strobe in level triggered mode. I'm still not sure if the edge/level-triggered 
> names are the best option. They confused me in the beginning, so I find them 
> confusing :-) If we keep them, they will need to be very precisely documented.

I'm fine with other naming --- edge/level is from the AS3645
documentation. ADP1653 does not call it with a name as far as I
remember. Other similar chips can be found here:

<URL:http://www.austriamicrosystems.com/eng/Products/Lighting-Management/>

I tried to download the datasheets but couldn't. The AS3645 datasheet,
however, is also available here:

<URL:http://www.cdiweb.com/datasheets/austriamicro/AS3645_Datasheet_v1-6.pdf>

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

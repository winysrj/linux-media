Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48497 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbEYPUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:20:07 -0400
Message-id: <55633DA3.9090409@samsung.com>
Date: Mon, 25 May 2015 17:20:03 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v8 8/8] DT: samsung-fimc: Add examples for
 samsung,flash-led property
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
 <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
 <555DA119.9030904@samsung.com>
 <20150521113213.GI8601@valkosipuli.retiisi.org.uk>
 <555DDD88.8080601@samsung.com>
 <20150523120348.GA3170@valkosipuli.retiisi.org.uk>
 <55630EE1.90307@samsung.com> <55631AAC.6080507@samsung.com>
 <55633186.1000004@samsung.com>
In-reply-to: <55633186.1000004@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2015 04:28 PM, Sylwester Nawrocki wrote:
> On 25/05/15 14:50, Jacek Anaszewski wrote:
>>> On 23/05/15 14:03, Sakari Ailus wrote:
>>>>>> On Thu, May 21, 2015 at 03:28:40PM +0200, Sylwester Nawrocki wrote:
>>>>>>>> flash-leds = <&flash_xx &image_sensor_x>, <...>;
>>>>>>
>>>>>> One more matter to consider: xenon flash devices.
>>>>>>
>>>>>> How about samsung,camera-flashes (and ti,camera-flashes)? After pondering
>>>>>> this awhile, I'm ok with removing the vendor prefix as well.
>>>>>>
>>>>>> Let me know what you think.
>>>>
>>>> I thought about it a bit more and I have some doubts about semantics
>>>> as above. I'm fine with 'camera-flashes' as far as name is concerned.
>>>>
>>>> Perhaps we should put only phandles to leds or xenon flash devices
>>>> in the 'camera-flashes' property. I think it would be more future
>>>> proof in case there is more nodes needed to describe the camera flash
>>>> (or a camera module) than the above two. And phandles to corresponding
>>>> image sensor device nodes would be put in a separate property.
>>
>> Could you give examples of the cases you are thinking of?
>
> I don't have any examples in mind ATM, I just wanted to point out
> the above convention might not be flexible enough. Especially since
> we already know there is more sub-devices within the camera module
> than just flashes and image sensors.
>
>>>> camera-flashes = <&flash_xx>, ...
>>>> camera-flash-masters = <&image_sensor_x>, ...
>>>>
>>>> Then pairs at same index would describe a single flash, 0 would indicate
>>>> a null entry if needed.
>>
>> When it should be needed?
>
> Not sure if there is a real use case for null entries, it was just to
> note we can skip any entry if needed - probably an irrelevant comment.
> I could imagine 2 LEDs of which one is only triggered in software, so
> it wouldn't have a 'camera-flash-masters' entry.
>
>>>> Similarly we could create properties for other sub-devices of a camera
>>>> module, like lenses, etc.

I have had the ninth version of the patch set ready to send today,
so in view of your doubts I made the property samsung specific
so as not to prevent us from going further while we will be
discussing the implementation of the generic property.
The 9th version of the patch set has been just sent.

-- 
Best Regards,
Jacek Anaszewski

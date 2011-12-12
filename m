Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53623 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1LLVIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 16:08:17 -0500
Date: Mon, 12 Dec 2011 23:08:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Subject: Re: [Query] V4L2 Integer (?) menu control
Message-ID: <20111212210813.GL1967@valkosipuli.localdomain>
References: <4ECD730E.3080808@gmail.com>
 <20111124085018.GF27136@valkosipuli.localdomain>
 <4ECE0FA5.1040205@samsung.com>
 <4ECEAFBE.1010303@iki.fi>
 <4ECED8EC.8010807@gmail.com>
 <20111126093618.GF29342@valkosipuli.localdomain>
 <4ED13D92.6090305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4ED13D92.6090305@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> Hi Sakari,
>
> On 11/26/2011 10:36 AM, Sakari Ailus wrote:
>> On Fri, Nov 25, 2011 at 12:53:16AM +0100, Sylwester Nawrocki wrote:
>>> On 11/24/2011 09:57 PM, Sakari Ailus wrote:
>>>> Sylwester Nawrocki wrote:
>>>>> On 11/24/2011 09:50 AM, Sakari Ailus wrote:
>>>>>>
>>>>>> There is not currently, but I have patches for it. The issue is that I need
>>>>>> them myself but the driver I need them for isn't ready to be released yet.
>>>>>> And as usual, I assume others than vivo is required to show they're really
>>>>>> useful so I haven't sent them.
>>>>>
>>>>> That's great news. Then I might not need to do all the work on my own;)
>>>>
>>>> I hope mine will do. ;-)
>>>>
>>>> I'm working on 2.6.32 kernel (ouch!) so I haven't been able to test them properly
>>>> yet. Please provide feedback on them if you find any issues.
>
> Sure, I just need to reserve some time to try these things out.
>
>>>>
>>>>>>
>>>>>> Good that you asked so we won't end up writing essentially the same code
>>>>>> again. I'll try to send the patches today.
>>>>>
>>>>> All right, there is no rush. I was just looking around how to support the
>>>>> camera scene mode with m5mols sort of sensors. The scene mode is essentially
>>>>> a compilation of several different parameters, for some of which there are
>>>>> standard controls in V4L2 but for many there are not.
>>>>
>>>> I fully agree with this approach. Scene modes should not be implemented at the
>>>> level of the V4L2 API. Instead, the parameters that the scene modes consist of
>>>> must be shown separately on the V4L2 API, if that is the level of API they belong
>>>> to. Depending on your camera stack control algorithms could reside in the user
>>>> space, which I believe is however not the case with the M5-MOLS.
>>>
>>> No, with these hybrid camera devices the algorithms are built in their own ISP.
>>> And there is quite many advanced algorithms, e.g. auto focus/face detection that
>>> are difficult to control at the subdevice API level.
>>
>> Can you tell what makes it difficult?
>
> I think the problem boils down to the following issues:
>
>   1) lack of controls for several parameters at the camera control class, e.g.
>     - V4L2_CID_METERING_MODE (menu),
>     - V4L2_CID_AUTO_EXPOSURE_BIAS (integer),
>     - V4L2_CID_ISO (integer menu),
>     - various auto focus modes,
>     - capture mode: single, multi, auto bracketing, anti hand-shake, etc.

These are indeed quite high level controls. You need some of this when 
your camera control algorithms run on the camera module itself.

I think it's just a matter of adding them to the control class, or to 
export them as private controls. Some autofocus modes might require a 
private control, for example, if they need additional information from 
the user.

>   2) separate H/W contexts (image format, some controls) for viewfinder, snapshot,
>      preview; introducing the SNAPSHOT control could partially resolve this;

This could be more tricky. Guennadi did measurements on how much time 
could be saved by doing this, and the answer was in his case some 30 
milliseconds. The sensor he was using used archaic 20 kHz bus speed 
instead of the 400 kHz one standardised in the beginning of 90s.

How about M5-MOLS?

>   3) proper support for encoded data on the media bus
>
>   4) some sensors with embedded ISPs provide features which might be considered
>      "high level", like for example scene mode (white balance) presets, exposure
>      bracketing, drawing some additional markers in viewfinder video stream,
>      e.g. a face detection rectangle, etc.

Much of the time this kind of features bind together many parameters and 
it may be best to provide a private interface to these. That's also how 
it often is in the higher layers --- if your functionality is something 
that no-one else has chances are low that you can provide a fully 
standardised interface for it.

> That's just what comes to my mind right now. 1), 2), 3) shouldn't be difficult
> to solve, only 4) seems to be a real issue.
>
> I was planning to prepare an RFC on controls listed in 1). Some of them would need
> your recent integer menu control patches.
>
>>
>>> The issue is that the subdev API seems to low level for the device but it's
>>> the only API available at the user space ;)
>>
>> ...
>>
>>>> This makes your user space to depend both on the sensor and the ISP, but there's
>>>> really no way around that if both do non-trivial hardware-specific things.
>>>
>>> I guess a dedicated library for the sensor itself is needed on top of subdevice API
>>> to be able to use advanced features. And even then subdevice/V4L2 API is a limitation.
>>
>> How is it a limitation?
>>
>> Whe whole intent is to provide as standard as possible way to access the
>> hardware features through an interface provided by the driver. So what is
>> missing in your opinion? :-)
>
> What I tried to say was that there might different logic implemented at each hybrid
> sensor/ISP device. Some device specific sequences might be needed, which might not
> be possible to abstract in a v4l2 subdevice driver itself. With regards to what is
> missing please see above.

Indeed. The V4L2 subdev API provides access to subdevices themselves, 
not the whole media device.

>>>> I think we need to further standardise image processing configuration such as
>>>> RGB-to-RGB matrices and gamma tables. This would make the ISP interfaces less
>>>> hardware specific.
>>>
>>> I guess first we need at least one more OMAP3 ISP like device driver in mainline
>>> to identify common features and design APIs for them. On the other hand gamma tables
>>> are also present in some embedded ISPs, e.g. in s5k6aafx IIRC.
>>
>> Or get more public specs for different ISPs. Or just read the existing specs
>> more. ;-) The OMAP 4 ISS spec is public. Even if it's from TI as well it's
>> very different from the OMAP 3 ISP.
>
> Right, a very valid point:) I just had a look at the OMAP4 ISS, thanks for the hint!
> I'll try to obtain more detailed documentation on similar Samsung devices,
> unfortunately as you know it still isn't public.

That definitely would be very interesting and useful, and also good for 
V4L2 support for Samsung ISPs...

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

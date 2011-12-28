Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42567 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1L1QHB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 11:07:01 -0500
Received: by eekc4 with SMTP id c4so12393919eek.19
        for <linux-media@vger.kernel.org>; Wed, 28 Dec 2011 08:06:59 -0800 (PST)
Message-ID: <4EFB3E9F.1070408@gmail.com>
Date: Wed, 28 Dec 2011 17:06:55 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com> <20111205224155.GB938@valkosipuli.localdomain> <4EE364C7.1090805@gmail.com> <20111214215145.GA3677@valkosipuli.localdomain>
In-Reply-To: <20111214215145.GA3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/14/2011 10:51 PM, Sakari Ailus wrote:
> On Sat, Dec 10, 2011 at 02:55:19PM +0100, Sylwester Nawrocki wrote:
>> On 12/05/2011 11:41 PM, Sakari Ailus wrote:
>>> On Mon, Dec 05, 2011 at 08:56:46PM +0100, Sylwester Nawrocki wrote:
>>>> The V4L2_CID_FLASH_HW_STROBE_MODE mode control is intended
>>>> for devices that are source of an external flash strobe for flash
>>>> devices. This part seems to be missing in current Flash control
>>>> class, i.e. a means for configuring devices that are not camera
>>>> flash drivers but involve a flash related functionality.
>>>>
>>>> The V4L2_CID_FLASH_HW_STROBE_MODE control enables the user
>>>> to determine the flash control behavior, for instance, at an image
>>>> sensor device.
>>>>
>>>> The control has effect only when V4L2_CID_FLASH_STROBE_SOURCE control
>>>> is set to V4L2_FLASH_STROBE_SOURCE_EXTERNAL at a flash subdev, if
>>>> a flash subdev is present in the system.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
>>>> ---
>>>>
>>>> Hi Sakari,
>>>>
>>>> My apologies for not bringing this earlier when you were designing
>>>> the Flash control API.
>>>> It seems like a use case were a sensor controller drives a strobe
>>>> signal for a Flash and the sensor side requires some set up doesn't
>>>> quite fit in the Flash Control API.
>>>>
>>>> Or is there already a control allowing to set Flash strobe mode at
>>>> the sensor to: OFF, ON (per each exposed frame), AUTO ?
>>
>> Thank you for the in-depth opinion (and sorry for the delayed response).
> 
> You're welcome! Thanks for bringing up the topic! :-)
> 
>>> The flash API defines the API for the flash, not for the sensor which might
>>> be controlling the flash through the hardware strobe pin. I left that out
>>> deliberately before I could see what kind of controls would be needed for
>>> that.
>>>
>>> If I understand you correctly, this control is intended to configure the
>>> flash strobe per-frame? That may be somewhat hardware-dependent.
>>
>> Yes, per captured frame. Actually the controls I proposed were meant to select
>> specific flash strobe algorithm. What refinements could be relevant for those
>> algorithms may be a different question. Something like the proposed controls
>> is really almost all that is offered by many of hardware we use.
> 
> 
> 
>>> Some hardware is able to strobe the flash for the "next possible frame" or
>>> for the first frame when the streaming is started. In either of the cases,
>>> the frames before and after the one exposed with the flash typically are
>>> ruined because the flash has exposed only a part of them. You typically want
>>> to discard such frames.
>>
>> Is this the case for Xenon flash as well, or LED only ?
> 
> Both xenon and LED.
> 
>> I think the fact that we're using video capture like interface for still 
>> capture adds complexity in such cases.
> 
> It also adds flexibility. You can expose one frame with xenon flash w/o
> stopping streaming.

Yes, but only if you're able to control an image sensor and ISP at very low
level.

>>> flash: LED flash typically remains on for the whole duration of the frame
>>> exposure, whereas on xenon flash the full frame must be being exposed when
>>> the flash is being fired.
>>
>> Indeed, I should have separated the LED and Xenon case in the first place.
>>
>> Do you think we could start with separate menu controls for LED and Xenon
>> flash strobe, e.g.
>>
>> V4L2_FLASH_LED_STROBE_MODE,
>> V4L2_FLASH_XENON_STROBE_MODE
>>
>> and then think of what controls would be needed for each particular mode
>> under these menus ?
> 
> Do we need to separate them? I don't think they're very different, with the

Perhaps we don't need to separate them this much. But the differences are
significant IHMO. However it could be enough if we pass information about
the flash type in sensor's platform data. (I wrote this before I've seen
your smiapp driver patches;)).

> possible exception of intensity control. For xenon flashes the intensity is
> at least sometimes controlled by the strobe pulse length.
> 
> Still, flash strobe start timing and length control are the same.

But strobe control signal characteristics may be different for Xenon lamp,
due to pre-flash strobes for example ? Does pre-flash really apply to
LED flashes as well ?

>>> Also different use cases may require different flash timing handling. [1]
>>
>> I think we need to be able to specify flash strobe delay relative to exposure
>> start in absolute time and relative to exposure time units.
> 
> I agree. I actually just sent a few patches which could be relevant to this,
> you're cc'd (patches 1 and 2):
> 
> <URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg39798.html>
> 
> What units your sensor uses naturally?

The one which allows to specify flash strobe delay and its length just accepts
absolute time with resolution determined by sensor master clock period.

But in many cases with a high brightness LED as flash the delay is handled by
sensor firmware with only relatively high level interface exposed to the user.

>>> Some sensors have a synchronised electrical shutter (or what was it called,
>>> something like that anyway); that causes the exposure of all the lines of
>>
>> I guess you mean two-curtain type shutter, like the one described here:
>>
>> http://camerapedia.wikia.com/wiki/Focal_plane_shutter
>> http://www.photozone.de/hi-speed-flash-sync
> 
> No, but I wasn't actually aware of that. :)
> 
> This is what I meant:
> 
> <URL:http://forums.dpreview.com/forums/read.asp?forum=1037&message=37167063>

Hmm, the characteristic of this kind of shutter might be similar to mechanical
shutter. So there would be at least 2 types of shutter from flash POV:
 - electronics rolling shutter,
 - mechanical (electronic synchronized) shutter.

Then maybe we could develop a control indicating shutter type:

V4L2_CID_FLASH_SHUTTER_TYPE
  V4L2_FLASH_ELECTRONIC_ROLLING_SHUTTER
  V4L2_FLASH_MECHANICAL_SHUTTER

But I don't know what to do with this information exactly at this moment.. :-)

>>> the sensor to stop at the same time. This effectively eliminates the rolling
>>> shutter effect. The user should know whether (s)he is using synchronised
>>> shutter or rolling shutter since that affects the timing a lot.
>>>
>>> How the control of the hardware strobe should look like to the user?
>>>
>>> I don't think the flash handling can be fully expressed by a single control
>>> --- except for end user applications. They very likely don't want to know
>>> about all the flash timing related details.
>>
>> Agreed.
>>
>>>
>>> Are you able tell more about your use case? How about the sensor providing
>>> the hardware strobe signal?
>>
>> As a light source a high intensity white LED is used. The LED current control
>> circuit is directly controlled by a sensor, let's say for simplicity through
>> one pin.
> 
> Can there be use for more? That said, I like simple things. ;)

:-) Yes, physically. However logically it's safe to assume we have only one for
strobe. Some Flash LED drivers might have more pins for operation mode control
like capacitor precharge, etc. E.g. like this one:

URL: http://www.maxim-ic.com/datasheet/index.mvp/id/4163

Some may use additional pin for intensity control (PWM), whereas for some the
intensity is controlled through I2C (and we might not always have a Flash subdev
driver for them - for instance a led class driver).

URL : http://para.maxim-ic.com/en/results.mvp?fam=whiteled


-- 
Regards,
Sylwester

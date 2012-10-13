Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44528 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2JMSw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 14:52:29 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2399302eek.19
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2012 11:52:28 -0700 (PDT)
Message-ID: <5079B869.3040609@gmail.com>
Date: Sat, 13 Oct 2012 20:52:25 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com> <20111205224155.GB938@valkosipuli.localdomain> <4EE364C7.1090805@gmail.com>
In-Reply-To: <4EE364C7.1090805@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

My apologies for reviving so old thread ;)

It unfortunately didn't end with any conclusion but we need 
a functionality similar to the provided by the $subject patch 
for multiple different {camera sensor + ISP} devices.

On 12/10/2011 02:55 PM, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 12/05/2011 11:41 PM, Sakari Ailus wrote:
>> On Mon, Dec 05, 2011 at 08:56:46PM +0100, Sylwester Nawrocki wrote:
>>> The V4L2_CID_FLASH_HW_STROBE_MODE mode control is intended
>>> for devices that are source of an external flash strobe for flash
>>> devices. This part seems to be missing in current Flash control
>>> class, i.e. a means for configuring devices that are not camera
>>> flash drivers but involve a flash related functionality.
>>>
>>> The V4L2_CID_FLASH_HW_STROBE_MODE control enables the user
>>> to determine the flash control behavior, for instance, at an image
>>> sensor device.
>>>
>>> The control has effect only when V4L2_CID_FLASH_STROBE_SOURCE control
>>> is set to V4L2_FLASH_STROBE_SOURCE_EXTERNAL at a flash subdev, if
>>> a flash subdev is present in the system.
>>>
>>> Signed-off-by: Sylwester Nawrocki<snjw23@gmail.com>
>>> ---
>>>
>>> Hi Sakari,
>>>
>>> My apologies for not bringing this earlier when you were designing
>>> the Flash control API.
>>> It seems like a use case were a sensor controller drives a strobe
>>> signal for a Flash and the sensor side requires some set up doesn't
>>> quite fit in the Flash Control API.
>>>
>>> Or is there already a control allowing to set Flash strobe mode at
>>> the sensor to: OFF, ON (per each exposed frame), AUTO ?
> 
> Thank you for the in-depth opinion (and sorry for the delayed response).
> 
>> The flash API defines the API for the flash, not for the sensor which might
>> be controlling the flash through the hardware strobe pin. I left that out
>> deliberately before I could see what kind of controls would be needed for
>> that.
>>
>> If I understand you correctly, this control is intended to configure the
>> flash strobe per-frame? That may be somewhat hardware-dependent.
> 
> Yes, per captured frame. Actually the controls I proposed were meant to select
> specific flash strobe algorithm. What refinements could be relevant for those
> algorithms may be a different question. Something like the proposed controls
> is really almost all that is offered by many of hardware we use.
> 
>> Some hardware is able to strobe the flash for the "next possible frame" or
>> for the first frame when the streaming is started. In either of the cases,
>> the frames before and after the one exposed with the flash typically are
>> ruined because the flash has exposed only a part of them. You typically want
>> to discard such frames.
> 
> Is this the case for Xenon flash as well, or LED only ?
> 
> I think the fact that we're using video capture like interface for still capture
> adds complexity in such cases.
> 
>> The timing control of the flash strobe fully depends on the type of the
>> flash: LED flash typically remains on for the whole duration of the frame
>> exposure, whereas on xenon flash the full frame must be being exposed when
>> the flash is being fired.
> 
> Indeed, I should have separated the LED and Xenon case in the first place.
> 
> Do you think we could start with separate menu controls for LED and Xenon
> flash strobe, e.g.
> 
> V4L2_FLASH_LED_STROBE_MODE,
> V4L2_FLASH_XENON_STROBE_MODE
> 
> and then think of what controls would be needed for each particular mode
> under these menus ?
> 
>> Also different use cases may require different flash timing handling. [1]
> 
> I think we need to be able to specify flash strobe delay relative to exposure
> start in absolute time and relative to exposure time units.
> 
>>
>> Some sensors have a synchronised electrical shutter (or what was it called,
>> something like that anyway); that causes the exposure of all the lines of
> 
> I guess you mean two-curtain type shutter, like the one described here:
> 
> http://camerapedia.wikia.com/wiki/Focal_plane_shutter
> http://www.photozone.de/hi-speed-flash-sync
> 
>> the sensor to stop at the same time. This effectively eliminates the rolling
>> shutter effect. The user should know whether (s)he is using synchronised
>> shutter or rolling shutter since that affects the timing a lot.
>>
>> How the control of the hardware strobe should look like to the user?
>>
>> I don't think the flash handling can be fully expressed by a single control
>> --- except for end user applications. They very likely don't want to know
>> about all the flash timing related details.
> 
> Agreed.
> 
>>
>> Are you able tell more about your use case? How about the sensor providing
>> the hardware strobe signal?
> 
> As a light source a high intensity white LED is used. The LED current control
> circuit is directly controlled by a sensor, let's say for simplicity through
> one pin.
> Now all the magic happens in the sensor firmware and the user can only select
> flash programs, e.g. always on/off or auto. I've seen the front curtain and
> rear curtain modes used here and there. As you may know these are used in
> "slow sync" flash case, where the sensor is fired at the beginning or at the
> end of long exposure period.
> 
> For example S5K6AA sensor provides following options in REG_TC_FLS_Mode
> register for LED flash strobe:
> 
> 0: TC_FLASH_DISABLE,
> 1: TC_FLASH_CONT_ENABLE,  // Always on
> 2: TC_FLASH_PULSE_ENABLE, // Use burst pulse on every capture
> 3: TC_FLASH_PULSE_AUTO    // Sensor controls the Flash status (burst mode)
> 
> For option 3 there is also a register:
> 
> REG_TC_FLS_Threshold - Set flash activation threshold in normalized
>                         brightness units
> 
> For Xenon flash
> 
> REG_TC_FLS_XenonMode (Set Xenon flash mode):
> 
> 0: TC_XENON_DISABLE,
> 1: TC_XENON_ONE_STROBE, // Use one strobe
> 2: TC_XENON_PRE_FLASH   // Use n strobes for pre-flash and another one, full
> 
> REG_TC_FLS_XenonPreFlashCnt - Number of Xenon pre-flash strobes
> 
> 
> And this sensor has also register to trigger still (single- or multi-frame)
> capture (REG_TC_GP_EnableCapture), i.e. switch from low resolution/high frame
> rate operation to higher resolution image capture.
> 
> 
>> [1] http://www.spinics.net/lists/linux-media/msg31363.html

I'm wondering whether we should separate somehow, e.g. by using different
prefix, controls related to the flash controller and controls of camera
device controlling the flash in firmware ? Perhaps it's not necessary.
 
And should we develop distinct set of flash controls for camera devices,
i.e. not the flash controllers itself ? Or may we reuse the existing
flash controls [1] there ?

Having studied multiple Samsung sensor drivers in Android kernels, it 
seems all of them basically expose 4 flash modes:

1. The flash strobe is off (the flash is always off)
2. The flash strobe is on (the flash is fired with each snapshot,
   exact timing is determined in the camera firmware)
3. The flash strobe is controlled automatically by the sensor 
   (the flash may get fired or not, depending on light conditions, etc.)
4. The flash is on continuously (torch function)

There is even a dedicated common control in the private header for samsung
devices [1] - V4L2_CID_CAMERA_FLASH_MODE.

Having studied the existing flash controls [1] I'm wondering whether
a control like

V4L2_CID_FLASH_HW_STROBE_AUTO

with options:
	V4L2_FLASH_HW_STROBE_OFF
	V4L2_FLASH_HW_STROBE_AUTO
	V4L2_FLASH_HW_STROBE_ON


would make sense ? It would cover above cases 1, 3, 2.

Then I'm not sure what to do exactly with the Torch option.
 
Perhaps a boolean control like V4L2_FLASH_TORCH_ENABLED would do ?

Then V4L2_CID_FLASH_HW_STROBE_AUTO and V4L2_FLASH_TORCH_ENABLED could
possibly form a cluster where required.

What do you think ?

--
Thanks,
Sylwester

[1] http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#flash-controls
[2] https://android.googlesource.com/kernel/samsung/+/665612374970f5dba43b65510b52b72130818541/include/linux/videodev2_samsung.h

Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:24468 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1EHVyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 17:54:20 -0400
Message-ID: <4DC6BB43.3060804@maxwell.research.nokia.com>
Date: Sun, 08 May 2011 18:48:19 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v4] V4L2 API for flash devices
References: <4DC2F131.6090407@maxwell.research.nokia.com> <201105071446.56843.hverkuil@xs4all.nl>
In-Reply-To: <201105071446.56843.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hans Verkuil wrote:
[clip]
>> 	V4L2_CID_FLASH_STROBE (button; wo; LED, xenon)
>>
>> Strobe the flash using software strobe from the host, typically over I2C
>> or a GPIO. The flash is NOT synchronised to sensor pixel are exposure
>> since the command is given asynchronously. Alternatively, if the flash
>> controller is a master in the system, the sensor exposure may be
>> triggered based on software strobe.
> 
> I would like a comment here that the driver will always stop the strobe
> to prevent hardware damage, but that STROBE_STOP can be called to shut
> down the strobe earlier.
> 
> Also, how to protect against nastiness like this:
> 
> struct v4l2_control ctrl = { V4L2_CID_FLASH_STROBE, 0 };
> 
> for (;;)
> 	ioctl(fd, VIDIOC_S_CTRL, &ctrl);
> 
> Return -EBUSY as long as either a strobe is in progress or if it is unsafe to
> start a new one?

This is not implemented in the current adp1653 driver but yes, it should
be done. However, it isn't simple to implement in a way that it would
still allow the optimal use of the flash.

I'll add that to the todo list for the driver.

Modelling of the flash LED cooldown period should be relatively
independent of the board, actual LED and the flash chip, so this might
make a nice library in the future.

>>
>>
>> 	V4L2_CID_FLASH_STROBE_STOP (button; wo; LED)
>>
>> This control may be used to shut down the strobe immediately.
>>
>>
>> 	V4L2_CID_FLASH_STROBE_STATUS (boolean; ro; LED)
>>
>> This contol may be used to query the status of the strobe (on/off).
>>
>>
>> 	V4L2_CID_FLASH_STROBE_MODE (menu; rw; LED)
>>
>> Use hardware or software strobe. If hardware strobe is selected, the
>> flash controller is a slave in the system where the sensor produces the
>> strobe signal to the flash.
>>
>> In this case the flash controller setup is limited to programming strobe
>> timeout and power (LED flash) and the sensor controls the timing and
>> length of the strobe.
>>
>> enum v4l2_flash_strobe_whence {
>> 	V4L2_FLASH_STROBE_WHENCE_SOFTWARE,
>> 	V4L2_FLASH_STROBE_WHENCE_EXTERNAL,
>> };
> 
> Perhaps use 'type' instead of 'whence'? English isn't my native language,
> but it sounds pretty archaic to me.

Neither it is mine. I actually forgot to change the name of the enum to
v4l2_flash_strobe_mode so it would match the control.

What do you think of that?

>>
>>
>> 	V4L2_CID_FLASH_TIMEOUT (integer; rw; LED)
>>
>> The flash controller provides timeout functionality to shut down the led
>> in case the host fails to do that. For hardware strobe, this is the
>> maximum amount of time the flash should stay on, and the purpose of the
>> setting is to prevent the LED from catching fire.
> 
> It is a bit ambiguous. I assume you mean to say that the application can
> set the timeout to any value less than the maximum of the control (which
> is the maximum allowed by the hardware).

Yes; that's what I intended. I'll attempt to formulate it better in the
forthcoming patches. :-)

[clip]

>> Open questions
>> ==============
>>
>> 1. Flash LED mode control
>> -------------------------
>>
>> Should the flash led mode control be a single control or a set of
>> controls? A single control would make it easier for application to
>> choose between different modes, but on the other hand limits future
>> extensibility if there would have to be further splitting of the modes. [8]
> 
> I think I like the current proposal best.

I agree.

>> 3. Units
>> --------
>>
>> Which units should e.g. V4L2_CID_FLASH_TIMEOUT be using? It'd be very
>> useful to have standard unit on this control, like ms or µs.
> 
> This should be standardized. The question is how flexible we want this.
> I would definitely go for µs or perhaps even ns. But what should the
> maximum duration be? Are there extreme cases where you can have a really
> long flash in special types of photography? Perhaps this should be a 64-bit
> number?

On xenon flashes the strobe strength is controlled by strobe duration,
as far as I understand. I think it would be better to hide that under
the V4L2_CID_FLASH_INTENSITY, though.

The timeout on adp1653 the timeout is really coarse, there are 16
different values for it.

On other chips more precise control could be possible.

>> Some controls, like V4L2_CID_FLASH_INTENSITY, can't easily use a
>> standard unit. The luminous output depends on the LED connected (you
>> could use an incandescent lightbulb too, I suppose?) to the flash
>> controller. These controls typically control the current supplied by the
>> flash controller.
>>
>> The timing controls on the sensor could use pixels (or lines) since
>> these are the units the sensor uses itself. Converting between pixels
>> (or lines) and SI units is trivial since the pixel clock is known in the
>> user space.
>>
>> The flash chip, on the other hand, has no knowledge of sensor pixel
>> clock, so it should use SI units. Also, the timing control currently in
>> the flash chip itself is very coarse.
>>
>> PROPOSAL: If the component has internal timing which is known elsewhere,
>> such the sensor, the controls should use these units. Otherwise,
>> standard SI units should be used. In the sensor's case, this could be µs.
> 
> Not sure about that. I would go for SI units at all time.

Sometimes that's not possible.

The LED flash current on the adp1653 is known but I don't think that's
an universal property of LED flash controllers.

Which brings up another question: we have essentially the same control
but sometimes depending on the chip, the unit could be different. It
would be good to be able to tell this to the user space.

I think it would be nice to be able to attach unit and prefix (or
10^exponent) to the control. VIDIOC_QUERYCTRL would be the natural place
for passing such information to user space.

However, there are just two reserved fields left in struct
v4l2_queryctrl. Do you think it would be good use of those fields to add
such information there? Four bytes would definitely be enough for the
two together, perhaps even less.

>>
>>
>> Possible future extensions
>> ==========================
>>
>> 1. Indicator faults
>> -------------------
>>
>> Some chips do support these. As they are part of the same register (at
>> least on some chips [10]), they could be part of V4L2_CID_FLASH_FAULT
>> control.
>>
>> 2. Strobe output control on sensor
>> ----------------------------------
>>
>> Sensor requires strobe output control to trigger hardware strobe (on
>> next possible frame).
>>
>> 3. Sensor metadata on frames
>> ----------------------------
>>
>> It'd be useful to be able to read back sensor metadata. If the flash is
>> strobed (on sensor hardware) while streaming, it's difficult to know
>> otherwise which frame in the stream has been exposed with flash.
> 
> I wonder if it would make sense to have a V4L2_BUF_FLAG_FLASH buffer flag?
> That way userspace can tell if that particular frame was taken with flash.

That would be one way, yes.

But whether a video buffer had flash exposure is just one property of
the buffer; there are several such properties, for example exposure time
and gain.

I think this would be best resolved as part of the rest of the metadata
passing to user space.

>> 4. Timing of strobe
>> -------------------
>>
>> Hardware strobe timing relative to frame start. The length of the strobe
>> should be timeable as well.
>>
>> 5. Flash type control
>> ---------------------
>>
>> Probably it'd be good to be able to tell which kind of flash we have
>> (xenon/LED). This should be added no later than we have a xenon flash
>> driver.
>>
>> V4L2_CID_FLASH_TYPE
>>
>> 6. V4L2_CID_FLASH_EXTERNAL_STROBE_MODE
>> --------------------------------------
>>
>> The implementation of this control is postponed until we have a driver
>> which implements this functionality.
>>
>> 	V4L2_CID_FLASH_EXTERNAL_STROBE_MODE (bool; rw; xenon, LED)
>>
>> Whether the flash controller considers external strobe as edge, when the
>> only limit of the strobe is the timeout on flash controller, or level,
>> when the flash strobe will last as long as the strobe signal, or as long
>> until the timeout expires.
>>
>> enum v4l2_flash_external_strobe_mode {
>> 	V4L2_FLASH_EXTERNAL_STROBE_MODE_LEVEL,
>> 	V4L2_FLASH_EXTERNAL_STROBE_MODE_EDGE,
>> };
>>
>> Should V4L2_CID_FLASH_EXTERNAL_STROBE_MODE be renamed? Are _EDGE and
>> _LEVEL menu values enough to describe the functionality?
>>
>>
>> References
>> ==========
>>
>> [1] ADP1653 datasheet.
>> http://www.analog.com/static/imported-files/data_sheets/ADP1653.pdf
>>
>> [2] LM3555. http://www.national.com/mpf/LM/LM3555.html#Overview
>>
>> [3] AS3645 product brief.
>> http://www.austriamicrosystems.com/eng/Products/Lighting-Management/Camera-Flash-LED-Drivers/AS3645
>>
>> [4] Flashlight applet for the N900.
>> http://maemo.org/downloads/product/Maemo5/flashlight-applet/
>>
>> [5] V4L2 Warszaw brainstorming meeting notes, day 2.
>> http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%202%20(SGz6LU2esk).html
>>
>> [6] V4L2 Warszaw brainstorming meeting notes, day 3.
>> http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%203%20(RhoYa0X9D7).html
>>
>> [7] [RFC] V4L2 flash API for flash devices.
>> http://www.spinics.net/lists/linux-media/msg30725.html
>>
>> [8] http://www.spinics.net/lists/linux-media/msg30794.html
>>
>> [9] [RFC v2] V4L2 flash API for flash devices.
>> http://www.spinics.net/lists/linux-media/msg31135.html
>>
>> [10] AS3645 datasheet.
>> http://www.cdiweb.com/datasheets/austriamicro/AS3645_Datasheet_v1-6.pdf
>>
>> [11] Andrew's use cases for flash.
>> http://www.spinics.net/lists/linux-media/msg31363.html
>>
>> [12] [RFC v3] V4L2 flash API for flash devices.
>> http://www.spinics.net/lists/linux-media/msg31425.html
>>
>>
>> Cheers,
>>
>>
> 
> I think this is starting to look good.

Thanks! :-)

Kidn regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45903 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963Ab3IBVoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 17:44:06 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so2603164eek.37
        for <linux-media@vger.kernel.org>; Mon, 02 Sep 2013 14:44:04 -0700 (PDT)
Message-ID: <522506A1.7000200@gmail.com>
Date: Mon, 02 Sep 2013 23:44:01 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <Pine.LNX.4.64.1308261515320.1767@axis700.grange> <20130826110933.318f31fa@samsung.com> <6237856.Ni2ROBVUfl@avalon> <5224D952.5020004@googlemail.com>
In-Reply-To: <5224D952.5020004@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2013 08:30 PM, Frank Schäfer wrote:
> Sorry for the delayed reply.
> A few remarks:
>
> Am 27.08.2013 14:52, schrieb Laurent Pinchart:
>> ...
>>
>> Even if the bridge doesn't control the clock, it provides a clock to the
>> sensor. As such, it's the responsibility of the bridge driver to provide the
>> clock to the sensor driver. The sensor driver knows that the sensor needs a
>> clock, and must thus get a clock object from somewhere.
>
> As Mauro already noticed: the clock may be provided by a simple crystal.
> Who is supposed to provide the clock object in this case ?

Whatever module that defines configuration of the whole system. In case of
embedded systems it were the board files. Now it can be defined in DT as
a fixed rate clock and is handled by generic code, without a need for any
custom driver.

> Making a clock object mandatory isn't reasonable.

That's a too far generalization. :-)

> And the second argument is, that even if the clock is
> provided/controlled by another chip, it often makes no sense to let the
> sensor control them.

We need to have it modelled like this to support initialization from the
device tree. It has been agreed on the mailing list and on face-to-face
meetings. Let's not go in circles with that.

With device tree the order of initialization of drivers (e.g. I2C client
subdev and the host interface) cannot be determined in advance.

The I2C client subdev is normally a child of I2C bus controller device,
not the video host interface device. So it may happen that either I2C
client or the host initializes first. It cannot be determined in advance.

All resources that are provided to the sensor so it can complete its
initialization (e.g. I2C communication can be performed) need to be
explicitly modelled and the sensor driver needs to be aware when any
of them is missing.

Also a well written sensor driver needs to know exact frequency of the
master clock, so it can, e.g. configure any PLLs inside the sensor in
order to achieve requested frame rates, exposure times, etc.

I hear your argument that for some systems it's the bridge driver that
has some specific requirements for the clock frequency. But it seems
strange, in that particular case of the em28xx, that lower master clock
frequency is needed for higher resolution. Usually it's the opposite.
I'm curious how that strange requirement has been figured out in this
particular case ? I guess it's somehow connected with the pixel clock
signal ?

> At least in em28xx USB devices, it's the _bridge_ that controls and
> configures the sensor, not the other way around.

On embedded SoC systems it also often the host that has registers to
control the clock.

> The bridge knows better than the sensor if it wants to drive the sensor
> with 6, 12 or 24 MHz, when power should be switched on or off etc.

Not necessarily, power on/off sequences are supposed to be handled by
subdev drivers. Otherwise each bridge driver would need to code power/
clock sequences for each subdev. Do you think that's a good idea ?
N sensors * M bridge devices.

>  From an em28xx bridges point of view, the whole soc_camera module isn't
> needed and the sensor driver design appears to be "upside-down".

Perhaps there are some requirements missed. But we could also say that,
for embedded systems where we in majority of cases know what wiring
and device control registers exactly look like, thus it's clear what
resources and device properties should be associated with what driver,
the em28xx like modules are not needed. Since they were written with
simplified, e.g. due to insufficient access to documentation, view of
the hardware and are difficult to work with.

> The problem with the sensor drivers in soc_camera seems to be, that the
> assumptions and driver design decisions seem to be based on typical
> embedded hardware only and don't match the requirements of others.

Could be, note that there are many non soc-camera sensor drivers that
behave similarly. And now it is still difficult (not supported) to use
soc-camera sensor with non a soc-camera bridge. But related works are
ongoing AFAIK and it will likely get addressed in not so distant future.

> Changing that will be a not-so-trivial long-term task... :/

IIRC soc-camera already allowed the sensors to control the clocks in the
past, but then it was decided to move away from that. Not sure what were
the reasons, perhaps Guennadi knows the details. Now due to the DT boot
requirements it has been changed again.

>>>> * possible fixes: several fixes have been proposed, e.g.
>>>> (a) implement a V4L2 clock in em28xx.
>>>>
>>>>      Pro: logically correct - a clock is indeed present, local - no core
>>>> 	changes are needed
>>>>      Contra: presumably relatively many devices will have such static
>>>> 	
>>>> 	always-on clocks. Implementing them in each of those drivers will
>>>> 	add copied code. Besides creating a clock name from I2C bus and
>>>> 	device numbers is ugly (a helper is needed).
>>>>
>>>> (b) make clocks optional in all subdevice drivers
>>>>
>>>>      Pro: host / bridge drivers or core don't have to be modified
>>>>      Contra: wrong in principle - those clocks are indeed compulsory
>>> I don't think that (b) is wrong: it is not a matter or clocks being
>>> compulsory or not. It is a matter of being able to be controlled or not.
>>
>> No, it's a matter of providing a clock to a chip that needs one. If the chip
>> needs a clock, it must get one. Whether the clock can be controlled or not is
>> not relevant.
>
> IMHO it is relevant. And (as mentioned above) if the sensor
> _should_be_allowed_ to control the clock is also relevant.

If there is really nothing that could be done about those handful of the
old bridge drivers we could probably use a platform data flag at the sensor
subdevs they interwork with, signalling the clock usage is optional. With
device tree platform data is usually NULL so such flag wouldn't be set
automatically.

But that sounds like a wrong approach, given that it would make things
easier for...one? bridge driver and cause more trouble for tens of subdev
drivers that are used on (ARM) embedded systems, that will in near future
support in practice only initialization/booting from the device tree.

>> Otherwise all clock users would need to implement several code
>> paths depending on whether the clock is controllable or not.
>
> That's indeed what the drivers should do.
> What's so unusual about it ? soc_camera already does it. ;)
> As you can see from the code (and also my RFC patch), these "code paths"
> are basically pretty simple.

Could become slightly more complex once the drivers start using the clock
object to get/configure the clock's frequency.

> Of course, the async device registration mechanism needs to be
> fixed/improved.

So what's you proposed fixes/improvements ? ;-)

>> That's something we wanted to avoid, as it would result in code bloat.
>
> Forcing drivers to implement pseudo/fake clocks is code bloat.
>
>
> Am 27.08.2013 18:00, schrieb Mauro Carvalho Chehab:
>> Em Tue, 27 Aug 2013 17:27:52 +0200
>> Laurent Pinchart<laurent.pinchart@ideasonboard.com>  escreveu:
>>
>> ...
>>> The point is that the client driver knows that it needs a clock, and knows how
>>> to use it (for instance it knows that it should turn the clock on at least
>>> 100ms before sending the first I2C command). However, the client should not
>>> know how the clock is provided. That's the clock API abstraction layer. The
>>> client will request the clock and turn it on/off when it needs to, and if the
>>> clock source is a crystal it will always be on. On platforms where the clock
>>> can be controlled we will thus save power by disabling the clock when it's not
>>> used, and on other platforms the clock will just always be on, without any
>>> need to code this explictly in all client drivers.
>>
>> On em28xx devices, power saving is done by enabling reset pin. On several
>> hardware, doing that internally disables the clock line. I'm not sure if
>> ov2640 supports this mode (Frank may know better how power saving is done
>> with those cameras). Other devices have an special pin for power off or
>> power saving.
>
> The EM25xx describes a standard mapping of GPIO pins to several
> functionalities (LEDs, buttons, sensor power on/off, ...).
> But hardware manufacturers can of course build circuits differently.
> The VAD Laplace webcam for example doesn't use the dedicated GPIO-pin
> for sensor power on/off. It's sensor seems to be powered all the time.

It may be just a matter of passing a GPIO number to a specific driver.
If the GPIO is not used on a specific system we just pass EINVAL and its
handled gracefully in the GPIO API. No changes in a sensor driver needed.

>> Anyway, that rises an interesting question: on devices with wired clocks,
>> the power saving mode should not be provided via clock API abstraction
>> layer, but via a callback to the bridge (as the bridge knows the GPIO
>> register/bit that corresponds to device reset and/or power off pin).
>
> Well, you can add power on/off callbacks to struct soc_camera_link for
> this.

If a sensor has a STANDBY pin natural API to control any device attached
to such a pin is the GPIO API. By introducing various callbacks we are
just tying various elements using v4l2-specific APIs, which makes the
whole thing difficult to change partially.

> But - same question as above: who controls who ? ;)
> IMHO, it's the em28xx bridge that controls the sensor and decides when
> the sensor power needs to be switched on/off.

Yes, but that doesn't mean the bridge drivers need to handle power sequence
details for each specific sensor they need to interwork with.

--
Regards,
Sylwester


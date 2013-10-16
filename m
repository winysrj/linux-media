Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:38874 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3JPRRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 13:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <525DF0C7.9090407@ti.com>
References: <201309101134.32883.hansverk@cisco.com> <3335821.8epFKWiJXY@avalon>
 <CAK5ve-JHEaNrNiYwdMdEiEsD0LnqHG-MEAQv4D-962fYK0=g4A@mail.gmail.com>
 <2523390.YEHU3IBNqR@avalon> <CAK5ve-+N=GyNk-ryR0LbiUcT0TErFTwK60-vHNEf7112dNyh_A@mail.gmail.com>
 <525DF0C7.9090407@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 16 Oct 2013 10:17:02 -0700
Message-ID: <CAK5ve-K481KMXZJW9Ah8N_NaOYNNgdxABvewqiTOhquUAzr-UA@mail.gmail.com>
Subject: Re: [media-workshop] V2: Agenda for the Edinburgh mini-summit
To: Milo Kim <milo.kim@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	media-workshop@linuxtv.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Thierry Reding <thierry.reding@gmail.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-pwm@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 15, 2013 at 6:49 PM, Milo Kim <milo.kim@ti.com> wrote:
> Hi Bryan,
>
>
> On 10/16/2013 03:37 AM, Bryan Wu wrote:
>>
>> On Fri, Oct 11, 2013 at 12:38 AM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>>
>>> Hi Bryan,
>>>
>>> On Thursday 10 October 2013 17:02:18 Bryan Wu wrote:
>>>>
>>>> On Mon, Oct 7, 2013 at 3:24 PM, Laurent Pinchart wrote:
>>>>>
>>>>> On Tuesday 08 October 2013 00:06:23 Sakari Ailus wrote:
>>>>>>
>>>>>> On Tue, Sep 24, 2013 at 11:20:53AM +0200, Thierry Reding wrote:
>>>>>>>
>>>>>>> On Mon, Sep 23, 2013 at 10:27:06PM +0200, Sylwester Nawrocki wrote:
>>>>>>>>
>>>>>>>> On 09/23/2013 06:37 PM, Oliver Schinagl wrote:
>>>>>>>>>
>>>>>>>>> On 09/23/13 16:45, Sylwester Nawrocki wrote:
>>>>>>>>>>
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> I would like to have a short discussion on LED flash devices
>>>>>>>>>> support
>>>>>>>>>> in the kernel. Currently there are two APIs: the V4L2 and LED
>>>>>>>>>> class
>>>>>>>>>> API exposed by the kernel, which I believe is not good from user
>>>>>>>>>> space POV. Generic applications will need to implement both APIs.
>>>>>>>>>> I
>>>>>>>>>> think we should decide whether to extend the led class API to add
>>>>>>>>>> support for more advanced LED controllers there or continue to use
>>>>>>>>>> the both APIs with overlapping functionality. There has been some
>>>>>>>>>> discussion about this on the ML, but without any consensus reached
>>>>>>>>>> [1].
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> What about the linux-pwm framework and its support for the
>>>>>>>>> backlight
>>>>>>>>> via dts?
>>>>>>>>>
>>>>>>>>> Or am I talking way to uninformed here. Copying backlight to
>>>>>>>>> flashlight with some minor modification sounds sensible in a way...
>>>>>>>>
>>>>>>>>
>>>>>>>> I'd assume we don't need yet another user interface for the LEDs ;)
>>>>>>>> AFAICS the PWM subsystem exposes pretty much raw interface in sysfs.
>>>>>>>> The PWM LED controllers are already handled in the leds-class API,
>>>>>>>> there is the leds_pwm driver (drivers/leds/leds-pwm.c).
>>>>>>>>
>>>>>>>> I'm adding linux-pwm and linux-leds maintainers at Cc so someone may
>>>>>>>> correct me if I got anything wrong.
>>>>>>>
>>>>>>>
>>>>>>> The PWM subsystem is most definitely not a good fit for this. The
>>>>>>> only
>>>>>>> thing it provides is a way for other drivers to access a PWM device
>>>>>>> and
>>>>>>> use it for some specific purpose (pwm-backlight, leds-pwm).
>>>>>>>
>>>>>>> The sysfs support is a convenience for people that needs to use a PWM
>>>>>>> in a way for which no driver framework exists, or for which it
>>>>>>> doesn't
>>>>>>> make sense to write a driver. Or for testing.
>>>>>>>
>>>>>>>> Presumably, what we need is a few enhancements to support in a
>>>>>>>> standard way devices like MAX77693, LM3560 or MAX8997.  There is
>>>>>>>> already a led class driver for the MAX8997 LED controller
>>>>>>>> (drivers/leds/leds-max8997.c), but it uses some device-specific
>>>>>>>> sysfs
>>>>>>>> attributes.
>>>>>>>>
>>>>>>>> Thus similar devices are currently being handled by different
>>>>>>>> subsystems. The split between the V4L2 Flash and the leds class API
>>>>>>>> WRT to Flash LED controller drivers is included in RFC [1], it seems
>>>>>>>> still up to date.
>>>>>>>>
>>>>>>>>>> [1] http://www.spinics.net/lists/linux-leds/msg00899.html
>>>>>>>
>>>>>>>
>>>>>>> Perhaps it would make sense for V4L2 to be able to use a LED as
>>>>>>> exposed
>>>>>>> by the LED subsystem and wrap it so that it can be integrated with
>>>>>>> V4L2? If functionality is missing from the LED subsystem I suppose
>>>>>>> that
>>>>>>> could be added.
>>>>>>
>>>>>>
>>>>>> The V4L2 flash API supports also xenon flashes, not only LED ones.
>>>>>> That
>>>>>> said, I agree there's a common subset of functionality most LED flash
>>>>>> controllers implement.
>>>>>>
>>>>>>> If I understand correctly, the V4L2 subsystem uses LEDs as flashes
>>>>>>> for
>>>>>>> camera devices. I can easily imagine that there are devices out there
>>>>>>> which provide functionality beyond what a regular LED will provide.
>>>>>>> So
>>>>>>> perhaps for things such as mobile phones, which typically use a plain
>>>>>>> LED to illuminate the surroundings, an LED wrapped into something
>>>>>>> that
>>>>>>> emulates the flash functionality could work. But I doubt that the LED
>>>>>>> subsystem is a good fit for anything beyond that.
>>>>>>
>>>>>>
>>>>>> I originally thought one way to do this could be to make it as easy as
>>>>>> possible to support both APIs in driver which some aregued, to which I
>>>>>> agree, is rather poor desing.
>>>>>>
>>>>>> Does the LED API have a user space interface library like libv4l2? If
>>>>>> yes, one option oculd be to implement the wrapper between the V4L2 and
>>>>>> LED APIs there so that the applications using the LED API could also
>>>>>> access those devices that implement the V4L2 flash API. Torch mode
>>>>>> functionality is common between the two right now AFAIU,
>>>>>>
>>>>>> The V4L2 flash API also provides a way to strobe the flash using an
>>>>>> external trigger which typically connected to the sensor (and the user
>>>>>> can choose between that and software strobe). I guess that and Xenon
>>>>>> flashes aren't currently covered by the LED API.
>>>>>
>>>>>
>>>>> The issue is that we have a LED API targetted at controlling LEDs, a
>>>>> V4L2
>>>>> flash API targetted at controlling flashes, and hardware devices
>>>>> somewhere
>>>>> in the middle that can be used to provide LED or flash function.
>>>>> Merging
>>>>> the two APIs on the kernel side, with a compatibility layer for both
>>>>> kernel space and user space APIs, might be an idea worth investigating.
>>>>
>>>>
>>>> I'm so sorry for jumping in the discussion so late. Some how the
>>>> emails from linux-media was archived in my Gmail and I haven't
>>>> checkout this for several weeks.
>>>>
>>>> I agree right now LED API doesn't  quite fit for the usage of V4L2
>>>> Flash API. But I'd also like to see a unified API.
>>>>
>>>> Currently, LED API are exported to user space as sysfs interface,
>>>> while V4L2 Flash APIs are like IOCTL and user space library. We also
>>>> merged some LED Flash trigger into LED subsystem. My basic idea is
>>>> what about creating or expanding the LED Flash trigger driver and
>>>> provide a well defined sysfs interface, which can be wrapped into user
>>>> space libv4l2.
>>>
>>>
>>> The biggest reason why we're not fond of sysfs-based APIs for media
>>> devices is
>>> that they can't provide atomicity. There's no way to set multiple
>>> parameters
>>> in a single operation.
>>>
>>> We can't get rid of the sysfs LEDs API, but maybe we could have a unified
>>> kernel LED/flash subsystem that would provide both a sysfs-based API to
>>> ensure
>>> compatibility with current userspace software and an ioctl-based API
>>> (possibly
>>> through V4L2 controls). That way LED/flash devices would be registered
>>> with a
>>> single subsystem, and the corresponding drivers won't have to care about
>>> the
>>> API exposed to userspace. That would require a major refactoring of the
>>> in-
>>> kernel APIs though.
>>>
>>
>> I agree this. I'm thinking about expanding the ledtrig-camera.c
>> created by Milo Kim. This trigger will provide flashing and strobing
>> control of a LED device and for sure the LED device driver like
>> drivers/leds/leds-lm355x.c.
>>
>> So we basically can do this:
>> 1. add V4L2 Flash subdev into ledtrig-camera.c. So this trigger driver
>> can provide trigger API to kernel drivers as well as V4L2 Flash API to
>> userspace.
>> 2. add the real flash torch functions into LED device driver like
>> leds-lm355x.c, this driver will still provide sysfs interface and
>> extended flash/torch control sysfs interface as well.
>>
>> I'm not sure about whether we need some change in V4L2 internally. But
>> actually Andrzej Hajda's patchset is quite straightforward, but we
>> just need put those V4L2 Flash API into a LED trigger driver and the
>> real flash/torch operation in a LED device driver.
>>
>> Milo, could you please give some comments here?
>
>
> General LED trigger APIs were created not for the application interface but
> for any kernel space driver.
> The LED camera trigger APIs are used by a camera driver, not application.
>

That's basically correct, but trigger sometime can also provide sysfs
interface which might be used by user space app.

Actually this camera flash/torch trigger API can also be used by V4L2
Flash subdev.
We create a V4L2 Flash subdev in the driver, which will expose V4L2
API to user space. And this V4L2 Flash subdev will use this
flash/torch trigger API to talk with our LED core and it really
doesn't need to know the details about the LED flash/torch chip, if we
can provide a good interface between trigger and LED device driver.

So benefits are
a) one trigger/V4L2 Flash subdev driver can be used by multiple LED chips
b) LED chip driver just need to provide standard or extended LED API
to support flash/torch
c) LED chip driver still keep those LED sysfs interface to user space
and won't break user space application

> Some LED devices provide basic LED functionalities and high current features
> like a flash and a torch.(eg. LM3554, LM3642)
> The reason why I added the LED camera trigger is
>   "for providing multiple operations(LEDs, flash and torch) by one LED
> device driver".
>
> For example,
> A LED indicator is controlled via the LED sysfs.
> And flash and torch are controlled by a camera driver - calls exported LED
> trigger function, ledtrig_flash_ctrl().
>
> My understanding is the V4L2 subsystem provides rich IOCTLs for the media
> device.
> I agree that the V4L2 is more proper interface for camera *application*.
>
> So, my suggestion is:
>   - If a device has only flash/torch functionalities, then register the
> driver as the V4L2 sub-device.
>   - If a device provides not only flash/torch but also LED features, then
> create the driver as the MFD.
>

We really don't need to separate them, one LED device driver can
provide flash/torch/normal functions in on driver. I think LED device
driver is trying to provide the LED chip's hardware functions, like
flash/torch/indicator etc. how to use it, we can choose different
trigger. That gives us the maxim flexibility.

> For example, LM3555 (and AS3645A) is used only for the camera.
> Then, this driver is registered as the V4L2 sub-device.
> (drivers/media/i2c/as3645a.c) - no change at all.
>

That's current solution, we plan to unify this two API since those
chip are basically LED.

> On the other hands, LM3642 has an indicator mode with flash/torch.
> Then, it will consist of 3 parts - MFD core, LED(indicator) and
> V4L2(flash/torch).
>

So if one LED device driver can support that, we don't need these 3 parts.

Thanks,
-Bryan

> Then, ledtrig-camera will be removed after we complete to change the driver
> structure.
>
> Best regards,
> Milo
>
>

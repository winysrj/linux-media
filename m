Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab0IGXIX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Sep 2010 19:08:23 -0400
Message-ID: <4C86AB22.7020206@redhat.com>
Date: Tue, 07 Sep 2010 23:14:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
References: <20100906201105.4029d7e7@tele> <201009071650.21029.hverkuil@xs4all.nl> <4C863877.3000005@redhat.com> <201009071730.33642.hverkuil@xs4all.nl>
In-Reply-To: <201009071730.33642.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/07/2010 05:30 PM, Hans Verkuil wrote:
> On Tuesday, September 07, 2010 15:04:55 Hans de Goede wrote:
>> Hi,
>>
>> On 09/07/2010 04:50 PM, Hans Verkuil wrote:

<snip>

>>>> Both off
>>>> Top on, Bottom off
>>>> Top off, Bottom on
>>>> Both on
>>>>
>>>> Which raises the question do we leave this as is, or do we make this 2 boolean
>>>> controls. I personally would like to vote for keeping it as is, as both lamps
>>>> illuminate the same substrate in this case, and esp. switching between
>>>> Top on, Bottom off to Top off, Bottom on in one go is a good feature to have
>>>> UI wise (iow switch from top to bottom lighting or visa versa.
>>>
>>> The problem with having one control is that while this makes sense for this
>>> particular microscope, it doesn't make sense in general.
>>>
>>
>> Actual it does atleast for microscopes in general a substrate under a microscope
>> usually is either illuminated from above or below.
>>
>>> Standard controls such as proposed by this patch should have a fixed type
>>
>> Although I agree with that sentiment in general I don't see this as an absolute
>> need, apps should get the type by doing a query ctrl not by assuming they
>> know it based on the cid.
>>
>> And esp. for menu controls this is not true, for example
>> most devices have a light freq filter menu of:
>> off
>> 50 hz
>> 60 hz
>>
>> Which matches what is documented in videodev2.h
>>
>> Where as some have:
>> off
>> 50 hz
>> 60 hz
>> auto hz
>>
>> Because they can (and default to) detect the light frequency automatically.
>
> The v4l2 api allows drivers to selectively enable items from a menu. So this
> control has a fixed menu type and a fixed menu contents. Some of the menu
> choices are just not available for some drivers.

This is not possible:

Quoting from:
http://www.linuxtv.org/downloads/v4l-dvb-apis/re61.html
"Menu items are enumerated by calling VIDIOC_QUERYMENU with successive index values from struct v4l2_queryctrl minimum (0) to maximum, inclusive."

And many apps are coded this way, so we cannot simply skip values in a
menu enum just because a driver does not support them, this would
break apps as they (rightfully) don't expect an error when
calling VIDIOC_QUERYMENU with an index between minimum and
maximum, so given for example:

enum v4l2_led {
          V4L2_LED_AUTO = 0,
	 V4L2_LED_BLINK = 1,
          V4L2_LED_OFF = 2,
          V4L2_LED_ON = 3,
};

Drivers which do not support blink would still need to report a minimum
and maximum of 0 and 3, making any control apps expect 4 menu items not
3 !

And this example is exactly why I'm arguing against defining standard
meanings for standard controls with a menu type.

Also note that at least with the uvc driver that due to how extension
unit controls are working (the uvcvideo driver gets told about these
vendor specific controls from a userspace helper), the menu index is
the value which gets written to the hardware! So one cannot simply
make this match some random enum.

>
> There are several advantages of sticking to one standard menu for standard
> controls:
>
> 1) The contents of the menu can be defined centrally in v4l2-ctrls.c, which
>     ensures consistency. Not only of the menu texts, but also of how the
>     control behaves in various drivers.

No they cannot as v4l2-ctrls.c will not know when to return -EINVAL to
indicate that in the example case the driver does not support blink, and
moreover an app will not expect this and maybe decide to not show the
menu at all, or ...

> 2) It makes it possible to set the control directly from within a program.
>     This is currently true for *all* standard controls

No this is not true, programs still need to know minimum and maximum values
for all integer standard controls, brightness may be 0-15 on one device
and 0-65535 on another, so they cannot simply bang in any value they need to
take into account the query ctrl results.

> This looks pretty decent IMHO:
>
> enum v4l2_illuminator {
>          V4L2_ILLUMINATOR_OFF = 0,
>          V4L2_ILLUMINATOR_ON = 1,
> };
> #define V4L2_CID_ILLUMINATOR_0              (V4L2_CID_BASE+37)
> #define V4L2_CID_ILLUMINATOR_1              (V4L2_CID_BASE+38)
>

I don't like this, as explained before most microscopes have a top
and a bottom light, and you want to switch between them, or to
all off, or to all on. So having a menu with 4 options for this
makes a lot more sense then having 2 separate controls. Defining
these values as standard values would take away the option for drivers
to do something other then a simple on / off control here. Again
what is wrong with with not defining standard meanings for standard
controls with a menu type. This means less stuff in videodev2.h
and more flexibility wrt using these control ids.


I think we should not even define a type for this one. If we
get microscopes with pwm control for the lights we will want this
to be an integer using one control per light.

We have this excellent infrastructure to automatically discover
control types, ranges and menu item meaning. Why would it be
forbidden to use this for standard controls.

Either we need to drop our aversion for private controls, or
allow somewhat more flexible standard controls!

> enum v4l2_led {
>          V4L2_LED_AUTO = 0,
>          V4L2_LED_OFF = 1,
>          V4L2_LED_ON = 2,
> };
> #define V4L2_CID_LED_0              (V4L2_CID_BASE+39)
>
> Simple and straightforward.

Until a cam comes along which only supports auto and on, and
we have a whole in our menu range with the standard does not
allow!

>>> consistent behavior. Note that I am also wondering whether it wouldn't be a
>>> good idea to use a menu for this, just as for the LEDs.
>>
>> I do agree that the illuminator ctrls should be a menu, that way the driver
>> author can also choose wether to group 2 together in a single control or not
>> we simply should not specify the menu values in the spec (the same can
>> be said for the led case).
>
> See above. Just because you can do it, doesn't mean you should. In this case
> I think it is a bad idea. Standard controls should have standard behavior.

How about a compromise, we add a set of standard defines for menu
index meanings, with a note that these are present as a way to standardize
things between drivers, but that some drivers may deviate and that
apps should always use VIDIOC_QUERYMENU ?

Regards,

Hans

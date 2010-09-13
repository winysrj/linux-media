Return-path: <mchehab@localhost.localdomain>
Received: from mx1.redhat.com ([209.132.183.28]:9981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab0IMLpq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 07:45:46 -0400
Message-ID: <4C8E0ED2.4010403@redhat.com>
Date: Mon, 13 Sep 2010 08:45:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com> <4C88C9AA.2060405@redhat.com> <201009130904.19143.laurent.pinchart@ideasonboard.com> <201009131006.06967.hverkuil@xs4all.nl>
In-Reply-To: <201009131006.06967.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Em 13-09-2010 05:06, Hans Verkuil escreveu:
> On Monday, September 13, 2010 09:04:18 Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Thursday 09 September 2010 13:48:58 Hans de Goede wrote:
>>> On 09/09/2010 03:29 PM, Hans Verkuil wrote:
>>>>> On 09/09/2010 08:55 AM, Peter Korsgaard wrote:
>>>>>> "Hans" == Hans Verkuil<hverkuil@xs4all.nl>   writes:
>>>>>>
>>>>>> I originally was in favor of controlling these through v4l as well, but
>>>>>> people made some good arguments against that. The main one being: why
>>>>>> would you want to show these as a control? What is the end user supposed
>>>>>> to do with them? It makes little sense.
>>
>> Status LEDs reflect in glasses, making annoying color dots on webcam pictures. 
>> That's why Logitech allows to turn the status LED off on its webcams.
> 
> That's a really good argument. I didn't think of that one.

There's one difference between illuminators and leds and anything else that we use
currently via CTRL interface: all other controls affects just an internal hardware
capability that are not visible to the user, nor can cause any kind of damage or 
annoyance.

On the other hand, a LED and an illuminator that an application may forget to turn
off could be very annoying, and may eventually reduce the lifecycle or a device (in
the case of non-LED illuminators, for example).

So, a special treatment seems to be required for both cases: if the application that
changed the LED or illuminator to ON dies or closes, the LED/illuminator should be
turned off by the driver.

Maybe we could add an internal flag to be consumed by the controls core, and call it
during release() callback, to be sure that such controls will return to a default state
(0) when users count reaches zero.

> 
> I'm happy with a menu control for LEDs, something like:
> 
> Auto (default)
> Off
> 
> and possibly:
> 
> On
> Blink
> 
> Although I'm not so sure we need/want these last two.

Provided that it will return to Off (or auto) after application shuts down, I don't see
why not offering such control to userspace. While it may not make sense on desktops,
turning LEDs on may be interesting on some cases. For example, there are several Android
applications to turn the webcam "flash" LED on, meant to use the cell phone as an 
emergency light.

> It should be a control since otherwise v4l2 apps would need to add support for
> the LED interface just for this, whereas if it is a control it will 'just work'.
> 
> I think it is up to the driver whether it wants to implement the LED interface
> as well.


> 
> Regards,
> 
> 	Hans
> 
>>
>> [snip]
>>
>>>>> Reading this whole thread I have to agree that if we are going to expose
>>>>> camera status LEDs it would be done through the sysfs API. I think this
>>>>> can be done nicely for gspca based drivers (as we can put all the "crud"
>>>>> in the gspca core having to do it only once), but that is a low priority
>>>>> nice to have thingy.
>>>>>
>>>>> This does leave us with the problem of logitech uvc cams where the LED
>>>>> currently is exposed as a v4l2 control.
>>>>
>>>> Is it possible for the uvc driver to detect and use a LED control? That's
>>>> how I would expect this to work, but I know that uvc is a bit of a
>>>> strange beast.
>>>
>>> Unfortunately no, some uvc cameras have "proprietary" controls. The uvc
>>> driver knows nothing about these but offers an API to map these to v4l2
>>> controls (where userspace tells it the v4l2 cid, type, min, max, etc.).
>>>
>>> Currently on logitech cameras the userspace tools if installed will map
>>> the led control to a private v4l2 menu control with the following options:
>>> On
>>> Off
>>> Auto
>>> Blink
>>>
>>> The cameras default to auto, where the led is turned on when video
>>> is being streamed and off when there is no streaming going on.
>>
>> I confirm this. If the UVC LED controls were standard the driver could expose 
>> them through a LED-specific API. As UVC allows devices to implement private 
>> controls, the driver needs to expose all those private controls (both LED and 
>> non-LED) through the same API.
>>
>>
> 


Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0IMOic (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 10:38:32 -0400
Message-ID: <4C8E374B.4050103@redhat.com>
Date: Mon, 13 Sep 2010 11:38:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>	 <4C88C9AA.2060405@redhat.com>	 <201009130904.19143.laurent.pinchart@ideasonboard.com>	 <201009131006.06967.hverkuil@xs4all.nl>  <4C8E0ED2.4010403@redhat.com> <1284385792.2031.87.camel@morgan.silverblock.net>
In-Reply-To: <1284385792.2031.87.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-09-2010 10:49, Andy Walls escreveu:
> On Mon, 2010-09-13 at 08:45 -0300, Mauro Carvalho Chehab wrote:
>> Em 13-09-2010 05:06, Hans Verkuil escreveu:
>>> On Monday, September 13, 2010 09:04:18 Laurent Pinchart wrote:
>>>> Hi Hans,
>>>>
>>>> On Thursday 09 September 2010 13:48:58 Hans de Goede wrote:
>>>>> On 09/09/2010 03:29 PM, Hans Verkuil wrote:
>>>>>>> On 09/09/2010 08:55 AM, Peter Korsgaard wrote:
>>>>>>>> "Hans" == Hans Verkuil<hverkuil@xs4all.nl>   writes:
>>>>>>>>
>>>>>>>> I originally was in favor of controlling these through v4l as well, but
>>>>>>>> people made some good arguments against that. The main one being: why
>>>>>>>> would you want to show these as a control? What is the end user supposed
>>>>>>>> to do with them? It makes little sense.
>>>>
>>>> Status LEDs reflect in glasses, making annoying color dots on webcam pictures. 
>>>> That's why Logitech allows to turn the status LED off on its webcams.
>>>
>>> That's a really good argument. I didn't think of that one.
>>
>> There's one difference between illuminators and leds and anything else that we use
>> currently via CTRL interface: all other controls affects just an internal hardware
>> capability that are not visible to the user, nor can cause any kind of damage or 
>> annoyance.
>>
>> On the other hand, a LED and an illuminator that an application may forget to turn
>> off could be very annoying, and may eventually reduce the lifecycle or a device (in
>> the case of non-LED illuminators, for example).
> 
> Yes, I can appreciate that.  On driver unload and suspend that should
> certainly be the case for illuminators.
> 
> However, I don't think that's a good idea for final close on a file
> descriptor though.  That's a departure from normal V4L2 behavior.

This doesn't seem to be a good reason. Keeping a LED after its usage is annoying to 
the user, can cause damage on devices (reduce lifetime) and can draw lots of power 
from the batteries (on battery-powered devices).

> For a USB connected device, turning off the illuminator after the fact
> is simple, if the user has no other recourse: unplug the device. :)

Try to unplug the flash led on your cell phone ;)

>> So, a special treatment seems to be required for both cases: if the application that
>> changed the LED or illuminator to ON dies or closes, the LED/illuminator should be
>> turned off by the driver.
> 
> That will break cases like these:
> 
> $ v4l2-ctl -d /dev/video0 -c illuminator_2=1
> $ (command to run app that doesn't present all controls, e.g. cheese)

True, but it may have an alternative syntax for it, like:

v4l2-ctl -d /dev/video0 -c illuminator_2=1 --run cheese [<args>]

This way, if cheese or v4l2-ctl abends, the illuminator will be turned off.

Of course, we'll likely need to have a flag visible on userspace, to say that such
control resets to an "off" state when the application dies, to avoid someone to use it
like:
	v4l2-ctl -d /dev/video0 -c illuminator_2=1

Cheers,
Mauro

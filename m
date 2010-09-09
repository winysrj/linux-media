Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3824 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0IIOSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 10:18:05 -0400
Message-ID: <275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
In-Reply-To: <y1el0c4vecj8x6uk04ypatvd.1284039765001@email.android.com>
References: <y1el0c4vecj8x6uk04ypatvd.1284039765001@email.android.com>
Date: Thu, 9 Sep 2010 16:17:40 +0200
Subject: Re: [PATCH] Illuminators and status LED controls
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andy Walls" <awalls@md.metrocast.net>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Peter Korsgaard" <jacmet@sunsite.dk>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	"ext Eino-Ville Talvala" <talvala@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


> Hans,
> I'll have more later, but I can say, if LED API is what we agree to, we
> should have infrastructure in v4l2 at a level higher than gspca for
> helping drivers use the LED interface and triggers.
>
>
> Specifically this is needed to make discovery and association of v4l2
> devices, exposed v4l2 LEDs, and v4l2 LED triggers easier for userspace,
> and to provide a logical, consistent naming scheme.  It may also help with
> logical association to a v4l2 media controller later on.

The association between a v4l device and sysfs LEDs is something that
should be exposed in the upcoming media API (although I guess we should
take a look first as to how that should be done exactly).

But I feel I am missing something: who is supposed to use these LEDs?
Turning LEDs in e.g. webcams on or off is a job for the driver, never for
a userspace application. For that matter, if the driver handles the LEDs,
can we still expose the API to userspace? Wouldn't those two interfere
with one another? I know nothing about the LED interface in sysfs, but I
can imagine that will be a problem.

> Sysfs entry ownership, unix permissions, and ACL permissions consistency
> with /dev/videoN will be the immediate usability problem for end users in
> any case.

Again, why would end users or application need or want to manipulate such
LEDs in any case?

> Sucessfully setting up or disabling LED triggers without much
> documentation will likely be the other largest hurdle for the average
> user.  (To disable an indicator LED that is manipulated automatically by a
> driver using its own Default LED trigger, the end user must disable the
> trigger in addition to setting the brightness to 0.)
>
> I still want to add trigger use to my prototype to discover the nuances.
>
>
> BTW, what did you mean by uvc discovering an LED control?

In order for the uvc driver to be able to turn LEDs on or off it needs to
detect that the uvc camera actually has a LED. It is my impression that
that is something that the driver has to discover from the uvc camera
itself. Either that, or it is passed in from the userspace utility that
uses the usb ID to determine the uvc extension controls and tells the
driver about it.

I'm probably not using the right terminology, but I hope I didn't make too
much of a mess of it :-)

In any case, the uvc driver has to discover somehow if there are leds and
how to turn them on/off.

Regards,

        Hans

>
> Regards,
> Andy
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>>
>>> Hi,
>>>
>>> On 09/09/2010 08:55 AM, Peter Korsgaard wrote:
>>>>>>>>> "Hans" == Hans Verkuil<hverkuil@xs4all.nl>  writes:
>>>>
>>>> Hi,
>>>>
>>>>   >>  - the status LED should be controlled by the LED interface.
>>>>
>>>>   Hans>  I originally was in favor of controlling these through v4l as
>>>>   Hans>  well, but people made some good arguments against that. The
>>>> main
>>>>   Hans>  one being: why would you want to show these as a control?
>>>> What
>>>> is
>>>>   Hans>  the end user supposed to do with them? It makes little sense.
>>>>
>>>>   Hans>  Frankly, why would you want to expose LEDs at all? Shouldn't
>>>> this
>>>>   Hans>  be completely hidden by the driver? No generic application
>>>> will
>>>>   Hans>  ever do anything with status LEDs anyway. So it should be the
>>>>   Hans>  driver that operates them and in that case the LEDs do not
>>>> need
>>>>   Hans>  to be exposed anywhere.
>>>>
>>>> It's not that it *HAS* to be exposed - But if we can, then it's nice
>>>> to
>>>> do
>>>> so as it gives flexibility to the user instead of hardcoding policy in
>>>> the kernel.
>>>>
>>>
>>> Reading this whole thread I have to agree that if we are going to
>>> expose
>>> camera status LEDs it would be done through the sysfs API. I think this
>>> can be done nicely for gspca based drivers (as we can put all the
>>> "crud"
>>> in the gspca core having to do it only once), but that is a low
>>> priority
>>> nice to have thingy.
>>>
>>> This does leave us with the problem of logitech uvc cams where the LED
>>> currently is exposed as a v4l2 control.
>>
>>Is it possible for the uvc driver to detect and use a LED control? That's
>>how I would expect this to work, but I know that uvc is a bit of a
>> strange
>>beast.
>>
>>Regards,
>>
>>         Hans
>>
>>--
>>Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of
>> Cisco
>>
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco


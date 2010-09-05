Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:7940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0IEIN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 04:13:57 -0400
Message-ID: <4C83528F.3070705@redhat.com>
Date: Sun, 05 Sep 2010 10:19:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
References: <20100904131048.6ca207d1@tele> <4C834D46.5030801@redhat.com> <87sk1oty46.fsf@macbook.be.48ers.dk>
In-Reply-To: <87sk1oty46.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi,

On 09/05/2010 10:04 AM, Peter Korsgaard wrote:
>>>>>> "Hans" == Hans de Goede<hdegoede@redhat.com>  writes:
>
> Hi,
>
>   >>  +	<entry><constant>V4L2_CID_LEDS</constant></entry>
>   >>  +	<entry>integer</entry>
>   >>  +	<entry>Switch on or off the LED(s) or illuminator(s) of the device.
>   >>  +	    The control type and values depend on the driver and may be either
>   >>  +	    a single boolean (0: off, 1:on) or the index in a menu type.</entry>
>   >>  +	</row>
>
>   Hans>  I think that using one control for both status leds (which is
>   Hans>  what we are usually talking about) and illuminator(s) is a bad
>   Hans>  idea. I'm fine with standardizing these, but can we please have 2
>   Hans>  CID's one for status lights and one for the led. Esp, as I can
>   Hans>  easily see us supporting a microscope in the future where the
>   Hans>  microscope itself or other devices with the same bridge will have
>   Hans>  a status led, so then we will need 2 separate controls anyways.
>
> Why does this need to go through the v4l2 api and not just use the
> standard LED (sysfs) api in the first place?
>

Quoting from the reply by Jean-Francois Moine to a patch adding illuminator control
support to the cpia1 driver where this proposal is a result of:

###

As many gspca users are waiting for a light/LED/illuminator/lamp
control, I tried to define a standard one in March 2009:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/3095

A second, but more restrictive, attempt was done by Németh Márton in
February 2010:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16705

The main objection to that proposals was that the sysfs LED interface
should be used instead:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/3114

A patch in this way was done by Németh Márton in February 2010:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16670

but it was rather complex, and there was no consensus
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17111

###

So using the sysfs interface for this is non trivial. Most cameras don't offer
any hardware dimming / blinking features, but we do want to do an auto setting
where the led goes on when streaming and goes off again when not streaming.
So the sysfs interface is not a good match to what we need.

A more important argument IMHO however is that the LED control is just one element
of many things one can control on  (some) webcams, things like focus, pan and tilt
for the more fancy ones also come into play. Not to mention contrast, brightness
etc. settings. Currently we have one central API for this which is the v4l2 ctrl
API, and we have several apps which dynamically build up a UI for this depending
on the ctrls advertised by the device. Adding a LED ctrl to the v4l2 API will
make this automatically show up in these apps and give the user one central place
to control everything related to the camera. Where as using the led sysfs API would
mean that the led control will basically stay invisible to the end user unless we
start patching all apps to also use support this API, requiring all v4l2 apps
to grow code to support a whole new api just to turn on / off a led does not
seem like a good idea to me.

Regards,

Hans














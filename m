Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39269 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZCNN6I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 09:58:08 -0400
Subject: Re: [PATCH] LED control
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
In-Reply-To: <20090314091747.21153855@pedra.chehab.org>
References: <20090314125923.4229cd93@free.fr>
	 <20090314091747.21153855@pedra.chehab.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 09:58:21 -0400
Message-Id: <1237039101.3272.24.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-03-14 at 09:17 -0300, Mauro Carvalho Chehab wrote:
> On Sat, 14 Mar 2009 12:59:23 +0100
> Jean-Francois Moine <moinejf@free.fr> wrote:
> 
> > +	    <entry><constant>V4L2_CID_LEDS</constant></entry>
> > +	    <entry>integer</entry>
> > +	    <entry>Switch on or off the LEDs or illuminators of the device.
> > +In the control value, each LED may be coded in one bit (0: off, 1: on) or in
> > +many bits (light intensity).</entry>
> > +	  </row>
> > +	  <row>
> 
> The idea of having some sort of control over the LEDs is interesting, but we
> should have a better way of controlling it. If the LED may have more than one
> bit, maybe the better would be to create more than one CID entry. Something like:
> 
> V4L2_CID_LED_POWER	- for showing that the camera is being used
> V4L2_CID_LED_LIGHT	- for normal white light
> V4L2_CID_LED_INFRARED	- for dark light, using infrared
> ...
> 
> This way a driver can enumberate what kind of leds are available, and get the
> power intensity range for each individual one.

Just some random thought of mine of the subject of LED control:


I have an EVK board that has 4 LED's on it.  

They are red and of the on/off type. (Although I suppose someday someone
might install a dual color LED unit (red & green) or tri-color LED unit
(red yellow green) on a piece of equipment.)

They are controlled by GPIOs.

Right now the cx18 driver implicitly controls them when switching
between audio inputs, tuner, and radio.  However, I was going to
internally make an "LED Controller" v4l2_subdevice to handle them.


So I agree that *if* giving control of LEDs to the user application
supports valid use cases, then the API spec needs some more thought.

There are at least these uses for LED's in devices:

1. Simple indicator/display
2. Subject matter illumination for video/image capture (I'm guessing)
3. Area illimunation to provide a reference level to an on board sensor
(i.e. IR motion detection?)
4. Transmission of data (e.g IR remotes)


The first questions to answer in all of these cases

1. "Should this be controllable from userspace?"

2. "Should it be a user control?"
(When the whole sensor orientation feedback thing came up and Hans spoke
of a good "fit" in the API for sensor feedback, I concluded that there
isn't a terribly good place in the V4L2 API for sensor feedback,
miscellaneous input, or indicator status.  Nor is there a good way to
enumerate them.  Maybe I'm missing something.)

For a subcase of a display indicator to indicate device "power on", if
the driver can control that at all (they should be tied to the output of
a voltage regulator really) why would you want a use app to "lie" to the
user and say power is off?

OK.  That's the end of my random thoughts.

Regards,
Andy


> Cheers,
> Mauro



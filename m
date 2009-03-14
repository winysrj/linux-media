Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:49564 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbZCNN3M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 09:29:12 -0400
Date: Sat, 14 Mar 2009 14:25:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
Message-ID: <20090314142513.315c52b0@free.fr>
In-Reply-To: <20090314091747.21153855@pedra.chehab.org>
References: <20090314125923.4229cd93@free.fr>
	<20090314091747.21153855@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009 09:17:47 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Sat, 14 Mar 2009 12:59:23 +0100
> Jean-Francois Moine <moinejf@free.fr> wrote:
> 
> > +	    <entry><constant>V4L2_CID_LEDS</constant></entry>
> > +	    <entry>integer</entry>
> > +	    <entry>Switch on or off the LEDs or illuminators of
> > the device. +In the control value, each LED may be coded in one bit
> > (0: off, 1: on) or in +many bits (light intensity).</entry>
> > +	  </row>
> > +	  <row>
> 
> The idea of having some sort of control over the LEDs is interesting,
> but we should have a better way of controlling it. If the LED may
> have more than one bit, maybe the better would be to create more than
> one CID entry. Something like:
> 
> V4L2_CID_LED_POWER	- for showing that the camera is being used
> V4L2_CID_LED_LIGHT	- for normal white light
> V4L2_CID_LED_INFRARED	- for dark light, using infrared
> ...
> 
> This way a driver can enumberate what kind of leds are available, and
> get the power intensity range for each individual one.

OK for V4L2_CID_LED_INFRARED: I already know a webcam type which needs
such a control, but I don't know if it is associated to a LED or to a
sensor capability.

I heard of some webcams with many LEDs (up to 6) and some of these last
ones may be independently switched on or off. But, actually, I don't
heard about individual or global LED power.

So, as I understand your controls, V4L2_CID_LED_LIGHT would contain a
bit array, one bit for each LED, and V4L2_CID_LED_POWER would give the
light intensity for all LEDs. This last control might be added later if
needed.

Am I right?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:41066 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0IIGG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 02:06:58 -0400
Date: Thu, 9 Sep 2010 08:07:02 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
	Andy Walls <awalls@md.metrocast.net>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Illuminators and status LED controls
Message-ID: <20100909080702.1687d29a@tele>
In-Reply-To: <87fwxkcbat.fsf@macbook.be.48ers.dk>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
	<4C86F210.2060605@stanford.edu>
	<20100908075903.GE29776@besouro.research.nokia.com>
	<1283963858.6372.81.camel@morgan.silverblock.net>
	<87fwxkcbat.fsf@macbook.be.48ers.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 08 Sep 2010 20:58:18 +0200
Peter Korsgaard <jacmet@sunsite.dk> wrote:
> >>>>> "Andy" == Andy Walls <awalls@md.metrocast.net> writes:
>  Andy> Incandescent and Halogen lamps that effect an image coming
>  Andy> into a camera are *not* LEDs that blink or flash automatically
>  Andy> based on driver or system trigger events.  They are components
>  Andy> of a video capture system with which a human attempts to
>  Andy> adjust the appearance of an image of a subject by changing the
>  Andy> subject's environment.  These illuminators are not some
>  Andy> generically connected device, but controlled by GPIO's on the
>  Andy> camera's bridge or sensor chip itself.  Such an illuminator
>  Andy> will essentially be used only in conjunction with the camera.
> 
> Agreed.
> 
>  Andy> Status LEDs integrated into webcam devices that are not
>  Andy> generically connected devices but controlled with GPIOs on the
>  Andy> camera's bridge or sensor chip will also essentially be used
>  Andy> only in conjunction with the camera.
> 
> Or for any other usage the user envision - E.G. I could imagine using
> the status led of the webcam in my macbook for hard disk or wifi
> activity. I'm sure other people can come up with more creative use
> cases as well.
> 
>  Andy> Turning these sorts camera specific illuminators and LEDs on
>  Andy> an off should be as simple to implement for an application
>  Andy> developer as it is to grasp the concept of turning a light
>  Andy> bulb on and off.
> 
> The point is that the logic rarely needs to be in the v4l
> applications. The status LEDs should by default go on when the v4l
> device is active and go off again when not like it used to do. A v4l
> application developer would normally not want to worry about such
> things, and only care about the video data.
> 
> But if a user wants something special / non-standard, then it's just a
> matter of changing LED trigger in /sys/class/leds/..
	[snip]
> Again, for status LEDs I don't see any reason why a standard v4l tool
> would care. As I mentioned above, illuminators are a different story
> (comparable to a gain setting imho).
	[snip]
> Again, I see the sysfs LED interface for status LEDs as more of a
> user/administrator interface than a programming API.

Hi,

If I may resume this exchange:

- the (microscope or device dependant) illuminators may be controlled
  by v4l2,

- the status LED should be controlled by the LED interface.

Does everybody agree?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

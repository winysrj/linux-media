Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:13846 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab0IHQhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 12:37:53 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
From: Andy Walls <awalls@md.metrocast.net>
To: eduardo.valentin@nokia.com
Cc: ext Eino-Ville Talvala <talvala@stanford.edu>,
	ext Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <20100908075903.GE29776@besouro.research.nokia.com>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
	 <4C86F210.2060605@stanford.edu>
	 <20100908075903.GE29776@besouro.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 12:37:38 -0400
Message-ID: <1283963858.6372.81.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 2010-09-08 at 10:59 +0300, Eduardo Valentin wrote:
> Hello,
> 
> On Wed, Sep 08, 2010 at 04:16:48AM +0200, ext Eino-Ville Talvala wrote:
> > 
> >  This is probably a bit OT, but these sorts of indicator LEDs can get quite complicated.
> > 
> > As part of our FCamera sample program on the Nokia N900 (which uses
> V4L2 way down there), we wanted to reprogram the front indicator LED
> to flash exactly when a picture is taken.
>   The N900 front LED is quite a programmable beast [1], with a
> dedicated microcontroller (the lp5521) that runs little programs that
> define the blink patterns for the RGB LED.
> > 
> > I'm not really suggesting that the V4L2 control should be able to
> handle this sort of an LED, but as these sorts of things get cheaper,
> it may become a case of 'why not?' for manufacturers putting in more
> complex RGB LEDs.   And if you don't want to encapsulate all that in
> V4L2, it may be better to leave it to other APIs at some point of
> complexity (the current lp5521 driver seems to have a sysfs-only
> interface for now for the programmable patterns, and the standard LED
> API otherwise)
> > 
> > [1] http://wiki.maemo.org/LED_patterns
> 
> Well, that's exactly why duplicating API's is usually a bad idea. If
> the thing start to get complex, having only one place to hold
> the mess is better than keeping it into two (or more) different
> places. This will become worst and worst. I mean, why do we want two
> different APIs to control same stuff?

For the case when requiring an application to use two separate APIs adds
more complexity for application developer than it alleviates.

Let's be more specific about "stuff" that may need to be controlled:

1. Illuminators with control lines directly tied to a camera's bridge or
sensor chip

2. Simple status LEDs tied directly to a camera's bridge or sensor chip
(maybe with a simple hardware assisted blink)

3. Generically connected LEDs (some platform GPIO chip or
microcontroller somewhere) with blinking or PWM intensity under CPU or
microcontroller control.

Number 1 & 2 above certainly apply to consumer desktop devices.

Number 3 is likely common on embedded devices.



Incandescent and Halogen lamps that effect an image coming into a camera
are *not* LEDs that blink or flash automatically based on driver or
system trigger events.  They are components of a video capture system
with which a human attempts to adjust the appearance of an image of a
subject by changing the subject's environment.  These illuminators are
not some generically connected device, but controlled by GPIO's on the
camera's bridge or sensor chip itself.  Such an illuminator will
essentially be used only in conjunction with the camera.

Status LEDs integrated into webcam devices that are not generically
connected devices but controlled with GPIOs on the camera's bridge or
sensor chip will also essentially be used only in conjunction with the
camera.

Turning these sorts camera specific illuminators and LEDs on an off
should be as simple to implement for an application developer as it is
to grasp the concept of turning a light bulb on and off.


The LED interface seems more appropriate to use when the LEDs are
connected more generically and will likely be used more generically,
such as in an embedded system.



> And yes, application developers must use the correct API to control
> stuff.

>  Why should kernel duplicate interfaces just because
> user land don't want to use two different interfaces? Doesn't this sound a bit ... strange at least?

Why should the kernel push multiple APIs on application developers to
control a complex federation of small devices all connected behind a
single bridge chip, which the user perceives as a single device?  (BTW a
USB microscope is such a federation which doesn't work at all without
proper subject illumination.)

V4L2 controls are how desktop V4L2 applications currently control
aspects of a incoming image.  Forcing the use of the LED interface in
sysfs to control one aspect of that would be a departure from the norm
for the existing V4L2 desktop applications.

Forcing the use of the LED interface also brings along the complication
of proper association of the illuminator or LED sysfs control node to
the proper video capture/control device node.  I have a laptop with a
built in webcam with a status LED and a USB connected microscope with
two illuminators.  What are the steps for an application to discover the
correct light for the video device and what settings that light is
capable of: using V4L2 controls? using the LED interface?

With the V4L2 controls, association to the correct video devices is no
effort, and current v4l2 control handling code in applications like
v4l2-ctl and qv4l2 can discover the controls and their metadata and
present the control in a UI with no changes to the application.

How does one go about associating LEDs and Illuminators to video device
nodes using the LED sysfs interface?  I'm betting it's not as simple for
applications that use V4L2 controls.

What you suggest is a separate API, and all the burdens it brings, just
to accomplish a simple task of turning a few switches on and off.

That to me is analogous to insisting to use a few bolts made to SI
units, on a vehicle otherwise made with fasteners made to English units.


I do not see how forcing applications to use a second control API, with
no clear video device node<->led sysfs node association semantics,
reduces application complexity, when those applications already support
the V4L2 control API from which application can generically discover
controls and their metadata and automatically know the associated video
device.


Regards,
Andy

> > 
> > Eino-Ville Talvala
> > Computer Graphics Lab
> > Stanford University
> > 
> > On 9/7/2010 1:33 PM, Andy Walls wrote:
> > > It has already been discussed.  Please check the list archives for the past few days.
> 
> 
> OK, will search the logs. But you should probably add some sort of reasoning in your patch
> description, explaining why you are duplicating interfaces.
> 
> > >
> > > Do you know of any V4L2 application developer or development team that prefers to use a separate API just to turn lights on and off, when all other aspects of the incoming video are controlled with the V4L2 control API?
> > >
> > > (That question is mostly rhetorical, but I'd still actually be interested from video app developers.)
> > >
> > > Regards,
> > > Andy
> > >
> > > Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
> > >
> > >> Hello,
> > >>
> > >> On Mon, Sep 06, 2010 at 08:11:05PM +0200, ext Jean-Francois Moine wrote:
> > >>> Hi,
> > >>>
> > >>> This new proposal cancels the previous 'LED control' patch.
> > >>>
> > >>> Cheers.
> > >>>
> > >>> -- 
> > >>> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> > >>> Jef		|		http://moinejf.free.fr/
> > >> Apologies if this has been already discussed but,
> > >> doesn't this patch duplicates the same feature present
> > >> nowadays under include/linux/leds.h ??
> > >>
> > >> I mean, if you want to control leds, I think we already have that API, no?
> > >>
> > >> BR,
> > >>
> > >> ---
> > >> Eduardo Valentin
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> > 
> 



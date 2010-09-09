Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33273 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab0IIEH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 00:07:26 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
From: Andy Walls <awalls@md.metrocast.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>,
	ext Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTikYon8802NhOMO=A7utPBPOBNNsxLeU7RQb3=ir@mail.gmail.com>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
	 <4C86F210.2060605@stanford.edu>
	 <20100908075903.GE29776@besouro.research.nokia.com>
	 <1283963858.6372.81.camel@morgan.silverblock.net>
	 <87fwxkcbat.fsf@macbook.be.48ers.dk>
	 <AANLkTikYon8802NhOMO=A7utPBPOBNNsxLeU7RQb3=ir@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 00:07:05 -0400
Message-ID: <1284005225.29812.38.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 2010-09-08 at 15:27 -0400, Alex Deucher wrote:
> On Wed, Sep 8, 2010 at 2:58 PM, Peter Korsgaard <jacmet@sunsite.dk> wrote:
> >>>>>> "Andy" == Andy Walls <awalls@md.metrocast.net> writes:
> >
> > Hi,
> >
> >  Andy> Incandescent and Halogen lamps that effect an image coming into a
> >  Andy> camera are *not* LEDs that blink or flash automatically based on
> >  Andy> driver or system trigger events.  They are components of a video
> >  Andy> capture system with which a human attempts to adjust the
> >  Andy> appearance of an image of a subject by changing the subject's
> >  Andy> environment.  These illuminators are not some generically
> >  Andy> connected device, but controlled by GPIO's on the camera's bridge
> >  Andy> or sensor chip itself.  Such an illuminator will essentially be
> >  Andy> used only in conjunction with the camera.
> >
> > Agreed.
> >
> >  Andy> Status LEDs integrated into webcam devices that are not generically
> >  Andy> connected devices but controlled with GPIOs on the camera's bridge or
> >  Andy> sensor chip will also essentially be used only in conjunction with the
> >  Andy> camera.
> >
> > Or for any other usage the user envision - E.G. I could imagine using
> > the status led of the webcam in my macbook for hard disk or wifi
> > activity. I'm sure other people can come up with more creative use cases
> > as well.
> >
> >  Andy> Turning these sorts camera specific illuminators and LEDs on an off
> >  Andy> should be as simple to implement for an application developer as it is
> >  Andy> to grasp the concept of turning a light bulb on and off.
> >
> > The point is that the logic rarely needs to be in the v4l
> > applications. The status LEDs should by default go on when the v4l
> > device is active and go off again when not like it used to do. A v4l
> > application developer would normally not want to worry about such
> > things, and only care about the video data.
> >
> > But if a user wants something special / non-standard, then it's just a
> > matter of changing LED trigger in /sys/class/leds/..
> 
> I agree with Peter here.  I don't see why a video app would care about
> blinking an LED while capturing.  I suspect most apps won't bother to
> implement it, or it will be a card specific mess (depending on what
> the hw actually provides).  Shouldn't the driver just turn it on or
> blink it when capturing is active or whatever.  Why should apps care?
> Plus, each app may implement some different behavior or some may not
> implement it at all which will further confuse users.
> 
> Alex

Hi all,

I just got finished a prototype implementation of using the LED API for
the illuminators on the QX3 microscope, so I could learn about the
interface.  (No devices in any of my systems presented an led interface,
so I had.)  I'm too tired right now to discuss what I've found, but I'll
hopefully respond with my observations around noon EDT tomorrow.

Two patches - my previous one using the V4L2 control API, and this
second one using the LED API - can be found as the last two patches
here:

	http://linuxtv.org/hg/~awalls/qx3/

$ diffstat qx3-lamp.diff
 cpia1.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 11 deletions(-)

$ diffstat qx3-ledapi.diff
 cpia1.c |  185 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 183 insertions(+), 2 deletions(-)

Regards,
Andy


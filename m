Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62277 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0IHT1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 15:27:21 -0400
Received: by fxm16 with SMTP id 16so382549fxm.19
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 12:27:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fwxkcbat.fsf@macbook.be.48ers.dk>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
	<4C86F210.2060605@stanford.edu>
	<20100908075903.GE29776@besouro.research.nokia.com>
	<1283963858.6372.81.camel@morgan.silverblock.net>
	<87fwxkcbat.fsf@macbook.be.48ers.dk>
Date: Wed, 8 Sep 2010 15:27:19 -0400
Message-ID: <AANLkTikYon8802NhOMO=A7utPBPOBNNsxLeU7RQb3=ir@mail.gmail.com>
Subject: Re: [PATCH] Illuminators and status LED controls
From: Alex Deucher <alexdeucher@gmail.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Andy Walls <awalls@md.metrocast.net>, eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>,
	ext Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 8, 2010 at 2:58 PM, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Andy" == Andy Walls <awalls@md.metrocast.net> writes:
>
> Hi,
>
>  Andy> Incandescent and Halogen lamps that effect an image coming into a
>  Andy> camera are *not* LEDs that blink or flash automatically based on
>  Andy> driver or system trigger events.  They are components of a video
>  Andy> capture system with which a human attempts to adjust the
>  Andy> appearance of an image of a subject by changing the subject's
>  Andy> environment.  These illuminators are not some generically
>  Andy> connected device, but controlled by GPIO's on the camera's bridge
>  Andy> or sensor chip itself.  Such an illuminator will essentially be
>  Andy> used only in conjunction with the camera.
>
> Agreed.
>
>  Andy> Status LEDs integrated into webcam devices that are not generically
>  Andy> connected devices but controlled with GPIOs on the camera's bridge or
>  Andy> sensor chip will also essentially be used only in conjunction with the
>  Andy> camera.
>
> Or for any other usage the user envision - E.G. I could imagine using
> the status led of the webcam in my macbook for hard disk or wifi
> activity. I'm sure other people can come up with more creative use cases
> as well.
>
>  Andy> Turning these sorts camera specific illuminators and LEDs on an off
>  Andy> should be as simple to implement for an application developer as it is
>  Andy> to grasp the concept of turning a light bulb on and off.
>
> The point is that the logic rarely needs to be in the v4l
> applications. The status LEDs should by default go on when the v4l
> device is active and go off again when not like it used to do. A v4l
> application developer would normally not want to worry about such
> things, and only care about the video data.
>
> But if a user wants something special / non-standard, then it's just a
> matter of changing LED trigger in /sys/class/leds/..

I agree with Peter here.  I don't see why a video app would care about
blinking an LED while capturing.  I suspect most apps won't bother to
implement it, or it will be a card specific mess (depending on what
the hw actually provides).  Shouldn't the driver just turn it on or
blink it when capturing is active or whatever.  Why should apps care?
Plus, each app may implement some different behavior or some may not
implement it at all which will further confuse users.

Alex

>
>  Andy> The LED interface seems more appropriate to use when the LEDs are
>  Andy> connected more generically and will likely be used more generically,
>  Andy> such as in an embedded system.
>
> The LED subsystem certainly has it uses in embedded, but it's also used
> on PCs - As an example the ath9k wireless driver exports a number of
> LEDs. I find the situation with the wlan LEDs pretty comparable to
> status LEDs on v4l devices.
>
>  >> And yes, application developers must use the correct API to control
>  >> stuff.
>
>  >> Why should kernel duplicate interfaces just because
>  >> user land don't want to use two different interfaces? Doesn't this sound a bit ... strange at least?
>
>  Andy> Why should the kernel push multiple APIs on application developers to
>  Andy> control a complex federation of small devices all connected behind a
>  Andy> single bridge chip, which the user perceives as a single device?  (BTW a
>  Andy> USB microscope is such a federation which doesn't work at all without
>  Andy> proper subject illumination.)
>
> Because that's the only sensible way to create a bunch of incompatible
> custom interfaces  - E.G. a microphone built into a webcam is handled
> through also, not v4l, so it works with any sound recording program.
>
>  Andy> V4L2 controls are how desktop V4L2 applications currently control
>  Andy> aspects of a incoming image.  Forcing the use of the LED interface in
>  Andy> sysfs to control one aspect of that would be a departure from the norm
>  Andy> for the existing V4L2 desktop applications.
>
>  Andy> Forcing the use of the LED interface also brings along the complication
>  Andy> of proper association of the illuminator or LED sysfs control node to
>  Andy> the proper video capture/control device node.  I have a laptop with a
>  Andy> built in webcam with a status LED and a USB connected microscope with
>  Andy> two illuminators.  What are the steps for an application to discover the
>  Andy> correct light for the video device and what settings that light is
>  Andy> capable of: using V4L2 controls? using the LED interface?
>
> Again, for status LEDs I don't see any reason why a standard v4l tool
> would care. As I mentioned above, illuminators are a different story
> (comparable to a gain setting imho).
>
>  Andy> How does one go about associating LEDs and Illuminators to video device
>  Andy> nodes using the LED sysfs interface?  I'm betting it's not as simple for
>  Andy> applications that use V4L2 controls.
>
> I would imagine each video device would have a (number of) triggers,
> similar to how it's done for E.G. the wlan stuff - Something like
> "video0-active". The status LED of the video0 device would default to
> that trigger.
>
>  Andy> I do not see how forcing applications to use a second control
>  Andy> API, with no clear video device node<->led sysfs node association
>  Andy> semantics, reduces application complexity, when those
>  Andy> applications already support the V4L2 control API from which
>  Andy> application can generically discover controls and their metadata
>  Andy> and automatically know the associated video device.
>
> Again, I see the sysfs LED interface for status LEDs as more of a
> user/administrator interface than a programming API.
>
> --
> Bye, Peter Korsgaard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

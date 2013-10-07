Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37816 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752563Ab3JGVG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 17:06:28 -0400
Date: Tue, 8 Oct 2013 00:06:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
	linux-pwm@vger.kernel.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: V2: Agenda for the Edinburgh mini-summit
Message-ID: <20131007210623.GB6732@valkosipuli.retiisi.org.uk>
References: <201309101134.32883.hansverk@cisco.com>
 <52405427.6000002@samsung.com>
 <52406E5C.2020709@schinagl.nl>
 <5240A41A.6050207@gmail.com>
 <20130924092053.GB13971@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924092053.GB13971@ulmo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry and Sylwester,

My apologies for the late answer.

On Tue, Sep 24, 2013 at 11:20:53AM +0200, Thierry Reding wrote:
> On Mon, Sep 23, 2013 at 10:27:06PM +0200, Sylwester Nawrocki wrote:
> > On 09/23/2013 06:37 PM, Oliver Schinagl wrote:
> > >On 09/23/13 16:45, Sylwester Nawrocki wrote:
> > >>Hi,
> > >>
> > >>I would like to have a short discussion on LED flash devices support
> > >>in the kernel. Currently there are two APIs: the V4L2 and LED class
> > >>API exposed by the kernel, which I believe is not good from user space
> > >>POV. Generic applications will need to implement both APIs. I think we
> > >>should decide whether to extend the led class API to add support for
> > >>more advanced LED controllers there or continue to use the both APIs
> > >>with overlapping functionality.
> > >>There has been some discussion about this on the ML, but without any
> > >>consensus reached [1].
> > >
> > >What about the linux-pwm framework and its support for the backlight via
> > >dts?
> > >
> > >Or am I talking way to uninformed here. Copying backlight to flashlight
> > >with some minor modification sounds sensible in a way...
> > 
> > I'd assume we don't need yet another user interface for the LEDs ;) AFAICS
> > the PWM subsystem exposes pretty much raw interface in sysfs. The PWM LED
> > controllers are already handled in the leds-class API, there is the
> > leds_pwm
> > driver (drivers/leds/leds-pwm.c).
> > 
> > I'm adding linux-pwm and linux-leds maintainers at Cc so someone may correct
> > me if I got anything wrong.
> 
> The PWM subsystem is most definitely not a good fit for this. The only
> thing it provides is a way for other drivers to access a PWM device and
> use it for some specific purpose (pwm-backlight, leds-pwm).
> 
> The sysfs support is a convenience for people that needs to use a PWM in
> a way for which no driver framework exists, or for which it doesn't make
> sense to write a driver. Or for testing.
> 
> > Presumably, what we need is a few enhancements to support in a standard way
> > devices like MAX77693, LM3560 or MAX8997.  There is already a led
> > class driver
> > for the MAX8997 LED controller (drivers/leds/leds-max8997.c), but it
> > uses some
> > device-specific sysfs attributes.
> > 
> > Thus similar devices are currently being handled by different subsystems.
> > The split between the V4L2 Flash and the leds class API WRT to Flash LED
> > controller drivers is included in RFC [1], it seems still up to date.
> > 
> > 
> > >>[1] http://www.spinics.net/lists/linux-leds/msg00899.html
> 
> Perhaps it would make sense for V4L2 to be able to use a LED as exposed
> by the LED subsystem and wrap it so that it can be integrated with V4L2?
> If functionality is missing from the LED subsystem I suppose that could
> be added.

The V4L2 flash API supports also xenon flashes, not only LED ones. That
said, I agree there's a common subset of functionality most LED flash
controllers implement.

> If I understand correctly, the V4L2 subsystem uses LEDs as flashes for
> camera devices. I can easily imagine that there are devices out there
> which provide functionality beyond what a regular LED will provide. So
> perhaps for things such as mobile phones, which typically use a plain
> LED to illuminate the surroundings, an LED wrapped into something that
> emulates the flash functionality could work. But I doubt that the LED
> subsystem is a good fit for anything beyond that.

I originally thought one way to do this could be to make it as easy as
possible to support both APIs in driver which some aregued, to which I
agree, is rather poor desing.

Does the LED API have a user space interface library like libv4l2? If yes,
one option oculd be to implement the wrapper between the V4L2 and LED APIs
there so that the applications using the LED API could also access those
devices that implement the V4L2 flash API. Torch mode functionality is
common between the two right now AFAIU,

The V4L2 flash API also provides a way to strobe the flash using an external
trigger which typically connected to the sensor (and the user can choose
between that and software strobe). I guess that and Xenon flashes aren't
currently covered by the LED API.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

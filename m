Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55074 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbbDHKgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 06:36:24 -0400
Date: Wed, 8 Apr 2015 12:36:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, sakari.ailus@iki.fi,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
Message-ID: <20150408103622.GB17245@amd>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <5524FCEF.7060901@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5524FCEF.7060901@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 2015-04-08 12:03:27, Sylwester Nawrocki wrote:
> Hello,
> 
> On 31/03/15 15:52, Jacek Anaszewski wrote:
> > Description of flash LEDs related properties was not precise regarding
> > the state of corresponding settings in case a property is missing.
> > Add relevant statements.
> > Removed is also the requirement making the flash-max-microamp
> > property obligatory for flash LEDs. It was inconsistent as the property
> > is defined as optional. Devices which require the property will have
> > to assert this in their DT bindings.
> > 
> > Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Bryan Wu <cooloney@gmail.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: devicetree@vger.kernel.org
> > ---
> >  Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> > index 747c538..21a25e4 100644
> > --- a/Documentation/devicetree/bindings/leds/common.txt
> > +++ b/Documentation/devicetree/bindings/leds/common.txt
> > @@ -29,13 +29,15 @@ Optional properties for child nodes:
> >       "ide-disk" - LED indicates disk activity
> >       "timer" - LED flashes at a fixed, configurable rate
> >  
> > -- max-microamp : maximum intensity in microamperes of the LED
> > -		 (torch LED for flash devices)
> > -- flash-max-microamp : maximum intensity in microamperes of the
> > -                       flash LED; it is mandatory if the LED should
> > -		       support the flash mode
> > -- flash-timeout-us : timeout in microseconds after which the flash
> > -                     LED is turned off
> > +- max-microamp : Maximum intensity in microamperes of the LED
> > +		 (torch LED for flash devices). If omitted this will default
> > +		 to the maximum current allowed by the device.
> > +- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
> > +		       If omitted this will default to the maximum
> > +		       current allowed by the device.
> > +- flash-timeout-us : Timeout in microseconds after which the flash
> > +                     LED is turned off. If omitted this will default to the
> > +		     maximum timeout allowed by the device.
> 
> Sorry about late comments on that, but since we can still change these
> properties and it seems we're going to do that, I'd like throw in my
> few preferences on the colour of this bike...

Lets not paint bikes here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

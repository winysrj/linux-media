Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:63998 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0IHMOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 08:14:30 -0400
Date: Wed, 8 Sep 2010 15:11:36 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Jarkko Nikula <jhnikula@gmail.com>
Cc: "Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] V4L/DVB: radio-si4713: Add regulator framework
 support
Message-ID: <20100908121136.GI29776@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
 <1276452568-16366-2-git-send-email-jhnikula@gmail.com>
 <20100907194949.GA15216@besouro.research.nokia.com>
 <20100908085938.2d2e5992.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908085938.2d2e5992.jhnikula@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

On Wed, Sep 08, 2010 at 07:59:38AM +0200, Jarkko Nikula wrote:
> Hi
> 
> On Tue, 7 Sep 2010 22:49:49 +0300
> Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
> 
> > Hello Jarkko,
> > 
> > On Sun, Jun 13, 2010 at 08:09:28PM +0200, Jarkko Nikula wrote:
> > > Convert the driver to use regulator framework instead of set_power callback.
> > > This with gpio_reset platform data provide cleaner way to manage chip VIO,
> > > VDD and reset signal inside the driver.
> > > 
> > > Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> > > Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > ---
> > > I don't have specifications for this chip so I don't know how long the
> > > reset signal must be active after power-up. I used 50 us from Maemo
> > > kernel sources for Nokia N900 and I can successfully enable-disable
> > > transmitter on N900 with vdd power cycling.
> > > ---
> > >  drivers/media/radio/radio-si4713.c |   20 ++++++++++++++-
> > >  drivers/media/radio/si4713-i2c.c   |   48 ++++++++++++++++++++++++++++-------
> > >  drivers/media/radio/si4713-i2c.h   |    3 +-
> > >  include/media/si4713.h             |    3 +-
> > 
> > Could you please elaborate a bit more on the fact that you have put vio on
> > the platform driver and vdd on the i2c driver?
> > 
> This is good question and let me explain. The regulator management
> division between these two files were based on my assumption that only
> VIO is needed and must be on before probing the chip on I2C bus.
> 
> Another assumption was that only VDD can realistically be managed
> runtime in si4713_powerup function. I think usually IO voltages cannot
> be shutdown even in suspend while the system is powered so I let the
> driver to keep the VIO enabled as long as the module is loaded.

OK. I kinda agree with you in this reasoning.

My concern here is that splitting the regulator usage into two entities
could cause some troubles.

The background here you are probably missing is that the split between
i2c and platform drivers. That has been done because we were thinking also
in the situation where the si4713 i2c driver could be used without the
platform driver. I mean, the i2c code could be re-used for instance by
other v4l2 driver, if that is driving a device which has also si4713.
So, in this sense, the current platform is essentially a wrapper.
And if you split the regulator usage in that way,
we would probably be loosing that.

And apart from that, it is also bad from the regfw point of view as well.
I believe the idea is that the driver itself must take care of all needed
regulators. The way you have done, looks like the platform driver needs only
VIO and the i2c needs only VDD. And to my understanding, the i2c needs both
in order to work. So, my suggestion is to move everything to the i2c driver.

> 
> 
> -- 
> Jarkko

---
Eduardo Valentin

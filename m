Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50756 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab0IHF65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 01:58:57 -0400
Received: by eyb6 with SMTP id 6so2817945eyb.19
        for <linux-media@vger.kernel.org>; Tue, 07 Sep 2010 22:58:56 -0700 (PDT)
Date: Wed, 8 Sep 2010 08:59:38 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: eduardo.valentin@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] V4L/DVB: radio-si4713: Add regulator framework
 support
Message-Id: <20100908085938.2d2e5992.jhnikula@gmail.com>
In-Reply-To: <20100907194949.GA15216@besouro.research.nokia.com>
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
	<1276452568-16366-2-git-send-email-jhnikula@gmail.com>
	<20100907194949.GA15216@besouro.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi

On Tue, 7 Sep 2010 22:49:49 +0300
Eduardo Valentin <eduardo.valentin@nokia.com> wrote:

> Hello Jarkko,
> 
> On Sun, Jun 13, 2010 at 08:09:28PM +0200, Jarkko Nikula wrote:
> > Convert the driver to use regulator framework instead of set_power callback.
> > This with gpio_reset platform data provide cleaner way to manage chip VIO,
> > VDD and reset signal inside the driver.
> > 
> > Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> > Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> > I don't have specifications for this chip so I don't know how long the
> > reset signal must be active after power-up. I used 50 us from Maemo
> > kernel sources for Nokia N900 and I can successfully enable-disable
> > transmitter on N900 with vdd power cycling.
> > ---
> >  drivers/media/radio/radio-si4713.c |   20 ++++++++++++++-
> >  drivers/media/radio/si4713-i2c.c   |   48 ++++++++++++++++++++++++++++-------
> >  drivers/media/radio/si4713-i2c.h   |    3 +-
> >  include/media/si4713.h             |    3 +-
> 
> Could you please elaborate a bit more on the fact that you have put vio on
> the platform driver and vdd on the i2c driver?
> 
This is good question and let me explain. The regulator management
division between these two files were based on my assumption that only
VIO is needed and must be on before probing the chip on I2C bus.

Another assumption was that only VDD can realistically be managed
runtime in si4713_powerup function. I think usually IO voltages cannot
be shutdown even in suspend while the system is powered so I let the
driver to keep the VIO enabled as long as the module is loaded.


-- 
Jarkko

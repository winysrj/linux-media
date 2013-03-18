Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3CRL24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 07:28:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Mon, 18 Mar 2013 11:28:45 +0000
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <201303181058.51641.arnd@arndb.de> <CAHkwnC-aHwd24S5MyLhnVzTqqQj2L7MMuVX9dirhS-G830jZcw@mail.gmail.com>
In-Reply-To: <CAHkwnC-aHwd24S5MyLhnVzTqqQj2L7MMuVX9dirhS-G830jZcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181128.45215.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 18 March 2013, Fabio Porcedda wrote:
> 
> On Mon, Mar 18, 2013 at 11:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 18 March 2013, Fabio Porcedda wrote:
> >> Since by using platform_driver_probe() the  function
> >> ep93xx_pwm_probe() is freed after initialization,
> >> is better to use module_platform_drive_probe().
> >> IMHO i don't see any good reason to use module_platform_driver() for
> >> this driver.
> >
> > As I commented earlier, the platform_driver_probe() and
> > module_platform_drive_probe() interfaces are rather dangerous in combination
> > with deferred probing, I would much prefer Harley's patch.
> 
> Since those drivers don't use -EPROBE_DEFER i was thinking that they don't use
> deferred probing.
> I'm missing something?

clk_get() may return -EPROBE_DEFER after ep93xx is converted to use the
common clk API. We currently return the value of clk_get from the probe()
function, which will automatically do the right thing as long as the probe
function remains reachable.

	Arnd

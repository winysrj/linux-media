Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3CRK76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 06:59:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Mon, 18 Mar 2013 10:58:51 +0000
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
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <201303152018.09094.arnd@arndb.de> <CAHkwnC9YFTw8gVzyZB3_gZCgM5zMA6tLch15EDqcA2F4CAOpAQ@mail.gmail.com>
In-Reply-To: <CAHkwnC9YFTw8gVzyZB3_gZCgM5zMA6tLch15EDqcA2F4CAOpAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181058.51641.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 18 March 2013, Fabio Porcedda wrote:
> Since by using platform_driver_probe() the  function
> ep93xx_pwm_probe() is freed after initialization,
> is better to use module_platform_drive_probe().
> IMHO i don't see any good reason to use module_platform_driver() for
> this driver.

As I commented earlier, the platform_driver_probe() and
module_platform_drive_probe() interfaces are rather dangerous in combination
with deferred probing, I would much prefer Harley's patch.

	Arnd

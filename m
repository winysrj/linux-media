Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab3COUTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 16:19:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Fri, 15 Mar 2013 20:18:08 +0000
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
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
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <201303141358.05616.arnd@arndb.de> <ADE657CA350FB648AAC2C43247A983F0020980106B9E@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020980106B9E@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303152018.09094.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 March 2013, H Hartley Sweeten wrote:
> Arnd,
> 
> Ill look at converting the ep93xx pwm driver to the PWM subsystem. The only issue is
> the current driver exposes a sysfs interface that I think is not available in that subsystem.

You can probably keep providing that interface if you have active users.

> >* Regarding the use of module_platform_driver_probe, I'm a little worried about
> >  the interactions with deferred probing. I don't think there are any regressions,
> >  but we should probably make people aware that one cannot return -EPROBE_DEFER
> >  from a platform_driver_probe function.
> 
> The ep93xx pwm driver does not need to use platform_driver_probe(). It can be changed
> to use module_platform_driver() by just moving the .probe to the platform_driver. This
> driver was added before module_platform_driver() was available and I used the
> platform_driver_probe() thinking it would save a couple lines of code.
> 
> I'll change this in a bit. Right now I'm trying to work out why kernel 3.8 is not booting
> on the ep93xx. I had 3.6.6 on my development board and 3.7 works fine but 3.8 hangs
> without uncompressing the kernel.

Ok, thanks!

	Arnd

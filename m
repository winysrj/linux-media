Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3COL3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 07:29:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Fri, 15 Mar 2013 11:28:48 +0000
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	"linux-media" <linux-media@vger.kernel.org>,
	"linux-ide" <linux-ide@vger.kernel.org>,
	"lm-sensors" <lm-sensors@lm-sensors.org>,
	"linux-input" <linux-input@vger.kernel.org>,
	"linux-fbdev" <linux-fbdev@vger.kernel.org>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	"Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <20130314140631.GM1906@pengutronix.de> <CAHkwnC9nGsdgOTQZ6VpeDyPWXw7tpP+2oHvnLv6LEr1cNdnrsg@mail.gmail.com>
In-Reply-To: <CAHkwnC9nGsdgOTQZ6VpeDyPWXw7tpP+2oHvnLv6LEr1cNdnrsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151128.48432.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 March 2013, Fabio Porcedda wrote:
> >> * Regarding the use of module_platform_driver_probe, I'm a little worried about
> >>   the interactions with deferred probing. I don't think there are any regressions,
> >>   but we should probably make people aware that one cannot return -EPROBE_DEFER
> >>   from a platform_driver_probe function.
> 
> The use of module_platform_driver_probe() doesn't change anything about that,
> it's exactly the same thing as using "return platform_driver_probe()".
> I'm right or I'm missing something? Maybe are you just speaking about
> the misuse of "platform_driver_probe"?

Yes, that was what I meant. The point is that if we need to review or remove
all uses of platform_driver_probe, it would be better not to introduce a
module_platform_driver_probe() interface to make it easier to use.

	Arnd

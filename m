Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53837 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CNN60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 09:58:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 13:58:05 +0000
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
	lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"H Hartley Sweeten" <hsweeten@visionengravers.com>,
	"Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <1363266691-15757-12-git-send-email-fabio.porcedda@gmail.com>
In-Reply-To: <1363266691-15757-12-git-send-email-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303141358.05616.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 14 March 2013, Fabio Porcedda wrote:
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/misc/atmel_pwm.c  | 12 +-----------
>  drivers/misc/ep93xx_pwm.c | 13 +------------
>  2 files changed, 2 insertions(+), 23 deletions(-)

The patch itself seems fine, but there are two issues around it:

* The PWM drivers should really get moved to drivers/pwm and converted to the new
  PWM subsystem. I don't know if Hartley or Hans-Christian have plans to do
  that already.

* Regarding the use of module_platform_driver_probe, I'm a little worried about
  the interactions with deferred probing. I don't think there are any regressions,
  but we should probably make people aware that one cannot return -EPROBE_DEFER
  from a platform_driver_probe function.

	Arnd

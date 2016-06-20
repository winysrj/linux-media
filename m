Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbcFUDTi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 23:19:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Andrew F. Davis" <afd@ti.com>,
	Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-leds@vger.kernel.org, lguest@lists.ozlabs.org,
	linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Andrew F . Davis" <afd@ti.com>
Subject: Re: [PATCH 10/12] lguest: Only descend into lguest directory when CONFIG_LGUEST is set
In-Reply-To: <20160613200211.14790-11-afd@ti.com>
References: <20160613200211.14790-1-afd@ti.com> <20160613200211.14790-11-afd@ti.com>
Date: Tue, 21 Jun 2016 06:14:30 +0930
Message-ID: <87a8iflhe9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Andrew F. Davis" <afd@ti.com> writes:
> When CONFIG_LGUEST is not set make will still descend into the lguest
> directory but nothing will be built. This produces unneeded build
> artifacts and messages in addition to slowing the build. Fix this here.
>
> Signed-off-by: Andrew F. Davis <afd@ti.com>
> ---
>  drivers/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied,

Thanks!
Rusty.

>
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 19305e0..b178e2f 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -122,7 +122,7 @@ obj-$(CONFIG_ACCESSIBILITY)	+= accessibility/
>  obj-$(CONFIG_ISDN)		+= isdn/
>  obj-$(CONFIG_EDAC)		+= edac/
>  obj-$(CONFIG_EISA)		+= eisa/
> -obj-y				+= lguest/
> +obj-$(CONFIG_LGUEST)		+= lguest/
>  obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
>  obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
>  obj-y				+= mmc/
> -- 
> 2.8.3

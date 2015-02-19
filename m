Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:55331 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbBSOxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 09:53:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] [kbuild] Add and use IS_REACHABLE macro
Date: Thu, 19 Feb 2015 15:53:07 +0100
Message-ID: <14254005.QkaJhTuY5H@wuerfel>
In-Reply-To: <20150219121107.GA19684@sepie.suse.cz>
References: <6116702.rrbrOqQ26P@wuerfel> <20150219121107.GA19684@sepie.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 19 February 2015 13:11:07 Michal Marek wrote:
> On 2015-02-18 18:12, Arnd Bergmann wrote:
> > In the media drivers, the v4l2 core knows about all submodules
> > and calls into them from a common function. However this cannot
> > work if the modules that get called are loadable and the
> > core is built-in. In that case we get
> > 
> > drivers/built-in.o: In function `set_type':
> > drivers/media/v4l2-core/tuner-core.c:301: undefined reference to `tea5767_attach'
> > drivers/media/v4l2-core/tuner-core.c:307: undefined reference to `tea5761_attach'
> > drivers/media/v4l2-core/tuner-core.c:349: undefined reference to `tda9887_attach'
> > drivers/media/v4l2-core/tuner-core.c:405: undefined reference to `xc4000_attach'
> > [...]
> > Ideally Kconfig would be used to avoid the case of a broken dependency,
> > or the code restructured in a way to turn around the dependency, but either
> > way would require much larger changes here.
> 
> What can be done without extending kbuild is to accept
> CONFIG_VIDEO_TUNER=y and CONFIG_MEDIA_TUNER_FOO=m, but build both into
> the kernel, e.g.

Right, but

> diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
> index 42e5a01..d2c7e89 100644
> --- a/drivers/media/tuners/Kconfig
> +++ b/drivers/media/tuners/Kconfig
> @@ -71,6 +71,11 @@ config MEDIA_TUNER_TEA5767
>         help
>           Say Y here to include support for the Philips TEA5767 radio tuner.
>  
> +config MEDIA_TUNER_TEA5767_BUILD
> +       tristate
> +       default VIDEO_TUNER || MEDIA_TUNER_TEA5767
> +       depends on MEDIA_TUNER_TEA5767!=n
> +
>  config MEDIA_TUNER_MSI001
>         tristate "Mirics MSi001"
>         depends on MEDIA_SUPPORT && SPI && VIDEO_V4L2

We'd then have to do the same for each tuner driver that we have in the
kernel or that gets added later. My patch was intended to just restore
the previous behavior that was accidentally changed as part of a misguided
cleanup.

> Actually, I have hard time coming up with a kconfig syntactic sugar to
> express such dependency. If I understand it correctly, the valid
> configurations in this case are
> 
> MEDIA_TUNER_TEA5767     n       m       y
> VIDEO_TUNER     n       x       x       x
>                 m       x       x       x
>                 y       x               x
> 
> I.e. only VIDEO_TUNER=y and MEDIA_TUNER_TEA5767=m is incorrect, isn't
> it?

Yes, I think that is correct. We have similar problems in other areas
of the kernel. In theory, we could enforce the VIDEO_TUNER driver to
be modular here by adding lots of dependencies to it:

config VIDEO_TUNER
	tristate
	depends on MEDIA_TUNER_TEA5761 || !MEDIA_TUNER_TEA5761
	depends on MEDIA_TUNER_TEA5767 || !MEDIA_TUNER_TEA5767
	depends on MEDIA_TUNER_MSI001  || !MEDIA_TUNER_MSI001

but that would also soon get out of hand, and we probably need another
indirection here too, for each symbol that selects VIDEO_TUNER.

	Arnd

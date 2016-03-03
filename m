Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53301 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbcCCNAW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 08:00:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	David Brown <david.brown@linaro.org>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Lee Jones <lee.jones@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	driverdevel <devel@driverdev.osuosl.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Andy Gross <andy.gross@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jason Cooper <jason@lakedaemon.net>,
	RTCLINUX <rtc-linux@googlegroups.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Marc Zyngier <marc.zyngier@arm.com>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-soc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux PM list <linux-pm@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	dmaengine@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC 08/15] rtc: at91sam9: Add missing MFD_SYSCON dependency on HAS_IOMEM
Date: Thu, 03 Mar 2016 13:58:33 +0100
Message-ID: <4070388.ZbRf8kMntA@wuerfel>
In-Reply-To: <CAMuHMdXUdz0=n2+Aa74f1LtwiwfV9=gkPBiJKC_DMyr1_jBe7Q@mail.gmail.com>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com> <2233190.1BxevBAvDE@wuerfel> <CAMuHMdXUdz0=n2+Aa74f1LtwiwfV9=gkPBiJKC_DMyr1_jBe7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 March 2016 13:27:59 Geert Uytterhoeven wrote:
> On Thu, Mar 3, 2016 at 11:55 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 03 March 2016 17:03:34 Krzysztof Kozlowski wrote:
> >> index 0da40e2e4280..5c530b6b125d 100644
> >> --- a/drivers/rtc/Kconfig
> >> +++ b/drivers/rtc/Kconfig
> >> @@ -1302,6 +1302,7 @@ config RTC_DRV_AT91RM9200
> >>  config RTC_DRV_AT91SAM9
> >>         tristate "AT91SAM9 RTT as RTC"
> >>         depends on ARCH_AT91 || COMPILE_TEST
> >> +       depends on HAS_IOMEM    # For MFD_SYSCON
> >>         select MFD_SYSCON
> >>         help
> >>           Some AT91SAM9 SoCs provide an RTT (Real Time Timer) block which
> >>
> >
> > This is technically correct, but the entire RTC menu is hidden
> > inside of 'depends on !UML && !S390', so we won't ever get there
> > on any configuration that does not use HAS_IOMEM.
> >
> > If we did, all other RTC drivers would also fail.
> 
> So UML has no RTC. Should/can it use RTC_DRV_GENERIC?

I think nothing should use that, even if it could ;-)

Funny enough, RTC_DRV_GENERIC would probably actually work if you
run UML as root and set iopl() to allow port access, but we don't
really want it to mess with the host RTC.

I don't know where UML gets it real time, but it doesn't actually
need much other than calling clock_gettime(CLOCK_REALTIME, ...)
to get the host time. Presumably it uses some variation of that.

	Arnd

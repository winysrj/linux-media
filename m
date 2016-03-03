Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34637 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbcCCMfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 07:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20160303123343.GB5687@earth>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com>
	<1456992221-26712-12-git-send-email-k.kozlowski@samsung.com>
	<5230562.E0gg2SNP0m@wuerfel>
	<20160303123343.GB5687@earth>
Date: Thu, 3 Mar 2016 21:35:17 +0900
Message-ID: <CAJKOXPdp=n43=foh2y-zNUnuVOmk0qK8AxjriO5Hnq-ANgpM8w@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [RFC 11/15] power: reset: keystone: Add missing
 MFD_SYSCON dependency on HAS_IOMEM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: rtc-linux@googlegroups.com
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Marc Zyngier <marc.zyngier@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andy Gross <andy.gross@linaro.org>,
	David Brown <david.brown@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-media@vger.kernel.org, linux-samsun@comu.ring0.de,
	g-soc@vger.kernel.org, netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-03-03 21:33 GMT+09:00 Sebastian Reichel <sre@kernel.org>:
> Hi,
>
> On Thu, Mar 03, 2016 at 12:00:14PM +0100, Arnd Bergmann wrote:
>> On Thursday 03 March 2016 17:03:37 Krzysztof Kozlowski wrote:
>> > diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
>> > index 0a6408a39c66..0f34846ae80d 100644
>> > --- a/drivers/power/reset/Kconfig
>> > +++ b/drivers/power/reset/Kconfig
>> > @@ -141,6 +141,7 @@ config POWER_RESET_XGENE
>> >  config POWER_RESET_KEYSTONE
>> >         bool "Keystone reset driver"
>> >         depends on ARCH_KEYSTONE
>> > +       depends on HAS_IOMEM    # For MFD_SYSCON
>> >         select MFD_SYSCON
>> >         help
>> >           Reboot support for the KEYSTONE SoCs.
>> >
>>
>> This is platform specific, but we should probably add || COMPILE_TEST
>> along with the HAS_IOMEM dependency.
>
> Sounds sensible. Will you guys send an updated patch?
>

Sure, I'll make some compile tests and send a v2.

Best regards,
Krzysztof

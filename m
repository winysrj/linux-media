Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:56075 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcCCNHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 08:07:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	rtc-linux@googlegroups.com,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	David Brown <david.brown@linaro.org>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski.k@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org,
	Vinod Koul <vinod.koul@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Andy Gross <andy.gross@linaro.org>,
	linux-media@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Marc Zyngier <marc.zyngier@arm.com>,
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-soc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-pm@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	netdev@vger.kernel.org, dmaengine@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [rtc-linux] Re: [RFC 09/15] media: platform: Add missing MFD_SYSCON dependency on HAS_IOMEM
Date: Thu, 03 Mar 2016 14:05:33 +0100
Message-ID: <13054519.5feSCc5dgv@wuerfel>
In-Reply-To: <CAJKOXPe50ira_Qqy7qJ5H_PHa8B_xOinCK6JkncXFYn_eaQFfg@mail.gmail.com>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com> <2181866.k24LVvUjTs@wuerfel> <CAJKOXPe50ira_Qqy7qJ5H_PHa8B_xOinCK6JkncXFYn_eaQFfg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 March 2016 21:40:23 Krzysztof Kozlowski wrote:
> >>         select MFD_SYSCON
> >> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
> >> index 57d42c6172c5..c4317b99d257 100644
> >> --- a/drivers/media/platform/exynos4-is/Kconfig
> >> +++ b/drivers/media/platform/exynos4-is/Kconfig
> >> @@ -17,6 +17,7 @@ config VIDEO_S5P_FIMC
> >>         tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
> >>         depends on I2C
> >>         depends on HAS_DMA
> >> +       depends on HAS_IOMEM    # For MFD_SYSCON
> >>         select VIDEOBUF2_DMA_CONTIG
> >>         select V4L2_MEM2MEM_DEV
> >
> > This  is guarded by HAS_DMA, which implies HAS_IOMEM afaik.
> 
> Looking at Kconfigs - no, it is not implied (or am I missing
> something)... and sometimes dependency on HAS_IOMEM is next to
> HAS_DMA.
> 
> 

Ah, you are right: UML has no DMA and no IOMEM, but s390 can
have IOMEM (if PCI is enabled) and always sets HAS_DMA.

In practice, I think the HAS_DMA symbol is not as well-defined
as it should be, it basically refers to the presence of the dma-mapping.h
API, and that only really makes sense when you also have IOMEM,
so there might be an implied dependency between the two, but it's
not enforced or actually true.

	Arnd

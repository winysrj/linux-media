Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:34131 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbcCCMkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 07:40:25 -0500
MIME-Version: 1.0
In-Reply-To: <2181866.k24LVvUjTs@wuerfel>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com>
	<1456992221-26712-10-git-send-email-k.kozlowski@samsung.com>
	<2181866.k24LVvUjTs@wuerfel>
Date: Thu, 3 Mar 2016 21:40:23 +0900
Message-ID: <CAJKOXPe50ira_Qqy7qJ5H_PHa8B_xOinCK6JkncXFYn_eaQFfg@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [RFC 09/15] media: platform: Add missing
 MFD_SYSCON dependency on HAS_IOMEM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: rtc-linux@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org,
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
	Sebastian Reichel <sre@kernel.org>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andy Gross <andy.gross@linaro.org>,
	David Brown <david.brown@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-03-03 19:57 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 03 March 2016 17:03:35 Krzysztof Kozlowski wrote:
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 201f5c296a95..e5931e434fa2 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -79,6 +79,7 @@ config VIDEO_OMAP3
>>         depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
>>         depends on HAS_DMA && OF
>>         depends on OMAP_IOMMU
>> +       depends on HAS_IOMEM    # For MFD_SYSCON
>>         select ARM_DMA_USE_IOMMU
>>         select VIDEOBUF2_DMA_CONTIG
>
> This is only built for OMAP3, so we won't get here without HAS_IOMEM

Indeed.

>
>>         select MFD_SYSCON
>> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
>> index 57d42c6172c5..c4317b99d257 100644
>> --- a/drivers/media/platform/exynos4-is/Kconfig
>> +++ b/drivers/media/platform/exynos4-is/Kconfig
>> @@ -17,6 +17,7 @@ config VIDEO_S5P_FIMC
>>         tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
>>         depends on I2C
>>         depends on HAS_DMA
>> +       depends on HAS_IOMEM    # For MFD_SYSCON
>>         select VIDEOBUF2_DMA_CONTIG
>>         select V4L2_MEM2MEM_DEV
>
> This  is guarded by HAS_DMA, which implies HAS_IOMEM afaik.

Looking at Kconfigs - no, it is not implied (or am I missing
something)... and sometimes dependency on HAS_IOMEM is next to
HAS_DMA.

BR,
Krzysztof

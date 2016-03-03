Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:54340 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbcCCKyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 05:54:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
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
	linux-pm@vger.kernel.org, rtc-linux@googlegroups.com,
	linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [RFC 03/15] hwspinlock: qcom: Add missing MFD_SYSCON dependency on HAS_IOMEM
Date: Thu, 03 Mar 2016 11:53:23 +0100
Message-ID: <1850954.4r0iTkATb8@wuerfel>
In-Reply-To: <1456992221-26712-4-git-send-email-k.kozlowski@samsung.com>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com> <1456992221-26712-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 March 2016 17:03:29 Krzysztof Kozlowski wrote:
> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> index 73a401662853..5ab2d51dc147 100644
> --- a/drivers/hwspinlock/Kconfig
> +++ b/drivers/hwspinlock/Kconfig
> @@ -21,6 +21,7 @@ config HWSPINLOCK_OMAP
>  config HWSPINLOCK_QCOM
>         tristate "Qualcomm Hardware Spinlock device"
>         depends on ARCH_QCOM
> +       depends on HAS_IOMEM    # For MFD_SYSCON
>         select HWSPINLOCK
>         select MFD_SYSCON
>         help
> 

This is only needed if we add "|| COMPILE_TEST", right now the driver
is limited to ARCH_QCOM.

	Arnd

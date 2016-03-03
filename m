Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55598 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbcCCIGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 03:06:19 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
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
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
	rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
	linux-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 15/15] mfd: syscon: Fix build of missing ioremap on UM
Date: Thu, 03 Mar 2016 17:03:41 +0900
Message-id: <1456992221-26712-16-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com>
References: <1456992221-26712-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit c89c0114955a ("mfd: syscon: Set regmap max_register in
of_syscon_register") the syscon uses ioremap so it fails on COMPILE_TEST
without HAS_IOMEM:

drivers/mfd/syscon.c: In function ‘of_syscon_register’:
drivers/mfd/syscon.c:67:9: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
  base = ioremap(res.start, resource_size(&res));
         ^
drivers/mfd/syscon.c:67:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  base = ioremap(res.start, resource_size(&res));
       ^
drivers/mfd/syscon.c:109:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
  iounmap(base);

When selecting MFD_SYSCON, depend on HAS_IOMEM to avoid unmet direct
dependencies.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: c89c0114955a ("mfd: syscon: Set regmap max_register in of_syscon_register")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index aa21dc55eb15..2e5b1e525a1d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1034,6 +1034,7 @@ config MFD_SUN6I_PRCM
 
 config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
+	depends on HAS_IOMEM
 	select REGMAP_MMIO
 	help
 	  Select this option to enable accessing system control registers
-- 
2.5.0


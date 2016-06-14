Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:51706 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbcFNQNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 12:13:53 -0400
Subject: [PATCH] hsi: Build hsi_boardinfo.c into hsi core if enabled
To: kbuild test robot <lkp@intel.com>
References: <201606140808.bRJtAy1i%fengguang.wu@intel.com>
CC: <kbuild-all@01.org>, Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>, <linux-pwm@vger.kernel.org>,
	<lguest@lists.ozlabs.org>, <linux-wireless@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-leds@vger.kernel.org>,
	<linux-media@vger.kernel.org>
From: "Andrew F. Davis" <afd@ti.com>
Message-ID: <57602D10.4080708@ti.com>
Date: Tue, 14 Jun 2016 11:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <201606140808.bRJtAy1i%fengguang.wu@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the HSI core is built as a module hsi_boardinfo may still
be built-in as its Kconfig type is bool, which can cause build
issues. Fix this by building this code into the HSI core when
enabled.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew F. Davis <afd@ti.com>
---
This build error seems to be due to Kconfig symbol CONFIG_HSI_BOARDINFO
being a bool but depending on a tristate (CONFIG_HSI). This is normally
okay when it is just a flag to enable a feature in source, but the
helper code file hsi_boardinfo.c is built as a separate entity when
enabled. This patch is probably how it was intended, and is more like
how others do this kind of thing.

This patch should be applied before the parent patch:

 drivers/hsi/Makefile              | 3 ++-
 drivers/hsi/{hsi.c => hsi_core.c} | 0
 2 files changed, 2 insertions(+), 1 deletion(-)
 rename drivers/hsi/{hsi.c => hsi_core.c} (100%)

diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
index 360371e..9694478 100644
--- a/drivers/hsi/Makefile
+++ b/drivers/hsi/Makefile
@@ -1,7 +1,8 @@
 #
 # Makefile for HSI
 #
-obj-$(CONFIG_HSI_BOARDINFO)    += hsi_boardinfo.o
 obj-$(CONFIG_HSI)              += hsi.o
+hsi-objs                       := hsi_core.o
+hsi-$(CONFIG_HSI_BOARDINFO)    += hsi_boardinfo.o
 obj-y                          += controllers/
 obj-y                          += clients/
diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi_core.c
similarity index 100%
rename from drivers/hsi/hsi.c
rename to drivers/hsi/hsi_core.c
-- 
2.8.3

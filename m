Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33760 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbbDCRMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:12:43 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 03/14] clkdev: get rid of redundant clk_add_alias() prototype
 in linux/clk.h
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:12:37 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_add_alias() is provided by clkdev, and is not part of the clk API.
Howver, it is prototyped in two locations: linux/clkdev.h and
linux/clk.h.  This is a mess.  Get rid of the redundant and unnecessary
version in linux/clk.h.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-davinci/da850.c        |  1 +
 arch/arm/mach-omap1/board-nokia770.c |  2 +-
 arch/arm/mach-pxa/eseries.c          |  1 +
 arch/arm/mach-pxa/lubbock.c          |  1 +
 arch/arm/mach-pxa/tosa.c             |  1 +
 include/linux/clk.h                  | 13 -------------
 6 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 45ce065e7170..3b8740c083c4 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -11,6 +11,7 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
+#include <linux/clkdev.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/clk.h>
diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 85089d821982..3bc59390a943 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -7,6 +7,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/clkdev.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/kernel.h>
@@ -14,7 +15,6 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-#include <linux/clk.h>
 #include <linux/omapfb.h>
 
 #include <linux/spi/spi.h>
diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
index cfb864173ce3..4427bf26ea47 100644
--- a/arch/arm/mach-pxa/eseries.c
+++ b/arch/arm/mach-pxa/eseries.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/clkdev.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index d8a1be619f21..235f2d9318c1 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -11,6 +11,7 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
+#include <linux/clkdev.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 7780d1faa06f..92e56d8a24d8 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/clkdev.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff --git a/include/linux/clk.h b/include/linux/clk.h
index d1ac9f3ab24b..c94a34a8a1b3 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -467,19 +467,6 @@ static inline void clk_disable_unprepare(struct clk *clk)
 	clk_unprepare(clk);
 }
 
-/**
- * clk_add_alias - add a new clock alias
- * @alias: name for clock alias
- * @alias_dev_name: device name
- * @id: platform specific clock name
- * @dev: device
- *
- * Allows using generic clock names for drivers by adding a new alias.
- * Assumes clkdev, see clkdev.h for more info.
- */
-int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
-			struct device *dev);
-
 struct device_node;
 struct of_phandle_args;
 
-- 
1.8.3.1


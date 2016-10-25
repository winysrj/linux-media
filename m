Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33593 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbcJYXzk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 19:55:40 -0400
Received: by mail-pf0-f172.google.com with SMTP id 197so3669360pfu.0
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 16:55:40 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 2/6] ARM: davinci: da8xx: VPIF: enable DT init
Date: Tue, 25 Oct 2016 16:55:32 -0700
Message-Id: <20161025235536.7342-3-khilman@baylibre.com>
In-Reply-To: <20161025235536.7342-1-khilman@baylibre.com>
References: <20161025235536.7342-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic support for DT initializaion of VPIF (capture) via DT.  Clocks
and mux still need to happen in this file until there are real clock and
pinctrl drivers, but the video nodes and subdevs can all come from DT.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 arch/arm/mach-davinci/da8xx-dt.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index c9f7e9274aa8..e1b7d72f9070 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -17,6 +17,7 @@
 #include <mach/common.h>
 #include "cp_intc.h"
 #include <mach/da8xx.h>
+#include <mach/mux.h>
 
 static struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
@@ -38,14 +39,30 @@ static struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 		       NULL),
 	OF_DEV_AUXDATA("ti,da830-mcasp-audio", 0x01d00000, "davinci-mcasp.0", NULL),
 	OF_DEV_AUXDATA("ti,da850-aemif", 0x68000000, "ti-aemif", NULL),
+	OF_DEV_AUXDATA("ti,vpif", 0x01e17000, "vpif", NULL),
 	{}
 };
 
 #ifdef CONFIG_ARCH_DAVINCI_DA850
 
+#if IS_ENABLED(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE)
+static __init void da850_vpif_capture_init(void)
+{
+	int ret;
+	
+	ret = davinci_cfg_reg_list(da850_vpif_capture_pins);
+	if (ret)
+		pr_warn("da850_evm_init: VPIF capture mux setup failed: %d\n",
+			ret);
+}
+#else
+#define da850_vpif_capture_init()
+#endif
+
 static void __init da850_init_machine(void)
 {
 	of_platform_default_populate(NULL, da850_auxdata_lookup, NULL);
+	da850_vpif_capture_init();
 }
 
 static const char *const da850_boards_compat[] __initconst = {
-- 
2.9.3


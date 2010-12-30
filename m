Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42776 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0L3KsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 05:48:25 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC V8 7/7] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver.
Date: Thu, 30 Dec 2010 06:11:47 -0500
Message-Id: <1293707507-3376-8-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1293707507-3376-7-git-send-email-manjunatha_halli@ti.com>
References: <1293707507-3376-1-git-send-email-manjunatha_halli@ti.com>
 <1293707507-3376-2-git-send-email-manjunatha_halli@ti.com>
 <1293707507-3376-3-git-send-email-manjunatha_halli@ti.com>
 <1293707507-3376-4-git-send-email-manjunatha_halli@ti.com>
 <1293707507-3376-5-git-send-email-manjunatha_halli@ti.com>
 <1293707507-3376-6-git-send-email-manjunatha_halli@ti.com>
 <1293707507-3376-7-git-send-email-manjunatha_halli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Manjunatha Halli <manjunatha_halli@ti.com>

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/media/radio/Kconfig  |    3 +++
 drivers/media/radio/Makefile |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..4529bc7 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -452,4 +452,7 @@ config RADIO_TIMBERDALE
 	  found behind the Timberdale FPGA on the Russellville board.
 	  Enabling this driver will automatically select the DSP and tuner.
 
+# TI's ST based wl128x FM radio
+source "drivers/media/radio/wl128x/Kconfig"
+
 endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index f615583..b71f448 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
 obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
 obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
+obj-$(CONFIG_RADIO_WL128X) += wl128x/
 
 EXTRA_CFLAGS += -Isound
-- 
1.5.6.3


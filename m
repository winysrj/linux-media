Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44905 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2IOQeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 12:34:12 -0400
Received: by wgbdr13 with SMTP id dr13so4431456wgb.1
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 09:34:11 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, shaik.ameer@samsung.com,
	sungchun.kang@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] exynos-gsc: Add missing Makefile
Date: Sat, 15 Sep 2012 18:33:47 +0200
Message-Id: <1347726827-23335-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <20120915123500.41e1ae03@redhat.com>
References: <20120915123500.41e1ae03@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing Makefile that got lost while rebasing commit 655ceff16b45c847
"[media] gscaler: Add Makefile for G-Scaler Driver" onto latest source tree.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---

Mauro, my apologies for this omission. I somehow missed to add
the Makefile while rebasing on latest media tree. This patch
fixes the compilation. Please revert  commit
"[PATCH] [media] gscaler: mark it as BROKEN" if it's merged already.

Regards,
Sylwester

 drivers/media/platform/exynos-gsc/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/exynos-gsc/Makefile

diff --git a/drivers/media/platform/exynos-gsc/Makefile b/drivers/media/platform/exynos-gsc/Makefile
new file mode 100644
index 0000000..6d1411c
--- /dev/null
+++ b/drivers/media/platform/exynos-gsc/Makefile
@@ -0,0 +1,3 @@
+exynos-gsc-objs := gsc-core.o gsc-m2m.o gsc-regs.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc.o
--
1.7.4.1


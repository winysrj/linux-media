Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57423 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab0FPKMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:12:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/7] ARM: S5PV210: Add fifo link definitions for fimc and
 framebuffer
In-reply-to: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	kgene.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1276683123-30224-6-git-send-email-s.nawrocki@samsung.com>
References: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Add definition of local paths that are available on Sasmung S5PV210
SoCs.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 arch/arm/mach-s5pv210/setup-fimc0.c       |   23 +++++++++++++++++++++++
 arch/arm/mach-s5pv210/setup-fimc1.c       |   23 +++++++++++++++++++++++
 arch/arm/mach-s5pv210/setup-fimc2.c       |   23 +++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/fimc.h |    4 ++++
 4 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/setup-fimc0.c b/arch/arm/mach-s5pv210/setup-fimc0.c
index 94205f5..fab6e52 100644
--- a/arch/arm/mach-s5pv210/setup-fimc0.c
+++ b/arch/arm/mach-s5pv210/setup-fimc0.c
@@ -10,6 +10,10 @@
  */
 
 #include <plat/fimc.h>
+#include <plat/fifo.h>
+#include <linux/fb.h>
+#include <plat/fb.h>
+#include <plat/devs.h>
 
 struct samsung_plat_fimc s5p_fimc0_default_data __initdata = {
 	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
@@ -23,3 +27,22 @@ struct samsung_plat_fimc s5p_fimc0_default_data __initdata = {
 	.out_rot_en_w	= 1920,
 	.out_rot_dis_w	= 4224
 };
+
+static struct s3c_fifo_link s5pv210_fimc0_win0_link = {
+	.master_dev	= &s5p_device_fimc0.dev,
+	.slave_dev	= &s3c_device_fb.dev,
+};
+
+void __init s5pv210_setup_fimc0_fb_link(void)
+{
+	struct s3c_fb_platdata *fb_pd;
+	struct samsung_plat_fimc *fimc_pd;
+
+	fimc_pd = s5p_device_fimc0.dev.platform_data;
+	fb_pd = s3c_device_fb.dev.platform_data;
+
+	if (fimc_pd && fb_pd && fb_pd->win[0]) {
+		fb_pd->win[0]->fifo_sources[0] = &s5pv210_fimc0_win0_link;
+		fimc_pd->fifo_targets[0] = &s5pv210_fimc0_win0_link;
+	}
+}
diff --git a/arch/arm/mach-s5pv210/setup-fimc1.c b/arch/arm/mach-s5pv210/setup-fimc1.c
index bfaffe9..2a6e930 100644
--- a/arch/arm/mach-s5pv210/setup-fimc1.c
+++ b/arch/arm/mach-s5pv210/setup-fimc1.c
@@ -10,6 +10,10 @@
  */
 
 #include <plat/fimc.h>
+#include <plat/fifo.h>
+#include <linux/fb.h>
+#include <plat/fb.h>
+#include <plat/devs.h>
 
 struct samsung_plat_fimc s5p_fimc1_default_data __initdata = {
 	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
@@ -23,3 +27,22 @@ struct samsung_plat_fimc s5p_fimc1_default_data __initdata = {
 	.out_rot_en_w	= 1920,
 	.out_rot_dis_w	= 4224
 };
+
+static struct s3c_fifo_link s5pv210_fimc1_win1_link = {
+	.master_dev	= &s5p_device_fimc1.dev,
+	.slave_dev	= &s3c_device_fb.dev,
+};
+
+void __init s5pv210_setup_fimc1_fb_link(void)
+{
+	struct s3c_fb_platdata *fb_pd;
+	struct samsung_plat_fimc *fimc_pd;
+
+	fimc_pd = s5p_device_fimc1.dev.platform_data;
+	fb_pd = s3c_device_fb.dev.platform_data;
+
+	if (fimc_pd && fb_pd && fb_pd->win[1]) {
+		fb_pd->win[1]->fifo_sources[0] = &s5pv210_fimc1_win1_link;
+		fimc_pd->fifo_targets[0] = &s5pv210_fimc1_win1_link;
+	}
+}
diff --git a/arch/arm/mach-s5pv210/setup-fimc2.c b/arch/arm/mach-s5pv210/setup-fimc2.c
index a53a382..79b61b0 100644
--- a/arch/arm/mach-s5pv210/setup-fimc2.c
+++ b/arch/arm/mach-s5pv210/setup-fimc2.c
@@ -10,6 +10,10 @@
  */
 
 #include <plat/fimc.h>
+#include <plat/fifo.h>
+#include <linux/fb.h>
+#include <plat/fb.h>
+#include <plat/devs.h>
 
 struct samsung_plat_fimc s5p_fimc2_default_data __initdata = {
 	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
@@ -23,3 +27,22 @@ struct samsung_plat_fimc s5p_fimc2_default_data __initdata = {
 	.out_rot_en_w	= 1280,
 	.out_rot_dis_w	= 1920
 };
+
+static struct s3c_fifo_link s5pv210_fimc2_win2_link = {
+	.master_dev	= &s5p_device_fimc2.dev,
+	.slave_dev	= &s3c_device_fb.dev,
+};
+
+void __init s5pv210_setup_fimc2_fb_link(void)
+{
+	struct s3c_fb_platdata *fb_pd;
+	struct samsung_plat_fimc *fimc_pd;
+
+	fimc_pd = s5p_device_fimc2.dev.platform_data;
+	fb_pd = s3c_device_fb.dev.platform_data;
+
+	if (fimc_pd && fb_pd && fb_pd->win[2]) {
+		fb_pd->win[2]->fifo_sources[0] = &s5pv210_fimc2_win2_link;
+		fimc_pd->fifo_targets[0] = &s5pv210_fimc2_win2_link;
+	}
+}
diff --git a/arch/arm/plat-samsung/include/plat/fimc.h b/arch/arm/plat-samsung/include/plat/fimc.h
index bc6799e..8f95fc0 100644
--- a/arch/arm/plat-samsung/include/plat/fimc.h
+++ b/arch/arm/plat-samsung/include/plat/fimc.h
@@ -54,5 +54,9 @@ extern void s5p_fimc0_set_platdata(struct samsung_plat_fimc *fimc);
 extern void s5p_fimc1_set_platdata(struct samsung_plat_fimc *fimc);
 extern void s5p_fimc2_set_platdata(struct samsung_plat_fimc *fimc);
 
+extern void __init s5pv210_setup_fimc0_fb_link(void);
+extern void __init s5pv210_setup_fimc1_fb_link(void);
+extern void __init s5pv210_setup_fimc2_fb_link(void);
+
 #endif /* FIMC_H_ */
 
-- 
1.7.0.4


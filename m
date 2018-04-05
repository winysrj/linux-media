Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33590 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbeDERy1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH 05/16] media: fsl-viu: allow building it with COMPILE_TEST
Date: Thu,  5 Apr 2018 13:54:05 -0400
Message-Id: <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There aren't many things that would be needed to allow it
to build with compile test.

Add the needed bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/Kconfig   | 2 +-
 drivers/media/platform/fsl-viu.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 03c9dfeb7781..e6eb1eb776e1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -42,7 +42,7 @@ config VIDEO_SH_VOU
 
 config VIDEO_VIU
 	tristate "Freescale VIU Video Driver"
-	depends on VIDEO_V4L2 && PPC_MPC512x
+	depends on VIDEO_V4L2 && (PPC_MPC512x || COMPILE_TEST)
 	select VIDEOBUF_DMA_CONTIG
 	default y
 	---help---
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 9abe79779659..466053e00378 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -36,6 +36,14 @@
 #define DRV_NAME		"fsl_viu"
 #define VIU_VERSION		"0.5.1"
 
+/* Allow building this driver with COMPILE_TEST */
+#ifndef CONFIG_PPC_MPC512x
+#define NO_IRQ   0
+
+#define out_be32(v, a)	writel(a, v)
+#define in_be32(a) readl(a)
+#endif
+
 #define BUFFER_TIMEOUT		msecs_to_jiffies(500)  /* 0.5 seconds */
 
 #define	VIU_VID_MEM_LIMIT	4	/* Video memory limit, in Mb */
-- 
2.14.3

Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34414 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755792AbeDFOPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:15:45 -0400
Date: Fri, 6 Apr 2018 11:15:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Subject: Re: [PATCH 05/16] media: fsl-viu: allow building it with
 COMPILE_TEST
Message-ID: <20180406111537.04375bdf@vento.lan>
In-Reply-To: <CAK8P3a2FQapAqxOMJNe9oBs8kBXsd7TCdsNon5Gvab3Y8LLKSA@mail.gmail.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
        <CAK8P3a1a7r1FNhpRHJfyzRNHgNHOzcK1wkerYb+BR_RjWNkOUQ@mail.gmail.com>
        <20180406064718.2cdb69ea@vento.lan>
        <CAK8P3a2FQapAqxOMJNe9oBs8kBXsd7TCdsNon5Gvab3Y8LLKSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 Apr 2018 11:51:16 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Fri, Apr 6, 2018 at 11:47 AM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> 
> > [PATCH] media: fsl-viu: allow building it with COMPILE_TEST
> >
> > There aren't many things that would be needed to allow it
> > to build with compile test.
> >
> > Add the needed bits.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Actually, in order to avoid warnings with smatch, the COMPILE_TEST
macros should be declared as:

+#define out_be32(v, a)	iowrite32be(a, (void __iomem *)v)
+#define in_be32(a)	ioread32be((void __iomem *)a)

Thanks,
Mauro

[PATCH] media: fsl-viu: allow building it with COMPILE_TEST

There aren't many things that would be needed to allow it
to build with compile test.

Add the needed bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

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
index 9abe79779659..6fd1c8f66047 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -36,6 +36,12 @@
 #define DRV_NAME		"fsl_viu"
 #define VIU_VERSION		"0.5.1"
 
+/* Allow building this driver with COMPILE_TEST */
+#ifndef CONFIG_PPC
+#define out_be32(v, a)	iowrite32be(a, (void __iomem *)v)
+#define in_be32(a)	ioread32be((void __iomem *)a)
+#endif
+
 #define BUFFER_TIMEOUT		msecs_to_jiffies(500)  /* 0.5 seconds */
 
 #define	VIU_VID_MEM_LIMIT	4	/* Video memory limit, in Mb */
@@ -1407,7 +1413,7 @@ static int viu_of_probe(struct platform_device *op)
 	}
 
 	viu_irq = irq_of_parse_and_map(op->dev.of_node, 0);
-	if (viu_irq == NO_IRQ) {
+	if (!viu_irq) {
 		dev_err(&op->dev, "Error while mapping the irq\n");
 		return -EINVAL;
 	}

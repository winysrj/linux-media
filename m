Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34124 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756352AbeDFOX2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 04/21] media: davinci_vpfe: mark __iomem as such
Date: Fri,  6 Apr 2018 10:23:05 -0400
Message-Id: <12cab2f1324273f1db53b812fc78c7c54248b041.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several usages of an __iomem memory that aren't
marked as such, causing those warnings:

drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:201:27: warning: incorrect type in assignment (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:201:27:    expected void *ipipeif_base_addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:201:27:    got void [noderef] <asn:2>*ipipeif_base_addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    expected void const volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    expected void const volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:510:42: warning: incorrect type in initializer (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:510:42:    expected void *ipipeif_base_addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:510:42:    got void [noderef] <asn:2>*ipipeif_base_addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    expected void const volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:797:42: warning: incorrect type in initializer (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:797:42:    expected void *ipipeif_base_addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:797:42:    got void [noderef] <asn:2>*ipipeif_base_addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 46fd2c7f69c3..cf91f8842d35 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -66,17 +66,17 @@ ipipeif_get_pack_mode(u32 in_pix_fmt)
 	}
 }
 
-static inline u32 ipipeif_read(void *addr, u32 offset)
+static inline u32 ipipeif_read(void __iomem *addr, u32 offset)
 {
 	return readl(addr + offset);
 }
 
-static inline void ipipeif_write(u32 val, void *addr, u32 offset)
+static inline void ipipeif_write(u32 val, void __iomem *addr, u32 offset)
 {
 	writel(val, addr + offset);
 }
 
-static void ipipeif_config_dpc(void *addr, struct ipipeif_dpc *dpc)
+static void ipipeif_config_dpc(void __iomem *addr, struct ipipeif_dpc *dpc)
 {
 	u32 val = 0;
 
@@ -191,7 +191,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 	struct ipipeif_params params = ipipeif->config;
 	enum ipipeif_input_source ipipeif_source;
 	u32 isif_port_if;
-	void *ipipeif_base_addr;
+	void __iomem *ipipeif_base_addr;
 	unsigned int val;
 	int data_shift;
 	int pack_mode;
@@ -507,7 +507,7 @@ static int ipipeif_s_ctrl(struct v4l2_ctrl *ctrl)
 void vpfe_ipipeif_enable(struct vpfe_device *vpfe_dev)
 {
 	struct vpfe_ipipeif_device *ipipeif = &vpfe_dev->vpfe_ipipeif;
-	void *ipipeif_base_addr = ipipeif->ipipeif_base_addr;
+	void __iomem *ipipeif_base_addr = ipipeif->ipipeif_base_addr;
 	unsigned char val;
 
 	if (ipipeif->input != IPIPEIF_INPUT_MEMORY)
@@ -794,7 +794,7 @@ static int
 ipipeif_video_in_queue(struct vpfe_device *vpfe_dev, unsigned long addr)
 {
 	struct vpfe_ipipeif_device *ipipeif = &vpfe_dev->vpfe_ipipeif;
-	void *ipipeif_base_addr = ipipeif->ipipeif_base_addr;
+	void __iomem *ipipeif_base_addr = ipipeif->ipipeif_base_addr;
 	unsigned int adofs;
 	u32 val;
 
-- 
2.14.3

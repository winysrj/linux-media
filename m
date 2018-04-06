Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42984 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756739AbeDFOXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 12/21] media: isif: reorder a statement to match coding style
Date: Fri,  6 Apr 2018 10:23:13 -0400
Message-Id: <93ce8b5784eb29d228a1f0976fe4896cceafec4f.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On all places, we do:
	void <asn_ref> *foo;

Here, it is doing, instead:
	void * <asn_ref> foo;

That tricks static analyzers, making it see errors where
there's none. So, just reorder in order to cleanup those
warnings:

    drivers/media/platform/davinci/isif.c:1066:22: warning: incorrect type in assignment (different address spaces)
    drivers/media/platform/davinci/isif.c:1066:22:    expected void *[noderef] <asn:2>addr
    drivers/media/platform/davinci/isif.c:1066:22:    got void [noderef] <asn:2>*
    drivers/media/platform/davinci/isif.c:1074:44: warning: incorrect type in assignment (different address spaces)
    drivers/media/platform/davinci/isif.c:1074:44:    expected void [noderef] <asn:2>*static [toplevel] [assigned] base_addr
    drivers/media/platform/davinci/isif.c:1074:44:    got void *[noderef] <asn:2>addr
    drivers/media/platform/davinci/isif.c:1078:51: warning: incorrect type in assignment (different address spaces)
    drivers/media/platform/davinci/isif.c:1078:51:    expected void [noderef] <asn:2>*static [toplevel] [assigned] linear_tbl0_addr
    drivers/media/platform/davinci/isif.c:1078:51:    got void *[noderef] <asn:2>addr
    drivers/media/platform/davinci/isif.c:1082:51: warning: incorrect type in assignment (different address spaces)
    drivers/media/platform/davinci/isif.c:1082:51:    expected void [noderef] <asn:2>*static [toplevel] [assigned] linear_tbl1_addr
    drivers/media/platform/davinci/isif.c:1082:51:    got void *[noderef] <asn:2>addr
    drivers/media/platform/davinci/isif.c:1067:22: warning: dereference of noderef expression

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/isif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index b14caadcd0df..f924e76e2fbf 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1027,7 +1027,7 @@ static int isif_probe(struct platform_device *pdev)
 {
 	void (*setup_pinmux)(void);
 	struct resource	*res;
-	void *__iomem addr;
+	void __iomem *addr;
 	int status = 0, i;
 
 	/* Platform data holds setup_pinmux function ptr */
-- 
2.14.3
